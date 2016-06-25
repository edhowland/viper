# statement - classStatement - statement node in AST

# Represents a statement of the form:
# [var=val ...] command [arg1 arg2 ...] [redirection_op target ...] (# comment)?
# At runtime, the statement proceeds in 2 phases:
# Phase I : Evaluate all the command expansion/substitution stuff
# Phase II : Having the context proceed as if the substitutions were substituted. Run the command
class Statement
  def initialize assignments:AssignmentList.new([]), command:Command.new(command_name:'null')
    @assignments = assignments
    @command = command
  end
  attr_reader :command

  # proceeding in the phase order:
  # set up assignments, redirects and args
  # Then pass a block to redirection_list.call
  def call env:, frames:
    locals = frames.clone
    locals.push
    @assignments.call frames:locals
    @command.call env:env, frames:frames
  end
  def to_s
    @assignments.to_s + ' ' +
    @command.to_s + ' ' +
    @redirects.to_s
  end

end

