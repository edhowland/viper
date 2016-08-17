# buf_node - class BufNode - subclass VFSNode - like a directory, but a buffer


class BufNode < VFSNode
  def initialize parent, name
    super parent, name
    @list['line'] = LineNode.new(self, 'line')   #StringIO.new
  end
  def mknode name
    @list['nl'] = BufNode.new self, 'nl'
  end
  def insnode text=''
    child = @list['nl']
    baby = mknode ''
    lnode = LineNode.new(baby, 'line')
    lnode.right = text
    baby['line'] = lnode
    baby.parent = child.parent
    child.parent = baby
    baby['nl'] = child
    baby
  end
  def to_s
    "buf node #{name}"
  end

     def newline
    exist = @list['nl']
    nl = BufNode.new(self, 'nl')
    nl['nl'] = exist unless exist.nil?
    exist.parent = nl unless exist.nil?
    @list['nl'] = nl
  end
end
