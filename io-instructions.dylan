Module: brainfuck-impl
Synopsis: IO instructions
Author: Fernando Raya
Copyright: GPLv3

// IO instructions

define abstract class <io-instruction> (<instruction>) end;

// Input instruction

define class <input> (<io-instruction>) end;

define method print-object
    (input :: <input>, s :: <stream>) => ()
  write-element(s, ',');
end;

define method execute
    (instruction :: <input>, bf :: <interpreter>) => ()
  error("Not implemented yet")
end;

// Output instruction

define class <output> (<io-instruction>) end;

define method print-object
    (output :: <output>, s :: <stream>) => ()
  write-element(s, '.');
end;

define method execute
    (instruction :: <output>, bf :: <interpreter>) => ()
  format(bf.interpreter-output-stream,
	 "%c", as(<character>, bf.memory.memory-item));
  force-out()
end;
