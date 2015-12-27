# key_mappings.rb - method key_mappings returns a hash of keys to syms
def key_mappings
    {
    "\003" => :ctrl_c,   
    "\f" => :ctrl_l,
    "\t" => :tab,
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
    '#' => 'number',
   '$' => :dollar,
    '%' => :percent,
    '^' => :caret,
    '&' => :ampersand,
    '*' => :asterik,
    '(' => :lparen,
    ')' => :rparen,
    '-' => :hyphen,
    '_' => :underline,
    '=' => :equals,
  '+' => :plus,
  '\\' => :backslash,
    '/' => :slash,
    '|' => :pipe
  }
end
