#!/bin/sh

# partition size in MB
BOOT_ROM_SIZE=10


# call sfdisk to create partition table
# destroy the partition table
node=$1
dd if=/dev/zero of=${node} bs=1024 count=1

sfdisk --force -uM ${node} << EOF
${BOOT_ROM_SIZE},500,0c
600,,83
EOF
