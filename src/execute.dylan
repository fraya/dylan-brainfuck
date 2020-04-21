Module: brainfuck
Synopsis: Brainfuck interpreter 
Author: Fernando Raya
Copyright: GPLv3

define generic execute
  (bf :: <brainfuck>, instruction :: <instruction>)
  => (bf :: <brainfuck>);

define method execute
  (bf :: <brainfuck>, instruction :: <comment>)
  => (bf :: <brainfuck>)
  bf
end method execute;

define method execute
  (bf :: <brainfuck>, instruction :: <increment-data>)
  => (bf :: <brainfuck>)
  bf.tape[bf.dp] := bf.tape[bf.dp] + instruction.amount;
  bf
end method execute;

define method execute
  (bf :: <brainfuck>, instruction :: <decrement-data>)
  => (bf :: <brainfuck>)
  bf.tape[bf.dp] := bf.tape[bf.dp] - instruction.amount;
  bf
end method execute;

define method execute
  (bf :: <brainfuck>, instruction :: <increment-pointer>)
  => (bf :: <brainfuck>)
  bf.dp := bf.dp + instruction.amount;
  bf
end method execute;

define method execute
  (bf :: <brainfuck>, instruction :: <decrement-pointer>)
  => (bf :: <brainfuck>)
  bf.dp := bf.dp - instruction.amount;
  bf
end method execute;

define method execute
  (bf :: <brainfuck>, instruction :: <output>)
  => (bf :: <brainfuck>)
  format-out("%c", as(<character>, bf.tape[bf.dp]));
  force-out();
  bf
end method execute;

define method execute
  (bf :: <brainfuck>, instruction :: <jump-forward>)
  => (bf :: <brainfuck>)
  unless (bf.tape[bf.dp] ~= 0)
    let i = 1;
    while (i > 0)
      bf.pp := bf.pp + 1;
      select (object-class(bf.program[bf.pp]))
	<jump-forward> =>
	  i := i + 1;
	<jump-backward> =>
	  i := i - 1;
	otherwise => ;
      end select;
    end while;
  end unless;
  bf;
end method execute;

define method execute
  (bf :: <brainfuck>, instruction :: <jump-backward>)
  => (bf :: <brainfuck>)
  unless (bf.tape[bf.dp] = 0)
    let i = 1;
    while (i > 0)
      bf.pp := bf.pp - 1;
      select (object-class(bf.program[bf.pp]))
	<jump-forward> =>
	  i := i - 1;
	<jump-backward> =>
	  i := i + 1;
	otherwise => ;
      end select;
    end while;
  end unless;
  bf;
end method execute;


