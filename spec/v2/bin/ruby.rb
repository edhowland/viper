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
      status = self.instance_eval(args[0])
    ensure
      $stdout = @orig_out
      $stdin = @orig_in
    end
    status
  end
end
