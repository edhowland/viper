# fnd.rb - class Fnd - command fnd - prototype for functional find command
# eventually
# args:
# -e &(f) { ... }  : Run this anon function for everymatched file
# -grep /pattern/ : match only files that match this pattern
# -name glob_pattern : match files that match this Shell -like glob pattern
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
      @parser.on('-name') do |pattern|
              raise ArgumentError.new('-name requires a string argument') unless String === pattern
              @filter = ->(*args, env:, frames:) { File.fnmatch pattern, args[0] }

      end
    end
  end
  def clear_filter_action
    @filter = nil
    @action = nil
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
  def filter_p env:, frames:
    if @filter.nil?
      ->(o) { true }
    else
      ->(o) { @filter.call o, env:env, frames:frames }
    end
    
  end
  def action_p env:
    ->(o) {env[:out].puts o }
  end
  def call *args, env:, frames:
    args.unshift '.' if args.empty?
    src,  = args
    clear_filter_action
    @parser.parse args
    @action ||= ->(*args, env:, frames:) { env[:out].puts args[0] }
    action_p = ->(o) { @action.call o, env:env, frames:frames }
    src = get_glob(src)
    Hal[src].select(&filter_p(env:env, frames:frames)).each(&action_p)
    true
  end
end