# vfs_node - class VFSNode - A node in a VFS tree


class VFSNode
  def initialize parent, name
  @name = name
    @parent = parent
    @list = {}
  end
  attr_reader :parent, :list, :name
  def mknode name
    @list[name] = VFSNode.new(self, name)
  end
  def [] key
    @list[key]
  end
  def []= key, value
    @list[key] = value
  end
  def keys
    @list.keys
  end
end
