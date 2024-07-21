# To Do list for parser fix

## Must do

- Check if need to restore_unless block in p_statement around p_alt alternatives

This might not be needed because all the alternatives actually already do this
and the final alternative does not consume anything.

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



## tokenizer: lex.rb

- lib/vish/token.rb
- lib/vish/lex.rb

```ruby
# globals: $tokens, $cursor and $source are created with:
lex("echo foo")
# Run a single step of the tokenizer
get
# => true
# ...
get
# => false
# when EOF is reached


# or:
lx_run;

# For debugging:
lx_tokens;
```



### The parser: vparse

````ruby
block = vparse("echo foo")
````


### Parser internals

Each rule in the grammar below becomes a Ruby function.
This includes  the alternatives after the '|' delimiter.
These inner rules are enumerated with _1, _2 etc with the rule name like thus:

- statement_list : Then entry point to the statement_list parser
- statement_list_1 : The first alternative : statement "\n" statement_list
- statement_list_2: The second alternative : statement ";" statement_list

Note: no need for a separate extra function for Epsilon, it is just tacked on as the last item in the alternatives list
... which is just an empty array literal because it can be appended to any other array.



## Argument parsing

Arguments in a shell like Vish or even Bash are just bare words or other kind
string literal (double or single quoted strings)
... this is just from the perspective of the parser, semantic actions notwithstanding
like glob or brace, variable expansion or redirections even alias expansions.
The parser is probably r-enterdd  again for each statement after expansions have
been completed.

A command can have 0 or many arguments.




### sequences and alternatives

Every rule in the grammar is just an alternation set of sequences.
A sequence is an ordered set in which every nonterminal and terminal must be
satisfied for the entire sequence to be satisfied.

An alternation is an ordered* set of sequences.
If at least one of the items in the alt set succeeds, then the entire alternation succeeds.
This is why the order matters for recursive descent matters.


#### Internal implementation details

Note that if a sequence proceeds to many items, the current token pointer
moves along until the sequence ends. If the sequence fails at some mid point,
then the previous token pointer must be restored as if we never went down that path.

This saving (and possible restoring) of the current token pointer
is not needed for processing a alternation because, each item in that set
is presumed to be a sequence which will restore the token pointer before the next
choice is tried.

##### Discarded terminals

A terminal or token like ';' or newline is needed to make the syntax correct
but is not passed along to the semantic action.

To discard the terminal, call the 'expect' function with the Token type
like SEMICOLON or NEWLINE like thus:

```ruby
expect(NEWLINE)
```

If the current token is the expected one, then it is consummed and an empty
array is returned, otherwise false is returned and the token pointer is left where it was.

Actually, expect does not really do anything, but returns a closure. See below.

##### Closure wrappers around calls to other grammar rule functions

Every element in the variadic argument list to 'p_seq' or 'p_alt' is meant
to be a closure. That closure should call some other part of the parser
grammar rule function set. The reason for this restriction is because Ruby will first
try and call the function before p_seq or p_alt even gets its grubby hands on
its arguments.

```ruby
p_seq(-> { p_arg }, -> { p_arg_list })
```

The above code shows  both the closure wrapping as well as mutual recursion.

```ruby
p_seq(-> { statement}, expect(SEMICOLON), -> { p_statement_list })
````

The above code shows the same thing, but expects a terminal: ';' that will be
ignored. Remember that the 'expect' function returns its own closure, so need to wrap it further.


* Here the concept of ordering is arbitrary and used in practice.
Each possible alternation is tested in sequence in the order they appear in the over grammar rule.
In actual language theory, it is assumed that is a nondetermininistic branching of choices.
IOW: They are all tried in parralel and if at least one of them succeeds, then the entire suceeds.
Note: source of shift-reduce and reduce-reduce  errors in LR parser generators like YACC and bison.

A grammar rule

## Further parser To Do items

Must expand single statement parser to handle extra  arguments to the statement
#### Vish EBNF

block ::= statement_list

statement_list ::= statement "\n" statement_list
               | statement ";" statement_list
               | statement
               | eps

statement ::= BARE (WS BARE)*

arg_list  ::= arg arg_list
          | arg
          | eps


## Must work

### Tokenizer:

- bare string regex is not fully developed yet

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

