# rangify - method rangify string - given a string: '1..2' returns Range object

def rangify string
  if string =~ /(\-?\d+)\.\.(\-?\d+)/
    Range.new $1.to_i, $2.to_i
  else
    nil
  end
end