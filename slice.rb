# slice.rb - class Slice - wraps a call to string.slice

require_relative 'span'

# Slice - Span of some string
class Slice
  def initialize string, span=Span.new(0..(string.length-1))
    @string = string
    @span = span
  end
  attr_reader :string, :span
  def with_span(spn)
    Slice.new(@string, spn)
  end

  def to_s
    @span.span { @string }
  end

  def empty?
    to_s.empty?
  end

  def length
    to_s.length
  end

  # modification methods
  def join(other)
    self.class.new(@string, (@span + other.span))
  end
  # split gap : Span
  # returns 2 new Slices w spans gapped
  def split(gap)
    return self.class.new(@string, (gap - @span)),
     self.class.new(@string, gap.outer(@span))
  end

  def inspect
    "#{self.class.name}: #{to_s}"
  end
end


#class EmptySlice < Slice
#  def initialize string
#    super string, 0, 0
#  end
#
#  def to_s
#    ''
#  end
#
#  def empty?
#    true
#  end
#
#  def length
#    0
#  end
#
#  def +(other)
#    other
#  end
#end
