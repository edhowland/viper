# buffer sliced_buffer.rb - class SlicedBuffer - triple of string, append string 
# and  SliceTable

class SlicedBuffer
  def initialize string=''
    @buffer = string.freeze
    @append = ''
    # TODO: Change this to ring buffer for undo/redo
    @slices = SliceTable.new(@buffer)
  end

  def to_s
    @slices.to_s
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
    @slices.split_at(gap)
  end

  def insert(position, string)
    offset = @slices.offset_of(position)
    range = @slices.ranges[offset]
    position = position - range.first
    @slices.cleave_at(offset, position)
    @slices.insert_at(offset+1, string)
  end
end