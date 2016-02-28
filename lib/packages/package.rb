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

    def viper_path fname
      "#{@path}#{fname}.viper"
    end

    def lib_path
      "#{@path}lib/"
    end

    def load
      # raise Viper::Packages::LoadFileNotFound unless File.exist? viper_path('load')
      tmp_buffer = Buffer.new ''
      load_rc(viper_path('load')) do |line|
        perform!(line) { tmp_buffer }
      end
    end
  end
end
