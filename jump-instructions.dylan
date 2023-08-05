Module: brainfuck-impl
Synopsis: Jump instructions
Author: Fernando Raya
Copyright: GPLv3

// Jump instruction

define abstract class <jump-instruction> (<instruction>)
  slot jump-address :: false-or(<program-pointer>) = #f,
    init-keyword: address:;
end;

define method print-object
    (jump :: <jump-instruction>, s :: <stream>) => ()
  when (jump.jump-address)
    write(s, integer-to-string(jump.jump-address))
  end
end;

define method \=
    (this :: <jump-instruction>, that :: <jump-instruction>)
 => (equals? :: <boolean>)
  next-method() & this.jump-address = that.jump-address
end;

// Jump forward

define class <jump-forward> (<jump-instruction>) end;

define method print-object
    (jump :: <jump-forward>, s :: <stream>) => ()
  write-element(s, '[');
  next-method()
end;

define method execute
    (jump :: <jump-forward>, bf :: <interpreter>) => ()
  local
    method find-jump-backward(bf)
      block (addr)
	let level = 1;
	for (index from bf.program-pointer + 1 below bf.interpreter-program.size)
	  select (object-class(program-at(bf, index)))
	    <jump-forward>  => level := level + 1;
	    <jump-backward> => level := level - 1;
	    otherwise       => ;
	  end select;
	  when (level = 0) addr(index) end
	end for;
	error(make(<brainfuck-error>, instruction: bf.current-instruction))
      end block;
    end method;
  when (bf.memory-item = 0)
    bf.program-pointer := jump.jump-address | find-jump-backward(bf)
  end when;
end execute;

// Jump backward

define class <jump-backward> (<jump-instruction>) end;

define method print-object
    (jump :: <jump-backward>, s :: <stream>) => ()
  write-element(s, ']');
  next-method()
end;

define method execute
    (jump :: <jump-backward>, bf :: <interpreter>) => ()
  local
    method find-jump-forward(bf)
      block (addr)
	let level = 1;
	for (index from bf.program-pointer - 1 to 0 by -1)
	  select (object-class(program-at(bf, index)))
	    <jump-forward>  => level := level - 1;
	    <jump-backward> => level := level + 1;
	    otherwise       => ;
	  end select;
	  when (level = 0) addr(index) end
	end for;
	error(make(<brainfuck-error>, instruction: bf.current-instruction))
      end block;
    end method;
  when (bf.memory-item ~= 0)
    bf.program-pointer := jump.jump-address | find-jump-forward(bf)
  end when;
end execute;
