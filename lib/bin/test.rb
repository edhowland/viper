# test - class Test - command test - returns true or false based on  arguments
# args:
# (no flags: tests if first arg is true
# -f checks if file exists
# -z checks if argument is empty string
# -e checks if array or directory  is empty
# -l true if arg is a Lambda

class Test < BaseCommand
  def call *args, env:, frames:
    super do |*a|
      result = true
      if @options[:f]
        result = Hal.exist?(a[0])
      elsif @options[:z]
        result = (a[0].nil? || a[0].empty?)
      elsif  @options[:e]
        root = frames[:vroot]
        node = root[a[0]]
        result = node.empty?
      elsif @options[:l]
        result = (Lambda === a[0])
      else
        result = a[0]
      end
      result
    end
  end
end
