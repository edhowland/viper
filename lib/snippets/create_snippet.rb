# create_snippet.rb - method create_snippet

def create_snippet(cascade, name, buffer)
  $snippet_cascades[cascade] = {} if $snippet_cascades[cascade].nil?
  $snippet_cascades[cascade][name] = buffer.to_s
end
