# encode64 - class Encode64 - command encode64 - converts input,arg to base 64

require 'base64'

class Encode64 < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      if @options[:r]
        env[:out].write(Base64.encode64(env[:in].read))
      else
        env[:out].write(Base64.encode64(a.join(' ')))
      end
    end
  end
end
