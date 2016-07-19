# line_node - class LineNode - element node under BufNode


class LineNode < VFSNode
  def initialize parent, name
    super parent, name
    @list['left'] = []
    @list['right'] = []
  end
  def left
    @list['left']
  end
  def right
    @list['right']
  end
  def insert string
    @list['left'] += string.chars
  end
  def string
    (@list['left'] + @list['right']).join ''
  end
end
