# glob - class Glob - represents *.rb - expands to all files matching pattern.



class Glob
  def initialize pattern
    @pattern = pattern
  end
  def call frames:
    derefed_pattern = @pattern.call frames:frames
    result = Dir[derefed_pattern]
    return derefed_pattern if result.empty?
    result
  end
  def to_s
    @pattern.to_s
  end
end
