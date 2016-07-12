# stat - class Stat - command stat file - info about path



class Stat
  def call *args, env:, frames:
    path = args[0]
    env[:out].puts "#{path}: is virtual? #{Hal.virtual?(path)}"
  end
end
