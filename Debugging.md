# Debugging : Hints for help with debugging Vish/Viper

## Ruby debugging

###  smoke test with pry:

```bash
pry

>>
^D

$ pry -e boot_etc
...
>>
^D
$
```

### Further smoke tests

See rake note below for step 3

Step 4

```bash
ivsh
```

Step 5

```bash
scratch
```

(Or: ./bin/viper)
### Run just  Ruby tests in ./minitest

```bash
rake test
```


Note: This also turns Ruby warnings on. Needed for final 2.1 release
## Vish debugging

Hint: the :vhome var is set in lib/runtime/virtual_machine.rb $vm or VirtualMachine
IOW: can be counted on for use in Vish prelude scripts


## Viper Debugging

In current circumstances: when trying to move viper commands into BinCommand::ViperCommand out from BaseCommand:


getting exception in ./bin/biper

But: try : 

```bash
vish -e 'o file_to_edit;_mode=viper vip'
```



### Loading the entire stack and invoking the pry debugger

```bash
./bin/viper -e pry
```

Note: this interrupts the startup sequence before the first buffer: "unnamed1' is established

If you exit from Pry here by ctrl-D, you trigger the bug



#### In Pry, you have the entire ./pry/debug.rb tools while you have invoked the above ./bin/viper -e pry


You can:

- veval 'type clear_line', .etc
- source 'script.vsh'


and other $vm tooling



### Located problem in the peek command

- This call :

```
meta vip
```

### Loading pry environment for debugging  Viper stuff

```bash
pry -e boot_etc
```

Above loads 