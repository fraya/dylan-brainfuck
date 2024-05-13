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

////////////////////////////////////////////////////////////////////////
//
// Brainfuck interface
//
////////////////////////////////////////////////////////////////////////

define generic bf-pp
  (bf :: <bf>) => (pp :: <program-pointer>);

define generic bf-mp
  (bf :: <bf>) => (mp :: <memory-pointer>);

define generic bf-program
  (bf :: <bf>) => (program :: <program>);

define generic bf-memory
  (bf :: <bf>) => (memory :: <memory>);

define generic execute
  (instruction :: <instruction>, bf :: <bf>) => ();

define generic run!
  (object :: <object>) => (bf :: <bf>);

////////////////////////////////////////////////////////////////////////
//
// 'run' methods to execute a program in a brainfuck machine
//
////////////////////////////////////////////////////////////////////////

define method run!
    (program :: <program>)
 => (bf :: <bf>)
  let bf = make(<bf>, program: program);
  run!(bf)
end;

define method run!
    (bf :: <bf>) => (bf :: <bf>)
  while (bf.bf-pp < bf.bf-program.size)
    execute(bf.bf-program[bf.bf-pp], bf);
    bf.bf-pp := bf.bf-pp + 1
  end;
  bf
end;

define method print-object
    (bf :: <bf>, s :: <stream>) => ()
  print-object(bf.bf-memory, s);
  format(s," PP:%03d '%='",
	 bf.bf-pp,
	 bf.bf-program[bf.bf-pp]);
end;
