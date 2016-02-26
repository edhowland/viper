# session - module Viper::Session

# Viper root namespace for Viper editor
module Viper
  # Session Storage for Viper editor session. Maintains a Hash interface to various values.
  module Session
    @storage = {} # stores various misc. variables, undefined

    def self.clear
      @storage = {}
    end

    def self.[](key)
      @storage[key]
    end

    def self.[]=(key, value)
      @storage[key] = value
    end
  end
end
