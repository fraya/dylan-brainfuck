Module: brainfuck-impl
Synopsis: Optimization of programs
Author: Fernando Raya
Copyright: GPLv3

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
  let pattern      = as(<program>, "[-]");
  let optimization = make(<reset-to-zero>); 
  let optimized    = make(<program>);
  let _size = origin.size;
  for (i from 0 below _size)
    if (i + 2 < _size)
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
