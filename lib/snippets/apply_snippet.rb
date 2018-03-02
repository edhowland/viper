# apply_snippet.rb - method apply_snippet

# applies the snippet from the collection to the buffer
def apply_snippet(cascade, name, buffer)
  snippets = $snippet_cascades[cascade]
  raise SnippetCollectionNotFound if snippets.nil?
  snip = snippets[name]
  raise SnippetNotFound if snip.nil?

  bindings = make_bindings
  ksyms = convert_snip_to_keys(snip)
  suppress_audio do
    buffer.remember do |b|

      ksyms.each do |k|
        prc = bindings[k]
        prc.call(b)
      end
    end
  end

  proceed_tab_pt buffer
end