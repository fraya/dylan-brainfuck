Module: brainfuck-impl
Synopsis: Brainfuck errors  
Author: Fernando Raya
Copyright: GPLv3

define class <brainfuck-error> (<error>)
  constant slot error-instruction :: <instruction>,
    init-keyword: instruction:;
end;

define class <mismatch-jump-error> (<brainfuck-error>)
end;
