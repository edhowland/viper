# association.rb - class Association - maps pathspec parts to closet association

# Associations map to a given symbol according to the most specific match
class Association
    def initialize 
    @ext_regexs = {}
    @ext_lits = {}
  end

    def ext_regex regex, sym
    @ext_regexs[regex] = sym
  end

    def ext_lit lit, sym
    @ext_lits[lit] = sym
  end



end

