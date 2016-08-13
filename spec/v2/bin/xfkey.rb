# xfkey - class Xfkey - command xfkey - maps bytes to string representsations
# arg: [-h] :  print human readable version
# Usage: raw - | xfkey  # generates key_j if j pressed. ctrl_q if Ctrol-Q hit.
# echo key_space | xfkey -h  # prints human understandable character: "space"
class Xfkey
  def key_to_unicode values
#  binding.pry

    uni = values.chars.map {|e| e.unpack('H*')[0] }.map {|e| '\\u00' + e }

    @out.puts uni.join(' ')
    true
  end
  def key_to_name values
        if ('A'..'Z').include?(values) || ('a'..'z').include?(values) || ('0'..'9').include?(values)
      @out.write "key_#{values}" 
      return true
    end
    unis = (1..26).to_a.map {|e| [e].pack('U') }
    if unis.member? values
      unpacked = values.unpack('C')[0]
      ctrl = 'ctrl_' + (unpacked + 64).chr.downcase
      @out.write ctrl

      return true
    end
    result = {
      "\e" => "escape",
      "\u007F" => 'key_backspace',
      # punctuation
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
      # movement keys
      "\u001b" + "\u005b" + "\u0044" => 'move_left'
    }[values]
    unless result.nil?
      @out.write result
      true
    else
      @out.write "unknown"
      false

    end
  end
  def name_to_human name
    human = {
      'key_space' => 'space'
    }[name]
    if human.nil?
      case name[0..3]
      when 'key_'
        if name.length == 5
          @out.puts name[4]
        else
          @out.puts name[4..(-1)]
        end
        true
      when 'ctrl'
        @out.puts "control #{name[5]}"
        true
      else
        @out.puts 'unknown'
        false
      end
    else
      @out.puts human
      true
    end
  end
  def call *args, env:, frames:
    @out = env[:out]
    values = env[:in].read
    if args[0] == '-h'
      name_to_human values
      elsif args[0] == '-u'
        key_to_unicode values
    else
      key_to_name values
    end
  end
end

