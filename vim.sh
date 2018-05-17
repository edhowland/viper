#!/bin/bash
# vim.sh - run ivs REPL with viper stuff
ivs -r ./env -r ./viper_api -r ./command/cparse a1.vs command/command.vs normal.vs  util.vs
