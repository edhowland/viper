# pry_helper.rb - methods to automate pry stuff
require_relative 'range_functions'
require_relative 'pt'


def npt
  PieceTable.new "0123ABC789"
end

def hello
  PieceTable.new 'hello world'
end