Module: dylan-user

define library brainfuck-app
  use common-dylan;
  use io;
  use brainfuck;
end library brainfuck-app;

define module brainfuck-app
  use common-dylan;
  use common-extensions;
  use format-out;
  use brainfuck;
end module brainfuck-app;
