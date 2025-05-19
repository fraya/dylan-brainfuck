Module: brainfuck-impl
Synopsis: Brainfuck program
Author: Fernando Raya
Copyright: GPLv3

define constant <program-pointer>
  = limited(<integer>);

define constant <program>
  = limited(<vector>, of: <instruction>);

define method \=
    (this :: <program>, that :: <program>)
 => (equals? :: <boolean>)
   next-method()
end;

define sealed domain \= (<program>, <program>);

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

define function parse-instruction
    (char :: <character>) => (instruction :: <instruction>)
  let type = element($brainfuck-table, char, default: <comment>);
  make(type)
end;

define method as
    (type == <program>, string :: <string>)
 => (program :: <program>)
  map-as(<program>, parse-instruction, string)
end as;

define function read-program
    (pathname :: <pathname>) => (program :: <program>)
  with-open-file (fs = pathname, element-type: <byte-character>)
    as(<program>, stream-contents(fs))
  end
end;

