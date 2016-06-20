# block - class Block - stores StatementList from vish parser


class Block
  def initialize statement_list
    @statement_list = statement_list
  end
  attr_reader :statement_list
end
