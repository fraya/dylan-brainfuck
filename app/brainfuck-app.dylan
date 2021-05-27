Module: brainfuck-app
Synopsis: Brainfuck interpreter 
Author: Fernando Raya
Copyright: GPLv3

define function main
  (name :: <string>, arguments :: <vector>)  
  if (arguments.size < 1)
    format-out("USAGE:\n\t%s <program> [optimization]\n\n", application-name());
    format-out("optimization:\n");
    format-out("\t0: No optimization\n");
    format-out("\t1: Remove comments\n");
    format-out("\t2: Level 1 and group instructions\n");
    format-out("\t3: Level 2 and precalculate jumps (default)\n");
    exit-application(1);
  end;

  let program = read-program(arguments[0]);

  let optimization-level = 3;
  if (arguments.size > 1)
    optimization-level := string-to-integer(arguments[1]);
  end;
  
  let optimized = optimize-program(program, optimization-level);
  
  let bf = make(<brainfuck>, program: optimized);
  run(bf);  
  exit-application(0);
end function main;

main(application-name(), application-arguments());
