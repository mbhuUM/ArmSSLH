; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

@val = global i64 3203383023, align 4096
@val2 = global i64 19088743, align 4096
@array = internal global [131072 x i8] zeroinitializer, align 2048
@array_ctx = global ptr null, align 8
@arr_context = global ptr null, align 2048
@val_context = global ptr null, align 2048
@val2_context = global ptr null, align 2048
@time1 = global i64 0, align 8
@time2 = global i64 0, align 8
@.str = private unnamed_addr constant [7 x i8] c"%3lld \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@secret_context = global ptr null, align 2048
@is_public_context = global ptr null, align 2048
@training_offset = global i64 0, align 8
@timestamp = external global i64, align 8
@llvm.used = appending global [1 x ptr] [ptr @victim_function], section "llvm.metadata"

; Function Attrs: noinline nounwind speculative_load_hardening ssp uwtable(sync)
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
  %12 = load i32, ptr %3, align 4
  %13 = icmp ne i32 %12, 0
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

; Function Attrs: noinline nounwind speculative_load_hardening ssp uwtable(sync)
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
  ret void
}

; Function Attrs: speculative_load_hardening
declare ptr @cache_remove_prepare(ptr noundef) #2

; Function Attrs: noinline nounwind speculative_load_hardening ssp uwtable(sync)
define void @leakValue(i32 noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i64, align 8
  store i32 %0, ptr %8, align 4
  store i32 0, ptr %9, align 4
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !8
  store i32 40, ptr %10, align 4
  br label %13

13:                                               ; preds = %26, %1
  %14 = load i32, ptr %10, align 4
  %15 = icmp sge i32 %14, 0
  br i1 %15, label %16, label %29

16:                                               ; preds = %13
  %17 = load i32, ptr %10, align 4
  %18 = icmp eq i32 %17, 0
  %19 = zext i1 %18 to i32
  %20 = mul nsw i32 %19, 10
  store i32 %20, ptr %11, align 4
  %21 = load ptr, ptr @arr_context, align 2048
  call void @cache_remove(ptr noundef %21)
  %22 = load ptr, ptr @val_context, align 2048
  call void @cache_remove(ptr noundef %22)
  %23 = load ptr, ptr @val2_context, align 2048
  call void @cache_remove(ptr noundef %23)
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !9
  %24 = load i32, ptr %8, align 4
  %25 = load i32, ptr %11, align 4
  call void @victim_function(i32 noundef %24, i32 noundef %25)
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !10
  br label %26

26:                                               ; preds = %16
  %27 = load i32, ptr %10, align 4
  %28 = add nsw i32 %27, -1
  store i32 %28, ptr %10, align 4
  br label %13, !llvm.loop !11

29:                                               ; preds = %13
  store ptr @val, ptr %2, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !12
  %30 = load i64, ptr @timestamp, align 8
  store i64 %30, ptr %3, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !13
  %31 = load ptr, ptr %2, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %31) #3, !srcloc !14
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !15
  %32 = load i64, ptr @timestamp, align 8
  store i64 %32, ptr %4, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !16
  %33 = load i64, ptr %4, align 8
  %34 = load i64, ptr %3, align 8
  %35 = sub i64 %33, %34
  store i64 %35, ptr @time1, align 8
  store ptr @val2, ptr %5, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !12
  %36 = load i64, ptr @timestamp, align 8
  store i64 %36, ptr %6, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !13
  %37 = load ptr, ptr %5, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %37) #3, !srcloc !14
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !15
  %38 = load i64, ptr @timestamp, align 8
  store i64 %38, ptr %7, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !16
  %39 = load i64, ptr %7, align 8
  %40 = load i64, ptr %6, align 8
  %41 = sub i64 %39, %40
  store i64 %41, ptr @time2, align 8
  ret void
}

; Function Attrs: speculative_load_hardening
declare void @cache_remove(ptr noundef) #2

; Function Attrs: noinline nounwind speculative_load_hardening ssp uwtable(sync)
define i32 @main(i32 noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca [32 x i64], align 8
  %9 = alloca [32 x i64], align 8
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  store ptr %1, ptr %5, align 8
  call void @timer_start()
  %13 = load ptr, ptr %5, align 8
  %14 = getelementptr inbounds ptr, ptr %13, i64 1
  %15 = load ptr, ptr %14, align 8
  %16 = call i32 @atoi(ptr noundef %15)
  store i32 %16, ptr %6, align 4
  store i32 0, ptr %7, align 4
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !17
  call void @setup()
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !18
  store i32 0, ptr %10, align 4
  br label %17

17:                                               ; preds = %30, %2
  %18 = load i32, ptr %10, align 4
  %19 = icmp slt i32 %18, 32
  br i1 %19, label %20, label %33

20:                                               ; preds = %17
  %21 = load i32, ptr %6, align 4
  call void @leakValue(i32 noundef %21)
  %22 = load i64, ptr @time1, align 8
  %23 = load i32, ptr %10, align 4
  %24 = sext i32 %23 to i64
  %25 = getelementptr inbounds [32 x i64], ptr %8, i64 0, i64 %24
  store i64 %22, ptr %25, align 8
  %26 = load i64, ptr @time2, align 8
  %27 = load i32, ptr %10, align 4
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds [32 x i64], ptr %9, i64 0, i64 %28
  store i64 %26, ptr %29, align 8
  br label %30

30:                                               ; preds = %20
  %31 = load i32, ptr %10, align 4
  %32 = add nsw i32 %31, 1
  store i32 %32, ptr %10, align 4
  br label %17, !llvm.loop !19

33:                                               ; preds = %17
  store i32 0, ptr %11, align 4
  br label %34

34:                                               ; preds = %43, %33
  %35 = load i32, ptr %11, align 4
  %36 = icmp slt i32 %35, 32
  br i1 %36, label %37, label %46

37:                                               ; preds = %34
  %38 = load i32, ptr %11, align 4
  %39 = sext i32 %38 to i64
  %40 = getelementptr inbounds [32 x i64], ptr %8, i64 0, i64 %39
  %41 = load i64, ptr %40, align 8
  %42 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %41)
  br label %43

43:                                               ; preds = %37
  %44 = load i32, ptr %11, align 4
  %45 = add nsw i32 %44, 1
  store i32 %45, ptr %11, align 4
  br label %34, !llvm.loop !20

46:                                               ; preds = %34
  %47 = call i32 (ptr, ...) @printf(ptr noundef @.str.1)
  store i32 0, ptr %12, align 4
  br label %48

48:                                               ; preds = %57, %46
  %49 = load i32, ptr %12, align 4
  %50 = icmp slt i32 %49, 32
  br i1 %50, label %51, label %60

51:                                               ; preds = %48
  %52 = load i32, ptr %12, align 4
  %53 = sext i32 %52 to i64
  %54 = getelementptr inbounds [32 x i64], ptr %9, i64 0, i64 %53
  %55 = load i64, ptr %54, align 8
  %56 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %55)
  br label %57

57:                                               ; preds = %51
  %58 = load i32, ptr %12, align 4
  %59 = add nsw i32 %58, 1
  store i32 %59, ptr %12, align 4
  br label %48, !llvm.loop !21

60:                                               ; preds = %48
  call void @timer_stop()
  %61 = load i32, ptr %3, align 4
  ret i32 %61
}

; Function Attrs: speculative_load_hardening
declare void @timer_start(...) #2

; Function Attrs: speculative_load_hardening
declare i32 @atoi(ptr noundef) #2

; Function Attrs: speculative_load_hardening
declare i32 @printf(ptr noundef, ...) #2

; Function Attrs: speculative_load_hardening
declare void @timer_stop(...) #2

attributes #0 = { noinline nounwind speculative_load_hardening ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { speculative_load_hardening "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 13, i32 1]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"clang version 17.0.6"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{i64 2151209037, i64 2151209046}
!9 = !{i64 2151209088, i64 2151209097}
!10 = !{i64 2151209136, i64 2151209145}
!11 = distinct !{!11, !7}
!12 = !{i64 2151169851, i64 2151169860}
!13 = !{i64 2151169919, i64 2151169928}
!14 = !{i64 2151169967}
!15 = !{i64 2151170050, i64 2151170059}
!16 = !{i64 2151170116, i64 2151170125}
!17 = !{i64 2151209184, i64 2151209193}
!18 = !{i64 2151209232, i64 2151209241}
!19 = distinct !{!19, !7}
!20 = distinct !{!20, !7}
!21 = distinct !{!21, !7}
