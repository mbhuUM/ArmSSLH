all: spectre

PASS = 

main.ll: main.c
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/clang -emit-llvm -S main.c -Xclang -disable-O0-optnone -o main.ll

main.o: main.ll
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/opt ${PASS} main.ll -o main.o

eviction.ll: eviction.c
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/clang -emit-llvm -S eviction.c -Xclang -disable-O0-optnone -o eviction.ll

eviction.o: eviction.ll
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/opt ${PASS} eviction.ll -o eviction.o

counter_thread.ll: counter_thread.c
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/clang -emit-llvm -S counter_thread.c -Xclang -disable-O0-optnone -o counter_thread.ll

counter_thread.o: counter_thread.ll
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/opt ${PASS} counter_thread.ll -o counter_thread.o

spectre.ll: spectre.c
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/clang -emit-llvm -S spectre.c -Xclang -disable-O0-optnone -o spectre.ll

spectre.o: spectre.ll
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/opt ${PASS} spectre.ll -o spectre.o

spectre: main.o eviction.o counter_thread.o spectre.o
	/Users/jsliu/Downloads/llvm-project-llvmorg-17.0.6/build/bin/clang main.o eviction.o counter_thread.o spectre.o -o spectre



clean:
	rm spectre *.o *.ll

