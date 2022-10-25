# promise_finder.rb: class PromiseFinder < Promise - adds .find to Promise
# .find will find the first promise that returns resolved?, or   result of calling its none_found lambda

# require_relative 'promise'



class PromiseFinder < Promise
  class << self
    def find(promises)
      promises.find {|p| p.run; p.resolved? ? p :  false }
    end
  end
end