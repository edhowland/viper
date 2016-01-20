# handle_tab.rb - method handle_tab

def handle_tab buffer
  cascade = $snippet_associations[:default]
  snippets = $snippet_cascades[cascade]
  snip = buffer.word_back
  possible = snippets[snip]

  if !possible.nil?
    buffer.del(snip)
    apply_snippet cascade, snip, buffer
    say buffer.line
  elsif proceed_tab_pt(buffer) == true
    say buffer.at
  else
    buffer.ins '  '
    say 'tab'
  end
end
