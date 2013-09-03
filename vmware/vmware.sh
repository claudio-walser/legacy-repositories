#!/bin/bash

# Argument = -n server-01 -e environment-development -d domain.tld -m 1024 -c 2 -s 20G

# display the help
usage() {
    echo "
    usage: $0 options

    This script creates a new virtual machine on vmware workstation

    OPTIONS:
       -h      Show this message
       -f      Pass a config file for the following configs
       -p      Base path to the virtual machines folder

       // Hostname settings
       -n      Name of the VirtualMachine
       -e      Environment of the VirtualMachine (development|acceptance|production)
       -d      Domain of the VirtualMachine

       // Hardware settings
       -m      Memory size
       -c      CPU amount
       -s      Disk size";

    exit;
}

writeVmx() {
    CODE="
            #!/usr/bin/vmware\n
\n
            guestOS = \"debian6-64\"\n
            .encoding = \"UTF-8\"\n
            config.version = \"8\"\n
            virtualHW.version = \"9\"\n
            machine.id = \"$FQDN\"
\n
            numvcpus = \"$CPU\"\n
            memsize = \"$MEMORY\"\n
            displayName = \"$NAME\"\n
            extendedConfigFile = \"$VM_PATH/$FQDN.vmxf\"\n
\n
            scsi0.present = \"true\"\n
            scsi0.sharedBus = \"none\"\n
            scsi0.virtualDev = \"lsilogic\"\n
            scsi0:0.present = \"true\"\n
            scsi0:0.fileName = \"$VM_PATH/$FQDN.vmdk\"\n
            scsi0:0.deviceType = \"disk\"\n
\n
            ethernet0.present = \"TRUE\"\n
            ethernet0.connectionType = \"nat\"\n
            ethernet0.virtualDev = \"e1000\"\n
            ethernet0.wakeOnPcktRcv = \"FALSE\"\n
            ethernet0.addressType = \"generated\"\n
\n
            ide0:0.present = \"TRUE\"\n
            ide0:0.deviceType = \"cdrom-raw\"\n
            ide:0.startConnected = \"false\"\n
            ide0:0.autodetect = \"TRUE\"\n";


    if [-n "$SHARED_FOLDER"]; then
        CODE=$CODE + "\n
            sharedFolder0.present = \"TRUE\"
            sharedFolder0.enabled = \"TRUE\"
            sharedFolder0.readAccess = \"TRUE\"
            sharedFolder0.writeAccess = \"TRUE\"
            sharedFolder0.hostPath = \"$SHARED_FOLDER\"
            sharedFolder0.guestName = \"$SHARED_FOLDER_GUEST\"
            sharedFolder0.expiration = \"never\"
            ";
    fi

    echo $CODE > $VM_PATH/$FQDN.vmx;
 }

# VM Settings
VM_BASE_PATH='/home/claudio/Development/VMWare/VirtualMachines';

# Domain defaults
NAME='debian-1';
ENVIRONMENT='development';
DOMAIN='claudio.dev';
# Hardware defaults
MEMORY='1024';
CPU='1';
SIZE='10GB';


while getopts “n:e:d:m:c:s:f:p:h” OPTION
do
     case $OPTION in
        n)
            NAME=$OPTARG;
            ;;
        e)
            ENVIRONMENT=$OPTARG;
            ;;
        d)
            DOMAIN=$OPTARG;
            ;;

        m)
            MEMORY=$OPTARG;
            ;;
        c)
            CPU=$OPTARG;
            ;;
        s)
            SIZE=$OPTARG;
            ;;

        p)
            VM_BASE_PATH=$OPTARG;
            ;;
        f)
            if [ -r $OPTARG ]; then
                . $OPTARG;
            else
                echo "Could not find config file $OPTARG";
            fi
            ;;
        ?)
            usage;
            ;;
     esac
done


FQDN="$NAME.$ENVIRONMENT.$DOMAIN";

echo "Create vm named $FQDN";
echo "Its hardware specifications are as following:
    - CPU $CPU
    - Memory $MEMORY
    - DiskSize $SIZE

";

# just annoying during development
#read -p "Continue creating the vm (y/n)?" CONT
#if [ "$CONT" != "y" ]; then
#  echo "user aborted";
#  exit 1;
#fi

VM_PATH=$VM_BASE_PATH/$DOMAIN/$ENVIRONMENT/$NAME;
echo "Starting create vm in $VM_PATH";


# create virtual disk if it does not already exists
 if [ ! -r $VM_PATH/$FQDN.vmdk ]; then
    echo "";
    /bin/mkdir -p $VM_PATH;
    /usr/bin/vmware-vdiskmanager -c -t 0 -s $SIZE -a ide $VM_PATH/$FQDN.vmdk;
fi


# fix shared folder path if exists
if [ -n ${SHARED_FOLDER+x} ]; then
    
    if [ "${SHARED_FOLDER:0:2}" == "./" ]; then
        echo 'Hell i am not so bad';
    fi
    exit 1;
fi

# create vm config file
writeVmx;

# register vm and boot it up
/usr/bin/vmware -x $VM_PATH/$FQDN.vmx;

# start autoinstallation of debian wheezy
echo "Starting installation";