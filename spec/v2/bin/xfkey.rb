# xfkey - class Xfkey - command xfkey - maps bytes to string representsations
# arg: [-h] :  print human readable version
# Usage: raw - | xfkey  # generates key_j if j pressed. ctrl_q if Ctrol-Q hit.
# echo key_space | xfkey -h  # prints human understandable character: "space"
class Xfkey

  def key_to_hex  values
    @out.write(values.bytes.map {|e| '%0x' % e }.join(' '))
  end
  def key_to_decimal values
    @out.write(values.bytes.map {|e| '%0d' % e }.join(' '))
  end
  def key_to_unicode values
    uni = values.chars.map {|e| e.unpack('H*')[0] }.map {|e| '\\u00' + e }

    @out.write uni.join(' ')
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
    # check for possible meta key
    meta_keys = {
        [226, 136, 130] => 'meta_d',
[226, 136, 145] => 'meta_w'
      }
      meta_k = values.bytes
      if meta_keys[meta_k]
        @out.write meta_keys[meta_k]
        return true
      end

    result = {
      "\e" => "escape",
      "\u007F" => 'key_backspace',
      # punctuation
      " " => 'key_space',
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
      "\u001b" + "\u005b" + "\u0044" => 'move_left',
       "\u001b" + "\u005b" + "\u0043" => 'move_right',
        "\u001b" + "\u005b" + "\u0041" => 'move_up',
      "\u001b" + "\u005b" + "\u0042" => 'move_down',
      "\u001b" + "\u005b" + "\u0035" + "\u007e" => 'move_shift_pgup',
      "\u001b" + "\u005b" + "\u0036" + "\u007e" => 'move_shift_pgdn',
      "\u001b" + "\u005b" + "\u0048" => 'move_shift_home',
      "\u001b" + "\u005b" + "\u0046" => 'move_shift_end',
      # forward delete
      "\u001b" + "\u005b" + "\u0033" + "\u007e" => 'key_delete',
      # backtab
      "\u001b" + "\u005b" + "\u005a" => 'key_backtab',
      # function keys
      "\u001b" + "\u004f" + "\u0050" => 'fn_1',
      "\u001b" + "\u004f" + "\u0051" => 'fn_2',
      "\u001b" + "\u004f" + "\u0052" => 'fn_3',
      "\u001b" + "\u004f" + "\u0053" => 'fn_4',
      "\u001b" + "\u005b" + "\u0031" + "\u0035" + "\u007e" => 'fn_5',
      "\u001b" + "\u005b" + "\u0031" + "\u0037" + "\u007e" => 'fn_6',



      # meta keys
      #[e2,88,82] => 'meta_d'

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
      'key_space' => 'space',
      'ctrl_j' => 'new line',
      'ctrl_i' => 'tab'
    }[name]
    if human.nil?
      case name[0..3]
      when 'key_'
        if name.length == 5
          @out.write name[4]
        else
          @out.write name[4..(-1)]
        end
        true
      when 'ctrl'
        @out.write "control #{name[5]}"
        true
      else
        @out.write 'unknown'
        false
      end
    else
      @out.write human
      true
    end
  end
  def call *args, env:, frames:
    @out = env[:out]
    values = env[:in].read
#  binding.pry

    if args[0] == '-h'
      name_to_human values
      elsif args[0] == '-u'
        key_to_unicode values
      elsif args[0] == '-x'
        key_to_hex  values
      elsif args[0] == '-d'
        key_to_decimal values
    else
      key_to_name values
    end
  end
end

