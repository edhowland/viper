# event - class Event - events handler

class Event
  @@proceed = -1
  class << self
    def init
      @@events ||= []
    end
    def << handler
      init
      @@events << handler
    end
    def events
      init
      @@events
    end
    def trigger *args, env:, frames:
      init
      @@proceed += 1
      @@events.each {|e| e.call(*args, env:env, frames:frames) } if @@proceed.zero?
      @@proceed -= 1
    end
  end
end
