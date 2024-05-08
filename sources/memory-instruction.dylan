Module: brainfuck-impl
Synopsis: Instructions that change memory 
Author: Fernando Raya
Copyright: GPLv3

////////////////////////////////////////////////////////////////////////
//
// Memory classes hierarchy 
//
////////////////////////////////////////////////////////////////////////

define abstract class <memory-instruction> (<instruction>)
  slot instruction-amount :: <integer> = 1,
    init-keyword: amount:;
end;

define abstract class <memory-data-instruction> (<memory-instruction>)
end;

define abstract class <memory-pointer-instruction> (<memory-instruction>)
end;

define class <memory-data-increment> (<memory-data-instruction>)
end;

define class <memory-data-decrement> (<memory-data-instruction>)
end;

define class <reset-to-zero> (<memory-data-instruction>)
end;

define class <memory-pointer-increment> (<memory-pointer-instruction>)
end;

define class <memory-pointer-decrement> (<memory-pointer-instruction>)
end;

////////////////////////////////////////////////////////////////////////
//
// Execution methods on memory classes 
//
////////////////////////////////////////////////////////////////////////

define method execute
    (instruction :: <memory-data-increment>, bf :: <interpreter>)
 => ()
  memory-increment(bf.interpreter-memory, instruction.instruction-amount)
end;

define method execute
    (instruction :: <memory-data-decrement>, bf :: <interpreter>)
 => ()
  memory-decrement(bf.interpreter-memory, instruction.instruction-amount)
end;

define method execute
    (instruction :: <memory-pointer-increment>, bf :: <interpreter>)
 => ()
  memory-forth(bf.interpreter-memory, instruction.instruction-amount)
end;

define method execute
    (instruction :: <memory-pointer-decrement>, bf :: <interpreter>)
 => ()
  memory-back(bf.interpreter-memory, instruction.instruction-amount);
end;

define method execute
    (instruction :: <reset-to-zero>, bf :: <interpreter>) => ()
  bf.interpreter-memory.memory-item := 0
end;

////////////////////////////////////////////////////////////////////////
//
// Print memory instructions
//
////////////////////////////////////////////////////////////////////////

define method print-object
    (instruction :: <memory-instruction>, s :: <stream>) => ()
  unless (instruction.instruction-amount == 1) 
    write(s, integer-to-string(instruction.instruction-amount)) 
  end
end;

define method print-object
    (instruction :: <memory-data-increment>, s :: <stream>) => ()
  write-element(s, '+');
  next-method();
end;

define method print-object
    (instruction :: <memory-data-decrement>, s :: <stream>) => ()
  write-element(s, '-');
  next-method();
end;

define method print-object
    (instruction :: <memory-pointer-increment>, s :: <stream>) => ()
  write-element(s, '>');
  next-method();
end;

define method print-object
    (instruction :: <memory-pointer-decrement>, s :: <stream>) => ()
  write-element(s, '<');
  next-method();
end;

define method print-object
    (instruction :: <reset-to-zero>, s :: <stream>) => ()
  write-element(s, 'Z');
end;