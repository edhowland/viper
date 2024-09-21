# visher - class Visher - wraps Vish parser with parse! method


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

    bk  = v.p_root
#binding.pry
    # put in  any found docs
    bk.statement_list.select {|s| FunctionDeclaration ==  s.class }.each {|f| f.doc = "#{f.name} #{v.docstrings[f.name]}" } 

    bk
    end
  end
end
