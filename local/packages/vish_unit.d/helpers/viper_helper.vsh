rem viper_helper.vsh starts up the viper module
load viper
rem this next line covers the old 2.0.11 and 2.0.12.b cases where /v/events/ does not exist
mkdir /v/events/exit; touch /v/events/exit/1; touch /v/events/exit/*
rem this next line removes the at_exit proc so no ask to save does not happen after tests /v/events/2 is the vunit at_exit handler
test -f /v/events/exit/3 &&  rm /v/events/exit/3
