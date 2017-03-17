# hashcode - class Hashcode - command hashcode - converts string to hash code
# Args:
# -r reads from stdin
# args:  joined - string to be converted after joining

class Hashcode < BaseCommand
  def call(*args, env:, frames:)
    super do |*a|
      if @options[:r]
        env[:out].write(env[:in].read.hash)
      else
        env[:out].write a.join(' ').hash
      end
    end
  end
end
