# buffer sliced_buffer.rb - class SlicedBuffer - triple of string, append string 
# and  SliceTable

# NullSliceTable - End of ring buffer
class NullSliceTable
  def inspect
    self.class.name
  end
end


# exceptions
class UndoStackUnderflowError < RuntimeError
  def initialize
    super "#{self.class.name}: Can perform no more undo operations"
  end
end

class RedoStackOverflowError < RuntimeError
  def initialize
    super "#{self.class.name}: Can perform no more redo operations"
  end
end

class SlicedBuffer
  def initialize string=''
    @buffer = string.freeze
    @append = ''
    # TODO: Change this to ring buffer for undo/redo
    @slices = [NullSliceTable.new, SliceTable.new(@buffer)]
  end
  attr_reader :slices

  def slices_start
    @slices.last
  end


  def to_s
    slices_start.to_s
  end

  def span_after_append(string)
    @append << string
    Span.new(@append.length - (string.length)..(@append.length - 1))
  end

  # modifieres
  def wrap(&blk)
    SliceTable.from_a(yield)
  end
  def delete_at(object)
    case object
    when Integer
      gap = Span.new(object..object)
    when Range
      gap = Span.new(object)
    else
      raise RuntimeError.new "Wrong type of argument for delete_at: #{object.class.name}"
    end
    @slices << wrap {slices_start.applyp(gap)} 
  end

  def insert(position, string)
    if position.zero?
      self.>>(string)
    elsif position >= slices_start.length
      self.<<(string)
    else
    offset = slices_start.offset_of(position)
    range = slices_start.ranges[offset]
    position = position - range.first
      # temporay storage for cleave_at result. In case it explodes
      temp = wrap { slices_start.perform_cleave_at(offset, position) }
      span = span_after_append(string)
      slice = Slice.new(@append, span)
      @slices << wrap { temp.perform_insert_at(offset+1, slice) }
    end
  end

  def >>(string)
  span = span_after_append(string)

    @slices <<  wrap { slices_start.table.unshift(Slice.new(@append, span)) }
  end
  def <<(string)
  span = span_after_append(string)
    @slices << wrap {slices_start.table + [ Slice.new(@append, span) ] } 
  end

  # query methods
  def [](object)
    span = case object
    when Integer
      Span.new(object..object)
    when Range
      Span.new(object)
    else
      raise RuntimeError.new 'Invalid type of index expression. Only integer and range allowed'
    end

  slices_start.with_span(span).join
  end

  # Undo/Redo operations
  def undo
    raise UndoStackUnderflowError if @slices[-2].instance_of?(NullSliceTable)
    @slices.rotate!(-1)
  end
  def redo
    raise RedoStackOverflowError.new if @slices[0].instance_of?(NullSliceTable)
    @slices.rotate!
  end

  def inspect
    "#{self.class.name}: slices length: #{@slices.length}"
  end
end