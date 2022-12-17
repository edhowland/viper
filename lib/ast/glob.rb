# glob - class Glob - represents *.rb - expands to all files matching pattern.

require_relative 'context_constants'

class Glob
  def initialize(pattern)
    raise "glob: pattern is not a kind of QuotedString" unless pattern.kind_of?(QuotedString)
    @pattern = pattern
  end
  attr_reader :pattern

  def call(env:, frames:)
#binding.pry unless $debug.nil?
    derefed_pattern = @pattern.call frames: frames
    result = []
    if derefed_pattern =~ /\*|\[|\?/
      result = Hal[derefed_pattern]  
    else

    end
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
