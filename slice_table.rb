# slice_table.rb - class  SliceTable - Holds Slices, can split, join them

class SliceTable
  def initialize string
    @table = [Slice.new(string)]
  end
  attr_reader :table
  def ranges
    result = []
    running = 0
    @table.each_with_index do |e, i|
      result << e.span.start_at(running)
      running += e.length
    end
    result
  end

  def within offset, length=-1
    span = ranges
    des = span.find {|e| e.include? offset }
    span.index des
  end

  # split_at span
  def split_at(span)
    ndx = within(span.first)
    piece = @table[ndx]
    @table[ndx] = piece.split(span)
    @table.flatten!
  end
  def join(left, right)
    l = @table[left]
    r = @table[right]
    c = l.join(r)
    @table[left] = c
    @table.delete_at(right)
  end
  def to_s
    @table.map(&:to_s).join
  end
  def inspect
    "#{self.class.name}: length: #{@table.length}"
  end
end
