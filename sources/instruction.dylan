Module: brainfuck-impl
Synopsis: Brainfuck's instructions 
Author: Fernando Raya
Copyright: GPLv3

define abstract class <instruction> (<object>)
  constant each-subclass slot instruction-symbol :: <character>;
end;

define method print-object
    (instruction :: <instruction>, stream :: <stream>) => ()
  write-element(stream, instruction.instruction-symbol)
end;

define function instruction-table
    (type :: <class>, #rest types)
 => (table :: <table>)
  let table = make(<table>);
  let instructions = map(make, add(types, type));
  for (instruction in instructions)
    table[instruction.instruction-symbol] := object-class(instruction)
  end;
  table
end instruction-table;
