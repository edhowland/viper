# hal - class Hal - Hardware Abstraction Layer - dispatches to file or VFS



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
        VirtualLayer.mv(VirtualLayer.realpath(src), VirtualLayer.realpath(dest))
      else
        PhysicalLayer.mv src, dest
      end
    end
  end
end

