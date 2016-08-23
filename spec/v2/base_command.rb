# base_command - class BaseCommand - base class for all/most commands.
# possibly abstracts out option handling
# adds methods: pout, perr to simplify stdout, stderr stream output

class BaseCommand
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
    args.select {|e| e =~ /^\-/ }.map {|e| e =~ /^\-*([^\-]*)/; $1.to_sym }.each {|e| @options[e] = true }
    args.reject {|e| e =~ /^\-/ }
  end
  def call *args, env:, frames:, &blk
  @ios = env
  @in = env[:in]
  @out = env[:out]
  @fs = frames
  av = args_parse! args
  result = true
    result = yield(*av) if block_given?
    if TrueClass === result || FalseClass === result
      return result
    end
    true
  end
end

