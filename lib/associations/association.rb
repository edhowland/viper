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

  def ext pattern, sym
    regex = %r{/(.*)/}
    m = regex.match(pattern)
    unless m.nil?
      s_regex = Regexp.new(m[1])
      ext_regex s_regex, sym
    else
      ext_lit pattern, sym
    end
  end

  def match_regex regexs, string
    found_a = regexs.keys.map {|r| r.match(string) }.reject {|m| m.nil? }.sort {|a,b| b.to_s.length <=> a.to_s.length }
    unless found_a.empty?
      regex = found_a.first.regexp
      return regexs[regex]
    end
    return nil    
  end

  def match_ext_regex string
    match_regex @ext_regexs, string
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

  def file pattern, sym
    regex = %r{/(.*)/}
    m = regex.match(pattern)
    unless m.nil?
      s_regex = Regexp.new(m[1])
      file_regex s_regex, sym
    else
      file_lit pattern, sym
    end
  end

  def match_file_regex string
    match_regex @file_regexs, string
  end

  def match_file_lit string
    @file_lits[string]
  end

  def match_file string
    (match_file_lit(string) || match_file_regex(string))
  end

  def dir_regex regex, sym
    @dir_regexs[regex] = sym
  end

  def dir_lit lit, sym
    @dir_lits[lit] = sym
  end

  def dir pattern, sym
    regex = %r{/(.*)/}
    m = regex.match(pattern)
    unless m.nil?
      s_regex = Regexp.new(m[1])
      dir_regex s_regex, sym
    else
      dir_lit pattern, sym
    end
  end

  def match_dir_regex string
    match_regex @dir_regexs, string
  end

  def match_dir_lit string
    @dir_lits[string]
  end

  def match_dir string
    (match_dir_lit(string) || match_dir_regex(string))
  end

  def associate fname
    dir = fname.pathmap('%d')
    file = fname.pathmap('%f')
    ext = fname.pathmap('%x')

    (match_file(file) || match_ext(ext) || match_dir(dir) || :default)
  end
end
