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
    (instruction :: <output>, bf :: <bf>) => ()
  format-out("%c", as(<character>, bf.bf-memory[bf.bf-mp]));
  force-out();
end;

define method execute
    (instruction :: <input>, bf :: <bf>) => ()
  error("Not implemented yet")
end;

define sealed domain execute (<output>, <bf>);
define sealed domain execute (<input>, <bf>);
