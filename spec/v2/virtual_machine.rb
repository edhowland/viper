# virtual_machine - class VirtualMachine - runs your stuff after parsing


require 'deep_clone'

class VirtualMachine
  class BreakCalled < RuntimeError; end
  def initialize  env:FrameStack.new(frames:[{in: $stdin, out: $stdout, err: $stderr}]), frames:FrameStack.new
    @fs= frames
    @fs[:exit_status] = true
    @fs.vm = self
    @fs[:pwd] = Hal.pwd
    @fs[:oldpwd] = Hal.pwd
    @ios = env
    @seen = [] # seen aliases during dealias
  end
  attr_accessor :fs, :ios, :seen

  def call block
    block.call env:@ios, frames:@fs
  end

  # implement a dir stack so cd -, pushd, popd work
  def _chdir path
    @fs.first[:oldpwd] = Hal.pwd
    Hal.chdir path
    @fs.first[:pwd] = Hal.pwd
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
    env[:out].puts Hal.pwd
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
  def unalias *args, env:, frames:
    @fs.aliases.delete args[0]
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
  def declare_function fn, funct, env:
    env[:out].puts "function #{fn}#{funct.to_s}"
    true
  end
  def declare_functions env:
    @fs.functions.each_pair { |k, v| declare_function k, v, env:env }
    true
  end
  def declare_single_function fn, env:
    return false if @fs.functions[fn].nil?
    declare_function fn, @fs.functions[fn], env:env
  end
  def declare *args, env:, frames:
    if args.length ==1 && args[0] == '-f'
      declare_functions env:env
    elsif args.length > 1 && args[0] == '-f'
      declare_single_function args[1], env:env
    else
       declare_variables env:env
     end
  end
  def break *args, env:, frames:
    raise VirtualMachine::BreakCalled.new
  end
    alias_method :exit, :break

  def eval *args, env:, frames:
    block = Visher.parse! args[0] 
    block.call env:env, frames:frames
    @fs.merge
  end
  # create a deep copy of me
  def _clone
    DeepClone.clone(self)
  end
end

