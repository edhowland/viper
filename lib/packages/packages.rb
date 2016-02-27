# packages.rb - module Viper::Packages

# Viper namespace. Root of Viper editor namespace.
module Viper
  # Packages namespace. Root of all external Viper editor packages
module Packages
      PACKAGE_PATH = []
    def self.init
      pkg_root = Viper::Local::ROOT.pathmap('%p/.viper/packages/')
      PACKAGE_PATH.unshift pkg_root
    end
  end
end

