# repl_pda.rb: class ReplPDA
# Push-down automata finite state machine for determining whether the current string is an unfinished line:

# "" : Ok
# " { " : unfinished
# "  { ... } " : ok, .etc

require 'set'


class ReplPDA
  def initialize
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
  def delta(ch, state)
    if error?
      :SErr
    elsif !@actuals.member?(ch)
      @state
    elsif @states.has_key?([ch, state])
      @states[[ch, state]]
    else
      :SErr
    end
  end
  def run(str)
    @state = :S0
    idx = 0
    until str[idx].nil? do
      @state = delta(str[idx], @state)
      idx += 1
    end
    @finals.member? @state
  end
  def error?
    @state == :SErr
  end
end