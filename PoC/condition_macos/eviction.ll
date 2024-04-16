; ModuleID = 'eviction.c'
source_filename = "eviction.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

%struct.elem = type { ptr, ptr, i32, i64, [32 x i8] }

@threshold = global i64 0, align 8
@eviction_sets = global ptr null, align 8
@eviction_sets_pages = global ptr null, align 8
@evset_size = global i32 0, align 4
@evsets_count = global i32 0, align 4
@page_size = global i64 0, align 8
@evset_memory_size = global i64 0, align 8
@traverser = global ptr null, align 8
@cache_line_size = global i64 64, align 8
@.str = private unnamed_addr constant [13 x i8] c"MMAP FAILED\0A\00", align 1
@.str.1 = private unnamed_addr constant [30 x i8] c"finding eviction set failed!\0A\00", align 1
@.str.2 = private unnamed_addr constant [23 x i8] c"max retries exceeded!\0A\00", align 1
@.str.3 = private unnamed_addr constant [21 x i8] c"Eviction set found!\0A\00", align 1
@.str.4 = private unnamed_addr constant [16 x i8] c"munmap failed!\0A\00", align 1
@.str.5 = private unnamed_addr constant [40 x i8] c"miss: %llu, hit: %llu, threshold: %llu\0A\00", align 1
@.str.6 = private unnamed_addr constant [44 x i8] c"ERROR: Entries are bigger than cache line!\0A\00", align 1
@.str.7 = private unnamed_addr constant [28 x i8] c"Could not allocate chunks!\0A\00", align 1
@.str.8 = private unnamed_addr constant [29 x i8] c"Could not allocate ichunks!\0A\00", align 1
@.str.9 = private unnamed_addr constant [43 x i8] c"Could not allocate back (%d, %f, %f, %d)!\0A\00", align 1
@timestamp = external global i64, align 8

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @evset_init(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) #0 {
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store ptr %0, ptr %6, align 8
  store i32 %1, ptr %7, align 4
  store i32 %2, ptr %8, align 4
  store i32 %3, ptr %9, align 4
  store i32 %4, ptr %10, align 4
  %11 = call i64 @time(ptr noundef null)
  %12 = trunc i64 %11 to i32
  call void @srand(i32 noundef %12)
  call void @timer_start()
  %13 = load ptr, ptr @traverser, align 8
  %14 = icmp ne ptr %13, null
  br i1 %14, label %17, label %15

15:                                               ; preds = %5
  %16 = load ptr, ptr %6, align 8
  store ptr %16, ptr @traverser, align 8
  br label %17

17:                                               ; preds = %15, %5
  %18 = load i32, ptr @evset_size, align 4
  %19 = icmp ne i32 %18, 0
  br i1 %19, label %22, label %20

20:                                               ; preds = %17
  %21 = load i32, ptr %7, align 4
  store i32 %21, ptr @evset_size, align 4
  br label %22

22:                                               ; preds = %20, %17
  %23 = load i64, ptr @page_size, align 8
  %24 = icmp ne i64 %23, 0
  br i1 %24, label %28, label %25

25:                                               ; preds = %22
  %26 = load i32, ptr %8, align 4
  %27 = sext i32 %26 to i64
  store i64 %27, ptr @page_size, align 8
  br label %28

28:                                               ; preds = %25, %22
  %29 = load i64, ptr @evset_memory_size, align 8
  %30 = icmp ne i64 %29, 0
  br i1 %30, label %34, label %31

31:                                               ; preds = %28
  %32 = load i32, ptr %9, align 4
  %33 = sext i32 %32 to i64
  store i64 %33, ptr @evset_memory_size, align 8
  br label %34

34:                                               ; preds = %31, %28
  %35 = load i64, ptr @threshold, align 8
  %36 = icmp ne i64 %35, 0
  br i1 %36, label %40, label %37

37:                                               ; preds = %34
  %38 = load i32, ptr %10, align 4
  %39 = sext i32 %38 to i64
  store i64 %39, ptr @threshold, align 8
  br label %40

40:                                               ; preds = %37, %34
  %41 = load ptr, ptr @eviction_sets, align 8
  %42 = icmp ne ptr %41, null
  br i1 %42, label %45, label %43

43:                                               ; preds = %40
  %44 = call ptr @calloc(i64 noundef 1, i64 noundef 8) #6
  store ptr %44, ptr @eviction_sets, align 8
  br label %45

45:                                               ; preds = %43, %40
  %46 = load ptr, ptr @eviction_sets_pages, align 8
  %47 = icmp ne ptr %46, null
  br i1 %47, label %50, label %48

48:                                               ; preds = %45
  %49 = call ptr @calloc(i64 noundef 1, i64 noundef 8) #6
  store ptr %49, ptr @eviction_sets_pages, align 8
  br label %50

50:                                               ; preds = %48, %45
  call void @timer_stop()
  ret void
}

declare void @srand(i32 noundef) #1

declare i64 @time(ptr noundef) #1

declare void @timer_start(...) #1

; Function Attrs: allocsize(0,1)
declare ptr @calloc(i64 noundef, i64 noundef) #2

declare void @timer_stop(...) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @evset_find(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca i32, align 4
  %11 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %12 = load i64, ptr @page_size, align 8
  %13 = sub i64 %12, 1
  %14 = load ptr, ptr %2, align 8
  %15 = ptrtoint ptr %14 to i64
  %16 = and i64 %13, %15
  %17 = load i64, ptr @cache_line_size, align 8
  %18 = sub i64 %17, 1
  %19 = xor i64 %18, -1
  %20 = and i64 %16, %19
  store i64 %20, ptr %3, align 8
  store i32 -1, ptr %4, align 4
  %21 = load ptr, ptr %2, align 8
  %22 = ptrtoint ptr %21 to i64
  %23 = load i64, ptr @page_size, align 8
  %24 = udiv i64 %22, %23
  store i64 %24, ptr %5, align 8
  store i32 0, ptr %6, align 4
  br label %25

25:                                               ; preds = %41, %1
  %26 = load i32, ptr %6, align 4
  %27 = load i32, ptr @evsets_count, align 4
  %28 = sub nsw i32 %27, 1
  %29 = icmp slt i32 %26, %28
  br i1 %29, label %30, label %44

30:                                               ; preds = %25
  %31 = load ptr, ptr @eviction_sets_pages, align 8
  %32 = load i32, ptr %6, align 4
  %33 = sext i32 %32 to i64
  %34 = getelementptr inbounds i64, ptr %31, i64 %33
  %35 = load i64, ptr %34, align 8
  %36 = load i64, ptr %5, align 8
  %37 = icmp eq i64 %35, %36
  br i1 %37, label %38, label %40

38:                                               ; preds = %30
  %39 = load i32, ptr %6, align 4
  store i32 %39, ptr %4, align 4
  br label %44

40:                                               ; preds = %30
  br label %41

41:                                               ; preds = %40
  %42 = load i32, ptr %6, align 4
  %43 = add nsw i32 %42, 1
  store i32 %43, ptr %6, align 4
  br label %25, !llvm.loop !6

44:                                               ; preds = %38, %25
  %45 = load i32, ptr %4, align 4
  %46 = icmp ne i32 %45, -1
  br i1 %46, label %47, label %55

47:                                               ; preds = %44
  %48 = load ptr, ptr @eviction_sets, align 8
  %49 = load i32, ptr %4, align 4
  %50 = sext i32 %49 to i64
  %51 = getelementptr inbounds ptr, ptr %48, i64 %50
  %52 = load ptr, ptr %51, align 8
  %53 = load i64, ptr %3, align 8
  %54 = call ptr @initialize_list_with_offset(ptr noundef %52, i64 noundef %53)
  store ptr %54, ptr %7, align 8
  br label %121

55:                                               ; preds = %44
  %56 = load i64, ptr @evset_memory_size, align 8
  %57 = call ptr @"\01_mmap"(ptr noundef null, i64 noundef %56, i32 noundef 3, i32 noundef 4098, i32 noundef 0, i64 noundef 0)
  store ptr %57, ptr %8, align 8
  %58 = load ptr, ptr %8, align 8
  %59 = icmp ne ptr %58, null
  br i1 %59, label %62, label %60

60:                                               ; preds = %55
  %61 = call i32 (ptr, ...) @printf(ptr noundef @.str)
  br label %62

62:                                               ; preds = %60, %55
  %63 = load ptr, ptr %8, align 8
  %64 = load i64, ptr %3, align 8
  %65 = getelementptr inbounds i8, ptr %63, i64 %64
  store ptr %65, ptr %7, align 8
  %66 = load ptr, ptr %8, align 8
  %67 = load i64, ptr @evset_memory_size, align 8
  %68 = load i64, ptr %3, align 8
  call void @initialize_list(ptr noundef %66, i64 noundef %67, i64 noundef %68)
  store ptr null, ptr %9, align 8
  store i32 0, ptr %10, align 4
  br label %69

69:                                               ; preds = %79, %62
  %70 = load ptr, ptr %2, align 8
  %71 = call i32 @gt_eviction(ptr noundef %7, ptr noundef %9, ptr noundef %70)
  %72 = icmp ne i32 %71, 0
  br i1 %72, label %73, label %93

73:                                               ; preds = %69
  %74 = call i32 (ptr, ...) @printf(ptr noundef @.str.1)
  %75 = load i32, ptr %10, align 4
  %76 = icmp sgt i32 %75, 20
  br i1 %76, label %77, label %79

77:                                               ; preds = %73
  %78 = call i32 (ptr, ...) @printf(ptr noundef @.str.2)
  br label %93

79:                                               ; preds = %73
  %80 = load ptr, ptr %8, align 8
  %81 = load i64, ptr @evset_memory_size, align 8
  %82 = call i32 @"\01_munmap"(ptr noundef %80, i64 noundef %81)
  %83 = load i64, ptr @evset_memory_size, align 8
  %84 = call ptr @"\01_mmap"(ptr noundef null, i64 noundef %83, i32 noundef 3, i32 noundef 4098, i32 noundef 0, i64 noundef 0)
  store ptr %84, ptr %8, align 8
  %85 = load ptr, ptr %8, align 8
  %86 = load i64, ptr %3, align 8
  %87 = getelementptr inbounds i8, ptr %85, i64 %86
  store ptr %87, ptr %7, align 8
  %88 = load ptr, ptr %8, align 8
  %89 = load i64, ptr @evset_memory_size, align 8
  %90 = load i64, ptr %3, align 8
  call void @initialize_list(ptr noundef %88, i64 noundef %89, i64 noundef %90)
  store ptr null, ptr %9, align 8
  %91 = load i32, ptr %10, align 4
  %92 = add nsw i32 %91, 1
  store i32 %92, ptr %10, align 4
  br label %69, !llvm.loop !8

93:                                               ; preds = %77, %69
  %94 = load i32, ptr %10, align 4
  %95 = icmp slt i32 %94, 20
  br i1 %95, label %96, label %98

96:                                               ; preds = %93
  %97 = call i32 (ptr, ...) @printf(ptr noundef @.str.3)
  br label %98

98:                                               ; preds = %96, %93
  br label %99

99:                                               ; preds = %118, %98
  %100 = load ptr, ptr %9, align 8
  %101 = icmp ne ptr %100, null
  br i1 %101, label %102, label %120

102:                                              ; preds = %99
  %103 = load ptr, ptr %9, align 8
  %104 = getelementptr inbounds %struct.elem, ptr %103, i32 0, i32 0
  %105 = load ptr, ptr %104, align 8
  store ptr %105, ptr %11, align 8
  %106 = load ptr, ptr %9, align 8
  %107 = ptrtoint ptr %106 to i64
  %108 = load i64, ptr @page_size, align 8
  %109 = sub i64 %108, 1
  %110 = xor i64 %109, -1
  %111 = and i64 %107, %110
  %112 = inttoptr i64 %111 to ptr
  %113 = load i64, ptr @page_size, align 8
  %114 = call i32 @"\01_munmap"(ptr noundef %112, i64 noundef %113)
  %115 = icmp ne i32 %114, 0
  br i1 %115, label %116, label %118

116:                                              ; preds = %102
  %117 = call i32 (ptr, ...) @printf(ptr noundef @.str.4)
  br label %118

118:                                              ; preds = %116, %102
  %119 = load ptr, ptr %11, align 8
  store ptr %119, ptr %9, align 8
  br label %99, !llvm.loop !9

120:                                              ; preds = %99
  br label %121

121:                                              ; preds = %120, %47
  %122 = load ptr, ptr %7, align 8
  %123 = load ptr, ptr @eviction_sets, align 8
  %124 = load i32, ptr @evsets_count, align 4
  %125 = sub nsw i32 %124, 1
  %126 = sext i32 %125 to i64
  %127 = getelementptr inbounds ptr, ptr %123, i64 %126
  store ptr %122, ptr %127, align 8
  %128 = load i64, ptr %5, align 8
  %129 = load ptr, ptr @eviction_sets_pages, align 8
  %130 = load i32, ptr @evsets_count, align 4
  %131 = sub nsw i32 %130, 1
  %132 = sext i32 %131 to i64
  %133 = getelementptr inbounds i64, ptr %129, i64 %132
  store i64 %128, ptr %133, align 8
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal ptr @initialize_list_with_offset(ptr noundef %0, i64 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store i64 %1, ptr %4, align 8
  %9 = load ptr, ptr %3, align 8
  %10 = ptrtoint ptr %9 to i64
  %11 = load i64, ptr @page_size, align 8
  %12 = sub i64 %11, 1
  %13 = and i64 %10, %12
  %14 = load i64, ptr %4, align 8
  %15 = xor i64 %13, %14
  store i64 %15, ptr %5, align 8
  store ptr null, ptr %6, align 8
  %16 = load ptr, ptr %3, align 8
  %17 = ptrtoint ptr %16 to i64
  %18 = load i64, ptr %5, align 8
  %19 = xor i64 %17, %18
  %20 = inttoptr i64 %19 to ptr
  store ptr %20, ptr %7, align 8
  br label %21

21:                                               ; preds = %45, %2
  %22 = load ptr, ptr %3, align 8
  %23 = icmp ne ptr %22, null
  br i1 %23, label %24, label %50

24:                                               ; preds = %21
  %25 = load ptr, ptr %3, align 8
  %26 = ptrtoint ptr %25 to i64
  %27 = load i64, ptr %5, align 8
  %28 = xor i64 %26, %27
  %29 = inttoptr i64 %28 to ptr
  store ptr %29, ptr %8, align 8
  %30 = load ptr, ptr %8, align 8
  %31 = getelementptr inbounds %struct.elem, ptr %30, i32 0, i32 2
  store i32 -2, ptr %31, align 8
  %32 = load ptr, ptr %8, align 8
  %33 = getelementptr inbounds %struct.elem, ptr %32, i32 0, i32 3
  store i64 0, ptr %33, align 8
  %34 = load ptr, ptr %6, align 8
  %35 = load ptr, ptr %8, align 8
  %36 = getelementptr inbounds %struct.elem, ptr %35, i32 0, i32 1
  store ptr %34, ptr %36, align 8
  %37 = load ptr, ptr %8, align 8
  %38 = getelementptr inbounds %struct.elem, ptr %37, i32 0, i32 0
  store ptr null, ptr %38, align 8
  %39 = load ptr, ptr %6, align 8
  %40 = icmp ne ptr %39, null
  br i1 %40, label %41, label %45

41:                                               ; preds = %24
  %42 = load ptr, ptr %8, align 8
  %43 = load ptr, ptr %6, align 8
  %44 = getelementptr inbounds %struct.elem, ptr %43, i32 0, i32 0
  store ptr %42, ptr %44, align 8
  br label %45

45:                                               ; preds = %41, %24
  %46 = load ptr, ptr %8, align 8
  store ptr %46, ptr %6, align 8
  %47 = load ptr, ptr %3, align 8
  %48 = getelementptr inbounds %struct.elem, ptr %47, i32 0, i32 0
  %49 = load ptr, ptr %48, align 8
  store ptr %49, ptr %3, align 8
  br label %21, !llvm.loop !10

50:                                               ; preds = %21
  %51 = load ptr, ptr %7, align 8
  ret ptr %51
}

declare ptr @"\01_mmap"(ptr noundef, i64 noundef, i32 noundef, i32 noundef, i32 noundef, i64 noundef) #1

declare i32 @printf(ptr noundef, ...) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @initialize_list(ptr noundef %0, i64 noundef %1, i64 noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  %10 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store i64 %1, ptr %5, align 8
  store i64 %2, ptr %6, align 8
  store i64 0, ptr %7, align 8
  store ptr null, ptr %8, align 8
  store i32 0, ptr %9, align 4
  %11 = load i64, ptr %6, align 8
  store i64 %11, ptr %7, align 8
  br label %12

12:                                               ; preds = %41, %3
  %13 = load i64, ptr %7, align 8
  %14 = load i64, ptr %5, align 8
  %15 = sub i64 %14, 64
  %16 = icmp ult i64 %13, %15
  br i1 %16, label %17, label %45

17:                                               ; preds = %12
  %18 = load i32, ptr %9, align 4
  %19 = add nsw i32 %18, 1
  store i32 %19, ptr %9, align 4
  %20 = load ptr, ptr %4, align 8
  %21 = load i64, ptr %7, align 8
  %22 = getelementptr inbounds i8, ptr %20, i64 %21
  store ptr %22, ptr %10, align 8
  %23 = load ptr, ptr %10, align 8
  %24 = load ptr, ptr %10, align 8
  %25 = getelementptr inbounds %struct.elem, ptr %24, i32 0, i32 2
  store i32 -2, ptr %25, align 8
  %26 = load ptr, ptr %10, align 8
  %27 = getelementptr inbounds %struct.elem, ptr %26, i32 0, i32 3
  store i64 0, ptr %27, align 8
  %28 = load ptr, ptr %8, align 8
  %29 = load ptr, ptr %10, align 8
  %30 = getelementptr inbounds %struct.elem, ptr %29, i32 0, i32 1
  store ptr %28, ptr %30, align 8
  %31 = load ptr, ptr %10, align 8
  %32 = getelementptr inbounds %struct.elem, ptr %31, i32 0, i32 0
  store ptr null, ptr %32, align 8
  %33 = load ptr, ptr %8, align 8
  %34 = icmp ne ptr %33, null
  br i1 %34, label %35, label %39

35:                                               ; preds = %17
  %36 = load ptr, ptr %10, align 8
  %37 = load ptr, ptr %8, align 8
  %38 = getelementptr inbounds %struct.elem, ptr %37, i32 0, i32 0
  store ptr %36, ptr %38, align 8
  br label %39

39:                                               ; preds = %35, %17
  %40 = load ptr, ptr %10, align 8
  store ptr %40, ptr %8, align 8
  br label %41

41:                                               ; preds = %39
  %42 = load i64, ptr @page_size, align 8
  %43 = load i64, ptr %7, align 8
  %44 = add i64 %43, %42
  store i64 %44, ptr %7, align 8
  br label %12, !llvm.loop !11

45:                                               ; preds = %12
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @gt_eviction(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca double, align 8
  %14 = alloca double, align 8
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca ptr, align 8
  %18 = alloca i32, align 4
  %19 = alloca i32, align 4
  %20 = alloca i32, align 4
  %21 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store ptr %2, ptr %7, align 8
  %22 = load i32, ptr @evset_size, align 4
  %23 = add nsw i32 %22, 1
  %24 = sext i32 %23 to i64
  %25 = call ptr @calloc(i64 noundef %24, i64 noundef 8) #6
  store ptr %25, ptr %8, align 8
  %26 = load ptr, ptr %8, align 8
  %27 = icmp ne ptr %26, null
  br i1 %27, label %30, label %28

28:                                               ; preds = %3
  %29 = call i32 (ptr, ...) @printf(ptr noundef @.str.7)
  store i32 1, ptr %4, align 4
  br label %266

30:                                               ; preds = %3
  %31 = load i32, ptr @evset_size, align 4
  %32 = add nsw i32 %31, 1
  %33 = sext i32 %32 to i64
  %34 = call ptr @calloc(i64 noundef %33, i64 noundef 4) #6
  store ptr %34, ptr %9, align 8
  %35 = load ptr, ptr %9, align 8
  %36 = icmp ne ptr %35, null
  br i1 %36, label %40, label %37

37:                                               ; preds = %30
  %38 = call i32 (ptr, ...) @printf(ptr noundef @.str.8)
  %39 = load ptr, ptr %8, align 8
  call void @free(ptr noundef %39)
  store i32 1, ptr %4, align 4
  br label %266

40:                                               ; preds = %30
  %41 = load ptr, ptr %5, align 8
  %42 = load ptr, ptr %41, align 8
  %43 = call i32 @list_length(ptr noundef %42)
  store i32 %43, ptr %11, align 4
  store i32 0, ptr %12, align 4
  %44 = load i32, ptr @evset_size, align 4
  %45 = sitofp i32 %44 to double
  %46 = load i32, ptr %11, align 4
  %47 = sitofp i32 %46 to double
  %48 = fdiv double %45, %47
  store double %48, ptr %13, align 8
  %49 = load i32, ptr @evset_size, align 4
  %50 = sitofp i32 %49 to double
  %51 = load i32, ptr @evset_size, align 4
  %52 = add nsw i32 %51, 1
  %53 = sitofp i32 %52 to double
  %54 = fdiv double %50, %53
  store double %54, ptr %14, align 8
  %55 = load double, ptr %13, align 8
  %56 = call double @llvm.log.f64(double %55)
  %57 = load double, ptr %14, align 8
  %58 = call double @llvm.log.f64(double %57)
  %59 = fdiv double %56, %58
  %60 = call double @llvm.ceil.f64(double %59)
  %61 = fptosi double %60 to i32
  store i32 %61, ptr %15, align 4
  store i32 0, ptr %16, align 4
  %62 = load i32, ptr %15, align 4
  %63 = mul nsw i32 %62, 2
  %64 = sext i32 %63 to i64
  %65 = call ptr @calloc(i64 noundef %64, i64 noundef 8) #6
  store ptr %65, ptr %17, align 8
  %66 = load ptr, ptr %17, align 8
  %67 = icmp ne ptr %66, null
  br i1 %67, label %78, label %68

68:                                               ; preds = %40
  %69 = load i32, ptr %15, align 4
  %70 = load double, ptr %13, align 8
  %71 = load double, ptr %14, align 8
  %72 = load ptr, ptr %5, align 8
  %73 = load ptr, ptr %72, align 8
  %74 = call i32 @list_length(ptr noundef %73)
  %75 = call i32 (ptr, ...) @printf(ptr noundef @.str.9, i32 noundef %69, double noundef %70, double noundef %71, i32 noundef %74)
  %76 = load ptr, ptr %8, align 8
  call void @free(ptr noundef %76)
  %77 = load ptr, ptr %9, align 8
  call void @free(ptr noundef %77)
  store i32 1, ptr %4, align 4
  br label %266

78:                                               ; preds = %40
  store i32 0, ptr %18, align 4
  br label %79

79:                                               ; preds = %230, %78
  store i32 0, ptr %10, align 4
  br label %80

80:                                               ; preds = %91, %79
  %81 = load i32, ptr %10, align 4
  %82 = load i32, ptr @evset_size, align 4
  %83 = add nsw i32 %82, 1
  %84 = icmp slt i32 %81, %83
  br i1 %84, label %85, label %94

85:                                               ; preds = %80
  %86 = load i32, ptr %10, align 4
  %87 = load ptr, ptr %9, align 8
  %88 = load i32, ptr %10, align 4
  %89 = sext i32 %88 to i64
  %90 = getelementptr inbounds i32, ptr %87, i64 %89
  store i32 %86, ptr %90, align 4
  br label %91

91:                                               ; preds = %85
  %92 = load i32, ptr %10, align 4
  %93 = add nsw i32 %92, 1
  store i32 %93, ptr %10, align 4
  br label %80, !llvm.loop !12

94:                                               ; preds = %80
  %95 = load ptr, ptr %9, align 8
  %96 = load i32, ptr @evset_size, align 4
  %97 = add nsw i32 %96, 1
  %98 = sext i32 %97 to i64
  call void @shuffle(ptr noundef %95, i64 noundef %98)
  br label %99

99:                                               ; preds = %220, %94
  %100 = load i32, ptr %11, align 4
  %101 = load i32, ptr @evset_size, align 4
  %102 = icmp sgt i32 %100, %101
  br i1 %102, label %103, label %221

103:                                              ; preds = %99
  %104 = load ptr, ptr %5, align 8
  %105 = load ptr, ptr %104, align 8
  %106 = load ptr, ptr %8, align 8
  %107 = load i32, ptr @evset_size, align 4
  %108 = add nsw i32 %107, 1
  call void @list_split(ptr noundef %105, ptr noundef %106, i32 noundef %108)
  store i32 0, ptr %19, align 4
  store i32 0, ptr %20, align 4
  br label %109

109:                                              ; preds = %133, %103
  %110 = load ptr, ptr %5, align 8
  %111 = load ptr, ptr %8, align 8
  %112 = load ptr, ptr %9, align 8
  %113 = load i32, ptr %19, align 4
  %114 = sext i32 %113 to i64
  %115 = getelementptr inbounds i32, ptr %112, i64 %114
  %116 = load i32, ptr %115, align 4
  %117 = load i32, ptr @evset_size, align 4
  %118 = add nsw i32 %117, 1
  call void @list_from_chunks(ptr noundef %110, ptr noundef %111, i32 noundef %116, i32 noundef %118)
  %119 = load i32, ptr %19, align 4
  %120 = add nsw i32 %119, 1
  store i32 %120, ptr %19, align 4
  %121 = load ptr, ptr %5, align 8
  %122 = load ptr, ptr %121, align 8
  %123 = load ptr, ptr %7, align 8
  %124 = call i32 @tests_avg(ptr noundef %122, ptr noundef %123, i32 noundef 50)
  store i32 %124, ptr %20, align 4
  br label %125

125:                                              ; preds = %109
  %126 = load i32, ptr %20, align 4
  %127 = icmp ne i32 %126, 0
  br i1 %127, label %133, label %128

128:                                              ; preds = %125
  %129 = load i32, ptr %19, align 4
  %130 = load i32, ptr @evset_size, align 4
  %131 = add nsw i32 %130, 1
  %132 = icmp slt i32 %129, %131
  br label %133

133:                                              ; preds = %128, %125
  %134 = phi i1 [ false, %125 ], [ %132, %128 ]
  br i1 %134, label %109, label %135, !llvm.loop !13

135:                                              ; preds = %133
  %136 = load i32, ptr %20, align 4
  %137 = icmp ne i32 %136, 0
  br i1 %137, label %138, label %170

138:                                              ; preds = %135
  %139 = load i32, ptr %19, align 4
  %140 = load i32, ptr @evset_size, align 4
  %141 = icmp sle i32 %139, %140
  br i1 %141, label %142, label %170

142:                                              ; preds = %138
  %143 = load ptr, ptr %8, align 8
  %144 = load ptr, ptr %9, align 8
  %145 = load i32, ptr %19, align 4
  %146 = sub nsw i32 %145, 1
  %147 = sext i32 %146 to i64
  %148 = getelementptr inbounds i32, ptr %144, i64 %147
  %149 = load i32, ptr %148, align 4
  %150 = sext i32 %149 to i64
  %151 = getelementptr inbounds ptr, ptr %143, i64 %150
  %152 = load ptr, ptr %151, align 8
  %153 = load ptr, ptr %17, align 8
  %154 = load i32, ptr %16, align 4
  %155 = sext i32 %154 to i64
  %156 = getelementptr inbounds ptr, ptr %153, i64 %155
  store ptr %152, ptr %156, align 8
  %157 = load ptr, ptr %17, align 8
  %158 = load i32, ptr %16, align 4
  %159 = sext i32 %158 to i64
  %160 = getelementptr inbounds ptr, ptr %157, i64 %159
  %161 = load ptr, ptr %160, align 8
  %162 = call i32 @list_length(ptr noundef %161)
  %163 = load i32, ptr %12, align 4
  %164 = add nsw i32 %163, %162
  store i32 %164, ptr %12, align 4
  %165 = load ptr, ptr %5, align 8
  %166 = load ptr, ptr %165, align 8
  %167 = call i32 @list_length(ptr noundef %166)
  store i32 %167, ptr %11, align 4
  %168 = load i32, ptr %16, align 4
  %169 = add nsw i32 %168, 1
  store i32 %169, ptr %16, align 4
  br label %220

170:                                              ; preds = %138, %135
  %171 = load i32, ptr %16, align 4
  %172 = icmp sgt i32 %171, 0
  br i1 %172, label %173, label %208

173:                                              ; preds = %170
  %174 = load ptr, ptr %5, align 8
  %175 = load ptr, ptr %8, align 8
  %176 = load ptr, ptr %9, align 8
  %177 = load i32, ptr %19, align 4
  %178 = sub nsw i32 %177, 1
  %179 = sext i32 %178 to i64
  %180 = getelementptr inbounds i32, ptr %176, i64 %179
  %181 = load i32, ptr %180, align 4
  %182 = sext i32 %181 to i64
  %183 = getelementptr inbounds ptr, ptr %175, i64 %182
  %184 = load ptr, ptr %183, align 8
  call void @list_concat(ptr noundef %174, ptr noundef %184)
  %185 = load i32, ptr %16, align 4
  %186 = sub nsw i32 %185, 1
  store i32 %186, ptr %16, align 4
  %187 = load ptr, ptr %17, align 8
  %188 = load i32, ptr %16, align 4
  %189 = sext i32 %188 to i64
  %190 = getelementptr inbounds ptr, ptr %187, i64 %189
  %191 = load ptr, ptr %190, align 8
  %192 = call i32 @list_length(ptr noundef %191)
  %193 = load i32, ptr %12, align 4
  %194 = sub nsw i32 %193, %192
  store i32 %194, ptr %12, align 4
  %195 = load ptr, ptr %5, align 8
  %196 = load ptr, ptr %17, align 8
  %197 = load i32, ptr %16, align 4
  %198 = sext i32 %197 to i64
  %199 = getelementptr inbounds ptr, ptr %196, i64 %198
  %200 = load ptr, ptr %199, align 8
  call void @list_concat(ptr noundef %195, ptr noundef %200)
  %201 = load ptr, ptr %17, align 8
  %202 = load i32, ptr %16, align 4
  %203 = sext i32 %202 to i64
  %204 = getelementptr inbounds ptr, ptr %201, i64 %203
  store ptr null, ptr %204, align 8
  %205 = load ptr, ptr %5, align 8
  %206 = load ptr, ptr %205, align 8
  %207 = call i32 @list_length(ptr noundef %206)
  store i32 %207, ptr %11, align 4
  br label %222

208:                                              ; preds = %170
  %209 = load ptr, ptr %5, align 8
  %210 = load ptr, ptr %8, align 8
  %211 = load ptr, ptr %9, align 8
  %212 = load i32, ptr %19, align 4
  %213 = sub nsw i32 %212, 1
  %214 = sext i32 %213 to i64
  %215 = getelementptr inbounds i32, ptr %211, i64 %214
  %216 = load i32, ptr %215, align 4
  %217 = sext i32 %216 to i64
  %218 = getelementptr inbounds ptr, ptr %210, i64 %217
  %219 = load ptr, ptr %218, align 8
  call void @list_concat(ptr noundef %209, ptr noundef %219)
  br label %221

220:                                              ; preds = %142
  br label %99, !llvm.loop !14

221:                                              ; preds = %208, %99
  br label %232

222:                                              ; preds = %173
  br label %223

223:                                              ; preds = %222
  %224 = load i32, ptr %16, align 4
  %225 = icmp sgt i32 %224, 0
  br i1 %225, label %226, label %230

226:                                              ; preds = %223
  %227 = load i32, ptr %18, align 4
  %228 = add nsw i32 %227, 1
  store i32 %228, ptr %18, align 4
  %229 = icmp slt i32 %227, 50
  br label %230

230:                                              ; preds = %226, %223
  %231 = phi i1 [ false, %223 ], [ %229, %226 ]
  br i1 %231, label %79, label %232, !llvm.loop !15

232:                                              ; preds = %230, %221
  store i32 0, ptr %10, align 4
  br label %233

233:                                              ; preds = %245, %232
  %234 = load i32, ptr %10, align 4
  %235 = load i32, ptr %15, align 4
  %236 = mul nsw i32 %235, 2
  %237 = icmp slt i32 %234, %236
  br i1 %237, label %238, label %248

238:                                              ; preds = %233
  %239 = load ptr, ptr %6, align 8
  %240 = load ptr, ptr %17, align 8
  %241 = load i32, ptr %10, align 4
  %242 = sext i32 %241 to i64
  %243 = getelementptr inbounds ptr, ptr %240, i64 %242
  %244 = load ptr, ptr %243, align 8
  call void @list_concat(ptr noundef %239, ptr noundef %244)
  br label %245

245:                                              ; preds = %238
  %246 = load i32, ptr %10, align 4
  %247 = add nsw i32 %246, 1
  store i32 %247, ptr %10, align 4
  br label %233, !llvm.loop !16

248:                                              ; preds = %233
  %249 = load ptr, ptr %8, align 8
  call void @free(ptr noundef %249)
  %250 = load ptr, ptr %9, align 8
  call void @free(ptr noundef %250)
  %251 = load ptr, ptr %17, align 8
  call void @free(ptr noundef %251)
  store i32 0, ptr %21, align 4
  %252 = load ptr, ptr %5, align 8
  %253 = load ptr, ptr %252, align 8
  %254 = load ptr, ptr %7, align 8
  %255 = call i32 @tests_avg(ptr noundef %253, ptr noundef %254, i32 noundef 50)
  store i32 %255, ptr %21, align 4
  %256 = load i32, ptr %21, align 4
  %257 = icmp ne i32 %256, 0
  br i1 %257, label %258, label %264

258:                                              ; preds = %248
  %259 = load i32, ptr %11, align 4
  %260 = load i32, ptr @evset_size, align 4
  %261 = icmp sgt i32 %259, %260
  br i1 %261, label %262, label %263

262:                                              ; preds = %258
  store i32 1, ptr %4, align 4
  br label %266

263:                                              ; preds = %258
  br label %265

264:                                              ; preds = %248
  store i32 1, ptr %4, align 4
  br label %266

265:                                              ; preds = %263
  store i32 0, ptr %4, align 4
  br label %266

266:                                              ; preds = %265, %264, %262, %68, %37, %28
  %267 = load i32, ptr %4, align 4
  ret i32 %267
}

declare i32 @"\01_munmap"(ptr noundef, i64 noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @cache_remove(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = ptrtoint ptr %4 to i64
  %6 = trunc i64 %5 to i32
  store i32 %6, ptr %3, align 4
  %7 = load ptr, ptr @traverser, align 8
  %8 = load ptr, ptr @eviction_sets, align 8
  %9 = load i32, ptr %3, align 4
  %10 = zext i32 %9 to i64
  %11 = getelementptr inbounds ptr, ptr %8, i64 %10
  %12 = load ptr, ptr %11, align 8
  call void %7(ptr noundef %12)
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i64 @probe_cache_miss() #0 {
  %1 = alloca ptr, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store i64 0, ptr %4, align 8
  br label %7

7:                                                ; preds = %38, %0
  %8 = call ptr @malloc(i64 noundef 1638400) #7
  store ptr %8, ptr %5, align 8
  %9 = call i32 @rand()
  %10 = srem i32 %9, 99
  store i32 %10, ptr %6, align 4
  %11 = load ptr, ptr %5, align 8
  %12 = load i32, ptr %6, align 4
  %13 = mul nsw i32 %12, 16384
  %14 = sext i32 %13 to i64
  %15 = getelementptr inbounds i8, ptr %11, i64 %14
  %16 = call i32 @rand()
  %17 = srem i32 %16, 8192
  %18 = sext i32 %17 to i64
  %19 = getelementptr inbounds i8, ptr %15, i64 %18
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %19) #8, !srcloc !17
  %20 = load ptr, ptr %5, align 8
  %21 = load i32, ptr %6, align 4
  %22 = mul nsw i32 %21, 16384
  %23 = sext i32 %22 to i64
  %24 = getelementptr inbounds i8, ptr %20, i64 %23
  %25 = getelementptr inbounds i8, ptr %24, i64 8192
  %26 = call i32 @rand()
  %27 = srem i32 %26, 16384
  %28 = sdiv i32 %27, 2
  %29 = sext i32 %28 to i64
  %30 = getelementptr inbounds i8, ptr %25, i64 %29
  store ptr %30, ptr %1, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !18
  %31 = load i64, ptr @timestamp, align 8
  store i64 %31, ptr %2, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !19
  %32 = load ptr, ptr %1, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %32) #8, !srcloc !20
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !21
  %33 = load i64, ptr @timestamp, align 8
  store i64 %33, ptr %3, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !22
  %34 = load i64, ptr %3, align 8
  %35 = load i64, ptr %2, align 8
  %36 = sub i64 %34, %35
  store i64 %36, ptr %4, align 8
  %37 = load ptr, ptr %5, align 8
  call void @free(ptr noundef %37)
  br label %38

38:                                               ; preds = %7
  %39 = load i64, ptr %4, align 8
  %40 = icmp eq i64 %39, 0
  br i1 %40, label %7, label %41, !llvm.loop !23

41:                                               ; preds = %38
  %42 = load i64, ptr %4, align 8
  ret i64 %42
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #3

declare i32 @rand() #1

declare void @free(ptr noundef) #1

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i64 @probe_cache_hit() #0 {
  %1 = alloca ptr, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca ptr, align 8
  store i64 0, ptr %4, align 8
  br label %6

6:                                                ; preds = %19, %0
  %7 = call ptr @malloc(i64 noundef 16384) #7
  store ptr %7, ptr %5, align 8
  %8 = load ptr, ptr %5, align 8
  %9 = getelementptr inbounds i8, ptr %8, i64 1024
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %9) #8, !srcloc !24
  %10 = load ptr, ptr %5, align 8
  %11 = getelementptr inbounds i8, ptr %10, i64 1024
  store ptr %11, ptr %1, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !18
  %12 = load i64, ptr @timestamp, align 8
  store i64 %12, ptr %2, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !19
  %13 = load ptr, ptr %1, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %13) #8, !srcloc !20
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !21
  %14 = load i64, ptr @timestamp, align 8
  store i64 %14, ptr %3, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !22
  %15 = load i64, ptr %3, align 8
  %16 = load i64, ptr %2, align 8
  %17 = sub i64 %15, %16
  store i64 %17, ptr %4, align 8
  %18 = load ptr, ptr %5, align 8
  call void @free(ptr noundef %18)
  br label %19

19:                                               ; preds = %6
  %20 = load i64, ptr %4, align 8
  %21 = icmp eq i64 %20, 0
  br i1 %21, label %6, label %22, !llvm.loop !25

22:                                               ; preds = %19
  %23 = load i64, ptr %4, align 8
  ret i64 %23
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i64 @find_threshold() #0 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i64 0, ptr %1, align 8
  store i64 0, ptr %2, align 8
  store i32 0, ptr %3, align 4
  br label %5

5:                                                ; preds = %12, %0
  %6 = load i32, ptr %3, align 4
  %7 = icmp slt i32 %6, 1000
  br i1 %7, label %8, label %15

8:                                                ; preds = %5
  %9 = call i64 @probe_cache_miss()
  %10 = load i64, ptr %1, align 8
  %11 = add i64 %10, %9
  store i64 %11, ptr %1, align 8
  br label %12

12:                                               ; preds = %8
  %13 = load i32, ptr %3, align 4
  %14 = add nsw i32 %13, 1
  store i32 %14, ptr %3, align 4
  br label %5, !llvm.loop !26

15:                                               ; preds = %5
  store i32 0, ptr %4, align 4
  br label %16

16:                                               ; preds = %23, %15
  %17 = load i32, ptr %4, align 4
  %18 = icmp slt i32 %17, 1000
  br i1 %18, label %19, label %26

19:                                               ; preds = %16
  %20 = call i64 @probe_cache_hit()
  %21 = load i64, ptr %2, align 8
  %22 = add i64 %21, %20
  store i64 %22, ptr %2, align 8
  br label %23

23:                                               ; preds = %19
  %24 = load i32, ptr %4, align 4
  %25 = add nsw i32 %24, 1
  store i32 %25, ptr %4, align 4
  br label %16, !llvm.loop !27

26:                                               ; preds = %16
  %27 = load i64, ptr %1, align 8
  %28 = udiv i64 %27, 1000
  %29 = load i64, ptr %2, align 8
  %30 = udiv i64 %29, 1000
  %31 = load i64, ptr %1, align 8
  %32 = mul i64 3, %31
  %33 = load i64, ptr %2, align 8
  %34 = add i64 %32, %33
  %35 = udiv i64 %34, 4000
  %36 = call i32 (ptr, ...) @printf(ptr noundef @.str.5, i64 noundef %28, i64 noundef %30, i64 noundef %35)
  %37 = load i64, ptr %1, align 8
  %38 = mul i64 3, %37
  %39 = load i64, ptr %2, align 8
  %40 = add i64 %38, %39
  %41 = udiv i64 %40, 4000
  ret i64 %41
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define ptr @cache_remove_prepare(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  store ptr %0, ptr %6, align 8
  %10 = load i64, ptr @cache_line_size, align 8
  %11 = icmp ult i64 %10, 64
  br i1 %11, label %12, label %14

12:                                               ; preds = %1
  %13 = call i32 (ptr, ...) @printf(ptr noundef @.str.6)
  br label %14

14:                                               ; preds = %12, %1
  %15 = load ptr, ptr @eviction_sets, align 8
  %16 = icmp ne ptr %15, null
  br i1 %16, label %18, label %17

17:                                               ; preds = %14
  call void @evset_init(ptr noundef @traverse_list_skylake, i32 noundef 32, i32 noundef 16384, i32 noundef 33554432, i32 noundef 220)
  br label %18

18:                                               ; preds = %17, %14
  call void @timer_start()
  store i64 0, ptr %8, align 8
  br label %19

19:                                               ; preds = %50, %18
  %20 = load i64, ptr %8, align 8
  %21 = load i32, ptr @evsets_count, align 4
  %22 = sext i32 %21 to i64
  %23 = icmp ult i64 %20, %22
  br i1 %23, label %24, label %53

24:                                               ; preds = %19
  %25 = load ptr, ptr %6, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %25) #8, !srcloc !28
  %26 = load ptr, ptr %6, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %26) #8, !srcloc !29
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !30
  %27 = load ptr, ptr @traverser, align 8
  %28 = load ptr, ptr @eviction_sets, align 8
  %29 = load i64, ptr %8, align 8
  %30 = getelementptr inbounds ptr, ptr %28, i64 %29
  %31 = load ptr, ptr %30, align 8
  call void %27(ptr noundef %31)
  %32 = load ptr, ptr @traverser, align 8
  %33 = load ptr, ptr @eviction_sets, align 8
  %34 = load i64, ptr %8, align 8
  %35 = getelementptr inbounds ptr, ptr %33, i64 %34
  %36 = load ptr, ptr %35, align 8
  call void %32(ptr noundef %36)
  %37 = load ptr, ptr %6, align 8
  store ptr %37, ptr %2, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !18
  %38 = load i64, ptr @timestamp, align 8
  store i64 %38, ptr %3, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !19
  %39 = load ptr, ptr %2, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %39) #8, !srcloc !20
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !21
  %40 = load i64, ptr @timestamp, align 8
  store i64 %40, ptr %4, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !22
  %41 = load i64, ptr %4, align 8
  %42 = load i64, ptr %3, align 8
  %43 = sub i64 %41, %42
  %44 = load i64, ptr @threshold, align 8
  %45 = icmp ugt i64 %43, %44
  br i1 %45, label %46, label %49

46:                                               ; preds = %24
  %47 = load i64, ptr %8, align 8
  %48 = inttoptr i64 %47 to ptr
  store ptr %48, ptr %5, align 8
  br label %77

49:                                               ; preds = %24
  br label %50

50:                                               ; preds = %49
  %51 = load i64, ptr %8, align 8
  %52 = add i64 %51, 1
  store i64 %52, ptr %8, align 8
  br label %19, !llvm.loop !31

53:                                               ; preds = %19
  %54 = load i32, ptr @evsets_count, align 4
  %55 = add nsw i32 %54, 1
  store i32 %55, ptr @evsets_count, align 4
  %56 = sext i32 %54 to i64
  store i64 %56, ptr %9, align 8
  %57 = load i32, ptr @evsets_count, align 4
  %58 = srem i32 %57, 8
  %59 = icmp eq i32 %58, 1
  br i1 %59, label %60, label %73

60:                                               ; preds = %53
  %61 = load ptr, ptr @eviction_sets, align 8
  %62 = load i32, ptr @evsets_count, align 4
  %63 = add nsw i32 %62, 8
  %64 = sext i32 %63 to i64
  %65 = mul i64 8, %64
  %66 = call ptr @realloc(ptr noundef %61, i64 noundef %65) #9
  store ptr %66, ptr @eviction_sets, align 8
  %67 = load ptr, ptr @eviction_sets_pages, align 8
  %68 = load i32, ptr @evsets_count, align 4
  %69 = add nsw i32 %68, 8
  %70 = sext i32 %69 to i64
  %71 = mul i64 8, %70
  %72 = call ptr @realloc(ptr noundef %67, i64 noundef %71) #9
  store ptr %72, ptr @eviction_sets_pages, align 8
  br label %73

73:                                               ; preds = %60, %53
  %74 = load ptr, ptr %6, align 8
  call void @evset_find(ptr noundef %74)
  call void @timer_stop()
  %75 = load i64, ptr %9, align 8
  %76 = inttoptr i64 %75 to ptr
  store ptr %76, ptr %5, align 8
  br label %77

77:                                               ; preds = %73, %46
  %78 = load ptr, ptr %5, align 8
  ret ptr %78
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define internal void @traverse_list_skylake(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  store ptr %4, ptr %3, align 8
  br label %5

5:                                                ; preds = %22, %1
  %6 = load ptr, ptr %3, align 8
  %7 = icmp ne ptr %6, null
  br i1 %7, label %8, label %20

8:                                                ; preds = %5
  %9 = load ptr, ptr %3, align 8
  %10 = getelementptr inbounds %struct.elem, ptr %9, i32 0, i32 0
  %11 = load ptr, ptr %10, align 8
  %12 = icmp ne ptr %11, null
  br i1 %12, label %13, label %20

13:                                               ; preds = %8
  %14 = load ptr, ptr %3, align 8
  %15 = getelementptr inbounds %struct.elem, ptr %14, i32 0, i32 0
  %16 = load ptr, ptr %15, align 8
  %17 = getelementptr inbounds %struct.elem, ptr %16, i32 0, i32 0
  %18 = load ptr, ptr %17, align 8
  %19 = icmp ne ptr %18, null
  br label %20

20:                                               ; preds = %13, %8, %5
  %21 = phi i1 [ false, %8 ], [ false, %5 ], [ %19, %13 ]
  br i1 %21, label %22, label %44

22:                                               ; preds = %20
  %23 = load ptr, ptr %3, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %23) #8, !srcloc !32
  %24 = load ptr, ptr %3, align 8
  %25 = getelementptr inbounds %struct.elem, ptr %24, i32 0, i32 0
  %26 = load ptr, ptr %25, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %26) #8, !srcloc !33
  %27 = load ptr, ptr %3, align 8
  %28 = getelementptr inbounds %struct.elem, ptr %27, i32 0, i32 0
  %29 = load ptr, ptr %28, align 8
  %30 = getelementptr inbounds %struct.elem, ptr %29, i32 0, i32 0
  %31 = load ptr, ptr %30, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %31) #8, !srcloc !34
  %32 = load ptr, ptr %3, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %32) #8, !srcloc !35
  %33 = load ptr, ptr %3, align 8
  %34 = getelementptr inbounds %struct.elem, ptr %33, i32 0, i32 0
  %35 = load ptr, ptr %34, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %35) #8, !srcloc !36
  %36 = load ptr, ptr %3, align 8
  %37 = getelementptr inbounds %struct.elem, ptr %36, i32 0, i32 0
  %38 = load ptr, ptr %37, align 8
  %39 = getelementptr inbounds %struct.elem, ptr %38, i32 0, i32 0
  %40 = load ptr, ptr %39, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %40) #8, !srcloc !37
  %41 = load ptr, ptr %3, align 8
  %42 = getelementptr inbounds %struct.elem, ptr %41, i32 0, i32 0
  %43 = load ptr, ptr %42, align 8
  store ptr %43, ptr %3, align 8
  br label %5, !llvm.loop !38

44:                                               ; preds = %20
  ret void
}

; Function Attrs: allocsize(1)
declare ptr @realloc(ptr noundef, i64 noundef) #4

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @list_length(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  store i32 0, ptr %3, align 4
  br label %4

4:                                                ; preds = %7, %1
  %5 = load ptr, ptr %2, align 8
  %6 = icmp ne ptr %5, null
  br i1 %6, label %7, label %13

7:                                                ; preds = %4
  %8 = load i32, ptr %3, align 4
  %9 = add nsw i32 %8, 1
  store i32 %9, ptr %3, align 4
  %10 = load ptr, ptr %2, align 8
  %11 = getelementptr inbounds %struct.elem, ptr %10, i32 0, i32 0
  %12 = load ptr, ptr %11, align 8
  store ptr %12, ptr %2, align 8
  br label %4, !llvm.loop !39

13:                                               ; preds = %4
  %14 = load i32, ptr %3, align 4
  ret i32 %14
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @list_concat(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = load ptr, ptr %3, align 8
  %7 = icmp ne ptr %6, null
  br i1 %7, label %8, label %11

8:                                                ; preds = %2
  %9 = load ptr, ptr %3, align 8
  %10 = load ptr, ptr %9, align 8
  br label %12

11:                                               ; preds = %2
  br label %12

12:                                               ; preds = %11, %8
  %13 = phi ptr [ %10, %8 ], [ null, %11 ]
  store ptr %13, ptr %5, align 8
  %14 = load ptr, ptr %5, align 8
  %15 = icmp ne ptr %14, null
  br i1 %15, label %19, label %16

16:                                               ; preds = %12
  %17 = load ptr, ptr %4, align 8
  %18 = load ptr, ptr %3, align 8
  store ptr %17, ptr %18, align 8
  br label %39

19:                                               ; preds = %12
  br label %20

20:                                               ; preds = %25, %19
  %21 = load ptr, ptr %5, align 8
  %22 = getelementptr inbounds %struct.elem, ptr %21, i32 0, i32 0
  %23 = load ptr, ptr %22, align 8
  %24 = icmp ne ptr %23, null
  br i1 %24, label %25, label %29

25:                                               ; preds = %20
  %26 = load ptr, ptr %5, align 8
  %27 = getelementptr inbounds %struct.elem, ptr %26, i32 0, i32 0
  %28 = load ptr, ptr %27, align 8
  store ptr %28, ptr %5, align 8
  br label %20, !llvm.loop !40

29:                                               ; preds = %20
  %30 = load ptr, ptr %4, align 8
  %31 = load ptr, ptr %5, align 8
  %32 = getelementptr inbounds %struct.elem, ptr %31, i32 0, i32 0
  store ptr %30, ptr %32, align 8
  %33 = load ptr, ptr %4, align 8
  %34 = icmp ne ptr %33, null
  br i1 %34, label %35, label %39

35:                                               ; preds = %29
  %36 = load ptr, ptr %5, align 8
  %37 = load ptr, ptr %4, align 8
  %38 = getelementptr inbounds %struct.elem, ptr %37, i32 0, i32 1
  store ptr %36, ptr %38, align 8
  br label %39

39:                                               ; preds = %16, %35, %29
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @list_split(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store i32 %2, ptr %6, align 4
  %11 = load ptr, ptr %4, align 8
  %12 = icmp ne ptr %11, null
  br i1 %12, label %14, label %13

13:                                               ; preds = %3
  br label %80

14:                                               ; preds = %3
  %15 = load ptr, ptr %4, align 8
  %16 = call i32 @list_length(ptr noundef %15)
  store i32 %16, ptr %7, align 4
  %17 = load i32, ptr %7, align 4
  %18 = load i32, ptr %6, align 4
  %19 = sdiv i32 %17, %18
  store i32 %19, ptr %8, align 4
  store i32 0, ptr %9, align 4
  store i32 0, ptr %10, align 4
  br label %20

20:                                               ; preds = %77, %14
  %21 = load i32, ptr %10, align 4
  %22 = load i32, ptr %6, align 4
  %23 = icmp slt i32 %21, %22
  br i1 %23, label %24, label %80

24:                                               ; preds = %20
  store i32 0, ptr %9, align 4
  %25 = load ptr, ptr %4, align 8
  %26 = load ptr, ptr %5, align 8
  %27 = load i32, ptr %10, align 4
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds ptr, ptr %26, i64 %28
  store ptr %25, ptr %29, align 8
  %30 = load ptr, ptr %4, align 8
  %31 = icmp ne ptr %30, null
  br i1 %31, label %32, label %35

32:                                               ; preds = %24
  %33 = load ptr, ptr %4, align 8
  %34 = getelementptr inbounds %struct.elem, ptr %33, i32 0, i32 1
  store ptr null, ptr %34, align 8
  br label %35

35:                                               ; preds = %32, %24
  br label %36

36:                                               ; preds = %53, %35
  %37 = load ptr, ptr %4, align 8
  %38 = icmp ne ptr %37, null
  br i1 %38, label %39, label %51

39:                                               ; preds = %36
  %40 = load i32, ptr %9, align 4
  %41 = add nsw i32 %40, 1
  store i32 %41, ptr %9, align 4
  %42 = load i32, ptr %8, align 4
  %43 = icmp slt i32 %41, %42
  br i1 %43, label %49, label %44

44:                                               ; preds = %39
  %45 = load i32, ptr %10, align 4
  %46 = load i32, ptr %6, align 4
  %47 = sub nsw i32 %46, 1
  %48 = icmp eq i32 %45, %47
  br label %49

49:                                               ; preds = %44, %39
  %50 = phi i1 [ true, %39 ], [ %48, %44 ]
  br label %51

51:                                               ; preds = %49, %36
  %52 = phi i1 [ false, %36 ], [ %50, %49 ]
  br i1 %52, label %53, label %57

53:                                               ; preds = %51
  %54 = load ptr, ptr %4, align 8
  %55 = getelementptr inbounds %struct.elem, ptr %54, i32 0, i32 0
  %56 = load ptr, ptr %55, align 8
  store ptr %56, ptr %4, align 8
  br label %36, !llvm.loop !41

57:                                               ; preds = %51
  %58 = load ptr, ptr %4, align 8
  %59 = icmp ne ptr %58, null
  br i1 %59, label %60, label %77

60:                                               ; preds = %57
  %61 = load ptr, ptr %4, align 8
  %62 = getelementptr inbounds %struct.elem, ptr %61, i32 0, i32 0
  %63 = load ptr, ptr %62, align 8
  store ptr %63, ptr %4, align 8
  %64 = load ptr, ptr %4, align 8
  %65 = icmp ne ptr %64, null
  br i1 %65, label %66, label %76

66:                                               ; preds = %60
  %67 = load ptr, ptr %4, align 8
  %68 = getelementptr inbounds %struct.elem, ptr %67, i32 0, i32 1
  %69 = load ptr, ptr %68, align 8
  %70 = icmp ne ptr %69, null
  br i1 %70, label %71, label %76

71:                                               ; preds = %66
  %72 = load ptr, ptr %4, align 8
  %73 = getelementptr inbounds %struct.elem, ptr %72, i32 0, i32 1
  %74 = load ptr, ptr %73, align 8
  %75 = getelementptr inbounds %struct.elem, ptr %74, i32 0, i32 0
  store ptr null, ptr %75, align 8
  br label %76

76:                                               ; preds = %71, %66, %60
  br label %77

77:                                               ; preds = %76, %57
  %78 = load i32, ptr %10, align 4
  %79 = add nsw i32 %78, 1
  store i32 %79, ptr %10, align 4
  br label %20, !llvm.loop !42

80:                                               ; preds = %13, %20
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @list_from_chunks(ptr noundef %0, ptr noundef %1, i32 noundef %2, i32 noundef %3) #0 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca ptr, align 8
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store i32 %2, ptr %7, align 4
  store i32 %3, ptr %8, align 4
  %11 = load i32, ptr %7, align 4
  %12 = add nsw i32 %11, 1
  %13 = load i32, ptr %8, align 4
  %14 = srem i32 %12, %13
  store i32 %14, ptr %9, align 4
  %15 = load ptr, ptr %5, align 8
  %16 = load ptr, ptr %15, align 8
  %17 = icmp ne ptr %16, null
  br i1 %17, label %18, label %28

18:                                               ; preds = %4
  %19 = load ptr, ptr %6, align 8
  %20 = icmp ne ptr %19, null
  br i1 %20, label %21, label %28

21:                                               ; preds = %18
  %22 = load ptr, ptr %6, align 8
  %23 = load i32, ptr %9, align 4
  %24 = sext i32 %23 to i64
  %25 = getelementptr inbounds ptr, ptr %22, i64 %24
  %26 = load ptr, ptr %25, align 8
  %27 = icmp ne ptr %26, null
  br i1 %27, label %29, label %28

28:                                               ; preds = %21, %18, %4
  br label %170

29:                                               ; preds = %21
  %30 = load ptr, ptr %6, align 8
  %31 = load i32, ptr %7, align 4
  %32 = sext i32 %31 to i64
  %33 = getelementptr inbounds ptr, ptr %30, i64 %32
  %34 = load ptr, ptr %33, align 8
  store ptr %34, ptr %10, align 8
  %35 = load ptr, ptr %10, align 8
  %36 = icmp ne ptr %35, null
  br i1 %36, label %37, label %40

37:                                               ; preds = %29
  %38 = load ptr, ptr %10, align 8
  %39 = getelementptr inbounds %struct.elem, ptr %38, i32 0, i32 1
  store ptr null, ptr %39, align 8
  br label %40

40:                                               ; preds = %37, %29
  br label %41

41:                                               ; preds = %61, %40
  %42 = load ptr, ptr %10, align 8
  %43 = icmp ne ptr %42, null
  br i1 %43, label %44, label %59

44:                                               ; preds = %41
  %45 = load ptr, ptr %10, align 8
  %46 = getelementptr inbounds %struct.elem, ptr %45, i32 0, i32 0
  %47 = load ptr, ptr %46, align 8
  %48 = icmp ne ptr %47, null
  br i1 %48, label %49, label %59

49:                                               ; preds = %44
  %50 = load ptr, ptr %10, align 8
  %51 = getelementptr inbounds %struct.elem, ptr %50, i32 0, i32 0
  %52 = load ptr, ptr %51, align 8
  %53 = load ptr, ptr %6, align 8
  %54 = load i32, ptr %9, align 4
  %55 = sext i32 %54 to i64
  %56 = getelementptr inbounds ptr, ptr %53, i64 %55
  %57 = load ptr, ptr %56, align 8
  %58 = icmp ne ptr %52, %57
  br label %59

59:                                               ; preds = %49, %44, %41
  %60 = phi i1 [ false, %44 ], [ false, %41 ], [ %58, %49 ]
  br i1 %60, label %61, label %65

61:                                               ; preds = %59
  %62 = load ptr, ptr %10, align 8
  %63 = getelementptr inbounds %struct.elem, ptr %62, i32 0, i32 0
  %64 = load ptr, ptr %63, align 8
  store ptr %64, ptr %10, align 8
  br label %41, !llvm.loop !43

65:                                               ; preds = %59
  %66 = load ptr, ptr %10, align 8
  %67 = icmp ne ptr %66, null
  br i1 %67, label %68, label %71

68:                                               ; preds = %65
  %69 = load ptr, ptr %10, align 8
  %70 = getelementptr inbounds %struct.elem, ptr %69, i32 0, i32 0
  store ptr null, ptr %70, align 8
  br label %71

71:                                               ; preds = %68, %65
  %72 = load ptr, ptr %6, align 8
  %73 = load i32, ptr %9, align 4
  %74 = sext i32 %73 to i64
  %75 = getelementptr inbounds ptr, ptr %72, i64 %74
  %76 = load ptr, ptr %75, align 8
  %77 = load ptr, ptr %5, align 8
  store ptr %76, ptr %77, align 8
  store ptr %76, ptr %10, align 8
  %78 = load ptr, ptr %10, align 8
  %79 = icmp ne ptr %78, null
  br i1 %79, label %80, label %83

80:                                               ; preds = %71
  %81 = load ptr, ptr %10, align 8
  %82 = getelementptr inbounds %struct.elem, ptr %81, i32 0, i32 1
  store ptr null, ptr %82, align 8
  br label %83

83:                                               ; preds = %80, %71
  br label %84

84:                                               ; preds = %163, %83
  %85 = load i32, ptr %9, align 4
  %86 = load i32, ptr %7, align 4
  %87 = icmp ne i32 %85, %86
  br i1 %87, label %88, label %95

88:                                               ; preds = %84
  %89 = load ptr, ptr %6, align 8
  %90 = load i32, ptr %9, align 4
  %91 = sext i32 %90 to i64
  %92 = getelementptr inbounds ptr, ptr %89, i64 %91
  %93 = load ptr, ptr %92, align 8
  %94 = icmp ne ptr %93, null
  br label %95

95:                                               ; preds = %88, %84
  %96 = phi i1 [ false, %84 ], [ %94, %88 ]
  br i1 %96, label %97, label %164

97:                                               ; preds = %95
  %98 = load i32, ptr %9, align 4
  %99 = add nsw i32 %98, 1
  %100 = load i32, ptr %8, align 4
  %101 = srem i32 %99, %100
  store i32 %101, ptr %9, align 4
  br label %102

102:                                              ; preds = %133, %97
  %103 = load ptr, ptr %10, align 8
  %104 = icmp ne ptr %103, null
  br i1 %104, label %105, label %120

105:                                              ; preds = %102
  %106 = load ptr, ptr %10, align 8
  %107 = getelementptr inbounds %struct.elem, ptr %106, i32 0, i32 0
  %108 = load ptr, ptr %107, align 8
  %109 = icmp ne ptr %108, null
  br i1 %109, label %110, label %120

110:                                              ; preds = %105
  %111 = load ptr, ptr %10, align 8
  %112 = getelementptr inbounds %struct.elem, ptr %111, i32 0, i32 0
  %113 = load ptr, ptr %112, align 8
  %114 = load ptr, ptr %6, align 8
  %115 = load i32, ptr %9, align 4
  %116 = sext i32 %115 to i64
  %117 = getelementptr inbounds ptr, ptr %114, i64 %116
  %118 = load ptr, ptr %117, align 8
  %119 = icmp ne ptr %113, %118
  br label %120

120:                                              ; preds = %110, %105, %102
  %121 = phi i1 [ false, %105 ], [ false, %102 ], [ %119, %110 ]
  br i1 %121, label %122, label %137

122:                                              ; preds = %120
  %123 = load ptr, ptr %10, align 8
  %124 = getelementptr inbounds %struct.elem, ptr %123, i32 0, i32 0
  %125 = load ptr, ptr %124, align 8
  %126 = icmp ne ptr %125, null
  br i1 %126, label %127, label %133

127:                                              ; preds = %122
  %128 = load ptr, ptr %10, align 8
  %129 = load ptr, ptr %10, align 8
  %130 = getelementptr inbounds %struct.elem, ptr %129, i32 0, i32 0
  %131 = load ptr, ptr %130, align 8
  %132 = getelementptr inbounds %struct.elem, ptr %131, i32 0, i32 1
  store ptr %128, ptr %132, align 8
  br label %133

133:                                              ; preds = %127, %122
  %134 = load ptr, ptr %10, align 8
  %135 = getelementptr inbounds %struct.elem, ptr %134, i32 0, i32 0
  %136 = load ptr, ptr %135, align 8
  store ptr %136, ptr %10, align 8
  br label %102, !llvm.loop !44

137:                                              ; preds = %120
  %138 = load ptr, ptr %10, align 8
  %139 = icmp ne ptr %138, null
  br i1 %139, label %140, label %148

140:                                              ; preds = %137
  %141 = load ptr, ptr %6, align 8
  %142 = load i32, ptr %9, align 4
  %143 = sext i32 %142 to i64
  %144 = getelementptr inbounds ptr, ptr %141, i64 %143
  %145 = load ptr, ptr %144, align 8
  %146 = load ptr, ptr %10, align 8
  %147 = getelementptr inbounds %struct.elem, ptr %146, i32 0, i32 0
  store ptr %145, ptr %147, align 8
  br label %148

148:                                              ; preds = %140, %137
  %149 = load ptr, ptr %6, align 8
  %150 = load i32, ptr %9, align 4
  %151 = sext i32 %150 to i64
  %152 = getelementptr inbounds ptr, ptr %149, i64 %151
  %153 = load ptr, ptr %152, align 8
  %154 = icmp ne ptr %153, null
  br i1 %154, label %155, label %163

155:                                              ; preds = %148
  %156 = load ptr, ptr %10, align 8
  %157 = load ptr, ptr %6, align 8
  %158 = load i32, ptr %9, align 4
  %159 = sext i32 %158 to i64
  %160 = getelementptr inbounds ptr, ptr %157, i64 %159
  %161 = load ptr, ptr %160, align 8
  %162 = getelementptr inbounds %struct.elem, ptr %161, i32 0, i32 1
  store ptr %156, ptr %162, align 8
  br label %163

163:                                              ; preds = %155, %148
  br label %84, !llvm.loop !45

164:                                              ; preds = %95
  %165 = load ptr, ptr %10, align 8
  %166 = icmp ne ptr %165, null
  br i1 %166, label %167, label %170

167:                                              ; preds = %164
  %168 = load ptr, ptr %10, align 8
  %169 = getelementptr inbounds %struct.elem, ptr %168, i32 0, i32 0
  store ptr null, ptr %169, align 8
  br label %170

170:                                              ; preds = %28, %167, %164
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @shuffle(ptr noundef %0, i64 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i64 %1, ptr %4, align 8
  %8 = load i64, ptr %4, align 8
  %9 = icmp ugt i64 %8, 1
  br i1 %9, label %10, label %46

10:                                               ; preds = %2
  store i64 0, ptr %5, align 8
  br label %11

11:                                               ; preds = %42, %10
  %12 = load i64, ptr %5, align 8
  %13 = load i64, ptr %4, align 8
  %14 = sub i64 %13, 1
  %15 = icmp ult i64 %12, %14
  br i1 %15, label %16, label %45

16:                                               ; preds = %11
  %17 = load i64, ptr %5, align 8
  %18 = call i32 @rand()
  %19 = sext i32 %18 to i64
  %20 = load i64, ptr %4, align 8
  %21 = load i64, ptr %5, align 8
  %22 = sub i64 %20, %21
  %23 = udiv i64 2147483647, %22
  %24 = add i64 %23, 1
  %25 = udiv i64 %19, %24
  %26 = add i64 %17, %25
  store i64 %26, ptr %6, align 8
  %27 = load ptr, ptr %3, align 8
  %28 = load i64, ptr %6, align 8
  %29 = getelementptr inbounds i32, ptr %27, i64 %28
  %30 = load i32, ptr %29, align 4
  store i32 %30, ptr %7, align 4
  %31 = load ptr, ptr %3, align 8
  %32 = load i64, ptr %5, align 8
  %33 = getelementptr inbounds i32, ptr %31, i64 %32
  %34 = load i32, ptr %33, align 4
  %35 = load ptr, ptr %3, align 8
  %36 = load i64, ptr %6, align 8
  %37 = getelementptr inbounds i32, ptr %35, i64 %36
  store i32 %34, ptr %37, align 4
  %38 = load i32, ptr %7, align 4
  %39 = load ptr, ptr %3, align 8
  %40 = load i64, ptr %5, align 8
  %41 = getelementptr inbounds i32, ptr %39, i64 %40
  store i32 %38, ptr %41, align 4
  br label %42

42:                                               ; preds = %16
  %43 = load i64, ptr %5, align 8
  %44 = add i64 %43, 1
  store i64 %44, ptr %5, align 8
  br label %11, !llvm.loop !46

45:                                               ; preds = %11
  br label %46

46:                                               ; preds = %45, %2
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @test_set(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  store ptr %0, ptr %6, align 8
  store ptr %1, ptr %7, align 8
  %8 = load ptr, ptr %7, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %8) #8, !srcloc !47
  %9 = load ptr, ptr %7, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %9) #8, !srcloc !48
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !49
  %10 = load ptr, ptr @traverser, align 8
  %11 = load ptr, ptr %6, align 8
  call void %10(ptr noundef %11)
  %12 = load ptr, ptr %7, align 8
  store ptr %12, ptr %3, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !18
  %13 = load i64, ptr @timestamp, align 8
  store i64 %13, ptr %4, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !19
  %14 = load ptr, ptr %3, align 8
  call void asm sideeffect "LDR x10, [$0]", "r,~{x10},~{memory}"(ptr %14) #8, !srcloc !20
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !21
  %15 = load i64, ptr @timestamp, align 8
  store i64 %15, ptr %5, align 8
  call void asm sideeffect "DMB SY\0AISB SY", "~{memory}"() #8, !srcloc !22
  %16 = load i64, ptr %5, align 8
  %17 = load i64, ptr %4, align 8
  %18 = sub i64 %16, %17
  %19 = trunc i64 %18 to i32
  ret i32 %19
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @tests_avg(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store i32 %2, ptr %6, align 4
  store i32 0, ptr %7, align 4
  store i32 0, ptr %8, align 4
  store i32 0, ptr %9, align 4
  store i32 0, ptr %10, align 4
  store i32 0, ptr %7, align 4
  br label %11

11:                                               ; preds = %26, %3
  %12 = load i32, ptr %7, align 4
  %13 = load i32, ptr %6, align 4
  %14 = icmp slt i32 %12, %13
  br i1 %14, label %15, label %29

15:                                               ; preds = %11
  %16 = load ptr, ptr %4, align 8
  %17 = load ptr, ptr %5, align 8
  %18 = call i32 @test_set(ptr noundef %16, ptr noundef %17)
  store i32 %18, ptr %9, align 4
  %19 = load i32, ptr %9, align 4
  %20 = icmp ult i32 %19, 800
  br i1 %20, label %21, label %25

21:                                               ; preds = %15
  %22 = load i32, ptr %9, align 4
  %23 = load i32, ptr %10, align 4
  %24 = add i32 %23, %22
  store i32 %24, ptr %10, align 4
  br label %25

25:                                               ; preds = %21, %15
  br label %26

26:                                               ; preds = %25
  %27 = load i32, ptr %7, align 4
  %28 = add nsw i32 %27, 1
  store i32 %28, ptr %7, align 4
  br label %11, !llvm.loop !50

29:                                               ; preds = %11
  %30 = load i32, ptr %10, align 4
  %31 = uitofp i32 %30 to float
  %32 = load i32, ptr %6, align 4
  %33 = sitofp i32 %32 to float
  %34 = fdiv float %31, %33
  %35 = fptosi float %34 to i32
  store i32 %35, ptr %8, align 4
  %36 = load i32, ptr %8, align 4
  %37 = sext i32 %36 to i64
  %38 = load i64, ptr @threshold, align 8
  %39 = icmp ugt i64 %37, %38
  %40 = zext i1 %39 to i32
  ret i32 %40
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.log.f64(double) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.ceil.f64(double) #5

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #2 = { allocsize(0,1) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #4 = { allocsize(1) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #6 = { allocsize(0,1) }
attributes #7 = { allocsize(0) }
attributes #8 = { nounwind }
attributes #9 = { allocsize(1) }

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
!13 = distinct !{!13, !7}
!14 = distinct !{!14, !7}
!15 = distinct !{!15, !7}
!16 = distinct !{!16, !7}
!17 = !{i64 2148427024}
!18 = !{i64 2148425835, i64 2148425844}
!19 = !{i64 2148425903, i64 2148425912}
!20 = !{i64 2148425951}
!21 = !{i64 2148426034, i64 2148426043}
!22 = !{i64 2148426100, i64 2148426109}
!23 = distinct !{!23, !7}
!24 = !{i64 2148427180}
!25 = distinct !{!25, !7}
!26 = distinct !{!26, !7}
!27 = distinct !{!27, !7}
!28 = !{i64 2148427296}
!29 = !{i64 2148427376}
!30 = !{i64 2148427456, i64 2148427465}
!31 = distinct !{!31, !7}
!32 = !{i64 2148426508}
!33 = !{i64 2148426587}
!34 = !{i64 2148426672}
!35 = !{i64 2148426763}
!36 = !{i64 2148426842}
!37 = !{i64 2148426927}
!38 = distinct !{!38, !7}
!39 = distinct !{!39, !7}
!40 = distinct !{!40, !7}
!41 = distinct !{!41, !7}
!42 = distinct !{!42, !7}
!43 = distinct !{!43, !7}
!44 = distinct !{!44, !7}
!45 = distinct !{!45, !7}
!46 = distinct !{!46, !7}
!47 = !{i64 2148427827}
!48 = !{i64 2148427909}
!49 = !{i64 2148427991, i64 2148428000}
!50 = distinct !{!50, !7}
