# block - class Block - stores StatementList from vish parser

module LineNumberable
  def line_number
    @line_number
  end

  def line_number=(value)
    @line_number = value
  end
end

class Block
  def initialize(statement_list)
    @statement_list = statement_list
  end
  attr_reader :statement_list
  def call(env:, frames:)
    @statement_list.each do |s|
      begin
        # Event.trigger *(s.to_s.split), env:env, frames:frames
        Event.on(*s.to_s.split, env: env, frames: frames)
        s.call env: env, frames: frames
      rescue => err
        err.extend LineNumberable
        err.line_number = s.line_number
        raise err
      end
    end
    frames[:exit_status]
  end

  def to_s
    '{ ' + @statement_list.map(&:to_s).join(';') + ' }'
  end
end
