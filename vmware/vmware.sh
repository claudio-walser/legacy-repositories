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
    
    echo "#!/usr/bin/vmware" > $VM_PATH/$FQDN.vmx;
    echo "" >> $VM_PATH/$FQDN.vmx;

    echo "guestOS = \"debian6-64\"" >> $VM_PATH/$FQDN.vmx;
    echo ".encoding = \"UTF-8\"" >> $VM_PATH/$FQDN.vmx;
    echo "config.version = \"8\"" >> $VM_PATH/$FQDN.vmx;
    echo "virtualHW.version = \"9\"" >> $VM_PATH/$FQDN.vmx;
    echo "machine.id = \"$FQDN\"" >> $VM_PATH/$FQDN.vmx;

    echo "" >> $VM_PATH/$FQDN.vmx;

    echo "numvcpus = \"$CPU\"" >> $VM_PATH/$FQDN.vmx;
    echo "memsize = \"$MEMORY\"" >> $VM_PATH/$FQDN.vmx;
    echo "displayName = \"$NAME\"" >> $VM_PATH/$FQDN.vmx;
    echo "extendedConfigFile = \"$VM_PATH/$FQDN.vmxf\"" >> $VM_PATH/$FQDN.vmx;

    echo "" >> $VM_PATH/$FQDN.vmx;

    echo "scsi0.present = \"true\"" >> $VM_PATH/$FQDN.vmx;
    echo "scsi0.sharedBus = \"none\"" >> $VM_PATH/$FQDN.vmx;
    echo "scsi0.virtualDev = \"lsilogic\"" >> $VM_PATH/$FQDN.vmx;
    echo "scsi0:0.present = \"true\"" >> $VM_PATH/$FQDN.vmx;
    echo "scsi0:0.fileName = \"$VM_PATH/$FQDN.vmdk\"" >> $VM_PATH/$FQDN.vmx;
    echo "scsi0:0.deviceType = \"disk\"" >> $VM_PATH/$FQDN.vmx;

    echo "" >> $VM_PATH/$FQDN.vmx;

    echo "ethernet0.present = \"TRUE\"" >> $VM_PATH/$FQDN.vmx;
    echo "ethernet0.connectionType = \"nat\"" >> $VM_PATH/$FQDN.vmx;
    echo "ethernet0.virtualDev = \"e1000\"" >> $VM_PATH/$FQDN.vmx;
    echo "ethernet0.wakeOnPcktRcv = \"FALSE\"" >> $VM_PATH/$FQDN.vmx;
    echo "ethernet0.addressType = \"generated\"" >> $VM_PATH/$FQDN.vmx;    

    echo "" >> $VM_PATH/$FQDN.vmx;

    echo "ide0:0.present = \"TRUE\"" >> $VM_PATH/$FQDN.vmx;
    echo "ide0:0.deviceType = \"cdrom-image\"" >> $VM_PATH/$FQDN.vmx;
    echo "ide:0.startConnected = \"false\"" >> $VM_PATH/$FQDN.vmx;
    echo "ide0:0.autodetect = \"TRUE\"" >> $VM_PATH/$FQDN.vmx;
    echo "ide0:0.fileName = \"/home/claudio/Development/VMWare/Isos/binary.hybrid.iso\"" >> $VM_PATH/$FQDN.vmx;    


    if [ -n ${SHARED_FOLDER+x} ]; then
        echo "sharedFolder0.present = \"TRUE\"" >> $VM_PATH/$FQDN.vmx;
        echo "sharedFolder0.enabled = \"TRUE\"" >> $VM_PATH/$FQDN.vmx;
        echo "sharedFolder0.readAccess = \"TRUE\"" >> $VM_PATH/$FQDN.vmx;
        echo "sharedFolder0.writeAccess = \"TRUE\"" >> $VM_PATH/$FQDN.vmx;
        echo "sharedFolder0.hostPath = \"$SHARED_FOLDER\"" >> $VM_PATH/$FQDN.vmx;    
        echo "sharedFolder0.guestName = \"$SHARED_FOLDER_GUEST\"" >> $VM_PATH/$FQDN.vmx;
        echo "sharedFolder0.expiration = \"never\"" >> $VM_PATH/$FQDN.vmx;
    fi

    return 1;
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
        echo $(pwd)"/${SHARED_FOLDER:2}";
        SHARED_FOLDER_GUEST=$(basename "/${SHARED_FOLDER:2}");
    fi

fi

# create vm config file
writeVmx;

# register vm and boot it up
/usr/bin/vmware -x $VM_PATH/$FQDN.vmx;

# start autoinstallation of debian wheezy
echo "Starting installation";