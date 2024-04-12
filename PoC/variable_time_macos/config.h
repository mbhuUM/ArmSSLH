#ifndef CONFIG_H
#define CONFIG_H

/* --- Constants --- */
#define EVICTION 0
#define FLUSHING 1
#define MSR 0
#define COUNTER_THREAD 1


/* --- Generic --- */
#define VERBOSITY 0
#define CACHE EVICTION
#define TIMER COUNTER_THREAD
#define PAGE_SIZE 16384


/* --- Eviction --- */
#define EVICTION_THRESHOLD 220 /* use calibration */
#define EVICTION_SET_SIZE 32
#define EVICTION_MEMORY_SIZE 20 * 1024 * 1024

/* --- Spectre --- */
#define VARIANT 1 /* 1 or 2 */
#define BITS 2
#define ENTRY_SIZE 512
#define ITERATIONS 4
#define VICTIM_CALLS 40
#define TRAINING 9
#define THRESHOLD 220
#define BENCHMARK 0

/* --- Calculated automatically --- */
#define OFFSETS_PER_BYTE (8 / BITS)
#define VALUES (1 << BITS)

/* --- Mitigation --- */
#define MITIGATION_ASM
#define MITIGATION

#endif
