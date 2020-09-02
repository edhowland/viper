# redirection - class Redirection - holder for >, <, >> 2> stuff

require_relative 'context_constants'

class AmbigousRedirection < RuntimeError
  def initialize(target)
    super "#{self.class.name}: target: #{target}"
  end
end

class ObjectRedir
  def initialize(target, mode)
    @target = target
    @mode = mode
  end

  def open
    @handle = Hal.open @target, @mode
  end

  def close
    @handle.close
  end
end

class Redirection
  def initialize(op, target)
    @op = op
    @target = target
  end

  def key
    { '<' => :in, '>' => :out, '2>' => :err, '>>' => :out }[@op]
  end

  def mode
    { '<' => 'r', '>' => 'w', '2>' => 'w', '>>' => 'a' }[@op]
  end

  def call(env:, frames:)
    target = @target.call env: env, frames: frames
    target.extend Blankable
    raise AmbigousRedirection, target if target.blank?
    target = target[0] if Array === target
    env[key] = ObjectRedir.new target, mode
    nil # we will be rejected in statement after  we have been called
  end

  def ordinal
    REDIR
  end

  def to_s
    @op + ' ' + @target.to_s
  end
end
