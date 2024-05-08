Module: brainfuck-impl
Synopsis: Comment instruction 
Author: Fernando Raya
Copyright: GPLv3

define class <comment> (<instruction>)
  constant slot comment-char :: <character>,
    init-keyword: char:;
end;

define method execute
   (instruction :: <comment>, bf :: <interpreter>) => ()
 // do nothing
end;

define method print-object
    (comment :: <comment>, s :: <stream>) => ()
  write-element(s, comment.comment-char)
end;
