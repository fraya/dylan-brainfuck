Module: brainfuck-impl
Synopsis: Memory instructions
Author: Fernando Raya
Copyright: GPLv3

// Memory instruction

define abstract class <memory-instruction> (<instruction>)
  slot memory-amount :: <integer>,
    required-init-keyword: amount:;
end;

define method print-object
    (instruction :: <memory-instruction>, s :: <stream>)
 => ()
  unless (abs(instruction.memory-amount) = 1)
    write(s, integer-to-string(abs(instruction.memory-amount)))
  end;
end;

define method \=
    (this :: <memory-instruction>, that :: <memory-instruction>)
 => (equals? :: <boolean>)
      next-method()
    & this.memory-amount = that.memory-amount
end;

// Memory data instruction

define class <memory-data-instruction> (<memory-instruction>) end;

define method print-object
    (instruction :: <memory-data-instruction>, s :: <stream>)
 => ()
  write-element(s, if (instruction.memory-amount > 0) '+' else '-' end);
  next-method();
end;

define method execute
    (instruction :: <memory-data-instruction>, bf :: <interpreter>)
 => ()
  memory-increment(bf, instruction.memory-amount)
end;

// Memory pointer instruction

define class <memory-pointer-instruction> (<memory-instruction>) end;

define method execute
    (instruction :: <memory-pointer-instruction>, bf :: <interpreter>)
 => ()
  memory-forth(bf, instruction.memory-amount)
end;

define method print-object
    (instruction :: <memory-pointer-instruction>, s :: <stream>)
 => ()
  let symbol = if (instruction.memory-amount > 0) '>' else '<' end;
  write-element(s, symbol);
  next-method();
end;
