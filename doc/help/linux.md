# Operating Systems

Viper is designed to be as cross platform as possible. This page lists 
system requirements and potential caveats for various operating systems
where Viper is running.

From this page there are also links to more specific help for your  operating system.

## Mac OS

### System Requirements

Viper has been tested on Mac OS versions  10.10 Yosemite and 10.12 Sierra.

- Screen Reader : Voice Over : Start with Super (or Command) + F5
- Terminal.app - Viper is a terminal or command line application.
- Ruby language. Viper requires Ruby 2.2 or greater.

## Linux

### System Requirements

Viper can run under Linux systems assuming some screen reader. Currently,
Viper has been tested with the Orca screen reader running in the Gnome desktop environment.

- Screen Reader : Orca version 3.x or greater. Start with Super plus Alt plus Capitol S.
- Gnome Terminal : Known terminal emulator that works with Orca.
- Ruby Language : Version 2.2 or greater.

[Orca Notes : Additional notes regarding the Orca screen reader and use with Viper](orca)


Note: Viper can be run on any system that is reached via ssh. This can include
remote systems or local systems running in a Virtual Machine  guest OS.
In this case, the screen reader is expected to be on the Host OS. If you are
running Viper on some host reached via ssh, the only requirements are Ruby version 2.2 or greater on the remote host.

Of course, the platform specific requirements apply to the originating host.


## Windows

Viper has not yet been tested on Microsoft Windows. However,
Here are some expected requirements. The plan is to test on the following
machine setups.


### System Requirements

- OS version : Windows 10 running Anniversary or Creators Update.
- Screen Reader : Windows Narrotor : Start with Windows or Super key plus Enter key.
-  Windows Subsystem for Linux : WSL
- Ruby version 2.2 or greater.

Notes: Getting the correct version of Ruby on Windows 10 + WSL
may require quite a lot of work. As Viper development progresses
We may provide guidance about setting up Viper on Windows 10.

