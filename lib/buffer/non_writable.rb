# non_writable.rb - module NonWritable

module NonWritable
  def ins _string
    say BELL
  end

  def del
    say BELL
  end

  def name
    "#{@name} (read only)"
  end
end

