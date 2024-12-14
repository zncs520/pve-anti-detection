sudo apt-get update
sudo apt-get install libacl1-dev libaio-dev libattr1-dev libcap-ng-dev libcurl4-gnutls-dev libepoxy-dev libfdt-dev libgbm-dev libglusterfs-dev libgnutls28-dev libiscsi-dev libjpeg-dev libnuma-dev libpci-dev libpixman-1-dev libproxmox-backup-qemu0-dev librbd-dev libsdl1.2-dev libseccomp-dev libslirp-dev libspice-protocol-dev libspice-server-dev libsystemd-dev liburing-dev libusb-1.0-0-dev libusbredirparser-dev libvirglrenderer-dev meson python3-sphinx python3-sphinx-rtd-theme quilt xfslibs-dev
ls
df -h
git clone git://git.proxmox.com/git/pve-qemu.git
cd pve-qemu
git reset --hard 3b3d5516ee5c01e5c5d0f183488c3480c3438a5e
git submodule update --init
ls
cd qemu
git submodule update --init
cd ..
cp ../sedPatch-pve-qemu-kvm7-8-anti-dection.sh qemu/
cd qemu
chmod +x sedPatch-pve-qemu-kvm7-8-anti-dection.sh
bash sedPatch-pve-qemu-kvm7-8-anti-dection.sh
#cp ../../smbios.h include/hw/firmware/smbios.h
#cp ../../smbios.c hw/smbios/smbios.c
cd ..
apt install devscripts -y
mk-build-deps --install
make

