Module: brainfuck-impl
Synopsis: Brainfuck core 
Author: Fernando Raya
Copyright: GPLv3


define abstract class <instruction> (<object>) end;

// Miscelanous instructions

define class <comment> (<instruction>)
  constant slot comment-char :: <character>,
    init-keyword: char:;
end;

define class <reset-to-zero> (<instruction>) end;


// Errors

define class <brainfuck-error> (<error>)
  constant slot error-instruction :: <instruction>,
    init-keyword: instruction:;
end;

define class <mismatch-jump-error> (<brainfuck-error>) end;
