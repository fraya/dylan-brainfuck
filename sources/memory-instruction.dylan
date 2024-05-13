Module: brainfuck-impl
Synopsis: Instructions that change memory 
Author: Fernando Raya
Copyright: GPLv3

////////////////////////////////////////////////////////////////////////
//
// Memory classes hierarchy 
//
////////////////////////////////////////////////////////////////////////

define sealed abstract class <memory-instruction> (<instruction>)
  slot instruction-amount :: <integer> = 1,
    init-keyword: amount:;
end;

define sealed abstract class <memory-data-instruction> (<memory-instruction>)
end;

define sealed abstract class <memory-pointer-instruction> (<memory-instruction>)
end;

define sealed class <memory-data-increment> (<memory-data-instruction>)
  inherited slot instruction-symbol = '+';
end;

define sealed class <memory-data-decrement> (<memory-data-instruction>)
  inherited slot instruction-symbol = '-';
end;

define sealed class <reset-to-zero> (<memory-data-instruction>)
  inherited slot instruction-symbol = 'Z';
end;

define sealed class <memory-pointer-increment> (<memory-pointer-instruction>)
  inherited slot instruction-symbol = '>';
end;

define sealed class <memory-pointer-decrement> (<memory-pointer-instruction>)
  inherited slot instruction-symbol = '<';
end;

////////////////////////////////////////////////////////////////////////
//
// Execution methods on memory classes 
//
////////////////////////////////////////////////////////////////////////

define method execute
    (instruction :: <memory-data-increment>, bf :: <interpreter>)
 => ()
  bf.interpreter-memory[bf.mp] := bf.interpreter-memory[bf.mp] + instruction.instruction-amount
end;

define method execute
    (instruction :: <memory-data-decrement>, bf :: <interpreter>)
 => ()
  bf.interpreter-memory[bf.mp] := bf.interpreter-memory[bf.mp] - instruction.instruction-amount
end;

define method execute
    (instruction :: <memory-pointer-increment>, bf :: <interpreter>)
 => ()
  bf.mp := bf.mp + instruction.instruction-amount
end;

define method execute
    (instruction :: <memory-pointer-decrement>, bf :: <interpreter>)
 => ()
  bf.mp := bf.mp - instruction.instruction-amount
end;

define method execute
    (instruction :: <reset-to-zero>, bf :: <interpreter>) => ()
  bf.interpreter-memory[bf.mp] := 0
end;

define sealed domain execute (<memory-data-increment>, <interpreter>);
define sealed domain execute (<memory-data-decrement>, <interpreter>);
define sealed domain execute (<memory-pointer-increment>, <interpreter>);
define sealed domain execute (<memory-pointer-decrement>, <interpreter>);

////////////////////////////////////////////////////////////////////////
//
// Print memory instructions
//
////////////////////////////////////////////////////////////////////////

define method print-object
    (instruction :: <memory-instruction>, s :: <stream>) => ()
  unless (instruction.instruction-amount == 1) 
    write(s, integer-to-string(instruction.instruction-amount)) 
  end;
  next-method();
end;

////////////////////////////////////////////////////////////////////////
//
//  Equal methods
//
////////////////////////////////////////////////////////////////////////

define method \=
    (this :: <memory-data-instruction>, that :: <memory-data-instruction>)
 => (equals? :: <boolean>)
      object-class(this) = object-class(that)
    & this.instruction-amount = that.instruction-amount
end;

define sealed domain \= (<memory-data-instruction>, <memory-data-instruction>);
