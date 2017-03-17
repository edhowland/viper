# rand.rb - class Class Rand - command rand - outputs  random string
# args: -c first last => output chars within first..last range.
# Else outputs all 22 chars

require 'securerandom'

class Rand < BaseCommand
  def call(*args, env:, frames:)
    super do |*a|
      range = 0..-1
      if @options[:c]
        first, last = a
        range = (first.to_i)..(last.to_i)
      end
      pout SecureRandom.urlsafe_base64[range]
      true
    end
  end
end
