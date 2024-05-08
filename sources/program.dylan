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
  while (~stream-at-end?(stream))
    let char = as(<character>, read-element(stream));
    let instruction = parse-instruction(char);
    when (instruction) program := add(program, instruction) end;
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
  with-input-from-string(stream = string)
    read-program(stream)
  end
end;

define method read-program
    (instructions :: <collection>) => (program :: <program>)
  map-as(<program>, identity, instructions)
end;
