Module: dylan-user

define library brainfuck-test-suite
  use common-dylan;
  use io;
  use testworks;
  use brainfuck;
end library;

define module brainfuck-test-suite
  use common-dylan;
  use format-out;
  use testworks;
  use brainfuck;
  use brainfuck-impl;

  export
    brainfuck-test-suite;
end module;
