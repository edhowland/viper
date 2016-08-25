# line_writer - class LineWriter - returned from LineNodeFacade.open 'w'
# methods write, puts, close

class LineWriter < BaseLineHandler
  # write - overwrites contents of this line
  def write string
    @io.left = ''
    @io.right = string
  end
  def puts string
    write "#{string}\n"
  end
  def close
    # nop
  end
end
