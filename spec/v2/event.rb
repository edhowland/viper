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
    def trigger object, env:, frames:
      init
      @@events.each {|e| e.call(object, env:env, frames:frames) }
    end
  end
end
