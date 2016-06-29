# redirection - class Redirection - holder for >, <, >> 2> stuff

require_relative 'context_constants'


class ObjectRedir
  def initialize target, mode
    @target = target
    @mode = mode
  end
  def open
    @handle = File.open @target, @mode
  end
  def close
    @handle.close
  end
  end

class Redirection
  def initialize op, target
    @op = op
    @target = target
    def key
      {'<' => :in, '>' => :out, '2>' => :err, '<<' => :out}[@op]
    end
    def mode
      {'<' => 'r', '>' => 'w', '2>' => 'w', '>>' => 'w'}[@op]
    end
  end
  def call env:, frames:
    target  = @target.call env:env, frames:frames
    target = target[0] if Array === target
    env[key] = ObjectRedir.new target, mode
    nil   # we will be rejected in statement after  we have been called
  end
  def ordinal
    REDIR
  end
  def to_s
    @op + ' ' + @target.to_s
  end
end
