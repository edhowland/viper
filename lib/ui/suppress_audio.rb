# suppress_audio.rb - method suppress_audio within the block
def suppress_audio &_blk
  $audio_suppressed = true
  yield if block_given?
  $audio_suppressed = false
end
