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

  # returns array of tuples of  logical Spans along with offset within @table
  def ranges_w_offsets
    ranges.map {|e| Span.new(e) }.zip((0..@table.length-1).to_a)
  end

  # Given the filtered logical Spans of those spans which overlap the gap
  # return the 2 outer tuples of logical Span and offset. First and last
  def overlapped_regions(gap)
    regions = ranges_w_offsets.select { |e| e[0].overlap? gap }
    return regions.first, regions.last
  end

  # returns the sliced edges off the logical Span edge from the overlapped regions
  def logical_edges(gap)
    l_reg, r_reg = overlapped_regions(gap)
    l_gap = l_reg[0]
    r_gap = r_reg[0]
    l_sp = l_gap.overlap(gap)
    r_sp = gap.overlap(r_gap)
    return l_sp, r_sp

  end

  def indexes_of_gap(gap)
    l_reg, r_reg = overlapped_regions(gap)
    return l_reg[1], r_reg[1]
  end
  def actual_slices(gap)
  l_ndx, r_ndx = indexes_of_gap(gap)
    return @table[l_ndx], @table[r_ndx]
  end

  # Return 2 new Slices computed fromlogical  span edges 
  def actual_adjusted(gap)
  l_ndx, r_ndx = indexes_of_gap(gap)
    l_edge, r_edge = logical_edges(gap)
    l_actual, r_actual = actual_slices(gap)

    l_sp = l_actual.span.from_right(l_edge.length)
    r_sp = r_actual.span.from_left(r_edge.length)
     [l_actual.with_span(l_sp), l_ndx, r_actual.with_span(r_sp), r_ndx]
  end
  def split_2(gap)
    l, lndx, r, rndx = actual_adjusted(gap) 
    @table = @table.select {|e| @table.index(e) < lndx } + [l] + [r] + @table.select { |e| @table.index(e) > rndx }
  end

  # split_at span
  def split_at(span)
    ndx = within(span.first)
    r_ndx = within(span.last)
    if ndx == r_ndx
      piece = @table[ndx]
      @table[ndx] = piece.split(span)
    else
      split_2(span)
    end
    @table.flatten!
  end

  # cleave_at offset of piece_table and offset of slice therin
  def cleave_at(p_off, s_off)
    piece = @table[p_off]
    @table[p_off] = piece.cleave(s_off)
    @table.flatten!
  end

  def insert_at(index, string)
    @table.insert(index, Slice.new(string))
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
