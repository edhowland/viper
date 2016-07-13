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
      def virtual? path
        @@root.contains? path
      end
    end


    def [] path
      if path == '*'
      path = '.'
    end
    @@root.list path
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
    def open path, mode
      # start with StringIO
      # work up to different openable objects
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
  end
end

