# hal - class Hal - Hardware Abstraction Layer - dispatches to file or VFS

class PhysicalLayer
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


$vfs = {
  'v' => {'.' => 'root',  'file.rb' => 'contents', 'edh' => {'myfile.txt' => 'more stuff'}}
}
 
class VirtualLayer
  class << self
    def dig h, *keys
      keys.reduce(h) {|i, j| i[j] }
    end
    def path_to_keys path
      path.split('/')[1..-1]
    end
    def access path
      self.dig($vfs, *self.path_to_keys(path))
    end
    def [] path
      []
    end
  end

end


class Hal
  class << self
  # simulate Dir[]
  def [] path
    PhysicalLayer[path]
  end
  def pwd
    PhysicalLayer.pwd
  end
  def chdir path
    PhysicalLayer.chdir path
  end
  # simulate File.open, directory?
  def open path, mode
    PhysicalLayer.open path, mode
  end
    def directory? path
      PhysicalLayer.directory? path
    end
  end

end

