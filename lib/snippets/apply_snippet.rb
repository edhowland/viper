# apply_snippet.rb - method apply_snippet

def apply_snippet cascade, name, buffer
  snippets = $snippet_cascades[cascade]
  raise SnippetCollectionNotFound if snippets.nil?
  snip = snippets[name]
  raise SnippetNotFound if snip.nil?

  buffer.remember do |b|
    b.ins snip
  end

  proceed_tab_pt buffer
end
