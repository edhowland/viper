# TODO



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