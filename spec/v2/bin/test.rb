# test - class Test - command test - returns true or false based on  arguments
# args: 
# -f checks if file exists

class Test < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      result = true
      if @options[:f]
        result = Hal.exist?(a[0]).to_s
      end
      result
    end
  end
end
