# assignment - class Assignment - Subtree of  Symbol node and either
# QuotedString, StringLiteral, Deref or CommandExpansion

require_relative 'context_constants'

class Assignment
  include ClassEquivalence
  def initialize(left, right)
    @left = left
    @right = right
  end
  attr_reader :left, :right

  def call(env:, frames:)
    frames[@left] = @right.call env: env, frames: frames
    nil # we will be rejected in statement
  end

  def to_s
    @left.to_s + '=' + @right.to_s
  end

  def ordinal
    ASSIGN
  end
  def ==(other)
    class_eq(other) && (other.left == self.left && other.right == self.right)
  end
end
