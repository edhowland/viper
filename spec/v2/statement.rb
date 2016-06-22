# statement - classStatement - statement node in AST

# Represents a statement of the form:
# [var=val ...] command [arg1 arg2 ...] [redirection_op target ...] (# comment)?
# At runtime, the statement proceeds in 2 phases:
# Phase I : Evaluate all the command expansion/substitution stuff
# Phase II : Having the context proceed as if the substitutions were substituted. Run the command
# Note: Must remember to close any open file descriptors
class Statement
  def initialize assignments:[], command:NullCommand.new, args:[], redirects:[]
    @assignments = assignments
    @command = command
    @args = args
    @redirects = redirects
    @variables = {}
  end
  def call
    # TODO implement this
    # In bash, redirects are setup first
    # @redirects.each {|r| r.prepare }
    #  @args.each {|a| a.call, .prepare }
    # assignments.each {|a| a.call, .prepare } # Only assigns for this call
    # @command.call(@args, env:@variables)
  end
end

