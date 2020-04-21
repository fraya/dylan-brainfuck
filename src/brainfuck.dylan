Module: brainfuck
Synopsis: Brainfuck interpreter 
Author: Fernando Raya
Copyright: GPLv3

define constant <program> =
  limited(<stretchy-vector>, of: <instruction>);

define constant <tape> =
  limited(<stretchy-vector>, of: <byte>);

define method print-object
  (program :: <program>, stream :: <stream>)
  => ()
  do (method (x) print(x, stream) end, program)
end method;

define method print-object
  (tape :: <tape>, stream :: <stream>)
  => ()
  do (method (x) print(x, stream) end, tape)
end method;

define class <brainfuck> (<object>)
  slot pp :: <integer>,
    init-value: 0;
  slot program :: <program>,
    required-init-keyword: program:;
  slot dp :: <integer>,
    init-value: 0;
  slot tape :: <tape>,
    init-keyword: tape:,
    init-value: make(<tape>, size: 3000, fill: 0);
end class <brainfuck>;

define method print-object
  (bf :: <brainfuck>, stream :: <stream>)
  => ()
  format(stream, "prog[%d] = '%=' ", bf.pp, bf.program[bf.pp]);
  format(stream, "tape[%d] = '%='", bf.dp, bf.tape[bf.dp]);
end method;

define method finished?
  (bf :: <brainfuck>)
  => (result :: <boolean>)
  bf.pp < 0 | bf.pp >= bf.program.size - 1
end method finished?;

define function make-instruction
  (c :: <byte>)
  => (instruction :: <instruction>)
  select (as(<character>, c))
    '>' =>
      make(<increment-pointer>);
    '<' =>
      make(<decrement-pointer>);
    '+' =>
      make(<increment-data>);
    '-' =>
      make(<decrement-data>);
    '.' =>
      make(<output>);
    ',' =>
      make(<input>);
    '[' =>
      make(<jump-forward>);
    ']' =>
      make(<jump-backward>);
    otherwise =>
      make(<comment>);
  end select;
end function;

///
/// Read a brainfuck <program> from a <stream>
///
define method read-program
  (stream :: <stream>)
  => (program :: <program>)
  let program = make(<program>);
  while (~stream-at-end?(stream))
    let character   = read-element(stream);
    let instruction = make-instruction(character);
    if (~instance?(instruction, <comment>))
      add!(program, instruction)
    end if;
  end while;
  program 
end method read-program;

define method run
  (bf :: <brainfuck>)
  => ()
  while (~finished?(bf))
    //format-out("%=\n", bf);
    //force-out();
    execute(bf, bf.program[bf.pp]);
    bf.pp := bf.pp + 1;
  end while;
end method run;

define method tokenize
  (filename :: <string>)
  => (program :: <program>)
  let is = make(<byte-file-stream>, locator: filename);
  let rs = read-program(is);
  close(is);
  rs
end method tokenize;

define function main
  (name :: <string>, arguments :: <vector>)
  let status = 0;
  if (arguments.size < 1)
    format-out("Usage: %s <program>\n", application-name());
    status := 1;
  else
    let program  = tokenize(arguments[0]);
    let bf       = make(<brainfuck>, program: program);
    run(bf);
  end;
  exit-application(status);
end function main;

main(application-name(), application-arguments());
