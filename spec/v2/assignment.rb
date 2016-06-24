# assignment - class Assignment - Subtree of  Symbol node and either 
# QuotedString, StringLiteral, Deref or CommandExpansion

class Assignment
  def initialize left, right
    @left = left
    @right = right
  end
  def call frames:
    frames[@left] = @right.call frames:frames
  end
  def to_s
    @left.to_s + '=' + @right.to_s
  end
end

