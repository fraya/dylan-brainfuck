Module: brainfuck
Synopsis: Brainfuck interpreter 
Author: Fernando Raya
Copyright: GPLv3

define abstract class <instruction> (<object>)
end class;

define sealed class <comment> (<instruction>)
end class;

define abstract class <tape-instruction> (<instruction>)
  slot amount :: <integer>, init-value: 1, init-keyword: amount:
end class;

define sealed class <increment-data> (<tape-instruction>)
end class;

define sealed class <decrement-data> (<tape-instruction>)
end class;

define sealed class <increment-pointer> (<tape-instruction>)
end class;

define sealed class <decrement-pointer> (<tape-instruction>)
end class;

define abstract class <jump> (<instruction>)
end class;

define sealed class <jump-forward> (<jump>)
end class;

define sealed class <jump-backward> (<jump>)
end class;

define abstract class <precalculated-jump> (<jump>)
  constant slot address :: <integer>, init-keyword: address:;
end class;

define sealed class <precalculated-jump-forward> (<precalculated-jump>)
end class;

define sealed class <precalculated-jump-backward> (<precalculated-jump>)
end class;

define sealed class <input> (<instruction>)
end class;

define sealed class <output> (<instruction>)
end class;

define function make-instruction
  (c :: <byte>)
  => (instruction :: <instruction>)
  select (as(<character>, c))
    '>'
      => make(<increment-pointer>);
    '<'
      => make(<decrement-pointer>);
    '+'
      => make(<increment-data>);
    '-'
      => make(<decrement-data>);
    '.'
      => make(<output>);
    ','
      => make(<input>);
    '['
      => make(<jump-forward>);
    ']'
      => make(<jump-backward>);
    otherwise
      => make(<comment>)
  end select
end function;

define method print-object
  (i :: <comment>, s :: <stream>) => ()
  write-element(s, '#')
end method;

define method print-object
  (i :: <tape-instruction>, s :: <stream>) => ()
  if (i.amount > 1)
    for (i from 1 below i.amount)
      write-element(s, 'X')
    end
  end if
end method;

define method print-object
  (i :: <increment-data>, s :: <stream>) => ()
  next-method();
  write-element(s, '+')
end method;

define method print-object
  (i :: <decrement-data>, s :: <stream>) => ()
  write-element(s, '-')
end method;

define method print-object
  (i :: <increment-pointer>, s :: <stream>) => ()
  next-method();  
  write-element(s, '>')
end method;

define method print-object
  (i :: <decrement-pointer>, s :: <stream>) => ()
  next-method();  
  write-element(s, '<')
end method;

define method print-object
  (i :: <jump-forward>, s :: <stream>) => ()
  write-element(s, '[')
end method;

define method print-object
  (i :: <jump-backward>, s :: <stream>) => ()
  write-element(s, ']')
end method;

define method print-object
  (i :: <precalculated-jump-forward>, s :: <stream>) => ()
  write-element(s, 'X');
  write-element(s, '[')
end method;

define method print-object
  (i :: <precalculated-jump-backward>, s :: <stream>) => ()
  write-element(s, 'X');
  write-element(s, '[')
end method;

define method print-object
  (i :: <input>, s :: <stream>) => ()
  write-element(s, ',')
end method;

define method print-object
  (i :: <output>, s :: <stream>) => ()
  write-element(s, '.')
end method;

