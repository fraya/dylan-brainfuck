Module: brainfuck-impl
Synopsis: Comment instruction 
Author: Fernando Raya
Copyright: GPLv3

define sealed class <comment> (<instruction>)
  inherited slot instruction-symbol = '#';
end;

define method execute
    (instruction :: <comment>, bf :: <interpreter>) => ()
  // do nothing
end;
