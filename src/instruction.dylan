Module: brainfuck
Synopsis: Brainfuck interpreter 
Author: Fernando Raya
Copyright: GPLv3

define class <instruction> (<object>)
end class <instruction>;

define class <comment> (<instruction>)
end class <comment>;

define class <tape-instruction> (<instruction>)
  slot amount :: <integer>, init-value: 1, init-keyword: amount:
end class <tape-instruction>;

define class <increment-data> (<tape-instruction>)
end class <increment-data>;

define class <decrement-data> (<tape-instruction>)
end class <decrement-data>;

define class <increment-pointer> (<tape-instruction>)
end class <increment-pointer>;

define class <decrement-pointer> (<tape-instruction>)
end class <decrement-pointer>;

define class <jump> (<instruction>)
end class <jump>;

define class <jump-forward> (<jump>)
end class <jump-forward>;

define class <jump-backward> (<jump>)
end class <jump-backward>;

define class <input> (<instruction>)
end class <input>;

define class <output> (<instruction>)
end class <output>;

define method print-object(i :: <comment>, s :: <stream>) => ()
  write-element(s, '#')
end method print-object;

define method print-object(i :: <increment-data>, s :: <stream>) => ()
  write-element(s, '+')
end method print-object;

define method print-object(i :: <decrement-data>, s :: <stream>) => ()
  write-element(s, '-')
end method print-object;

define method print-object(i :: <increment-pointer>, s :: <stream>) => ()
  write-element(s, '>')
end method;

define method print-object(i :: <decrement-pointer>, s :: <stream>) => ()
  write-element(s, '<')
end method;

define method print-object(i :: <jump-forward>, s :: <stream>) => ()
  write-element(s, '[')
end method;

define method print-object(i :: <jump-backward>, s :: <stream>) => ()
  write-element(s, ']')
end method;

define method print-object(i :: <input>, s :: <stream>)
  => ()
  write-element(s, ',')
end method;

define method print-object(i :: <output>, s :: <stream>) => ()
  write-element(s, '.')
end method;

