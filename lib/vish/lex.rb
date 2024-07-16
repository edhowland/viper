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

# primary i/f to lexer
def get
  if $cursor >= $fin
    $tokens << Token.new('', type: EOF)
    return false 
  end
  case $source[$cursor]
  when "\n"
    $tokens << Token.new($source[$cursor], type: NEWLINE)
    advance
  when " ", "\t"
    $tokens << lx_whitespace
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