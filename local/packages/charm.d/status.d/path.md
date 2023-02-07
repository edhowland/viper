the viper program is not in your $PATH variable.
You can construct it with:
charm config path
This can be redirected to append to your ~/.bashrc or your preferred shell
startup script.


Example command

```bash
echo export PATH="$(charm config path)" >> ~/.bashrc
```

Or, if you prefer,  you can use aliases instead. You can construct an alias
command line with the 'charm config alias' statement.

```bash
charm config alias >> ~/.bashrc
# Or, for a less permanent solution:
charm config alias > viper.alias
source viper.alias
```

Or wherever you store your permanent aliases. To unalias these do the following:

```bash
unalias viper vish ivsh charm
```


