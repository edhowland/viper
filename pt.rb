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
  def ante(descript, length:)
    PieceDescript.new(descript.buff, descript.offset, length)
  end

  def peri string
        PieceDescript.new(APPEND, @append.length, string.length)
  end

  # post - teh bit after the deletion or insert
  def post(descript, addnl:)
    np = descript.to_range.last - addnl + 1
    PieceDescript.new(descript.buff, np, addnl)
  end

  def within offset, length=-1
    span = ranges
    des = span.find {|e| e.include? offset }
    span.index des
  end

  def split(piece, offset:, length:)
    return ante(piece, length: offset),        post(piece,  addnl: length)
  end
  def delete(offset, length)
    ndx = within(offset, length)
    logical_rng  = ranges[ndx]
    piece = @table[ndx]
    r1, r2 = split_range(piece.to_range, offset_of(logical_rng, piece.to_range, offset), length)  
#    binding.pry
    @table[ndx] = [PieceDescript.from_range(piece.buff, r1), PieceDescript.from_range(piece.buff, r2)]
    @table.flatten!
  end
  # insert - triplicate the the piece
  def insert(string, offset:)
    ndx = within(offset)
    logical_rng  = ranges[ndx]
    piece = @table[ndx]
    r1, r2 = split_range(piece.to_range, offset_of(logical_rng, piece.to_range, offset), 0)  
    @table[ndx] = [PieceDescript.from_range(piece.buff, r1),       peri(string), PieceDescript.from_range(piece.buff, r2)]
    @table.flatten!

    @append << string
  end

  def []=(ndx, string)
    insert string, offset: ndx
  end
end

