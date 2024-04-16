; ModuleID = 'counter_thread.c'
source_filename = "counter_thread.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@timers_active = global i32 0, align 4
@counter_thread = global ptr null, align 8
@timestamp = global i64 0, align 8

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @counter_thread_thread(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  call void asm sideeffect "LDR x10, [$0]\0Aloop:\0AADD x10, x10, #1\0ASTR x10, [$0]\0AB loop\0A", "r,~{x10},~{memory}"(ptr %3) #2, !srcloc !6
  ret ptr null
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @timer_start() #0 {
  %1 = load i32, ptr @timers_active, align 4
  %2 = add nsw i32 %1, 1
  store i32 %2, ptr @timers_active, align 4
  %3 = icmp ne i32 %1, 0
  br i1 %3, label %6, label %4

4:                                                ; preds = %0
  %5 = call i32 @pthread_create(ptr noundef @counter_thread, ptr noundef null, ptr noundef @counter_thread_thread, ptr noundef @timestamp)
  br label %6

6:                                                ; preds = %4, %0
  ret void
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @timer_stop() #0 {
  %1 = load i32, ptr @timers_active, align 4
  %2 = add nsw i32 %1, -1
  store i32 %2, ptr @timers_active, align 4
  %3 = icmp ne i32 %2, 0
  br i1 %3, label %7, label %4

4:                                                ; preds = %0
  %5 = load ptr, ptr @counter_thread, align 8
  %6 = call i32 @"\01_pthread_cancel"(ptr noundef %5)
  br label %7

7:                                                ; preds = %4, %0
  ret void
}

declare i32 @"\01_pthread_cancel"(ptr noundef) #1

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+complxnum,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+jsconv,+lse,+neon,+pauth,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+complxnum,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+jsconv,+lse,+neon,+pauth,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 14, i32 4]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"clang version 19.0.0git (https://github.com/llvm/llvm-project.git b074f25329501487e312b59e463a2d5f743090f8)"}
!6 = !{i64 258, i64 320, i64 381, i64 446, i64 513}
