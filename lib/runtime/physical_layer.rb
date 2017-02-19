# physical_layer - class PhysicalLayer - from hal.rb - implements 
# physical file system functions

class PhysicalLayer
  class << self
  def mkdir_p path
    FileUtils.mkdir_p path
  end
  # simulate Dir[]
  def [] path
    Dir[path]
  end
  def pwd
    Dir.pwd
  end
  def chdir path
    Dir.chdir path
  end
  # simulate File.open, directory?
  def open path, mode
    File.open path, mode
  end
    def directory? path
      File.directory? path
    end
    def touch path
      FileUtils.touch(path)
    end
    def basename path
      File.basename path
    end
    def realpath path
      File.expand_path path
    end
    def mv src, dest
      File.rename src, dest
    end
    def rm path
      File.unlink path
    end
    def exist? path
      File.exist? path
    end
  end
end
