Module: brainfuck-impl
Synopsis: Interpreter memory 
Author: Fernando Raya
Copyright: GPLv3

define constant $memory-size
  = 30000;

define constant <memory-cell>
  = <integer>;

define constant <memory-cells>
  = limited(<vector>, of: <memory-cell>, size: $memory-size);

define constant <memory-pointer>
  = <integer>;

define class <memory> (<object>)
  constant slot memory-cells :: <memory-cells> = make(<memory-cells>, fill: 0),
    init-keyword: cells:;
  slot memory-pointer :: <memory-pointer> = 0,
    init-keyword: pointer:;
  virtual slot memory-item :: <memory-cell>;
end class <memory>;

define method memory-item
    (mem :: <memory>) => (cell :: <memory-cell>)
  mem.memory-cells[mem.memory-pointer]
end;

define method memory-item-setter
    (value :: <integer>, mem :: <memory>) => (cell :: <memory-cell>)
  mem.memory-cells[mem.memory-pointer] := value
end;

define method memory-increment
    (mem :: <memory>, amount :: <integer>) => (cell :: <memory-cell>)
  mem.memory-item := mem.memory-item + amount
end;

define method memory-decrement
    (mem :: <memory>, amount :: <integer>) => (cell :: <memory-cell>)
  mem.memory-item := mem.memory-item - amount
end;

define method memory-forth
    (mem :: <memory>, steps :: <memory-pointer>) => (pointer :: <memory-pointer>)
  mem.memory-pointer := mem.memory-pointer + steps
end;

define method memory-back
    (mem :: <memory>, steps :: <memory-pointer>) => (pointer :: <memory-pointer>)
  mem.memory-pointer := mem.memory-pointer - steps
end;    

define method print-object
    (mem :: <memory>, s :: <stream>) => ()
  format(s, "MEM[%d]=%d", mem.memory-pointer, mem.memory-item)
end;
