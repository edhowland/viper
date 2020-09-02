# spike_runner.rb - PipeProc for running all tests

def spike_runner
  PipeProc.new {|coll|
    coll.map do |p|
      begin
        p.call
        [:pass, p.message]
      rescue BaseAssertionException => err
        [:fail, p.message + ':' + err.message]
      rescue SkippedTest => err
        [:skip, p.message + ':' + err.message]
      rescue => err
        [:error, p.message + ':' + err.message]
      end
    end
  }
end
