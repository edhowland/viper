# load_snippets.rb - method load_snippets

def load_snippets
  snippets_file = "/home/vagrant/src/viper/config/snippets.json" # FIXME
  content = File.read(snippets_file)
  $snippets = JSON.parse(content)
end
