Module: brainfuck-impl
Synopsis: Brainfuck core 
Author: Fernando Raya
Copyright: GPLv3

define constant $memory-size
  = 30000;

define constant <memory-pointer>
  = limited(<integer>);

define constant <memory>
  = limited(<vector>, of: <integer>, size: $memory-size);

define constant <program-pointer>
  = limited(<integer>, min: 0);

define constant <program>
  = limited(<stretchy-vector>, of: <instruction>);

define class <interpreter> (<object>)
  slot program-pointer :: <program-pointer> = 0,
    init-keyword: program-pointer:;
  slot memory-pointer :: <memory-pointer> = 0,
    init-keyword: memory-pointer:;
  constant slot interpreter-program :: <program>,
    required-init-keyword: program:;
  constant slot interpreter-memory :: <memory> = make(<memory>, fill: 0),
    init-keyword: memory:;
  constant slot interpreter-output-stream :: <stream> = *standard-output*,
    init-keyword: output-stream:;
  constant virtual slot current-instruction :: <instruction>;
  virtual slot memory-item :: <integer>;
end class <interpreter>;

define function current-instruction
    (bf :: <interpreter>)
 => (instruction :: <instruction>)
  bf.interpreter-program[bf.program-pointer]
end;

define inline method program-at
    (bf :: <interpreter>, index :: <program-pointer>)
 => (instruction :: <instruction>)
  bf.interpreter-program[index]
end;

define inline function program-not-finished?
    (bf :: <interpreter>)
 => (finished? :: <boolean>)
  bf.program-pointer < bf.interpreter-program.size
end;

define inline function program-forth
    (bf :: <interpreter>)
 => (address :: <program-pointer>)
  bf.program-pointer := bf.program-pointer + 1
end;

define inline function program-back
    (bf :: <interpreter>)
 => (address :: <program-pointer>)
  bf.program-pointer := bf.program-pointer - 1
end;

define function memory-item
    (bf :: <interpreter>)
 => (cell :: <integer>)
  bf.interpreter-memory[bf.memory-pointer]
end;

define function memory-item-setter
    (value :: <integer>, bf :: <interpreter>)
 => (cell :: <integer>)
  bf.interpreter-memory[bf.memory-pointer] := value
end;

define inline method memory-increment
    (bf :: <interpreter>, amount :: <integer>)
 => (cell :: <integer>)
  bf.memory-item := bf.memory-item + amount
end;

define inline method memory-forth
    (bf :: <interpreter>, amount :: <memory-pointer>)
 => (pointer :: <memory-pointer>)
  bf.memory-pointer := bf.memory-pointer + amount
end;

define method as
    (type == <instruction>, char :: <character>)
 => (instruction :: <instruction>)
  select (char)
    '>' => make(<memory-pointer-instruction>, amount: 1);
    '<' => make(<memory-pointer-instruction>, amount: - 1);
    '+' => make(<memory-data-instruction>, amount: 1);
    '-' => make(<memory-data-instruction>, amount: - 1);
    '.' => make(<output>);
    ',' => make(<input>);
    '[' => make(<jump-forward>);
    ']' => make(<jump-backward>);
    otherwise
      => make(<comment>, char: char);
  end select;
end;

////////////////////////////////////////////////////////////////////////
//
// Read programs
//
////////////////////////////////////////////////////////////////////////

define generic read-program
  (source :: <object>) => (program :: <program>);

define method read-program
    (stream :: <stream>) => (program :: <program>)
  let program = make(<program>);
  while (~stream-at-end?(stream))
    let char = as(<character>, read-element(stream));
    add!(program, as(<instruction>, char))
  end while;
  program
end method read-program;

define method read-program
    (locator :: <locator>) => (program :: <program>)  
  with-open-file (fs = locator, element-type: <byte>)
    read-program(fs)
  end;
end;

define method read-program
    (string :: <string>) => (program :: <program>)
  map-as(<program>, curry(as, <instruction>), string)
end;

define method read-program
    (instructions :: <collection>) => (program :: <program>)
  map-as(<program>, identity, instructions)
end;

define method run-brainfuck-program
    (program :: <program>) => ()
  let bf = make(<interpreter>, program: program);
  block ()
    while (program-not-finished?(bf))
      //format-out("%=\n", bf); force-out();
      execute(bf.current-instruction, bf);
      program-forth(bf);
    end;
  exception (error :: <error>)
    let instruction = bf.current-instruction;
    signal(make(<brainfuck-error>, instruction: instruction));
  end block;
end method run-brainfuck-program;


////////////////////////////////////////////////////////////////////////
//
// Execute methods
//
////////////////////////////////////////////////////////////////////////

define generic execute
  (instruction :: <instruction>, bf :: <interpreter>) => ();


define method execute
    (instruction :: <output>, bf :: <interpreter>) => ()
  format(bf.interpreter-output-stream,
	 "%c", as(<character>, bf.memory-item));
  force-out()
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
  bf.memory-item := 0
end;



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
  let stream    = make(<sequence-stream>, contents: program);
  while (~stream-at-end?(stream))
    let current = read-element(stream);
    let next    = peek(stream, on-end-of-stream: #f);
    while (next & optimizable?(current, next))
      current.memory-amount := current.memory-amount + next.memory-amount;
      read-element(stream);
      next := peek(stream, on-end-of-stream: #f);
    end while;
    add!(optimized, current);
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
      add!(optimized, if (optimizable?) optimization else program[i] end);
      when (optimizable?) i := i + 2 end;
    else
      add!(optimized, program[i]);
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
  format(s,"PP[%d]='%=' DP[%d]=%d\n",
	 bf.program-pointer,
	 bf.current-instruction,
	 bf.memory-pointer,
	 bf.memory-item)
end;

define method print-object
    (instruction :: <reset-to-zero>, s :: <stream>) => ()
  write-element(s, 'Z');
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

define method print-object
    (program :: <program>, s :: <stream>) => ()
  for (instruction in program)
    print-object(instruction, s)
  end
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
