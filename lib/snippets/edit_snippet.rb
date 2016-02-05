# edit_snippet.rb - method edit_snippet

def edit_snippet(cascade, name, buffer)
  snippets = $snippet_cascades[cascade]
  raise SnippetCollectionNotFound if snippets.nil?
  snip = snippets[name]
  raise SnippetNotFound if snip.nil?
  
  buffer.clear
  buffer.ins snip
end

