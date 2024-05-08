Module: brainfuck-impl
Synopsis: Brainfuck's instructions 
Author: Fernando Raya
Copyright: GPLv3

define abstract class <instruction> (<object>)
  constant slot instruction-line   :: false-or(<integer>) = #f,
    init-keyword: line:;
  constant slot instruction-column :: false-or(<integer>) = #f,
    init-keyword: column:;
end;

define class <comment> (<instruction>)
  constant slot comment-char :: <character>,
    init-keyword: char:;
end;
