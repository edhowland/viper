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
    final = offset + (@length.zero? ? 0 : @length - 1)
    Range.new(offset, final)   # offset + @length-1)
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
  def at_start?
    @table.length == 1 && @table[0].buff == ORIG && @table[0].offset.zero? && @table[0].length == @orig.length
  end

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
    # return stuff to undo this
    return :undo_delete, ndx, ndx+1
  end
  # insert - triplicate the the piece
  def insert(string, offset:)
ndx, logical_rng, piece = piece_index_of(offset)
    r1, r2 =  left_right(piece, logical_rng, offset)

    table_inject(ndx) { [PieceDescript.from_range(piece.buff, r1),       peri(string), PieceDescript.from_range(piece.buff, r2)] }

    @append << string
    return :undo_insert, ndx, ndx+1, ndx+2
  end

  def []=(ndx, string)
    insert string, offset: ndx
  end

  # undo/redo methods
  # undo_delete, left_index, right_index. Given 2 entries in table reverse them
  # return everything needed to redo the original action: :delete, offset, length
  def undo_delete(l_ndx, r_ndx)
    l, r = @table[l_ndx..r_ndx]
    range = join_range(l.to_range, r.to_range)
    piece = PieceDescript.from_range(l.buff, range)
    @table.delete_at(r_ndx)
    @table[l_ndx] = piece
    return :delete, l.to_range.last+1, (r.to_range.first - (l.to_range.last + 1))
  end

  # undo insert, prepare for redo_insert instead of :insert
  def undo_insert(l_ndx, i_ndx, r_ndx)
    l, i, r = @table[l_ndx..r_ndx]
    range = join_range(l.to_range, r.to_range)
    piece = PieceDescript.from_range(l.buff, range)

@table.delete(r)
@table.delete(i)
@table[l_ndx] = piece
# return the special :redo_insert, since we already have the inserted text in @append
return :redo_insert, r.to_range.first, i.length
  end
end
