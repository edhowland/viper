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
  end
end
