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
    def trigger type, object
      init
      @@events.each {|e| e.call(type, object) }
    end
  end
end
