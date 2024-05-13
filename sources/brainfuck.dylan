Module: brainfuck-impl
Synopsis: Brainfuck core 
Author: Fernando Raya
Copyright: GPLv3

define constant $memory-size
  = 30000;

define constant <memory-cell>
  = <integer>;

define constant <memory>
  = limited(<vector>, of: <memory-cell>, size: $memory-size);

define constant <memory-pointer>
  = <integer>;

define sealed class <bf> (<object>)
  slot program-pointer :: <program-pointer> = 0,
    init-keyword: program-pointer:;
  slot bf-mp :: <memory-pointer> = 0,
    init-keyword: memory-pointer:;
  constant slot bf-program :: <program>,
    required-init-keyword: program:;
  constant slot bf-memory :: <memory> = make(<memory>, fill: 0),
    init-keyword: memory:;
  constant virtual slot current-instruction :: <instruction>;
end;

define inline method current-instruction
    (bf :: <bf>) => (instruction :: <instruction>)
  bf.bf-program[bf.program-pointer]
end;

define inline method instruction-at
    (bf :: <bf>, index :: <program-pointer>)
 => (instruction :: <instruction>)
  bf.bf-program[index]
end;

define inline method program-not-finished?
    (bf :: <bf>) => (finished? :: <boolean>)
  bf.program-pointer < bf.bf-program.size
end;

define inline method program-forth
    (bf :: <bf>) => (address :: <program-pointer>)
  bf.program-pointer := bf.program-pointer + 1
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

define generic run
  (object :: <object>) => (bf :: <bf>);

define method run
    (program :: <program>)
 => (bf :: <bf>)
  let bf = make(<bf>, program: program);
  run(bf)
end;

define method run
    (bf :: <bf>) => (bf :: <bf>)
  while (program-not-finished?(bf))
    execute(bf.current-instruction, bf);
    program-forth(bf);
  end;
  bf
end;

///////////////////////////////////////////////////////////////////////////////
//
//  Optimizations
//
///////////////////////////////////////////////////////////////////////////////

define function remove-comments
    (program :: <program>) => (optimized :: <program>)
  choose(method (x) ~instance?(x, <comment>) end, program)
end;

define function group-instructions
    (program :: <program>) => (optimized :: <program>)
  local
    method optimizable?(x, y)
      instance?(x, <memory-instruction>) & object-class(x) = object-class(y)
    end method;
  let optimized = make(<program>);
  let stream    = make(<sequence-stream>, contents: program, direction: #"input");
  while (~stream-at-end?(stream))
    let current = read-element(stream);
    let next    = peek(stream, on-end-of-stream: #f);
    while (next & optimizable?(current, next))
      current.instruction-amount := current.instruction-amount + 1;
      read-element(stream);
      next := peek(stream, on-end-of-stream: #f);
    end while;
    optimized := add(optimized, current);
  end while;
  optimized
end function;

define function reset-to-zero
    (origin :: <program>) => (optimized :: <program>)
  let pattern      = read-program("[-]");
  let optimization = make(<reset-to-zero>); 
  let optimized    = make(<program>);
  for (i from 0 below origin.size)
    if (i + 2 < origin.size)
      let optimizable? = pattern = copy-sequence(origin, start: i, end: i + 3);
      optimized := add(optimized, if (optimizable?) optimization else origin[i] end);
      when (optimizable?) i := i + 2 end;
    else
      optimized := add(optimized, origin[i]);
    end if;
  end for;
  optimized
end function reset-to-zero;

define function precalculate-jumps
    (program :: <program>) => (optimized :: <program>)
  let optimized = copy-sequence(program);
  let levels    = make(<deque>);
  for (i from 0 below optimized.size)
    select (object-class(optimized[i]))
      <jump-forward> => 
        push(levels, i);
      <jump-backward> => 
        let j = pop(levels);
        optimized[i].jump-address := j;
        optimized[j].jump-address := i;
      otherwise => ;
    end select;
  end for;
  if (~empty?(levels))
    error("Mismatched jump instruction");
  end if;
  optimized;
end function;

// Exported

define function optimize-program
    (program :: <program>, level :: <integer>)
 => (optimized :: <program>)
  let o1 = remove-comments;
  let o2 = compose(group-instructions, o1);
  let o3 = compose(reset-to-zero, o2);
  let o4 = compose(precalculate-jumps, o3);
  select (level)
    0 => program;
    1 => o1(program);
    2 => o2(program);
    3 => o3(program);
    otherwise =>
      o4(program)
  end select;
end function optimize-program;

////////////////////////////////////////////////////////////////////////
//
// Print objects
//
////////////////////////////////////////////////////////////////////////

define method print-object
    (bf :: <bf>, s :: <stream>) => ()
  print-object(bf.bf-memory, s);
  format(s," PP:%03d '%='",
	 bf.program-pointer,
	 bf.current-instruction);
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
