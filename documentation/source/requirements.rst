Requirements
------------

Program requirements
^^^^^^^^^^^^^^^^^^^^

This are the requirements for a :term:`program<Program>`.

RP01: read
""""""""""

Must be able to be read from:

- RP011: A :drm:`<string>`.
- RP012: A :class:`<stream>`.
- RP013: A :class:`<pathname>`.

RP02: size
""""""""""

We must know how many instructions has a program.

RP03: element
"""""""""""""

An :term:`instruction` can be accessed by an index. This index is a
:drm:`<integer>` number with range from 0 to the size of the program
minus 1.

RP04: append
""""""""""""

It is possible to add new instructions, returning a new
:term:`program<Program>` with this instruction added at the end.
