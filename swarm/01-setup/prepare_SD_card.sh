#!/bin/bash

SD_DEV_PATH=/dev/sdd

cat > /tmp/parted.txt <<EOF
select ${SD_DEV_PATH}
rm 4
mkpart primary xfs 1055MB 15.5GB
q
EOF
parted < /tmp/parted.txt

mount ${SD_DEV_PATH}4 /mnt
xfs_growfs ${SD_DEV_PATH}4

# Change root password, ssh key ( password is swarmdemo )
sed -i 's|root:\*|root:$6$SE.m05eJFjIY7Wwl$i7ZNlKJ/VB23jEw6Ae.H87tixUe42ZBxrHMtHqbTEG7x/BgPJysVpvIQEKduTiet1LK.k7XoJnJByksSG3LJU/|' /mnt/etc/shadow
mkdir -p -m 0600 /mnt/root/.ssh/
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCle9kEzAK5UmYN8ADEfGSAivDcOkhhWR+EOotD+dA3MpHSAGaWb6AEoJTNpFGI6ff4ObvjpiSncX9dYT4JxTv3rz0FLM0o4nHGHjBhxRrVyj8weG6ntCFJrjufH6ysrU5+3FF73s4PksQPfY+twxmlaCCdRzqpOXcpUgqnYkocyfVy8uI9x4SCPXDVOzw/+ux0a79R0vi2WD05ZprBjUq0S78wzzyQFFBBC/ij+hwUyS6054wCY5eGjJXdhcBpmkVQisHB4MBRYfBQ42bajDoDo8Gk8W7S/1jNvN3bxRLs2me0SZ2YaiGytIOTq39vsiBXv1XBfmChr7b4pgQtnmNREM8vCvcA4gSgmLJq3QY/vfhEeu3QpJjWwr/CHYLrdhsXkfV2iWIqkgnCVZWEtUQ358ErXIz/Lcn9lzVnaGzXj/G8Os+vxwa9YFyV+OSXAgDuLYoLROSJBeoeCEKSJhqZ41Q5PmXZNPNE9NqpEzv1m6xW2bP1GooJF/kFgWtoubVfv8+Y6qsBHuzr2Qpe1MYZ09ai3MOFG/mb6aSDXUcvvviEiB7TMBbqGuX5U4swiK13v3Y1OyNjPP4teFRGFdvp119qm9olh2FYueuxyXw7mF89Gj7YM8y6knpEse7Sw2V+jQyjPRDqBaJakBuoTw41c8dfu2X5yjFu8iURMABqLQ==' > /mnt/root/.ssh/authorized_keys
chmod 640 /mnt/root/.ssh/authorized_keys

# Enable docker service
ln -s /mnt/usr/lib/systemd/system/docker.service /mnt/etc/systemd/system/multi-user.target.wants/docker.service
