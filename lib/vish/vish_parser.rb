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


  # consumes a token and returns its contents in an array that can be appended to AST so far
  # this returns a Proc that can be called by p_all or p_alt
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


  # match works like consume but returns just the actual contents of the token
  # or whatever the block returns if given
  def match(exp, &blk)
    -> {
  if p_peek.type == exp
    if block_given?
      blk.call(p_next.contents)
    else
      p_next.contents
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

# utilities

  # Epsilon returns a closure wrapped empty array. Use as final alternative in lists.
  def epsilon
    -> { [] }
  end

  def enclose_when(target)
    if target
      [ target ]
    else
      false
    end
  end

def glob_lit(str)
  Glob.new(StringLiteral.new(str))
end


  # Grammar

  # handle identifiers whenever they occur herein
  def identifier(&blk)
    i = match(BARE) {|v| v.to_sym }.call
    if block_given?
      blk.call(i)
    else
      i
    end
  end

  def match_ident
    match(BARE) {|v| [ v.to_sym] }
  end
    def glob
      match(BARE) {|g| glob_lit(g) }
    end


  def variable
    p_all(expect(COLON), consume(BARE)) {|v| Deref.new(v.to_sym) }
  end


  # given either a single or double quoted string return AST node matching type
  # or if block, then execute that before returning
  def string(&blk)
    s = p_alt(
    match(DQUOTE) {|s| QuotedString.new(s) },
    match(SQUOTE) {|s| StringLiteral.new(s) }
    )
    if block_given?
      blk.call(s)
    else
      s
    end
  end


  def bare_string(blk)
    s = match(BARE) {|s|  StringLiteral.new(s) }
    if block_given?
      blk.call(s)
    else
      s
    end
  end

  # this MUST be a choice between glob, lambda, subshell_expansion, deref, .etc
  def argument
    p_alt(
      glob,
      -> { lambda_declaration },
      -> { string{|s| Argument.new(s) }  },
      -> { bare_string {|s| Argument.new(s) } },
      -> { variable },
    )
  end


  # a block is a list of statements: TODO MUST expand this when statement_list is completed
  def block
    Block.new([])
  end



  # the recursive case for function_args
  def function_args_1
    p_all(-> { identifier {|i| [ i ] } }, expect(COMMA), -> { function_args })
  end


  def function_args
    p_alt(
      -> { function_args_1 },
      -> { identifier {|i| [ i ] } },
      epsilon
      )
  end
  # a lambda is an argument to something else or a return value
  def lambda_declaration
    p_all(expect(AMPERSAND), expect(LPAREN), -> { enclose_when(function_args) }, expect(RPAREN),expect(LBRACE), -> { enclose_when(block) }, expect(RBRACE)) {|a, b| puts "args are : #{a.class.name} => #{a}";  LambdaDeclaration.new(a, b) }
  end
  def assignment
    p_all(match_ident, expect(EQUALS), ->{ enclose_when(argument) }) {|k, v| Assignment.new(k, v) }
  end

  def element
    p_alt(-> { assignment }, -> { argument }, -> { p_redirection })
  end

  # a context is something that gets stuffed into a statement
  def context
    p_alt(
      -> { p_all(-> { enclose_when(element) }, -> { context }) },
      -> { enclose_when(element) }
    )
  end

  def p_redirect_in
    p_all(consume(LT), consume(BARE)) {|op, t| Redirection.new(op, glob_lit(t)) }
  end

  # parses redirection to stdout : > bar.txt
  def p_redirect_out
    p_all(consume(GT), consume(BARE)) {|op, t| Redirection.new(op, glob_lit(t)) }
  end

# parses redirection for append: >> target
def p_redirect_append
  p_all(expect(GT), expect(GT), consume(BARE)) {|t| Redirection.new('>>', glob_lit(t)) }
end

#  choice between all possible redirection types
def p_redirection
  p_alt(
    -> { p_redirect_in },
    -> { p_redirect_append },
    -> { p_redirect_out },
  )
end


  def statement_list
    []
  end

  def setup
    @lexer.run
    @lexer.tokens.reject! {|t| t.type == COMMENT }
    @lexer.tokens.reject! {|t| t.type == WS }
    #collapse_newlines
  end

  # reset things
  def reset
    @pos = 0
  end
  # start me up
  def run
    setup
  # Make a block out of trying to parse a statement list
  Block.new(statement_list())
  end
end

