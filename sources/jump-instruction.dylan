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

define sealed method execute
    (jump :: <jump-forward>, bf :: <bf>) => ()
  local
    method find-address(bf)
      block (address)
	let level = 1;
	let jump  = bf.bf-program[bf.bf-pp];
	for (index from bf.bf-pp + 1 below bf.bf-program.size)
	  select (object-class(instruction-at(bf, index)))
	    <jump-forward>  => level := level + 1;
	    <jump-backward> => level := level - 1;
	    otherwise       => ;
	  end select;
	  if (level = 0) address(index) end;
	end for;
	error("Mismatched jump: %=", jump);
      end block;
    end method;
  when (bf.bf-memory[bf.bf-mp] = 0)
    bf.bf-pp := jump.jump-address | find-address(bf)
  end;
end execute;
  
define sealed method execute
    (jump :: <jump-backward>, bf :: <bf>) => ()
  local
    method find-address(bf)
      block (address)
	let level = 1;
	let jump  = bf.bf-program[bf.bf-pp];
	for (index from bf.bf-pp - 1 to 0 by -1)
	  select (object-class(instruction-at(bf, index)))
	    <jump-forward>  => level := level - 1;
	    <jump-backward> => level := level + 1;
	    otherwise       => ;
	  end select;
	  if (level = 0) address(index) end;
	end for;
	error("Mismatched jump: %=", jump);
      end block;
    end method;
  when (bf.bf-memory[bf.bf-mp] ~= 0)
    bf.bf-pp := jump.jump-address | find-address(bf)
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
