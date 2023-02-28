rem environment.vsh loads up environment variables all caps become lowercase
test -z :(env VISH_INIT) || vish_init=:(env VISH_INIT)
USER=:(env USER)
LPATH=:(env LPATH); test -z :LPATH || LPATH=:(cd :proj; realpath :LPATH)
MPATH=:(env MPATH); test -z :MPATH || MPATH=:(cd :proj; realpath :MPATH)
SHELL=:(env SHELL)
PATH=:(env PATH)



