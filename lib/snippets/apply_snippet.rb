# apply_snippet.rb - method apply_snippet

def apply_snippet buffer, snip, cascade
  snippet = cascade[snip]
  raise SnippetNotFound if snippet.nil?

  buffer.remember do |b|
    b.ins snippet
  end
  
  
end
