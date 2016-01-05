# read_only_file_buffer.rb - class ReadOnlyFileBuffer

class ReadOnlyFileBuffer < FileBuffer
  include NonWritable

  def save
    say BELL
  end
end
