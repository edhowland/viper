# redirection - class Redirection - holder for >, <, >> 2> stuff

require_relative 'context_constants'

class AmbigousRedirection < RuntimeError
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
    # %%LINT4
    raise AmbigousRedirection, "ambigous redirection target #{target}" if target.nil? || target.empty? || !!(target =~ /^\s+$/)
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
