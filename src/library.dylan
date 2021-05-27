Module: dylan-user

define library brainfuck
  use common-dylan;
  use io;
  use system;
  use strings;
  export brainfuck;
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
    program,
    tape,
    pp,
    dp;
  export
    <program>,
    <tape>;
  export
    <instruction>,
    <comment>,
    <tape-instruction>,
    <increment-data>,
    <decrement-data>,
    <increment-pointer>,
    <decrement-pointer>,
    <jump>,
    <jump-forward>,
    <jump-backward>,
    <precalculated-jump>,
    <precalculated-jump-forward>,
    <input>,
    <output>;
  export
    read-program,
    optimize-program,
    run;
end module brainfuck;
