# pry_helper.rb - methods to automate pry stuff
require_relative 'range_functions'
require_relative 'pt'


def npt
  PieceTable.new "0123ABC789"
end

def hello
  PieceTable.new 'hello world'
end

def do_undo(pt, meth)
  method, *args = meth
  pt.send method, *args
end

def ept
  PieceTable.new ''
end
def delete_all pt
  pt.delete 0, pt.to_s.length
end