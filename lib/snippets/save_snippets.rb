# save_snippets.rb - method save_snippets

def save_snippets
  snippets_file = File.dirname(File.expand_path(__FILE__)) + '/../../config/snippets.json'
  content = JSON.generate($snippets)
  File.write(snippets_file, content)
end
