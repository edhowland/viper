# save_snippets.rb - method save_snippets

def save_snippets
  snippets_file = "/home/vagrant/src/viper/config/snippets.json" # FIXME
  content = JSON.generate($snippets)
  File.write(snippets_file, content)
end
