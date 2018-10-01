# NVMEmon
#### Install smartmontools and curl.

**Ubuntu 16.04 :**

```
apt-get update
apt-get install smartmontools curl
```

```
git clone https://github.com/cyborg00222/NVMEmon/
cd NVMEmon
mkdir /root/scripts/
cp NVMEmon.sh /root/scripts
chmod +x NVMEmon.sh
```

#### Install crontab
```
crontab -e
*/1 * * * * /bin/bash /root/scripts/NVMEmon.sh nvme0
```
