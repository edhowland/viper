# non_writable.rb - module NonWritable

# NonWritable module included in Buffers which are not savable.
module NonWritable
  def ins(_string)
    say BELL
  end

  def del
    say BELL
  end

  def name
    "#{@name} (read only)"
  end
end
