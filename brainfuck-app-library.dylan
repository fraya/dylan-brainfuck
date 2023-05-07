Module: dylan-user
Synopsis: Module and library definition for executable application

define library brainfuck-app
  use common-dylan;
  use io;
  use system;
  
  use brainfuck;
end library;

define module brainfuck-app
  use common-dylan;
  use format-out;
  use file-system;
  use locators;
  
  use brainfuck;
end module;
