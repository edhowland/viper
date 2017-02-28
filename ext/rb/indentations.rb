# indentations.rb - method indententations array - given array  of strings
# given an array of strings, returns  array of indentations

def indentations strings
  strings.map do |e|
    m = e.match /^( *)/
    m[1].nil? ? 0 : m[1].length
  end
end

# indented - given a string, return its indentation
def indented string
  m = string.match /^( *)/
  m[1].nil? ? 0 : m[1].length
end