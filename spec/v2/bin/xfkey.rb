# xfkey - class Xfkey - command xfkey - maps bytes to string representsations

class Xfkey
  def call *args, env:, frames:
    values = env[:in].read
    if ('A'..'Z').include?(values) || ('a'..'z').include?(values)
      env[:out].write "key_#{values}" 
      return true
    end
    result = {
      "\r" => "return",
      "\e" => "escape",
      " " => "space",
      "." => 'key_period',
      "," => "key_comma",
      "<" => 'key_less',
      ">" => 'key_greater',
      "/" => 'key_slash',
      "?" => 'key_question',
      "'" => 'key_apostrophe',
      '"' => 'key_quote',
      ";" => 'key_semicolon',
      ":" => 'key_colon',
      "]" => 'key_rbracket',
      "}" => 'key_rbrace',
      "[" => 'key_lbracket',
      "{" => 'key_lbrace',
      
      "\u0011" => 'ctrl_q'
    }[values]
    unless result.nil?
      env[:out].write result
      true
    else
      env[:out].write "unknown"
      false

    end
  end
end

