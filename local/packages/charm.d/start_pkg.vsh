rem start subcommand for the charm app
test -X ":{lhome}/etc/no-viper-welcome-banner" && exec { cat ":{lhome}/packages/charm.d/start.d/nothing-to-do.md"; exit }
cat ":{lhome}/packages/charm.d/start.d/welcome.md"
rm ":{lhome}/etc/no-viper-welcome-banner"
