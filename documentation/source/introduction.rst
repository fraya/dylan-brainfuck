Introduction
------------

:term:`Brainfuck` (:term:`BF`) is an esoteric programming language
with only eight simple commands, a data pointer, and an instruction
pointer.

The present program is a vehicle to learn programming and design in
the Open Dylan programming language. The program could be simpler and
faster but is designed for experimentation.

Usage
-----

The program executable is called `brainfuck-app`.

If the executable is called without parameters it will show:

.. code-block:: console

   USAGE:
	   _build/bin/brainfuck-app <program> [optimization]

   optimization:
	   0: No optimization
	   1: Remove comments
	   2: Level 1 and group instructions
	   3: Level 2 and replace pattern [-] with reset to zero
	   4: Level 3 and precalculate jumps (default)


