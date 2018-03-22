# vim.sh - load stuff into Vish scripts in ivs REPL
ivs -r ./env -r ./buffer_connector -l openf.vs -l registers.vs -l buffer.vs -l marks.vs -l startup.vs -l loop.vs $1


