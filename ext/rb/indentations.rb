# indentations.rb - method indententations array - given array  of strings
# returns  array of indentations

def indentations strings
  strings.map do |e|
    m = e.match /^( *)/
    m[1].nil? ? 0 : m[1].length
  end
end