# stat - class Stat - command stat file - info about path

class Stat < BaseCommand
  def examine(rxr, method, *args)
    method.to_s + ' ' + rxr.send(method, *args).to_s
  end

  def call(*args, env:, frames:)
    path = args[0]
    info path, *([:virtual?, :directory?]
      .map { |e| examine(Hal, e, path) }), env: env, sep: "\n"
    if Hal.virtual? path
      root = frames[:vroot]
      node = root[path]
      env[:out].puts "#{node.class.name}: #{node}"
      env[:out].puts "length: #{node.length}" if node.instance_of?(Array)
    end
    true
  end
end
