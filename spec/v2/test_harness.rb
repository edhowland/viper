# test_harness.rb - sets up some variables for testing

 def harness key, as, klass, arg, redirs 

   asl =  Assignment.new key, StringLiteral.new(as)
   sl = StringLiteral.new arg
   return FrameStack.new, AssignmentList.new([asl]), ArgumentList.new([sl]), RedirectionList.new(redirs), klass.new
 end
 def  mkst as, cl, al, rl
  Statement.new(assignments:as, command:cl, arguments:al, redirections:rl)
  end

 def dbg key, as, klass, arg
   fs, as, al, rl, cl = harness key, as, klass, arg, [] 
   return fs, mkst(as, cl, al, rl) 
 end
