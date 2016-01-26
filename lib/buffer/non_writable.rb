# non_writable.rb - module NonWritable

# TODO: Module documentation
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
