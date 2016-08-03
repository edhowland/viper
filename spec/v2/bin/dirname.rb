# dirname - class Dirname - command dirname path


class Dirname
  def call *args, env:, frames:
    env[:out].puts Hal.dirname(args[0])
    true
  end
end
