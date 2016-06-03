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
      def path_to_value path
        parts = path.split '/'
        parts.shift
        parts.reduce(@storage) { |i, j| i[j] }
      end
      
      def directory? path
        File.directory? path
      end
      def resolve_path path
      fail "#{path}: no such file or directory" unless File.exist?(path)
        self.directory?(path) ? Dir[path + '/*'] : path
      end
    end
  end
end
