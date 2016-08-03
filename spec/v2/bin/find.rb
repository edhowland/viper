# find - class Find - command find - like the bash one
# args: possible places to search
# -name: filter
# -exec :lambda to run on found elements

class Selector < Eq
  def initialize filter
    @filter = filter
  end
  def call *args, env:, frames:
    super @filter, Hal.basename(args[0]), env:env, frames:frames
  end
end

class Find
  def initialize 
    @source = '.'
    @filter = Eq.new
    @exec = Echo.new
  end
  def call *args, env:, frames:
    @source, @filter, @exec = args.shift(3)
    @filter = Selector.new(@filter)
    @exec ||= Echo.new
    Hal['**'].select {|e| @filter.call(e, env:env, frames:frames) }.each {|e| @exec.call(e, env:env, frames:frames) }
    true
  end
end

