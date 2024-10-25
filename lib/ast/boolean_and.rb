# boolean_and - class BooleanA - implements && operatornd

class BooleanAnd
  include ClassEquivalence

  def initialize(left, right, line_number = 0)
    @left  = left
    @right = right
    @line_number = line_number
  end

  attr_reader :line_number, :left, :right
  def call(env:, frames:)
    @left.call(env: env, frames: frames) &&
      @right.call(env: env, frames: frames)
  end

  def to_s
    @left.to_s + ' && ' + @right.to_s
  end
  def ==(other)
    class_eq(other) && (other.left == self.left && other.right == self.right && other.line_number == self.line_number)
  end
end
