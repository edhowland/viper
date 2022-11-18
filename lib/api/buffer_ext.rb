# buffer_ext.rb: module BufferExt

module BufferExt
  def blank_if_nil(b)
    b.nil? ? '' : b
  end
end
