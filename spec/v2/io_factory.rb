# io_factory - class IOFactory - constructs a factory object for a given class
# each object has an open and close method, possibly
# Implements the factory pattern. Returning facades for Ruby classes to work 
# with Vish redirection requests

class IOFactory
  class << self
    def make object
      knowns = {
        StringIO => StringIOFacade,
        BufNode => BufWriteFacade
      }
      klass = object.class
      facade = knowns[klass]
      unless facade.nil?
        facade.new(object)
      else
        StringIOFacade.new(StringIO.new(''))
      end
    end
  end
end
