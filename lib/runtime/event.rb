# event - class Event - events handler
# Stores handlers for matching command regexs. Runs them when triggered
# rubocop:disable Style/ClassVars
# logic herein does not (yet) allow for guard clause
# rubocop:disable Style/GuardClause

require_relative 'regex_hash'

class Event
  @@proceed = -1
  class << self
    def init
      @@events ||= []
      @@matches ||= RegexHash.new
    end

    def <<(handler)
      init
      @@events << handler
    end

    def events
      init
      @@events
    end

    def []=(key, handler)
      init
      @@matches[key] = handler
    end

    def matches
      @@matches
    end

    def on(*args, env:, frames:)
      init

      handler = @@matches[args.join(' ')]
      if handler.respond_to? :call
        if handler.instance_of? Lambda
          handler.call(*args, env: env, frames: frames)
        elsif handler.instance_of? Block
          handler.call env: env, frames: frames
        else
          raise 'Unknown event handler type'
        end
      end
    end

    def trigger(*args, env:, frames:)
      init
      @@proceed += 1
      if @@proceed.zero?
        @@events.each do |e|
          e.call(*args, env: env,
                        frames: frames)
        end
      end
      @@proceed -= 1
    end
  end
end
