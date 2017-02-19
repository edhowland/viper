# buf_node - class BufNode - subclass VFSNode - like a directory, but a buffer

class BufNode < VFSNode
  def initialize parent, name
    super parent, name
    buffer = Buffer.new('')
    @list['buffer'] = buffer
  end
  def mknode name
    @list['nl'] = BufNode.new self, 'nl'
  end
  def insnode text=''
    child = @list['nl']
    unless child
      mknode ''
    child = @list['nl']
    end
    baby = mknode ''
    lnode = LineNode.new(baby, 'line')
    lnode.right = text
    baby['line'] = lnode
    baby.parent = child.parent
    child.parent = baby
    baby['nl'] = child
    baby
  end
  def addnode text=''
    child = mknode ''
    lnode = LineNode.new child, 'line'
    lnode.right = text
    child['line'] = lnode
    child
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
