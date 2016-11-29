# base_command.rb - abstract class BaseCommand - base class for all/most commands.
# possibly abstracts out option handling
# adds methods: pout, perr to simplify stdout, stderr stream output

class BaseCommand
def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
        end
  def initialize 
    @options = {}
  end
  def pout *stuff
    @ios[:out].puts *stuff
  end
  def perr *stuff
    @ios[:err].puts *stuff
  end
  def args_parse! args
    @options = {}
    args.select {|e| e =~ /^\-.+/ }.map {|e| e =~ /^\-*([^\-]*)/; $1.to_sym }.each {|e| @options[e] = true }
    args.reject {|e| e =~ /^\-.+/ }
    #opts, ags = args.partition {|e| e =~ /^\-/ }
    #opts.map {|e| e[1..-1] }.map {|e| e.to_sym }.each_with_object(@options) {|e, o| o[e] = true }
    #ags
  end
  def call *args, env:, frames:, &blk
  @ios = env
  @in = env[:in]
  @out = env[:out]
  @err = env[:err]
  @fs = frames
  @av = args_parse! args
  result = true
    result = yield(*@av) if block_given?
    if TrueClass === result || FalseClass === result
      return result
    end
    true
  end
end

