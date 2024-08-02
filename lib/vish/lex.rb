# lex.rb - function lex : Takes a string as imput and returns array of Tokens
# Can also throw an error if no matching token type is recognized

# some common regexs
def regex_dquote
  #
end

def regex_squote
  /'[^']*'/
end

def regex_dquote
  /"[^"]*"/
end

def regex_bare
  /[\/\.\-_\?\[\]0-9A-Za-z][\/\.\-\{\}:_\?\[\]0-9A-Za-z]*/
end

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

  def run
    while get(); end
    # TODO FIXME MUST reset all line numbers already inserted
    @tokens.each {|t| t.line_number = 1 }
    # update only the newline tokens
    @tokens.select {|t| t.type == NEWLINE }.zip(2..).each {|t,n| t.line_number = n }
  # the initial seed token with a line number of 1 and type == NEWLINE
  seed = Token.new("\n", type: NEWLINE); seed.line_number = 1
  ([seed] + @tokens).zip((@tokens + [seed])).each do |i, j|
    j.line_number = i.line_number unless j.type == NEWLINE
  end
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
if @source[(@cursor)..(@cursor + 1)] == 'fn' 
  return Token.new('fn', type: FUNCTION)
  elsif @source[(@cursor)..(@cursor+7)] == 'function'
  Token.new('function', type: FUNCTION)
  elsif @source[(@cursor)..(@cursor + 4)] == 'alias'
  Token.new('alias', type: ALIAS)
  else
    false
  end
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


  when /[\/\.\-_\?\[\]0-9A-Za-z]/

      tmp = regex(regex_bare)
      @tokens << Token.new(tmp, type: BARE)
    advance(tmp.length)
  else
    raise RuntimeError.new("Unrecognized token type")
  end
  return true
  end

  def x_tokens
    @tokens.each {|t| puts t.to_s }
  end
end

def lex(source)
  $source = source
  $cursor = 0
  $fin = source.length
  $tokens = []
  Token.reset # MUST: fix when code here is moved to Lexer class
end

def advance(amount=1)
  $cursor += amount
end

def lx_whitespace
  result = ''
  while $cursor < $fin
    if $source[$cursor] == ' ' or $source[$cursor] == "\t"
      result << $source[$cursor]
      advance
    else
      break
    end
  end
  Token.new(result, type: WS)
end


# Consume a comment till the end of the next newline char or the EOF
def lx_comment
  result = ''
  while $cursor < $fin
    if $source[$cursor] == '#'
      advance
    elsif $source[$cursor] == "\n"
      break
    else
      result << $source[$cursor]
      advance
    end
  end
  Token.new(result, type: COMMENT)
end



# this is very AWK -like
# patterns and actions for keywords
# first matching pattern in this list has priority
$lx_keywords = [
  { pattern: /^(fn|function)/, action: ->(val) { Token.new(val, type: FUNCTION) }},
  { pattern: /^alias/, action: ->(val) { Token.new(val, type: ALIAS) } },
]

# Given the above structure of patterns/actions, try and find a matching in the char stream

# Abandoned: cannot figure out to not match future keywords given using ^pattern and interleaving newlines

# hard code every possible keyword char by char in $source
def lx_keyword
if $source[($cursor)..($cursor + 1)] == 'fn' 
  return Token.new('fn', type: FUNCTION)
  elsif $source[($cursor)..($cursor+7)]   == 'function'
  Token.new('function', type: FUNCTION)
  elsif $source[($cursor)..($cursor + 4)] == 'alias'
  Token.new('alias', type: ALIAS)
  else
    false
  end
end

# match on some regex
def lx_regex(pattern)
  m = pattern.match($source[$cursor..])
  if m
    m[0]
  else
    false
  end
end

# primary i/f to lexer
def get
  if $cursor >= $fin
    $tokens << Token.new('', type: EOF)
    return false 
  end


  # check for keyword
  if (t = lx_keyword)
    $tokens << t
    advance(t.contents.length)
    return true
  end
  if lx_is_punct?($source[$cursor])
    $tokens << Token.new($source[$cursor], type: lx_punct_type($source[$cursor]))
    advance
    return true
  end
  case $source[$cursor]
  when "\n"
    $tokens << Token.new($source[$cursor], type: NEWLINE)
    advance
  when " ", "\t"
    $tokens << lx_whitespace
  when "#"
    $tokens << lx_comment
  when '"'
    tmp = lx_regex($regex_dquote)
    $tokens << Token.new(tmp, type: DQUOTE)
    advance(tmp.length)
  when "'"
    tmp = lx_regex($regex_squote)
    $tokens << Token.new(tmp, type: SQUOTE)
    advance(tmp.length)


  when /[\/\.\-_\?\[\]0-9A-Za-z]/

      tmp = lx_regex($regex_bare)
      $tokens << Token.new(tmp, type: BARE)
    advance(tmp.length)
  else
    raise RuntimeError.new("Unrecognized token type")
  end
  return true
end


# debugging support
def lx_status
  "tokens: #{$tokens.length}, cursor: #{$cursor}, fin: #{fin}"
end


def lx_tokens
  $tokens.each {|t| puts t.to_s }
end

def lx_run
  while get(); end
end