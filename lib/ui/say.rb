# say.rb - method say

def say string
  print string unless $audio_suppressed
end
