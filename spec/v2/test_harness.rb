# test_harness.rb - sets up some variables for testing

 def harness arg, redirs, klass
   sl = StringLiteral.new arg
   return FrameStack.new, AssignmentList.new([]), ArgumentList.new([sl]), RedirectionList.new(redirs), klass.new
 end
