Module: brainfuck-impl
Synopsis: I/O instructions 
Author: Fernando Raya
Copyright: GPLv3

////////////////////////////////////////////////////////////////////////
//
// Memory classes hierarchy 
//
////////////////////////////////////////////////////////////////////////

define abstract class <io-instruction> (<instruction>)
end;

define class <input> (<io-instruction>)
  inherited slot instruction-symbol = ',';
end;

define class <output> (<io-instruction>)
  inherited slot instruction-symbol = '.';
end;

////////////////////////////////////////////////////////////////////////
//
// Execute methods
//
////////////////////////////////////////////////////////////////////////

define method execute
    (instruction :: <output>, bf :: <interpreter>) => ()
  format-out("%c", as(<character>, bf.interpreter-memory.memory-item));
  force-out();
end;

define method execute
    (instruction :: <input>, bf :: <interpreter>) => ()
  error("Not implemented yet")
end;

////////////////////////////////////////////////////////////////////////
//
// Print objects
//
////////////////////////////////////////////////////////////////////////

define method print-object
    (input :: <input>, s :: <stream>) => ()
  write-element(s, ',');
end;

define method print-object
    (output :: <output>, s :: <stream>) => ()
  write-element(s, '.');
end;
