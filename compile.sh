#!/bin/bash
# compile.sh - compile files into ruby executable
/home/vagrant/dev/vish/bin/vishc --ruby -i ./env.rb -i ./viper_api.rb -o viper  -l a0.vs -l commander.vs normal.vs
