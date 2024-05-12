# Redefinition of Hardware Abstraction Layer

require_relative 'lib/viper'

class Hal2
  class << self
    def method_missing meth, *args
      PhysicalLayer.send meth, *args
    end
    end

end