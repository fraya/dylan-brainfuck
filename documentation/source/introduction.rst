Introduction
------------

:term:`Brainfuck` (:term:`BF`) is an esoteric programming language
with only eight simple commands, a data pointer, and an instruction
pointer.

The present program is a vehicle to learn programming and design in
the Open Dylan programming language. The program could be simpler and
faster but is designed for experimentation.

Language design
^^^^^^^^^^^^^^^

The language specification from Wikipedia [1]_:

The language consists of eight commands. A brainfuck program is a
sequence of these commands, possibly interspersed with other
characters (which are ignored). The commands are executed
sequentially, with some exceptions: an instruction pointer begins at
the first command, and each command it points to is executed, after
which it normally moves forward to the next command. The program
terminates when the instruction pointer moves past the last command.

The brainfuck language uses a simple machine model consisting of the
program and instruction pointer, as well as a one-dimensional array of
at least 30,000 byte cells initialized to zero; a movable data pointer
(initialized to point to the leftmost byte of the array); and two
streams of bytes for input and output (most often connected to a
keyboard and a monitor respectively, and using the ASCII character
encoding).

The eight language commands each consist of a single character:

========= =====================================================================
Character Instruction Performed
========= =====================================================================
  ``<``   Decrement the data pointer by one (to point to the next cell to the
          left).
  ``+``   Increment the byte at the data pointer by one.
  ``-``   Decrement the byte at the data pointer by one.
  ``.``   Output the byte at the data pointer.
  ``,``   Accept one byte of input, storing its value in the byte at the data
          pointer.
  ``[``   If the byte at the data pointer is zero, then instead of moving
          the instruction pointer forward to the next command, jump it
          forward to the command after the matching ``]`` command.
  ``]``   If the byte at the data pointer is nonzero, then instead of
          moving the instruction pointer forward to the next command,
          jump it back to the command after the matching ``[`` command.
========= =====================================================================

.. [1] https://en.wikipedia.org/w/index.php?title=Brainfuck&oldid=1281127911
