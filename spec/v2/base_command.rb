# base_command - class BaseCommand - base class for all/most commands.
# possibly abstracts out option handling
# adds methods: pout, perr to simplify stdout, stderr stream output

class BaseCommand
  def pout *stuff
    @ios[:out].puts *stuff
  end
  def perr *stuff
    @ios[:err].puts *stuff
  end
  def call *args, env:, frames:, &blk
  @ios = env
  @in = env[:in]
  @out = env[:out]
  @fs = frames
    result = yield *args
    if TrueClass === result || FalseClass === result
      return result
    end
    true
  end
end

