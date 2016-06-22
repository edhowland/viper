# assignment_list - class AssignmentList possible Assignments


class AssignmentList
  def initialize list=[]
    @storage = list
  end
  def call frames:
    frames.push       # push down for possible assignments
    @storage.each {|a| a.call(frames:frames) }
  end
end

