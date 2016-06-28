# assignment - class Assignment - Subtree of  Symbol node and either 
# QuotedString, StringLiteral, Deref or CommandExpansion

require_relative 'context_constants'
class Assignment
  def initialize left, right
    @left = left
    @right = right
  end
  def call env:, frames:
    frames[@left] = @right.call env:env, frames:frames
    nil # we will be rejected in statement
  end
  def to_s
    @left.to_s + '=' + @right.to_s
  end
  def ordinal
    ASSIGN
  end
end

