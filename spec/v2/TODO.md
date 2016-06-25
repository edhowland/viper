# TODO

[v/] 1. implement RedirectStdoutToStderr
2. Expand redirected_statement.rb to include crossover types
3. add tests to StringLiteral, test in assignment*_spec USING string interpolation
4. Expand Argument to return a possible ArgumentList if given a name with a glob E.g. file*.rb, etc.
[x]5. modify grammar to find bare string literals
  Note: this is handled in argument rule
[v/] 6. make string types visible in new vish.kpeg
7. add multiple statements, blocks