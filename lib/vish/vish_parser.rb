# vish_parser.rb : class VishParser - takes source string returns Block

#require_relative 'lex'

module Deleter
  def deleteme!
    true
  end
end

class VishParser
  def initialize(source)
    @source = source
    @lexer = Lexer.new(@source)
    @pos = 0
  end
  attr_reader :source, :lexer, :pos, :pos_limit

  # unwrap any quote marks from strings, if they exist
  def unquote(s)
    if s[0] == "'" and s[-1] == "'"
      s[1..(-2)]
    elsif s[0] == '"' and s[-1] == '"'
      s[1..(-2)]
    else
      s
    end
  end
  def p_peek
    @lexer.tokens[@pos]
  end

  def p_next
    tok = p_peek
    # uncomment for debugging
    #$stderr.puts "#{@pos}: #{tok.to_s}"
    if @pos < @lexer.tokens.length
      @pos += 1
    else
      raise VishSyntaxError.new("parser exceeded all tokens from the lexer")
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


  # try both alternate token types and return empty array if either matches, else false
  def either(t1, t2)
    -> {
    if p_peek.type == t1 or p_peek.type == t2
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

  def epsilon
    -> { [] }
  end

  def p_all(*seq, &blk)
  maybe_backup do
  t = seq.reduce([]) {|i, j| p_add_if(i, j) }
  @limit_pos = @pos
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


  # optional production (part)
  def p_opt(prc)
    p_alt(
      prc,
      epsilon
    )
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
    match(DQUOTE) {|s| StringLiteral.new(unquote(s)) },
    match(SQUOTE) {|s| QuotedString.new(unquote(s)) }
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
      -> { string {|s| Argument.new(s) } },
      -> { variable {|v| Argument.new(Deref.new(v)) } },
      -> { subshell_expansion },
      -> { lazy_block },
    )
  end


  # A list of statements is either a single expression, or several expressions
  # strung together with either semicolons or newlines
  def statement_list
    p_alt(
    #-> { p_all(-> { expression }, either(SEMICOLON, NEWLINE), -> { statement_list }) {|s1, s2|p s1, s2;   [s1] + [s2] } },
      -> { p_all(-> { expression }, either(SEMICOLON, NEWLINE), -> { statement_list }) },
      -> { expression }
    )
  end


  # a block is a list of statements: TODO MUST expand this when statement_list is completed
  def block
    Block.new(statement_list)
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

  # 
  def lazy_block
    p_all(expect(LBRACE), -> { p_opt(expect(NEWLINE)) }, -> { enclose_when(block) }, -> { p_opt(expect(NEWLINE)) }, expect(RBRACE)) {|b| LazyArgument.new(b) }
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
    p_all(consume(LT), -> { enclose_when(argument) }) {|op, t| Redirection.new(op, t) }
  end

  # parses redirection to stdout : > bar.txt
  def p_redirect_out
    p_all(consume(GT), -> { enclose_when(argument) }) {|op, t| Redirection.new(op, t) }
  end

# parses redirection for append: >> target
def p_redirect_append
  p_all(expect(GT), expect(GT), -> { enclose_when(argument) }) {|t| Redirection.new('>>', t) }
end

#  choice between all possible redirection types
def p_redirection
  p_alt(
    -> { p_redirect_in },
    -> { p_redirect_append },
    -> { p_redirect_out },
  )
end




  # Collect any redirections into a list, this must be passed to SubShell.new
  def redirection_list
    p_alt(
      -> { p_all(-> { enclose_when(p_redirection) }, -> { redirection_list }) },
      -> { enclose_when(p_redirection) },
      epsilon
    )
  end
  # a subshell which is a kind of expression
  def subshell
    p_all(-> { [redirection_list] }, expect(LPAREN), -> { enclose_when(block) }, expect(RPAREN), -> { [redirection_list] }) {|r1, s, r2| SubShell.new(s, r1 + r2) }
  end

  # an alias declaration. other methods of calling alias, like 'alias' and 'alias foo' are treated like normal statements w/o or with arguments
  def alias_declaration
    lnum = p_peek.line_number
    p_all(expect(ALIAS), -> { enclose_when(identifier) }, expect(EQUALS), -> { enclose_when(argument) }) {|i, a|  AliasDeclaration.new(i.to_s, a, lnum)  }
  end

  def alias_invocation
    lnum = p_peek.line_number
    p_alt(
      -> { p_all(expect(ALIAS), consume(BARE)) {|v| Statement.new([glob_lit('alias'), glob_lit(v)], lnum) } },
      -> { p_all(expect(ALIAS)) {|| Statement.new(['alias'], lnum) } }
    )
  end

  # a function declaration
  def function_declaration
    lnum = p_peek.line_number
    p_all(expect(FUNCTION), -> { enclose_when(identifier) }, expect(LPAREN), -> { enclose_when(function_args) }, expect(RPAREN), expect(LBRACE), -> { p_opt(expect(NEWLINE)) }, -> { enclose_when(block) }, -> { p_opt(expect(NEWLINE)) }, expect(RBRACE)) {|n, a, b|    FunctionDeclaration.new(n.to_s, a, b, lnum)  }
  end

  # wrapper around context that makes a new Statement
  def statement
    lnum = p_peek.line_number
    p_all(-> { context }) {|*c| Statement.new(c, lnum) }
  end
  # expression_kind are types of expressions. E.g. statements, function declarations and aliases
  def expression_kind
    p_alt(
      -> { statement },
      -> { function_declaration },
      -> { alias_declaration },
      -> { subshell },
      -> { alias_invocation },
    )
  end

  # a piped expression is one kind of expression compound type
  def piped_expression
      lnum = p_peek.line_number
    p_all(-> { enclose_when(expression_kind) }, expect(PIPE), -> { expression }) {|l, r| [ Pipe.new(l, r, lnum) ] }
  end


  # a logical and operation using double ampersands:  'foo && bar'
  def logical_and
    lnum = p_peek.line_number
    p_all(-> { enclose_when(expression_kind) }, expect(AMPERSAND), expect(AMPERSAND), -> { expression }) {|l, r| [ BooleanAnd.new(l, r, lnum) ] }
  end

  # a logical or using double pipe or 'foo || bar'
  def logical_or
    lnum = p_peek.line_number
    p_all(-> { enclose_when(expression_kind) }, expect(PIPE), expect(PIPE), -> { expression }) {|l, r|[ BooleanOr.new(l, r, lnum) ] } 
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

  # Start of parsing
  
  # A correct parse is a block followd by an EOF
  def p_root
    b = block
    if b
      if expect(EOF).call
        b
      else
        raise VishSyntaxError.new("Expected end of file but got #{@lexer.tokens[@pos].to_s} instead. This occurredat token position #{@pos}")
      end
    else
      raise VishSyntaxError.new("Expected statement list but got something else")
    end
  end


  def setup
    @lexer.run
    @lexer.tokens.reject! {|t| t.type == COMMENT }
    @lexer.tokens.reject! {|t| t.type == WS }
    #collapse_newlines
    @lexer.tokens = @lexer.tokens.drop_while {|t| t.type == NEWLINE }
    # extract the end of file
    saved_tok = @lexer.tokens[-1]
    @lexer.tokens = @lexer.tokens.reverse[1..].drop_while {|t| t.type == NEWLINE }.reverse
    @lexer.tokens << saved_tok

  # Now eliminate extra runs of newlines collapsing them into a single newline per occurrance
    deletes = []
    @lexer.tokens.zip(@lexer.tokens[1..]).each do |i, j|
      if i.type == NEWLINE and j.type == NEWLINE
        deletes << j.object_id
      end
    end
    # now delete them
    @lexer.tokens = @lexer.tokens.reject {|t| deletes.member?(t.object_id) }
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

