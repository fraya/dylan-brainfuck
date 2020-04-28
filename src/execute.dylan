Module: brainfuck
Synopsis: Execution of each instruction
Author: Fernando Raya
Copyright: GPLv3

define generic execute
  (bf :: <brainfuck>, instruction :: <instruction>) => ();

define sealed inline method execute
  (bf :: <brainfuck>, instruction :: <comment>) => ()
end method;

define sealed inline method execute
  (bf :: <brainfuck>, instruction :: <increment-data>) => ()
  bf.tape[bf.dp] := bf.tape[bf.dp] + instruction.amount;
end method;

define sealed inline method execute
  (bf :: <brainfuck>, instruction :: <decrement-data>) => ()
  bf.tape[bf.dp] := bf.tape[bf.dp] - instruction.amount;
end method;

define sealed inline method execute
  (bf :: <brainfuck>, instruction :: <increment-pointer>) => ()
  bf.dp := bf.dp + instruction.amount;
end method;

define sealed inline method execute
  (bf :: <brainfuck>, instruction :: <decrement-pointer>) => ()
  bf.dp := bf.dp - instruction.amount;
end method;

define sealed inline method execute
  (bf :: <brainfuck>, instruction :: <output>) => ()
  format-out("%c", as(<character>, bf.tape[bf.dp]));
  force-out()
end method;

define sealed inline method execute
  (bf :: <brainfuck>, instruction :: <jump-forward>) => ()
  unless (bf.tape[bf.dp] ~= 0)
    let i = 1;
    while (i > 0)
      bf.pp := bf.pp + 1;
      select (object-class(bf.program[bf.pp]))
	<jump-forward>
	  => i := i + 1;
	<jump-backward>
	  => i := i - 1;
	otherwise => ;
      end select;
    end while;
  end unless
end method;

define sealed inline method execute
  (bf :: <brainfuck>, instruction :: <jump-backward>) => ()
  unless (bf.tape[bf.dp] = 0)
    let i = 1;
    while (i > 0)
      bf.pp := bf.pp - 1;
      select (object-class(bf.program[bf.pp]))
	<jump-forward>
	  => i := i - 1;
	<jump-backward>
	  => i := i + 1;
	otherwise => ;
      end select;
    end while;
  end unless
end method;

define sealed inline method execute
  (bf :: <brainfuck>, instruction :: <precalculated-jump-forward>) => ()
  unless (bf.tape[bf.dp] ~= 0)
    bf.pp := instruction.address
  end
end method;

define sealed inline method execute
  (bf :: <brainfuck>, instruction :: <precalculated-jump-backward>) => ()
  unless (bf.tape[bf.dp] = 0)
    bf.pp := instruction.address
  end
end method;
