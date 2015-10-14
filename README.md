# knack - vmware-api-client #
Its a try to create my own vmware managing script, since the vagrant adapter has ridicolous prices...
And because i dont like ruby and i dont want to destroy vagrants business model, i did not write a vagrant extension for vmware

# status #
Its a early shot, if you like to try it out, give it a shot. 
Since i use ubuntu for desktop and debian on vmware workstation as my development environment, this is the only combination knack supports yet.
I am happy to get feedback as well as pull requests for different os support.

# Tested with #
Hostsystem: Ubuntu 14.04
Hypervisor: VMWare Workstation 11
Guestsystem: Debian 7 / Debian 8

# pre requisites #
sudo apt-get install python3 python3-yaml

# installation #
git clone https://github.com/claudio-walser/knack.git
cd knack
chmod +x knack.py
sudo ln -s `pwd`/knack.py /usr/local/bin/knack

# where to get automated debian installations #
There are different possibilites to achieve an automated installation.
I like a custom live-cd the most because its always getting the most
current version of your desired distribution by the internet.
To make your life a bit easier, there are two other projects for knack.
One containing a automated live-cd installation with debian 7 (wheezy),
the other for debian 8 (jessie)
https://github.com/claudio-walser/knack-debian-7-live-cd
https://github.com/claudio-walser/knack-debian-8-live-cd

# how to use #
knack start|stop|restart|destroy <boxname>

# issues #
- If you create a vm for the first time, vmware-diskmanager will output this  
  warning: VixDiskLib: Invalid configuration file parameter. Failed to read configuration file.
  While i am trying to fix this, according to this thread, its safe to ignore:https://communities.vmware.com/message/2539094

- Vmware Workstation on Linux does not support vmrun register|unregister,
  therefore you wont see a vm in your vmware gui, even if its running. You can open the vm by your self but be aware you have to remove it from library before knack destroy can run successful
