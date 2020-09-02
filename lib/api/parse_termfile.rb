# parse_termfile.rb - method parse_termfile - returns proper hash from JSON file

def parse_termfile path
  JSON.parse(File.read(path)).map {|e| [ (eval e[0]), e[1] ] }.to_h
end
