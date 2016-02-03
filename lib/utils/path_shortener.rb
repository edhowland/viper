# path_shortener.rb - ..

def path_shortener(path)
  dir = path.pathmap '%d'
  dir_a = dir.split '/'
  short = dir_a[-3..-1].join '/'
  path.pathmap(".../#{short}/%f")
end
