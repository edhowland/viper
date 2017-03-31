# boolean_and - class BooleanA - implements && operatornd

class BooleanAnd
  def initialize(left, right, line_number = 0)
    @left  = left
    @right = right
    @line_number = line_number
  end

  attr_reader :line_number
  def call(env:, frames:)
    @left.call(env: env, frames: frames) &&
      @right.call(env: env, frames: frames)
  end

  def to_s
    @left.to_s + ' && ' + @right.to_s
  end
end
