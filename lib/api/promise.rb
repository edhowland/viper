# promise.rb: class Promise - primitive attempt at Javascript-like promises



class Promise
  def initialize &blk
    @state = :pending
    @blk = blk
    @value = nil
    @error = nil
  @handle_resolve = ->(o) { o }
    @handle_reject = ->(e) { e }
  end
  attr_reader :state, :value, :error

  class << self

    def all(promises)
      self.new do |p|
        rejected = promises.select {|pr| pr.run.rejected? }
        if rejected.empty?
          p.resolve!(promises)
        else
          p.reject!(rejected)
        end
      end
    end


    # any returns all that resolve. Can get values by .map(&:value)
    def any(promises)
      self.new do |p|
        resolved = promises.select {|pr| pr.run.resolved? }
        unless resolved.empty?
          p.resolve!(resolved)
        else
          p.reject!(promises.select {|pr| pr.rejected? })
        end
      end
    end
    def all_selected(promises)
      selector = self.new do |p|
        p.resolve!(promises.map(&:run))
      end
      selector.extend Aggregation
      selector
    end
  end
  module Aggregation
    def aggregate_values
      @value.select(&:resolved?).map(&:value)
    end
  def aggregate_errors
    @value.select(&:rejected?).map(&:error)
  end
  end  
  def resolve!(obj)
    @state = :resolved
    @value = @handle_resolve.call(obj)
  end
  def reject!(obj)
    @state = :rejected
    @error = @handle_reject.call(obj)
  end
  # finalize handlers
  def then(&blk)
    @handle_resolve = blk
    self
  end
  def catch(&blk)
    @handle_reject = blk
    self
  end
  # main
  def run
    return self unless runnable?
    @blk.call(self)
    self
  rescue => err
    @handle_reject.call(err)
    self
  end


  # debug helpers
  def inspect
    "Promise: state: #{@state.to_s}"
  end
  def resolved?
    @state == :resolved
  end
  def pending?
    @state == :pending
  end
  def rejected?
    @state == :rejected
  end
  def runnable?
    pending?
  end

  def reset!
    @state = :pending
    @value = nil
    @error = nil
  end
end
