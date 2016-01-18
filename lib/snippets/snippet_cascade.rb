# snippet_cascade.rb - class SnippetCascade

class SnippetCascade
  def initialize snippets
    @cascade = [snippets]
  end

  def [](key)
    @cascade.reduce(nil) {|i, j| i || j[key] }
  end

end
