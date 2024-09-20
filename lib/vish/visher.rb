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
    # put in  any found docs
    bk.statement_list.select {|s|FunctionDeclaration ==  s.class }.each {|f| f.doc = "#{f.name} #{v.docstrings[f]}" } 

    bk
    end
  end
end
