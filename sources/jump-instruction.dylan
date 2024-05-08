Module: brainfuck-impl
Synopsis: Jump instructions 
Author: Fernando Raya
Copyright: GPLv3

////////////////////////////////////////////////////////////////////////
//
// Memory classes hierarchy 
//
////////////////////////////////////////////////////////////////////////

define abstract class <jump-instruction> (<instruction>)
  slot jump-address :: false-or(<program-pointer>) = #f,
    init-keyword: address:;
end;

define class <jump-forward>  (<jump-instruction>)
end;

define class <jump-backward> (<jump-instruction>)
end;

////////////////////////////////////////////////////////////////////////
//
// Execute methods
//
////////////////////////////////////////////////////////////////////////

define method execute
    (jump :: <jump-forward>, bf :: <interpreter>) => ()
  local
    method find-address(bf)
      block (address)
	let level = 1;
	let jump  = bf.current-instruction;
	for (index from bf.program-pointer + 1 below bf.interpreter-program.size)
	  select (object-class(instruction-at(bf, index)))
	    <jump-forward>  => level := level + 1;
	    <jump-backward> => level := level - 1;
	    otherwise       => ;
	  end select;
	  if (level = 0) address(index) end;
	end for;
	signal(make(<brainfuck-error>, instruction: jump));
      end block;
    end method;
  when (bf.interpreter-memory.memory-item = 0)
    bf.program-pointer := jump.jump-address | find-address(bf)
  end;
end execute;

define method execute
    (jump :: <jump-backward>, bf :: <interpreter>) => ()
  local
    method find-address(bf)
      block (address)
	let level = 1;
	let jump  = bf.current-instruction;
	for (index from bf.program-pointer - 1 to 0 by -1)
	  select (object-class(instruction-at(bf, index)))
	    <jump-forward>  => level := level - 1;
	    <jump-backward> => level := level + 1;
	    otherwise       => ;
	  end select;
	  if (level = 0) address(index) end;
	end for;
	error(make(<brainfuck-error>, instruction: jump));
      end block;
    end method;
  when (bf.interpreter-memory.memory-item ~= 0)
    bf.program-pointer := jump.jump-address | find-address(bf)
  end;
end execute;

////////////////////////////////////////////////////////////////////////
//
// Print objects
//
////////////////////////////////////////////////////////////////////////

define method print-object
    (jump :: <jump-instruction>, s :: <stream>) => ()
  when (jump.jump-address)
    write(s, integer-to-string(jump.jump-address))
  end
end;

define method print-object
    (jump :: <jump-forward>, s :: <stream>) => ()
  write-element(s, '[');
  next-method()
end;

define method print-object
    (jump :: <jump-backward>, s :: <stream>) => ()
  write-element(s, ']');
  next-method()
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
