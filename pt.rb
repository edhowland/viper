# pt.rb - implementation of PieceTable data structure

require_relative 'range_functions'


ORIG=true
APPEND=false

class PieceDescript
  def initialize buff, offset, length
    @buff = buff
    @offset = offset
    @length = length
  end
  attr_reader :buff, :offset, :length
  def self.from_range(buff, range)
    self.new(buff, range.first, range.last - range.first + 1)
  end
  def orig?
    @buff
  end
  def append?
    not @buff
  end
  def to_range offset=@offset
    Range.new(offset, offset + @length-1)
  end
  def to_a
    [to_range.first, to_range.last]
  end
  def inspect
    "#{self.class.name}: buff: #{@buff}, offset: #{@offset}, length: #{@length}"
  end
end

class PieceTable
  def initialize buffer
    @orig = buffer
    @append = ""
    @table = [PieceDescript.new(ORIG, 0, @orig.length)]
  end
  attr_reader :orig, :table
  attr_accessor :append

  def ranges
    result = []
    running = 0
    @table.each_with_index do |e, i|
      result << e.to_range(running)
      running += e.length
    end
    result
  end

  def get_slice(buff, descript)
    buff.slice(descript.offset, descript.length)
  end
  def buff_of(piece)
    piece.orig? ? @orig : @append
  end
  def piece_of(piece)
    get_slice(buff_of(piece), piece)
  end
  def partition(ndx)
    piece_of @table[ndx]
  end

  def to_s
    @table.reduce('') {|i, j| i << piece_of(j) }
  end

  # ante - the part of buff before the descript

  def peri string
        PieceDescript.new(APPEND, @append.length, string.length)
  end


  def within offset, length=-1
    span = ranges
    des = span.find {|e| e.include? offset }
    span.index des
  end

  def left_right(piece, logical_rng, offset, length=0)
    split_range(piece.to_range, offset_of(logical_rng, piece.to_range, offset), length)  
  end

  def table_inject(ndx, &blk) 
    @table[ndx] = yield
    @table.flatten!
  end


  # given offset, length return found ndx, piece and logical range
  def piece_index_of(offset, length=0)
    ndx = within(offset, length)
    logical_rng  = ranges[ndx]
    return ndx, logical_rng, piece = @table[ndx]
  end

  def delete(offset, length)
    ndx, logical_rng, piece = piece_index_of(offset, length)
    r1, r2 =  left_right(piece, logical_rng, offset, length)
    table_inject(ndx) {  [PieceDescript.from_range(piece.buff, r1), PieceDescript.from_range(piece.buff, r2)] }
  end
  # insert - triplicate the the piece
  def insert(string, offset:)
ndx, logical_rng, piece = piece_index_of(offset)
    r1, r2 =  left_right(piece, logical_rng, offset)

    table_inject(ndx) { [PieceDescript.from_range(piece.buff, r1),       peri(string), PieceDescript.from_range(piece.buff, r2)] }

    @append << string
  end

  def []=(ndx, string)
    insert string, offset: ndx
  end
end

