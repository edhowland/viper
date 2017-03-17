# io_factory - class IOFactory - constructs a factory object for a given class
# each object has an open and close method, possibly
# Implements the factory pattern. Returning facades for Ruby classes to work
# with Vish redirection requests

class IOFactory
  class << self
    def mk_facade(klass)
      {
        StringIO => StringIOFacade,
        BufNode => BufWriteFacade,
        Array => ArrayFacade
      }[klass]
    end

    def make(object)
      facade = mk_facade object.class
      if facade.nil?
        StringIOFacade.new(StringIO.new(''))
      else
        facade.new(object)
      end
    end
  end
end
