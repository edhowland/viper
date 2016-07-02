# TODO


0. Implement HAL - hardware abstraction layer
  refactor all calls to File.open, Dir, etc? to @hal in VM
    Implement some sort of VFS:
        Has root path: /v -> adjustable
    has '.', '..' dirs
  0.1: correct ls behaviour currently
[check]] 1. implement RedirectStdoutToStderr
2. Expand redirected_statement.rb to include crossover types
[check]] 2.1: Somehow add multiple redirections to RedirectedStatement
3. add tests to StringLiteral, test in assignment*_spec USING string interpolation
[check]]4. Expand Argument to return a possible ArgumentList if given a name with a glob E.g. file*.rb, etc.
[check]]5. modify grammar to find bare string literals
[check]] 6. make string types visible in new vish.kpeg
[check]]7. add multiple statements, blocks
[check] 8. add '|' Pipe class @left, @right = RedirectedStatement(s)
[check] 9. Add BooleanAnd, BooleanOr @left=RedirectedStatement, @right=RedirectedStatement
[check] 10. add functions
[check]  10.1 implement argument list for functions
[check]  10.2 - implement binding actual args to passed arguments on frame stack
  [check] 10.3 make sure empty args work
[chekc] 11. add alias expansion
  [check] 11.1 Check for cyclic references, e.g. alias foo=bar;alias bar=baz;alias baz=foo
[chack]12. builtins in virtual machine
  [check] cd, pwd, :pwd, :oldpwd, cd -   # [NO IMPLEMENT], pushd, popd
[check]    alias - lists aliases in this VM, either single or full list
  [check] unalias
[check]      declare -f -> lists functions, uses the to_s method for Function object
  [check] declare lists all variables
  [check] Add query function in args
          - only functions in this VM instance, see: #13 below
  [check] break - support for loops, subshells.
  [check] eval given a string, parse it and execute it in a new VM
  [check] exit - like break - maybe alias?
[check]            13. make SubShell .new called in parser, invokes a new VirtualMachine
               run the block, returns the final result.
[check]                14. Sub shell expansion.  As above, invokes a new VM, the output of ios[:out] is captured and returned.
    As above, :exit_status is set to the result of the last command

15. make comments, empty lines work w/o syntax errors