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
#binding.pry
        parts.reduce(@storage) { |i, j| i[j] }
      end
    end
  end
end
