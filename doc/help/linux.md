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

- OS version : Windows 10 running Fall Creators Update. Build 1709
- Screen Reader : Windows Narrotor : Start with Windows or Super key plus Control plus Enter key. *Note: 1
-  Windows Subsystem for Linux : WSL
- Ruby version 2.2 or greater. FCU will install Ruby version 2.3

Notes:

The Win10 Narrator start key sequence changed from simply the Windows/Super key plus th Enter key in previous version of Windows 10.
Now you must also use the Control key. E.g. Control + Windows + Enter  ... Will turn on Narrator.
The Narrator function key is Caps lock. Press Caps lock and Escape to turn off Naraator.
To to resume the old function of Caps lock while in Narrator, simply quickly tap the Caps lock twice.

For help with narrator keys:

- Caps Lock + F1 :Start Narator key list. With search box
- Caps Lock + left, right keysto move around
- Caps Lock + Enter : Activate a button or link

### Setting up the Ruby development environment

Perform these steps once you have Ubuntu for Windows (WSL) installed:

- sudo apt update
- sudo apt install build-essential
- sudo apt install ruby ruby-dev
- sudo gem install bundler

Once you have gotten this far, you can clone the Viper project from the GitHub path:

[https://github.com/edhowland/viper](https://github.com/edhowland/viper.git)

Stay tuned for more help with this step!

Development of Viper
may require quite a lot of work. As Viper development progresses
We may provide guidance about setting up Viper on Windows 10.

