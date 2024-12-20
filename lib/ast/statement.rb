# statement - classStatement - statement node in AST
# Use multiline block chain is OK
# rubocop:disable Style/MultilineBlockChain
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize

require_relative 'context_constants'

class AliasStackTooDeep < RuntimeError
  def initialize message='Alias stack too deep'
    super message
  end
end

class Statement
  include Redirectable
  include ClassEquivalence

  def initialize(context = [], line_number = 0)
    @context = context
    @line_number = line_number
  end
  attr_reader :context
  attr_accessor  :line_number

  # comment these out to restore old call method
 # alias_method :old_call, :call
#  alias_method :call, :_call
  def command_ndx
    @context.index {|e| e.ordinal == COMMAND }
  end

  def has_alias?(frames:)
    ndx = command_ndx
    unless ndx.nil?
      !frames.aliases[@context[ndx].to_s].nil?
    else
      false
    end
  end

  def expand_alias(frames:)
    str = @context[command_ndx].to_s
    frames.aliases[str]
  end

  def embed_alias(frames:)
    str = expand_alias(frames: frames)
    lit = Glob.new str
    @context[command_ndx] = lit
    @context.map(&:to_s).join(' ')
  end

  def expand_and_call(env:, frames:)
    al = expand_alias(frames: frames)
    if frames.vm.seen.member? al
      frames.vm.seen.clear
      raise AliasStackTooDeep.new
    end
    frames.vm.seen.push al
    block = Visher.parse!(embed_alias(frames: frames))
    result = block.call(env: env, frames: frames)
    frames.vm.seen.pop
    result
  end


  # given context array, perform any redirections, remove them and return ctx
  def perform_redirs(ctx, env:, frames:)
    ctx.reject do |e|
      redirectable?(e) &&
        redirect(e, env: env, frames: frames).nil?
    end
  end

  # perform any variable assignments
  def perform_assigns(ctx, env:, frames:)
    ctx.reject do |e|
      e.ordinal == ASSIGN &&
        e.call(env:env, frames:frames).nil?
    end
  end

  # perform any dereferences
  def perform_derefs(ctx, env:, frames:)
    ctx.map {|e| e.call(env:env, frames:frames) }.flatten
  end

  # prepare statement context by dereferenceing redirections, assignments and variable dereferences
  def prepare ctx, env:, frames:
    ctx = perform_redirs ctx, env:env, frames:frames
    ctx = perform_assigns ctx, env:env, frames:frames
    perform_derefs ctx, env:env, frames:frames
  end

  def bump_frames env:, frames:, &blk
    env.push
    frames.push
    yield env, frames
  ensure
    env.pop
    frames.pop
  end

  def wrap_streams env:, frames:, &blk
      closers = open_redirs env: env
    yield env, frames
  ensure
    #fail 'nil found for closers' if closers.nil?
    if closers.nil?
      Log.say_time("closers were nil for this statement: > #{self.to_s} <")
      fail
    end

    close_redirs closers  
  end

  # prepare context and resolve command or function and call with args and env
  def execute env:, frames:
    result = true
    bump_frames(env:env, frames:frames) do |ios, fs|
      ctx = prepare @context, env: ios, frames: fs
      c, *args = ctx
    # TODO: Is this correct? Shouldn't use local_ios and local_vars
      command = Command.resolve(c, env: env, frames: frames, line_number:@line_number)
      wrap_streams(env:ios, frames:fs) do |ios, fs|
        result = command.call(*args, env: ios, frames: fs)
      end
    end
        frames[:exit_status] = result
        frames.first[:pipe_status] = [result]
      result
  end

  def call_expanded(env:, frames:)
    string = @context.map(&:to_s).join(' ')
    block = Visher.parse! string
    block.call env: env, frames: frames
    frames.vm.seen.pop
  end
  # def thing
  def _call(env:, frames:)
    if has_alias?(frames: frames)
      expand_and_call(env: env, frames: frames)
    else
      execute(env: env, frames: frames)
    end
  end

  # sort the @context array by ordinal numbertake any command args and move them
  # the assignments and command. The command is the first arg or glob or deref.
  # the args are the rest of the array.
  def call(env:, frames:)
    # check if we have an alias expansion
    possible_alias = @context.find { |e| e.ordinal == COMMAND }
    real_alias = possible_alias.to_s
    expansion = frames.aliases[real_alias]
    if expansion.nil?
      local_vars = frames
      local_vars.push
      local_ios = env
      local_ios.push

      sorted = @context.sort_by(&:ordinal)
#      sorted = sorted
#               .reject do |e|
#                 redirectable?(e) &&
#                   redirect(e, env: local_ios, frames: local_vars)
#               end
      sorted = perform_redirs(sorted, env:local_ios, frames:local_vars)
      sorted = sorted.map { |e| e.call env: local_ios, frames: local_vars }
      sorted.flatten!
      sorted.reject!(&:nil?)
#      sorted = perform_assigns(sorted, env:local_ios, frames:local_vars)
#      sorted = perform_derefs(sorted, env:local_ios, frames:local_vars)

      c, *args = sorted
      command = Command.resolve(c, env: env, frames: frames)
      # closers = local_ios.values
      # local_ios.top.each_pair {|k, v| local_ios[k] = v.open }
      closers = open_redirs env: local_ios
      begin
        result = command.call(*args, env: local_ios, frames: local_vars)
      ensure
        # closers.each {|f| f.close }
        close_redirs closers
        local_ios.pop
        local_vars.pop
        frames[:exit_status] = result
        frames.first[:pipe_status] = [result]
      end
      result
    else
      if frames.vm.seen.member? real_alias
        env[:err].puts "#{real_alias} not found"
        return false
      else
        frames.vm.seen << real_alias
      end
      @context[@context.index(possible_alias)] = StringLiteral.new(expansion)
      call_expanded env: env, frames: frames
    end
  end

  def to_s
    @context.map(&:to_s).join(' ')
  end
  def ==(other)
    class_eq(other) && (other.line_number == self.line_number) && list_eq(other.context, self.context)
  end
 
  # comment these out to restore old call method functionality 
     alias_method :old_call, :call
  alias_method :call, :_call

end
