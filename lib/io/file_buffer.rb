# file_buffer.rb - class FileBuffer

class FileBuffer < Buffer
  def initialize filename
    @fname = filename
    if File.exist? @fname
    super(File.read(@fname))
    else
    super ''
  end
  end

  attr_reader :fname
end
