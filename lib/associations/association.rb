# association.rb - class Association - maps pathspec parts to closet association

# Associations map to a given symbol according to the most specific match
class Association
    def initialize 
    @ext_regexs = {}
    @ext_lits = {}
    @file_regexs = {}
    @file_lits = {}
    @dir_regexs = {}
    @dir_lits = {}
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

    def match_ext_lit string
    @ext_lits[string]
  end

    def match_ext string
    (match_ext_lit(string) || match_ext_regex(string))
  end

    def file_regex regex, sym
    @file_regexs[regex] = sym
  end

  def file_lit lit, sym
    @file_lits[lit] = sym
  end

  def match_file_regex string
    found_a = @file_regexs.keys.map {|r| r.match(string) }.reject {|m| m.nil? }.sort {|a,b| b.to_s.length <=> a.to_s.length }
    unless found_a.empty?
      regex = found_a.first.regexp
      return @file_regexs[regex]
    end
    return nil
  end

  def match_file_lit string
    @file_lits[string]
  end

  def match_file string
    (match_file_lit(string) || match_file_regex(string))
  end





end


