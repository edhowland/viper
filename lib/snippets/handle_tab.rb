# handle_tab.rb - method handle_tab

def handle_tab(buffer)
  association = buffer.association
  snippets = $snippet_cascades[association]
  snip = buffer.word_back
  possible = snippets[snip]

  if !possible.nil?
    buffer.del(snip)
    apply_snippet association, snip, buffer
    say buffer.line
  elsif proceed_tab_pt(buffer) == true
    say buffer.at
  else
    indent = Viper::Variables[:indent] || 2
    buffer.ins(' ' * indent)
    say 'tab'
  end
end
