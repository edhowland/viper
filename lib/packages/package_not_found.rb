# package_not_found.rb - exception Viper::Packages::PackageNotNotFound

# Viper namespace
module Viper
  # Packages namespace for loaded packages with package command.
  module Packages
    # ExceptionPackageNotFound raised if attempt to see if a package was loaded or did not exist in the package search space.
    class PackageNotFound < RuntimeError
      def initialize(name)
        super "Package #{name} could not be foud or was not loaded"
      end
    end
  end
end
