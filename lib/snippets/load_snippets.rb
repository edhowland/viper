# load_snippets.rb - method load_snippets

def load_snippets
  snippets_file = File.dirname(File.expand_path(__FILE__)) + '/../../config/snippets.json'
  content = File.read(snippets_file)
  $snippets = JSON.parse(content)
end
