# rangify - method rangify string - given a string: '1..2' returns Range object

def rangify(string)
  if string =~ /(\-?\d+)\.\.(\-?\d+)/
    Range.new Regexp.last_match(1).to_i, Regexp.last_match(2).to_i
  end
end
