# apply_snippet.rb - method apply_snippet

def apply_snippet cascade, name, buffer
  snippets = $snippet_cascades[cascade]
  raise SnippetCollectionNotFound if snippets.nil?
  snip = snippets[name]
  raise SnippetNotFound if snip.nil?

  buffer.remember do |b|
    b.ins snip
  end

  pos = buffer.position
  buffer.srch_fwd('^.')
  if buffer.at == '^'
    buffer.del_at('^.') 
  else
    buffer.goto_position pos
  end
end
