# virtual_layer - class VirtualLayer - fromhal.rb - implements
# VFS functions
# rubocop:disable Style/AccessorMethodName
# rubocop:disable Style/ClassVars

$in_virtual = false

class VirtualLayer
  class << self
    def split_path(path)
      parts = path.split('/')
      [parts[0..-2].join('/'), parts[-1]]
    end

    def mkdir_p(path)
      @@root.mkdir_p path
    end

    def get_root
      @@root
    end

    def set_root(root = VFSRoot.new)
      @@root = root
    end

    def virtual?(path)
      @@root.contains?(path) || (Hal.relative?(path) && @@root.contains?(Hal.pwd))
    end

    def [](path)
      if path == '*'
        path = '.'
        result = @@root.list(path).sort
        result
      elsif path == '**'
        gather = []
        node = @@root.wd
        until node.nil?
          prepend = node.pathname
          gather += node.list.keys.map { |e| "#{prepend}/#{e}" }
          node = node['nl']
        end
        gather
      elsif path =~ /\*/
        @@root.list('.').grep(regexify(path)).sort
      else
        @@root.list(path)
      end
    end

    def directory?(path)
      @@root.directory? path
    end

    def relative?(path)
      path[0] != '/'
    end

    def chdir(path)
      @@root.cd path
    end

    def pwd
      @@root.pwd
    end

    def touch(path)
      node = @@root[path]
      @@root.creat path if node.nil?
    end

    def open(path, mode)
      node = @@root[path]
      raise Errno::ENOENT, path if node.nil? && mode == 'r'
      facade = IOFactory.make node
      facade.open path, mode
    end

    def basename(path)
      @@root.basename path
    end

    def realpath(path)
      @@root.realpath path
    end

    def cp(src, dest)
      src = realpath(src)
      sfile = src.pathmap('%f')
      snode = @@root[src]
      raise Errno::ENOENT, src if snode.nil?
      dest = realpath(dest)
      raise ArgumentError, "same file: #{src}" if src == dest
      ddir, dfile = split_path dest
      if exist? dest
        if directory? dest
          # copy to directory node THIS WORKS
          dnode = @@root[dest]
          dnode[sfile] = cloner(snode)
        else
          # some other object, overwrite.
          # get directory node
          dnode = @@root[ddir]
          # raise No such Directory if dnode.nil?
          # add node of sfile .deep_clone her
          dnode[dfile] = cloner(snode)
        end
      else
        # object or directory does not exist
        # get node of ddir
        # add node of sfile .deep_clone here
        dnode = @@root[ddir]
        that = cloner(snode)
        that.name = dfile if snode.is_a? VFSNode
        dnode[dfile] = that
      end
    end

    def mv(src, dest)
      cp src, dest
      rm src
    end

    def rm(path)
      dir, file = split_path path
      node = @@root[dir]
      node.list.delete file
    end

    def exist?(path)
      !@@root[path].nil?
    end
  end
end
