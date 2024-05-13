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
  constant slot bf-memory :: <memory>,
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

define inline function forth!
    (bf :: <bf>) => (pp :: <program-pointer>)
  bf.bf-pp := bf.bf-pp + 1;
end;

define inline function perform!
    (bf :: <bf>) => (bf :: <bf>)
  execute(bf.bf-program[bf.bf-pp], bf);
  bf
end;

////////////////////////////////////////////////////////////////////////
//
// 'run' methods to execute a program in a brainfuck machine
//
////////////////////////////////////////////////////////////////////////

define generic run!
  (object :: <object>) => (bf :: <bf>);

define method run!
    (program :: <program>) => (bf :: <bf>)
  let memory = make(<memory>, size: $default-memory-size);
  run!(make(<bf>, program: program, memory: memory))
end;

define method run!
    (bf :: <bf>) => (bf :: <bf>)
  while (bf.bf-pp < bf.bf-program.size)
    forth!(perform!(bf))
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
