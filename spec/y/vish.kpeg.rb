require 'kpeg/compiled_parser'

class Vish < KPeg::CompiledParser


  attr_accessor :result


  # :stopdoc:

  module AST
    class Node; end
    class Assignment < Node
      def initialize(name, value)
        @name = name
        @value = value
      end
      attr_reader :name
      attr_reader :value
    end
  end
  module ASTConstruction
    def assign(name, value)
      AST::Assignment.new(name, value)
    end
  end
  include ASTConstruction

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

  # comment = - "#" not_nl* nl
  def _comment

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
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
        break
      end
      _tmp = apply(:_nl)
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_comment unless _tmp
    return _tmp
  end

  # eol = (comment | - nl)
  def _eol

    _save = self.pos
    while true # choice
      _tmp = apply(:_comment)
      break if _tmp
      self.pos = _save

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_nl)
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_eol unless _tmp
    return _tmp
  end

  # identifier = < /[_A-Za-z][_A-Za-z0-9]*/ > { text.to_sym }
  def _identifier

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:[_A-Za-z][_A-Za-z0-9]*)/)
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

  # redirector = ("<" - arg:a { [[:redirect_from, a]] } | ">" - arg:a { [[:redirect_to, a]] } | ">>" - arg:a { [[:append_to, a]] })
  def _redirector

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = match_string("<")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_arg)
        a = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  [[:redirect_from, a]] ; end
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
        _tmp = match_string(">")
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_arg)
        a = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  [[:redirect_to, a]] ; end
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
        _tmp = match_string(">>")
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:_arg)
        a = @result
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin;  [[:append_to, a]] ; end
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

    set_failed_rule :_redirector unless _tmp
    return _tmp
  end

  # string = ("'" < /[^']*/ > "'" { text } | "\"" < /[^"]*/ > "\"" { text })
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
        @result = begin;  text ; end
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
        @result = begin;  text ; end
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

  # arg = < /:?[\/\.\-\*_0-9A-Za-z]+/ > { text }
  def _arg

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix::?[\/\.\-\*_0-9A-Za-z]+)/)
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

    set_failed_rule :_arg unless _tmp
    return _tmp
  end

  # args = (args:a1 - args:a2 { a1 + a2 } | redirector | arg:a { [ a ] })
  def _args

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_args)
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
        _tmp = apply(:_args)
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
      _tmp = apply(:_redirector)
      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = apply(:_arg)
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

    set_failed_rule :_args unless _tmp
    return _tmp
  end

  # command = (identifier:c - args:a { [c, a] } | identifier:c { [ c ] })
  def _command

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_identifier)
        c = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_args)
        a = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  [c, a] ; end
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

  # statement = (eol { [] } | eol - statement:s { s } | statement:s1 - ";" - statement:s2 { s1 + s2 } | statement:s1 - eol - statement:s2 { s1 + s2 } | term:t { [ t ] })
  def _statement

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_eol)
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  [] ; end
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
        _tmp = apply(:_eol)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_statement)
        s = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  s ; end
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
        _tmp = apply(:_statement)
        s1 = @result
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = match_string(";")
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:_statement)
        s2 = @result
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin;  s1 + s2 ; end
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
        _tmp = apply(:_statement)
        s1 = @result
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:_eol)
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:_statement)
        s2 = @result
        unless _tmp
          self.pos = _save4
          break
        end
        @result = begin;  s1 + s2 ; end
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
        _tmp = apply(:_term)
        t = @result
        unless _tmp
          self.pos = _save5
          break
        end
        @result = begin;  [ t ] ; end
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

  # term = (term:t1 - "&&" - term:t2 { [:and, t1,  t2] } | term:t1 - "||" - term:t2 { [:or, t1,  t2] } | term:t1 - "|" - term:t2 { [:|, t1,  t2] } | ":(" statement:s ")" { [:eval, s] } | "(" statement ")" | command)
  def _term

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_term)
        t1 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("&&")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_term)
        t2 = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  [:and, t1,  t2] ; end
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
        _tmp = apply(:_term)
        t1 = @result
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = match_string("||")
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_term)
        t2 = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  [:or, t1,  t2] ; end
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
        _tmp = apply(:_term)
        t1 = @result
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = match_string("|")
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:_term)
        t2 = @result
        unless _tmp
          self.pos = _save3
          break
        end
        @result = begin;  [:|, t1,  t2] ; end
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
        _tmp = match_string(":(")
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:_statement)
        s = @result
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = match_string(")")
        unless _tmp
          self.pos = _save4
          break
        end
        @result = begin;  [:eval, s] ; end
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
        _tmp = match_string("(")
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:_statement)
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = match_string(")")
        unless _tmp
          self.pos = _save5
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      _tmp = apply(:_command)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_term unless _tmp
    return _tmp
  end

  # root = statement:t { @result = t }
  def _root

    _save = self.pos
    while true # sequence
      _tmp = apply(:_statement)
      t = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  @result = t ; end
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
  Rules[:__hyphen_] = rule_info("-", "space*")
  Rules[:_nl] = rule_info("nl", "\"\\n\"")
  Rules[:_not_nl] = rule_info("not_nl", "/[^\\n]/")
  Rules[:_comment] = rule_info("comment", "- \"\#\" not_nl* nl")
  Rules[:_eol] = rule_info("eol", "(comment | - nl)")
  Rules[:_identifier] = rule_info("identifier", "< /[_A-Za-z][_A-Za-z0-9]*/ > { text.to_sym }")
  Rules[:_redirector] = rule_info("redirector", "(\"<\" - arg:a { [[:redirect_from, a]] } | \">\" - arg:a { [[:redirect_to, a]] } | \">>\" - arg:a { [[:append_to, a]] })")
  Rules[:_string] = rule_info("string", "(\"'\" < /[^']*/ > \"'\" { text } | \"\\\"\" < /[^\"]*/ > \"\\\"\" { text })")
  Rules[:_arg] = rule_info("arg", "< /:?[\\/\\.\\-\\*_0-9A-Za-z]+/ > { text }")
  Rules[:_args] = rule_info("args", "(args:a1 - args:a2 { a1 + a2 } | redirector | arg:a { [ a ] })")
  Rules[:_command] = rule_info("command", "(identifier:c - args:a { [c, a] } | identifier:c { [ c ] })")
  Rules[:_statement] = rule_info("statement", "(eol { [] } | eol - statement:s { s } | statement:s1 - \";\" - statement:s2 { s1 + s2 } | statement:s1 - eol - statement:s2 { s1 + s2 } | term:t { [ t ] })")
  Rules[:_term] = rule_info("term", "(term:t1 - \"&&\" - term:t2 { [:and, t1,  t2] } | term:t1 - \"||\" - term:t2 { [:or, t1,  t2] } | term:t1 - \"|\" - term:t2 { [:|, t1,  t2] } | \":(\" statement:s \")\" { [:eval, s] } | \"(\" statement \")\" | command)")
  Rules[:_root] = rule_info("root", "statement:t { @result = t }")
  # :startdoc:
end
