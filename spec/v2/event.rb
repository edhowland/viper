# event - class Event - events handler
# Stores handlers for matching command regexs. Runs them when triggered

require_relative 'regex_hash'
class Event

  @@proceed = -1
  class << self
    def init
      @@events ||= []
      @@matches ||= RegexHash.new
    end
    def << handler
      init
      @@events << handler
    end
    def events
      init
      @@events
    end
    def []= key, handler
      init
      @@matches[key] = handler
    end
    def on(*args, env:, frames:)
          init

      handler = @@matches[args.join(' ')]
      handler.call(*args, env:env, frames:frames) if handler.respond_to? :call
    end
    def trigger *args, env:, frames:
      init
      @@proceed += 1
      @@events.each {|e| e.call(*args, env:env, frames:frames) } if @@proceed.zero?
      @@proceed -= 1
    end
  end
end
