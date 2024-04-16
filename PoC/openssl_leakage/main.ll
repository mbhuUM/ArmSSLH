; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

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
define i32 @leakValue(i32 noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i64, align 8
  store i32 %0, ptr %5, align 4
  store i32 0, ptr %6, align 4
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #4, !srcloc !8
  store i32 40, ptr %7, align 4
  br label %10

10:                                               ; preds = %24, %1
  %11 = load i32, ptr %7, align 4
  %12 = icmp sge i32 %11, 0
  br i1 %12, label %13, label %27

13:                                               ; preds = %10
  %14 = load i32, ptr %7, align 4
  %15 = icmp eq i32 %14, 0
  %16 = zext i1 %15 to i32
  %17 = mul nsw i32 %16, 10
  store i32 %17, ptr %8, align 4
  %18 = load ptr, ptr @arr_context, align 2048
  call void @cache_remove(ptr noundef %18)
  %19 = load ptr, ptr @val_context, align 2048
  call void @cache_remove(ptr noundef %19)
  %20 = load ptr, ptr @val2_context, align 2048
  call void @cache_remove(ptr noundef %20)
  %21 = load ptr, ptr @is_public_context, align 2048
  call void @cache_remove(ptr noundef %21)
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #4, !srcloc !9
  %22 = load i32, ptr @secret, align 2048
  %23 = load i32, ptr %8, align 4
  call void @victim_function(i32 noundef %22, i32 noundef %23)
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #4, !srcloc !10
  br label %24

24:                                               ; preds = %13
  %25 = load i32, ptr %7, align 4
  %26 = add nsw i32 %25, -1
  store i32 %26, ptr %7, align 4
  br label %10, !llvm.loop !11

27:                                               ; preds = %10
  store ptr @val, ptr %2, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #4, !srcloc !12
  %28 = load i64, ptr @timestamp, align 8
  store i64 %28, ptr %3, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #4, !srcloc !13
  %29 = load ptr, ptr %2, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %29) #4, !srcloc !14
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #4, !srcloc !15
  %30 = load i64, ptr @timestamp, align 8
  store i64 %30, ptr %4, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #4, !srcloc !16
  %31 = load i64, ptr %4, align 8
  %32 = load i64, ptr %3, align 8
  %33 = sub i64 %31, %32
  store i64 %33, ptr %9, align 8
  %34 = load i64, ptr %9, align 8
  %35 = load i32, ptr %6, align 4
  %36 = sext i32 %35 to i64
  %37 = add i64 %36, %34
  %38 = trunc i64 %37 to i32
  store i32 %38, ptr %6, align 4
  %39 = load i32, ptr %6, align 4
  ret i32 %39
}

declare void @cache_remove(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main(i32 noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca [32 x i64], align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  store ptr %1, ptr %5, align 8
  call void @timer_start()
  %10 = load ptr, ptr %5, align 8
  %11 = getelementptr inbounds ptr, ptr %10, i64 1
  %12 = load ptr, ptr %11, align 8
  %13 = call i32 @atoi(ptr noundef %12)
  store i32 %13, ptr @secret, align 2048
  store i32 0, ptr %6, align 4
  call void @llvm.memset.p0.i64(ptr align 8 %7, i8 0, i64 256, i1 false)
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #4, !srcloc !17
  call void @setup()
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #4, !srcloc !18
  store volatile i32 0, ptr %8, align 4
  br label %14

14:                                               ; preds = %24, %2
  %15 = load volatile i32, ptr %8, align 4
  %16 = icmp slt i32 %15, 32
  br i1 %16, label %17, label %27

17:                                               ; preds = %14
  %18 = load volatile i32, ptr %8, align 4
  %19 = call i32 @leakValue(i32 noundef %18)
  %20 = sext i32 %19 to i64
  %21 = load volatile i32, ptr %8, align 4
  %22 = sext i32 %21 to i64
  %23 = getelementptr inbounds [32 x i64], ptr %7, i64 0, i64 %22
  store i64 %20, ptr %23, align 8
  br label %24

24:                                               ; preds = %17
  %25 = load volatile i32, ptr %8, align 4
  %26 = add nsw i32 %25, 1
  store volatile i32 %26, ptr %8, align 4
  br label %14, !llvm.loop !19

27:                                               ; preds = %14
  store i32 0, ptr %9, align 4
  br label %28

28:                                               ; preds = %37, %27
  %29 = load i32, ptr %9, align 4
  %30 = icmp slt i32 %29, 32
  br i1 %30, label %31, label %40

31:                                               ; preds = %28
  %32 = load i32, ptr %9, align 4
  %33 = sext i32 %32 to i64
  %34 = getelementptr inbounds [32 x i64], ptr %7, i64 0, i64 %33
  %35 = load i64, ptr %34, align 8
  %36 = call i32 (ptr, ...) @printf(ptr noundef @.str, i64 noundef %35)
  br label %37

37:                                               ; preds = %31
  %38 = load i32, ptr %9, align 4
  %39 = add nsw i32 %38, 1
  store i32 %39, ptr %9, align 4
  br label %28, !llvm.loop !20

40:                                               ; preds = %28
  call void @timer_stop()
  %41 = load i32, ptr %3, align 4
  ret i32 %41
}

declare void @timer_start(...) #2

declare i32 @atoi(ptr noundef) #2

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #3

declare i32 @printf(ptr noundef, ...) #2

declare void @timer_stop(...) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #4 = { nounwind }

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
!8 = !{i64 2151209461, i64 2151209470}
!9 = !{i64 2151209512, i64 2151209521}
!10 = !{i64 2151209560, i64 2151209569}
!11 = distinct !{!11, !7}
!12 = !{i64 2151170275, i64 2151170284}
!13 = !{i64 2151170343, i64 2151170352}
!14 = !{i64 2151170391}
!15 = !{i64 2151170474, i64 2151170483}
!16 = !{i64 2151170540, i64 2151170549}
!17 = !{i64 2151209608, i64 2151209617}
!18 = !{i64 2151209656, i64 2151209665}
!19 = distinct !{!19, !7}
!20 = distinct !{!20, !7}
