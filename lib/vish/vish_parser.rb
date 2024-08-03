# vish_parser.rb : class VishParser - takes source string returns Block

require_relative 'lex'

class VishParser
  def initialize(source)
    @source = source
    @lexer = Lexer.new(@source)
    @pos = 0
  end
  attr_reader :source, :lexer, :pos

  def p_peek
    @lexer.tokens[@pos]
  end

  def p_next
    tok = p_peek
    if @pos < @lexer.tokens.length
      @pos += 1
    else
      raise RuntimeError.new("parser exceeded all tokens from the lexer")
    end
    tok
  end

  # support functions
  def maybe_backup(&blk)
    tok = @pos
    res = blk.call
    if res
      res#
    else
      @pos = tok
      return false
    end
  end

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

  def p_all(*seq, &blk)
  maybe_backup do
  t = seq.reduce([]) {|i, j| p_add_if(i, j) }
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

def p_alt(*l)
  maybe_backup do
    l.reduce(false) {|i,j| i || j.() }
  end
end

  # Grammar
  def statement_list
    []
  end

  def setup
    @lexer.run
    @lexer.tokens.reject! {|t| t.type == COMMENT }.reject! {|t| t.type == WS }
    #collapse_newlines
  end

  # start me up
  def run
    setup
  # Make a block out of trying to parse a statement list
  Block.new(statement_list())
  end
end

