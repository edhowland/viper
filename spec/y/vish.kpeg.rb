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

  # word = < /[_A-Za-z0-9]*/ > { text }
  def _word

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:[_A-Za-z0-9]*)/)
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

    set_failed_rule :_word unless _tmp
    return _tmp
  end

  # term = (term:t1 - "&&" - term:t2 { [:and, t1,  t2] } | term:t1 - "||" - term:t2 { [:or, t1,  t2] } | term:t1 - "|" - term:t2 { [:|, t1,  t2] } | word:w {[ w ] })
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
        _tmp = apply(:_word)
        w = @result
        unless _tmp
          self.pos = _save4
          break
        end
        @result = begin; [ w ] ; end
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

    set_failed_rule :_term unless _tmp
    return _tmp
  end

  # root = term:t { @result = t }
  def _root

    _save = self.pos
    while true # sequence
      _tmp = apply(:_term)
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
  Rules[:_word] = rule_info("word", "< /[_A-Za-z0-9]*/ > { text }")
  Rules[:_term] = rule_info("term", "(term:t1 - \"&&\" - term:t2 { [:and, t1,  t2] } | term:t1 - \"||\" - term:t2 { [:or, t1,  t2] } | term:t1 - \"|\" - term:t2 { [:|, t1,  t2] } | word:w {[ w ] })")
  Rules[:_root] = rule_info("root", "term:t { @result = t }")
  # :startdoc:
end
