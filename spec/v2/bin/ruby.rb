# ruby - class Ruby - command ruby - evalulates string in Ruby interperter

class Ruby
  def initialize 
    @orig_in = $stdin
    @orig_out = $stdout
  end
  def call *args, env:, frames:
    begin
      $stdin = env[:in]
      $stdout = env[:out]
      code = args.first
      argv = args[1..-1]
      result = self.instance_eval(code)
    ensure
      $stdout = @orig_out
      $stdin = @orig_in
    end
    if TrueClass === result || FalseClass === result
      return result
    end
    true
  end
end
