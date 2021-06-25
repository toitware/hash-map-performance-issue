// Copyright (C) 2021 Toitware ApS. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

package java;

import java.util.LinkedHashSet;

class Fly {
  public static void main(String[] args) {
    // Warm up.
    for (int i = 1; i <= 10; i++) {
      double us = fifo(1 << 10, false);
    }

    // Benchmark.
    double total = 0.0;
    for (int i = 1; i <= 10; i++) {
      long size = 1 << i;
      double us = fifo(size, true);
      total += us;
    }
    System.out.println("Average 2-1024: " + total / 10);
    total = 0.0;
    for (int i = 11; i <= 20; i++) {
      long size = 1 << i;
      double us = fifo(size, true);
      total += us;
    }
    System.out.println("Average 2048-1M: " + total / 10);
  }

  static double fifo(long size, boolean do_print) {
    long iterations = 1024 / size;
    if (iterations == 0) iterations = 1;
    long total = 0;
    var start = System.nanoTime();
    for (int i = 0; i < iterations; i++) {
      var set = new LinkedHashSet<Long>();
      for (long j = 0; j < size; j++) {
        set.add(j);
      }
      while (!set.isEmpty()) {
        var f = first(set);
        total += f;
        set.remove(f);
      }
    }
    var end = System.nanoTime();
    double us_per_op = (end - start) / 1000.0 / size / iterations;
    if (do_print) {
      System.out.println("" + (total & 1) + " " + size + " iterations, " + us_per_op + "us per operation");
    }
    return us_per_op;
  }

  static Long first(LinkedHashSet<Long> set) {
    if (set.isEmpty()) return null;
    var it = set.iterator();
    return it.next();
  }
}
