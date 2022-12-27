# #!/bin/bash
# Set up the storage drive
sudo mkfs.ext4 /dev/xvdg
mkdir -p /app-data
sudo e2label /dev/xvdg app-data
sudo echo "LABEL=app-data /app-data ext4 rw,noatime,nodiratime 0 0" >> /etc/fstab
mount -a