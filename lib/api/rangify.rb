# rangify - method rangify string - given a string: '1..2' returns Range object

def rangify(string)
  parts = string.split('..')
  return nil unless parts.length == 2
  Range.new(*parts.map(&:to_i))
end
