Module: brainfuck-impl
Synopsis: Brainfuck core 
Author: Fernando Raya
Copyright: GPLv3

define abstract class <instruction> (<object>)
end;

define class <interpreter> (<object>)
  slot program-pointer :: <program-pointer> = 0,
    init-keyword: program-pointer:;
  constant slot interpreter-program :: <program>,
    required-init-keyword: program:;
  constant slot interpreter-memory :: <memory> = make(<memory>, fill: 0),
    init-keyword: memory:;
  constant virtual slot current-instruction :: <instruction>;
end;

define method current-instruction
    (interpreter :: <interpreter>) => (instruction :: <instruction>)
  interpreter.interpreter-program[interpreter.program-pointer]
end;

define method instruction-at
    (interpreter :: <interpreter>, index :: <program-pointer>)
 => (instruction :: <instruction>)
  interpreter.interpreter-program[index]
end;

define inline method program-not-finished?
    (interpreter :: <interpreter>) => (finished? :: <boolean>)
  interpreter.program-pointer < interpreter.interpreter-program.size
end;

define inline method program-forth
    (interpreter :: <interpreter>) => (address :: <program-pointer>)
  interpreter.program-pointer := interpreter.program-pointer + 1
end;

////////////////////////////////////////////////////////////////////////
//
// Parse instructions
//
////////////////////////////////////////////////////////////////////////

define method parse-instruction
    (char :: <character>)
 => (instruction :: false-or(<instruction>))
  let type :: false-or(<class>) = select (char)
				    '>' => <memory-pointer-increment>;
				    '<' => <memory-pointer-decrement>;
				    '+' => <memory-data-increment>;
				    '-' => <memory-data-decrement>;
				    '.' => <output>;
				    ',' => <input>;
				    '[' => <jump-forward>;
				    ']' => <jump-backward>;
				    otherwise
				      => #f;
				  end select;
  if (type) make(type) else #f end
end;


define method run-brainfuck-program
    (interpreter :: <interpreter>) => (bf :: <interpreter>)
  block ()
    while (program-not-finished?(interpreter))
      // format-out("%=\n", interpreter); force-out();
      execute(interpreter.current-instruction, interpreter);
      program-forth(interpreter);
    end;
    interpreter
  exception (error :: <error>)
    let instruction = interpreter.current-instruction;
    signal(make(<brainfuck-error>, instruction: instruction));
  end block;
end method run-brainfuck-program;

define method run-brainfuck-program
    (program :: <program>) => (bf :: <interpreter>)
  let interpreter = make(<interpreter>, program: program);
  run-brainfuck-program(interpreter)
end;

////////////////////////////////////////////////////////////////////////
//
// Execute methods
//
////////////////////////////////////////////////////////////////////////

define generic execute
  (instruction :: <instruction>, bf :: <interpreter>) => ();

///////////////////////////////////////////////////////////////////////////////
//
//  Optimizations
//
///////////////////////////////////////////////////////////////////////////////

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
    (program :: <program>) => (optimized :: <program>)
  let pattern      = read-program("[-]");
  let optimization = make(<reset-to-zero>); 
  let optimized    = make(<program>);
  for (i from 0 below program.size)
    if (i + 2 < program.size)
      let optimizable? = pattern = copy-sequence(program, start: i, end: i + 3);
      optimized := add(optimized, if (optimizable?) optimization else program[i] end);
      when (optimizable?) i := i + 2 end;
    else
      optimized := add(optimized, program[i]);
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
    error(make(<mismatch-jump-error>));
  end if;
  optimized;
end function;

// Exported

define function optimize-program
    (program :: <program>, level :: <integer>)
 => (optimized :: <program>)
  let o1 = group-instructions;
  let o2 = compose(reset-to-zero, o1);
  let o3 = compose(precalculate-jumps, o2);
  select (level)
    0 => program;
    1 => o1(program);
    2 => o2(program);
    otherwise =>
      o3(program)
  end select;
end function optimize-program;

////////////////////////////////////////////////////////////////////////
//
// Print objects
//
////////////////////////////////////////////////////////////////////////

define method print-object
    (bf :: <interpreter>, s :: <stream>) => ()
  print-object(bf.interpreter-memory, s);
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
