# string_to_regex.rb - method string_to_regexstring - convert str to regex

# deslashify string
# returns string with optional bounding slashes removed
# Eg. deslashify '/hello/' # => 'hello'
# deslashify 'hello' # => 'hello
# deslashify '/thing' # => 'thing'
# This can be used as front end of Regexp.new which guarantees a true regex
# Use of Rake's pathmap method works better than constructed regex here
def deslashify string
  string.pathmap('%f')
end

def string_to_regex string
  Regexp.new(deslashify(string))
end
