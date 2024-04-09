#!/usr/bin/python3
import statistics
import csv
import sys
import subprocess as oss
import numpy as np
import matplotlib.pyplot as plt
import pathlib as path
import os


def check_clang_version():
    # This command calls 'clang --version' and captures the output
    # version_info = oss.check_output(['clang', '--version']).decode('utf-8')
	version_info = os.system("clang --version")
    # print(version_info)

def build():
	# check_clang_version()
	# oss.call(['pwd'])
	os.system('clang main.c -Wno- -O0')

def run():
	oss.call(['bash', 'run.bash'])

def modify_line(file_name, line_num, new_instruction):
	lines = open(file_name, 'r').readlines()
	lines[line_num] = new_instruction
	out = open(file_name, 'w')
	out.writelines(lines)
	out.close();

def read_line(file_name):
	lines = open(file_name, 'r').readlines()
	return lines[0]


def main(repeat_time = 250, start_time=0):
	oss.call(['mkdir','data'])
	results = [0] * repeat_time
	threshold = 220
	for i in range(start_time,repeat_time+1):
		modify_line('main.c', 29, 'asm volatile (".rept ' + str(i) + ';\\n\\tfsqrt d0, d0;\\nfmul d0, d0, d0;\\n.endr;"); }\n')
		# modify_line('./main.c', 29, 'asm volatile (\".rept ' + str(i) + '\");' + '\n')
		build()
		for j in range(1,101):
			run()
			results[i-1] = results[i-1] + int(read_line('tmp.txt'))
		print('', '%3d' % i, '', results[i-1] / 100)

	with open('data/slow_value2.txt', 'w') as f:
		for result in results:
			f.write(str(result/100))
			f.write('\n') 

if __name__ == "__main__":
	caffeinate_process = oss.Popen(['caffeinate'])
	print("caffeinated activated")
	if(len(sys.argv) > 1):
		print("inside if statement")
		main(int(sys.argv[1]), int(sys.argv[2]))
		caffeinate_process.terminate()
	
	else:
	    main()

