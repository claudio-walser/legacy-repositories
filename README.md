# knack - vmware-api-client #
Its a try to create my own vmware managing script, since the vagrant adapter has ridicolous prices...
And because i dont like ruby and i dont want to destroy vagrants business model, i did not write a vagrant extension for vmware

# Issues #
If you create a vm for the first time, vmware-diskmanager will output this warning:
VixDiskLib: Invalid configuration file parameter. Failed to read configuration file.

While i am trying to fix this, according to this thread, its safe to ignore:
https://communities.vmware.com/message/2539094
