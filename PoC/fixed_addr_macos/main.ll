; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

@val = global i64 3203383023, align 4096
@val2 = global i64 19088743, align 4096
@secret = global i32 -559039810, align 2048
@array = internal global [131072 x i8] zeroinitializer, align 2048
@tmp2 = global i64 0, align 8
@tmp3 = global i64 0, align 8
@array_ctx = global ptr null, align 8
@arr_context = global ptr null, align 2048
@val_context = global ptr null, align 2048
@val2_context = global ptr null, align 2048
@secret_context = global ptr null, align 2048
@time1 = global i64 0, align 8
@time2 = global i64 0, align 8
@.str = private unnamed_addr constant [7 x i8] c"%3lld \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"%d, %d\00", align 1
@is_public_context = global ptr null, align 2048
@training_offset = global i64 0, align 8
@timestamp = external global i64, align 8
@llvm.used = appending global [1 x ptr] [ptr @victim_function], section "llvm.metadata"

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @victim_function(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  store i32 %1, ptr %4, align 4
  %5 = load i32, ptr %4, align 4
  %6 = load i8, ptr getelementptr inbounds ([131072 x i8], ptr @array, i64 0, i64 1024), align 1024
  %7 = zext i8 %6 to i32
  %8 = icmp slt i32 %5, %7
  br i1 %8, label %9, label %15

9:                                                ; preds = %2
  %10 = load i32, ptr %3, align 4
  %11 = icmp ne i32 %10, 0
  br i1 %11, label %12, label %13

12:                                               ; preds = %9
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 @tmp2, ptr align 1 @val, i64 8, i1 false)
  br label %14

13:                                               ; preds = %9
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 @tmp3, ptr align 1 @val2, i64 8, i1 false)
  br label %14

14:                                               ; preds = %13, %12
  br label %15

15:                                               ; preds = %14, %2
  ret i32 0
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
  %17 = call ptr @cache_remove_prepare(ptr noundef @secret)
  store ptr %17, ptr @secret_context, align 2048
  ret void
}

declare ptr @cache_remove_prepare(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @leakValue() #0 {
  %1 = alloca ptr, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i64, align 8
  store i32 0, ptr %7, align 4
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !8
  store i32 40, ptr %8, align 4
  br label %11

11:                                               ; preds = %25, %0
  %12 = load i32, ptr %8, align 4
  %13 = icmp sge i32 %12, 0
  br i1 %13, label %14, label %28

14:                                               ; preds = %11
  %15 = load i32, ptr %8, align 4
  %16 = icmp eq i32 %15, 0
  %17 = zext i1 %16 to i32
  %18 = mul nsw i32 %17, 10
  store i32 %18, ptr %9, align 4
  %19 = load ptr, ptr @arr_context, align 2048
  call void @cache_remove(ptr noundef %19)
  %20 = load ptr, ptr @val_context, align 2048
  call void @cache_remove(ptr noundef %20)
  %21 = load ptr, ptr @val2_context, align 2048
  call void @cache_remove(ptr noundef %21)
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !9
  %22 = load i32, ptr @secret, align 2048
  %23 = load i32, ptr %9, align 4
  %24 = call i32 @victim_function(i32 noundef %22, i32 noundef %23)
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !10
  br label %25

25:                                               ; preds = %14
  %26 = load i32, ptr %8, align 4
  %27 = add nsw i32 %26, -1
  store i32 %27, ptr %8, align 4
  br label %11, !llvm.loop !11

28:                                               ; preds = %11
  store ptr @val, ptr %1, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !12
  %29 = load i64, ptr @timestamp, align 8
  store i64 %29, ptr %2, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !13
  %30 = load ptr, ptr %1, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %30) #3, !srcloc !14
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !15
  %31 = load i64, ptr @timestamp, align 8
  store i64 %31, ptr %3, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !16
  %32 = load i64, ptr %3, align 8
  %33 = load i64, ptr %2, align 8
  %34 = sub i64 %32, %33
  store i64 %34, ptr @time1, align 8
  store ptr @val2, ptr %4, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !12
  %35 = load i64, ptr @timestamp, align 8
  store i64 %35, ptr %5, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !13
  %36 = load ptr, ptr %4, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %36) #3, !srcloc !14
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !15
  %37 = load i64, ptr @timestamp, align 8
  store i64 %37, ptr %6, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !16
  %38 = load i64, ptr %6, align 8
  %39 = load i64, ptr %5, align 8
  %40 = sub i64 %38, %39
  store i64 %40, ptr @time2, align 8
  ret void
}

declare void @cache_remove(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main(i32 noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca [32 x i64], align 8
  %8 = alloca [32 x i64], align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  store ptr %1, ptr %5, align 8
  call void @timer_start()
  %12 = load ptr, ptr %5, align 8
  %13 = getelementptr inbounds ptr, ptr %12, i64 1
  %14 = load ptr, ptr %13, align 8
  %15 = call i32 @atoi(ptr noundef %14)
  store i32 %15, ptr @secret, align 2048
  store i32 0, ptr %6, align 4
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !17
  call void @setup()
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #3, !srcloc !18
  store i32 0, ptr %9, align 4
  br label %16

16:                                               ; preds = %28, %2
  %17 = load i32, ptr %9, align 4
  %18 = icmp slt i32 %17, 32
  br i1 %18, label %19, label %31

19:                                               ; preds = %16
  call void @leakValue()
  %20 = load i64, ptr @time1, align 8
  %21 = load i32, ptr %9, align 4
  %22 = sext i32 %21 to i64
  %23 = getelementptr inbounds [32 x i64], ptr %7, i64 0, i64 %22
  store i64 %20, ptr %23, align 8
  %24 = load i64, ptr @time2, align 8
  %25 = load i32, ptr %9, align 4
  %26 = sext i32 %25 to i64
  %27 = getelementptr inbounds [32 x i64], ptr %8, i64 0, i64 %26
  store i64 %24, ptr %27, align 8
  br label %28

28:                                               ; preds = %19
  %29 = load i32, ptr %9, align 4
  %30 = add nsw i32 %29, 1
  store i32 %30, ptr %9, align 4
  br label %16, !llvm.loop !19

31:                                               ; preds = %16
  store i32 0, ptr %10, align 4
  br label %32

32:                                               ; preds = %41, %31
  %33 = load i32, ptr %10, align 4
  %34 = icmp slt i32 %33, 32
  br i1 %34, label %35, label %44

35:                                               ; preds = %32
  %36 = load i32, ptr %10, align 4
  %37 = sext i32 %36 to i64
  %38 = getelementptr inbounds [32 x i64], ptr %7, i64 0, i64 %37
  %39 = load i64, ptr %38, align 8
  %40 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %39)
  br label %41

41:                                               ; preds = %35
  %42 = load i32, ptr %10, align 4
  %43 = add nsw i32 %42, 1
  store i32 %43, ptr %10, align 4
  br label %32, !llvm.loop !20

44:                                               ; preds = %32
  %45 = call i32 (ptr, ...) @printf(ptr noundef @.str.1)
  store i32 0, ptr %11, align 4
  br label %46

46:                                               ; preds = %55, %44
  %47 = load i32, ptr %11, align 4
  %48 = icmp slt i32 %47, 32
  br i1 %48, label %49, label %58

49:                                               ; preds = %46
  %50 = load i32, ptr %11, align 4
  %51 = sext i32 %50 to i64
  %52 = getelementptr inbounds [32 x i64], ptr %8, i64 0, i64 %51
  %53 = load i64, ptr %52, align 8
  %54 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %53)
  br label %55

55:                                               ; preds = %49
  %56 = load i32, ptr %11, align 4
  %57 = add nsw i32 %56, 1
  store i32 %57, ptr %11, align 4
  br label %46, !llvm.loop !21

58:                                               ; preds = %46
  call void @timer_stop()
  %59 = load i64, ptr @tmp2, align 8
  %60 = load i64, ptr @tmp3, align 8
  %61 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i64 noundef %59, i64 noundef %60)
  %62 = load i32, ptr %3, align 4
  ret i32 %62
}

declare void @timer_start(...) #2

declare i32 @atoi(ptr noundef) #2

declare i32 @printf(ptr noundef, ...) #2

declare void @timer_stop(...) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 13, i32 1]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"clang version 17.0.6 (https://github.com/llvm/llvm-project.git 6009708b4367171ccdbf4b5905cb6a803753fe18)"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{i64 2151209284, i64 2151209293}
!9 = !{i64 2151209335, i64 2151209344}
!10 = !{i64 2151209383, i64 2151209392}
!11 = distinct !{!11, !7}
!12 = !{i64 2151170098, i64 2151170107}
!13 = !{i64 2151170166, i64 2151170175}
!14 = !{i64 2151170214}
!15 = !{i64 2151170297, i64 2151170306}
!16 = !{i64 2151170363, i64 2151170372}
!17 = !{i64 2151209431, i64 2151209440}
!18 = !{i64 2151209479, i64 2151209488}
!19 = distinct !{!19, !7}
!20 = distinct !{!20, !7}
!21 = distinct !{!21, !7}
