# cat - class Cat - implement the command :cat

class Cat < BaseCommand
  def call *args, env:, frames:
    env[:out].write(env[:in].read)
    true
  end
end
