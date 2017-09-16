# lambda_declaration - class LambdaDeclaration - returns lambda closure
# returns Lambda instance

class LambdaDeclaration
  def initialize(args, block)
    @args = args
    @block = block
  end

  def call(*_args, env:, frames:)
    #  save the environment of of us back to  first function on stack or 0 or global level
#    binding.pry
    idx = frames.index_of {|e| e[:__FUNCTION__] }
    idx ||= 0
    klone = frames._clone
    fr = klone.slice (idx..-1)
#    fr = frames.back(:__FUNCTION__)
    Lambda.new(@args, @block, frames: fr)
  end

  def ordinal
    COMMAND
  end

  def to_s
    '&(' + @args.to_s + ') { ' + @block.to_s + ' )'
  end
end
