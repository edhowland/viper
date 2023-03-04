rem welcome_page.vsh
cond { test -X ":{lhome}/etc/no-viper-welcome-banner" } { will=not } else { will='' }
echo When Viper starts with no files to edit it will :will display the Welcome banner
echo You can view or change this behaviour with charm welcome "[remove] [restore]"
echo