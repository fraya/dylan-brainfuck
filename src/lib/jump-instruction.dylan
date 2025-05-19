Module: brainfuck-impl
Synopsis: Jump instructions 
Author: Fernando Raya
Copyright: GPLv3

////////////////////////////////////////////////////////////////////////
//
// Memory classes hierarchy 
//
////////////////////////////////////////////////////////////////////////

define sealed abstract class <jump-instruction> (<instruction>)
  slot jump-address :: false-or(<program-pointer>) = #f,
    init-keyword: address:;
end;

define sealed class <jump-forward>  (<jump-instruction>)
  inherited slot instruction-symbol = '[';
end;

define sealed class <jump-backward> (<jump-instruction>)
  inherited slot instruction-symbol = ']';
end;

////////////////////////////////////////////////////////////////////////
//
// Execute methods
//
////////////////////////////////////////////////////////////////////////

define function forward-range
    (bf :: <bf>) => (range :: <range>)
  range(from: bf.bf-pp + 1, to: bf.bf-program.size)
end;

define function backward-range
    (bf :: <bf>) => (range :: <range>)
  range(from: bf.bf-pp - 1, to: 0, by: -1)
end;

define function find-address
    (bf :: <bf>,
     instructions :: <range>,
     jump :: <class>)
 => (index :: <program-pointer>)
  block (address)
    let level = 1;
    let match = if (jump = <jump-forward>) <jump-backward> else <jump-forward> end;
    for (index in instructions)
      let instruction = bf.bf-program[index];
      select (object-class(instruction))
	jump      => level := level + 1;
	match     => level := level - 1;
	otherwise => ;
      end select;
      if (level = 0) address(index) end;
    end for;
    error("Mismatched jump: %=", jump)
  end block;
end find-address;

define sealed method execute
    (jump :: <jump-forward>, bf :: <bf>) => ()
  local method find-jump (bf)
	  find-address(bf, forward-range(bf), <jump-forward>)
	end method;
  when (bf.bf-memory[bf.bf-mp] = 0)
    bf.bf-pp := jump.jump-address | find-jump(bf)
  end;
end execute;

define sealed method execute
    (jump :: <jump-backward>, bf :: <bf>) => ()
  local method find-jump (bf)
	  find-address(bf, backward-range(bf), <jump-backward>)
	end method;
  when (bf.bf-memory[bf.bf-mp] ~= 0)
    bf.bf-pp := jump.jump-address | find-jump(bf)
  end;
end execute;

define sealed domain execute (<jump-forward>, <bf>);
define sealed domain execute (<jump-backward>, <bf>);

////////////////////////////////////////////////////////////////////////
//
// Print objects
//
////////////////////////////////////////////////////////////////////////

define method print-object
    (jump :: <jump-instruction>, s :: <stream>) => ()
  when (jump.jump-address)
    write(s, integer-to-string(jump.jump-address))
  end;
  next-method();
end;

////////////////////////////////////////////////////////////////////////
//
//  Equal methods
//
////////////////////////////////////////////////////////////////////////

define method \=
    (this :: <jump-instruction>, that :: <jump-instruction>)
 => (equals? :: <boolean>)
  next-method() & this.jump-address = that.jump-address
end;

define sealed domain \= (<jump-instruction>, <jump-instruction>);
