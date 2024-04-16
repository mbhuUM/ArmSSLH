; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@val = global i64 3203383023, align 2048
@val2 = global i64 19088743, align 2048
@is_public = global i32 1, align 2048
@secret = global i32 -559039810, align 2048
@array = internal global [131072 x i8] zeroinitializer, align 2048
@array_ctx = global ptr null, align 8
@arr_context = global ptr null, align 2048
@val_context = global ptr null, align 2048
@val2_context = global ptr null, align 2048
@is_public_context = global ptr null, align 2048
@secret_context = global ptr null, align 2048
@.str = private unnamed_addr constant [7 x i8] c"%3lld \00", align 1
@training_offset = global i64 0, align 8
@timestamp = external global i64, align 8

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @victim_function(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca double, align 8
  %6 = alloca double, align 8
  store i32 %0, ptr %3, align 4
  store i32 %1, ptr %4, align 4
  %7 = load i32, ptr %4, align 4
  %8 = load i8, ptr getelementptr inbounds ([131072 x i8], ptr @array, i64 0, i64 1024), align 1024
  %9 = zext i8 %8 to i32
  %10 = icmp slt i32 %7, %9
  br i1 %10, label %11, label %17

11:                                               ; preds = %2
  %12 = load i32, ptr @secret, align 2048
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %14, label %15

14:                                               ; preds = %11
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %5, ptr align 1 @val, i64 8, i1 false)
  br label %16

15:                                               ; preds = %11
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %6, ptr align 1 @val2, i64 8, i1 false)
  br label %16

16:                                               ; preds = %15, %14
  br label %17

17:                                               ; preds = %16, %2
  ret void
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @setup() #0 {
  %1 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  br label %2

2:                                                ; preds = %10, %0
  %3 = load i32, ptr %1, align 4
  %4 = sext i32 %3 to i64
  %5 = icmp ult i64 %4, 131072
  br i1 %5, label %6, label %13

6:                                                ; preds = %2
  %7 = load i32, ptr %1, align 4
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds [131072 x i8], ptr @array, i64 0, i64 %8
  store i8 0, ptr %9, align 1
  br label %10

10:                                               ; preds = %6
  %11 = load i32, ptr %1, align 4
  %12 = add nsw i32 %11, 1
  store i32 %12, ptr %1, align 4
  br label %2, !llvm.loop !6

13:                                               ; preds = %2
  store i8 10, ptr getelementptr inbounds ([131072 x i8], ptr @array, i64 0, i64 1024), align 1024
  %14 = call ptr @cache_remove_prepare(ptr noundef getelementptr inbounds ([131072 x i8], ptr @array, i64 0, i64 1024))
  store ptr %14, ptr @arr_context, align 2048
  %15 = call ptr @cache_remove_prepare(ptr noundef @val)
  store ptr %15, ptr @val_context, align 2048
  %16 = call ptr @cache_remove_prepare(ptr noundef @val2)
  store ptr %16, ptr @val2_context, align 2048
  %17 = call ptr @cache_remove_prepare(ptr noundef @is_public)
  store ptr %17, ptr @is_public_context, align 2048
  %18 = call ptr @cache_remove_prepare(ptr noundef @secret)
  store ptr %18, ptr @secret_context, align 2048
  ret void
}

declare ptr @cache_remove_prepare(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @leakValue() #0 {
  %1 = alloca ptr, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  store i32 0, ptr %4, align 4
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !8
  store i32 40, ptr %5, align 4
  br label %8

8:                                                ; preds = %22, %0
  %9 = load i32, ptr %5, align 4
  %10 = icmp sge i32 %9, 0
  br i1 %10, label %11, label %25

11:                                               ; preds = %8
  %12 = load i32, ptr %5, align 4
  %13 = icmp eq i32 %12, 0
  %14 = zext i1 %13 to i32
  %15 = mul nsw i32 %14, 10
  store i32 %15, ptr %6, align 4
  %16 = load ptr, ptr @arr_context, align 2048
  call void @cache_remove(ptr noundef %16)
  %17 = load ptr, ptr @val_context, align 2048
  call void @cache_remove(ptr noundef %17)
  %18 = load ptr, ptr @val2_context, align 2048
  call void @cache_remove(ptr noundef %18)
  %19 = load ptr, ptr @is_public_context, align 2048
  call void @cache_remove(ptr noundef %19)
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !9
  %20 = load i32, ptr @secret, align 2048
  %21 = load i32, ptr %6, align 4
  call void @victim_function(i32 noundef %20, i32 noundef %21)
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !10
  br label %22

22:                                               ; preds = %11
  %23 = load i32, ptr %5, align 4
  %24 = add nsw i32 %23, -1
  store i32 %24, ptr %5, align 4
  br label %8, !llvm.loop !11

25:                                               ; preds = %8
  store ptr @val, ptr %1, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !12
  %26 = load i64, ptr @timestamp, align 8
  store i64 %26, ptr %2, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !13
  %27 = load ptr, ptr %1, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %27) #3, !srcloc !14
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !15
  %28 = load i64, ptr @timestamp, align 8
  store i64 %28, ptr %3, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !16
  %29 = load i64, ptr %3, align 8
  %30 = load i64, ptr %2, align 8
  %31 = sub i64 %29, %30
  store i64 %31, ptr %7, align 8
  %32 = load i64, ptr %7, align 8
  %33 = load i32, ptr %4, align 4
  %34 = sext i32 %33 to i64
  %35 = add i64 %34, %32
  %36 = trunc i64 %35 to i32
  store i32 %36, ptr %4, align 4
  %37 = load i32, ptr %4, align 4
  ret i32 %37
}

declare void @cache_remove(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main(i32 noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i64, align 8
  store i32 %0, ptr %3, align 4
  store ptr %1, ptr %4, align 8
  call void @timer_start()
  %7 = load ptr, ptr %4, align 8
  %8 = getelementptr inbounds ptr, ptr %7, i64 1
  %9 = load ptr, ptr %8, align 8
  %10 = call i32 @atoi(ptr noundef %9)
  store i32 %10, ptr @secret, align 2048
  store i32 0, ptr %5, align 4
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !17
  call void @setup()
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !18
  %11 = call i32 @leakValue()
  %12 = sext i32 %11 to i64
  store i64 %12, ptr %6, align 8
  %13 = load i64, ptr %6, align 8
  %14 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %13)
  call void @timer_stop()
  ret i32 0
}

declare void @timer_start(...) #2

declare i32 @atoi(ptr noundef) #2

declare i32 @printf(ptr noundef, ...) #2

declare void @timer_stop(...) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+complxnum,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+jsconv,+lse,+neon,+pauth,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+complxnum,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+jsconv,+lse,+neon,+pauth,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 14, i32 4]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"clang version 19.0.0git (https://github.com/llvm/llvm-project.git b074f25329501487e312b59e463a2d5f743090f8)"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{i64 2151270419, i64 2151270428}
!9 = !{i64 2151270470, i64 2151270479}
!10 = !{i64 2151270518, i64 2151270527}
!11 = distinct !{!11, !7}
!12 = !{i64 2151231245, i64 2151231254}
!13 = !{i64 2151231313, i64 2151231322}
!14 = !{i64 2151231361}
!15 = !{i64 2151231444, i64 2151231453}
!16 = !{i64 2151231510, i64 2151231519}
!17 = !{i64 2151270566, i64 2151270575}
!18 = !{i64 2151270614, i64 2151270623}
