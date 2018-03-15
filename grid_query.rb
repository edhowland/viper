# grid_query.rb - class GridQuery
# Given a SlicedBuffer return query Spans for the SlicedBuffer query method(s)

class GridQuery
  def initialize sliced_buffer
    @buffer = sliced_buffer
    @cursor = Span.new(0..0)
  end
  attr_reader :buffer
  attr_accessor :cursor
  def line_marks
    contents = @buffer.to_s
    indxs = contents.to_s.chars.map {|e| e == "\n" ? e : nil }
    indxs.zip((0..(contents.length - 1)).to_a).select {|c, n| c == "\n" }.map { |c, n| n }
  end
  def line_spans
    lm = line_marks
    y = [0] + lm.map {|e| e + 1 }
    y.zip(lm).reject {|s, e| e.nil? }.map {|s, e| Span.new(s..e) }
  end
  def line
    line_spans.find {|s| s.overlap?(@cursor) }
  end
  def down
    lspan = line
    ndx = line_spans.index lspan
    nspan = line_spans[ndx + 1]
    @cursor = Span.new nspan.first..nspan.first
  end
  def up
        lspan = line
    ndx = line_spans.index lspan
    nspan = line_spans[ndx - 1]
    @cursor = Span.new nspan.first..nspan.first
  end
  def right
    @cursor = Span.new((@cursor.first+1)..(@cursor.first+1))
  end
  def left
    @cursor = Span.new((@cursor.first-1)..(@cursor.first-1))
  end
  def top
    @cursor = Span.new(0..0)
  end
  def bottom
    limit = @buffer.length - 1
    @cursor = Span.new(limit..limit)
  end
end
