# hal - class Hal - Hardware Abstraction Layer - dispatches to file or VFS
# TODO: Should figure a better way to not use global vars
# rubocop:disable Style/GlobalVars

class Hal
  class << self

      # inject either a real file system layer or a mocked one
      # the vm will initially inject it when the mount system is called.
      # because any other call must go thru Hal and both the filesystem
      # and the vfs must be setup first

      @@p_layer = nil
      def set_filesystem(klass)
        @@p_layer = klass
      end
      def get_filesystem
        @@p_layer
      end
    # simulate Dir[]
    def [](path)
      _dispatch(path) {|k| k[path] }
    end

    def pwd
      _dispatch {|k| k.pwd }
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
        @@p_layer.chdir path
      end
    end

    # is this virtual or is it real
    def virtual?(path)
      VirtualLayer.virtual? path
    end

    # simulate File.open, directory?
    def open(path, mode)
      _dispatch(path) {|k| k.open(path, mode) }
    end

    def touch(path)
      _dispatch(path) {|k| k.touch(path) }
    end

    # No need to dispatch to either of the other 2 layers here.
        # can just do it ourself
    def basename(path)
      File.basename path
    end

    def dirname(path)
      File.dirname path
    end

    # checks which layer is present in vogue and dispatches the block with that klass as arg to block
    def _dispatch(path='', &blk)
      raise RuntimeError.new("Invallid Hal configuration. No @@p_layer set. Did you mean to call Hal.set_filesystem() earlier?") if @@p_layer.nil?
      if $in_virtual || (!path.empty? && virtual?(path))
        yield VirtualLayer
      else
        yield @@p_layer
      end
    end
    # returns the actual klass to be used for this state


    def respond_to_missing?(name, private = false)
      _dispatch {|k| k.respond_to? name }
    end

    def method_missing(name, *args)
      if _dispatch {|k| k.respond_to? name }
    raise ::ArgumentError.new() if args[0].nil?

        if args.length.zero?
          klass = _dispatch {|k| k }
        else
          klass = _dispatch(args[0]) {|k| k }

        end
        raise ::ArgumentError.new("Wrong number of args for method: #{name} on class: #{klass.class.name}; Expected #{klass.method(name).arity} but got #{args.length} for parameters: #{args}") if klass._arity(name) < args.length
        klass.send name, *args
      else
        super
      end
    end
  end
end
