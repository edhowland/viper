# span.rb - class Span operations  on span of string

class Span
  def initialize range
    @range = range
  end
  attr_reader :range

  def first
    @range.first
  end
  def last
    @range.last
  end

  def span &blk
    yield.slice((first)..( last))
  end
  def start_at(offset)
    Range.new(offset, (@range.size-1) + offset)
  end

  # arithmetic operations
  # + : Union of 2 spans
  # from first of left span to last of right span
  def +(span)
    self.class.new(self.first..span.last)
  end
  #
  # - : Intersection of 2 spans
  # Assuming left is larger subtracts from smaller on right
  def -(right)
    if self.first.zero?
      LeftSpan.new
    else
      Span.new(right.first..self.first - 1)
    end
  end
  def outer(span)
    if self.last == span.last
      RightSpan.new(self.first)
    else
      Span.new((last + 1)..(span.last))
    end
  end

  def inspect
    "#{self.class.name}: #{@range}"
  end
end

# EmptySpan - Helpful for exactly split splices
# E.g. sl = Slice.new '0123456789'
# sl.split EmptySpan.new(5) = '01234', '56789'
class EmptySpan < Span
  def initialize offset
    super(Range.new(offset,0))
  end
  def span(&blk)
    ""
  end
  def last
    first 
  end
  def outer(right)
    Span.new(first..right.last)
  end
end

class LeftSpan < Span
  def initialize
    super(-1..0)
  end
  def span &blk
    ""#
  end
  def -(other)
    self
  end
  def outer(span)
    span
  end
  def start_at(offset)
    Range.new(offset, 0)
  end
end

class RightSpan < EmptySpan
def span(&blk)
  ""
end
  def -(span)
    span
  end
  def outer(span)
    self
  end
  def start_at(offset)
    Range.new(offset, 0)
  end
end