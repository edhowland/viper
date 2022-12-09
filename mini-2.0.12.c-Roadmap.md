# mini 2.0.12.c Roadmap

## Abstract

This new initerim release 2.0.12.c encapsulates the migration of the 
./scripts/0??_*.vsh  to to ./local/vish/modules/viper/0??_*.vsh
And the new ./local/vish/modulesviper/on_import.vsh which starts the whole ball
a-rolling.


## New script ./local/vish/modules/viper/0??_process_args.vsh

This script adds back in some CLI args that might be useful:

- -s source.vsh
- -e 'echo foo | cat' 

