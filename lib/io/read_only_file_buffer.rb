# read_only_file_buffer.rb - class ReadOnlyFileBuffer

# TODO: Class documentation
class ReadOnlyFileBuffer < FileBuffer
  include NonWritable

  def save
    say BELL
  end
end
