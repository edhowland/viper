# log - class Log - implements log functions


LOGF=File.expand_path(File.dirname(__FILE__)) + '/vish.log'

class Log
  class << self
    def time_of_day
      Time.now.strftime("%m/%d/%y %H:%M")
    end
    def log &blk
      File.open(LOGF, 'a', &blk)
    end
    def start
      log do |f|
        f.puts time_of_day + ' Log started'
      end
    end
    def finish
      log {|f| f.puts(time_of_day + ' Log stopped') }
    end
    def say message
      log {|f| f.puts message }
    end
    def remove
      File.unlink LOGF
    end
  end
end

