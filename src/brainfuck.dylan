Module: brainfuck
Synopsis: Brainfuck interpreter 
Author: Fernando Raya
Copyright: GPLv3

define constant <tape> =
  limited(<vector>, of: <byte>);

define class <brainfuck> (<object>)
  slot pp :: <program-pointer>,
    init-value: 0;
  constant slot program :: <program>,
    required-init-keyword: program:;
  slot dp :: <integer>,
    init-value: 0;
  constant slot tape :: <tape>,
    init-keyword: tape:,
    init-value: make(<tape>, size: 30000, fill: 0);
end class <brainfuck>;

define method print-object
    (bf :: <brainfuck>, stream :: <stream>)
 => ()
  format(stream, "prog[%d] = '%=' ", bf.pp, bf.program[bf.pp]);
  format(stream, "tape[%d] = '%='", bf.dp, bf.tape[bf.dp])
end method;

define inline method finished?
    (bf :: <brainfuck>)
 => (result :: <boolean>)
  bf.pp < 0 | bf.pp >= bf.program.size - 1
end method finished?;

define method run
    (bf :: <brainfuck>)
 => ()
  while(~finished?(bf))
    execute(bf, bf.program[bf.pp]);
    bf.pp := bf.pp + 1;
  end
end method run;
  
