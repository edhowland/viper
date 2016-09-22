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

  # ws = (space | nl)
  def _ws

    _save = self.pos
    while true # choice
      _tmp = apply(:_space)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_nl)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_ws unless _tmp
    return _tmp
  end

  # not_nl = /[^\n]/
  def _not_nl
    _tmp = scan(/\A(?-mix:[^\n])/)
    set_failed_rule :_not_nl unless _tmp
    return _tmp
  end

  # redirect_op = < /<|>(>|&2)?|>&2|2>&1|2>/ > { text }
  def _redirect_op

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:<|>(>|&2)?|>&2|2>&1|2>)/)
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

    set_failed_rule :_redirect_op unless _tmp
    return _tmp
  end

  # valid_id = /[_A-Za-z][_A-Za-z0-9\.]*/
  def _valid_id
    _tmp = scan(/\A(?-mix:[_A-Za-z][_A-Za-z0-9\.]*)/)
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

  # variable = ":" < valid_id > { Deref.new(text.to_sym) }
  def _variable

    _save = self.pos
    while true # sequence
      _tmp = match_string(":")
      unless _tmp
        self.pos = _save
        break
      end
      _text_start = self.pos
      _tmp = apply(:_valid_id)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  Deref.new(text.to_sym) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_variable unless _tmp
    return _tmp
  end

  # function_name = < valid_id > { text }
  def _function_name

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

    set_failed_rule :_function_name unless _tmp
    return _tmp
  end

  # bare_string = < /[\/\.\-_0-9A-Za-z][\/\.\-\{\}:_0-9A-Za-z]*/ > { StringLiteral.new(text) }
  def _bare_string

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:[\/\.\-_0-9A-Za-z][\/\.\-\{\}:_0-9A-Za-z]*)/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  StringLiteral.new(text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_bare_string unless _tmp
    return _tmp
  end

  # glob = < /[\/\.\-\*_0-9A-Za-z][\/\.\-\*\{\}:_0-9A-Za-z]*/ > { Glob.new(StringLiteral.new(text)) }
  def _glob

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
      @result = begin;  Glob.new(StringLiteral.new(text)) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_glob unless _tmp
    return _tmp
  end

  # argument = (glob:g { g } | "&(" - function_args:a - ")" - "{" - block:b - "}" { LambdaDeclaration.new(a, b) } | string:s { Argument.new(s) } | bare_string:s { Argument.new(s) } | variable:v { Argument.new(v) } | ":(" - block:b - ")" { SubShellExpansion.new(b) } | "{" ws* block:b ws* "}" { LazyArgument.new(b) })
  def _argument

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_glob)
        g = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  g ; end
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
        _tmp = match_string("&(")
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_function_args)
        a = @result
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = match_string(")")
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = match_string("{")
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_block)
        b = @result
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = match_string("}")
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  LambdaDeclaration.new(a, b) ; end
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
        _tmp = apply(:_string)
        s = @result
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin;  Argument.new(s) ; end
        _tmp = true
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save4 = self.pos
      while true # sequence
        _tmp = apply(:_bare_string)
        s = @result
        unless _tmp
          self.pos = _save4
          break
        end
        @result = begin;  Argument.new(s) ; end
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
        _tmp = apply(:_variable)
        v = @result
        unless _tmp
          self.pos = _save5
          break
        end
        @result = begin;  Argument.new(v) ; end
        _tmp = true
        unless _tmp
          self.pos = _save5
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save6 = self.pos
      while true # sequence
        _tmp = match_string(":(")
        unless _tmp
          self.pos = _save6
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save6
          break
        end
        _tmp = apply(:_block)
        b = @result
        unless _tmp
          self.pos = _save6
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save6
          break
        end
        _tmp = match_string(")")
        unless _tmp
          self.pos = _save6
          break
        end
        @result = begin;  SubShellExpansion.new(b) ; end
        _tmp = true
        unless _tmp
          self.pos = _save6
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save7 = self.pos
      while true # sequence
        _tmp = match_string("{")
        unless _tmp
          self.pos = _save7
          break
        end
        while true
          _tmp = apply(:_ws)
          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save7
          break
        end
        _tmp = apply(:_block)
        b = @result
        unless _tmp
          self.pos = _save7
          break
        end
        while true
          _tmp = apply(:_ws)
          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save7
          break
        end
        _tmp = match_string("}")
        unless _tmp
          self.pos = _save7
          break
        end
        @result = begin;  LazyArgument.new(b) ; end
        _tmp = true
        unless _tmp
          self.pos = _save7
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

  # function_args = (function_args:a1 - "," - function_args:a2 { a1 + a2 } | identifier:a { [ a ] } | eps { [] })
  def _function_args

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_function_args)
        a1 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(",")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_function_args)
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
        _tmp = apply(:_identifier)
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

      _save3 = self.pos
      while true # sequence
        _tmp = apply(:_eps)
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin;  [] ; end
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

    set_failed_rule :_function_args unless _tmp
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

  # redirection = redirect_op:r - argument:a { Redirection.new(r, a) }
  def _redirection

    _save = self.pos
    while true # sequence
      _tmp = apply(:_redirect_op)
      r = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
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
      @result = begin;  Redirection.new(r, a) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_redirection unless _tmp
    return _tmp
  end

  # element = (assignment | argument | redirection)
  def _element

    _save = self.pos
    while true # choice
      _tmp = apply(:_assignment)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_argument)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_redirection)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_element unless _tmp
    return _tmp
  end

  # context = (context:c1 space+ context:c2 { c1 + c2 } | element:e { [ e ] })
  def _context

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_context)
        c1 = @result
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
        _tmp = apply(:_context)
        c2 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  c1 + c2 ; end
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
        _tmp = apply(:_element)
        e = @result
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin;  [ e ] ; end
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

    set_failed_rule :_context unless _tmp
    return _tmp
  end

  # redirection_list = (redirection_list:r1 - redirection_list:r2 { [ r1, r2 ] } | redirection:r { [ r ] })
  def _redirection_list

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_redirection_list)
        r1 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_redirection_list)
        r2 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  [ r1, r2 ] ; end
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
        _tmp = apply(:_redirection)
        r = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  [ r ] ; end
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

    set_failed_rule :_redirection_list unless _tmp
    return _tmp
  end

  # subshell = "(" - block:b - ")" { b }
  def _subshell

    _save = self.pos
    while true # sequence
      _tmp = match_string("(")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_block)
      b = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string(")")
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  b ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_subshell unless _tmp
    return _tmp
  end

  # subshell_command = (redirection_list:r1 - subshell:s - redirection_list:r2 { SubShell.new(s, r1 + r2) } | redirection_list:r - subshell:s { SubShell.new(s, r) } | subshell:s - redirection_list:r { SubShell.new(s, r) } | subshell:s { SubShell.new(s) })
  def _subshell_command

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_redirection_list)
        r1 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_subshell)
        s = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_redirection_list)
        r2 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  SubShell.new(s, r1 + r2) ; end
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
        _tmp = apply(:_redirection_list)
        r = @result
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_subshell)
        s = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  SubShell.new(s, r) ; end
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
        _tmp = apply(:_subshell)
        s = @result
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:_redirection_list)
        r = @result
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin;  SubShell.new(s, r) ; end
        _tmp = true
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save4 = self.pos
      while true # sequence
        _tmp = apply(:_subshell)
        s = @result
        unless _tmp
          self.pos = _save4
          break
        end
        @result = begin;  SubShell.new(s) ; end
        _tmp = true
        unless _tmp
          self.pos = _save4
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_subshell_command unless _tmp
    return _tmp
  end

  # statement_list = (statement_list:s1 - ";" - statement_list:s2 { s1 + s2 } | statement_list:s1 - nl - statement_list:s2 { s1 + s2 } | expression)
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
      _tmp = apply(:_expression)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_statement_list unless _tmp
    return _tmp
  end

  # expression = (expression:l - "|" - expression:r { [ Pipe.new(l[0], r[0]) ] } | expression:l - "&&" - expression:r { [ BooleanAnd.new(l[0], r[0]) ] } | expression:l - "||" - expression:r { [ BooleanOr.new(l[0], r[0]) ] } | subshell_command:s { [ s ] } | "alias" space+ function_name:f "=" argument:a {[ AliasDeclaration.new(f, a) ] } | "function" - function_name:i "(" - function_args:a - ")" - "{" ws* block:b ws* "}" { [ FunctionDeclaration.new(i, a, b) ] } | context:c { [ Statement.new(c) ] })
  def _expression

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_expression)
        l = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("|")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_expression)
        r = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  [ Pipe.new(l[0], r[0]) ] ; end
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
        _tmp = apply(:_expression)
        l = @result
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = match_string("&&")
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_expression)
        r = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  [ BooleanAnd.new(l[0], r[0]) ] ; end
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
        _tmp = apply(:_expression)
        l = @result
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = match_string("||")
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:_expression)
        r = @result
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin;  [ BooleanOr.new(l[0], r[0]) ] ; end
        _tmp = true
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save4 = self.pos
      while true # sequence
        _tmp = apply(:_subshell_command)
        s = @result
        unless _tmp
          self.pos = _save4
          break
        end
        @result = begin;  [ s ] ; end
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
        _tmp = match_string("alias")
        unless _tmp
          self.pos = _save5
          break
        end
        _save6 = self.pos
        _tmp = apply(:_space)
        if _tmp
          while true
            _tmp = apply(:_space)
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save6
        end
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:_function_name)
        f = @result
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = match_string("=")
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:_argument)
        a = @result
        unless _tmp
          self.pos = _save5
          break
        end
        @result = begin; [ AliasDeclaration.new(f, a) ] ; end
        _tmp = true
        unless _tmp
          self.pos = _save5
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save7 = self.pos
      while true # sequence
        _tmp = match_string("function")
        unless _tmp
          self.pos = _save7
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save7
          break
        end
        _tmp = apply(:_function_name)
        i = @result
        unless _tmp
          self.pos = _save7
          break
        end
        _tmp = match_string("(")
        unless _tmp
          self.pos = _save7
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save7
          break
        end
        _tmp = apply(:_function_args)
        a = @result
        unless _tmp
          self.pos = _save7
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save7
          break
        end
        _tmp = match_string(")")
        unless _tmp
          self.pos = _save7
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save7
          break
        end
        _tmp = match_string("{")
        unless _tmp
          self.pos = _save7
          break
        end
        while true
          _tmp = apply(:_ws)
          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save7
          break
        end
        _tmp = apply(:_block)
        b = @result
        unless _tmp
          self.pos = _save7
          break
        end
        while true
          _tmp = apply(:_ws)
          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save7
          break
        end
        _tmp = match_string("}")
        unless _tmp
          self.pos = _save7
          break
        end
        @result = begin;  [ FunctionDeclaration.new(i, a, b) ] ; end
        _tmp = true
        unless _tmp
          self.pos = _save7
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save10 = self.pos
      while true # sequence
        _tmp = apply(:_context)
        c = @result
        unless _tmp
          self.pos = _save10
          break
        end
        @result = begin;  [ Statement.new(c) ] ; end
        _tmp = true
        unless _tmp
          self.pos = _save10
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_expression unless _tmp
    return _tmp
  end

  # block = statement_list:s { Block.new(s) }
  def _block

    _save = self.pos
    while true # sequence
      _tmp = apply(:_statement_list)
      s = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  Block.new(s) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_block unless _tmp
    return _tmp
  end

  # root = block:x { @result = x }
  def _root

    _save = self.pos
    while true # sequence
      _tmp = apply(:_block)
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
  Rules[:_eps] = rule_info("eps", "\"\"")
  Rules[:_space] = rule_info("space", "\" \"")
  Rules[:__hyphen_] = rule_info("-", "space*")
  Rules[:_nl] = rule_info("nl", "\"\\n\"")
  Rules[:_ws] = rule_info("ws", "(space | nl)")
  Rules[:_not_nl] = rule_info("not_nl", "/[^\\n]/")
  Rules[:_redirect_op] = rule_info("redirect_op", "< /<|>(>|&2)?|>&2|2>&1|2>/ > { text }")
  Rules[:_valid_id] = rule_info("valid_id", "/[_A-Za-z][_A-Za-z0-9\\.]*/")
  Rules[:_identifier] = rule_info("identifier", "< valid_id > { text.to_sym }")
  Rules[:_string] = rule_info("string", "(\"'\" < /[^']*/ > \"'\" { QuotedString.new(text) } | \"\\\"\" < /[^\"]*/ > \"\\\"\" {StringLiteral.new(text) })")
  Rules[:_variable] = rule_info("variable", "\":\" < valid_id > { Deref.new(text.to_sym) }")
  Rules[:_function_name] = rule_info("function_name", "< valid_id > { text }")
  Rules[:_bare_string] = rule_info("bare_string", "< /[\\/\\.\\-_0-9A-Za-z][\\/\\.\\-\\{\\}:_0-9A-Za-z]*/ > { StringLiteral.new(text) }")
  Rules[:_glob] = rule_info("glob", "< /[\\/\\.\\-\\*_0-9A-Za-z][\\/\\.\\-\\*\\{\\}:_0-9A-Za-z]*/ > { Glob.new(StringLiteral.new(text)) }")
  Rules[:_argument] = rule_info("argument", "(glob:g { g } | \"&(\" - function_args:a - \")\" - \"{\" - block:b - \"}\" { LambdaDeclaration.new(a, b) } | string:s { Argument.new(s) } | bare_string:s { Argument.new(s) } | variable:v { Argument.new(v) } | \":(\" - block:b - \")\" { SubShellExpansion.new(b) } | \"{\" ws* block:b ws* \"}\" { LazyArgument.new(b) })")
  Rules[:_function_args] = rule_info("function_args", "(function_args:a1 - \",\" - function_args:a2 { a1 + a2 } | identifier:a { [ a ] } | eps { [] })")
  Rules[:_assignment] = rule_info("assignment", "identifier:i \"=\" argument:a { Assignment.new(i, a) }")
  Rules[:_comment] = rule_info("comment", "\"\#\" not_nl*")
  Rules[:_redirection] = rule_info("redirection", "redirect_op:r - argument:a { Redirection.new(r, a) }")
  Rules[:_element] = rule_info("element", "(assignment | argument | redirection)")
  Rules[:_context] = rule_info("context", "(context:c1 space+ context:c2 { c1 + c2 } | element:e { [ e ] })")
  Rules[:_redirection_list] = rule_info("redirection_list", "(redirection_list:r1 - redirection_list:r2 { [ r1, r2 ] } | redirection:r { [ r ] })")
  Rules[:_subshell] = rule_info("subshell", "\"(\" - block:b - \")\" { b }")
  Rules[:_subshell_command] = rule_info("subshell_command", "(redirection_list:r1 - subshell:s - redirection_list:r2 { SubShell.new(s, r1 + r2) } | redirection_list:r - subshell:s { SubShell.new(s, r) } | subshell:s - redirection_list:r { SubShell.new(s, r) } | subshell:s { SubShell.new(s) })")
  Rules[:_statement_list] = rule_info("statement_list", "(statement_list:s1 - \";\" - statement_list:s2 { s1 + s2 } | statement_list:s1 - nl - statement_list:s2 { s1 + s2 } | expression)")
  Rules[:_expression] = rule_info("expression", "(expression:l - \"|\" - expression:r { [ Pipe.new(l[0], r[0]) ] } | expression:l - \"&&\" - expression:r { [ BooleanAnd.new(l[0], r[0]) ] } | expression:l - \"||\" - expression:r { [ BooleanOr.new(l[0], r[0]) ] } | subshell_command:s { [ s ] } | \"alias\" space+ function_name:f \"=\" argument:a {[ AliasDeclaration.new(f, a) ] } | \"function\" - function_name:i \"(\" - function_args:a - \")\" - \"{\" ws* block:b ws* \"}\" { [ FunctionDeclaration.new(i, a, b) ] } | context:c { [ Statement.new(c) ] })")
  Rules[:_block] = rule_info("block", "statement_list:s { Block.new(s) }")
  Rules[:_root] = rule_info("root", "block:x { @result = x }")
  # :startdoc:
end
