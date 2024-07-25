# token.rb - class Token : the Token data type

# token enums

EOF = 0xFF
NEWLINE = 0xFE
WS = 0xFD
COMMENT = 0xFC

# punctuation tokens
SEMICOLON = 0xEF
COLON = 0xEE
LPAREN = 0xED
RPAREN = 0xEC
LBRACE = 0xEB
RBRACE = 0xEA
LBRACKET = 0xE9
RBRACKET = 0xE8

PIPE = 0xE7
AMPERSAND = 0xE6
GT = 0xE5
LT = 0xE4
DOLLAR = 0xE3
ATSIGN = 0xE2
PERCENT = 0xE1
TILDE = 0xE0
COMMA = 0xDF
EQUALS = 0xDE


# words, keywords and strings
BARE = 0xCF
DQUOTE = 0xCE
SQUOTE = 0xCD
IDENT = 0xCC   # these will start out life as BARE; then get narrowd in parser

# regex patterns
$regex_bare =  /[\/\.\-_\?\[\]0-9A-Za-z][\/\.\-\{\}:_\?\[\]0-9A-Za-z]*/
$regex_ident = /[_A-Za-z][_A-Za-z0-9]*/
$regex_dquote = /"[^"]*"/
$regex_squote = /'[^']*'/
def lx_is_punct?(char)
  [';', ':', '|', '&', '@', '~', ',', '<', '>', '(', ')', '{', '}', '[', ']', '%', '~', '$', '='].member?(char)
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






def lx_punct_type(char)
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

def token_names(type)
  if type >= COMMA and type <= SEMICOLON
    lx_punct_name(type)
  else
  case type
  when EOF
    "<EOF>"
  when NEWLINE
    "<new line>"
when WS
  "<white space>"
  when COMMENT
    "<comment>"
  when BARE
    "bare string"
  when DQUOTE
    "double quoted string"
  when SQUOTE
    "single quoted string"
  when EQUALS
    "<equal sign>"
  else
    "!Unknown!"
  end
  end
end

class Token
  # remember where our lines start at
  @@line_number = 1
  # MUST fix
  def self.reset
    @@line_number = 1
  end

  def initialize(contents, type: EOF)
    @contents = contents
    @type = type
    if @type == NEWLINE
      @@line_number += 1
    end
    @line_number = @@line_number
  end
  attr_reader :contents, :type, :line_number

  def to_s
    "content: >#{@contents}<, type: #{token_names(@type)}, line: #{@line_number}"
  end
end
