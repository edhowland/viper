# fnd.rb - class Fnd - command fnd - prototype for functional find command
# eventually
# args:
# -e &(f) { ... }  : Run this anon function for everymatched file
# -grep /pattern/ : match only files that match this pattern
# -filter &(o) { ... } : match only names that satisfiy this anon function
# -f : match actual files, not directories
# -d : match only directories, not files

class Fnd < BaseCommand
  def initialize
    @parser = FlagParser.new
    @parser.on('-e') do |lmbd|
      raise ArgumentError.new('-e requires a lambda argument') unless Lambda === lmbd
      @action = lmbd
    end
    @parser.on('-filter') do |lmbd|
      raise ArgumentError.new('-filter requires a lambda argument') unless Lambda === lmbd
      @filter = lmbd
    end
  end
  def get_glob pat
    case pat
    when '.'
      '**/*'
    else
      if Hal.directory? pat
        "#{pat}/**/*"
      else
        pat
      end
    end
  end
  def filter_p obj=nil
    ->(o) { true }
  end
  def action_p env:
    ->(o) {env[:out].puts o }
  end
  def call *args, env:, frames:
    args.unshift '.' if args.empty?
    src,  = args
    @action = nil
    @parser.parse args
    @action ||= ->(*args, env:, frames:) { env[:out].puts args[0] }
    action_p = ->(o) { @action.call o, env:env, frames:frames }
    src = get_glob(src)
    Hal[src].select(&filter_p).each(&action_p)
    true
  end
end