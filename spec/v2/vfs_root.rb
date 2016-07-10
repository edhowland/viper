# vfs_root - class VFSRoot - parent node of all nodes, and holder  for subtrees


class VFSRoot
  def initialize 
    @root = VFSNode.new nil, ''
    @dirs = [@root]
  end
  attr_reader :root

  # returns the VFSNode of the current working dir
  def cwd
    @dirs[-1]
  end
  def pwd
    '/' + @dirs.map {|d| d.name }.join('/')
  end
end
