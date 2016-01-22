# load_snippets.rb - method load_snippets

def load_snippets name=:default, path='default'
  snippets_file = File.dirname(File.expand_path(__FILE__)) + '/../../config/' + path + '.json'
  content = File.read(snippets_file)
  $snippet_cascades[name] = JSON.parse(content)
end
