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

define abstract class <memory-instruction> (<instruction>)
  slot instruction-amount :: <integer> = 1,
    init-keyword: amount:;
end;

define abstract class <memory-data-instruction> (<memory-instruction>)
end;

define abstract class <memory-pointer-instruction> (<memory-instruction>)
end;

define class <memory-data-increment> (<memory-data-instruction>)
end;

define class <memory-data-decrement> (<memory-data-instruction>)
end;

define class <memory-pointer-increment> (<memory-pointer-instruction>)
end;

define class <memory-pointer-decrement> (<memory-pointer-instruction>)
end;

define class <reset-to-zero> (<memory-data-instruction>)
end;

define abstract class <jump-instruction> (<instruction>)
  slot jump-address :: false-or(<program-pointer>) = #f,
    init-keyword: address:;
end;

define class <jump-forward>  (<jump-instruction>)
end;

define class <jump-backward> (<jump-instruction>)
end;

define abstract class <io-instruction> (<instruction>)
end;

define class <input> (<io-instruction>)
end;

define class <output> (<io-instruction>)
end;

define class <comment> (<instruction>)
  constant slot comment-char :: <character>,
    init-keyword: char:;
end;
