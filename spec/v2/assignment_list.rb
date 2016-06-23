# assignment_list - class AssignmentList possible Assignments


class AssignmentList
  def initialize list=[]
    @storage = list
  end
  def call frames:
    @storage.each {|a| a.call(frames:frames) }
  end
end

