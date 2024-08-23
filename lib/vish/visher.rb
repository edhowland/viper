# visher - class Visher - wraps Vish parser with parse! method

#require_relative 'vish.kpeg'

class Visher
  class << self
    def check!(statement)
      v = VishParser.new statement
    v.setup
      v.p_root().class == Block
    end

    def parse!(statement)
      v = VishParser.new statement
    v.setup

    v.p_root
    end
  end
end
