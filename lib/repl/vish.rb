# vish.rb - methods vish, vish! and vish_file

def vish_file path
  tmp_buff = ScratchBuffer.new
  load_rc path do |l|
      perform!(l) { tmp_buff }
  end
end
