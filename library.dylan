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

  // Errors
  
  create
    <brainfuck-error>,
    error-instruction,
    <mismatch-jump-error>;

  // Memory
  
  create
    <memory>,
    memory-pointer,
    memory-item;

  // Instructions
  
  create
    <instruction>;

  // Program
  
  create
    <program>,
    read-program,
    run-brainfuck-program,
    optimize-program;

  create
    <interpreter>,
    program-pointer;
  
end module;

define module brainfuck-impl
  use common-dylan;
  use byte-vector;
  use file-system;
  use format;
  use format-out;
  use locators;
  use print;
  use standard-io;
  use streams;
  
  use brainfuck;

  // Additional exports for use by test suite.

  // Memory
  
  export
    $memory-size,
    <memory-pointer>,
    memory-increment,
    memory-forth;

  // Memory instructions 
  
  export
    <memory-instruction>,
    memory-amount,
    memory-amount-setter,
    <memory-data-instruction>,
    <memory-pointer-instruction>,
    <reset-to-zero>;

  // Program exports
  
  export
    current-instruction,
    program-not-finished?,
    program-at,
    program-forth,
    program-back;
  
  // Jumps
 
  export
    <jump-instruction>,
    <jump-forward>,
    <jump-backward>;

  // IO instructions
  
  export
    <io-instruction>,
    <input>,
    <output>;

  // Miscelaneous instructions

  export
    <comment>,
    <reset-to-zero>;

  export
    execute,
    program-remove-comments,
    reset-to-zero,
    group-instructions,
    precalculate-jumps;
  
end module;
