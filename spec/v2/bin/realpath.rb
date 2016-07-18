# realpath - class Realpath - command realpath file - outputs fullpath of file


class Realpath
  def call *args, env:, frames:
    env[:out].puts Hal.realpath args[0]
    true
  end
end
