# Testing

Below are some notes about testing Viper for my own use.

## Rake test

The test task in Rakefile will run both the Ruby tests
in test/all_tests.rb and the application tests in test/all_tests.vsh.

You should get some spurious output then 2 reports. You should see the status of 'green' for
the Ruby tests and 'failures 0' for the Vish tests at the end.

## Ruby unit tests

```
ruby test/all_tests.rb
```


### Ruby unit test framework

Viper uses a very simple homegrown unit test library.
It can be loaded with one file:  test/lib/spike_load.rb

Here is the test/test_helper.rb


```
# test_helper.rb - requires for loading test stuff

require_relative 'lib/spike_load'
require_relative '../lib/viper'
```


