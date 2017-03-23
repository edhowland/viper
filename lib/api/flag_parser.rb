# flag_parser.rb - class FlagParser - simple option parser
# converts array of posible -flag strings internally to some Procs
# Then calls the procs, possibly with attached argument
#  The simplest thing that possibly could work
# class FlagHash - child of FlagParser - converts hash into hash of parsed
# values

class FlagParser
  def initialize
    @flags = {}
  end

  attr_accessor :flags

  def on(flag, &blk)
    @flags[flag] = blk
  end

  def o_or_arr(arg)
    if @flags.include? arg
      []
    else
      [arg]
    end
  end

  def arg_type(option, arg, klass)
    unless arg.instance_of?(klass)
      message = "#{option} expects arg to be a #{klass.name}"
      raise ArgumentError, message
    end
    true
  end

  def parse(args = [])
    execs = args.map { |e| @flags[e] }
    temp = args
    temp.shift
    params = temp.map { |e| o_or_arr(e) }
    params.push []
    things = execs.zip(params).reject { |e| e[0].nil? }
    things.each { |e| e[0].call(*e[1]) }
  end
end

# is_boolean? is intentional
# rubocop:disable Style/PredicateName
class FlagHash < FlagParser
  def initialize(flag_hash: {})
    super() # This forces 0 arguments to FlagParser.initialize
    @flag_hash = flag_hash
    @parsed_hash = @flag_hash.clone
    @flag_hash.each_pair do |key, value|
      if is_boolean?(value)
        on(key) { @parsed_hash[key] = true }
      else
        on(key) { |param| @parsed_hash[key] = param }
      end
    end
  end

  attr_accessor :flag_hash, :parsed_hash

  def is_boolean?(param)
    param.instance_of?(TrueClass) || param.instance_of?(FalseClass)
  end

  def parse(args = [])
    super args
    @parsed_hash
  end
end
