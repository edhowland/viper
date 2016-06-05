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

# add letters to /mode/vedit/bind
(('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a).each do |letter|
  Viper::VFS["mode"]["vedit"]["bind"]["key_#{letter}"] = "echo \"#{letter}\" >+ /buf/0"
end

# add some punctuation characters
def add_special_letter letter, value
    Viper::VFS["mode"]["vedit"]["bind"]["#{letter}"] = "echo \"#{value}\" >+ /buf/0"
  end

  add_special_letter :space, ' '
  

# setup /mode/vedit/speech/*
Viper::VFS["mode"]["vedit"]["speech"] = { "space" => "say space" }

(('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a).each do |letter|
  Viper::VFS["mode"]["vedit"]["speech"]["key_#{letter}"] = "say \"#{letter}\""
end
