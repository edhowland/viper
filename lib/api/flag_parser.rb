# flag_parser.rb - class FlagParser - simple option parser
# converts array of posible -flag strings internally to some Procs
# When :parse called, calls the procs, possibly with attached argument
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

  def arg_type(option, arg, klass)
    unless arg.instance_of?(klass)
      message = "#{option} expects arg to be a #{klass.name}"
      raise ArgumentError, message
    end
    true
  end

  def parse!(args = [])
    value = []
    ments = args.map {|e| @flags[e].nil? ? e : @flags[e] }
    iter = ments.each
    loop do
      arg = iter.next
      if arg.instance_of?(Proc)
        case arg.arity
        when 0
          arg.call
        when 1
          param = iter.next
          arg.call param
        else
          raise ArgumentError.new "Wrong number of parameters to block for this option. Got #{arg.arity}. Expected 0 or 1"
        end
      else
        value << arg
      end
    end rescue StopIteration
    value
  end

  def parse(args = [])
    parse! args
  end
end

# is_boolean? is intentional
# rubocop:disable Style/PredicateName
# create w/flag_hash: {'-e' -> false, '-f' => ''}  :: Will return found flags
# when :parse called w/array. Unfound flags, will leave initial 
# key, value unchenged
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
  def parse!(args = [])
    remaining = super args
    [@parsed_hash, remaining]
  end
end
