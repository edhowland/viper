# spike_total.rb - method spike_total - computes total count of tests
def spike_total
  L do |coll|
    "Total #{coll.count}"
  end
end