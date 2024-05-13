Module: brainfuck-impl
Synopsis: Brainfuck memory 
Author: Fernando Raya
Copyright: GPLv3

define constant $default-memory-size
  = 30000;

define constant <memory-cell>
  = <integer>;

define constant <memory>
  = limited(<vector>, of: <memory-cell>);

define constant <memory-pointer>
  = <integer>;
