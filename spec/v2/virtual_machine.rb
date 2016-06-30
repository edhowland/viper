# virtual_machine - class VirtualMachine - runs your stuff after parsing

class VirtualMachine
  def initialize  env:FrameStack.new(frames:[{in: $stdin, out: $stdout, err: $stderr}]), frames:FrameStack.new
    @fs= frames
    @fs[:exit_status] = true
    @fs.vm = self
    @fs[:pwd] = Dir.pwd
    @fs[:oldpwd] = ''
    @ios = env
  end
  attr_accessor :fs, :ios

  def call block
    block.call env:@ios, frames:@fs
  end

  # implement a dir stack so cd -, pushd, popd work
  def cd *args, env:, frames:
#binding.pry
    @fs.first[:oldpwd] = Dir.pwd
    Dir.chdir args[0]
        @fs.first[:pwd] = Dir.pwd
        true
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
end

