# handle_tab.rb - method handle_tab

def handle_tab buffer, cascade=:ruby
  snippets = $snippet_cascades[cascade]
  snip = buffer.line
  possible = snippets[snip]

  if !possible.nil?
    buffer.del(snip)
    apply_snippet cascade, snip, buffer
    say buffer.line
  elsif proceed_tab_pt(buffer) == true
    say buffer.line
  else
    buffer.ins '  '
    say 'tab'
  end
end
