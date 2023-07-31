.. highlight:: shell

*********************
Brainfuck interpreter
*********************

Brainfuck interpreter written in Open Dylan.
   
How it works
============

The interpreter parses the source code and transform it to
`<instruction>` classes. Every character is a comment except `<`, `>`,
`+`, `-`, `.`, `[`, and `]` that are instructions.

After that the program is optimized and interpreted.

Running a program
=================

To execute a brainfuck program called `hello.bf` use:

  dylan-brainfuck hello.bf
  
Optimization
============

By default every program is optimized as follows:

0. No optimization.
1. Remove comments.
2. Group instructions.
3. Reset to zero
4. Precalculate jumps.

The optimization is controlled by the 'optimize' option followed by a
number between '0' and '3'. Every optimization includes the
optimizations with a number smaller than the number passed. For
instance, an optimization of '2' (group instructions) includes the
optimization '1' (remove comments).

  dylan-brainfuck -O 2 hello.bf

Remove comments
---------------

All characters from source code are transformed in objects of the
class `<comment>`. Even this class does nothing when executed, we can
save time removing it.

Group optimization
------------------

A group of instructions of the same type are grouped in one. For
instance, a group of three `<memory-data-instruction>`, '+++', is
optimized as one '3+'. The group of instructions are subclasses of
`<memory-instruction>`: `<memory-data-instruction>` and
`<memory-pointer-instruction>`.

Reset to zero
-------------

When a pattern like `[-]` is found, it is replaced by an instruction
`<reset-to-zero>` that puts the memory item to 0.

Precalculate jumps
------------------

When an instruction `JumpForward` is executed, it must move to the
pair `JumpBackward` instruction. This process can be faster if we
precalculate the jump ahead. Every `JumpForward` is changed with a
`PrecalculatedJumpForward` with a fix instruction address. At the same
time the `JumpBackward` instruction is removed and changed for a
`PrecalculatedJumbBackward`.

Examples
========

In folder the 'res/' there are some brainfuck programs. I'm sorry I
don't remember the source of all of them. There are more examples in
`http://esoteric.sange.fi/brainfuck/bf-source/prog/`


Library structure and dependencies
==================================

The libraries used by the project are shown with the modules inside.
The arrows between the modules are the dependencies.

.. graphviz::
   :caption: Libraries and modules used

   digraph G {
         bgcolor  = "#00000000";
	 fontname = "Helvetica,Arial,sans-serif";
	 ranksep  = 1.0;
	 
         graph [compound=true];
	 node  [fontname="Helvetica,Arial,sans-serif";shape=box;]
	 edge  [fontname="Helvetica,Arial,sans-serif"]

	
	 subgraph cluster_dbf {
	   color = lightgrey;
	   label = "dylan-nbody library";
	   "dylan-brainfuck-impl";
	   "dylan-brainfuck";
	 };
	
	 subgraph cluster_cd {
	   color   = lightgrey;
	   label   = "common-dylan library";
	   rank    = same;
	   rankdir = LR;
	   "common-dylan";
	   transcendentals;
         };
	
         subgraph cluster_io {
           color = lightgrey;
	   label = "io library";
	   rank  = same;
	   format;
	   "format-out";
	   streams;
	   print;
	 };

        subgraph cluster_system {
           color = lightgrey;
	   label = "system library";
	   rank  = same;
	   "file-system";
	   "locators";
	   "standard-io";
	 };	 

	 "dylan-nbody-impl" -> streams        [ltail=cluster_dbf, lhead=cluster_io];
	 "dylan-nbody-impl" -> "common-dylan" [ltail=cluster_dbf, lhead=cluster_cd];
    }

.. toctree::
   :maxdepth: 2
   :hidden:

   brainfuck
   
Index and Search
================

* :ref:`genindex`
* :ref:`search`
