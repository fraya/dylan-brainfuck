Module: brainfuck-test-suite

define test test-memory ()
  let memory = make(<memory>);
  memory-increment(memory, 1);
  assert-equal(1, memory.memory-item);
  memory-decrement(memory, 1);
  assert-equal(0, memory.memory-item);
end;

//////////////////////////////////////////////////////////////////////////////
//
// Read a program
//
//////////////////////////////////////////////////////////////////////////////

define test test-parse-instructions ()
  expect-instance?(<memory-data-increment>, parse-character('+'));
  expect-instance?(<memory-data-decrement>, parse-character('-'));
  expect-instance?(<memory-pointer-increment>, parse-character('>'));
  expect-instance?(<memory-pointer-decrement>, parse-character('<'));
  expect-instance?(<jump-forward>, parse-character('['));
  expect-instance?(<jump-backward>, parse-character(']'));
  expect-instance?(<input>, parse-character(','));
  expect-instance?(<output>, parse-character('.'));
end;

//////////////////////////////////////////////////////////////////////////////
//
// Reset to zero tests
//
//////////////////////////////////////////////////////////////////////////////

define test test-reset-to-zero ()
  let source    = read-program("[-]");
  let optimized = reset-to-zero(source);
  let expected  = read-program("Z");
  assert-equal(expected, optimized, "Replace '[-]' with 'Z'");
 end;

define test test-group-instructions ()
  let program  = read-program("[[+++<<<>>>---]]");
  let expected = vector(make(<jump-forward>),
			make(<jump-forward>),
			make(<memory-data-increment>, amount: 3),
			make(<memory-pointer-decrement>, amount: 3),
			make(<memory-pointer-increment>, amount: 3),
			make(<memory-data-decrement>, amount: 3),
			make(<jump-backward>),
			make(<jump-backward>));
  assert-equal(expected, group-instructions(program));			    
end;

define test test-precalculate-jumps ()
  let program   = read-program("[++++]");
  let optimized = precalculate-jumps(program);
  assert-equal(make(<jump-forward>, address: 5), optimized.first); 
end;

define suite brainfuck-test-suite ()
  test test-parse-instructions;
  test test-reset-to-zero;
  test test-group-instructions;
  test test-precalculate-jumps;
end;

// Use `_build/bin/dylan-brainfuck-test-suite --help` to see options.
run-test-application();
