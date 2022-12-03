# stack.rb

class Stack < Array
  def nop(*args)
    # ignores, or X don't care
  end
  alias_method :peek, :last
end
