all: spectre

PASS = -mspeculative-load-hardening

cleanmain:
	rm main.ll main.s

spectre:
	/Users/jsliu/llvm-project/build/bin/clang ${PASS} main.c eviction.c counter_thread.c -o spectre -O0

main.ll: main.c
	/Users/jsliu/llvm-project/build/bin/clang -O0 ${PASS} -emit-llvm -S main.c -Xclang -disable-O0-optnone -o main.ll

main.s: main.ll
	/Users/jsliu/llvm-project/build/bin/clang -S -o main.s main.ll



david:
	otool -tvV spectre > out

vizmain:
	opt -disable-output -passes="dot-cfg" main.ll
	cat .main.dot | dot -Tpdf > main.pdf


clean:
	rm spectre *.o *.ll *.s

