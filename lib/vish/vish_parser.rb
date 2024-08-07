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


  def unwrap_if(target)
    if target
      if target.class == Array
        target.first
      else
        target
      end
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


  def variable(&blk)
  unwrap_if(p_all(expect(COLON), -> { enclose_when(identifier) }, &blk))
  end


  # given either a single or double quoted string return AST node matching type
  # or if block, then execute that before returning
  def string(&blk)
    s = p_alt(
    match(DQUOTE) {|s| QuotedString.new(s) },
    match(SQUOTE) {|s| StringLiteral.new(s) }
    )
    return false unless s
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

# this belongs in def argument:
     # -> { bare_string {|s| Argument.new(s) } },

  # this MUST be a choice between glob, lambda, subshell_expansion, deref, .etc
  def argument
    p_alt(
      glob,
      -> { lambda_declaration },
      -> { string{|s| Argument.new(s) } },
      -> {  variable {|v| Argument.new(Deref.new(v)) } },
      -> { subshell_expansion },
      -> { lazy_block },
    )
  end


  def statement_list_semicolon
    p_all(-> { expression }, expect(SEMICOLON), -> { statement_list }) {|s1, s2| [s1] + [s2] }
  end

  def statement_list_newline
    p_all(-> { expression }, expect(NEWLINE), -> { statement_list }) {|s1, s2| [s1] + [s2] }
  end

  def statement_list
    p_alt(
      -> { statement_list_semicolon },
      -> { statement_list_newline },
      -> { expression }
    )
  end


  # a block is a list of statements: TODO MUST expand this when statement_list is completed
  def block
    Block.new([])
  end



  # the recursive case for function_args
  def function_args_1
    p_all(-> { enclose_when(identifier) }, expect(COMMA), -> { function_args })
  end


  def function_args
    p_alt(
      -> { function_args_1 },
      -> { enclose_when(identifier)  },
      epsilon
      )
  end
  # a lambda is an argument to something else or a return value
  def lambda_declaration
    p_all(expect(AMPERSAND), expect(LPAREN), -> { enclose_when(function_args) }, expect(RPAREN),expect(LBRACE), -> { enclose_when(block) }, expect(RBRACE)) {|a, b|   LambdaDeclaration.new(a, b) }
  end



    def subshell_expansion
      p_all(expect(COLON), expect(LPAREN), -> { enclose_when(block) }, expect(RPAREN)) {|b| SubShellExpansion.new(b) }
    end

  def lazy_block
    p_all(expect(LBRACE), -> { enclose_when(block) }, expect(RBRACE)) {|b| LazyArgument.new(b) }
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




  # a subshell which is a kind of expression
  def subshell
    p_all(expect(LPAREN), -> { enclose_when(block) }, expect(RPAREN)) {|s| [ SubShell.new(s) ] }
  end

  # an alias declaration. other methods of calling alias, like 'alias' and 'alias foo' are treated like normal statements w/o or with arguments
  def alias_declaration
    p_all(expect(ALIAS), -> { enclose_when(identifier) }, expect(EQUALS), -> { enclose_when(argument) }) {|i, a| [ AliasDeclaration.new(i, a) ] }
  end

  # a function declaration
  def function_declaration
    p_all(expect(FUNCTION), -> { enclose_when(identifier) }, expect(LPAREN), -> { enclose_when(function_args) }, expect(RPAREN), expect(LBRACE), -> { enclose_when(block) }, expect(RBRACE)) {|n, a, b|   [ FunctionDeclaration.new(n, a, b, 0) ] }
  end

  # wrapper around context that makes a new Statement
  def statement
    p_all(-> { context }) {|c| Statement.new(c, 0) }
  end
  # expression_kind are types of expressions. E.g. statements, function declarations and aliases
  def expression_kind
    p_alt(
      -> { subshell },
      -> { alias_declaration },
      -> { function_declaration },
      -> { statement },
    )
  end

  # a piped expression is one kind of expression compound type
  def piped_expression
    p_all(-> { enclose_when(expression_kind) }, expect(PIPE), -> { expression }) {|l, r| [ Pipe.new(l, r) ] }
  end


  # a logical and operation using double ampersands:  'foo && bar'
  def logical_and
    p_all(-> { enclose_when(expression_kind) }, expect(AMPERSAND), expect(AMPERSAND), -> { expression }) {|l, r| [ BooleanAnd.new(l, r) ] }
  end

  # a logical or using double pipe or 'foo || bar'
  def logical_or
    p_all(-> { enclose_when(expression_kind) }, expect(PIPE), expect(PIPE), -> { expression }) {|l, r|[ BooleanOr.new(l, r) ] } 
  end

  # expressions are compound statement types, e.g. a piped expression
  def expression
    p_alt(
      -> { piped_expression },
      -> { logical_and },
      -> { logical_or },
      -> { enclose_when(expression_kind) }
    )
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

