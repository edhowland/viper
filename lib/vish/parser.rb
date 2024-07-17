# parser.rb : parser for Vish language
#takes string and runs it first through lexer
# then strips outcomments
# finally, uses recursive descent algorythm and returns Block instance



# parses a list of statements
def p_statement_list
  []
end

# parses a block
def p_block
  p_statement_list
end


# strips out comments
def strip_comments
  $tokens = $tokens.reject {|t| t.type == COMMENT }
end
# parses strings and if successful returns new Block
def vparse(source)
  lex source
  lx_run
  strip_comments
  $p_tok = 0
  $p_ast = []
  $p_ast = p_block
  raise SyntaxError.new("Un expected end of input") unless $tokens[$p_tok].type == EOF
  Block.new($p_ast)
end