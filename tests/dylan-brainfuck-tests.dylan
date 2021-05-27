Module:    dylan-brainfuck-tests
Synopsis:  dylan brainfuck tests
Author:    Fernando Raya

define test test-make-instruction-comment ()
  assert-instance?(<comment>, make(<instruction>, char: '?'));
end;

define suite brainfuck-instruction-suite ()
  test test-make-instruction-comment;
end;
  
define suite dylan-brainfuck-test-suite ()
  suite brainfuck-instruction-suite;
end;

run-test-application();
