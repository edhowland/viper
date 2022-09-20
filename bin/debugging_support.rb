# debugging_support.rb: loaded only if -x flag is passed to viper

def default_of(a, b, &blk)
  a.nil? ? b : yield(a)
end

$tracef = default_of(ENV['VISH_TRACEFILE'], $stderr) {|n| File.open(n, 'a') }

at_exit do
  $tracef.close unless $tracef == $stderr
end


class Statement
  alias_method :old_call, :call
  def call(env:, frames:)
    src = @context.map(&:to_s).join(' ')
    $tracef.puts ">> #{src}"
    result = old_call(env: env, frames: frames)
    $tracef.puts "<< #{src}"
    result
  end
end