git clone git://git.proxmox.com/git/pve-qemu.git
cp sedPatch-pve-qemu-kvm7-8-anti-dection.sh pve-qemu/qemu/
cd pve-qemu
cd qemu
chmod +x sedPatch-pve-qemu-kvm7-8-anti-dection.sh
bash sedPatch-pve-qemu-kvm7-8-anti-dection.sh
apt install devscripts -y
mk-build-deps --install -y
make 
