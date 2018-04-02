# viper_api.rb - various API editor functions

require_relative 'buffer_requires'

module ViperApi
  def self.getcmd()
    parse = {
      "\u0012" => :ctrl_r,
      ':' => :colon,
      '/' => :fslash,
      'n' => :n,
      'N' => :N,
      '?' => :question,
      'f' => :f,
      'F' => :F,
      'w' => :w,
      'W' => :W,
      'j' => :j,
      'k' => :k,
      'h' => :h,
      'l' => :l,
      ' ' => :l,
      'L' => :L,
      'i' => :i,
      'I' => :I,
      'o' => :o,
      'O' => :O,
      'a' => :a,
      'A' => :A,
      'u' => :u,
      'r' => :r,
      '0' => :zero,
      '$' => :dollar,
      'p' => :p,
      'm' => { 'm' => :mm },
      'd' => {
        'd' => :dd,
        'w' => :dw,
        "'" => :dquote_m,
        'G' => :dG,
        '0' => :d0,
        '$' => :d_dollar,
        'g' => :dg
      },
      'g' => { 'g' => :gg },
      'G' => :G,
      'y' => { 
        'y' => :yy,
        "'" => :yquote_m
       },
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
  # contents of buffer
  def self.contents(b)
    b.to_s
  end
  # the current cursor
  def self.cursor(q)
    q.cursor
  end
  def self.span_of(b, span)
    b[span]
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
    begin
      b.undo
      ' undone '
    rescue UndoStackUnderflowError
      'no more undos'
    end
  end
  def self.redo(b, q)
    begin
      b.redo
      ' redone '
    rescue RedoStackOverflowError
      'no more redos'
    end
  end

  def self.delete_line(b, q)
    $registers.r1 = line(b, q)
    ln = q.line
    b.delete_at(ln)
    line(b, q)
  end

  # mark and region stuff
  def self.mark(b, q, name)
    c = q.cursor
    pos = c.first
    b.set_mark(name, pos)
    " mark #{name} set"
  end
  def self.region_of(b, q, name)
  pos = q.cursor.first
    b.region_of(name, pos)
  end
  def self.yank_region(b, q, span)
    $registers.tiny = b[span]
    ' region yanked '
  end
  def self.delete_region(b, q, span)
    yank_region(b, q, span)
    b.delete_at(span)
    ' region deleted '
  end

  # larger spans
  def self.delete_span(b, span)
    b.delete_at(span)
  end
  def self.to_bottom(q)
    q.cursor + Span.new(q.limit..q.limit)
  end
  def self.to_top(q)
    Span.new(0..0) + q.cursor
  end
  def self.to_eol(q)
  ln = q.line
    eol = Span.new(ln.last..(ln.last - 1))
    q.cursor + eol
  end
  def self.to_sol(q)
  ln = q.line
  sol = Span.new(ln.first..ln.first)
    sol + q.cursor
  end

  # more specific modifications
  def self.delete_inner_line(b, q)
    ln = q.line
    sp = Span.new(ln.first..(ln.last - 1))
    b.delete_at(sp)
    line(b, q)
  end

  # word stuff
  def self.word(b, q)
    sp = q.word
    b[sp]
  end
  def self.word_fwd(b, q)
    sp = q.word_fwd
    b[sp]
  end
  def self.delete_word(b, q)
    $registers.tiny = word(b, q)
    sp = q.word
    b.delete_at(sp)
    char(b, q)
  end

  # search stuff
  # search(query, regexp) - list of matching Spans for matches
  def self.search(regx, query)
    query.search_spans(regx)
  end
  def self.next(query)
    sp = query.next_result
    unless sp.nil?
      sp = Span.new(sp.first..sp.first)
      query.cursor = sp
    else
      Env.error('search not found')
    end
  end
  def self.prev(query)
    sp = query.prev_result
    unless sp.nil?
      sp = Span.new(sp.first..sp.first)
      query.cursor = sp
    else
      Env.error('reverse search not found')
    end
  end
end

Dispatch << ViperApi
