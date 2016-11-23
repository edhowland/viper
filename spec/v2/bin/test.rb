# test - class Test - command test - returns true or false based on  arguments
# args: 
# -f checks if file exists
# -z checks if argument is empty string
# -e checks if array is empty

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
      end
      result
    end
  end
end
