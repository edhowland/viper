# lex.rb - function lex : Takes a string as imput and returns array of Tokens
# Can also throw an error if no matching token type is recognized

def lex(source)
  $source = source
  $cursor = 0
  $fin = source.length
  $tokens = []
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