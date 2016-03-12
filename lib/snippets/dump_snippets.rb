# dump_snippets.rb - method dump_snippets

def dump_snippets(cascade, path)
  snippets_file = Viper::Snippets::Searcher.locate(path, :ignore_missing => true)

  snippets = $snippet_cascades[cascade]
  raise SnippetCollectionNotFound if snippets.nil?
  content = JSON.generate(snippets)
  File.write(snippets_file, content)
end
