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
  in [_, :Err, _]
    :Err
  in [']', _, :"$"]
    :Err
  in ['}', _, :"$"]
    :Err
  in [')', _, :"$"]
    :Err

  in ['[', :S0, _]
    :RBrack
  in ['{', :S0, _]
    :RBrace
  in ['(', :S0, _]
    :RParen
  in [']', :S0, :Rbrack]
    :Ok
  in ['}', :S0, :Rbrace]
    :Ok
  in [')', :S0, :Rparen]
    :Ok
  in [']', _, :Rbrace]
    :Err
  in ['}', _, :Rbrack]
    :Err
  in [')', _, :Rbrack]
    :Err
  in [']', _, :Rparen]
    :Err
  in ['}', _, :Rparen]
    :Err
  in [')', _, :Rbrace]
    :Err
  in [_, :S0, :"$"]
    :ok
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