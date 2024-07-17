# parser.rb : parser for Vish language
#takes string and runs it first through lexer
# then strips outcomments
# finally, uses recursive descent algorythm and returns Block instance


# parses strings and if successful returns new Block
def vparse(source)
  lex source
  lx_run
  $p_tok = 0
  raise SyntaxError.new("Un expected end of input") unless $tokens[$p_tok].type == EOF
  Block.new([])
end