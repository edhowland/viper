# closure.rb - class  Closure - Implements logic for closures in lambdas
# Used in class LambdaDeclaration call method.
# Depending on state of frame stack when the lambda is declared, implements
# the following truth table
# No enclosing function or lambda(s)    : [] - empty FrameStack
# One enclosing function                : frames back to [:__FUNCTION_TYPE__] == 'function'
# One or more enclosing lambdas         :  frames back to first enclosing lambda
# function with 2 or more enclosed lambdas : Same as single  function above
# 
# IOW: Any function body enclosing any number of lambdas each enclosing each 
# other, is the floor of the search back. But, in the global environment, 
# the floor is the outer most enclosing lambda, if more than one.
#
# The floor of the outer lambda is from the beginning of the FrameStack
# where frames[:__FUNCTION_TYPE__] == 'lambda'
# But does not include the current lambda being declared, since it does not exist

 # class Sorty - a hloder of things that can be sorted 
class Sorty
  include Comparable
  def initialize value, ordinal=0
    @value = value
    @ordinal = ordinal
  end
  attr_reader :value, :ordinal
  def <=> other
    self.ordinal <=> other.ordinal
  end
  def rangify
    Range.new(self.value, -1)
  end
end


 class Closure  
   class << self
    def floor(stack)
      (stack.rindex_of {|e| e[:__FUNCTION_TYPE__] == 'function'}) || BFN::Max
    end

    def ceil(stack)
      (stack.index_of {|e| e[:__FUNCTION_TYPE__] == 'lambda'}) || BFN::Max
    end

    def close stack
      start = floor(stack)
      fin = ceil(stack)
      return [] if ! closed?(start, fin)

      a = [Sorty.new(start), Sorty.new(fin, 1)]
      a.reject! {|e| e.value == BFN::Max }
      a.sort!
      return a if a.empty?
      rng = a.first.rangify

      stack.frames[rng]
    end
    def closed?(start, fin)
      !(start == fin)
    end
  end
end
