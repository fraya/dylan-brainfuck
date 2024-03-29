Module: brainfuck-test-suite

//////////////////////////////////////////////////////////////////////////////
//
// Read a program
//
//////////////////////////////////////////////////////////////////////////////

define test test-parse-instructions ()
  assert-instance?(<comment>, parse-instruction('#'));
  assert-instance?(<memory-data-increment>, parse-instruction('+'));
  assert-instance?(<memory-data-decrement>, parse-instruction('-'));
  assert-instance?(<memory-pointer-increment>, parse-instruction('>'));
  assert-instance?(<memory-pointer-decrement>, parse-instruction('<'));
  assert-instance?(<jump-forward>, parse-instruction('['));
  assert-instance?(<jump-backward>, parse-instruction(']'));
  assert-instance?(<input>, parse-instruction(','));
  assert-instance?(<output>, parse-instruction('.'));
end;

//////////////////////////////////////////////////////////////////////////////
//
// Remove comments tests
//
//////////////////////////////////////////////////////////////////////////////

define test test-remove-comments ()
  let p1 = read-program("");
  assert-true(empty?(program-remove-comments(p1)));
  
  let p2 = read-program("$#");
  assert-true(empty?(program-remove-comments(p2)));
  
  let p3 = read-program("+#-");
  assert-equal(read-program("+-"), program-remove-comments(p3));
end;

//////////////////////////////////////////////////////////////////////////////
//
// Reset to zero tests
//
//////////////////////////////////////////////////////////////////////////////

define test test-reset-to-zero ()
  let program   = read-program("[-]");
  let optimized = reset-to-zero(program);
  let expected  = read-program(vector(make(<reset-to-zero>)));
  assert-equal(expected, optimized, "Replace '[-]' with 'Z'");
 end;

define test test-group-instructions ()
  let program  = read-program("[[+++<<<>>>---]]");
  let expected = make(<program>);
  add!(expected, make(<jump-forward>));
  add!(expected, make(<jump-forward>));
  add!(expected, make(<memory-data-increment>, amount: 3));
  add!(expected, make(<memory-pointer-decrement>, amount: 3));
  add!(expected, make(<memory-pointer-increment>, amount: 3));
  add!(expected, make(<memory-data-decrement>, amount: 3));
  add!(expected, make(<jump-backward>));
  add!(expected, make(<jump-backward>));
  assert-equal(expected, group-instructions(program));			    
end;

define test test-precalculate-jumps ()
  let program   = read-program("[++++]");
  let optimized = precalculate-jumps(program);
  assert-equal(make(<jump-forward>, address: 5), optimized.first); 
end;

define suite brainfuck-test-suite ()
  test test-parse-instructions;
  test test-remove-comments;
  test test-reset-to-zero;
  test test-group-instructions;
  test test-precalculate-jumps;
end;

// Use `_build/bin/dylan-brainfuck-test-suite --help` to see options.
run-test-application();
