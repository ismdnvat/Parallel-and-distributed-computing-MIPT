#!/usr/bin/env python3.6

import random
import sys

identifier = random.randint(1, 5)
line_out = ""

for line in sys.stdin:
    try:
        str = line.strip().split('\t')[1]
    except ValueError as e:
        continue

    if identifier == 1:
        print(line_out + str)
        line_out = ""
        identifier = random.randint(1, 5)
    else:
        identifier -= 1
        line_out += str + ","

if line_out != "":
    print(line_out.strip(','))
