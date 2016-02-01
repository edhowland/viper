# session - module Viper::Session
module Viper::Session
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
