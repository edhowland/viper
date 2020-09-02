# hal - class Hal - Hardware Abstraction Layer - dispatches to file or VFS
# TODO: Should figure a better way to not use global vars
# rubocop:disable Style/GlobalVars

class Hal
  class << self
    # simulate Dir[]
    def [](path)
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

    def relative?(path)
      path[0] != '/'
    end

    def chdir(path, current_pwd = pwd)
      in_virtual = virtual?(current_pwd)
      if (relative?(path) && in_virtual) || virtual?(path)
        $in_virtual = true
        VirtualLayer.chdir path
      else
        $in_virtual = false
        PhysicalLayer.chdir path
      end
    end

    # is this virtual or is it real
    def virtual?(path)
      VirtualLayer.virtual? path
    end

    # simulate File.open, directory?
    def open(path, mode)
      if virtual?(path) || $in_virtual
        VirtualLayer.open(path, mode)
      else
        PhysicalLayer.open path, mode
      end
    end

    def touch(path)
      if $in_virtual || virtual?(path)
        VirtualLayer.touch(path)
      else
        PhysicalLayer.touch path
      end
    end

    def basename(path)
      PhysicalLayer.basename path
    end

    def dirname(path)
      File.dirname path
    end

    def _dispatch(arg, within = false)
      if virtual?(arg) || within
        VirtualLayer
      else
        PhysicalLayer
      end
    end

    def respond_to_missing?(name, private = false)
      PhysicalLayer.respond_to?(name) && VirtualLayer.respond_to?(name)
    end

    def method_missing(name, *args)
      if PhysicalLayer.respond_to?(name) && VirtualLayer.respond_to?(name)
        klass = _dispatch args[0] # , $in_virtual
        klass.send name, *args
      else
        super
      end
    end
  end
end
