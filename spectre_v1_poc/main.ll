; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

%struct.timeval = type { i64, i32 }

@parity = global [256 x i8] c"\00\01\01\02\01\02\02\03\01\02\02\03\02\03\03\04\01\02\02\03\02\03\03\04\02\03\03\04\03\04\04\05\01\02\02\03\02\03\03\04\02\03\03\04\03\04\04\05\02\03\03\04\03\04\04\05\03\04\04\05\04\05\05\06\01\02\02\03\02\03\03\04\02\03\03\04\03\04\04\05\02\03\03\04\03\04\04\05\03\04\04\05\04\05\05\06\02\03\03\04\03\04\04\05\03\04\04\05\04\05\05\06\03\04\04\05\04\05\05\06\04\05\05\06\05\06\06\07\01\02\02\03\02\03\03\04\02\03\03\04\03\04\04\05\02\03\03\04\03\04\04\05\03\04\04\05\04\05\05\06\02\03\03\04\03\04\04\05\03\04\04\05\04\05\05\06\03\04\04\05\04\05\05\06\04\05\05\06\05\06\06\07\02\03\03\04\03\04\04\05\03\04\04\05\04\05\05\06\03\04\04\05\04\05\05\06\04\05\05\06\05\06\06\07\03\04\04\05\04\05\05\06\04\05\05\06\05\06\06\07\04\05\05\06\05\06\06\07\05\06\06\07\06\07\07\08", align 1
@.str = private unnamed_addr constant [73 x i8] c"leaked %d byte in %d ms. (%.2f bytes/s) correct: %d / %d bits (%.2f %%)\0A\00", align 1
@.str.1 = private unnamed_addr constant [20 x i8] c"setup took: %d ms.\0A\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"[Spectre Variant %d]\0A\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"ABC\00", align 1
@.str.4 = private unnamed_addr constant [26 x i8] c"S3cret P4ssword, really!!\00", align 1
@.str.5 = private unnamed_addr constant [18 x i8] c" ---- SETUP ---- \00", align 1
@__stdoutp = external global ptr, align 8
@.str.6 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.7 = private unnamed_addr constant [19 x i8] c" ---- LEAKING ----\00", align 1
@.str.8 = private unnamed_addr constant [18 x i8] c" ---- RESULT ----\00", align 1
@.str.9 = private unnamed_addr constant [44 x i8] c"leaked %d bytes in %dms. (%.2f bytes / sec)\00", align 1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @benchmark() #0 {
  %1 = alloca %struct.timeval, align 8
  %2 = alloca %struct.timeval, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca [5 x i8], align 1
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store i32 10240, ptr %4, align 4
  %15 = call ptr @malloc(i64 noundef 1024) #3
  store ptr %15, ptr %6, align 8
  store i32 0, ptr %7, align 4
  br label %16

16:                                               ; preds = %24, %0
  %17 = load i32, ptr %7, align 4
  %18 = icmp slt i32 %17, 1024
  br i1 %18, label %19, label %27

19:                                               ; preds = %16
  %20 = load ptr, ptr %6, align 8
  %21 = load i32, ptr %7, align 4
  %22 = sext i32 %21 to i64
  %23 = getelementptr inbounds i8, ptr %20, i64 %22
  store i8 65, ptr %23, align 1
  br label %24

24:                                               ; preds = %19
  %25 = load i32, ptr %7, align 4
  %26 = add nsw i32 %25, 1
  store i32 %26, ptr %7, align 4
  br label %16, !llvm.loop !6

27:                                               ; preds = %16
  %28 = load ptr, ptr %6, align 8
  %29 = getelementptr inbounds i8, ptr %28, i64 1023
  store i8 0, ptr %29, align 1
  store i32 0, ptr %8, align 4
  br label %30

30:                                               ; preds = %37, %27
  %31 = load i32, ptr %8, align 4
  %32 = icmp slt i32 %31, 5
  br i1 %32, label %33, label %40

33:                                               ; preds = %30
  %34 = load i32, ptr %8, align 4
  %35 = sext i32 %34 to i64
  %36 = getelementptr inbounds [5 x i8], ptr %5, i64 0, i64 %35
  store i8 113, ptr %36, align 1
  br label %37

37:                                               ; preds = %33
  %38 = load i32, ptr %8, align 4
  %39 = add nsw i32 %38, 1
  store i32 %39, ptr %8, align 4
  br label %30, !llvm.loop !8

40:                                               ; preds = %30
  %41 = getelementptr inbounds [5 x i8], ptr %5, i64 0, i64 4
  store i8 0, ptr %41, align 1
  %42 = call i32 @gettimeofday(ptr noundef %1, ptr noundef null)
  %43 = load ptr, ptr %6, align 8
  %44 = getelementptr inbounds [5 x i8], ptr %5, i64 0, i64 0
  %45 = call i32 @setup(ptr noundef %43, ptr noundef %44)
  %46 = call i32 @gettimeofday(ptr noundef %2, ptr noundef null)
  %47 = getelementptr inbounds %struct.timeval, ptr %2, i32 0, i32 0
  %48 = load i64, ptr %47, align 8
  %49 = getelementptr inbounds %struct.timeval, ptr %1, i32 0, i32 0
  %50 = load i64, ptr %49, align 8
  %51 = sub nsw i64 %48, %50
  %52 = mul nsw i64 %51, 1000
  %53 = getelementptr inbounds %struct.timeval, ptr %2, i32 0, i32 1
  %54 = load i32, ptr %53, align 8
  %55 = getelementptr inbounds %struct.timeval, ptr %1, i32 0, i32 1
  %56 = load i32, ptr %55, align 8
  %57 = sub nsw i32 %54, %56
  %58 = sdiv i32 %57, 1000
  %59 = sext i32 %58 to i64
  %60 = add nsw i64 %52, %59
  %61 = trunc i64 %60 to i32
  store i32 %61, ptr %9, align 4
  %62 = load ptr, ptr %6, align 8
  %63 = call i64 @strlen(ptr noundef %62)
  %64 = add i64 %63, 1
  %65 = trunc i64 %64 to i32
  store i32 %65, ptr %10, align 4
  %66 = call i32 @gettimeofday(ptr noundef %1, ptr noundef null)
  store i32 0, ptr %11, align 4
  br label %67

67:                                               ; preds = %95, %40
  %68 = load i32, ptr %11, align 4
  %69 = load i32, ptr %4, align 4
  %70 = sdiv i32 %69, 4
  %71 = icmp slt i32 %68, %70
  br i1 %71, label %72, label %98

72:                                               ; preds = %67
  store i32 0, ptr %12, align 4
  br label %73

73:                                               ; preds = %91, %72
  %74 = load i32, ptr %12, align 4
  %75 = icmp slt i32 %74, 4
  br i1 %75, label %76, label %94

76:                                               ; preds = %73
  %77 = load i32, ptr %10, align 4
  %78 = load i32, ptr %12, align 4
  %79 = add nsw i32 %77, %78
  %80 = sext i32 %79 to i64
  %81 = call i32 @leakByte(i64 noundef %80)
  store i32 %81, ptr %13, align 4
  %82 = load i32, ptr %13, align 4
  %83 = xor i32 113, %82
  %84 = sext i32 %83 to i64
  %85 = getelementptr inbounds [256 x i8], ptr @parity, i64 0, i64 %84
  %86 = load i8, ptr %85, align 1
  %87 = sext i8 %86 to i32
  %88 = sub nsw i32 8, %87
  %89 = load i32, ptr %3, align 4
  %90 = add nsw i32 %89, %88
  store i32 %90, ptr %3, align 4
  br label %91

91:                                               ; preds = %76
  %92 = load i32, ptr %12, align 4
  %93 = add nsw i32 %92, 1
  store i32 %93, ptr %12, align 4
  br label %73, !llvm.loop !9

94:                                               ; preds = %73
  br label %95

95:                                               ; preds = %94
  %96 = load i32, ptr %11, align 4
  %97 = add nsw i32 %96, 1
  store i32 %97, ptr %11, align 4
  br label %67, !llvm.loop !10

98:                                               ; preds = %67
  %99 = call i32 @gettimeofday(ptr noundef %2, ptr noundef null)
  %100 = getelementptr inbounds %struct.timeval, ptr %2, i32 0, i32 0
  %101 = load i64, ptr %100, align 8
  %102 = getelementptr inbounds %struct.timeval, ptr %1, i32 0, i32 0
  %103 = load i64, ptr %102, align 8
  %104 = sub nsw i64 %101, %103
  %105 = mul nsw i64 %104, 1000
  %106 = getelementptr inbounds %struct.timeval, ptr %2, i32 0, i32 1
  %107 = load i32, ptr %106, align 8
  %108 = getelementptr inbounds %struct.timeval, ptr %1, i32 0, i32 1
  %109 = load i32, ptr %108, align 8
  %110 = sub nsw i32 %107, %109
  %111 = sdiv i32 %110, 1000
  %112 = sext i32 %111 to i64
  %113 = add nsw i64 %105, %112
  %114 = trunc i64 %113 to i32
  store i32 %114, ptr %14, align 4
  %115 = load i32, ptr %4, align 4
  %116 = load i32, ptr %14, align 4
  %117 = load i32, ptr %4, align 4
  %118 = sitofp i32 %117 to double
  %119 = fmul double 1.000000e+03, %118
  %120 = load i32, ptr %14, align 4
  %121 = sitofp i32 %120 to double
  %122 = fdiv double %119, %121
  %123 = load i32, ptr %3, align 4
  %124 = load i32, ptr %4, align 4
  %125 = mul nsw i32 %124, 8
  %126 = load i32, ptr %3, align 4
  %127 = sitofp i32 %126 to double
  %128 = fmul double %127, 1.250000e+01
  %129 = load i32, ptr %4, align 4
  %130 = sitofp i32 %129 to double
  %131 = fdiv double %128, %130
  %132 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %115, i32 noundef %116, double noundef %122, i32 noundef %123, i32 noundef %125, double noundef %131)
  %133 = load i32, ptr %9, align 4
  %134 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %133)
  %135 = load ptr, ptr %6, align 8
  call void @free(ptr noundef %135)
  ret void
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

declare i32 @gettimeofday(ptr noundef, ptr noundef) #2

declare i32 @setup(ptr noundef, ptr noundef) #2

declare i64 @strlen(ptr noundef) #2

declare i32 @leakByte(i64 noundef) #2

declare i32 @printf(ptr noundef, ...) #2

declare void @free(ptr noundef) #2

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @main(i32 noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca ptr, align 8
  %11 = alloca %struct.timeval, align 8
  %12 = alloca %struct.timeval, align 8
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  store ptr %1, ptr %5, align 8
  call void @timer_start()
  %16 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef 1)
  store ptr @.str.3, ptr %6, align 8
  store ptr @.str.4, ptr %7, align 8
  %17 = load ptr, ptr %7, align 8
  %18 = call i64 @strlen(ptr noundef %17)
  %19 = trunc i64 %18 to i32
  store i32 %19, ptr %8, align 4
  %20 = load ptr, ptr %6, align 8
  %21 = call i64 @strlen(ptr noundef %20)
  %22 = add i64 %21, 1
  %23 = trunc i64 %22 to i32
  store i32 %23, ptr %9, align 4
  %24 = load i32, ptr %8, align 4
  %25 = sext i32 %24 to i64
  %26 = call ptr @malloc(i64 noundef %25) #3
  store ptr %26, ptr %10, align 8
  %27 = call i32 @puts(ptr noundef @.str.5)
  %28 = load ptr, ptr @__stdoutp, align 8
  %29 = call i32 @fflush(ptr noundef %28)
  %30 = load ptr, ptr %6, align 8
  %31 = load ptr, ptr %7, align 8
  %32 = call i32 @setup(ptr noundef %30, ptr noundef %31)
  %33 = call i32 @puts(ptr noundef @.str.6)
  %34 = call i32 @puts(ptr noundef @.str.7)
  %35 = load ptr, ptr @__stdoutp, align 8
  %36 = call i32 @fflush(ptr noundef %35)
  %37 = call i32 @gettimeofday(ptr noundef %11, ptr noundef null)
  store i32 0, ptr %14, align 4
  br label %38

38:                                               ; preds = %53, %2
  %39 = load i32, ptr %14, align 4
  %40 = load i32, ptr %8, align 4
  %41 = icmp slt i32 %39, %40
  br i1 %41, label %42, label %56

42:                                               ; preds = %38
  %43 = load i32, ptr %9, align 4
  %44 = load i32, ptr %14, align 4
  %45 = add nsw i32 %43, %44
  %46 = sext i32 %45 to i64
  %47 = call i32 @leakByte(i64 noundef %46)
  %48 = trunc i32 %47 to i8
  %49 = load ptr, ptr %10, align 8
  %50 = load i32, ptr %14, align 4
  %51 = sext i32 %50 to i64
  %52 = getelementptr inbounds i8, ptr %49, i64 %51
  store i8 %48, ptr %52, align 1
  br label %53

53:                                               ; preds = %42
  %54 = load i32, ptr %14, align 4
  %55 = add nsw i32 %54, 1
  store i32 %55, ptr %14, align 4
  br label %38, !llvm.loop !11

56:                                               ; preds = %38
  %57 = call i32 @gettimeofday(ptr noundef %12, ptr noundef null)
  %58 = getelementptr inbounds %struct.timeval, ptr %12, i32 0, i32 0
  %59 = load i64, ptr %58, align 8
  %60 = getelementptr inbounds %struct.timeval, ptr %11, i32 0, i32 0
  %61 = load i64, ptr %60, align 8
  %62 = sub nsw i64 %59, %61
  %63 = mul nsw i64 %62, 1000
  %64 = getelementptr inbounds %struct.timeval, ptr %12, i32 0, i32 1
  %65 = load i32, ptr %64, align 8
  %66 = getelementptr inbounds %struct.timeval, ptr %11, i32 0, i32 1
  %67 = load i32, ptr %66, align 8
  %68 = sub nsw i32 %65, %67
  %69 = sdiv i32 %68, 1000
  %70 = sext i32 %69 to i64
  %71 = add nsw i64 %63, %70
  %72 = trunc i64 %71 to i32
  store i32 %72, ptr %13, align 4
  %73 = call i32 @puts(ptr noundef @.str.6)
  %74 = call i32 @puts(ptr noundef @.str.8)
  store i32 0, ptr %15, align 4
  br label %75

75:                                               ; preds = %87, %56
  %76 = load i32, ptr %15, align 4
  %77 = load i32, ptr %8, align 4
  %78 = icmp slt i32 %76, %77
  br i1 %78, label %79, label %90

79:                                               ; preds = %75
  %80 = load ptr, ptr %10, align 8
  %81 = load i32, ptr %15, align 4
  %82 = sext i32 %81 to i64
  %83 = getelementptr inbounds i8, ptr %80, i64 %82
  %84 = load i8, ptr %83, align 1
  %85 = sext i8 %84 to i32
  %86 = call i32 @putchar(i32 noundef %85)
  br label %87

87:                                               ; preds = %79
  %88 = load i32, ptr %15, align 4
  %89 = add nsw i32 %88, 1
  store i32 %89, ptr %15, align 4
  br label %75, !llvm.loop !12

90:                                               ; preds = %75
  %91 = call i32 @putchar(i32 noundef 10)
  %92 = load i32, ptr %8, align 4
  %93 = load i32, ptr %13, align 4
  %94 = load i32, ptr %8, align 4
  %95 = sitofp i32 %94 to double
  %96 = load i32, ptr %13, align 4
  %97 = sitofp i32 %96 to double
  %98 = fdiv double %95, %97
  %99 = fmul double %98, 1.000000e+03
  %100 = call i32 (ptr, ...) @printf(ptr noundef @.str.9, i32 noundef %92, i32 noundef %93, double noundef %99)
  %101 = call i32 @puts(ptr noundef @.str.6)
  call void @timer_stop()
  ret i32 0
}

declare void @timer_start(...) #2

declare i32 @puts(ptr noundef) #2

declare i32 @fflush(ptr noundef) #2

declare i32 @putchar(i32 noundef) #2

declare void @timer_stop(...) #2

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { allocsize(0) }

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
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = distinct !{!12, !7}
