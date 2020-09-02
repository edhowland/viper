# spike_status.rb - method spike_status - reduces input to true or false for exit

def spike_status
  L do |coll|
    codes = {pass: true, fail: false, error: false, skip: false }
    coll.reduce(true) { |i,j| i && codes[j] }
  end
end