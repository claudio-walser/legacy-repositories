#!/bin/bash

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

    echo "msg.autoAnswer = \"true\"" >> $VM_PATH/$FQDN.vmx;
    echo "guestOS = \"debian6-64\"" >> $VM_PATH/$FQDN.vmx;
    echo ".encoding = \"UTF-8\"" >> $VM_PATH/$FQDN.vmx;
    echo "config.version = \"8\"" >> $VM_PATH/$FQDN.vmx;
    echo "virtualHW.version = \"9\"" >> $VM_PATH/$FQDN.vmx;
    echo "machine.id = \"$FQDN\"" >> $VM_PATH/$FQDN.vmx;

    echo "" >> $VM_PATH/$FQDN.vmx;

    echo "numvcpus = \"$CPU\"" >> $VM_PATH/$FQDN.vmx;
    echo "memsize = \"$MEMORY\"" >> $VM_PATH/$FQDN.vmx;
    echo "displayName = \"$FQDN\"" >> $VM_PATH/$FQDN.vmx;
    echo "extendedConfigFile = \"$VM_PATH/$FQDN.vmxf\"" >> $VM_PATH/$FQDN.vmx;

    echo "" >> $VM_PATH/$FQDN.vmx;

    echo "scsi0.present = \"true\"" >> $VM_PATH/$FQDN.vmx;
    echo "scsi0.sharedBus = \"none\"" >> $VM_PATH/$FQDN.vmx;
    echo "scsi0.virtualDev = \"lsilogic\"" >> $VM_PATH/$FQDN.vmx;
    echo "scsi0:0.present = \"true\"" >> $VM_PATH/$FQDN.vmx;
    echo "scsi0:0.fileName = \"$VM_PATH/$FQDN.vmdk\"" >> $VM_PATH/$FQDN.vmx;
    echo "scsi0:0.deviceType = \"disk\"" >> $VM_PATH/$FQDN.vmx;

    echo "" >> $VM_PATH/$FQDN.vmx;

    echo "ethernet0.present = \"true\"" >> $VM_PATH/$FQDN.vmx;
    echo "ethernet0.connectionType = \"bridged\"" >> $VM_PATH/$FQDN.vmx;
    echo "ethernet0.generatedAddressOffset = \"0\"" >> $VM_PATH/$FQDN.vmx;
    echo "ethernet0.wakeOnPcktRcv = \"false\"" >> $VM_PATH/$FQDN.vmx;
    echo "ethernet0.addressType = \"generated\"" >> $VM_PATH/$FQDN.vmx;   
    echo "ethernet0.pciSlotNumber = \"30\"" >> $VM_PATH/$FQDN.vmx;
    
    echo "" >> $VM_PATH/$FQDN.vmx;

    echo "ethernet1.present = \"true\"" >> $VM_PATH/$FQDN.vmx;
    echo "ethernet1.connectionType = \"bridged\"" >> $VM_PATH/$FQDN.vmx;
    echo "ethernet1.generatedAddressOffset = \"10\"" >> $VM_PATH/$FQDN.vmx;
    echo "ethernet1.wakeOnPcktRcv = \"false\"" >> $VM_PATH/$FQDN.vmx;
    echo "ethernet1.addressType = \"generated\"" >> $VM_PATH/$FQDN.vmx;
    echo "ethernet1.pciSlotNumber = \"31\"" >> $VM_PATH/$FQDN.vmx;
      

    echo "" >> $VM_PATH/$FQDN.vmx;

    echo "ide0:0.present = \"true\"" >> $VM_PATH/$FQDN.vmx;
    echo "ide0:0.deviceType = \"cdrom-image\"" >> $VM_PATH/$FQDN.vmx;
    echo "ide:0.startConnected = \"false\"" >> $VM_PATH/$FQDN.vmx;
    echo "ide0:0.autodetect = \"true\"" >> $VM_PATH/$FQDN.vmx;
    echo "ide0:0.fileName = \"$VM_INSTALL_MEDIUM\"" >> $VM_PATH/$FQDN.vmx;    


    i=0;
    if [ -n ${SHARED_FOLDERS_GUEST+x} ]; then
        
        echo "" >> $VM_PATH/$FQDN.vmx;
        echo "sharedFolder.maxNum = \"${#SHARED_FOLDERS_GUEST[@]}\"" >> $VM_PATH/$FQDN.vmx;
        echo "isolation.tools.hgfs.disable = \"false\"" >> $VM_PATH/$FQDN.vmx;
        echo "" >> $VM_PATH/$FQDN.vmx;

        for SHARED_FOLDER_GUEST in "${SHARED_FOLDERS_GUEST[@]}"; do
            SHARED_FOLDER_GUEST_BASE=$(basename $SHARED_FOLDER_GUEST)
            
            echo "sharedFolder$i.present = \"true\"" >> $VM_PATH/$FQDN.vmx;
            echo "sharedFolder$i.enabled = \"true\"" >> $VM_PATH/$FQDN.vmx;
            echo "sharedFolder$i.readAccess = \"true\"" >> $VM_PATH/$FQDN.vmx;
            echo "sharedFolder$i.writeAccess = \"true\"" >> $VM_PATH/$FQDN.vmx;
            echo "sharedFolder$i.hostPath = \"$SHARED_FOLDER_GUEST\"" >> $VM_PATH/$FQDN.vmx;    
            echo "sharedFolder$i.guestName = \"$SHARED_FOLDER_GUEST_BASE\"" >> $VM_PATH/$FQDN.vmx;
            echo "sharedFolder$i.expiration = \"never\"" >> $VM_PATH/$FQDN.vmx;
            echo "" >> $VM_PATH/$FQDN.vmx;

            i=$[i + 1];
        done

        
    

    fi
    cp $VM_PATH/$FQDN.vmx $VM_PATH/$FQDN.vmx.copy
    return 1;
}
