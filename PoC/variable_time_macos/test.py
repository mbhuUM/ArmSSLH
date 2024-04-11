import os
import subprocess


def modify_line(file_name, line_num, new_instruction):
	lines = open(file_name, 'r').readlines()
	lines[line_num] = new_instruction
	out = open(file_name, 'w')
	out.writelines(lines)
	out.close()
	
def compile():
	os.system("clang main.c eviction.c counter_thread.c -O0")
	
def run(val):	
	output =os.popen('./a.out ' + val).read()
	return output

def parser(attack_output):
	tab = attack_output.split()[0:31]
	
	return tab


def main():
	# thresholds = []
    arr = [0] * 32
    val = 3735927486
    compile()
    for i in range(1000):
        output = run(val)
        tab = parser(output)
        for j in range(32):
            arr[j] += tab[j]
    print(arr)
    return arr
		

if __name__ == "__main__":
	main()