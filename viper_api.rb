# viper_api.rb - various API editor functions

require_relative 'buffer_requires'

module ViperApi
  def self.getcmd()
    parse = {
      "\u0012" => :ctrl_r,
      'f' => :f,
      'j' => :j,
      'k' => :k,
      'h' => :h,
      'l' => :l,
      'L' => :L,
      'i' => :i,
      'a' => :a,
      'A' => :A,
      'u' => :u,
      'r' => :r,
      '0' => :zero,
      '$' => :dollar,
      'p' => :p,
      'd' => {
        'd' => :dd,
        'w' => :dw
      },
      'g' => { 'g' => :gg },
      'G' => :G,
      'y' => { 'y' => :yy },
      'Y' => :yy,
      'c' => {
        'c' => :cc,
        'w' => :cw
      },
      'x' => :x,
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

  def self.char(b, q)
    sp = q.cursor
    b[sp]
  end

  def self.right(b, q)
    sp=q.right
    b[sp]
  end
  def self.left(b, q)
    sp = q.left
    b[sp]
  end
  def self.line(b, q)
    ln = q.line
    b[ln]
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
  # line stuff
  def self.eol(b, q)
    sp=q.eol
    char(b, q)
  end
  def self.sol(b, q)
    sp = q.sol
    char(b, q)
  end

  def self.top(b, q)
    sp = q.top
    line(b, q)
  end
  def self.bottom(b, q)
    sp = q.bottom
    line(b, q)
  end

  # insertion/append, etc.
  def self.insert(string, b, q)
    sp = q.cursor
    b.insert_at(sp, string)
  end
  def self.put(b, q, method)
    self.send(method, b, q)
  end
  def self.put_tiny(b, q)
    q.right
    insert($registers.tiny, b, q)
    char(b, q)
  end
  def self.delete_char(b, q)
    sp = q.cursor
    $registers.tiny = b[sp]
    b.delete_at(sp)
    char(b, q)
  end
  def self.put_line(b, q)
    down(b, q)
    insert($registers.r1, b, q)
    line(b, q)
  end

  # register stuff
  def self.yank_line(b, q)
    $registers.r1 = line(b, q)
    count = 1 # for later
    "#{count} line yanked"
  end

  # undo/redo stuff
  def self.undo(b, q)
    b.undo
    ' undone '
  end
  def self.redo(b, q)
    b.redo
    ' redone '
  end

  def self.delete_line(b, q)
    $registers.r1 = line(b, q)
    ln = q.line
    b.delete_at(ln)
    line(b, q)
  end
end

Dispatch << ViperApi
