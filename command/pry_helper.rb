# pry_helper.rb - setup for VCL parser stuff
# import some Vish internals
require_relative '/home/vagrant/dev/vish/lib/runtime'


require_relative 'vcl_parser'
require_relative 'command_transform'

# for comparison
require_relative 'vish_parser'
require_relative 'sexp_transform'

def ps
  [VishParser.new, SexpTransform.new]
end

def vcl
  [VCLParser.new, CommandTransform.new]
end
#around -   capture syntax failure
def around &blk
  begin
    yield
  rescue => failure
      puts failure.parse_failure_cause.ascii_tree
    end
    puts failure.parse_failure_cause.ascii_tree

end