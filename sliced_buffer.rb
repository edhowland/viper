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
    # No need for append buffer. Use Slice with new string instead
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

  # modifieres
  def delete_at(object)
    case object
    when Integer
      gap = Span.new(object..object)
    when Range
      gap = Span.new(object)
    else
      raise RuntimeError.new "Wrong type of argument for delete_at: #{object.class.name}"
    end
    @slices << SliceTable.from_a(slices_start.applyp(gap))
  end

  def insert(position, string)
    offset = slices_start.offset_of(position)
    range = slices_start.ranges[offset]
    position = position - range.first

    # temporay storage for cleave_at result. In case it explodes
    temp = SliceTable.from_a(slices_start.perform_cleave_at(offset, position))
    @slices << SliceTable.from_a(temp.perform_insert_at(offset+1, string))
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