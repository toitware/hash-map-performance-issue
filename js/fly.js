// Copyright (C) 2021 Toitware ApS. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be found
// in the LICENSE file.

function fifo(size, do_print) {
  let iterations = Math.floor(1024 / size)
  if (iterations == 0) iterations = 1

  let start = process.hrtime()
  for (var i = 0; i < iterations; i++) {
    let set = new Set()
    for (var j = 0; j < size; j++) {
      set.add(j)
    }
    while (set.size != 0) {
      var element = first(set)
      set.delete(element);
    }
  }
  let end = process.hrtime()

  let elapsed = get_us(start, end)

  var us_per_op = elapsed / size / iterations;

  if (do_print) {
    console.log("" + size + " iterations, " + us_per_op + "us per operation");
  }
  return us_per_op;
}

function first(set) {
  for (let element of set) {
    return element;
  }
}

function get_us(start, end) {
  var seconds = end[0] - start[0]
  var us = end[1] - start[1]

  return seconds * 1000000 + us / 1000
}

// Warm up.
for (var i = 1; i <= 10; i++) fifo(1 << i, false)

// Benchmark.
var us = 0.0
for (var i = 1; i <= 10; i++) {
  us += fifo(1 << i, true)
}
console.log("Average 2-1024: " + us/10)
us = 0.0;
for (var i = 11; i <= 20; i++) {
  us += fifo(1 << i, true)
  if (us > 100) break
}
console.log("Average 2048-1M: " + us/10)
