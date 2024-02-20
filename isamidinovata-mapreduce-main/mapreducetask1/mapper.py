#!/usr/bin/env python3.6

import random
import sys

for line in sys.stdin:
    identifier = line.strip()
    random_number = random.randint(1, 100)
    print(f"{random_number}\t{identifier}")
