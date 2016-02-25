# ifind.rb - method ifind - interactive find

def ifind(buffer)
  say 'Search forward'
  pattern = SearchLineBuffer.new.readline
  find buffer, pattern
end

def irev_find(buffer)
  say 'Search back'
  pattern = SearchLineBuffer.new.readline
  rev_find buffer, pattern
end
