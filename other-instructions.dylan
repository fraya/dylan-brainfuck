Module: brainfuck-impl
Synopsis: Miscelanous instructions 
Author: Fernando Raya
Copyright: GPLv3

/// Comment

define class <comment> (<instruction>)
  constant slot comment-char :: <character>,
    init-keyword: char:;
end;

define method print-object
    (comment :: <comment>, s :: <stream>) => ()
  write-element(s, comment.comment-char)
end;

define method execute
   (instruction :: <comment>, bf :: <interpreter>) => ()
  // do nothing
end;

/// Reset to zero instruction

define class <reset-to-zero> (<instruction>) end;

define method print-object
    (instruction :: <reset-to-zero>, s :: <stream>) => ()
  write-element(s, 'Z');
end;

define method execute
    (instruction :: <reset-to-zero>, bf :: <interpreter>) => ()
  bf.memory.memory-item := 0
end;
