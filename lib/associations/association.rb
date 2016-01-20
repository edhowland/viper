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

    def match_ext_regex string
    found_a = @ext_regexs.keys.map {|r| r.match(string) }.reject {|m| m.nil? }.sort {|a,b| b.to_s.length <=> a.to_s.length }
    unless found_a.empty?
      regex = found_a.first.regexp
      return @ext_regexs[regex]
    end
    return nil
  end

end

