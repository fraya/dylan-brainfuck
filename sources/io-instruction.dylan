Module: brainfuck-impl
Synopsis: I/O instructions 
Author: Fernando Raya
Copyright: GPLv3

////////////////////////////////////////////////////////////////////////
//
// Memory classes hierarchy 
//
////////////////////////////////////////////////////////////////////////

define sealed abstract class <io-instruction> (<instruction>)
end;

define sealed class <input> (<io-instruction>)
  inherited slot instruction-symbol = ',';
end;

define sealed class <output> (<io-instruction>)
  inherited slot instruction-symbol = '.';
end;

////////////////////////////////////////////////////////////////////////
//
// Execute methods
//
////////////////////////////////////////////////////////////////////////

define method execute
    (instruction :: <output>, bf :: <interpreter>) => ()
  format-out("%c", as(<character>, bf.interpreter-memory[bf.mp]));
  force-out();
end;

define method execute
    (instruction :: <input>, bf :: <interpreter>) => ()
  error("Not implemented yet")
end;

define sealed domain execute (<output>, <interpreter>);
define sealed domain execute (<input>, <interpreter>);
