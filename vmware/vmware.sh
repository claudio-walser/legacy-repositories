#!/bin/bash

# load functions and defaults

SCRIPT_BASEDIR=$(dirname $0)

. $SCRIPT_BASEDIR/functions.sh;
. $SCRIPT_BASEDIR/defaults.cfg;

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



FULL_DOMAIN="$ENVIRONMENT.$DOMAIN";
FQDN="$NAME.$FULL_DOMAIN";

echo "Create vm named $FQDN";
echo "Its hardware specifications are as following:
    - CPU $CPU
    - Memory $MEMORY
    - DiskSize $SIZE

    - With this network configuration:";
if [ -n "$NETWORK_IP" ]; then

    if [ ! -n "$NETWORK_NETMASK" ] || [ ! -n "$NETWORK_GATEWAY" ]; then
        echo "Network Error: You have to set NETWORK_NETMASK and NETWORK_GATEWAY in order to have proper fixed ips."
        echo "Exiting now!";
        exit 1;
    fi
    echo "        - IP $NETWORK_IP
        - Netmask $NETWORK_NETMASK
        - Gateway $NETWORK_GATEWAY";
else
    echo "        - DHCP"
fi


# just annoying during development
#read -p "Continue creating the vm (y/N)?" CONT
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


# add provisioning scripts to shard folder path
if [ -n ${SHARED_FOLDERS+x} ]; then
    SHARED_FOLDERS="$SHARED_FOLDERS;$VM_DEFAULT_SHARED_FOLDER";
else
    SHARED_FOLDERS=$VM_DEFAULT_SHARED_FOLDER;
fi 
OLD_IFS=$IFS;
IFS=';';
i=0;

# fix shared folders path
for SHARED_FOLDER in $SHARED_FOLDERS; do
    if [ ! -n "$SHARED_FOLDER" ]; then
        continue;
    fi

    if [ "${SHARED_FOLDER:0:2}" == "./" ]; then
        SHARED_FOLDER=$(pwd)"/${SHARED_FOLDER:2}";
    fi
    SHARED_FOLDERS_GUEST[$i]=$SHARED_FOLDER
    i=$[i + 1];
done
IFS=$OLD_IFS; 



# create vm config file
writeVmx;

# register vm and boot it up
/usr/bin/vmware -x $VM_PATH/$FQDN.vmx;
vmrun start $VM_PATH/$FQDN.vmx


# start autoinstallation of debian wheezy
echo "Starting installation";

# wait until vm is started properly
FOLDER="never checked yet";
while [ "$FOLDER" != "The directory exists." ]; do
    echo 'waiting for properly installed operating system...';
    echo $FOLDER;
    FOLDER=$(vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD directoryExistsInGuest $VM_PATH/$FQDN.vmx '/mnt/hgfs/provisioning');

    # for some reason initial shared folders are disabled on start at a specific amount of vm's
    if [ "$FOLDER" == 'The directory does not exist.' ]; then
        FOLDER=$(vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD enableSharedFolders $VM_PATH/$FQDN.vmx);
        FOLDER=$(vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD directoryExistsInGuest $VM_PATH/$FQDN.vmx '/mnt/hgfs/provisioning');
    fi
done

echo '';
echo 'Proper installation finally done, provisioning starts now...';

echo '';
echo 'Set hostname';
#vmrun  -gu root -gp $DEFAULT_ROOT_PASSWORD runScriptInGuest "$VM_PATH/$FQDN.vmx" /bin/bash /mnt/hgfs/provisioning/hosts.sh -h$NAME -d$DOMAIN -p$PUPPET_MASTER_HOSTNAME -i$PUPPET_MASTER_IP
SCRIPT_OUTPUT=$(vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD runScriptInGuest "$VM_PATH/$FQDN.vmx" "/bin/bash" "/mnt/hgfs/provisioning/hostname.sh -h$NAME");
echo $SCRIPT_OUTPUT;

echo 'Set hosts file';
SCRIPT_OUTPUT=$(vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD runScriptInGuest "$VM_PATH/$FQDN.vmx" "/bin/bash" "/mnt/hgfs/provisioning/hosts.sh -h$NAME -d$FULL_DOMAIN -p$PUPPET_MASTER_HOSTNAME -i$PUPPET_MASTER_IP");
echo $SCRIPT_OUTPUT;

if [ -n "$NETWORK_IP" ]; then
    echo "Setup network - eth1";
    SCRIPT_OUTPUT=$(vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD runScriptInGuest "$VM_PATH/$FQDN.vmx" "/bin/bash" "/mnt/hgfs/provisioning/network.sh -i$NETWORK_IP -n$NETWORK_NETMASK -g$NETWORK_GATEWAY");
    echo $SCRIPT_OUTPUT; 
fi

echo 'Setup puppet client';
SCRIPT_OUTPUT=$(vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD runScriptInGuest "$VM_PATH/$FQDN.vmx" "/bin/bash" "/mnt/hgfs/provisioning/puppet.sh -p$PUPPET_MASTER_HOSTNAME.$FULL_DOMAIN");
echo $SCRIPT_OUTPUT;

if [ $PUPPET_MASTER_HOSTNAME == $NAME ]; then
    echo 'Setup puppet master';
    SCRIPT_OUTPUT=$(vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD runScriptInGuest "$VM_PATH/$FQDN.vmx" "/bin/bash" "/mnt/hgfs/provisioning/puppetmaster.sh");
    echo $SCRIPT_OUTPUT;
fi


echo 'Basic provision done, rebooting now';
SCRIPT_OUTPUT=$(vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD runScriptInGuest "$VM_PATH/$FQDN.vmx" "/sbin/reboot");
echo $SCRIPT_OUTPUT;

# wait until vm is rebooted properly
FOLDER="never checked yet";
while [ "$FOLDER" != "The directory exists." ]; do
    echo 'waiting for properly installed operating system...';
    echo $FOLDER;
    FOLDER=$(vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD directoryExistsInGuest $VM_PATH/$FQDN.vmx '/mnt/hgfs/provisioning');

    # for some reason initial shared folders are disabled on start at a specific amount of vm's
    if [ "$FOLDER" == 'The directory does not exist.' ]; then
        FOLDER=$(vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD enableSharedFolders $VM_PATH/$FQDN.vmx);
        FOLDER=$(vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD directoryExistsInGuest $VM_PATH/$FQDN.vmx '/mnt/hgfs/provisioning');
    fi
done

echo 'Running puppet agent now';
#vmrun  -gu root -gp $DEFAULT_ROOT_PASSWORD runScriptInGuest "$VM_PATH/$FQDN.vmx" /bin/bash /mnt/hgfs/provisioning/hosts.sh -h$NAME -d$DOMAIN -p$PUPPET_MASTER_HOSTNAME -i$PUPPET_MASTER_IP
SCRIPT_OUTPUT=$(vmrun -gu root -gp $DEFAULT_ROOT_PASSWORD runProgramInGuest "$VM_PATH/$FQDN.vmx" "/usr/bin/puppet" "agent -t");
echo $SCRIPT_OUTPUT;

exit 0;