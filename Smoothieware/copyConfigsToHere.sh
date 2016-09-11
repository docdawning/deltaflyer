#!/bin/bash
MOUNTPOINT=/smoothieboard

echo -e "\nMounting the board's card & copying configs"
sudo mount $MOUNTPOINT
cp $MOUNTPOINT/config ./
cp $MOUNTPOINT/config-override ./
cp $MOUNTPOINT/FIRMWARE.CUR ./
echo -e "\n Resto. Oh, and I left $MOUNTPOINT mounted, enjoy that."
