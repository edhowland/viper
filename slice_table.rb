# slice_table.rb - class  SliceTable - Holds Slices, can split, join them

class SliceTable
  def initialize string=''
    @table = [Slice.new(string)]
  end
  def self.from_a(array)
    result = self.new
    result.table = array
    result
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


  def offset_of(index)
    ranges.index{|e| e.overlap?(Span.new(index..index)) } 
  end

  # Use map on @table to detect overlaps
  def zipper gap
    def from_p(r, g)
      if r.contains?(g)
#        ->(x) { x.split(g) }
        ->(x) { x.split(x.span.translate(r, g)) }
      elsif g.contains?(r)
        ->(x) { [] }
      elsif r < g
        ->(x) { x.with_span(x.span.from_right(r.last - g.first + 1)) }
      elsif r > g
        ->(x) { x.with_span(x.span.from_left(g.last - r.first + 1)) }
      else
        raise RuntimeError.new "something went wrong: r: #{r.inspect}, g: #{g.inspect}"
      end
    end
    r = ranges.map {|r| gap.overlap?(r) ? from_p(r, gap) : ->(x) { x } }
    @table.zip(r)
  end
  def applyp(gap)
    zipper(gap).map {|sl, p| p[sl] }.flatten
  end
  def split_at(gap)
    @table = applyp(gap)
  end

  def perform_at(offset, &blk)
    @table.zip((0..(@table.length - 1)).to_a).map {|e, i| i == offset ? blk[e] : e }.flatten
  end


  # cleave_at offset of piece_table and offset of slice therin
  def perform_cleave_at(offset, s_off)
    perform_at(offset) { |e| e.cleave(s_off) }
  end
  def cleave_at(offset, s_off)
    @table = perform_cleave_at(offset, s_off)
  end

  def perform_insert_at(offset, string)
    perform_at(offset) { |e| [Slice.new(string), e] }
  end

  def insert_at(offset, string)
    @table = perform_insert_at(offset, string)
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


  def table=(array)
    @table = array
  end
end
