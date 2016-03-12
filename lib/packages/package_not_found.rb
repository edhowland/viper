# package_not_found.rb - exception Viper::Packages::PackageNotNotFound

module Viper
  module Packages
    class PackageNotFound < RuntimeError
      def initialize(name)
        super "Package #{name} could not be foud or was not loaded"
      end
    end
  end
end
