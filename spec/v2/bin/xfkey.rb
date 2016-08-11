# xfkey - class Xfkey - command xfkey - maps bytes to string representsations

class Xfkey
  def call *args, env:, frames:
    values = env[:in].read
    if ('A'..'Z').include?(values) || ('a'..'z').include?(values) || ('0'..'9').include?(values)
      env[:out].write "key_#{values}" 
      return true
    end
    result = {
      "\r" => "key_return",
      "\e" => "escape",
      " " => "key_space",
      "\u007F" => 'key_backspace',
      
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
      "\\" => 'key_backslash',
      "|" => 'key_pipe',
      "=" => 'key_equals',
      "+" => 'key_plus',
      "-" => 'key_dash',
      "_" => 'key_underline',
      ")" => 'key_rparen',
      "(" => 'key_lparen',
      "*" => 'key_star',
      "&" => 'key_ampersand',
      "^" => 'key_caret',
      "%" => 'key_percent',
      "$" => 'key_dollar',
      "#" => 'key_number',
      "@" => 'key_at',
      "!" => 'key_exclaim',
      "`" => 'key_accent',
      "~" => 'key_tilde',
    # control keys      
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

