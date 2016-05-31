# buffer.rb - class Buffer

# Buffer is the main buffer top level class. Almost all editor functions are deferred to this class.
class Buffer
  def initialize(string)
    @a_buff = StringBuffer.new ''
    @b_buff = StringBuffer.new string
    @dirty = false
    @name = 'unnamed'
    @mark_position = nil
    @match_data = nil
  end

  attr_accessor :name
  attr_reader :match_data

  def set_mark
    @mark_position = position
  end

  def set_if_not_set
    set_mark unless mark_set?
  end

  def unset_mark
    @mark_position = nil
  end

  def mark_set?
    !@mark_position.nil?
  end

  def mark
    @mark_position - position
  end

  def suppress(&_blk)
    @recordings_suppressed = true
    yield
    @recordings_suppressed = false
  end

  def dirty?
    @dirty
  end

  # dummy method. does nothing overriden in Recordable module
  def record(_method, *_args)
  end

  # Dummy save method. Does nothing in case ctrl_s pressed in ReadOnly or blank
  def save
  end

  def ins(string)
    @a_buff.push string
    @dirty = true
    record :ins, string
  end

  def del(string = ' ')
    raise BufferExceeded.new('Delete past beginning of buffer') if @a_buff.empty?
    @dirty = true
    value = @a_buff.cut(string.length * -1)
    record :del, value
    value
  end

  def fwd(count = 1)
    record :fwd, count
    count.times { @a_buff.push(@b_buff.shift) }
  end

  def back(count = 1)
    record :back, count
    count.times { @b_buff.unshift(@a_buff.pop) }
  end

  def at
    @b_buff[0]
  end

  def beg
    record :beg
    @b_buff = StringBuffer.new(to_s)
    @a_buff = StringBuffer.new ''
  end

  def fin
    record :fin
    @a_buff = StringBuffer.new(to_s)
    @b_buff = StringBuffer.new ''
  end

  def rchomp(string)
    return string[1..-1] if string[0] == "\n"
    string
  end

  def lline
    @a_buff.last_line
  end

  def rline
    @b_buff.first_line
  end

  def line
    lline + rline
  end

  def indent_level
    return line.length if line =~ /^\s*$/
    result = line =~ /[^\s]/
    result.nil? ? 0 : result
  end

  def col
    lline.length
  end

  def up
    raise BufferExceeded if position == 0
    suppress do
      pos = col
      back
      back until at == "\n" or position == 0
      back until col <= pos or position == 0
    end
    record :up
  end

  def front_of_line
    back @a_buff.rcount_nl
    fwd if at == NL
  end

  def back_of_line
    fwd @b_buff.count_nl
  end

  def look_ahead
    @b_buff.lines[0..9]
  end

  def clear
    @a_buff = StringBuffer.new ''
    @b_buff = StringBuffer.new ''
    @dirty = false
  end

  def copy
    raise MarkNotSet unless mark_set?
    value = if mark < 0
              @a_buff.copy(mark)
            else
              @b_buff.copy(mark)
            end
    unset_mark
    unset_mark
    value
  end

  def cut
    raise MarkNotSet unless mark_set?
    value = if mark < 1
              @a_buff.cut(mark)
            else
              @b_buff.cut(mark)
            end
    unset_mark
    @dirty = true
    value
  end

  def srch_fwd(regex)
    amount = @b_buff.index(regex)
    fwd(amount) unless amount.nil?
  end

  def srch_back(regex)
    amount = @a_buff.rindex(regex)
    back(amount * -1) unless amount.nil?
  end

  def position
    @a_buff.length
  end

  def down
    raise BufferExceeded if at.nil?
    suppress do
      pos = col
      fwd until at.nil? or at == "\n"
      fwd if at == "\n"
      fwd [line.chomp.length, pos].min
    end
    record :down
  end

  def goto(line_no)
    beg
    max_lines = @b_buff.lines.length
    ([max_lines, line_no].min - 1).times { down }
  end

  def goto_position(pos)
    offset = pos - position
    method = [nil, :fwd, :back][(offset <=> 0)]
    send(method, offset.abs) unless method.nil?
  end

  def remember(&_blk)
    saved = position
    yield self
    goto_position saved
  end

  def del_at(string = ' ')
    raise BufferExceeded.new('Delete past beginning of buffer') if @b_buff.empty?
    @dirty = true
    value = @b_buff.cut(string.length)
    record :del_at, value
    value
  end

  def overwrite!(string)
    @a_buff = StringBuffer.new ''
    @b_buff = StringBuffer.new string
  end

  # is this buffer able to be saved?
  def savable?
    false
  end

  def should_save?
    savable? and dirty?
  end

  def word_back
    @a_buff.rword_index
  end

  def match(regex)
    @match_data = @b_buff.to_s.match(regex)
    return @match_data[1] unless @match_data.nil?
  end

  def word_fwd
    match(/^(\w+)/)
  end

  def eob?
    @b_buff.length.zero?
  end

  def to_s
    @a_buff.to_s + @b_buff.to_s
  end

  # file associations: just return :default, but subclassed in FileBuffer
  def association
    :default
  end

  def line_number
    @a_buff.lines.length + 1
  end

  def restore
    raise NonRestorableException.new self.class.name
  end
end
