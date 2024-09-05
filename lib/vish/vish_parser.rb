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
    #puts "p_peek: #{@lexer.tokens[@pos].contents}"
    @lexer.tokens[@pos]
  end

  def p_next
    #tok = p_peek
    tok =  @lexer.tokens[@pos]
    # uncomment for debugging
    #$stderr.puts "p_next: #{@pos}: #{tok.to_s}"
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
      res
    else
      #puts "maybe_backup :  will backup, now: #{@pos}, prev: #{tok}"
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


  def p_seq(*seq,  &blk)
    res =  []
    will_fail = false
    maybe_backup do
      cnt = 0
      seq.each do |ele|
        #puts "p_seq: cnt: #{cnt}"
         cnt +=  1
        x =  ele.call()
        if x == false
          will_fail = true
          #puts "p_seq: breaking early"
          break
        end
        #puts "p_seq:  continuing to next part of rule"
        res += x
      end
    unless will_fail
      if block_given?
        blk.call(*res)
      else
        res
      end
    else
      false
    end
  end
  end

  def _x_p_all(*seq, &blk)
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

  def choice(*l)
    res = false
    maybe_backup do
      l.each do |e|
      res =  e.call
      break if res
      end
      res
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

  # simpler version of glob
  def n_glob
    if p_peek.type ==  BARE
      glob_lit(p_next.contents)
    else
      false
    end
  end


  def variable(&blk)
  unwrap_if(p_seq(expect(COLON), -> { enclose_when(identifier) }, &blk))
  end


  # given either a single or double quoted string return AST node matching type
  # or if block, then execute that before returning
  def string(&blk)
    res =  case p_peek.type
    when SQUOTE
      QuotedString.new(unquote(p_next.contents))
    when DQUOTE
      StringLiteral.new(unquote(p_next.contents))
    else
      false
    
    end
    return false unless res
    if block_given?
      blk.call(res)
    else
      res
    end
  end

  def x_string(&blk)
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

# this belongs in  argument: method
     # -> { bare_string {|s| Argument.new(s) } },

  # this MUST be a choice between glob, lambda, subshell_expansion, deref, .etc
  def x_argument
    p_alt(
      glob,
      -> { lambda_declaration },
      -> { string {|s| Argument.new(s) } },
      -> { variable {|v| Argument.new(Deref.new(v)) } },
      -> { subshell_expansion },
      -> { lazy_block },
    )
  end

  def argument
    case p_peek.type
    when AMPERSAND
      lambda_declaration
    when COLON
      #puts "checking colon for net token: #{@lexer.tokens[@pos + 1].to_s}"
      if @lexer.tokens[@pos + 1].type == LPAREN
        #puts "think we are in subshell_expansion"
        subshell_expansion
      else
        #puts "think we are in  variable deref"
        variable {|v| Argument.new(Deref.new(v)) }
      end
    when SQUOTE, DQUOTE
      string {|s| Argument.new(s) }
    when LBRACE
      lazy_block
    else
      n_glob
    end
  end


  # A list of statements is either a single expression, or several expressions
  # strung together with either semicolons or newlines
  def statement_list
    choice(
    #-> { p_seq(-> { expression }, either(SEMICOLON, NEWLINE), -> { statement_list }) {|s1, s2|p s1, s2;   [s1] + [s2] } },
      -> { p_seq(-> { expression }, either(SEMICOLON, NEWLINE), -> { statement_list }) },
      -> { expression }
    )
  end


  # a block is a list of statements: TODO MUST expand this when statement_list is completed
  def block
    Block.new(statement_list)
  end



  # the recursive case for function_args
  def function_args_1
    p_seq(-> { enclose_when(identifier) }, expect(COMMA), -> { function_args })
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
    return false unless @lexer.tokens[@pos].type == AMPERSAND
    p_seq(expect(AMPERSAND), expect(LPAREN), -> { enclose_when(function_args) }, expect(RPAREN),expect(LBRACE), -> { enclose_when(block) }, expect(RBRACE)) {|a, b|   LambdaDeclaration.new(a, b) }
  end



    def subshell_expansion
    #return false unless @lexer.tokens[@pos].type == COLON
      p_seq(expect(COLON), expect(LPAREN), -> { enclose_when(block) }, expect(RPAREN)) {|b| SubShellExpansion.new(b) }
    end

  # 
  def lazy_block
    p_seq(expect(LBRACE), -> { p_opt(expect(NEWLINE)) }, -> { enclose_when(block) }, -> { p_opt(expect(NEWLINE)) }, expect(RBRACE)) {|b| LazyArgument.new(b) }
  end
  def assignment
    p_seq(match_ident, expect(EQUALS), ->{ enclose_when(argument) }) {|k, v| Assignment.new(k, v) }
  end

  def element
    case p_peek.type
    when LT, GT
      redirection
    when BARE
      if @lexer.tokens[@pos + 1].type == EQUALS
        assignment
      else
        argument
      end
    when AMPERSAND, COLON, SQUOTE, DQUOTE, LBRACE
      argument
    else
      false
    end
  end

  def x_element
    p_alt(-> { assignment }, -> { argument }, -> { p_redirection })
  end

  # a context is something that gets stuffed into a statement
  def context
    p_alt(
      -> { p_seq(-> { enclose_when(element) }, -> { context }) },
      -> { enclose_when(element) }
    )
  end

  def p_redirect_in
    p_seq(consume(LT), -> { enclose_when(argument) }) {|op, t| Redirection.new(op, t) }
  end

  # parses redirection to stdout : > bar.txt
  def p_redirect_out
    p_seq(consume(GT), -> { enclose_when(argument) }) {|op, t| Redirection.new(op, t) }
  end

# parses redirection for append: >> target
def p_redirect_append
  p_seq(expect(GT), expect(GT), -> { enclose_when(argument) }) {|t| Redirection.new('>>', t) }
end

  def redirection
    case p_peek.type
    when LT
      p_redirect_in
    when GT
      if @lexer.tokens[@pos +  1].type == GT
        p_redirect_append
      else
        p_redirect_out
      end
    else
      false
    end
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
      -> { p_seq(-> { enclose_when(redirection) }, -> { redirection_list }) },
      -> { enclose_when(redirection) },
      epsilon
    )
  end
  # a subshell which is a kind of expression
  def subshell
    #return false unless @lexer.tokens[@pos].type == LPAREN
    p_seq(-> { [redirection_list] }, expect(LPAREN), -> { enclose_when(block) }, expect(RPAREN), -> { [redirection_list] }) {|r1, s, r2| SubShell.new(s, r1 + r2) }
  end

  # an alias declaration. other methods of calling alias, like 'alias' and 'alias foo' are treated like normal statements w/o or with arguments
  def alias_declaration
    tk = p_peek; return false unless tk.type ==  ALIAS; lnum =  tk.line_number #lnum = p_peek.line_number
    p_seq(expect(ALIAS), -> { enclose_when(identifier) }, expect(EQUALS), -> { enclose_when(argument) }) {|i, a|  AliasDeclaration.new(i.to_s, a, lnum)  }
  end

  def alias_invocation
    tk = p_peek; return false unless tk.type ==  ALIAS; lnum =  tk.line_number #lnum = p_peek.line_number
    p_alt(
      -> { p_seq(expect(ALIAS), consume(BARE)) {|v| Statement.new([glob_lit('alias'), glob_lit(v)], lnum) } },
      -> { p_seq(expect(ALIAS)) {|| Statement.new(['alias'], lnum) } }
    )
  end

  # a function declaration
  def function_declaration
    tk = p_peek; return false unless tk.type ==  FUNCTION; lnum =  tk.line_number#lnum = p_peek.line_number
    p_seq(expect(FUNCTION), -> { enclose_when(identifier) }, expect(LPAREN), -> { enclose_when(function_args) }, expect(RPAREN), expect(LBRACE), -> { p_opt(expect(NEWLINE)) }, -> { enclose_when(block) }, -> { p_opt(expect(NEWLINE)) }, expect(RBRACE)) {|n, a, b|    FunctionDeclaration.new(n.to_s, a, b, lnum)  }
  end

  # wrapper around context that makes a new Statement
  def statement
    lnum = p_peek.line_number
    p_seq(-> { context }) {|*c| Statement.new(c, lnum) }
  end

  # expression_kind are types of expressions. E.g. statements, function declarations and aliases
  def x_expression_kind
    p_alt(
      -> { statement },
      -> { function_declaration },
      -> { alias_declaration },
      -> { subshell },
      -> { alias_invocation },
    )
  end

  def expression_kind
    case p_peek.type
    when FUNCTION
      function_declaration
    when ALIAS
      res =       alias_declaration
      unless res
        alias_invocation
      else
        res
      end
    when LPAREN
      subshell
    else
      statement
    
    end
  end

  # a piped expression is one kind of expression compound type
  def piped_expression
      lnum = p_peek.line_number
    p_seq(-> { enclose_when(expression_kind) }, expect(PIPE), -> { expression }) {|l, r| [ Pipe.new(l, r, lnum) ] }
  end


  # a logical and operation using double ampersands:  'foo && bar'
  def logical_and
    lnum = p_peek.line_number
    p_seq(-> { enclose_when(expression_kind) }, expect(AMPERSAND), expect(AMPERSAND), -> { expression }) {|l, r| [ BooleanAnd.new(l, r, lnum) ] }
  end

  # a logical or using double pipe or 'foo || bar'
  def logical_or
    lnum = p_peek.line_number
    p_seq(-> { enclose_when(expression_kind) }, expect(PIPE), expect(PIPE), -> { expression }) {|l, r|[ BooleanOr.new(l, r, lnum) ] } 
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

