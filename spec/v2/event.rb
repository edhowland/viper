# event - class Event - events handler

class Event
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
      @@events.each {|e| e.call(*args, env:env, frames:frames) }
    end
  end
end
