# parser.rb : parser for Vish language
#takes string and runs it first through lexer
# then strips outcomments
# finally, uses recursive descent algorythm and returns Block instance



# initializes parser data structures
def p_init
strip_comments
strip_whitespace
collapse_newlines

p_reset
end

# examines the current token without advancing the $p_tok index
def p_peek
  $tokens[$p_tok]
end

# gets the next token and advanves the token index $p_tok
def p_next
  x = $p_tok
  $p_tok += 1
  $tokens[x]
end

# The Epsilon or empty string case
def p_epsilon
  -> { [] }
end

# collection stuff: seq and alt
def p_add_if(i, j)
  if i
    j = j.()
    if j
      i + j
    else
      false
    end
  else
    false
  end
end


# returns a closure that:
# If the current token is expected, consume it and return its contents, else return false
# and wrap it in an array for further processing
def consume(exp, &blk)
  -> {
  if p_peek.type == exp
    if block_given?
      [ blk.call(p_next.contents) ]
    else
      [ p_next.contents ]
    end
  else
    false
  end
  
  }
end


# if the current token is expected, consume it and return empty array  [], else return false
# actually returns a closure that can be used in p_seq, p_alt
def expect(exp)
  -> {
  if p_peek.type == exp
    p_next
    []
  else
    false
  end
  
  }
end

def restore_unless(&blk)
  stok = $p_tok
  res = blk.call
  unless res
    $p_tok = stok
  end
  res
end


# formerly p_seq
# all items in listin order must be there, and must be closures
# will be run in turn and resulting array returned unless block is present
# and if block, parameters of block are mapped to elements of array. Remember
# that any expects will be skipped over and not be present in result or args to
# block params
def p_all(*l, &blk)
  restore_unless do
  t = l.reduce([]) {|i, j| p_add_if(i, j) }
  if t
    if block_given?
      blk.call(*t)
    else
      t
    end
  else
    false
  end
  end
end

def _p_seq(*l, &blk)
  restore_unless do
    t = l.reduce([]) {|i,j| i && ((t = j.()) ? i + t : false) }
    if block_given?
      blk.call(*t)
    else
      t
    end
  end
  end


# Alternatives. Tries every closure and returns the one that eventually succeeds
def p_alt(*l)
  restore_unless do
    l.reduce(false) {|i,j| i || j.() }
  end
end


# util functions
def glob_lit(str)
  Glob.new(StringLiteral.new(str))
end
# Grammar rules


# a single argument
def p_arg
  consume(BARE) {|v| glob_lit(v) } 
  end



# arg_list sub rule 1
def p_arg_list_1
  p_all( p_arg, -> { p_arg_list })
end

# A possible list of arguments to a command
def p_arg_list
  p_alt(->{ p_arg_list_1 },
    p_arg,
    p_epsilon)
end





# An assignment is a variable name, (e.g. ident)and equal sign and a bare string
# TODO: must try and narrow down the variable name which starts out life as a
# BARE string but must be here an IDENT
def p_assignment
  p_all(consume(BARE), expect(EQUALS), consume(BARE)) {|n, v| [ Assignment.new(n, v) ] }
end

# A command is part of a statement
def p_command
  restore_unless do
    #p_peek.type == BARE && [  glob_lit(p_next.contents)  ]
    consume(BARE) {|it| glob_lit(it) }
  end
end

# a command with 0 or more arguments
def p_command_args
  p_all( p_command, -> { p_arg_list })
end

# parses a single statement
def p_statement
  lnum = p_peek.line_number
  t = p_alt(
    -> { p_assignment },
  -> {p_command_args },
  )
  if t
    [ Statement.new(t, lnum) ]
  else
    false
  end
end


# parses a statement list with newlines between them
def p_statement_list_1
  p_all(-> { p_statement },  expect(NEWLINE), -> { p_statement_list })
end


# parses statements delimited with semicolons
def p_statement_list_2
  p_all(-> { p_statement }, expect(SEMICOLON), -> { p_statement_list })
end


# parses a list of statements
def p_statement_list
  p_alt(-> { p_statement_list_1 },
    -> { p_statement_list_2 },
    -> { p_statement },
    p_epsilon
  )
end

# parses a block
def p_block
  p_statement_list
end


# strips out comments
def strip_comments
  $tokens = $tokens.reject {|t| t.type == COMMENT }
end

# strips out whitespace
def strip_whitespace
  $tokens = $tokens.reject {|t| t.type == WS }
end

# collapse all runs of newlines into a single newline
def collapse_newlines
  $tokens = $tokens.extend(Dropper) # will add .drop_while {|it| ... it ... } to that array
  deletes = []
  # find adjacent newlines
  $tokens.zip($tokens.drop(1)).each do |x, y|
    if x.type == NEWLINE and y.type == NEWLINE
      deletes << y.object_id
    end
  end

  # Now remove them
  $tokens = $tokens.reject {|t| deletes.member?(t.object_id) }
  # drops leading and trailing extra newlines
  $tokens = $tokens.drop_while {|it| it.type == NEWLINE }.reverse.drop_while {|it| it.type == NEWLINE }.reverse
end

# parses strings and if successful returns new Block
def vparse(source)
  lex source
  lx_run

  p_init
  $p_ast = p_block
  raise SyntaxError.new("Un expected end of input") unless $tokens[$p_tok].type == EOF
  Block.new($p_ast)
end

# debugging support

# resets the parser to the beginning
def p_reset
  $p_ast = []
  $p_tok = 0
end