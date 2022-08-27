# frame_debug.rb: outputs all the contents of the entire FrameStack

def frame_debug(fs, from:)
  cnt = 0
  puts from
  fs.each do |fr|
    puts "Frame[#{cnt}"; cnt += 1
    fr.each_pair {|k, v| puts "#{k}=#{v}" }

  end
end