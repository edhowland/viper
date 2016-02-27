# package.rb - class Viper::Package
# TODO module documentation
module Viper
  # TODO: class documentation
  class Package
    def initialize name
      @name = name
      pkg_locs = Viper::Packages::PACKAGE_PATH.map {|e| e.pathmap("%p#{@name}/")}.select {|e| File.exist?(e) }
      # raise Viper::Packages::PackageNotFound if pkg_locs.empty?
      @path = pkg_locs.first
    end

    attr_reader :name, :path

  end
end

