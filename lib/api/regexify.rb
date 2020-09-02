# regexify - method regexify - given a possible glop string, returns regex
# a real simple implementation

def regexify(glob)
  glob.gsub! '.', '\\.'
  rx = glob.split '*'
  rs = '^' + rx[0]
  rs << '.*'
  rs << rx[-1] if rx.length == 2
  rs << '$'
  Regexp.new rs
end
