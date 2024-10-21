#  class CommentRuns - collects runs of adjacent comment lines and appends to them to  a hash

# This takes a token stream and applies a DFA
class CommentRuns
  def initialize tokens
    @tokens = tokens.clone
    @state =  :start
    @idx = -1
    @docstring = ''
    @collection = {}
  end
  attr_reader :tokens,  :state, :idx, :docstring,  :collection
  # this is  just for debugging
  def setup
        @tokens.reject! {|t| t.type == WS }
    @idx = -1
  end
  # another  method for debugging
  def get_next
    @idx +=  1
    peek
  end
  def peek
    @tokens[@idx]
  end
  def gt
    get_next
    peek.type
  end
  def step1
    step(gt)
  end
  def step(type)
    @state = delta(@state, type)
    case @state
    when :comment_1
      @docstring += peek.contents
    when  :comment_nl
      @docstring += "\n"
    when :function
      nil
    when :collect
      @collection[peek.contents] = @docstring
      @docstring = ''
    else
        @docstring = ''
    end
    @state
    
  end

  def delta(state, type)
    return :fin if type == EOF
    case [state,  type]
    when [:start, COMMENT]
      :comment_1
    when [:comment_1, NEWLINE]
      :comment_nl
    when [:comment_nl, COMMENT]
      :comment_1
    when [:comment_nl, FUNCTION]
      :function
    when [:function, BARE]
      :collect
    else
      :start
      
    end
  end

  #  main
  def run
    until @state == :fin
      step1
    end
  end
end
