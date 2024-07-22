# parser.rb : parser for Vish language
#takes string and runs it first through lexer
# then strips outcomments
# finally, uses recursive descent algorythm and returns Block instance



# initializes parser data structures
def p_init
  $p_ast = []
  $p_tok = 0
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

# collection stuff: seq and alt

# if the current token is expected, consume it and return [], else return false
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

def p_seq(*l)
  restore_unless do
    l.reduce([]) {|i,j| i && ((t = j.()) ? i + t : false) }
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
  restore_unless do
    tok = p_next
    tok.type == BARE && [ tok.contents ]
  end
end


# arg_list sub rule 1
def p_arg_list_1
  p_seq(-> { p_arg }, -> { p_arg_list })
end

# A possible list of arguments to a command
def p_arg_list
  p_alt(->{ p_arg_list_1 },
    -> { p_arg },
    -> { [] })
end




# A command is part of a statement
def p_command
  restore_unless do
    p_peek.type == BARE && [  glob_lit(p_next.contents)  ]
  end
end
# parses a single statement
def p_statement
  (t = p_seq(-> { p_command }, -> { p_arg_list })) && [ Statement.new(t, p_peek.line_number) ]
end


# parses a statement list with newlines between them
def p_statement_list_1
  p_seq(-> { p_statement },  expect(NEWLINE), -> { p_statement_list })
end


# parses statements delimited with semicolons
def p_statement_list_2
  p_seq(-> { p_statement }, expect(SEMICOLON), -> { p_statement_list })
end


# parses a list of statements
def p_statement_list
  p_alt(-> { p_statement_list_1 }, -> { p_statement_list_2 }, -> { p_statement }, -> { [] })
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
  deletes = []
  # find adjacent newlines
  $tokens.zip($tokens.drop(1)).each do |x, y|
    if x.type == NEWLINE and y.type == NEWLINE
      deletes << y.object_id
    end
  end

  # Now remove them
  $tokens = $tokens.reject {|t| deletes.member?(t.object_id) }
end

# parses strings and if successful returns new Block
def vparse(source)
  lex source
  lx_run
  strip_comments
  strip_whitespace
  collapse_newlines
  p_init
  $p_ast = p_block
  raise SyntaxError.new("Un expected end of input") unless $tokens[$p_tok].type == EOF
  Block.new($p_ast)
end

# debugging support

# resets the parser to the beginning
def p_reset
  p_init
end