Module: brainfuck-impl
Synopsis: Brainfuck core 
Author: Fernando Raya
Copyright: GPLv3

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
    (char :: <character>, #key line = #f, column = #f)
 => (instruction :: <instruction>)
  select (char)
    '>' => make(<memory-pointer-increment>, line: line, column: column);
    '<' => make(<memory-pointer-decrement>, line: line, column: column);
    '+' => make(<memory-data-increment>, line: line, column: column);
    '-' => make(<memory-data-decrement>, line: line, column: column);
    '.' => make(<output>, line: line, column: column);
    ',' => make(<input>, line: line, column: column);
    '[' => make(<jump-forward>, line: line, column: column);
    ']' => make(<jump-backward>, line: line, column: column);
    otherwise
      => make(<comment>, char: char, line: line, column: column);
  end select;
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

// define method execute
//     (bf :: <interpreter>, instruction :: <instruction>) => ()
//   select (object-class(instruction))
//     <memory-data-increment> =>
//       memory-increment(bf, instruction.instruction-amount);
//     <memory-data-decrement> =>
//       memory-decrement(bf, instruction.instruction-amount);
//     <memory-pointer-increment> =>
//       memory-forth(bf, instruction.instruction-amount);
//     <memory-pointer-decrement> => 
//       memory-back(bf, instruction.instruction-amount);
//     <output> =>
//       format-out("%c", as(<character>, bf.memory-item));
//       force-out();
//     <reset-to-zero> => 
//       bf.memory[bf.memory-pointer] := 0;
//     <comment> =>
//       ;
//     otherwise =>
//       error("Unknown instruction");
//   end select;
// end method execute;

define method execute
    (instruction :: <memory-data-increment>, bf :: <interpreter>)
 => ()
  memory-increment(bf.interpreter-memory, instruction.instruction-amount)
end;

define method execute
    (instruction :: <memory-data-decrement>, bf :: <interpreter>)
 => ()
  memory-decrement(bf.interpreter-memory, instruction.instruction-amount)
end;

define method execute
    (instruction :: <memory-pointer-increment>, bf :: <interpreter>)
 => ()
  memory-forth(bf.interpreter-memory, instruction.instruction-amount)
end;

define method execute
    (instruction :: <memory-pointer-decrement>, bf :: <interpreter>)
 => ()
  memory-back(bf.interpreter-memory, instruction.instruction-amount);
end;

define method execute
    (instruction :: <output>, bf :: <interpreter>) => ()
  format-out("%c", as(<character>, bf.interpreter-memory.memory-item));
  force-out();
end;

define method execute
    (instruction :: <input>, bf :: <interpreter>) => ()
  error("Not implemented yet")
end;

define method execute
   (instruction :: <comment>, bf :: <interpreter>) => ()
 // do nothing
end;

define method execute
    (instruction :: <reset-to-zero>, bf :: <interpreter>) => ()
  bf.interpreter-memory.memory-item := 0
end;

define method execute
    (jump :: <jump-forward>, bf :: <interpreter>) => ()
  local
    method find-address(bf)
      block (address)
    let level = 1;
    let jump  = bf.current-instruction;
    for (index from bf.program-pointer + 1 below bf.interpreter-program.size)
      select (object-class(instruction-at(bf, index)))
        <jump-forward>  => level := level + 1;
        <jump-backward> => level := level - 1;
        otherwise       => ;
      end select;
      if (level = 0) address(index) end;
    end for;
    signal(make(<brainfuck-error>, instruction: jump));
      end block;
    end method;
  when (bf.interpreter-memory.memory-item = 0)
    bf.program-pointer := jump.jump-address | find-address(bf)
  end;
end execute;

define method execute
    (jump :: <jump-backward>, bf :: <interpreter>) => ()
  local
    method find-address(bf)
      block (address)
    let level = 1;
    let jump  = bf.current-instruction;
    for (index from bf.program-pointer - 1 to 0 by -1)
      select (object-class(instruction-at(bf, index)))
        <jump-forward>  => level := level - 1;
        <jump-backward> => level := level + 1;
        otherwise       => ;
      end select;
      if (level = 0) address(index) end;
    end for;
    error(make(<brainfuck-error>, instruction: jump));
      end block;
    end method;
  when (bf.interpreter-memory.memory-item ~= 0)
    bf.program-pointer := jump.jump-address | find-address(bf)
  end;
end execute;

///////////////////////////////////////////////////////////////////////////////
//
//  Optimizations
//
///////////////////////////////////////////////////////////////////////////////

define function program-remove-comments
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
  let o1 = compose(program-remove-comments);
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
    (bf :: <interpreter>, s :: <stream>) => ()
  print-object(bf.interpreter-memory, s);
  format(s," PP:%03d '%='",
	 bf.program-pointer,
	 bf.current-instruction);
end;

define method print-object
    (instruction :: <memory-instruction>, s :: <stream>) => ()
  unless (instruction.instruction-amount == 1) 
    write(s, integer-to-string(instruction.instruction-amount)) 
  end
end;

define method print-object
    (instruction :: <memory-data-increment>, s :: <stream>) => ()
  write-element(s, '+');
  next-method();
end;

define method print-object
    (instruction :: <memory-data-decrement>, s :: <stream>) => ()
  write-element(s, '-');
  next-method();
end;

define method print-object
    (instruction :: <memory-pointer-increment>, s :: <stream>) => ()
  write-element(s, '>');
  next-method();
end;

define method print-object
    (instruction :: <memory-pointer-decrement>, s :: <stream>) => ()
  write-element(s, '<');
  next-method();
end;

define method print-object
    (instruction :: <reset-to-zero>, s :: <stream>) => ()
  write-element(s, 'Z');
end;

define method print-object
    (jump :: <jump-instruction>, s :: <stream>) => ()
  when (jump.jump-address)
    write(s, integer-to-string(jump.jump-address))
  end
end;

define method print-object
    (jump :: <jump-forward>, s :: <stream>) => ()
  write-element(s, '[');
  next-method()
end;

define method print-object
    (jump :: <jump-backward>, s :: <stream>) => ()
  write-element(s, ']');
  next-method()
end;

define method print-object
    (input :: <input>, s :: <stream>) => ()
  write-element(s, ',');
end;

define method print-object
    (output :: <output>, s :: <stream>) => ()
  write-element(s, '.');
end;

define method print-object
    (comment :: <comment>, s :: <stream>) => ()
  write-element(s, comment.comment-char)
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
    (this :: <memory-data-instruction>, that :: <memory-data-instruction>)
 => (equals? :: <boolean>)
      object-class(this) = object-class(that)
    & this.instruction-amount = that.instruction-amount
end;

define method \=
    (this :: <jump-instruction>, that :: <jump-instruction>)
 => (equals? :: <boolean>)
  next-method() & this.jump-address = that.jump-address
end;

define method \=
    (this :: <program>, that :: <program>)
 => (equals? :: <boolean>)
   next-method()
 end;
