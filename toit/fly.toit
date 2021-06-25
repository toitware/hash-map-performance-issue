// Copyright (C) 2021 Toitware ApS. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

fifo size/int do_print/bool -> float:
  iterations := 1024 / size
  if iterations == 0: iterations = 1
  duration := Duration.of:
    iterations.repeat:
      set := {}
      size.repeat:
        set.add it
      while not set.is_empty:
        element := set.first
        set.remove element
  us_per_op := duration.in_us.to_float / size / iterations
  if do_print:
    print "$size iterations, $(%.3f us_per_op)us per operation"
  return us_per_op

main:
  // Warm up.
  10.repeat:
    fifo 1 << (it + 1) false

  // Benchmark.
  us := 0.0
  10.repeat:
    us += fifo 1 << (it + 1) true
  print "Average 2-1024: $(%.3f us/10)"
  us = 0.0
  10.repeat:
    us += fifo 1 << (it + 11) true
  print "Average 2048-1M: $(%.3f us/10)"
