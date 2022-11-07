# l1.rb - attempt to replicate Bash behaviour for ls -1

class LsDir
  def initialize name, entries=[]
    @name = name
    @entries = entries
  end
  attr_reader :name, :entries
  def to_s
    @entries.join("\n")
  end
  def directory?
    true
  end
end



class LsFile
  def initialize name
    @name = name
  end
  attr_reader :name
  def to_s
    @name
  end
  def directory?
    false
  end
  def <=>(that)
    self.name <=> that.name
  end
end

def entry name
  Promise.new {|p|   Hal.exist?(name) ? p.resolve!(name) : p.reject!(name) }.then {|v| Hal.directory?(v) ? LsDir.new(v, Hal["#{v}/*"]) : LsFile.new(v) }
end

def l1 *entries
  if entries.empty?
    puts Hal['*']
    return
  end
  p = Promise.all_selected(entries.map {|e| entry(e) })
  p.run
  errs = p.aggregate_errors
  vals = p.aggregate_values

  errs.each {|e| $stderr.puts "ls: #{e}: No such file or directory" }

  files = vals.reject(&:directory?)
  dirs = vals.select(&:directory?)
  files.sort!
  puts dirs
  puts files
  puts dirs
end

def ent1(name)
    TracePromise.new {|p| puts "in running promise, Hal thinks that #{name} does or doesw not exist #{Hal.exist?(name)}";  Hal.exist?(name) ? p.resolve!(name) : p.reject!(name) }.then {|v| Hal.directory?(v) ? Hal["#{v}/*"].unshift("#{v}:") : v }
end

class TracePromise < Promise
  def run
    puts "before run: #{self.inspect}"
    res = super
    puts "after run: #{self.inspect}"
    res
  end
  def resolve!(obj)
    puts "resolving with #{obj}"
    super
  end
  def reject!(err)
    puts "rejecting with error: #{err}"
    super
  end
end



def expand_glob glob, prefix: '/v'
  vroot = VirtualLayer.get_root
  ents = vroot.list(prefix)  #VirtualLayer[prefix]
  ents.select {|e| File.fnmatch glob, e }
end



def to_path list
  list.join('/')
end


def ele_or_list l
  case l
  when Array
    if l.length == 1
      l.first
    else
      l
    end
  else
    l
  end
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
    filt_fn = ->(p) { p } # The identy lambda
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
