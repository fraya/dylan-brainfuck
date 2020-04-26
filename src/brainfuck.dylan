Module: brainfuck
Synopsis: Brainfuck interpreter 
Author: Fernando Raya
Copyright: GPLv3

define constant <tape> =
  limited(<vector>, of: <byte>);

define class <brainfuck> (<object>)
  slot pp :: <integer>,
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
  (bf :: <brainfuck>, stream :: <stream>) => ()
  format(stream, "prog[%d] = '%=' ", bf.pp, bf.program[bf.pp]);
  format(stream, "tape[%d] = '%='", bf.dp, bf.tape[bf.dp]);
end method;

define inline method finished?
  (bf :: <brainfuck>) => (result :: <boolean>)
  bf.pp < 0 | bf.pp >= bf.program.size - 1
end method finished?;

define method run
  (bf :: <brainfuck>) => ()
  while(~finished?(bf))
    execute(bf, bf.program[bf.pp]);
    bf.pp := bf.pp + 1;
  end;
end method run;
  
define function main
  (name :: <string>, arguments :: <vector>)  
  if (arguments.size < 1)
    format-out("Usage:\n\t%s <program> [optimization]\n", application-name());
    format-out("optimization:\n");
    format-out("\t0: No optimization\n");
    format-out("\t1: Remove comments\n");
    format-out("\t2: Level 1 and group instructions\n");
    format-out("\t3: Level 2 and precalculate jumps\n");
    exit-application(1);
  end;

  let program = read-program(arguments[0]);

  let optimization-level = 3;
  if (arguments.size > 1)
    optimization-level := string-to-integer(arguments[1]);
  end;
  
  let optimized = optimize-program(program, optimization-level);
  
  let bf = make(<brainfuck>, program: optimized);
  run(bf);  
  exit-application(0);
end function main;

main(application-name(), application-arguments());
