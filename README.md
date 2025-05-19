# Dylan Brainfuck 

[![build](https://github.com/fraya/dylan-brainfuck/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/fraya/dylan-brainfuck/actions/workflows/build-and-test.yml)

Brainfuck interpreter written in [Opendylan](https://opendylan.org/)
programming language.

This is an exploration of Opendylan features (mainly multimethods) and
is not trying to be "as fast as possible".

## Installation

TODO

## Execution

  brainfuck-app <program> <optimization-level>

where:

- _program_ is a brainfuck program
- _optimization-level_ is a number between 0 and 4 (default `4`):
    - `0`: No optimization
    - `1`: Remove comments
    - `2`: Group similar instructions (e.g. `++` becomes `+2`)
    - `3`: Replace pattern `[-]` with a reset to zero
    - `4`: Precalculate jumps (e.g. `[+>]` becomes `[3+>]0`

### Examples

In the directory `examples` there are several brainfuck programs.

## TODO

### General

- [X] Load a program from a `<string>`
- [X] Load a program from a file (`<locator>`)

### Instructions

- [X] increment-data 
- [X] decrement-data
- [X] increment-pointer
- [X] decrement-pointer
- [ ] input
- [X] output
- [X] jump-forward
- [X] jump-backward

### Optimizations

- [X] Remove comments
- [X] Group instructions
- [X] Replace `[-]` pattern for a reset to zero instruction.
- [X] Precomputed jumps

## Project organization

```bash
├── documentation       # documentation in .rst format
├── dylan-package.json  # project description
├── examples            # program examples in .bf language
└── src                 # source code
    ├── app               # application
    ├── lib               # library
    └── tests             # tests
```