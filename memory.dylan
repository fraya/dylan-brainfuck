Module: brainfuck-impl
Synopsis: Brainfuck memory
Author: Fernando Raya
Copyright: GPLv3

define constant $memory-size = 30000;

define constant <memory-data>
  = limited(<vector>, of: <integer>, size: $memory-size);

define class <memory> (<object>)
  slot memory-pointer :: <integer> = 0,
    init-keyword: pointer:;
  slot memory-data :: <memory-data> = make(<memory-data>, fill: 0),
    init-keyword: data:,
    setter: #f;
  virtual slot memory-item :: <integer>;
end class;

define method memory-item
    (memory :: <memory>) => (item :: <integer>)
  memory.memory-data[memory.memory-pointer]
end;

define method memory-item-setter
    (value :: <integer>, memory :: <memory>) => (new-value :: <integer>)
  memory.memory-data[memory.memory-pointer] := value
end;
