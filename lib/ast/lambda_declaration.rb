# lambda_declaration - class LambdaDeclaration - returns lambda closure
# returns Lambda instance

class LambdaDeclaration
  include ClassEquivalence

  def initialize(args, block)
    @args = args
    @block = block
  end
  attr_reader :args, :block

  def call(*_args, env:, frames:)
    #  save the environment of of us back to  first lambda on stack or  or just our own environment frames[-1]
#    idx = frames.index_of {|e| e[:__FUNCTION_NAME__] == 'anonymous' }
#    idx ||= -1
#    klone = frames._clone
#    fr = klone.slice (idx..-1)
#    fr = frames.back(:__FUNCTION__)

  fr = Closure.close(frames)
    Lambda.new(@args, @block, frames: fr)
  end

  def ordinal
    COMMAND
  end

  def to_s
    '&(' + @args.to_s + ') { ' + @block.to_s + ' )'
  end

  def ==(other)
    class_eq(other) && other.block == self.block
  end
end
