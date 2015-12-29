# playback.rb - method playback to inject snippet into buffer

def playback buffer, key
  snippet = $snippets[key]
  unless snippet.nil?
    snippet.each {|cmd| buffer.send cmd[0], *cmd[1] }
  end
end
