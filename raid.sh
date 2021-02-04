#!/bin/bash

set -e
set -x

echo "Create raid..."

mdadm --zero-superblock --force /dev/sd{b,c,d,e}

mdadm --create --verbose /dev/md0 -l 10 -n 4 /dev/sd{b,c,d,e}

#mkdir -p /etc/mdadm

echo "DEVICE partitions" > /etc/mdadm.conf

mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm.conf

echo "Mount raid..."

parted -s /dev/md0 mklabel gpt

parted /dev/md0 mkpart primary ext4 0% 25%
parted /dev/md0 mkpart primary ext4 25% 50%
parted /dev/md0 mkpart primary ext4 50% 75%
parted /dev/md0 mkpart primary ext4 75% 100%

for i in $(seq 1 4); do sudo mkfs.ext4 /dev/md0p$i; done

mkdir -p /raid/part{1,2,3,4}

for i in $(seq 1 4); do mount /dev/md0p$i /raid/part$i; done
