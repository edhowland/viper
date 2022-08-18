# spike_output.rb - method spike_output - sends output to stdout

# spike_output - collection in, outputs within range, collection out
def spike_output range=(0..-1)
  L do |coll|
    coll[range].each {|e| puts e }
    coll
  end
end
