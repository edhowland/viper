# cparse - FFI method: cparse('command sting') - parses command
require_relative 'vcl_parser'
require_relative 'command_transform'



module Command
  def self.cparse(string)
    vcl = VCLParser.new
    trans = CommandTransform.new
    trans.apply(vcl.parse(string))
  end
end

Dispatch << Command
