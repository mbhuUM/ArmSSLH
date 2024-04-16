all: spectre

main.ll: main.c
	~/llvm-project/llvm/bin/clang -emit-llvm -S main.c -Xclang -disable-O0-optnone -o main.ll

main.o: main.ll
	~/llvm-project/llvm/bin/opt --aarch64-slh-loads main.ll -o main.o

eviction.ll: eviction.c
	~/llvm-project/llvm/bin/clang -emit-llvm -S eviction.c -Xclang -disable-O0-optnone -o eviction.ll

eviction.o: eviction.ll
	~/llvm-project/llvm/bin/opt --aarch64-slh-loads eviction.ll -o eviction.o

counter_thread.ll: counter_thread.c
	~/llvm-project/llvm/bin/clang -emit-llvm -S counter_thread.c -Xclang -disable-O0-optnone -o counter_thread.ll

counter_thread.o: counter_thread.ll
	~/llvm-project/llvm/bin/opt --aarch64-slh-loads counter_thread.ll -o counter_thread.o

spectre: main.o eviction.o counter_thread.o
	clang main.o eviction.o counter_thread.o -o spectre


