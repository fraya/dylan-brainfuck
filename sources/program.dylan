Module: brainfuck-impl
Synopsis: Brainfuck program
Author: Fernando Raya
Copyright: GPLv3

define constant <program-pointer>
  = limited(<integer>);

define constant <program>
  = limited(<vector>, of: <instruction>);

define constant $brainfuck-table
  = instruction-table(<memory-pointer-increment>,
		      <memory-pointer-decrement>,
		      <memory-data-increment>,
		      <memory-data-decrement>,
		      <output>,
		      <input>,
		      <jump-forward>,
		      <jump-backward>,
		      <reset-to-zero>);

define function parse-character
    (char :: <character>) => (instruction :: <instruction>)
  let type = element($brainfuck-table, char, default: <comment>);
  make(type)
end;

define generic read-program
  (object :: <object>) => (program :: <program>);

define method read-program
    (sequence :: <sequence>) => (program :: <program>)
  map-as(<program>, parse-character, sequence)
end;

define method read-program
    (stream :: <stream>) => (program :: <program>)
  read-program(read-to-end(stream))
end;

define method read-program
    (locator :: <locator>) => (program :: <program>)  
  with-open-file (fs = locator, element-type: <byte-character>)
    read-program(fs)
  end;
end;

define method \=
    (this :: <program>, that :: <program>)
 => (equals? :: <boolean>)
   next-method()
end;

define sealed domain \= (<program>, <program>);
