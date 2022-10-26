# promise.rb: class Promise - primitive attempt at Javascript-like promises
=begin

Usage:

p = Promise.new {|p| result = some_code(); result ? p.resolve!(result) : p.reject!(result) }

# ... constructor takes a block that (eventually) actually will run the  real code that the promise wraps

p.state
:pending
p.run
p.state
#=> :resolved
# or #=> :rejected


Available states:

:pending - Created, but not yet run
: resolved - Run and block succeeded
: rejected -  run, but block failed

# Unwrapping either the result, if resolved,  or the error if rejected

p.value
p.error

# Note: these get the value passed from .resolve!(obj) or .rejected!(err)

# Handlers for resolved and rejected varients
# Note these are optional, but will be used to chain Promise s togehter, if the .chain is called

p.then {|o| do_something_with_result(o) }
p.catch {|e| deal_with_error(e) }

# Note: both then and catch return the promise, so they can be changed together

p.then {|o| handle_ok(o) }.catch {|e| handle_err(e) }

# Note: the parameter passed to handler is the same as passed to  to either .resolved!(obj) or .reject!(err)
# The return from the then or the catch handler is either the .value or the .error attribute.
# This gives the oppertunity to modify the result result or do other processing on the value or error attributes


# resetting the state

p.reset!

# Resets the state so it can be re-run. Re-running the promise without first
#  .reset!, after the initial run, will ignore any further calls to passed in block
# to the constructor

p.runnable?

# returns true if state is :pending. Alias for .pending?

p.resolved? # true if promised was resolved
p.rejected? # true if the promise failed

# Aggregate class functions

Promise.all list_of_promisses
# Returns list, if, and only if, every promise in the list resolved

Promise.any list_of_promises
# Returns a new list of every Promise that resolved, and none that rejected

# See also, PromiseFinder. Subclass that adds .find  class method.
# PromiseFinder.find list_of_promises
# will return first Promise that resolved, nil, otherwise.

=end


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
