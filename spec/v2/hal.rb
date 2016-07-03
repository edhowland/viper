# hal - class Hal - Hardware Abstraction Layer - dispatches to file or VFS

class Hal
  class << self
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
  end

end
