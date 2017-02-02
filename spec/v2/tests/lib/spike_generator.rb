# spike_generate.rb - method spike_generate - gathers all the tests

# spike_spike_query_tests - reflects on BaseSpike for test names
def spike_query_test
  PipeProc.new do |coll|
    BaseSpike.descendants.map do |klass|
      [klass, klass.tests]
    end
  end
end

# spike_lamb_wrap - wraps its collection elements in a DecoratedProc
def spike_lamb_wrap
  PipeProc.new do |coll|
    coll.map do |tuple|
      tuple[1].map do |test|
        dp = DecoratedProc.new do 
          obj = tuple[0].new
          obj.try :set_up
          obj.send  test
          obj.try :tear_down
        end
        dp.message = "#{tuple[0].name}::#{test.to_s}"
        dp
      end
    end
  end
end



def spike_generate
  spike_query_test | spike_lamb_wrap | spike_flatten
end
