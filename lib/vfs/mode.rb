# mode - buffers /mode/vedit

Viper::VFS["mode"] = {
  "vedit" => {
    "bind" => {
      "ctrl_q" => "exit",
      "ctrl_d" => "pry",
      "meta_colon" => "vish"
    }
    }
  }
Viper::VFS["mode"]["vedit"]["speech"] = { "space" => "say space" }

# add letters to /mode/vedit/bind
(('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a).each do |letter|
  Viper::VFS["mode"]["vedit"]["bind"]["key_#{letter}"] = "echo \"#{letter}\" >+ :_buf"
  Viper::VFS["mode"]["vedit"]["speech"]["key_#{letter}"] = "say \"#{letter}\""
end

# add puctuation, other chars
[
                          [:apostrophe, "'"],
  [:asterisk, '*', 'star'], [:accent, '`'], [:at, '@', '@'],
  [:tilde, '~'], [:exclamation, '!', 'exclaim'], [:number, '#'],
                          [:dollar, '$'], [:percent, '%'], [:caret, '^'],
                            [:ampersand, '&'],
  [:lparen, '(', 'lap'], [:rparen, ')', 'rap'], [:hyphen, '-', 'dash'],
                          [:underline, '_'], [:plus, '+'], [:equals, '='],
                          [:backslash, '\\'], [:pipe, '|'],
  [:lbracket, '[', 'lack'], [:rbracket, ']', 'rack'],
  [:lbrace, '{', 'lace'], [:rbrace, '}', 'race'],
  [:less, '<'], [:greater, '>'], [:question, '?'], [:slash, '/'],
  [:period, '.'], [:comma, ',']
].each do  |e|
  k, v, s = e
  Viper::VFS["mode"]["vedit"]["bind"]["#{k}"] = "echo \"#{v}\" >+ :_buf"
  Viper::VFS["mode"]["vedit"]["speech"]["#{k}"] = "say \"#{s || k}\""
end

# special case for escaped chars
Viper::VFS["mode"]["vedit"]["bind"]["quote"] = "echo '\"' >+ :_buf"
Viper::VFS["mode"]["vedit"]["speech"]["quote"] = 'say quote'


# add some punctuation characters
def add_special_letter letter, value
    Viper::VFS["mode"]["vedit"]["bind"]["#{letter}"] = "echo \"#{value}\" >+ :_buf"
  end

  add_special_letter :space, ' '

# setup /mode/vedit/speech/*


# special case TODO: for now of ASCII chars values, like CR, etc.
Viper::Variables[:cr] = "\n"

Viper::VFS["mode"]["vedit"]["bind"]["return"] = "echo :cr >+ /buf/0"
Viper::VFS["mode"]["vedit"]["speech"]["return"] = "say new line"
# add special tab char - uses repeat primative - TODO: how to solve arch problem
Viper::VFS["mode"]["vedit"]["bind"]["tab"] = "repeat :indent ' ' >+ :_buf"
Viper::VFS["mode"]["vedit"]["speech"]["tab"] = "say tab"
# add some control characters
bind = Viper::VFS["mode"]["vedit"]["bind"]
speech = Viper::VFS["mode"]["vedit"]["speech"]

bind["ctrl_l"] = "nop"
speech["ctrl_l"] = "cat <_ :_buf"
bind["ctrl_j"] = "nop"
speech["ctrl_j"] = "cat <. :_buf"

bind["shift_home"] = "sol :_buf"
speech["shift_home"] = "cat <. :_buf"
bind["shift_end"] = "eol :_buf"
speech["shift_end"] = "cat <. :_buf"

 bind["shift_pgup"] = "top :_buf"
 speech["shift_pgup"] = "say 'top of buffer'"
 
 bind["shift_pgdn"] = "bottom :_buf"
 speech["shift_pgdn"] = "say 'bottom of buffer'"



bind["right"] = "+ :_buf"
speech["right"] = "cat <. :_buf"

bind["left"] = "- :_buf"
speech["left"] = "cat <. :_buf"

bind["down"] = "down :_buf"
speech["down"] = "cat <_ :_buf"

bind["up"] = "up :_buf"
speech["up"] = "cat <_ :_buf"


