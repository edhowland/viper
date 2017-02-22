# basname - class Basename - command basename fullpath


class Basename < BaseCommand
  def call *args, env:, frames:
    env[:out].puts Hal.basename(args[0])
    true
  end
end
