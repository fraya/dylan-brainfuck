Module: brainfuck-app

define method run
    (program :: <program>, optimization-level :: <integer>) => ()
  // format-out("Program read\n%=\n", program);
  let optimized = optimize-program(program, optimization-level);
  // format-out("Program optimized\n%=\n", optimized);
  let brainfuck = run-brainfuck-program(optimized);
end;

define method run
    (program :: <string>, optimization-level :: <integer>) => ()
  let locator = as(<file-locator>, program);
  let program = read-program(locator);
  run(program, optimization-level);
end;

define function main
  (name :: <string>, arguments :: <vector>)  
  if (arguments.size < 1)
    format-out("USAGE:\n\t%s <program> [optimization]\n\n", name);
    format-out("optimization:\n");
    format-out("\t0: No optimization\n");
    format-out("\t1: Group instructions\n");
    format-out("\t2: Level 1 and replace pattern [-] with reset to zero\n");    
    format-out("\t3: Level 2 and precalculate jumps (default)\n");
    exit-application(1);
  end if;
  
  block ()
    let program-name = arguments[0];
    if (~file-exists?(program-name))
      format-err("Error: File '%s' doesn't exists\n", program-name);
      exit-application(1)
    end;

    let optimization-level = 3;
    if (arguments.size > 1)
      optimization-level := string-to-integer(arguments[1]);
    end;

    run(program-name, optimization-level);
    format-out("\n");
  exception (error :: <brainfuck-error>)
    let instruction = error.error-instruction;
    format-out("\n%d:%d: Error executing instruction '%='\n",
	       instruction.instruction-line,
	       instruction.instruction-column,
	       instruction);
    exit-application(2);
  end;
end function main;

main(application-name(), application-arguments());
