
# convert_cmd.rb - method convert_cmd - converts :cmd_xxxx to :xxxx

def convert_cmd sym
  s = sym.to_s
  (s[4..(-1)]).to_sym
end

