Module: brainfuck
Synopsis: Brainfuck interpreter 
Author: Fernando Raya
Copyright: GPLv3

define constant <program-pointer> =
  limited(<integer>, min: 0);

define constant <program> =
  limited(<stretchy-vector>, of: <instruction>);

define method read-program
    (filename :: <string>)
 => (program :: <program>)
  let program = make(<program>);
  with-open-file (fs = filename, element-type: <byte>)
    while (~stream-at-end?(fs))
      let character   = as(<character>, read-element(fs));
      let instruction = make(<instruction>, char: character);
      add!(program, instruction);
    end while;
  end with-open-file;
  program 
end method read-program;

define method optimize-instruction
    (x :: <instruction>, y :: <instruction>)
 => (optimized? :: <boolean>)
  #f
end method;

define method optimize-instruction
    (x :: <tape-instruction>, y :: <tape-instruction>)
 => (optimized? :: <boolean>)
  if (object-class(x) = object-class(y))
    y.amount := y.amount + x.amount;
    #t
  else
    #f
  end
end method;

define method remove-comments
    (program :: <program>)
 => (optimized :: <program>)
  choose(method (x) ~instance?(x, <comment>) end, program)
end method;

define function group-optimize
    (program :: <program>)
 => (optimized :: <program>)
  let result = make(<program>);
  let stream = make(<sequence-stream>, contents: program);
  while (~stream-at-end?(stream))
    let current = read-element(stream);
    if (stream-at-end?(stream))
      add!(result, current)
    else
      let next = peek(stream);
      let optimizable? = optimize-instruction(current, next);
      if (~optimizable?)
	add!(result, current)
      end
    end if;
  end while;
  result
end function;

define function jump-optimize
    (program :: <program>)
 => (optimized :: <program>)
  for (i from 0 below program.size)
    if (object-class(program[i]) = <jump-forward>)
      let level = 1;
      let j = i;
      while (level > 0)
	j := j + 1;
	select (object-class(program[j]))
	  <jump-forward>
	    => level := level + 1;
	  <jump-backward>
	    => level := level - 1;
	  otherwise => ;
	end select;
      end while;
      program[i] := make(<precalculated-jump-forward>,  address: j);
      program[j] := make(<precalculated-jump-backward>, address: i);
    end if;
  end for;
  program
end function;

define constant optimize1
  = compose(remove-comments);

define constant optimize2
  = compose(group-optimize, optimize1);

define constant optimize3
  = compose(jump-optimize, optimize2);

define function optimize-program
    (program :: <program>, level :: <integer>)
 => (optimized :: <program>)
  select (level)
    0
      => program;
    1
      => optimize1(program);
    2
      => optimize2(program);
    otherwise
      => optimize3(program);
  end select
end function;
