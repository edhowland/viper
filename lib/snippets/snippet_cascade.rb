# snippet_cascade.rb - class SnippetCascade

# TODO: Class documentation
class SnippetCascade
  def initialize snippets
    @cascade = [snippets]
  end

  def [](key)
    @cascade.reduce(nil) {|i, j| i || j[key] }
  end

  def <<(arg_h)
    @cascade.unshift arg_h
  end
end
