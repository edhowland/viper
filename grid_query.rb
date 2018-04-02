# grid_query.rb - class GridQuery
# Given a SlicedBuffer return query Spans for the SlicedBuffer query method(s)

class GridQuery
  def initialize sliced_buffer
    @buffer = sliced_buffer
    @cursor = Span.new(0..0)
    @search_results = []
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
  # limit
  def limit
    @buffer.length - 1
  end

  def down
    lspan = line
    return bottom if lspan.nil?
    ndx = line_spans.index lspan
    nspan = line_spans[ndx + 1]
    return bottom if nspan.nil?

    @cursor = Span.new nspan.first..nspan.first
  end
  def up
        lspan = line
        return top if lspan.nil?
    ndx = line_spans.index lspan
    return top if ndx.zero?
    nspan = line_spans[ndx - 1]
        return top if nspan.nil?

    @cursor = Span.new nspan.first..nspan.first
  end
  def right
      return bottom if @cursor.first == limit
    @cursor = Span.new((@cursor.first+1)..(@cursor.first+1))
  end
  def left
    return ZeroSpan.new if @cursor == ZeroSpan.new
    @cursor = Span.new((@cursor.first-1)..(@cursor.first-1))
  end
  def top
    @cursor = Span.new(0..0)
  end
  def bottom
    @cursor = Span.new(limit..limit)
  end

  # start/end of line
  def sol
    sp = line
    @cursor = Span.new(sp.first..sp.first)
  end
  def eol
    sp = line
    @cursor = Span.new(sp.last..sp.last)
  end

  def inspect
    "#{self.class.name}: cursor: #{@cursor.inspect}"
  end
  def top_to_cursor
    Span.new(0..(@cursor.first))
  end
  def cursor_to_bottom
    Span.new(@cursor.first..limit)
  end
  # word queries
  def word
sp = cursor_to_bottom   #top_to_cursor #Span.new(sp.first..limit)
ahead = @buffer[sp]
match_data = ahead.match(/^(\w+)/)
    unless match_data.nil?
    _word =  match_data[1]
    s = sp.first #ahead.index _word
    e = s + _word.length

    Span.new(s..e)
  else
    cursor
  end

  end
  def word_back
    sp = top_to_cursor
    behind = @buffer[sp]
    offset = behind.rindex(/\s/)
    Span.new(offset..@cursor.first)
  end
  def word_fwd
    sp = word
    @cursor = Span.new((sp.last + 1)..(sp.last + 1))
    word
  end

  # search stuff
  def search_spans regx
    @search_results = @buffer.to_s.to_enum(:scan, regx).map { Regexp.last_match }.map {|m| [m.begin(0), m.end(0) ] }.map {|f, l| Span.new(f..l) }
  end
  def next_result
    @search_results.find {|r| r.first > @cursor.first }
  end
  def prev_result
    @search_results.reverse.find {|r| r.first < @cursor.first }#
  end
end
