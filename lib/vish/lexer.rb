# lexer.rb - class Lexer - can be used with VishParser or other uses


class Lexer
  def initialize source
    @source = source
    @tokens = []
    @cursor = 0
    @fin = @source.length
    Token.reset # MUST make this an instance variable here
    @line_number
  end
  attr_reader :source, :cursor, :tokens, :fin, :line_number

  def tokens=(that)
    @tokens = that
  end

  def run
    while get(); end
    # TODO FIXME MUST reset all line numbers already inserted
  @tokens = @tokens.reduce([[Token.new("\n", type: NEWLINE), 0]]) {|i, j| tk, l = i[-1]; l += 1 if tk.type == NEWLINE; j.line_number = l; i << [j, l] }.drop(1).map {|i| i[0] }
  end

  def at
    @source[@cursor]
  end
  def advance(count=1)
    @cursor = @cursor + count
  end

  def whitespace
    unless [" ", "\t"].member?(at)
      return false
    end
    result = ''
    while @cursor < @fin
      if @source[@cursor] == ' ' or @source[@cursor] == "\t"
        result << @source[@cursor]
        advance
      else
        break
      end
    end
    Token.new(result, type: WS)
  end

  def comment
  return false unless (at == '#')
  result = ''

  while @cursor < @fin
    if @source[@cursor] == '#'
      advance
    elsif @source[@cursor] == "\n"
      break
    else
      result << @source[@cursor]
      advance
    end
  end
  Token.new(result, type: COMMENT)  
  end


  def keyword
    if @source[(@cursor)..(@cursor + 1)] == 'fn' and [' ', "\n", nil].member? @source[@cursor + 2] and @source[@cursor - 1] != ':'
      return Token.new('fn', type: FUNCTION)
    elsif @source[(@cursor)..(@cursor+7)] == 'function' and [' ', "\n", nil].member? @source[@cursor + 8]
      Token.new('function', type: FUNCTION)
    elsif @source[(@cursor)..(@cursor + 4)] == 'alias' and ([' ', "\n", nil].member?(@source[@cursor + 5]))
      Token.new('alias', type: ALIAS)
    else
      false
    end
  end

  def regex_bare
    /[\/\.\-_\?\*0-9A-Za-z][\/\.\-:_\?\*0-9A-Za-z]*/
  end
def regex_dquote
    /"[^"]*"/
end

def regex_squote
  /'[^']*'/
end

def regex(pattern)
  m = pattern.match(@source[@cursor..])
  if m
    m[0]
  else
    false
  end
end



  def is_punct?(char)
      [';', ':', '|', '&', '@', '~', ',', '<', '>', '(', ')', '{', '}', '[', ']', '%', '~', '$', '='].member?(char)

  end
def punct_name(type)
  {
SEMICOLON => "<semicolon>",
COLON => "<colon>", 
LPAREN => "<left paren>", 
RPAREN => "<right paren", 
LBRACE => "<left brace>",
RBRACE => "<right brace>",
LBRACKET => "<left bracket>",
RBRACKET => "<right bracket>",
PIPE => "<pipe>",
AMPERSAND => "<ampersand>", 
GT => "<gt>",
LT => "<lt>", 
DOLLAR => "<dollar>", 
ATSIGN => "at sign>",
PERCENT => "<percent>", 
TILDE => "<tilde>", 
COMMA => "<comma>",
    EQUALS => "<equal sign>",
  }[type]
end



def lx_punct_name(type)
  {
SEMICOLON => "<semicolon>",
COLON => "<colon>", 
LPAREN => "<left paren>", 
RPAREN => "<right paren", 
LBRACE => "<left brace>",
RBRACE => "<right brace>",
LBRACKET => "<left bracket>",
RBRACKET => "<right bracket>",
PIPE => "<pipe>",
AMPERSAND => "<ampersand>", 
GT => "<gt>",
LT => "<lt>", 
DOLLAR => "<dollar>", 
ATSIGN => "at sign>",
PERCENT => "<percent>", 
TILDE => "<tilde>", 
COMMA => "<comma>",
    EQUALS => "<equal sign>",
  }[type]
end






def punct_type(char)
  {
    ";" => SEMICOLON,
    ":" => COLON ,
    "(" => LPAREN,
    ")" => RPAREN,
    "{" => LBRACE,
    "}" => RBRACE,
    "[" => LBRACKET,
    "]" => RBRACKET,
    "|" => PIPE,
    "&" => AMPERSAND,
    ">" => GT,
    "<" => LT,
    "$" => DOLLAR,
    "@" => ATSIGN,
    "%" => PERCENT,
    "~" => TILDE,
    "," => COMMA,
    '=' => EQUALS,
  }[char]
end


  def get
  if @cursor >= @fin
    @tokens << Token.new('', type: EOF)
    return false 
  end

  if at == "\n"
    @tokens << Token.new(at, type: NEWLINE)
    advance
    return true
  end

  # check for keyword
  if (t = keyword)
    @tokens << t
    advance(t.contents.length)
    return true
  end


  if (t = whitespace)
    @tokens << t
    return true
  end

  if (t = comment)
    @tokens << t
    return true
  end

    if is_punct?(at)
      @tokens << Token.new(at, type: punct_type(at))
      advance
      return true
    end
  case at

  when '"'
    tmp = regex(regex_dquote)
    @tokens << Token.new(tmp, type: DQUOTE)
    advance(tmp.length)
  when "'"
    tmp = regex(regex_squote)
    @tokens << Token.new(tmp, type: SQUOTE)
    advance(tmp.length)


  when /[\/\.\-_\?\*\[\]0-9A-Za-z]/
      tmp = regex(regex_bare)
      @tokens << Token.new(tmp, type: BARE)
    advance(tmp.length)
  else
    raise RuntimeError.new("Unrecognized token type |#{@source[@cursor]}|")
  end
  return true
  end

  def x_tokens
    @tokens.each {|t| puts t.to_s }
  end
  def map_tokens(&blk)
    @tokens = blk.call(@tokens)
  end

end
