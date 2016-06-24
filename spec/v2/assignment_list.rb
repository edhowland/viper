# assignment_list - class AssignmentList possible Assignments


class AssignmentList
  def initialize list
    @storage = list || []
  end
  def call frames:
    @storage.each {|a| a.call(frames:frames) }
  end
  def to_s
    @storage.map {|a| a.to_s }.join(' ')
  end
end

