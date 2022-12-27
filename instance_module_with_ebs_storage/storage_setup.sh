# #!/bin/bash
# Set up the storage drive
sudo mkfs.ext4 /dev/nvme1n1
mkdir -p /app-data
sudo e2label /dev/nvme1n1 app-data
sudo echo "LABEL=app-data /app-data ext4 rw,noatime,nodiratime 0 0" >> /etc/fstab
mount -a