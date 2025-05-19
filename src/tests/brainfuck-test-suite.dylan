Module: brainfuck-test-suite

///////////////////////////////////////////////////////////////////////////////
//
// Test instructions
//
//////////////////////////////////////////////////////////////////////////////

define test memory-data-increment-test ()
  let bf = run!(as(<program>, "+"));
  expect-equal(1, bf.bf-pp);
  expect-equal(1, bf.bf-memory[bf.bf-mp]);
end test;

define suite instruction-test-suite ()
  test memory-data-increment-test;
end suite;

//////////////////////////////////////////////////////////////////////////////
//
// Read a program
//
//////////////////////////////////////////////////////////////////////////////

define test test-parse-instructions ()
  expect-instance?(<memory-data-increment>, parse-instruction('+'));
  expect-instance?(<memory-data-decrement>, parse-instruction('-'));
  expect-instance?(<memory-pointer-increment>, parse-instruction('>'));
  expect-instance?(<memory-pointer-decrement>, parse-instruction('<'));
  expect-instance?(<jump-forward>, parse-instruction('['));
  expect-instance?(<jump-backward>, parse-instruction(']'));
  expect-instance?(<input>, parse-instruction(','));
  expect-instance?(<output>, parse-instruction('.'));
end;

//////////////////////////////////////////////////////////////////////////////
//
// Optimization tests
//
//////////////////////////////////////////////////////////////////////////////

define test test-reset-to-zero ()
  let source    = as(<program>, "[-]");
  let optimized = reset-to-zero(source);
  let expected  = vector(make(<reset-to-zero>));
  assert-equal(expected, optimized, "Replace '[-]' with 'Z'");
 end;

define test test-group-instructions ()
  let program  = as(<program>, "[[+++<<<>>>---]]");
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
  let program   = as(<program>, "[++++]");
  let optimized = precalculate-jumps(program);
  assert-equal(make(<jump-forward>, address: 5), optimized.first); 
end;

define suite optimization-test-suite ()
  test test-reset-to-zero;
  test test-group-instructions;
  test test-precalculate-jumps;
end suite;

//////////////////////////////////////////////////////////////////////////////
//
// All tests
//
//////////////////////////////////////////////////////////////////////////////


define suite brainfuck-test-suite ()
  test test-parse-instructions;
  suite instruction-test-suite;
  suite optimization-test-suite;
end;

// Use `_build/bin/dylan-brainfuck-test-suite --help` to see options.
run-test-application();
