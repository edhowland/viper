# mini 2.0.12.c Roadmap

## Abstract

This new interim release 2.0.12.c encapsulates the migration of the 
./scripts/0??_*.vsh  to to ./local/vish/modules/viper/0??_*.vsh
And the new ./local/vish/modulesviper/on_import.vsh which starts the whole ball
a-rolling.



## Add back in the at_exit stuff  so than you press ctrl_q in viper,
you get the at_exit behaviour, to check for unsaved files in the open buffers.

checkmark


## Make sure that the :mpath variable is searched

### Current import fn only looks in :vhome/local/vish/modules/*

checkmark

### After 2.0.12.c:

:vhome/local/vish/modules::vhome/local/viper/modules

####  create new function find_first(name, list)


Use with :ifs

checkmark


## New script ./local/vish/modules/viper/0??_process_args.vsh

This script adds back in some CLI args that might be useful:

- -s source.vsh
- -e 'echo foo | cat' 



## Create the ./viper.rb a copy of ./vish.rb but that  insteads loads viper package

### TODO: Create meta-package vip that loads viper package

Currently, this is hard coded in ./viper.rb in startup veval call.

