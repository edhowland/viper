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
end

Dispatch << BufferConnector
