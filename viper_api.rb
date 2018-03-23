# viper_api.rb - various API editor functions

require_relative 'buffer_requires'

module ViperApi
  def self.getcmd()
    parse = {
      'j' => :j,
      'k' => :k,
      'h' => :h,
      'l' => :l,
      'd' => {
        'd' => :dd,
        'w' => :dw
      },
      'g' => { 'g' => :gg },
      'y' => { 'y' => :yy },
      'c' => {
        'c' => :cc,
        'w' => :cw
      },
      'Z' => { 'Z' => :ZZ },
    'q' => :q
    }
    ch = $stdin.getch
    x = parse[ch]
    if x.instance_of?(Hash)
      y = $stdin.getch
result = x[y]
    else
      result = parse[ch]
    end
    result
  end

  # API functions
  def self.mkbuf(string)
    SlicedBuffer.new(string)
  end

  def self.mkquery(buffer)
    GridQuery.new(buffer)
  end
  
  def self.right(b, q)
    sp=q.right
    b[sp]
  end
  def self.left(b, q)
    sp = q.left
    b[sp]
  end
def self.up(b, q)
  sp = q.up
  line = q.line
  b[line]
end
def self.down(b, q)
  sp = q.down
  line = q.line
  b[line]
end
end

Dispatch << ViperApi
