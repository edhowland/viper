# match.rb: stake to test out Ruby 3.x match

=begin
3-D Truth table for PDA that matches balanced brackets, braces, parens and single and double quotes
_, :Err, _ => :Err, :nop
[, 0, $ => :S0, :push, :RBrack
[,0,:RBrack => :S0, :push, :RBrack
[,0,:RBrace => :S0,:push, :RBrack
[,0,:RParen => :S0, :push, :RBrack
##### left braces
{,0,$ => :S0, :push, :RBrace
{,0,:RBrace => :S0, :push, :RBrace
{,0,:RBrack => :S0, :push, :RBrace
{,0,:RParen => :S0, :push, :RBrace
##### left parens
(,0,$ => :S0, :push, :RParen
(,0, :RParen => :S0, :push, :RParen
(,0,:RBrack => :S0, :push, :RParen
(,0,:RBrace => :S0, :push, :RParen
##### right brackets
],0,$ => :Err, :nop
],0,:RBrack => :S0, :pop
],0,:RBrace => :Err, :nop
],0,:RParen => :Err, :nop
##### right brace
},0,$ => :Err, :nop
},0,:RBrace => :S0, :pop
},0,:RBrack => :Err, :nop
},0,:RParen => :Err, :nop
##### right parens
),0,$ => :Err, :nop
),0,:RParen => :S0, :pop
),0,:RBrack => :Err, :nop
),0,:RBrace => :Err, :nop


##### Dont care chars
_,0,$ => 0, :nop
_,0,:RBrack => 0, :nop
_,0,:RBrace => :S0, :nop
_,0,:RParen => :S0, :nop
=end

class Stack < Array
  def nop(*args)
    # ignores, or X don't care
  end
  alias_method :peek, :last
end

def match(ch, st, top)
  case [ch, st, top]
  ##### Error state always goes to :Err
  in [_, :Err, _]
    [:Err, :nop]
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
  else
    :err
  end
end

def mkstack
  s=Stack.new;
  s << :"$"
end

# for debugging help
def D
  :"$"
end