# ruby - class Ruby - command ruby - evalulates string in Ruby interperter

class Ruby < BaseCommand
  def initialize
    @orig_in = $stdin
    @orig_out = $stdout
  end

  def call(*args, env:, frames:)
    begin
      $stdin = env[:in]
      $stdout = env[:out]
      code = args.shift
      result = instance_eval(code)
    ensure
      $stdout = @orig_out
      $stdin = @orig_in
    end
    return result if TrueClass === result || FalseClass === result
    true
  end
end
