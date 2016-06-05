# mode - buffers /mode/vedit

Viper::VFS["mode"] = {
  "vedit" => {
    "bind" => {
      "key_i" => "echo i >+ /buf/0",
      "key_j" => "echo j >+ /buf/0",
      "ctrl_q" => "exit",
      "ctrl_d" => "pry",
      "meta_semicolon" => "vish"
    }
    }
  }
