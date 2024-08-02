# vish_parser.rb : class VishParser - takes source string returns Block

require_relative 'lex'

class VishParser
  def initialize(source)
    @source = source
    @lexer = Lexer.new(@source)
    @pos = 0
  end
  attr_reader :source, :lexer, :pos

  def peek
    @lexer.tokens[@pos]
  end

  def next
    tok = peek
    if @pos < @lexer.tokens.length
      @pos += 1
    else
      raise RuntimeError.new("parser exceeded all tokens from the lexer")
    end
    tok
  end

  # Grammar
  def statement_list
    []
  end
  # start me up
  def run
    @lexer.run
  # Make a block out of trying to parse a statement list
  Block.new(statement_list())
  end
end

