# hal - class Hal - Hardware Abstraction Layer - dispatches to file or VFS

class PhysicalLayer
  class << self
  def mkdir_p path
    FileUtils.mkdir_p path
  end
  # simulate Dir[]
  def [] path
    Dir[path]
  end
  def pwd
    Dir.pwd
  end
  def chdir path
    Dir.chdir path
  end
  # simulate File.open, directory?
  def open path, mode
    File.open path, mode
  end
    def directory? path
      File.directory? path
    end
    def touch path
      FileUtils.touch(path)
    end
    def basename path
      File.basename path
    end
    def realpath path
      File.expand_path path
    end
    def mv src, dest
      File.rename src, dest
    end
  end
end

$in_virtual = false

class VirtualLayer
  class << self
    def mkdir_p path
      @@root.mkdir_p path
    end
    def get_root
      @@root
    end
    def set_root root=VFSRoot.new
      @@root = root

    end
          def virtual? path
        @@root.contains? path
      end

    def [] path
      if path == '*'
      path = '.'
      @@root.list path
    elsif path == '**'
    gather = []
      node = @@root.wd
      until node.nil?
        prepend = node.pathname
        gather += node.list.keys.map {|e| "#{prepend}/#{e}" }
        node = node['nl']
      end
      gather
    else
      @@root.list path
    end
    end
    def directory? path
      @@root.directory? path
    end
    def relative? path
       path[0] != '/'
    end
    def chdir path
      @@root.cd path
    end
    def pwd
      @@root.pwd
    end
    def touch path
      @@root.creat path
    end
    def open path, mode
      node = @@root[path]
      facade = IOFactory.make node
      facade.open path, mode
    end
    def basename path
      @@root.basename path
    end
    def realpath path
      @@root.realpath path
    end
  end
end


class Hal
  class << self
  # simulate Dir[]
  def [] path
    if $in_virtual || virtual?(path)
      VirtualLayer[path]
    else
      PhysicalLayer[path]
    end
  end
  def pwd
    if $in_virtual
      VirtualLayer.pwd
    else
      PhysicalLayer.pwd
    end
  end
      def relative? path
       path[0] != '/'
    end

  def chdir path, current_pwd
#  binding.pry
    in_virtual = virtual?(current_pwd)
#    if in_virtual
    if (self.relative?(path) && in_virtual) || self.virtual?(path)
      $in_virtual = true
      VirtualLayer.chdir path
    else
      $in_virtual = false
      PhysicalLayer.chdir path
    end
  end
  # is this virtual or is it real
  def virtual? path
      VirtualLayer.virtual? path
  end
  def mkdir_p path
    if virtual? path
      VirtualLayer.mkdir_p path
    else
      PhysicalLayer.mkdir_p path
    end
  end
  # simulate File.open, directory?
  def open path, mode
  if virtual? path || $in_virtual
    VirtualLayer.open(path, mode)
  else
      PhysicalLayer.open path, mode
    end
  end
    def directory? path
      if virtual? path
        VirtualLayer.directory? path
      else
        PhysicalLayer.directory? path
      end
    end
    def touch path
      if $in_virtual || virtual?(path)
        VirtualLayer.touch(path)
      else
        PhysicalLayer.touch path
      end
    end
    def basename path
        PhysicalLayer.basename path
    end
    def dirname path
      File.dirname path
    end
    def realpath path
    if virtual? path
      VirtualLayer.realpath path
    else
        PhysicalLayer.realpath path
      end
    end
    def mv src, dest
      if virtual? src
        VirtualLayer.mv src, dest
      else
        PhysicalLayer.mv src, dest
      end
    end
  end
end

