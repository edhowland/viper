rem environment.vsh loads up environment variables all caps become lowercase
test -z :(env VISH_INIT) || vish_init=:(env VISH_INIT)