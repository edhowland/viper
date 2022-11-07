# virtual_layer - class VirtualLayer - fromhal.rb - implements
# VFS functions
# rubocop:disable Style/AccessorMethodName
# rubocop:disable Style/ClassVars
# rubocop:disable Metrics/ClassLength
# rubocop:disable Style/GlobalVars
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/PerceivedComplexity

# TODO: Should fugure more reactive way to do this
$in_virtual = false

class VirtualLayer
  class << self
    # imports from l1.rb
def expand_glob glob, prefix: '/v'
  vroot = VirtualLayer.get_root
  ents = vroot.list(prefix)  #VirtualLayer[prefix]
  ents.select {|e| File.fnmatch glob, e }
end

    def walk_globs list, acc: [], prefix: ''
  if list.empty?
    acc
  else
    start, *rest  = list
    exgs = expand_glob(start, prefix: prefix) # ele_or_list()
#    if exgs.instance_of?(Array)
      exgs.map {|x| walk_globs(rest, acc: (acc + [x]), prefix: prefix+"/#{x}") }
#    else
#      walk_globs(rest, acc: (acc << start), prefix: (prefix + "/#{start}"))
#    end
  end
end

# should be call expand_all_globs_in_path(path). E.g. expand_all '/v/tmp/a*/*.txt'
# TODO: Make sure this gets realpath
def expand_all path
  real_path = VirtualLayer.realpath(path)
  elems = real_path.split('/'); elems.shift # throw away the first element which is empty for a FQ pathname
  if path[-1] == '/'
    filt_fn = ->(p) { VirtualLayer.directory?(p) }
  else
    filt_fn = ->(p) { p }
  end
  result = rejoin(walk_globs(elems)).flatten.select(&filt_fn).sort

  if path[0] == '/'
    result
  else
    cwd = VirtualLayer.pwd
    result.map {|p| p[(cwd.length+1)..] }
  end
end


def rejoin(list, vtop: 'v')
  if list.first == vtop
    "/" + list.join('/')
  else
    list.map {|l| rejoin(l, vtop: vtop) }
  end
end

        # end of l1.rb imports
    # imported from l1.rb: supporting methods for globbing
    
    # end of l1.rb import
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
      @@root.contains?(path) ||
        (Hal.relative?(path) && @@root.contains?(Hal.pwd))
    end

    def [](path)
      expand_all path
=begin
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
=end
    end

    def directory?(path)
      @@root.directory? path
    end

    def relative?(path)
      path[0] != '/'
    end

    def chdir(path)
      raise  Errno::ENOENT    unless self.exist?(path)
      raise Errno::ENOTDIR unless self.directory?(path)
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
      path = realpath(path)
      raise Errno::ENOENT, path unless exist?(path)

      dir, file = split_path path
      node = @@root[dir]
      node.list.delete file
    end

    def exist?(path)
      !@@root[path].nil?
    end
  end
end
