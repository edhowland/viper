# flag_parser.rb - class FlagParser - simple option parser
# converts array of posible -flag strings internally to some Procs
# Then calls the procs, possibly with attached argument
#  The simplest thing that possibly could work

class FlagParser
  def initialize
    @flags = {}
  end
  attr_accessor :flags
  def on(flag, &blk)
    @flags[flag] = blk
  end
  def o_or_arr arg
    if @flags.include? arg
      []
    else
      [arg]
    end
  end
  def arg_type option, arg,  klass
    unless klass  === arg
      message = "#{option} expects arg to be a #{klass.name}"
      raise ArgumentError.new message
    end
    true
  end
  def parse args=[]
    execs = args.map {|e| @flags[e] }
    temp = args
    temp.shift
    params = temp.map {|e|o_or_arr(e) }
    params.push []
    things = execs.zip(params).reject {|e| e[0].nil? }
    things.each {|e| e[0].call *e[1] }
  end
end
