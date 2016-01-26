# snippet_cascade.rb - class SnippetCascade

# TODO: Class documentation
class SnippetCascade
  def initialize(snippets)
    @cascade = [snippets]
  end

  def [](key)
    @cascade.reduce(nil) {|a, e| a || e[key] }
  end

  def <<(arg_h)
    @cascade.unshift arg_h
  end
end
