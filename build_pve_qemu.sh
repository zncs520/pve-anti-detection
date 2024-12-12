git clone git://git.proxmox.com/git/pve-qemu.git
cd pve-qemu
apt install devscripts -y
mk-build-deps --install -y
make
make clean
cp ../sedPatch-pve-qemu-kvm7-8-anti-dection.sh qemu/
cp ../smbios.h qemu/include/hw/firmware/smbios.h
cp ../smbios.c qemu/hw/smbios/smbios.c
cd qemu
chmod +x sedPatch-pve-qemu-kvm7-8-anti-dection.sh
bash sedPatch-pve-qemu-kvm7-8-anti-dection.sh
cd ..
apt install devscripts -y
mk-build-deps --install -y
make 
