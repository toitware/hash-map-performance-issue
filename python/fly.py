# Copyright (C) 2021 Toitware ApS. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be found
# in the LICENSE file.

import sys
if sys.implementation.name == 'micropython':
  import utime
  def time_ms():
    return utime.ticks_ms()
else:
  import time
  def time_ms():
    return time.time() * 1000.0

def fifo(size, do_print):
    iterations = 1024 // size
    if iterations == 0:
        iterations = 1

    start = time_ms()

    for it in range(iterations):
        my_dict = {}
        for i in range(size):
            my_dict[i] = i

        while len(my_dict) > 0:
            remove_first(my_dict)

    end = time_ms()

    duration = end - start

    us_per_op = duration * 1000.0 / size / iterations

    if do_print:
        print("%d iterations, %fus per operation" % (size, us_per_op))

    return us_per_op

def remove_first(my_dict):
    i = iter(my_dict)
    elt = next(i)
    del my_dict[elt]
    return elt

# Warm up.
for s in range(10):
    fifo(1 << (s + 1), False)

# Benchmark.
us = 0.0
for s in range(10):
    us += fifo(1 << (s + 1), True)
print("Average 2-1024: %0.2f" % (us / 10.0))

us = 0.0
done = False
for s in range(10):
    us += fifo(1 << (s + 11), True)
    if s == 9: done = True
    if us > 100: break

if done:
    print("Average 2048-1M: %0.2f" % (us / 10.0))
