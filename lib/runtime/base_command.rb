# base_command.rb - abstract class BaseCommand - base class for all/most
# commands.
# possibly abstracts out option handling
# adds methods: pout, perr to simplify stdout, stderr stream output
# %%LINT1 # forced to do this by Rubocop alignment cop

class BaseCommand < BinCommand::NixCommand
=begin
  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end
=end

  def initialize
    @options = {}
  end

  attr_reader :options

  def pout(*stuff)
    @ios[:out].puts(*stuff)
  end

  def perr(*stuff)
    @ios[:err].puts(*stuff)
  end

  def args_parse!(args)
    @options = {}
    args.select { |e| e =~ /^\-.+/ }
        .map { |e| e[1..-1].to_sym }
        .each { |e| @options[e] = true }
    args.reject { |e| e =~ /^\-.+/ }
  end

  def message(*phrases, stream:, env:, sep:)
    phrases.unshift snakeize(self.class.name)
    env[stream].puts phrases.join(sep)
  end

  def error(*phrases, env:, sep: ': ')
    message(*phrases, stream: :err, env: env, sep: sep)
  end

  def info(*phrases, env:, sep: ' ')
    message(*phrases, stream: :out, env: env, sep: sep)
  end

  def arg_error(expected, env:)
    error 'Wrong number of arguments', 'Expected', expected, env: env
  end

  def call(*args, env:, frames:)
    @ios = env
    @in = env[:in]
    @out = env[:out]
    @err = env[:err]
    @fs = frames
    @av = args_parse! args
    result = true
    result = yield(*@av) if block_given?
    return result if TrueClass === result || FalseClass === result
    true
  end
end
