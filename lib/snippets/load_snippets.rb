# load_snippets.rb - method load_snippets

def load_snippets(name = :default, path = 'default')
  snippets_file = Viper::Snippets::Searcher.locate(path)
  content = File.read(snippets_file)
  $snippet_cascades[name] = JSON.parse(content)
end
