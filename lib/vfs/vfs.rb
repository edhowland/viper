# vfs.rb - module Viper::VFS - implement Viper's virtual file system
module Viper
  module VFS
    @storage = {}
    def self.[](key)
      @storage[key]
    end

    def self.[]=(key, value)
      @storage[key] = value
    end
    class << self
      # splits path on /, reverses returns the first element of the tail of that
      def path_to_parent path
        parts = path.split('/')
        head, *tail = parts.reverse
        self.path_to_value tail.reverse.join('/')
      end

      def path_to_value path
        parts = path.split '/'
        parts.shift
        parts.reduce(@storage) { |i, j| i[j] }
      end
      def mknode path
        parent = self.path_to_parent path
        parts = path.split('/')
        item = parts[-1]
        ppath = parts[1]
        klass = @storage["viper"]["classes"][ppath]
        parent[item] = klass.new
      end
      
      def directory? path
        File.directory? path
      end
      def virtual? path
        parts = path.split '/'
        parts.shift
        @storage[parts[0]] != nil
      end
      def resolve_path path='.'
      if self.virtual? path
        item = self.path_to_value path
        if item.instance_of? Hash
          item.keys
        else
          item.inspect
        end
      else
        fail "#{path}: no such file or directory" unless File.exist?(path)
        self.directory?(path) ? Dir[path + '/*'] : path
      end
      end
      def open_for_read path
        if self.virtual? path
          value = self.path_to_value path
          unless value.class.method_defined? :read
            BlanketFacade.new(value)
          else
            value
          end
        else
          File.open(path)
        end
      end
      def open_for_write path
        if self.virtual? path
          value = self.path_to_value path
                    unless value.class.method_defined? :read
            BlanketFacade.new(value)
          else
            value
          end
        else
          File.open(path, 'w')
        end
      end
    end
  end
end
