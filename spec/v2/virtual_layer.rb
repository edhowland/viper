# virtual_layer - class VirtualLayer - fromhal.rb - implements
# VFS functions

$in_virtual = false

class VirtualLayer
  class << self
    def split_path path
      parts = path.split('/')
      return parts[0..(-2)].join('/'), parts[-1]
    end
    def mkdir_p path
      @@root.mkdir_p path
    end
    def get_root
      @@root
    end
    def set_root root=VFSRoot.new
      @@root = root

    end
          def virtual? path
        @@root.contains? path
      end

    def [] path
      if path == '*'
      path = '.'
      @@root.list path
    elsif path == '**'
    gather = []
      node = @@root.wd
      until node.nil?
        prepend = node.pathname
        gather += node.list.keys.map {|e| "#{prepend}/#{e}" }
        node = node['nl']
      end
      gather
    else
      @@root.list path
    end
    end
    def directory? path
      @@root.directory? path
    end
    def relative? path
       path[0] != '/'
    end
    def chdir path
      @@root.cd path
    end
    def pwd
      @@root.pwd
    end
    def touch path
      @@root.creat path
    end
    def open path, mode
      node = @@root[path]
      facade = IOFactory.make node
      facade.open path, mode
    end
    def basename path
      @@root.basename path
    end
    def realpath path
      @@root.realpath path
    end
    def mv src, dest
      ddir, dfile = split_path(dest)
      sdir, sfile = split_path src
      d = @@root[ddir]
      s=@@root[src]
      s.parent = d
      s.name = dfile
      snode = @@root[sdir]
      snode.list.delete sfile
      d[dfile] = s
    end
    def rm path
      dir, file = split_path path
      node = @@root[dir]
      node.list.delete file
    end
  end
end
