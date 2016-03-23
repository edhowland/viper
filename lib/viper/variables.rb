# variables.rb - module Viper::Variables

# TODO module documentation
module Viper
  # TODO module documentation
module Variables

    @storage = {} # stores various misc. variables, undefined

    def self.clear
      @storage = {}
    end

    def self.cast(string)
      begin
        Integer(string)
      rescue
        begin
          Float(string)
        rescue
          string
        end
      end
end


    def self.[](key)
      @storage[key.to_sym]
    end

    def self.[]=(key, value)
      @storage[key.to_sym] = value
    end

    def self.set(key, value)
  @storage[key.to_sym] = cast(value)
end

    def self.storage
      @storage
    end

end
end

