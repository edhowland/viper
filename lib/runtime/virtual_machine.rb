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

  def _init
    #
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
  end

  # %%LINT4 - ignore this long line
  def initialize(
    env: FrameStack.new(frames: [{ in: $stdin, out: $stdout, err: $stderr }]),
    frames: FrameStack.new
  )
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
    block.call env: @ios, frames: @fs
  end

  # implement a dir stack so cd -, pushd, popd work
  def _chdir(path)
#    @fs.first[:oldpwd] = @fs[:pwd]
_saved_old = Hal.pwd
    result = true
    begin
      Hal.chdir path, @fs[:pwd]
      @cdbuf[-1] = _saved_old
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
  rescue Errno::ENOENT => err
    env[:err].puts "cd: #{err.message}"
    false
  end
  # restore_pwd - changes physical pwd to saved pwd if not equal
  def restore_pwd
     saved_old = @cdbuf[1]
    cd(@cdbuf[0], env:@ios, frames:@fs) if Hal.pwd != @cdbuf[0]
    @cdbuf[1] = saved_old
   end

  def mount(*args, env:, frames:)
    root = VFSRoot.new
    VirtualLayer.set_root root
    root.mkdir_p  args[0]
    root.mount_pt = args[0]
    frames[:vroot] = root
    frames.merge
    true
  end

  def mkdir(*args, env:, frames:)
    Hal.mkdir_p args[0]
    true
  end

  # install_cmd Class /v/bin # installs class named Class into vpath /v/bin
  # making it available to run as command
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
    BaseCommand.descendants.each do |klass|
      path[snakeize(klass.name)] = klass.new
    end
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

  def source(*args, env:, frames:)
    if args.empty?
      env[:err].puts 'source: missing argument'
      false
    else
      begin
        block = Visher.parse!(File.read(args[0]))
        @fs.push
        @fs[:__FILE__] = args[0]
        call block
        @fs.pop
      rescue ExitCalled
        raise ExitCalled
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
    else
      declare_variables env: env
    end
  end

  # type arg - reports type of arg, either alias function or alias or unknown
  def type *args, env:, frames:
    raise ArgumentError, 'Expected 1 argumnet' if args.empty?
    message = 'unknown'
    result = false
    if frames.aliases.has_key? args[0]
      message = 'alias'
      result = true
    elsif frames.functions.has_key?(args[0])
      message = 'function'
      result = true
    elsif self.respond_to? args[0].to_sym
      message = 'builtin'
      result = true
    else
      thing = Command.command_from_path "/v/bin/#{args[0]}", frames:frames
      if thing.class.ancestors.member? BaseCommand
        message = "/v/bin/#{args[0]}"
        result = true
      end
    end
    env[:out].puts message
    result
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
    vm
  end

  def restore_pids
    @fs[:pid] = ->() { @pid }
    @fs[:ppid] = ->() { @ppid }
  end

  def inspect
    'intentionally blank : from class VirtualMachine.inspect'
  end

  protected
  def ppid=(num)
    @ppid = num
  end
end
