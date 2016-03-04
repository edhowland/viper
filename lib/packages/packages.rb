# packages.rb - module Viper::Packages

# Viper namespace. Root of Viper editor namespace.
module Viper
  # Packages namespace. Root of all external Viper editor packages
  module Packages
    PACKAGE_PATH = []
    @store = []

    def self.init
      pkg_root = Viper::Local::ROOT.pathmap('%p/.viper/packages/')
      PACKAGE_PATH.unshift pkg_root
    end

    def self.[](ndx)
      @store[ndx]
    end

    def self.[]=(ndx, value)
      @store[ndx] = value
    end

    def self.<<(value)
      @store << value
    end

    def self.store
      @store
    end



  end
end

