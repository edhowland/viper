# argument - class Argument - holds an argument which be given to a command

require_relative 'context_constants'

class Argument
  def initialize(thing)
    @storage = thing
  end

  def call(env:, frames:)
    @storage.call frames: frames, env: env
  end

  def to_s
    @storage.to_s
  end

  def ordinal
    COMMAND
  end
end
