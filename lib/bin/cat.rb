# cat - class Cat - implement the command :cat

# flags
# - : placed anywhere in a list of arguments will be replaced with content of stdin

class Cat < BaseCommand
  def call(*args, env:, frames:)
    unless args.empty?
    stdin_ndx = args.index {|a| a == '-' }
    args.each_with_index do |a, i|
      if i == stdin_ndx
    env[:out].write(env[:in].read)
      else
        f = Hal.open(a, 'r')
        env[:out].write(f.read)
        f.close
      end
    end
    else
      env[:out].write(env[:in].read)
    end
    true
  end
end
