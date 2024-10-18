# virtual_machine - class VirtualMachine - runs your stuff after parsing
# rubocop:disable Metrics/ClassLength

class VirtualMachine
  class BreakCalled < RuntimeError; end
  class ExitCalled < RuntimeError
    def initialize(code = 0)
      @code = code
    end
    attr_reader :code
  end

  class ReturnCalled < RuntimeError
    def initialize(return_code)
      @return_code = return_code
    end
    attr_reader :return_code
  
  end
  class IOError < RuntimeError
  end

  def _init
    #
    @fs[:__vm] = self
    @fs[:exit_status] = true
    @fs.vm = self
    @fs[:pwd] = Hal.pwd
    @fs[:pw0] = ->() { @cdbuf[0] }
    @fs[:pw1] = ->() { @cdbuf[1] }
    @fs[:vhome] = PhysicalLayer.realpath(Hal.dirname(__FILE__) + '/../..')
    @fs[:prompt] = 'vish >'
#    @fs[:oldpwd] = Hal.pwd
    @fs[:version] = Vish::VERSION
    @fs[:release] = Vish::RELEASE
    @fs[:ifs] = ' '
    @fs[:ofs] = ' '
    @fs[:_debug] = false
    @fs[:metakeys] = UnknownHash.new
    @fs[:term] = ENV['TERM']
    term_match = @fs[:term].match(/([^\-]+).*/)
    @fs[:term_simple] = term_match[1]
    @fs[:term_program] = ENV['TERM_PROGRAM'] || @fs[:term_simple]
    @fs[:termfile] = "#{@fs[:vhome]}/etc/keymaps/#{@fs[:term_program]}.json"
    # Setup stuff for command, (and possibly cmdlet) name resolution
    @fs[:path] = '/v/bin'
    @fs[:nl] = "\n"
    @fs[:tab] = "\t"
    @fs[:bell] = "\g"
    @fs[:cr] = "\r"
  end

  # %%LINT4 - ignore this long line
  def initialize(
    env: FrameStack.new(frames: [{ in: $stdin, out: $stdout, err: $stderr }]),
    frames: FrameStack.new
  )

    # Initialize Hal to have the default actual filesystem
        Hal.set_filesystem(PhysicalLayer)
    @fs = frames
    @ios = env
    _init
    @seen = [] # seen aliases during dealias

    # setup cdbuf for storing :oldpwd and eventually :pwd
    @cdbuf = [Hal.pwd, Hal.pwd]
    @fs[:oldpwd] = ->() { @cdbuf[-1] }

    # setup our simulated PID.
    @@pid_frame ||= 0
    @ppid = @@pid_frame
    @@pid_frame += 1
    @pid = @@pid_frame
    # setup :pid, :ppid variables
    @fs[:pid] = ->() { @pid }
    @fs[:ppid] = ->() { @ppid }
  end
  attr_accessor :fs, :ios, :seen, :cdbuf
  attr_reader  :pid, :ppid


  def call(block)
    _hook(block) { block.call env: @ios, frames: @fs }
  end
  def _builtins
    self.class.instance_methods(false).reject {|m| m.to_s[0] == '_' }
  end
  # implement a dir stack so cd -, pushd, popd work
  def _chdir(path)
#    @fs.first[:oldpwd] = @fs[:pwd]
_saved_old = Hal.pwd
    result = true
    begin
      Hal.chdir path, @fs[:pwd]
      @cdbuf[-1] = _saved_old
    rescue Errno::ENOTDIR => exc
      raise exc

    rescue Errno::ENOENT => exc
      raise exc
    rescue => err
      @ios[:err].puts '_chdir: ' + err.message
      result = false

    ensure
      @fs.first[:pwd] = Hal.pwd
      @cdbuf[0] = Hal.pwd
    end
    result
  end

  # swap @cdvuf to get :oldpwd and :pwd and then chdir there there
  def _swapcd
    @cdbuf.rotate!
    Hal.chdir(*@cdbuf)
  end

  # export args into global environment
  def global(*args, env:, frames:)
    args.each { |a| @fs.first[a.to_sym] = frames[a.to_sym] }
    true
  end

  def cd(*args, env:, frames:)
    if !args.empty? && args[0] == '-'
      oldpwd = @fs[:oldpwd]
      _chdir oldpwd
      pwd(*args, env: env, frames: frames)
    elsif args.empty?
      # go back to :proj
      _chdir frames[:proj]
      pwd(*args, env: env, frames: frames)
    else
      _chdir args[0]
    end
    true
  rescue Errno::ENOTDIR => err
    env[:err].puts "cd: #{err.message}"
    false
  rescue Errno::ENOENT => err
    env[:err].puts "cd: #{err.message}"
    false
  end
  # restore_pwd - changes physical pwd to saved pwd if not equal
  def restore_pwd
     saved_old = @cdbuf[1]
    cd(@cdbuf[0], env:@ios, frames:@fs) if Hal.pwd != @cdbuf[0]
    @cdbuf[1] = saved_old
    @fs[:oldpwd] = ->() { @cdbuf[1] }
  end

  def mount(*args, env:, frames:)
    raise IOError.new('Argument to mount cannot be empty') if args.length.zero?
    root = VFSRoot.new
    VirtualLayer.set_root root
    root.mkdir_p  args[0]
    root.mount_pt = args[0]
    frames[:vroot] = root
    frames.merge
    #Hal.set_filesystem(PhysicalLayer)
  end

  def mkdir(*args, env:, frames:)
    #Hal.mkdir_p args[0]
    args.each {|p|  Hal.mkdir_p(p) }
    true
  end

  # install_cmd Class /v/bin # installs class named Class into vpath /v/bin
  # making it available to run as command
  # Hint: when doing this in Ruby, before calling this in vish: 
  # class ::Foo < BaseCommand
  #  def call *args, env: frames:
  #     env[:out].puts "in foo"
  #    end
  # end
  def install_cmd(*args, env:, frames:)
    klass = Kernel.const_get(args[0])
    root = frames[:vroot]
    path = root[args[1]]
    path[snakeize(klass.name)] = klass.new
    true
  end

  # install - command to install command objects into virtual bin dir
  def install(*_args, env:, frames:)
    root = frames[:vroot]
    path = root['/v/bin'] # commands will be installed here

    BinCommand::NixCommand.install_pairs.each {|fname, obj| path[fname] = obj }
    true
  end

  def pwd(*_args, env:, frames:)
    env[:out].puts Hal.pwd
    true
  end

  def one_alias(key)
    expansion = @fs.aliases[key]
    "alias #{key}=\"#{expansion}\""
  end

  def alias(*args, env:, frames:)
    if args.empty?
      @fs.aliases.keys.each { |k| env[:out].puts one_alias(k) }
    else
      env[:out].puts one_alias(args[0])
    end
    true
  end

  def unalias(*args, env:, frames:)
    @fs.aliases.delete args[0]
    true
  end

  def cmdlet(*args, env:, frames:)
    case args.length
    when 2
      fname, code = args
      clet = CommandLet.new
    when 4
      if args[1] == '-f' && CommandLet.valid_flags?(args[2])
        fname, _, flags, code = args
        clet = CommandLet.new(flags)
      else
        raise VishSyntaxError.new("cmdlet: invalid -f flags opton")
      end
    else
      raise VishSyntaxError.new(" cmdlet: expected 2 or 4  arguments, got #{args.length}")
    end

    path = default_path(fname, default: '/v/cmdlet/misc')
    clet.code = code

    vroot = frames[:vroot]
    vroot.creat(path, clet)
    return true
  end
  def source(*args, env:, frames:)
    if args.empty?
      env[:err].puts 'source: missing argument'
      false
    else
      begin
        fh = Hal.open(args[0], 'r')
        block = Visher.parse!(fh.read())
      __old_file = @fs[:__FILE__]
      __old_dir = @fs[:__DIR__]
        @fs[:__FILE__] = args[0]
        @fs[:__DIR__] = Hal.realpath(args[0]).pathmap('%d')
        call block
      @fs[:__FILE__] = __old_file
      @fs[:__DIR__] = __old_dir
        @fs.globalize
      rescue ExitCalled
        raise # re-raises the same exception
      rescue ReturnCalled => r
        return r.return_code
      rescue => err
        line = 0
        line = err.line_number if err.respond_to? :line_number
        env[:err].puts "#{args[0]}:#{line}: exception #{err.message}"
        false
      end
    end
  end
  def declare_single_variable(var, env:)
    ident = var.to_sym
    fr = @fs.frames.reduce({ident => "Undefined"}) {|f, j| j.key?(ident) ? j : f  }
    if fr[ident] == "Undefined"
      return false
    else
      env[:out].puts("#{var}=#{fr[ident]}")
    end
  end
  def declare_variables(env:)
    @fs.each do |fr|
      fr.each_pair { |k, v| env[:out].puts "#{k}=#{v}" }
    end
    true
  end

  def declare_function(fn, funct, env:)
    env[:out].puts "function #{fn}#{funct}"
    true
  end

  def declare_functions(env:)
    @fs.functions.each_pair { |k, v| declare_function k, v, env: env }
    true
  end

  def declare_single_function(fn, env:)
    return false if @fs.functions[fn].nil?
    declare_function fn, @fs.functions[fn], env: env
  end

  def declare(*args, env:, frames:)
    if args.length == 1 && args[0] == '-f'
      declare_functions env: env
    elsif args.length > 1 && args[0] == '-f'
      declare_single_function args[1], env: env
    elsif args.length > 1 && args[0] == '-p'
      declare_single_variable(args[1], env: env)
    else
      declare_variables env: env
    end
  end

  # defn promote a lambda into an actual function
  def defn(*args, env:, frames:)
    if (args.length != 2)
      env[:err].puts("defn: requires 2 arguments: A name and a lambda or a block")
      return false
    elsif !args[0].kind_of?(String)
      env[:err].puts("defn: first argument must be a string which will become the name of the function")
      return false
    else
      case args[1]
      when Lambda
        xblk = args[1]; xblk.extend LambdaFunction; xblk.name = args[0]
        frames.functions[args[0]] =  xblk
      when Block
        xblk = Lambda.new([], args[1], frames: Closure.close(frames))
        xblk.extend LambdaFunction; xblk.name = args[0]
        frames.functions[args[0]] = xblk

      else
        env[:err].puts("defn: second argument must be either a lambda or a block")
        return false
      end
      return true
    end
  end
  # type arg - reports type of arg, either alias function or alias or unknown
  def type *args, env:, frames:
    raise ArgumentError, 'Expected 1 argumnet' if args.empty?

    vf = VerbFinder.new
    if args[0] == "-a"
      args.shift
      msg = :find_all
    else
      msg = :find
    end
    res = vf.send(msg, args[0], vm: self) # find(args[0], vm: self)
    strm = (res.nil? ? :err : :out)
    env[strm].puts (res.nil? ? 'unknown' : res)
    !res.nil?
  end

  def _break(*_args, env:, frames:)
    raise VirtualMachine::BreakCalled
  end

  def _return(*args, env:, frames:)
    code = if args.empty?
             true
           elsif args[0] == 'false'
             false
           elsif args[0] == 'true'
             true
           else
             args[0]
           end
    raise VirtualMachine::ReturnCalled, code
  end
  #    alias_method :exit, :break

  def eval(*args, env:, frames:)
    block = Visher.parse! args.join(' ')
    block.call env: env, frames: frames
    @fs.merge
    frames[:exit_status]
  rescue VishSyntaxError => err
    env[:err].puts err.message
    false
  end

  def restore_oldpwd
    @fs[:oldpwd] = ->() { @cdbuf[1] }
  end

  # create a deep copy of me
  def _clone
    nfs = @fs._clone
    nios = @ios._clone
    vm = VirtualMachine.new(env: nios, frames: nfs)
    vm.cdbuf = @cdbuf.clone
    vm.fs.vm = vm
    # set child's ppid to our pi and reset both :pid, :ppid variablesd
    vm.ppid = @pid
    vm.restore_pids
    vm.fs[:oldpwd] = ->() { vm.cdbuf[1] }

    vm
  end

  def restore_pids
    @fs[:pid] = ->() { @pid }
    @fs[:ppid] = ->() { @ppid }
  end

  def _inspect
    'intentionally blank : from class VirtualMachine.inspect'
  end
  # _hook wraps the actual call to our call method. Allows for tracing
  def _hook(obj, &blk)
    yield
  end
  protected
  def ppid=(num)
    @ppid = num
  end
end
