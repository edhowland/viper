# glob - class Glob - represents *.rb - expands to all files matching pattern.

require_relative 'context_constants'

class Glob
  def initialize pattern
    @pattern = pattern
  end
  def call env:, frames:
    derefed_pattern = @pattern.call frames:frames
    result = Dir[derefed_pattern]
    return derefed_pattern if result.empty?
    return result[0] if result.length == 1
    result
  end
  def to_s
    @pattern.to_s
  end
  def ordinal
    COMMAND
  end
end
