# find - class Find - command find - like the bash one
# args: possible places to search
# -name: filter
# -exec :lambda to run on found elements

class Find
  def initialize 
    @source = '.'
    @filter = /.*/
    @exec = Echo.new
  end
  def call *args, env:, frames:
    @source, @filter, @exec = args.shift(3)
    @exec = @exec || Echo.new
    Hal['**'].each {|e| @exec.call(e, env:env, frames:frames) }
    true
  end
end

