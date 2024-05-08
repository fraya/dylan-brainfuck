Module: brainfuck-impl
Synopsis: Brainfuck program
Author: Fernando Raya
Copyright: GPLv3

define constant <program-pointer>
  = limited(<integer>);

define constant <program>
  = limited(<vector>, of: <instruction>);

define generic read-program
  (source :: <object>) => (program :: <program>);

define method read-program
    (stream :: <stream>) => (program :: <program>)
  let program = make(<program>);
  let line   = 0;
  let column = 0;
  while (~stream-at-end?(stream))
    let char = as(<character>, read-element(stream));
    if (char = '\n')
      column := 0; line := line + 1;
    else
      column := column + 1;
    end;
    let instruction = parse-instruction(char, line: line, column: column);
    program := add(program, instruction);
  end;
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
  map-as(<program>, parse-instruction, string)
end;

define method read-program
    (instructions :: <collection>) => (program :: <program>)
  map-as(<program>, identity, instructions)
end;
