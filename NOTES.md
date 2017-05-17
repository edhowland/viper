# NOTES
Rubocop stuff
command: rubo.todo.cop
individual command: rubo.todo.cop -D lib/... /... .rb
Current line in .rubocop_todo.yml:
~ 155 
Add tests for rangify
--- Skipping over global variables for now

Implement new option: -B, --boot
  >> This runs boot script : etc/vishrc, then if -s scripts, if present
  >> Implemented -R --run options to run any loaded scripts then exit
  >> Must implement -V, --viper ... loads entire set of editor scripts