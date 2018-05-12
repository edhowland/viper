#!/usr/bin/env ruby
# vish.erb - template for compiler output to Ruby file.rb
# 

require_relative "/home/vagrant/dev/vish/runtime/vish_runtime"

### Foreign requires with -r, --require vishc compiler flag(s)

###

### Included files with -i, --include vishc compiler flag(s)

## Included file: env.rb
# env.rb - module Env - additional commands in Vish runtime

module Env
  # prints - like puts w/o newline
  def self.prints(string)
    print string
  end
  # error(string) prints string w/padded spaces to stderr
  def self.error(string)
    $stderr.print " #{string} "
    raise string
  end

  # sym(string) - Symbolize any string
  def self.sym(string)
    string.to_sym
  end
  #
  # input read loop
  def self.getchars()
    result = ''
    ch = ' '
    until ch.ord == 27
      ch = $stdin.getch
      print ch
      result << ch unless ch.ord == 27
    end
    result
  end


  # convert string to regex
  def self.regex(string)
    Regexp.new(string)
  end

  # return this many spaces
  def self.spaces(count)
    ' ' * count
  end
  # is a space?
  def self.space?(char)
    char == ' '
  end
  end

  Dispatch << Env
  
## end of  file: env.rb

## Included file: viper_api.rb
# viper_api.rb - various API editor functions

require_relative 'buffer_requires'
require_relative 'parse_normal'

module ViperApi
  def self.getcmd()
    parse_normal()
  end


  # API functions
  def self.save_cmd(cmd)
    $registers.last_cmd = cmd
  end
  def self.last_cmd
    $registers.last_cmd
  end
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
    right(b, q)
    sp = q.word_fwd
    b[sp]
  end
  def self.word_back(b, q)
    sp = q.word_back
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

  # buffer restore stuff
  def self.rewind(buffer)
    begin
      loop { buffer.undo }
    rescue UndoStackUnderflowError
      'buffer restored'
    end

  end

  # indentation stuff
  def self.indented?(count, b, q)
    sp = q.line
    sp = Span.new(sp.first..(sp.first+count - 1))
    b[sp] == (' ' * count)
  end
  def self.cursor_save(q, &blk)
    c = q.cursor
    yield
    q.cursor = c
  end
  def self.indent(count, b, q)
  cursor_save(q) do
    sp = q.line
    c = Span.new(sp.first..sp.first)
    q.cursor = c
    insert((' ' * count), b, q)
    l = q.line
    c = Span.new(l.first..l.first)
    q.cursor = c
    end
    q.cursor.incr(count)
  end
  def self.outdent(count, b, q)
    if indented?(count, b, q)
      sp = q.line
      sp = Span.new(sp.first..(sp.first + count - 1))
      b.delete_at(sp)
      sp = q.line
      q.cursor = Span.new(sp.first..sp.first)
    end
  end
end

Dispatch << ViperApi

## end of  file: viper_api.rb

###

ctx = Context.new
bc = ByteCodes.new
### emission of bytecodes
bc.codes = [:cls, :pushl, :mkattr, :pushl, [:pushl, :v, :swp, :set, :drop, :pushl, :k, :swp, :set, :drop], :pushl, [:pushl, :s, :pushv, :k, :pushl, "!", :pushl, 2, :pushl, :cat, :icall, :pushl, 1, :pushv, :mksym, :ncall, :assign, :pushv, :k, :pushl, [], :pushl, [:pushv, :v], :pushl, 2, :pushl, :_mklambda, :icall, :pushl, 2, :pushv, :mkpair, :ncall, :pushv, :s, :pushl, [:pushl, :x, :swp, :set, :drop], :pushl, [:pushl, :v, :pushv, :x, :assign, :pushv, :v], :pushl, 2, :pushl, :_mklambda, :icall, :pushl, 2, :pushv, :mkpair, :ncall, :pushl, 2, :pushv, :mkobject, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :keys, :pushl, [:pushl, :obj, :swp, :set, :drop], :pushl, [:pushv, :obj, :pushl, :keys, :pushl, 2, :pushv, :xmit, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :values, :pushl, [:pushl, :obj, :swp, :set, :drop], :pushl, [:pushv, :obj, :pushl, :values, :pushl, 2, :pushv, :xmit, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :car, :pushl, [:pushl, :l, :swp, :set, :drop], :pushl, [:pushv, :l, :pushl, 1, :pushv, :key, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :cdr, :pushl, [:pushl, :l, :swp, :set, :drop], :pushl, [:pushv, :l, :pushl, 1, :pushv, :value, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :cadr, :pushl, [:pushl, :l, :swp, :set, :drop], :pushl, [:pushv, :l, :pushl, 1, :pushv, :cdr, :ncall, :pushl, 1, :pushv, :car, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :cddr, :pushl, [:pushl, :l, :swp, :set, :drop], :pushl, [:pushv, :l, :pushl, 1, :pushv, :cdr, :ncall, :pushl, 1, :pushv, :cdr, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :caddr, :pushl, [:pushl, :l, :swp, :set, :drop], :pushl, [:pushv, :l, :pushl, 1, :pushv, :cddr, :ncall, :pushl, 1, :pushv, :car, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :cdddr, :pushl, [:pushl, :l, :swp, :set, :drop], :pushl, [:pushv, :l, :pushl, 1, :pushv, :cddr, :ncall, :pushl, 1, :pushv, :cdr, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :list_length, :pushl, [:pushl, :l, :swp, :set, :drop], :pushl, [:pushv, :l, :pushl, 1, :pushv, :null?, :ncall, :jmprf, 4, :pushl, 0, :fret, :pushl, 1, :pushv, :l, :pushl, 1, :pushv, :cdr, :ncall, :pushl, 1, :pushv, :list_length, :ncall, :add], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :undefined?, :pushl, [:pushl, :key, :swp, :set, :drop], :pushl, [:pushv, :key, :pushl, 0, :pushv, :binding, :ncall, :pushl, 2, :pushv, :_undefined?, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :map, :pushl, [:pushl, :fn, :swp, :set, :drop, :pushl, :coll, :swp, :set, :drop], :pushl, [:pushv, :coll, :pushl, 1, :pushv, :empty?, :ncall, :jmprf, 7, :pushl, 0, :pushl, :mkvector, :icall, :fret, :pushv, :coll, :pushl, 1, :pushv, :head, :ncall, :pushl, 1, :pushv, :fn, :ncall, :pushl, 1, :pushl, :mkvector, :icall, :pushv, :coll, :pushl, 1, :pushv, :tail, :ncall, :pushv, :fn, :pushl, 2, :pushv, :map, :ncall, :add], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :null, :pushl, 0, :pushv, :mknull, :ncall, :assign, :pushl, :version, :pushl, 0, :pushv, :version, :ncall, :assign, :pushl, :pwd, :pushl, [], :pushl, [:pushl, 0, :pushv, :pwd, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :file_txt, :pushl, [:pushl, :file, :swp, :set, :drop], :pushl, [:pushv, :file, :pushl, 1, :pushv, :fread, :ncall, :pushl, 1, :pushv, :mkbuf, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :openf, :pushl, [:pushl, :fname, :swp, :set, :drop], :pushl, [:pushl, :b, :pushv, :fname, :pushl, 1, :pushv, :file_txt, :ncall, :assign, :pushl, :q, :pushv, :b, :pushl, 1, :pushv, :mkquery, :ncall, :assign, :pushv, :b, :pushv, :q, :pushv, :fname, :pushl, 3, :pushl, :mkvector, :icall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :shift_width, :pushl, 2, :assign, :pushl, :until, :pushl, [:pushl, :blk, :swp, :set, :drop, :pushl, :e, :swp, :set, :drop], :pushl, [:pushl, 0, :pushv, :e, :ncall, :jmprf, 4, :pushl, "", :fret, :pushl, 0, :pushv, :blk, :ncall, :pushv, :e, :pushv, :blk, :pushl, 2, :pushv, :until, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :times, :pushl, [:pushl, :fn, :swp, :set, :drop, :pushl, :count, :swp, :set, :drop], :pushl, [:pushv, :count, :pushl, 2, :less, :jmprf, 7, :pushl, 0, :pushv, :fn, :ncall, :fret, :pushl, 0, :pushv, :fn, :ncall, :pushv, :count, :pushl, 1, :sub, :pushv, :fn, :pushl, 2, :pushv, :times, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :_times, :pushl, [:pushl, :fn, :swp, :set, :drop, :pushl, :count, :swp, :set, :drop], :pushl, [:pushl, :result, :pushl, "", :assign, :pushv, :count, :pushl, 1, :pushv, :zero?, :ncall, :jmprf, 4, :pushv, :result, :fret, :pushl, :count, :pushv, :count, :pushl, 1, :sub, :assign, :pushl, :result, :pushl, 0, :pushv, :fn, :ncall, :assign, :pushv, :result, :pushl, 1, :pushv, :print, :ncall, :jmpr, -36], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :putm, :pushl, :put_tiny, :assign, :pushl, :normal, :pushl, [], :pushl, [:pushl, :f, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :char, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :j, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :down, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :k, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :up, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :h, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :left, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :l, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :right, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :L, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :line, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :gg, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :top, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :G, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :bottom, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :yy, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, :putm, :pushl, :put_line, :assign, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :yank_line, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :yquotem, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, :putm, :pushl, :put_tiny, :assign, :pushv, :_b, :pushv, :q, :pushv, :_b, :pushv, :q, :pushl, :m, :pushl, 3, :pushv, :region_of, :ncall, :pushl, 3, :pushv, :yank_region, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :y0, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, :putm, :pushl, :put_tiny, :assign, :pushv, :_b, :pushv, :q, :pushv, :q, :pushl, 1, :pushv, :to_sol, :ncall, :pushl, 3, :pushv, :yank_region, :ncall, :pushl, " yanked to fron of line "], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :ydollar, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, :putm, :pushl, :put_tiny, :assign, :pushv, :_b, :pushv, :q, :pushv, :q, :pushl, 1, :pushv, :to_eol, :ncall, :pushl, 3, :pushv, :yank_region, :ncall, :pushl, " yanked to end of line "], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :dquotem, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, :putm, :pushl, :put_tiny, :assign, :pushv, :_b, :pushv, :q, :pushv, :_b, :pushv, :q, :pushl, :m, :pushl, 3, :pushv, :region_of, :ncall, :pushl, 3, :pushv, :delete_region, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :p, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushv, :putm, :pushl, 3, :pushv, :put, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :x, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, :putm, :pushl, :put_tiny, :assign, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :delete_char, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :zero, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :sol, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :dollar, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :eol, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :u, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :undo, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :ctrl_r, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :redo, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :dd, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, :putm, :pushl, :put_line, :assign, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :delete_line, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :d0, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, :put, :pushl, :put_tiny, :assign, :pushv, :_b, :pushv, :q, :pushl, 1, :pushv, :to_sol, :ncall, :pushl, 2, :pushv, :delete_span, :ncall, :pushl, " delete to start of line "], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :ddollar, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, :putm, :pushl, :put_tiny, :assign, :pushv, :_b, :pushv, :q, :pushl, 1, :pushv, :to_eol, :ncall, :pushl, 2, :pushv, :delete_span, :ncall, :pushl, " delete to end of line "], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :dgg, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, :putm, :pushl, :put_tiny, :assign, :pushv, :_b, :pushv, :q, :pushl, 1, :pushv, :to_top, :ncall, :pushl, 2, :pushv, :delete_span, :ncall, :pushl, " delete to top of buffer "], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :dG, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, :putm, :pushl, :put_tiny, :assign, :pushv, :_b, :pushv, :q, :pushl, 1, :pushv, :to_bottom, :ncall, :pushl, 2, :pushv, :delete_span, :ncall, :pushl, " delete to bottom of buffer "], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :cc, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, :putm, :pushl, :put_tiny, :assign, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :delete_inner_line, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :i, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :i, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, " insert mode ", :pushl, 1, :pushv, :prints, :ncall, :pushl, 0, :pushv, :getchars, :ncall, :pushv, :_b, :pushv, :q, :pushl, 3, :pushv, :insert, :ncall, :pushl, " normal mode "], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :I, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :sol, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :i, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :a, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :right, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :i, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :A, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :eol, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :i, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :o, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :eol, :ncall, :pushl, "\n", :pushl, 1, :pushl, :cat, :icall, :pushv, :_b, :pushv, :q, :pushl, 3, :pushv, :insert, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :a, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :_i_nl, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, 0, :pushv, :getchars, :ncall, :pushl, "\n", :pushl, 1, :pushl, :cat, :icall, :add, :pushv, :_b, :pushv, :q, :pushl, 3, :pushv, :insert, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :O, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :sol, :ncall, :pushl, " open above ", :pushl, 1, :pushv, :prints, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :_i_nl, :ncall, :pushl, " normal mode ", :pushl, 1, :pushv, :prints, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :P, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :sol, :ncall, :pushv, :_b, :pushv, :q, :pushv, :putm, :pushl, 3, :pushv, :put, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :line, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :F, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :word, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :w, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :word_fwd, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :dw, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :delete_word, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :cw, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :dw, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :i, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :mm, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, :m, :pushl, 3, :pushv, :mark, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :fslash, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, " search ", :pushl, 1, :pushv, :prints, :ncall, :pushl, :term, :pushl, 0, :pushv, :read, :ncall, :assign, :pushv, :term, :pushl, 1, :pushv, :regex, :ncall, :pushv, :q, :pushl, 2, :pushv, :search, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :n, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :question, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, " reverse search ", :pushl, 1, :pushv, :prints, :ncall, :pushl, :term, :pushl, 0, :pushv, :read, :ncall, :assign, :pushv, :term, :pushl, 1, :pushv, :regex, :ncall, :pushv, :q, :pushl, 2, :pushv, :search, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :N, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :n, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :q, :pushl, 1, :pushv, :next, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :F, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :N, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :q, :pushl, 1, :pushv, :prev, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :F, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :colon, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushl, "command", :pushl, 1, :pushv, :prints, :ncall, :pushl, 0, :pushv, :read, :ncall, :pushv, :_b, :pushv, :q, :pushl, 3, :pushv, :commander, :ncall, :pushl, 1, :pushv, :prints, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :langle, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :shift_width, :pushv, :_b, :pushv, :q, :pushl, 3, :pushv, :outdent, :ncall, :pushl, " line outdented "], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :rangle, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :shift_width, :pushv, :_b, :pushv, :q, :pushl, 3, :pushv, :indent, :ncall, :pushl, " line indented "], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :hash, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :q, :pushl, 1, :pushv, :cursor, :ncall, :pushl, 1, :pushv, :inspect, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :caret, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :sol, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :char, :ncall, :pushl, 1, :pushv, :space?, :ncall, :not, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :right, :ncall, :pushl, 2, :pushv, :until, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :char, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :e, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :char, :ncall, :pushl, 1, :pushv, :space?, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :right, :ncall, :pushl, 2, :pushv, :until, :ncall, :pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :left, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :b, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 2, :pushv, :word_back, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :period, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:pushv, :_b, :pushv, :q, :pushl, 0, :pushv, :last_cmd, :ncall, :pushl, 3, :pushv, :nosave_perf_command, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :ZZ, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :_b, :swp, :set, :drop], :pushl, [:int, :_exit], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, 0, :pushv, :binding, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :norm, :pushl, 0, :pushv, :normal, :ncall, :assign, :pushl, :command, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :b, :swp, :set, :drop], :pushl, [:pushl, :result, :pushl, 0, :pushv, :getcmd, :ncall, :assign, :pushl, :count, :pushv, :result, :pushl, 0, :index, :assign, :pushl, :cmd, :pushv, :result, :pushl, 1, :index, :assign, :pushv, :b, :pushv, :q, :pushv, :count, :pushv, :cmd, :pushv, :norm, :pushl, 5, :pushv, :perf_command, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :nosave_perf_command, :pushl, [:pushl, :cmd, :swp, :set, :drop, :pushl, :q, :swp, :set, :drop, :pushl, :b, :swp, :set, :drop], :pushl, [:pushl, :bind, :pushl, 0, :pushv, :normal, :ncall, :assign, :pushl, :fn, :pushv, :bind, :pushv, :cmd, :index, :assign, :pushv, :fn, :pushl, 1, :pushv, :undefined?, :ncall, :jmprf, 11, :pushl, "key not found", :pushl, 1, :pushv, :error, :ncall, :pushl, "", :fret, :pushv, :b, :pushv, :q, :pushl, 2, :pushv, :fn, :ncall, :pushl, 1, :pushv, :prints, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :perf_command, :pushl, [:pushl, :bind, :swp, :set, :drop, :pushl, :cmd, :swp, :set, :drop, :pushl, :count, :swp, :set, :drop, :pushl, :q, :swp, :set, :drop, :pushl, :b, :swp, :set, :drop], :pushl, [:pushl, :fn, :pushv, :bind, :pushv, :cmd, :index, :assign, :pushv, :fn, :pushl, 1, :pushv, :undefined?, :ncall, :jmprf, 11, :pushl, "key not found", :pushl, 1, :pushv, :error, :ncall, :pushl, "", :fret, :pushv, :cmd, :pushl, :period, :neq, :jmprf, 8, :pushv, :cmd, :pushl, 1, :pushv, :save_cmd, :ncall, :pushv, :count, :pushl, [], :pushl, [:pushv, :b, :pushv, :q, :pushl, 2, :pushv, :fn, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :pushl, 2, :pushv, :times, :ncall, :pushl, 1, :pushv, :prints, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :go, :pushl, [], :pushl, [:pushv, :buf, :pushv, :q, :pushl, 2, :pushv, :line, :ncall, :pushl, 1, :pushv, :prints, :ncall, :pushv, :buf, :pushv, :q, :pushl, 2, :pushv, :command, :ncall, :jmpr, -10], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :key_bound?, :pushl, [:pushl, :fn, :swp, :set, :drop], :pushl, [:pushl, :x, :pushl, 0, :pushv, :normal, :ncall, :assign, :pushv, :x, :pushv, :fn, :index, :pushl, 1, :pushv, :undefined?, :ncall, :not], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :get_keyfn, :pushl, [:pushl, :name, :swp, :set, :drop], :pushl, [:pushl, :bind, :pushl, 0, :pushv, :normal, :ncall, :assign, :pushv, :bind, :pushv, :name, :index], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :commands, :pushl, [], :pushl, [:pushl, :w, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :b, :swp, :set, :drop], :pushl, [:pushv, :b, :pushl, 1, :pushv, :contents, :ncall, :pushv, :file_name, :pushl, 2, :pushv, :fwrite, :ncall, :pushl, "s", :pushl, "a", :pushl, "v", :pushl, "e", :pushl, " ", :pushl, "f", :pushl, "i", :pushl, "l", :pushl, "e", :pushl, " ", :pushv, :file_name, :pushl, 11, :pushl, :cat, :icall, :pushl, 1, :pushv, :prints, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :q!, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :b, :swp, :set, :drop], :pushl, [:int, :_exit], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :wq, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :b, :swp, :set, :drop], :pushl, [:pushv, :b, :pushv, :q, :pushl, 2, :pushv, :w, :ncall, :pushv, :b, :pushv, :q, :pushl, 2, :pushv, :q!, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :rew, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :b, :swp, :set, :drop], :pushl, [:pushv, :b, :pushl, 1, :pushv, :rewind, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, 0, :pushv, :binding, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :commander, :pushl, [:pushl, :q, :swp, :set, :drop, :pushl, :b, :swp, :set, :drop, :pushl, :c, :swp, :set, :drop], :pushl, [:pushl, :co, :pushv, :c, :pushl, 1, :pushv, :sym, :ncall, :assign, :pushl, :x, :pushl, 0, :pushv, :commands, :ncall, :assign, :pushl, :fn, :pushv, :x, :pushv, :co, :index, :assign, :pushv, :fn, :pushl, 1, :pushv, :undefined?, :ncall, :jmprf, 11, :pushl, "command not found", :pushl, 1, :pushv, :error, :ncall, :pushl, "", :fret, :pushv, :b, :pushv, :q, :pushl, 2, :pushv, :fn, :ncall], :pushl, 2, :pushl, :_mklambda, :icall, :assign, :pushl, :argv, :pushl, 0, :pushv, :getargs, :ncall, :assign, :pushl, :tup, :pushv, :argv, :pushl, 0, :index, :pushl, 1, :pushv, :openf, :ncall, :assign, :pushl, :buf, :pushv, :tup, :pushl, 0, :index, :assign, :pushl, :q, :pushv, :tup, :pushl, 1, :index, :assign, :pushl, :file_name, :pushv, :tup, :pushl, 2, :index, :assign, :pushl, :norm, :pushl, 0, :pushv, :normal, :ncall, :assign, :pushl, 0, :pushv, :go, :ncall, :halt]
###
ci = CodeInterpreter.new bc, ctx

# Main
# TODO uncomment the following line:
p ci.run
