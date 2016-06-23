# redirection - class Redirection - root for RedirectStd* classes

require 'fiber'

# Wraps call to open in a Fiber. The method call returns the open File.
# The method close, resumes the Fiber, closing the File.
# The target expects to be something that resolves to a string when
# call frames:frames is called in this call frames:.
# the handle attribute is the file handle returned from the Fiber.yield
class Redirection
  def initialize target, mode='r'
    @target = target
    @mode = mode
    @handle = nil
  end
  attr_reader :handle
  def call frames:{}
    target = @target.call frames:frames
    @fiber = Fiber.new do
      File.open(target, @mode) do |f|
        Fiber.yield f
      end
    end
    # kicks off the fiber's block initially. setting @handle and returning it
    @handle = @fiber.resume  
  end
  def close
    @fiber.resume
  end
end
