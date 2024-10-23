# charm config alias
# alias the subcommand  charm config alias that outputs 4 alias commands for you
# You  might want this method instead of charm config path
# If  you  redirect this command to a file and then source it  in Bash,
# the commands vish, viper, ivsh and charm will  be available in your environment
echo "alias vish=':{vhome}/bin/vish'"
echo  "alias ivsh='vish :{vhome}/bin/ivsh'"
echo "alias viper='vish :{vhome}/bin/viper'"
echo "alias charm='vish  :{vhome}/bin/charm'"

echo
