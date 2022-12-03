# repl_pda.rb: class ReplPDA
# Push-down automata finite state machine for determining whether the current string is an unfinished line:

# "" : Ok
# " { " : unfinished
# "  { ... } " : ok, .etc

require 'set'
require_relative 'stack'



class ReplPDA
  def initialize
    @stack = Stack.new; @stack << :"$"
    @states = {
      ['{', :S0] => :S1,
      ['[', :S0] => :S2,
      ['(', :S0] => :S3,
      ["'", :S0] => :S4,
      ['"', :S0] => :S5,
      ['}', :S1] => :S0,
      [']', :S2] => :S0,
      [')', :S3] => :S0,
    }
    @finals = Set.new
    @finals << :S0
    @start = :S0
    @state = @start
    # @actuals are chars that delta will actually process state transversals, all others are to be ignored
    @actuals = Set.new
  ['{', '}', '[', ']', '(', ')', '"', "'"].each {|a| @actuals << a }
    # :SErr is the error state
  end
  attr_reader :state, :actuals, :finals
  def delta(ch, state, top)
  case [ch, state, top]
  ##### Error state always goes to :Err
  in [_, :Err, _]
    [:Err, :nop]
    ##### double quotes
    in ['"', :S0, _]
      [:S1, :push, :DQuote]
    in ['"', :S1, :DQuote]
      [:S0, :pop]
    in [_, :S1, :DQuote]
      [:S1, :nop]
    ##### single quote
    in ["'", :S0, _]
      [:S2, :push, :SQuote]
    in ["'", :S2, :SQuote]
      [:S0, :pop]
    in [_, :S2, :SQuote]
      [:S2, :nop]
  ##### left bracket
  in ['[', :S0, :"$"]
    [:S0, :push, :RBrack]
  in ['[', :S0, _] ####????
  ##### left brace
  in ['{', :S0, :"$"]
    [:S0, :push, :RBrace]
  in ['{', :S0, _]
        [:S0, :push, :RBrace]

  ##### left paren
  in ['(', :S0, :"$"]
    [:S0, :push, :RParen]
  in ['(', :S0, _]
      [:S0, :push, :RParen]

  ##### right bracket
  in [']', :S0, :RBrack]
    [:S0, :pop]
  in [']', :S0, _]
    [:Err, :nop]
  ##### right brace
  in ['}', :S0, :RBrace]
    [:S0, :pop]
  in ['}', :S0, _]
    [:Err, :nop]
  ##### right paren
  in [')', :S0, :RParen]
    [:S0, :pop]
  in [')', :S0, _]
    [:Err, :nop]
  ##### ignored characters
    in [_, :S0, :"$"]
      [:S0, :nop]
    in [_, :S0, _]
      [:S0, :nop]
  else
    [:err, :nop]
  end
  end
  def run(str)
    @state = :S0
    @stack = Stack.new; @stack << :"$"
    idx = 0
    until str[idx].nil? do
      @state, *meth = delta(str[idx], @state, @stack.peek)
      @stack.send *meth
      idx += 1
    end
    @stack.length == 1 && @stack.peek == :"$"
  end
  def error?
    @state == :Err
  end
end