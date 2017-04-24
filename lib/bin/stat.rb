# stat - class Stat - command stat file - info about path

class Stat < FlaggedCommand
  def initialize
    super(flags: {'-s' => false }) do |inp, out, err, frames, flags, *args|
      env = {in: inp, out: out, err: err}
    path = args[0]
    unless flags['-s']
    info path, *([:virtual?, :directory?]
      .map { |e| examine(Hal, e, path) }), env: env, sep: "\n"
    if Hal.virtual? path
      root = frames[:vroot]
      node = root[path]
      out.puts "#{node.class.name}: #{node}"
      out.puts "length: #{node.length}" if node.instance_of?(Array)
    end
    else
      root = frames[:vroot]
      node = root[path]
      out.puts node.to_s
    end
        true

    end
  end

  def examine(rxr, method, *args)
    method.to_s + ' ' + rxr.send(method, *args).to_s
  end
end
