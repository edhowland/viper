require 'kpeg/compiled_parser'

class Vish < KPeg::CompiledParser


  attr_accessor :result


  # :stopdoc:

  # space = " "
  def _space
    _tmp = match_string(" ")
    set_failed_rule :_space unless _tmp
    return _tmp
  end

  # valid_id = /[_A-Za-z][_A-Za-z0-9]*/
  def _valid_id
    _tmp = scan(/\A(?-mix:[_A-Za-z][_A-Za-z0-9]*)/)
    set_failed_rule :_valid_id unless _tmp
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

  # argument = < /[\/\.\-\*_0-9A-Za-z][\/\.\-\*\{\}:_0-9A-Za-z]*/ > { Argument.new(StringLiteral.new(text)) }
  def _argument

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:[\/\.\-\*_0-9A-Za-z][\/\.\-\*\{\}:_0-9A-Za-z]*)/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  Argument.new(StringLiteral.new(text)) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_argument unless _tmp
    return _tmp
  end

  # argument_list = (argument_list:a1 argument_list:a2 { a1 + a2 } | space+ argument:a { [ a ] })
  def _argument_list

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_argument_list)
        a1 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_argument_list)
        a2 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  a1 + a2 ; end
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
        _save3 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save3
        end
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_argument)
        a = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  [ a ] ; end
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

    set_failed_rule :_argument_list unless _tmp
    return _tmp
  end

  # assignment = identifier:i "=" argument:a { Assignment.new(i, a) }
  def _assignment

    _save = self.pos
    while true # sequence
      _tmp = apply(:_identifier)
      i = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("=")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_argument)
      a = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  Assignment.new(i, a) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_assignment unless _tmp
    return _tmp
  end

  # assignment_list = (assignment_list:a1 space+ assignment_list:a2 { a1 + a2 } | assignment:a { [ a ] })
  def _assignment_list

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_assignment_list)
        a1 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_assignment_list)
        a2 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  a1 + a2 ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save3 = self.pos
      while true # sequence
        _tmp = apply(:_assignment)
        a = @result
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin;  [ a ] ; end
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

    set_failed_rule :_assignment_list unless _tmp
    return _tmp
  end

  # simple_command = identifier:i { Command.resolve(i) }
  def _simple_command

    _save = self.pos
    while true # sequence
      _tmp = apply(:_identifier)
      i = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  Command.resolve(i) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_simple_command unless _tmp
    return _tmp
  end

  # command = (simple_command:c argument_list:a { [ c, a ] } | simple_command:c { [ c ] })
  def _command

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_simple_command)
        c = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_argument_list)
        a = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  [ c, a ] ; end
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
        _tmp = apply(:_simple_command)
        c = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  [ c ] ; end
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

    set_failed_rule :_command unless _tmp
    return _tmp
  end

  # statement = (assignment_list:a space+ command:c? { [a, c ] } | assignment_list:a { AssignmentList.new(a) } | command:c { c })
  def _statement

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_assignment_list)
        a = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _save3 = self.pos
        _tmp = apply(:_command)
        c = @result
        unless _tmp
          _tmp = true
          self.pos = _save3
        end
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  [a, c ] ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save4 = self.pos
      while true # sequence
        _tmp = apply(:_assignment_list)
        a = @result
        unless _tmp
          self.pos = _save4
          break
        end
        @result = begin;  AssignmentList.new(a) ; end
        _tmp = true
        unless _tmp
          self.pos = _save4
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save5 = self.pos
      while true # sequence
        _tmp = apply(:_command)
        c = @result
        unless _tmp
          self.pos = _save5
          break
        end
        @result = begin;  c ; end
        _tmp = true
        unless _tmp
          self.pos = _save5
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

  # root = statement:x { @result = x }
  def _root

    _save = self.pos
    while true # sequence
      _tmp = apply(:_statement)
      x = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  @result = x ; end
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
  Rules[:_space] = rule_info("space", "\" \"")
  Rules[:_valid_id] = rule_info("valid_id", "/[_A-Za-z][_A-Za-z0-9]*/")
  Rules[:_identifier] = rule_info("identifier", "< valid_id > { text.to_sym }")
  Rules[:_argument] = rule_info("argument", "< /[\\/\\.\\-\\*_0-9A-Za-z][\\/\\.\\-\\*\\{\\}:_0-9A-Za-z]*/ > { Argument.new(StringLiteral.new(text)) }")
  Rules[:_argument_list] = rule_info("argument_list", "(argument_list:a1 argument_list:a2 { a1 + a2 } | space+ argument:a { [ a ] })")
  Rules[:_assignment] = rule_info("assignment", "identifier:i \"=\" argument:a { Assignment.new(i, a) }")
  Rules[:_assignment_list] = rule_info("assignment_list", "(assignment_list:a1 space+ assignment_list:a2 { a1 + a2 } | assignment:a { [ a ] })")
  Rules[:_simple_command] = rule_info("simple_command", "identifier:i { Command.resolve(i) }")
  Rules[:_command] = rule_info("command", "(simple_command:c argument_list:a { [ c, a ] } | simple_command:c { [ c ] })")
  Rules[:_statement] = rule_info("statement", "(assignment_list:a space+ command:c? { [a, c ] } | assignment_list:a { AssignmentList.new(a) } | command:c { c })")
  Rules[:_root] = rule_info("root", "statement:x { @result = x }")
  # :startdoc:
end
