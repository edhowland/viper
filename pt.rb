# pt.rb - implementation of PieceTable data structure

ORIG=true
APPEND=false


PieceDescript = Struct.new(:buff, :offset, :length)

class PieceTable
  def initialize buffer
    @orig = buffer
    @append = ""
    @table = [PieceDescript.new(ORIG, 0, @orig.length)]
  end
  attr_reader :orig, :table
  attr_accessor :append

  def get_slice(buff, descript)
    buff.slice(descript.offset, descript.length)
  end

  def to_s
    @table.reduce("") do |i, j|
#    binding.pry
      if j.buff == ORIG
        i << get_slice(@orig, j)
      else
        i << get_slice(@append, j)
      end
    end
  end

  # ante - the part of buff before the descript
  def ante(descript, offset:)
    PieceDescript.new(descript.buff, 0, offset)
  end

  # post - teh bit after the deletion or insert
  def post(descript, offset:, length:)
#  binding.pry

    PieceDescript.new(descript.buff, offset+length, descript.length - (offset + length))
  end
  def delete(offset, length)
    piece = @table.shift
    @table = [ante(piece, offset: offset), post(piece, offset: offset, length: length)]
  end
  # insert - triplicate the the piece
  def insert(string, offset:)
    piece = @table.shift
    peri = PieceDescript.new(APPEND, @append.length, string.length)
    @append << string
    @table = [
      ante(piece, offset: offset),
      peri,
      post(piece, offset: offset, length: (piece.length - offset))
    ]
#    @table = [ante(piece, offset: offset), peri, post(piece, offset: offset, piece.length - offset)]
 end
end

