# vfs_root - class VFSRoot - parent node of all nodes, and holder  for subtrees


class VFSRoot
  def initialize 
    @root = VFSNode.new nil, ''
    @wd = @root
  end
  attr_reader :root, :wd


  def pwd
    pathr = []
    p = @wd
    until p.parent.nil?
      pathr << p
      p = p.parent
    end
    '/' + pathr.reverse.map {|e| e.name }.join('/')
  end
  def _chdir elements, start=@wd
    elements.each do |e|
      start = start[e]
    end
    @wd = start
  end
  def _mkdir elements, start=@root
    node = start
    elements.each do |e|
      node = node.mknode e
  end
end
end
