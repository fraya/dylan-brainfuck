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
    <instruction>,
    instruction-line,
    instruction-column;

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
    parse-instruction;
  
  // Memory
  
  export
    $memory-size,
    <memory-cell>,
    <memory-cells>,
    <memory-pointer>,
    memory-increment,
    memory-decrement,
    memory-forth,
    memory-back;

  // Memory instructions 
  
  export
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
    program-not-finished?,
    program-forth;
  
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
