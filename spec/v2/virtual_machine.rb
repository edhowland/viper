# virtual_machine - class VirtualMachine - runs your stuff after parsing


require 'deep_clone'
class VirtualMachine
  def initialize  env:FrameStack.new(frames:[{in: $stdin, out: $stdout, err: $stderr}]), frames:FrameStack.new
    @fs= frames
    @fs[:exit_status] = true
    @fs.vm = self
    @fs[:pwd] = Dir.pwd
    @fs[:oldpwd] = Dir.pwd
    @ios = env
  end
  attr_accessor :fs, :ios

  def call block
    block.call env:@ios, frames:@fs
  end

  # implement a dir stack so cd -, pushd, popd work
  def _chdir path
    @fs.first[:oldpwd] = Dir.pwd
    Dir.chdir path
        @fs.first[:pwd] = Dir.pwd
        true
  end
  def cd *args, env:, frames:
    if !args.empty? && args[0] == '-'
      oldpwd = @fs[:oldpwd]
      self._chdir oldpwd
      self.pwd *args, env:env, frames:frames
    elsif args.empty?
      env[:err].puts "cd: Must supply one argument"
      false
    else
      self._chdir args[0]
    end
  end
  def pwd *args, env:, frames:
    env[:out].puts Dir.pwd
    true
  end
  def one_alias key
    expansion = @fs.aliases[key]
    "alias #{key.to_s}=\"#{expansion}\""
  end
   def alias *args, env:, frames:
     if args.empty?
       @fs.aliases.keys.each {|k| env[:out].puts one_alias(k)}
     else
       env[:out].puts one_alias(args[0])
     end
     true
  end
  def source *args, env:, frames:
    if args.empty?
      env[:err].puts 'source: missing argument'
      false
    else
      block = Visher.parse!(File.read(args[0]))
      self.call block
    end
  end
  def declare_variables env:
    @fs.each do |fr|
      fr.each_pair {|k, v| env[:out].puts "#{k}=#{v}" } 
    end
    true
  end
  def declare *args, env:, frames:
    if args[0] == '-f'
      @fs.functions.each_pair do |k, v |
        env[:out].puts "function #{k}#{v.to_s}"
       end
     else
       declare_variables
     end
    true
  end
  # get a deep copy using the MarshalltoUnMarshall method
  def _clone
    DeepClone.clone(self)
  end
end

