# string_io_facade - class StringIOFacade - open method for StringIO

class StringIOFacade
  def initialize(stringio)
    @io = stringio
  end

  def open(path, mode)
    if mode == 'w'
      root = VirtualLayer.get_root
      root.creat path
    elsif mode == 'r'
      @io.rewind
      StringIO.new(@io.string)
    elsif mode == 'a'
      root = VirtualLayer.get_root
      node = root[path]
      if node.nil?
        root.creat path
      else
        @io.reopen(@io.string, 'a')
      end
    end
  end
end
