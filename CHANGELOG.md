# Changelog for Viper project
## 2022-08-10

Release 2.0.2

- Added defensive coding to VirtualMachine.mount. Args must have length > 0
  * Added VirtualMachine::IOError
- Updated Gemfile to make kpeg explicit to version 1.1.0.
  * Newer versions use 1.3.x which is imcompatible with Vish parser



## 2022-08-09

### Release 2.0.1

Fixed compat w/Ruby 3.0.0: Ranges are now frozen and cannot be extended.
hence: A test in test/blank_test.rb cannot be run

- After markdown parsing was removed: removed test in test/hunt_test.rb


