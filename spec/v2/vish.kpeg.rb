require 'kpeg/compiled_parser'

class Vish < KPeg::CompiledParser


  attr_accessor :result


  # :stopdoc:

  # eps = ""
  def _eps
    _tmp = match_string("")
    set_failed_rule :_eps unless _tmp
    return _tmp
  end

  # space = " "
  def _space
    _tmp = match_string(" ")
    set_failed_rule :_space unless _tmp
    return _tmp
  end

  # - = space*
  def __hyphen_
    while true
      _tmp = apply(:_space)
      break unless _tmp
    end
    _tmp = true
    set_failed_rule :__hyphen_ unless _tmp
    return _tmp
  end

  # nl = "\n"
  def _nl
    _tmp = match_string("\n")
    set_failed_rule :_nl unless _tmp
    return _tmp
  end

  # not_nl = /[^\n]/
  def _not_nl
    _tmp = scan(/\A(?-mix:[^\n])/)
    set_failed_rule :_not_nl unless _tmp
    return _tmp
  end

  # valid_id = /[_A-Za-z][_A-Za-z0-9]*/
  def _valid_id
    _tmp = scan(/\A(?-mix:[_A-Za-z][_A-Za-z0-9]*)/)
    set_failed_rule :_valid_id unless _tmp
    return _tmp
  end

  # string = ("'" < /[^']*/ > "'" { QuotedString.new(text) } | "\"" < /[^"]*/ > "\"" {StringLiteral.new(text) })
  def _string

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = match_string("'")
        unless _tmp
          self.pos = _save1
          break
        end
        _text_start = self.pos
        _tmp = scan(/\A(?-mix:[^']*)/)
        if _tmp
          text = get_text(_text_start)
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("'")
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  QuotedString.new(text) ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = match_string("\"")
        unless _tmp
          self.pos = _save2
          break
        end
        _text_start = self.pos
        _tmp = scan(/\A(?-mix:[^"]*)/)
        if _tmp
          text = get_text(_text_start)
        end
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = match_string("\"")
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin; StringLiteral.new(text) ; end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_string unless _tmp
    return _tmp
  end

  # identifier = < valid_id > { text.to_sym }
  def _identifier

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = apply(:_valid_id)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text.to_sym ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_identifier unless _tmp
    return _tmp
  end

  # var_name = < valid_id > { text }
  def _var_name

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = apply(:_valid_id)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_var_name unless _tmp
    return _tmp
  end

  # argument = (< /[\/\.\-\*_0-9A-Za-z][\/\.\-\*\{\}:_0-9A-Za-z]*/ > { Argument.new(StringLiteral.new(text)) } | string:s { Argument.new(s) })
  def _argument

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _text_start = self.pos
        _tmp = scan(/\A(?-mix:[\/\.\-\*_0-9A-Za-z][\/\.\-\*\{\}:_0-9A-Za-z]*)/)
        if _tmp
          text = get_text(_text_start)
        end
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  Argument.new(StringLiteral.new(text)) ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = apply(:_string)
        s = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  Argument.new(s) ; end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_argument unless _tmp
    return _tmp
  end

  # comment = "#" not_nl*
  def _comment

    _save = self.pos
    while true # sequence
      _tmp = match_string("#")
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_not_nl)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_comment unless _tmp
    return _tmp
  end

  # statement = (identifier:i - string:s { [i, s] } | identifier:i { i })
  def _statement

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_identifier)
        i = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_string)
        s = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  [i, s] ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = apply(:_identifier)
        i = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  i ; end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_statement unless _tmp
    return _tmp
  end

  # statement_list = (statement_list:s1 - ";" - statement_list:s2 { s1 + s2 } | statement_list:s1 - nl - statement_list:s2 { s1 + s2 } | statement:s? - comment? { [ s ] })
  def _statement_list

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_statement_list)
        s1 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(";")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_statement_list)
        s2 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  s1 + s2 ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = apply(:_statement_list)
        s1 = @result
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_nl)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_statement_list)
        s2 = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  s1 + s2 ; end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save3 = self.pos
      while true # sequence
        _save4 = self.pos
        _tmp = apply(:_statement)
        s = @result
        unless _tmp
          _tmp = true
          self.pos = _save4
        end
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save3
          break
        end
        _save5 = self.pos
        _tmp = apply(:_comment)
        unless _tmp
          _tmp = true
          self.pos = _save5
        end
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin;  [ s ] ; end
        _tmp = true
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_statement_list unless _tmp
    return _tmp
  end

  # block = (statement_list:s { Block.new(s) } | eps)
  def _block

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_statement_list)
        s = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  Block.new(s) ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      _tmp = apply(:_eps)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_block unless _tmp
    return _tmp
  end

  # root = argument:a { @result = a }
  def _root

    _save = self.pos
    while true # sequence
      _tmp = apply(:_argument)
      a = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  @result = a ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_root unless _tmp
    return _tmp
  end

  Rules = {}
  Rules[:_eps] = rule_info("eps", "\"\"")
  Rules[:_space] = rule_info("space", "\" \"")
  Rules[:__hyphen_] = rule_info("-", "space*")
  Rules[:_nl] = rule_info("nl", "\"\\n\"")
  Rules[:_not_nl] = rule_info("not_nl", "/[^\\n]/")
  Rules[:_valid_id] = rule_info("valid_id", "/[_A-Za-z][_A-Za-z0-9]*/")
  Rules[:_string] = rule_info("string", "(\"'\" < /[^']*/ > \"'\" { QuotedString.new(text) } | \"\\\"\" < /[^\"]*/ > \"\\\"\" {StringLiteral.new(text) })")
  Rules[:_identifier] = rule_info("identifier", "< valid_id > { text.to_sym }")
  Rules[:_var_name] = rule_info("var_name", "< valid_id > { text }")
  Rules[:_argument] = rule_info("argument", "(< /[\\/\\.\\-\\*_0-9A-Za-z][\\/\\.\\-\\*\\{\\}:_0-9A-Za-z]*/ > { Argument.new(StringLiteral.new(text)) } | string:s { Argument.new(s) })")
  Rules[:_comment] = rule_info("comment", "\"\#\" not_nl*")
  Rules[:_statement] = rule_info("statement", "(identifier:i - string:s { [i, s] } | identifier:i { i })")
  Rules[:_statement_list] = rule_info("statement_list", "(statement_list:s1 - \";\" - statement_list:s2 { s1 + s2 } | statement_list:s1 - nl - statement_list:s2 { s1 + s2 } | statement:s? - comment? { [ s ] })")
  Rules[:_block] = rule_info("block", "(statement_list:s { Block.new(s) } | eps)")
  Rules[:_root] = rule_info("root", "argument:a { @result = a }")
  # :startdoc:
end
