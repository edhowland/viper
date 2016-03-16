# package.rb - class Viper::Package
# Viper namespace
module Viper
  # class Package instance of a loaded package. Probably loaded with the package command.
  class Package
    def initialize(name)
      @name = name
      pkg_locs = Viper::Packages::PACKAGE_PATH.map { |e| e.pathmap("%p#{@name}/") }.select { |e| File.exist?(e) }
      # raise Viper::Packages::PackageNotFound if pkg_locs.empty?
      @path = pkg_locs.first
      Viper::Packages << self # make ourself avaiable for reference
    end

    attr_reader :name, :path

    def viper_path(fname)
      "#{@path}#{fname}.viper"
    end

    def lib_path
      "#{@path}lib/"
    end

    def load
      # raise Viper::Packages::LoadFileNotFound unless File.exist? viper_path('load')
      $LOAD_PATH.push lib_path
      tmp_buffer = Buffer.new ''
      load_rc(viper_path('load')) do |line|
        perform!(line) { tmp_buffer }
      end
    end

    def const_string
      canon = canonical(@name)
      'Viper::Packages::' + canon
    end

    def version
      Viper::Packages.const_get(const_string + '::VERSION')
    end
  end
end
