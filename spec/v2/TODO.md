# TODO


0. Create Context taking an array of:
  any or none of the following
    redirection target:
      >, >>, 2> or < FileTarget
        One of OutTarget, InTarget, ErrTarget or OutAppender
        - also adds OutCloser, InCloser or ErrCloser
      2>&1, >&2
        - Err2outTarget or Out2errTarget
          - does not create a FileCloser
    Command - path to file, or variable dereferencer
    0 or more arguments
    0 or more assignments

  When called:
    sorts in this order:
      redirection
      crossover redirections
      arguments
      assignments
      command
   
[v/] 1. implement RedirectStdoutToStderr
2. Expand redirected_statement.rb to include crossover types
2.1: Somehow add multiple redirections to RedirectedStatement
3. add tests to StringLiteral, test in assignment*_spec USING string interpolation
[v/]4. Expand Argument to return a possible ArgumentList if given a name with a glob E.g. file*.rb, etc.
[v/]5. modify grammar to find bare string literals
[v/] 6. make string types visible in new vish.kpeg
[v/]7. add multiple statements, blocks
8. add '|' Pipe class @left, @right = RedirectedStatement(s)
9. Add BooleanAnd, BooleanOr @left=RedirectedStatement, @right=RedirectedStatement


Teststing

1. fix running call when redirect is involved