# optparse_from.rb : method optparse_from(flags) => OptionParser

def on_args(ch)
  if ch.length == 2 && ch[1] == ':'
    ["-#{ch[0]} value", String]
  else
  ["-#{ch[0]}"]
  end
end
def optparse_from(csv)
  p = OptionParser.new
    csv.split(',').each do |f|
      oav = on_args(f)
      p.on(*oav)
  end
  return p
end
