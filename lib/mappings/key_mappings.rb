# key_mappings.rb - method key_mappings returns a hash of keys to syms
def key_mappings
    {
    "\u0011" => :ctrl_q,
    "\u0013" => :ctrl_s,
    "\003" => :ctrl_c,   
  "\004" => :ctrl_d,
    "\b" => :ctrl_h,
    "\n" => :ctrl_j,
    "\v" => :ctrl_k,
    "\f" => :ctrl_l,
    "\t" => :tab,
    "\u007F" => :backspace,
  "\033[A" => :up,
  "\033[B" => :down,
  "\033[C" => :right,
  "\033[D" => :left, 
  # punctuation
    ';' => :semicolon,
    ':' => :colon,
    '.' => :period,
    ',' => :comma,
    '?' => :question,
    '!' => :exclamation,
    '~' => :tilde,
    '`' => :accent,
    '@' => :at,
    '#' => :number,
   '$' => :dollar,
    '%' => :percent,
    '^' => :caret,
    '&' => :ampersand,
    '*' => :asterisk,
    '(' => :lparen,
    ')' => :rparen,
    '-' => :hyphen,
    '_' => :underline,
    '=' => :equals,
  '+' => :plus,
  '\\' => :backslash,
    '/' => :slash,
    '|' => :pipe,
   "'" => :apostrophe,
    '"' => :quote,
    '<' => :less,
    '>' => :greater,
    '[' => :lbracket,
    ']' => :rbracket,
    '{' => :lbrace,
    '}' => :rbrace
  }
end
