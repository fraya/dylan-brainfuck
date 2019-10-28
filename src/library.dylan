Module: dylan-user

define library brainfuck
  use common-dylan;
  use io;
end library brainfuck;

define module brainfuck
  use common-dylan;
  use streams;
  use streams-internals;
  use format-out;

  export
    <brainfuck>,
    pp,pp-setter,
    dp, dp-setter;
  export
    <program>, program-setter;
  export
    tape-setter;
  export
    increment-data, decrement-data,
    increment-pointer, decrement-pointer;
  export
    run;
end module brainfuck;
