# pt.rb - implementation of PieceTable data structure

ORIG=true
APPEND=false


PieceDescript = Struct.new(:buff, :offset, :length)

class PieceTable
  def initialize buffer
    @orig = buffer
    @append = []
    @table = [PieceDescript.new(ORIG, 0, @orig.length)]
  end
  attr_reader :orig, :table
  attr_accessor :append

  def to_s
    @orig.to_s
  end

  def delete(offset, length)
    piece = @table.shift
    before =  PieceDescript.new(piece.buff, piece.offset, (offset - piece.offset))
    after = PieceDescript.new(piece.buff, (piece.offset + length), (piece.length - length))
    @table = [before, after]
  end
end

