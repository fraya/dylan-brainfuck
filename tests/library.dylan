Module: dylan-user

define library dylan-brainfuck-tests
  use common-dylan;
  use testworks;
  use brainfuck;
end;

define module dylan-brainfuck-tests
  use common-dylan;
  use testworks;
  use brainfuck;
  export dylan-brainfuck-test-suite;
end;
