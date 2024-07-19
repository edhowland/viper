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
# parses a single statement
def p_statement
  if p_peek().type == BARE
    [ Statement.new(p_next.contents) ]
  else
    false
  end
end

# parses a list of statements
def p_statement_list
  p_statement
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
  p_init
  $p_ast = p_block
  raise SyntaxError.new("Un expected end of input") unless $tokens[$p_tok].type == EOF
  Block.new($p_ast)
end