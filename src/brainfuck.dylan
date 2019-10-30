Module: brainfuck
Synopsis: Brainfuck interpreter 
Author: Fernando Raya
Copyright: GPLv3

define constant <program>
  = limited(<stretchy-vector>, of: <symbol>);

define constant <tape>
  = limited(<stretchy-vector>, of: <byte>);

define constant $default-tape-size :: <integer> = 3000;

///
///  Brainfuck abstract machine.
///
///  program::
///    Instructions in brainfuck's language
///  tape::
///    The memory of brainfuck abstract machine
///  pp::
///    Program pointer
///  dp::
///    Data pointer
///
define class <brainfuck> (<object>)
  slot program :: <program>,
    required-init-keyword: program:;
  slot tape :: <tape>,
    init-keyword: tape:,
    init-value: make(<tape>, size: $default-tape-size, fill: 0);
  slot pp :: <integer>,  
    init-value: 0;
  slot dp :: <integer>,
    init-value: 0;
end class <brainfuck>;

///
/// Read an instruction from a <character>
///
define function read-instruction
  (c :: <byte>)
  => (instruction :: <symbol>)
  select (as(<character>, c))
    '>' => #"increment-pointer";
    '<' => #"decrement-pointer";
    '+' => #"increment-data";
    '-' => #"decrement-data";
    '.' => #"output";
    ',' => #"input";
    '[' => #"jump-forward";
    ']' => #"jump-backward";
    otherwise
      => #"comment";
  end select;
end function read-instruction;

///
/// Read a brainfuck <program> from a <stream>
///
define method read-program
  (stream :: <stream>)
  => (program :: <program>)
  let program = make(<program>);
  while (~stream-at-end?(stream))
    add!(program, read-instruction(read-element(stream)));
  end while;
  program;
end method read-program;

define method increment-data
  (bf :: <brainfuck>)
  => (bf :: <brainfuck>)
  bf.tape[bf.dp] := bf.tape[bf.dp] + 1;
  bf
end method increment-data;

define method decrement-data
  (bf :: <brainfuck>)
  => (bf :: <brainfuck>)
  bf.tape[bf.dp] := bf.tape[bf.dp] - 1;
  bf
end method decrement-data;

define method increment-pointer
  (bf :: <brainfuck>)
  => (bf :: <brainfuck>)
  bf.dp := bf.dp + 1;
  if (bf.dp > bf.tape.size)
    error("Memory overflow");
  end;
  bf
end method increment-pointer;

define method decrement-pointer
  (bf :: <brainfuck>)
  => (bf :: <brainfuck>)
  bf.dp := bf.dp - 1;
  if (bf.dp < 0)
    error("Memory underflow");
  end;
  bf
end method decrement-pointer;

define method output
  (bf :: <brainfuck>)
  => (bf :: <brainfuck>)
  format-out("%=", bf.tape[bf.dp]);
  bf
end method output;

define method run
  (bf :: <brainfuck>)
  => ()
  while (bf.pp < bf.program.size)
    format-out("pp[%d]=%= tape[%d]=%d\n", bf.pp, bf.program[bf.pp], bf.dp, bf.tape[bf.dp]);
    select (bf.program[bf.pp])
      #"increment-data" =>
	increment-data(bf);
      #"decrement-data" =>
	decrement-data(bf);
      #"increment-pointer" =>
	increment-pointer(bf);
      #"decrement-pointer" =>
	decrement-pointer(bf);
      #"output" =>
	output(bf);
      #"comment" =>
	;
    otherwise =>
      error("Invalid instruction '%='", bf.program[bf.pp]);
    end;
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
    format-out("\n");
  end;
  exit-application(status);
end function main;

main(application-name(), application-arguments());
