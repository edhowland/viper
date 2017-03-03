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

    def chdir path, current_pwd=self.pwd
      in_virtual = virtual?(current_pwd)
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

    # simulate File.open, directory?
    def open path, mode
      if virtual? path || $in_virtual
        VirtualLayer.open(path, mode)
      else
        PhysicalLayer.open path, mode
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

    def _dispatch arg
      if virtual? arg
        VirtualLayer
      else
        PhysicalLayer
      end
    end
    def method_missing name, *args
      klass = _dispatch args[0]
      klass.send name, *args
    end
  end
end
