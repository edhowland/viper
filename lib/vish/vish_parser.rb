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

    # predefined procs for  common token expectors or consumers
    @x_lparen =  expect(LPAREN)
    @x_rparen =  expect(RPAREN)
    @x_lbrace = expect(LBRACE)
    @x_rbrace = expect(RBRACE)
    @x_function = expect(FUNCTION)
    @x_alias = expect(ALIAS)
    @x_newline = expect(NEWLINE)
    @x_semicolon = expect(SEMICOLON)
    @x_colon = expect(COLON)
    @x_ampersand = expect(AMPERSAND)
    @x_pipe = expect(PIPE)

  # the either semicolon, newline proc
  @e_semi_nl =  either(SEMICOLON, NEWLINE)

    # consumer procs
    @c_lt = consume(LT)
    @c_gt = consume(GT)
    # storage for  collected docstrings
    @docstrings = Hash.new {|| '<empty>'  }
  end
  attr_reader :source, :lexer, :pos, :pos_limit, :docstrings

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
      #puts "maybe_backup :  will backup, now  cur(@pos): #{@pos}, prev (tok): #{tok}"
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
  # this returns a Proc that can be called by p_seq  or choice
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



  # optional production (part)
  def p_opt(prc)
    choice(
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



  # new  statement_list
  def statement_list(acc: [])
    res = expression
    if res
      if [SEMICOLON, NEWLINE].member?(p_peek.type)
      p_next  # eat the  semicolon or  newline
        statement_list(acc: acc + res)
      else
        acc + res
      end
    else
      acc  #false
    end
  end
  # A list of statements is either a single expression, or several expressions
  # strung together with either semicolons or newlines


  # a block is a list of statements: TODO MUST expand this when statement_list is completed
  def block
    Block.new(statement_list)
  end



  # new  function arg method
  def function_args(acc:  [])
    case p_peek.type
    when RPAREN
      acc
    when BARE
      function_args(acc: acc + [p_next.contents.to_sym])
    when COMMA
      return false if acc.empty?  # do not  allow:    (, bar ,baz)
      p_next
      return false unless p_peek.type == BARE
      function_args(acc: acc + [p_next.contents.to_sym])
    else
      return false
    end
  end
  # the recursive case for function_args
  def function_args_1
    p_seq(-> { enclose_when(identifier) }, expect(COMMA), -> { function_args })
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


  def parse_context(acc:  false)
    if !([GT,LT,SQUOTE, DQUOTE,BARE,COLON,AMPERSAND,LBRACE].member?(p_peek.type))
      acc
    else
      res = element
      return acc unless  res
      acc ||= []
      acc <<  res
      parse_context(acc: acc)
    end
  end
  def context
    maybe_backup { parse_context }
  end
  # a context is something that gets stuffed into a statement


  def p_redirect_in
    p_seq(@c_lt, -> { enclose_when(argument) }) {|op, t| Redirection.new(op, t) }
  end

  # parses redirection to stdout : > bar.txt
  def p_redirect_out
    p_seq(@c_gt, -> { enclose_when(argument) }) {|op, t| Redirection.new(op, t) }
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





  # Collect any redirections into a list, this must be passed to SubShell.new
  # TODO: this should really work  like Statement and  just be part of the context
  # In Bash,  you  cannot do this w/o getting a  syntax error
  # For now,  leave it alone because
  #  1: rarely  used in actual code
  # 2:  Changes must be made in semantic layer first
  def redirection_list
    choice(
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
    tk = p_peek; return false unless tk.type ==  ALIAS; lnum =  tk.line_number
    if @pos < @lexer.tokens.length
    return false unless @lexer.tokens[@pos +  1].type == BARE
    return false unless @lexer.tokens[@pos +  2].type == EQUALS
    end
    #p_seq(expect(ALIAS), -> { enclose_when(identifier) }, expect(EQUALS), -> { enclose_when(argument) }) {|i, a|  AliasDeclaration.new(i.to_s, a, lnum)  }
    p_next # consume the alias keyword
    ident=p_next.contents; p_next; 
    val=argument
    return false unless val
    AliasDeclaration.new(ident, val, lnum)
  end

  # an alias invocation is wher, in the REPL, the user does alias to get all the aliases or alias name to get just that alias
  # Not  worth doing a perf  improvement because it only is needed interactively, not to load loading the source for the editor
  def alias_invocation
    tk = p_peek; return false unless tk.type ==  ALIAS; lnum =  tk.line_number #lnum = p_peek.line_number
    choice(
      -> { p_seq(expect(ALIAS), consume(BARE)) {|v| Statement.new([glob_lit('alias'), glob_lit(v)], lnum) } },
      -> { p_seq(expect(ALIAS)) {|| Statement.new(['alias'], lnum) } }
    )
  end

  def function_declaration
    maybe_backup do
      if p_peek.type ==  FUNCTION
    #puts 'lexeme ==  fn'
        lnum =  p_peek.line_number
        p_next
        if p_peek.type ==  BARE
      #puts 'ident found'
          ident =  p_next.contents
          if p_peek.type ==  LPAREN
            p_next
            args =  function_args
            if p_peek.type ==  RPAREN and args
#puts 'got args and  right  paren'
              p_next
              if p_peek.type == LBRACE
    #puts 'got  left brace'
                p_next
                if p_peek.type ==  NEWLINE
                  p_next
                end
  #puts 'about to get block'
                bk =  block
                if p_peek.type == RBRACE and bk
  #puts  'found block and right brace'
                  p_next
                  FunctionDeclaration.new(ident, args, bk, lnum)
                else
                  false
                end
              else
                false
              end
            else
              false
            end
          else
            false
          end
        else
          false
        end
      else
        false
      end
    end
  end


  # a function declaration


  # wrapper around context that makes a new Statement
  def statement
    lnum = p_peek.line_number
    p_seq(-> { context }) {|*c| Statement.new(c, lnum) }
  end

  # expression_kind are types of expressions. E.g. statements, function declarations and aliases

  def expression_kind
#puts  "expression_kind: #{p_peek.to_s}"
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
  def piped_expression(expr: nil)
      lnum = p_peek.line_number
    p_seq(-> { enclose_when(expr || expression_kind) }, expect(PIPE), -> { expression }) {|l, r| [ Pipe.new(l, r, lnum) ] }
  end


  # a logical and operation using double ampersands:  'foo && bar'
  def logical_and(expr: nil)
    lnum = p_peek.line_number
    p_seq(-> { enclose_when(expr || expression_kind) }, @x_ampersand, @x_ampersand, -> { expression }) {|l, r| [ BooleanAnd.new(l, r, lnum) ] }
  end

  # a logical or using double pipe or 'foo || bar'
  def logical_or(expr: nil)
    lnum = p_peek.line_number
    p_seq(-> { enclose_when(expr || expression_kind) }, @x_pipe, @x_pipe, -> { expression }) {|l, r|[ BooleanOr.new(l, r, lnum) ] } 
  end

  def expression
    expr =  expression_kind
    return false unless expr
    if p_peek.type == PIPE
      if @lexer.tokens[@pos + 1].type ==  PIPE
        logical_or(expr: expr)
      else
        piped_expression(expr: expr)
      end
    else
      if p_peek.type == AMPERSAND and @lexer.tokens[@pos + 1].type == AMPERSAND
        logical_and(expr: expr)
      else
        enclose_when(expr)
      end
    end
  end

  # expressions are compound statement types, e.g. a piped expression

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

