# find - class Find - command find - like the bash one
# args: possible places to search
# -name: filter
# -exec :lambda to run on found elements

class Selector < Eq
  def initialize(filter = '.') # default filter arg so can subclass from Eq
    @filter = filter
  end

  def call(*args, env:, frames:)
    super @filter, Hal.basename(args[0]), env: env, frames: frames
  end
end

class Find < BaseCommand
  def initialize
    @source = '.'
    @filter = Eq.new
    @exec = Echo.new
  end

  def call(*args, env:, frames:)
    @source, @filter, @exec = args.shift(3)
    case @filter
    when String
      @filter = Selector.new(@filter)
    when Lambda
      # nop
    else
      error 'Second arg must be string or lambda'
      # env[:err].puts 'find: second arg must be string or lambda'
      return false
    end
    @exec ||= Echo.new
    begin
      Hal['**'].select { |e| @filter.call(e, env: env, frames: frames) }
               .each { |e| @exec.call(e, env: env, frames: frames) }
      #
    rescue VirtualMachine::BreakCalled => err
      return true
    end
    true
  end
end
