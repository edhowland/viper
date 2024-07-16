# To Do list for parser fix

## Abstract

This branch: parser-new represents a new hand written  recursive descent parser
from scratch. It is hoped to be plug-compatible with existing PEG generated parser.

## Existing

```bash
rake compile
````

will recompile  the ./lib/vish/vish.kpeg.rb from ./lib/vish/vish.kpeg which is the source PEG
using the kpeg gem.  Will only recompile if PEG source is newer than the .rb.

Will create a new class: Vish which is the actual parser.

```ruby
p  = Vish.new("echo foo\n")
p.parse
# => true
b = p.result;
b.class
# => Block
b.statement_list.length
# => 1
```

The entire source program (either from .vsh script file, or entered into the ivsh REPL
is just a simple array of items which are callable.

```ruby
# from b above
b.call env: vm.ios, frames: vm.fs
````

essentiall does:

````ruby
b.statement_list.each {|s| s.call(...) }
````



## New parser

Will handle comments in the tokenizer
They will be be valid tokens types that will be filtered out before parser.

But will still exist is needing to merge them for future usage as docstrings for function documentation


## Must work

- empty file
- empty line(s)
- comment
  * terminating with EOF
  * terminating with newline
-  Trailing comment
  * terminating with EOF
  * terminating with newline


## More complex

- All the above within curly braces
- files with random mixes of all statement types
- Intermixed with blank lines
  * and comments

