# visher - class Visher - wraps Vish parser with parse! method
require_relative 'vish.kpeg'

class Visher
  class << self
    def check! statement
      v = Vish.new statement
      v.parse
    end

    def parse! statement
      v = Vish.new statement
      raise VishSyntaxError unless v.parse
      v.result
    end
  end
end
