# spike_color.rb - method spike_color - reduces (after a fasion) to a color string
# green - all tests passed
# yellow - some tests were skipped, the rest passed
# blue - no tests were discovered 
# red - some test failed or had an error
#
# (opt):
# infra red - a syntax error occurred, or some lib could not be  loaded

Red = 0b00
Green = 0b11
Yellow = 0b10
Blue = 0b01

def spike_color
  PipeProc.new do |coll|
    color_bits = {pass: Green, fail: Red, error: Red, skip: Yellow, empty: Blue }
    color_names = {Green => 'green', Yellow => 'yellow', Red => 'red', Blue => 'blue' }
    coll = [:empty] if coll.empty?

    color_names[ coll.reduce(Green) {|i, j| i & color_bits[j] } ]
  end
end
