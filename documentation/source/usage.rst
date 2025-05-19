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

The argument *<program>* is the name of a is a BF source program that
is loaded and executed. If the program argument is missing, the USAGE
text is shown.

The *optimization* option is a number between 0 and 4 with a default
value of 4. The higher the optimization number is, the faster the
program will run.

Optimizations
^^^^^^^^^^^^^

The interpreter can optimize a :term:`program` with the following
techniques:

**No optimization** (level 0):
  The program is executed without optimizations.

**Remove comments** (level 1):
  All characters that are not instructions are removed. The
  :term:`program` is smaller and the time spent executing the NOP is
  saved.

**Group instructions** (level 2):
  This optimization apply first the *remove comments* optimization.
  All instructions that are of the same type are grouped and executed
  as one.

  For instance, two instructions that increment the memory data by 1
  ``>>`` are grouped and increment the memory data by 2.

  If a instruction is followed by its opposite, the instructions are
  cancelled. E.g. If an increment memory data is followed by a decrement
  memory data the instructions are removed (``><``).

  Instructions that are grouped are:

  - Increment data pointer.
  - Decrement data pointer.
  - Increment memory data.
  - Decrement memory data.

**Reset to zero** (level 3):
  This optimization apply first the level 1 and level 2 optimizations.

  The pattern ``[-]`` is replaced with an instruction that resets to
  zero (0) the memory data pointed by the data pointer.

**Precalculate jumps** (level 4):
  This optimization apply first the level 1, level 2 and level 3
  optimizations.

  This optimization MUST BE done the last.

  The program search for the complementary of ``[`` that is ``]`` and
  save the direction. Whe the instruction is executed it jumps to the
  direction stored.
