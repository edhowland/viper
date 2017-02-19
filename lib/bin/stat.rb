# stat - class Stat - command stat file - info about path

class Stat < BaseCommand
  def call *args, env:, frames:
    path = args[0]
    env[:out].puts "#{path}: is virtual? #{Hal.virtual?(path)}\nis directory? #{Hal.directory?(path)}"
    if Hal.virtual? path
      root = frames[:vroot]
      node = root[path]
      env[:out].puts "#{node.class.name}: #{node.to_s}"
      env[:out].puts "length: #{node.length}" if node.instance_of?(Array)
    end
    true
  end
  end
