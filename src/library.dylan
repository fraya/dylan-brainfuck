Module: dylan-user

define library brainfuck
  use common-dylan;
  use io;
  use system;
  use strings;
end library brainfuck;

define module brainfuck
  use common-dylan;
  use common-extensions;
  use format;
  use format-out;
  use streams;
  use file-system;
  use print;
  use standard-io;

  export
    <brainfuck>,
    pp,
    dp;
  export
    <program>;
  export
    run;
end module brainfuck;
