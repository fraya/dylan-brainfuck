Module: brainfuck-app

define function main
  (name :: <string>, arguments :: <vector>)  
  if (arguments.size < 1)
    format-out("USAGE:\n\t%s <program> [optimization]\n\n", name);
    format-out("optimization:\n");
    format-out("\t0: No optimization\n");
    format-out("\t1: Remove comments\n");
    format-out("\t2: Level 1 and group instructions\n");
    format-out("\t3: Level 2 and replace pattern [-] with reset to zero\n");    
    format-out("\t4: Level 3 and precalculate jumps (default)\n");
    exit-application(1);
  end if;
  
  block ()
    let program-name = arguments[0];
    if (~file-exists?(program-name))
      format-err("Error: File '%s' doesn't exists\n", program-name);
      exit-application(1)
    end;

    let optimization-level = 4;
    if (arguments.size > 1)
      optimization-level := string-to-integer(arguments[1]);
    end;

    let program = read-program(program-name);
    let optimized = optimize-program(program, optimization-level);
    run!(optimized);
    format-out("\n");
  exception (error :: <error>)
    format-err("Error: %=", error);
    exit-application(2);
  end;
end function main;

main(application-name(), application-arguments());
