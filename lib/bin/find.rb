# find.rb - class Find - command find -  search input recursively
# args:
# -e &(f) { ... }  : Run this anon function for everymatched file
# -grep /pattern/ : match only files that match this pattern
# -name glob_pattern : match files that match this Shell -like glob pattern
# -filter &(o) { ... } : match only names that satisfiy this anon function
# -f : match actual files, not directories
# -d : match only directories, not files
#
# Double negation is OK to return true/false from regex match
# rubocop:disable Style/DoubleNegation
# rubocop:disable Metrics/AbcSize

class Find < BaseCommand
  def initialize
    @parser = FlagParser.new
    @parser.on('-e') do |lmbd|
      @parser.arg_type '-e', lmbd, Lambda
      @action = lmbd
    end
    @parser.on('-d') do
      @filter = ->(*args, **_keywords) { Hal.directory?(args[0]) }
    end
    @parser.on('-f') do
      @filter = ->(*args, **_keywords) { !Hal.directory?(args[0]) }
    end
    @parser.on('-filter') do |lmbd|
      @parser.arg_type '-filter', lmbd, Lambda
      @filter = lmbd
    end
    @parser.on('-name') do |pattern|
      @parser.arg_type '-name', pattern, String
      @filter = ->(*args, **_keywords) { File.fnmatch pattern, args[0] }
    end
    @parser.on('-grep') do |pattern|
      @parser.arg_type '-grep', pattern, String

      pattern = Regexp.new pattern
      @filter = ->(*args, **_keywords) { !!args[0].match(pattern) }
    end
  end

  def clear_filter_action
    @filter = nil
    @action = nil
  end

  def get_glob(pat)
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

  def filter_p(env:, frames:)
    if @filter.nil?
      ->(_o) { true }
    else
      ->(o) { @filter.call o, env: env, frames: frames }
    end
  end

  def action_set(env:)
    @action ||= ->(*ag, **_keywords) { env[:out].puts ag[0] }
  end

  def call(*args, env:, frames:)
    args.unshift '.' if args.empty?
    src, = args
    clear_filter_action
    @parser.parse args
    action_set(env: env)
    action_p = ->(o) { @action.call o, env: env, frames: frames }
    src = get_glob(src)
    Hal[src].select(&filter_p(env: env, frames: frames)).each(&action_p)
    true
  end
end
