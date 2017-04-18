# Setup Docker Swarm #

## Installing on Raspberry pi ##

Tested on [Raspberry pi Model 3 B v1.2](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/).
[Fedora 25](https://fedoraproject.org/wiki/Raspberry_Pi) will be used as Raspberry pi OS.

### Setup SD Card ###

  * Download [ARM installer](https://fedoraproject.org/wiki/Raspberry_Pi#Downloading_the_Fedora_ARM_image)
      * Fedora server in our case
  * Connect USB to PC via USB
  * Use `dmesg` command to find device path (`/dev/sdd` in our case)
  * Copy image to target device found in previous step using commands as root either
      * `xzcat Fedora-IMAGE-NAME.raw.xz | sudo dd status=progress bs=4M of=/dev/XXX` or
      * `arm-image-installer --image=/home/jveverka/programs/os/raspberry/fedora/Fedora-Server-armhfp-25-1.3-sda.raw.xz --media=/dev/sdd -y`
  * Grow partition
      * `parted`, `gparted` to resize partition and
      * `xfs_growfs /dev/sdd4` to extend filesystem

### Setup Swarm-mode cluster ###

#### Swarm Master ####
  * Start and enable docker service
    * `systemctl start docker; systemctl enable docker`
  * Change hostname
    * `hostname master.swarm`
  * Get Master IP address (ideally static one)
      * `ip a`
  * Init cluster
    * `docker swarm init --advertise-addr <IP_MASTER>`
  * ```firewall-cmd --zone=public --add-port=2377/tcp --permanent
firewall-cmd --zone=public --add-port=7946/tcp --permanent
firewall-cmd --zone=public --add-port=7946/udp --permanent
firewall-cmd --zone=public --add-port=4789/udp --permanent
firewall-cmd --zone=public --add-port=4789/tcp --permanent
firewall-cmd --zone=public --add-port=4789/tcp --permanent
firewall-cmd --reload```

#### Swarm node ####
  * Start and enable docker service
    * `systemctl start docker; systemctl enable docker`
  * Change hostname
    * `hostname node-0x.swarm`
  * Join cluster node
    * `docker swarm join --token SWMTKN-1-3f68c3at7tktnhgwmt6hrptywbtlqxxy0m213xnyuys6r6h4dk-cd37yjk20nqvg0774tkw5ka0z <MASTER_IP>:2377`

### Test swarm cluster ###

``` bash
docker service create --replicas 1 --name helloworld alpine ping docker.com
```
