Module: brainfuck-impl
Synopsis: Brainfuck core 
Author: Fernando Raya
Copyright: GPLv3

define sealed class <bf> (<object>)
  slot bf-pp :: <program-pointer> = 0,
    init-keyword: program-pointer:;
  slot bf-mp :: <memory-pointer> = 0,
    init-keyword: memory-pointer:;
  constant slot bf-program :: <program>,
    required-init-keyword: program:;
  constant slot bf-memory :: <memory>
    = make(<memory>, fill: 0, size: $default-memory-size),
    init-keyword: memory:;
end;

define inline method program-not-finished?
    (bf :: <bf>) => (finished? :: <boolean>)
  bf.bf-pp < bf.bf-program.size
end;

////////////////////////////////////////////////////////////////////////
//
// Execute methods
//
////////////////////////////////////////////////////////////////////////

define generic execute
  (instruction :: <instruction>, bf :: <bf>) => ();


////////////////////////////////////////////////////////////////////////
//
// 'run' methods to execute a program in a brainfuck machine
//
////////////////////////////////////////////////////////////////////////

define generic run!
  (object :: <object>) => (bf :: <bf>);

define method run!
    (program :: <program>)
 => (bf :: <bf>)
  let bf = make(<bf>, program: program);
  run!(bf)
end;

define method run!
    (bf :: <bf>) => (bf :: <bf>)
  while (program-not-finished?(bf))
    execute(bf.bf-program[bf.bf-pp], bf);
    bf.bf-pp := bf.bf-pp + 1
  end;
  bf
end;

////////////////////////////////////////////////////////////////////////
//
// Print objects
//
////////////////////////////////////////////////////////////////////////

define method print-object
    (bf :: <bf>, s :: <stream>) => ()
  print-object(bf.bf-memory, s);
  format(s," PP:%03d '%='",
	 bf.bf-pp,
	 bf.bf-program[bf.bf-pp]);
end;

////////////////////////////////////////////////////////////////////////
//
//  Equal methods
//
////////////////////////////////////////////////////////////////////////

define method \=
    (this :: <instruction>, that :: <instruction>)
 => (equals? :: <boolean>)
  object-class(this) = object-class(that)
end;

define method \=
    (this :: <program>, that :: <program>)
 => (equals? :: <boolean>)
   next-method()
 end;

define sealed domain \= (<instruction>, <instruction>);
define sealed domain \= (<program>, <program>);
