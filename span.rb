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
  def overlap?(other)
    last >= other.first and other.last >= first
  end

  # Spaceship: <=>. -1 if we are totally less than other. 0 if within or
  # overlapping. And 1 if we are completely > other
  def <=>(other)
    if last < other.first
      -1
    elsif first > other.last
      1
    else
      0
    end
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
    Span.new(self.first..span.last)
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
      RightSpan.new(self.first..self.last)
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
  def +(span)
    Span.new(0..(span.last))
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

class RightSpan < Span
def span(&blk)
  ""
end
def +(span)
  Span.new(first..(span.last))
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