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

 >> If no scripts loaded, just runs the boot scripts in ./etc/vishrc, then exits:
 >> ./bin/viper -B -R
 >> echo $?
 >> 0
 
  >> if used with -s, runs that scripts and exits
  >> ./bin/viper -B -R -s file.vsh
  >> ...
  >> Useful for debugging
 

# Scratch  function implementation
Starting:
>> use -e 'open x; scratch'
>> Or use Ctrl-n to create new scratch buffers
>> Will not ask to save buffer if /.no_ask2_save is present
>> But can still with save or Ctrl-s
