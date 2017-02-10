# vfs_root - class VFSRoot - parent node of all nodes, and holder  for subtrees

class VFSRoot
  def initialize 
    @root = VFSNode.new nil, ''
    @wd = @root
    @mount_pt = ''
  end
  attr_reader :root
  attr_accessor :wd
  attr_accessor  :mount_pt


  def pwd
    pathr = []
    p = @wd
    until p.parent.nil?
      pathr << p
      p = p.parent
    end
    '/' + pathr.reverse.map {|e| e.name }.join('/')
  end
  def path_to_elements path
    elements = path.split('/')
    if elements[0].nil? || elements[0].empty?
      elements[0] = @root
    else
    elements.unshift @wd
  end
  elements
  end
  def _chdir elements, start=@wd
    elements.each do |e|
      if start.nil? || start[e].nil?
        start = nil
      else
        start = start[e]
      end
    end
    raise Errno::ENOENT.new(elements.join('/')) if start.nil? 
    @wd = start
  end
  def _mkdir elements, start=@root
    node = start
    elements.each do |e|
      if node[e].nil?
        node = node.mknode e
      else
        node = node[e]
      end
  end
end
  def cd path
    start, *elements = path_to_elements(path)
    _chdir elements, start
  end
  def mkdir_p path
    start, *elements = path_to_elements path
    _mkdir elements, start
  end
  def node elements, start=@root
    elements.each do |e|
      if start.nil? || start[e].nil?
        start = nil
      else
        start = start[e]
      end
    end
    start
  end

  def directory? path
          start, *elements = path_to_elements path
    mynode = node elements, start
    mynode.instance_of? VFSNode
  end
  def list path='.'
    if path == '.'
      @wd.keys
    else
      start, *elements = path_to_elements path
#binding.pry
      mynode = node(elements, start)
      if VFSNode === mynode
        mynode.keys
      else
        [elements[-1]]
      end
    end
  end

  def contains? path
    start, *elements = path_to_elements path
    !start[elements[0]].nil?
  end
  def creat path, object=StringIO.new('')
    start, *elements = path_to_elements path
    my_node = node(elements[0..(-2)], start)
    my_node[elements[-1]] = object
  end
  def [] path
    start, *elements = path_to_elements path
    node elements, start
  end
  def to_s
    "mounted at: #{@mount_pt}"
  end
  # given a path, return its parent node
  def dirnode path
    start, *elements = path_to_elements path
    node elements[0..(-2)], start
  end
  def dirpath path
    start, *elements = path_to_elements path
    elements[0..-2]
  end
  def basename path
    start, *elements = path_to_elements path
    elements[-1]
  end
  def parents node
    rpath = []
    until node.parent.nil?
      rpath << node
      node = node.parent
    end
    rpath.reverse
  end
  def realpath path
    start, *elements = path_to_elements path
    '/' + (parents(start).map {|e| e.name } + elements).join('/')
  end
end
