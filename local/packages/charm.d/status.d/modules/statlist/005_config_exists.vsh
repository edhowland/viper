rem config_exists.vsh does the user have home .config/vish
if_dir ":{chome}" "The config folder exists in :{chome}" "There is no local configin :{chome}. It can be created with charm config create."
