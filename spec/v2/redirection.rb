# redirection - class Redirection - holder for >, <, >> 2> stuff


require_relative 'context_constants'

class Redirection
  def initialize op, target
    @op = op
    @target = target
  end
  def call env:, frames:
    target  = @target.call env:env, frames:frames
    target = target[0] if Array === target
    env[:out] = File.open(target, 'w')
    nil   # we will be rejected in statement after  we have been called
  end
  def ordinal
    REDIR
  end
end
