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