Module: brainfuck
Synopsis: Brainfuck interpreter 
Author: Fernando Raya
Copyright: GPLv3

define constant <program>
  = limited(<stretchy-vector>, of: <symbol>);

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
  slot tape :: <simple-object-vector>,
    init-keyword: tape:,
    init-value: make(<simple-object-vector>, size: $default-tape-size, fill: 0);
  slot pp :: <integer>,  
    init-value: 0;
  slot dp :: <integer>,
    init-value: 0;
end class <brainfuck>;

///
/// Encode each character as a symbol that represents an instruction
///
define function encode-character
  (char :: <character>)
  => (instruction :: <symbol>)
  select (char)
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
end function encode-character;

///
/// Encode a <stream> of characters as a <program>
///
define function encode-stream
  (stream :: <stream>)
  => (program :: <program>)
  let program = make(<program>);
  while (~stream-at-end?(stream))
    add!(program, encode-character(read-element(stream)));
  end while;
  program;
end function encode-stream;

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
  if (bf.dp > size(bf.tape))
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

define method run
  (bf :: <brainfuck>)
  => ()
  while (bf.pp < size(bf.program))
    //format-out("pp: %d dp: %d\n", bf.pp, bf.dp);
    select (bf.program[bf.pp])
      #"increment-data" =>
	increment-data(bf);
      #"decrement-data" =>
	decrement-data(bf);
      #"increment-pointer" =>
	increment-pointer(bf);
      #"decrement-pointer" =>
	decrement-pointer(bf);
      #"comment" =>
	;
    otherwise =>
      error("Invalid instruction '%s'", bf.program[bf.pp]);	
    end;
    bf.pp := bf.pp + 1;
  end while;
end method run;

define function main
  (name :: <string>, arguments :: <vector>)
  let stream   = make(<string-stream>, contents: "++-");
  let program  = encode-stream(stream);
  let bf       = make(<brainfuck>, program: program);
  run(bf);
  //format-out("tape[%d]=%d\n", bf.dp, bf.tape[bf.dp]);
  exit-application(0);
end function main;

main(application-name(), application-arguments());
