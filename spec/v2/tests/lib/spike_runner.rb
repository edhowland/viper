# spike_runner.rb - PipeProc for running all tests

def spike_runner
  PipeProc.new {|coll|
    coll.map do |p|
      begin
        p.call
        [:pass, p.message]
      rescue BaseAssertionException => err
        [:fail, err.message]
      rescue SkippedTest => err
        [:skip, err.message]
      rescue => err
        [:error, err.message]
      end
    end
  }
end
