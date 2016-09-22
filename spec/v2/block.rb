# block - class Block - stores StatementList from vish parser

class Block
  def initialize statement_list
    @statement_list = statement_list
  end
  attr_reader :statement_list
  def call env:, frames:
    @statement_list.each do |s|
      Event.trigger *(s.to_s.split), env:env, frames:frames
      s.call env:env, frames:frames 
    end
    frames[:exit_status]
  end
  def to_s
    '{ ' + @statement_list.map {|s| s.to_s }.join(';') + ' }'
  end
end
