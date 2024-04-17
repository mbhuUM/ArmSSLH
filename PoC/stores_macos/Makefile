all: spectre

PASS =
PATH = /Users/jsliu/llvm-project/build

main.ll: main.c
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/clang -emit-llvm -S main.c -Xclang -disable-O0-optnone -o main.ll

main.o: main.ll
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/opt -O0 ${PASS} main.ll -o main.o

eviction.ll: eviction.c
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/clang -emit-llvm -S eviction.c -Xclang -disable-O0-optnone -o eviction.ll

eviction.o: eviction.ll
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/opt ${PASS} eviction.ll -o eviction.o

counter_thread.ll: counter_thread.c
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/clang -emit-llvm -S counter_thread.c -Xclang -disable-O0-optnone -o counter_thread.ll

counter_thread.o: counter_thread.ll
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/opt ${PASS} counter_thread.ll -o counter_thread.o

spectre: main.o eviction.o counter_thread.o 
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/clang main.o eviction.o counter_thread.o -o spectre -O0



clean:
	rm spectre *.o *.ll

