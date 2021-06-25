// Copyright (C) 2021 Toitware ApS. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

double fifo(int size, bool do_print) {
  int iterations = 1024 ~/ size;
  if (iterations == 0) iterations = 1;

  var watch = new Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    var set = new Set();
    for (int j = 0; j < size; j++) {
      set.add(j);
    }
    while (set.isNotEmpty) {
      int element = set.first;
      set.remove(element);
    }
  }
  watch.stop();

  var us_per_op = watch.elapsedMicroseconds.toDouble() / size / iterations;

  if (do_print) {
    print("$size iterations, ${us_per_op}us per operation");
  }
  return us_per_op;
}

void main() {
  // Warm up.
  for (int i = 1; i <= 10; i++) fifo(1 << i, false);

  // Benchmark.
  var us = 0.0;
  for (int i = 1; i <= 10; i++) {
    us += fifo(1 << i, true);
  }
  print("Average 2-1024: ${us/10}");
  us = 0.0;
  for (int i = 11; i <= 20; i++) {
    us += fifo(1 << i, true);
    if (us > 150) break;
  }
  print("Average 2048-1M: ${us/10}");
}
