# pry_helper.rb - setup for VCL parser stuff

require_relative 'vcl_parser'

def vcl
  VCLParser.new
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