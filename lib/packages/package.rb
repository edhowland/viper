# package.rb - class Viper::Package
# TODO module documentation
module Viper
  # TODO: class documentation
  class Package
    def initialize name
      @name = name
      @path = ''
    end

    attr_reader :name, :path

  end
end

