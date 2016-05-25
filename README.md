# knack - vmware-api-client #
Its my own vmware managing script, since i dont want to buy 
the vagrant provider for vmware, i just made my own tool.




# status #
Its a early shot, if you like to test it out, give it a try. 
Since i use ubuntu for desktop and debian on vmware workstation as my development environment, this is the only combination knack supports yet.
I am happy to get feedback as well as pull requests for different os support.

# Tested with #
Hostsystem: Ubuntu 14.04 x64
Hypervisor: VMWare Workstation 11
Guestsystem: Debian 7 x64 / Debian 8 x64

# pre requisites #
For ubuntu 14.04 you can download python3-argcomplete from here:
https://launchpad.net/ubuntu/vivid/amd64/python3-argcomplete/0.8.1-0ubuntu1

        
    sudo apt-get install python3 python3-yaml python3-argcompleter
    #globally activate python argcompleter
    activate-global-python-argcomplete3
    

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
    
    knack start|stop|restart|ssh|provision|destroy <boxname>
    

# issues #
- If you create a vm for the first time, vmware-diskmanager will output this  
  warning: VixDiskLib: Invalid configuration file parameter. Failed to read configuration file.
  While i am trying to fix this, according to this thread, its safe to ignore:https://communities.vmware.com/message/2539094

- Vmware Workstation on Linux does not support vmrun register|unregister,
  therefore you wont see a vm in your vmware gui, even if its running. You can open the vm by your self but be aware you have to remove it from library before knack destroy can run successful
