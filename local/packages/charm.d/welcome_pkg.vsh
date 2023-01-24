rem welcome the welcome subcommand of the charm package options are restore and remove
lpath=":{lhome}/packages/charm.d/welcome.d"
function safe_rm(fname) {
   test -X :fname && rm :fname
}
opt=:(third :argv)
not { test -z :opt } && load :opt
cond { test -X ":{lhome}/etc/no-viper-welcome-banner" } { will=not } else { will='' }
echo The following message will :will be displayed when Viper starts with no files to edit on the command line
echo '====='
echo
cat ":{lhome}/share/viper/docs/welcome-banner.md"
echo; echo '====='

