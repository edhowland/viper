# redirection - class Redirection - root for RedirectStd* classes

require 'fiber'

# Wraps call to open in a Fiber. The method call returns the open File.
# The method close, resumes the Fiber, closing the File.
# The target expects to be something that resolves to a string when
# call frames:frames is called in this call frames:.
class Redirection
  def initialize target, mode='r'
    @target = target
    @mode = mode
  end
  def call frames:{}
    target = @target.call frames:frames
    @fiber = Fiber.new do
      File.open(target, @mode) do |f|
        Fiber.yield f
      end
    end
    @fiber.resume
  end
  def close
    @fiber.resume
  end
end
