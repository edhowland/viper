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

  def peri string
        PieceDescript.new(APPEND, @append.length, string.length)
  end

  # post - teh bit after the deletion or insert
  def post(descript, offset:)
#  binding.pry

    PieceDescript.new(ORIG, offset, (descript.length - offset))
  end
  def delete(offset, length)
    piece = @table.shift
    @table = [
      ante(piece, offset: offset), 
      post(piece, offset: offset+length)
    ]
  end
  # insert - triplicate the the piece
  def insert(string, offset:)
    piece = @table.shift
    @table = [
      ante(piece, offset: offset),
      peri(string),
      post(piece, offset: offset)
    ]

    @append << string
 end
end

