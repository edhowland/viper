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

$in_virtual = false
$vfs = {
  'v' => {'.' => 'root',  'file.rb' => 'contents', 'edh' => {'myfile.txt' => 'more stuff'}}
}
$wd = $vfs  # working dir is / 

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
      if path == '*'
        keys = $wd
      else
        keys = self.path_to_keys path
      end
      obj = self.dig($vfs, *keys)
      obj.keys
    end
    def directory? path
      access(path).instance_of? Hash
    end
    def relative? path
       path[0] != '/'
    end
    def chdir path
      if self.relative? path
        $wd << path
      else
      $wd = self.path_to_keys path
    end
    end
    def pwd
      '/' + $wd.join('/')
    end
  end

end


class Hal
  class << self
  # simulate Dir[]
  def [] path
    if $in_virtual || virtual?(path)
      VirtualLayer[path]
    else
      PhysicalLayer[path]
    end
  end
  def pwd
    if $in_virtual
      VirtualLayer.pwd
    else
      PhysicalLayer.pwd
    end
  end
      def relative? path
       path[0] != '/'
    end

  def chdir path
    if (self.relative?(path) && $in_virtual) || self.virtual?(path)
      $in_virtual = true
      VirtualLayer.chdir path
    else
      $in_virtual = false
      PhysicalLayer.chdir path
    end
  end
  # is this virtual or is it real
  def virtual? path
    keys = VirtualLayer.path_to_keys path
    !keys.nil? && keys.length > 0 && keys[0] == 'v'
  end
  # simulate File.open, directory?
  def open path, mode
    PhysicalLayer.open path, mode
  end
    def directory? path
      if virtual? path
        VirtualLayer.directory? path
      else
        PhysicalLayer.directory? path
      end
    end
  end
end

