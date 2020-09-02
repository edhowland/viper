# Vish variables

Unlike Bash or similar shells, Vish uses the ':' sigil to represent 
a variable dereference, where Bash would a dollar sign '$' for the same thing.

```
aa=hello bb=world;echo :aa :bb
# hello world
```


#### Variable scopes

Vish also differs from Bash in that variables are locally scoped by default but can be made global if needed.
This only occurs within Vish functions, otherwise, the variable scoping rules match those of Bash.

E.g.

```
aa="hello world"
function hi() {
aa="goodbye world"
echo :aa
}
hi; echo :aa
# goodbye world
# hellow world
```


#### Setting a global variable with global keyword

```
aa=bb
function setme() {
aa=cc
global aa
}
echo :aa
setme; echo :aa
# bb
# cc
```

#### Function parameters vs. variables

Another difference with Bash is that function parameters are named instead of positionally bound and referenced with numerals.
Within the body of the function, these parameter names behave like regular Vish variables and go out of scope 
once the function exits. 

The following examples show the difference between Bash and Vish:

```
# Bash syntax
function foo() {
echo $1 $2 $3
}
foo hello there sailor
# hello there sailor
# Vish syntax:
function foo(gt, pr, name) {
echo :gt :pre :name
}
foo hello world sailor
# hello there sailor
```


#### Referring to all passed arguments to a Vish function

In Bash, you would either refer to allpassed arguments to a function with either $@ or $*.
In Vish this is accomplished with the :_ special variable.
You can use the shift keyword to set a single argument to a new local variable, like in Bash.

```
function bar() {
shift aa; shift bb
echo :aa :bb
echo :_ 
}
bar whats up dude
# whats up
#  dude
```

#### Lexical scoping

A feature in Vish but not in Bash are anonymous functions, also called lambda functions or just lambdas.
Variables set in the enclosing scope wherein a lambda is defined
are lexically scoped within the body of the lambda. Those same variables
may go out of scope once the enclosing scope is destroyed. However, if referenced within a saved lambda,
the body of the lambda retains the value of that variable, even though it does
no longer in scope of the surrounding context.

The usefulness of this type of scoping might not be readily  apparent.
But it comes useful when computing a range of values that you want to save in laambda functions.

In  the Viper editor, we compute the actual values of characters for canonical 
key names and create lambda functions to insert these character values into the current buffer.

An example might be helpful:

```
function make_and_bind(key, char) {
bind :key &() { echo -n :char | ins :_buf } &() { echo -n :char }
}
_mode=viper make_bind key_d 'd'
_mode=viper make_and_bind key_f 'f'
```

#### Statement scoping

For completeness sake, the following example is submitted, althoughthe usage tracks that of Bash.

When variables are set before the name of a command, they are in scope only during the execution of that command.
They go out of scope after the command terminates.

```
function foo() { echo :aa :bb }
aa=hello bb=world foo
# hello world
echo :aa :bb
#
```

Note: the same variables cannot be referenced as arguments to that same command.

```
aa=hello bb=world echo :aa :bb
#
```

#### Unsetting variables

Use the unset keyword to unset a variable. E.g.

```
aa=hello
echo :aa
# hello
unset aa
echo :aa
#
```

#### Listing all set variables

Use the declare keyword to print out the names and values of all currently set varibles.

```
declare
# exit_status=false
# pwd=/home/vagrant/src/viper2
# vhome=/home/vagrant/src/viper2
# prompt=vish >
# oldpwd=/home/vagrant/src/viper2
# version=1.99-rc0
# release=Cleo
#ifs= 
# ...
```


### Variable ranges

A range can be set when a variable is defined. Then, when dereferenced, it is expanded.

```
aa=1..5
echo :aa
# 1 2 3 4 5
```
