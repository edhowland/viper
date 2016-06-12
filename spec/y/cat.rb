# cat - class Cat - implement the command :cat


class Cat
  def call *args, env:
    env[:out].write(env[:in].read)
  end
end
