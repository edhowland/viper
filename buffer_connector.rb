# buffer_connector.rb - cmodule BufferConnector - Vish runtime connections to 
# Ruby  SlicedBuffer, GridQuery, etc
require_relative 'buffer_requires'


module  BufferConnector
  def self.mkbuffer(string)
    SlicedBuffer.new(string)
  end

  def self.mkquery(buffer)
    GridQuery.new(buffer)
  end

  def self.line(query)
    query.line
  end

  def self.slice(buffer, span)
    buffer[span]
  end
  def self.cursor(query)
    query.cursor
  end
  def self.up(query)
    query.up
  end
  def self.down(query)
    query.down
  end
  def self.left(query)
    query.left
  end
  def self.right(query)
    query.right
  end
  def self.sol(query)
    query.sol
  end
  def self.eol(query)
    query.eol
  end
  def self.top(query)
    query.top
  end
  def self.bottom(query)
    query.bottom
  end
  # modification commands
  def self.insert(string, buffer, span)
    buffer.insert_at(span, string)
  end
  def self.delete(span, buffer)
    buffer.delete_at(span)
  end
  def self.undo(buffer)
    begin
      buffer.undo
      'Undone'
    rescue => err
      err.message
    end
  end
  def self.redo(buffer)
    begin
      buffer.redo
      'Redone'
    rescue => err
      err.message
    end
  end
  # output entire buffer
  def self.contents(buffer)
    buffer.to_s
  end

  # helpers for chars not likely to translate to symbols: 0, $, etc.
  def self.tr(ch)
    case ch
    when ' ' # space
      :l  # right
    when '0'
      :sol
      when '$'
        :eol
        when 'h', 'j', 'k','l','y','p','L','Q','g','G','d','x','u','r','i','o','f','Z','Y','m','a','A','I'
          ch.to_sym
      else
        :unbound
    end
  end
end

Dispatch << BufferConnector