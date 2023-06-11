Module: brainfuck-test-suite

//////////////////////////////////////////////////////////////////////////////
//
// Read a program
//
//////////////////////////////////////////////////////////////////////////////

define test test-parse-instructions ()
  assert-instance?(<comment>, as(<instruction>, '#'));
  assert-instance?(<memory-data-instruction>, as(<instruction>, '+'));
  assert-instance?(<memory-data-instruction>, as(<instruction>, '-'));
  assert-instance?(<memory-pointer-instruction>, as(<instruction>, '>'));
  assert-instance?(<memory-pointer-instruction>, as(<instruction>, '<'));
  assert-instance?(<jump-forward>, as(<instruction>, '['));
  assert-instance?(<jump-backward>, as(<instruction>, ']'));
  assert-instance?(<input>, as(<instruction>, ','));
  assert-instance?(<output>, as(<instruction>, '.'));
end;

define test test-print-instructions ()
  let stream = make(<string-stream>, direction: #"output");
  let i01 = make(<comment>, char: '#');
  let i02 = make(<memory-data-instruction>, amount: 2);
  let i03 = make(<memory-data-instruction>, amount: -3);
  let i04 = make(<memory-pointer-instruction>, amount: 4);
  let i05 = make(<memory-pointer-instruction>, amount: -5);
  let i06 = make(<jump-forward>);
  let i07 = make(<jump-forward>, address: 6);
  let i08 = make(<jump-backward>);
  let i09 = make(<jump-backward>, address: 7);
  let i10 = make(<input>);
  let i11 = make(<output>);
  format(stream, "%=%=%=%=%=%=%=%=%=%=%=", 
                 i01, i02, i03, i04, i05, i06, i07, i08, i09, i10, i11); 
  assert-equal("#+2-3>4<5[[6]]7,.", stream-contents(stream));
end test;

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
  add!(expected, make(<memory-data-instruction>, amount: 3));
  add!(expected, make(<memory-pointer-instruction>, amount: 0));
  add!(expected, make(<memory-data-instruction>, amount: -3));
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
  test test-print-instructions;
  test test-remove-comments;
  test test-reset-to-zero;
  test test-group-instructions;
  test test-precalculate-jumps;
end;

// Use `_build/bin/dylan-brainfuck-test-suite --help` to see options.
run-test-application();
