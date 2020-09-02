# spike_color.rb - method spike_color - reduces (after a fasion) to a color string
# green - all tests passed
# yellow - some tests were skipped, the rest passed
# blue - no tests were discovered 
# red - some test failed or had an error
#
# (opt):
# infra red - a syntax error occurred, or some lib could not be  loaded

# return lambda for bitwise and of 2 args
# lambda takes 2 args: color symbols like :red, :yellow
# based on  color_bits hash
def xform_color color_bits
  bits_color = color_bits.invert
  ->(a, b) { bits_color[color_bits[a] & color_bits[b] ] }
end

Red = 0b000
Green = 0b011
Yellow = 0b001
Blue = 0b111

def spike_color
  PipeProc.new do |coll|
    status_color = {pass: :green, fail: :red, error: :red, skip: :yellow }
        color_bits = {red: Red, yellow: Yellow, green: Green, blue: Blue }

    coll.map {|e| status_color[e] }.reduce(:blue, &xform_color(color_bits))
  end
end
