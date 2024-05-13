Module: dylan-user

define library brainfuck
  use common-dylan;
  use io;
  use system;

  export
    brainfuck,
    brainfuck-impl;
end library;

// Interface module creates public API

define module brainfuck

  // Memory
  
  create
    <memory>,
    <memory-pointer>;

  // Instructions
  
  create
    <instruction>;
    
  // Program
  
  create
    <program>,
    read-program,
    run,
    optimize-program;

  create
    <bf>,
    bf-pp;
  
end module;

define module brainfuck-impl
  use common-dylan;
  use common-extensions;
  use byte-vector;
  use file-system;
  use format;
  use format-out;
  use locators;
  use print;
  use streams;
  use brainfuck;

  // Instruction
  export
    parse-character;
  
  // Memory
  
  export
    $memory-size,
    <memory-cell>;
  
  // Memory instructions 
  
  export
    bf-memory,
    bf-mp,
    <memory-instruction>,
    instruction-amount,
    <memory-data-instruction>,
    <memory-data-increment>,
    <memory-data-decrement>,
    <memory-pointer-instruction>,
    <memory-pointer-increment>,
    <memory-pointer-decrement>,
    <reset-to-zero>;

  // Program exports
  
  export
    current-instruction,
    instruction-at,
    program-not-finished?;
  
  // Jumps
  
  export
    <jump-instruction>,
    <jump-forward>,
    <jump-backward>;
  
  export
    <io-instruction>,
    <input>,
    <output>;

  export
    <reset-to-zero>;

  export
    execute,
    reset-to-zero,
    group-instructions,
    precalculate-jumps;
  
end module;
