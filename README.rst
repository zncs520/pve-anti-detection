李晓流 & 大大帅666 作品 20240830出品
李晓流 b站地址：https://space.bilibili.com/565938745
大大帅666 b站地址 https://space.bilibili.com/14205798

本想把 李晓流 & 大大帅666 作品 LOGO.jpg 这个图标搞进pve虚拟机启动画面的，pve的kvm和ovmf分别是两个包不是同一个包，要编译ovmf包才能实现开机画面，现在实现了。

可以参考以前我发布的这个文章：https://www.bilibili.com/read/cv26245305 该文章抛砖引玉而已
1、前期准备工作：
pve网页 数据中心-》选项-》MAC地址前缀你先改成D8:FC:93
我个人的建议是直通sata硬盘或者m2硬盘给虚拟机，还有有线物理网卡（usb网卡）给虚拟机进行测试。
！！！！！！！！！！！本版本解开scsi以及virtio设备所有使用限制，可以随便使用了！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
本版本为谢幕版本，仅做测试使用！！！！！后期不再更新！！！！
我会在b站这个专栏发布全部的源码和教程如何编译源码，是整个系列的发布： https://www.bilibili.com/read/readlist/rl758108 pve反虚拟化检测玩游戏

2、正式开始
请把2个包
pve-qemu-kvm_9.0.2-2_amd64_anti_detection20240830v5.0.deb
pve-edk2-firmware-ovmf_4.2023.08-4_all_anti_detection20240830v5.0.deb
和3个ko文件
kvm.ko
kvm-amd.ko
kvm-intel.ko
请用winscp 上传到/root目录下

关于内核模块怎么单独编译并立马使用生效请参考我的这篇文章 https://www.bilibili.com/read/cv37772880/ 单独编译pve linux内核模块（比如kvm）加载到当前内核中立马使用生效

3、查询目前安装的kvm包版本命令
dpkg -l|grep kvm

4、如果是9.0.2-2，直接安装6.18.12-1-pve这个版本内核和这2个反检测包就是
apt install apt install proxmox-kernel-6.8.12-1-pve
dpkg -i pve-qemu-kvm_9.0.2-2_amd64_anti_detection20240830v5.0.deb
dpkg -i pve-edk2-firmware-ovmf_4.2023.08-4_all_anti_detection20240830v5.0.deb

如果版本不是9.0.2-2，你升级下系统并强制降级安装9.0.2-2版本包（6.18.12-1-pve这个版本内核和这2个反检测包），命令如下:
apt update
apt install apt install proxmox-kernel-6.8.12-1-pve
apt install  pve-qemu-kvm=9.0.2-2
dpkg -i pve-qemu-kvm_9.0.2-2_amd64_anti_detection20240830v5.0.deb
dpkg -i pve-edk2-firmware-ovmf_4.2023.08-4_all_anti_detection20240830v5.0.deb



上面命令会安装proxmox-kernel-6.8.12-1-pve内核，安装完成后请reboot机器
reboot


上面命令中安装的6.8.12-1内核，可以是以下的两个都可以，区别就是一个是签名版，一个没签名
apt install proxmox-kernel-6.8.12-1-pve-signed 和 apt install proxmox-kernel-6.8.12-1-pve 都可以的

不再提供qemu8版本的包了

5、重启物理机后执行以下命令
rmmod kvm_intel
rmmod kvm
lsmod | grep kvm
rm /lib/modules/6.8.12-1-pve/kernel/arch/x86/kvm/*
cp /root/{kvm.ko,kvm-intel.ko,kvm-amd.ko} /lib/modules/6.8.12-1-pve/kernel/arch/x86/kvm/
modprobe kvm
modprobe kvm_intel
lsmod |grep kvm
dmesg | grep dds

会有类似以下输出，说明成功加载kvm模块了，amd的你把上面命令rmmod kvm_intel改为rmmod kvm_amd 以及 modprobe kvm_intel改为modprobe kvm_amd 后运行
[ 4215.953468] Intel KVM lixiaoliu and dds666 v1.0 Start,ok!!!

如果没有这个输出，是这个错误： module kvm: .gnu.linkonce.this_module section size must match the kernel's built struct module size at run time
只能说明你运行的当前内核不是6.8.12-1，运行下面命令一定要是这个版本内核哈
uname -a
Linux pve 6.8.12-1-pve #1 SMP PREEMPT_DYNAMIC PMX 6.8.12-1 (2024-08-05T16:17Z) x86_64 GNU/Linux


6、新建虚拟机
虚拟机使用ovmf+q35（推荐q35）或者ovmf+i440fx，配置中注意硬盘一定选择sata硬盘（至少128g，50g 80g等大小太不像物理机硬盘大小，别对硬盘大小太抠抠扣扣搜搜了，scsi及virtio硬盘光驱网卡设备等避开使用），ide或者sata光驱，显示先选择标准（弄好后再直通独显核显vgpu等），cpu选择host（1插槽多核心这点一定注意），网卡选择e1000显卡（注意网卡mac地址问题，免得检测虚拟机），避开各种virtio设备（scsi硬盘scsi光驱等），并修改虚拟机的args参数和我一样。内存请使用8192 16384 4096这三个数值（更加像物理机内存大小），对应8g 16g 4g，其他大小请勿设置（太假太像虚拟机）。
只有一个原则：硬盘大小，内存大小，网卡都得像真实物理机配置！！！
使用以下类似命令修改虚拟机配置
nano /etc/pve/qemu-server/100.conf

我的完整虚拟机配置如下:
args: -cpu host,rdtscp=off,hypervisor=off,vmware-cpuid-freq=false,enforce=false,host-phys-bits=true -smbios type=0 -smbios type=9 -smbios type=8 -smbios type=8
balloon: 0
bios: ovmf
boot: order=ide2;sata0;net0
cores: 8
cpu: host
efidisk0: local:102/vm-102-disk-0.raw,efitype=4m,size=528K
ide2: none,media=cdrom
localtime: 1
memory: 16384
meta: creation-qemu=9.0.2,ctime=1724320553
name: win10
net0: e1000=D8:FC:93:56:1D:C7,bridge=vmbr0,firewall=1
numa: 0
ostype: l26
sata0: local:102/vm-102-disk-1.raw,size=128G,ssd=1
scsihw: virtio-scsi-single
smbios1: uuid=505429c8-a350-41e9-9154-3851c095254e
sockets: 1
usb0: host=0000:3825
usb1: host=258a:002a
vmgenid: 2271babc-cafc-4c68-be8b-2bb3157c9924

虚拟机中的args参数我现在全部做了隐藏内部定制了，不需要指定了，就用我这上面的args就是。aida64你进去看就知道有些什么硬件了（风扇、温度、电压等）

7、开机虚拟机后请查看下日志信息有没有以下输出 注意function关键词
dmesg|grep dds
[ 4389.421280] Intel KVM lixiaoliu and dds666 v1.0 Start,ok!!!
[ 4396.844466] Intel KVM lixiaoliu and dds666 function is working!!

没有这个信息说明没成功，你检查下第3步骤中的运行成功有 Intel KVM lixiaoliu and dds666 这个输出没？

有这个信息就一路安装windows10去吧，其他内容详见 目前过不了的检测说明.txt，这个是高级检测，以前的虚拟机检测工具.rar（详见qq群 102166071，进群暗号pve，qq群 25438194 进群暗号 666，这个检测我认为是很初级的 ）你也可以试试。高级检测还得是al-khaser 另外增加了一个pafish64.exe检测软件。pafish和al-khaser是虚拟机环境检测的两个金标准。

8、kvm.ko kvm-amd.ko kvm-intel.ko 这三个模块你也可以不用加载，直接用pve原生内核中的，当然你也可以自己编译后加载

9、https://www.bilibili.com/read/cv26245305 该文章中开源内容外的内容全部开源，将在这个系列全部公布: https://www.bilibili.com/read/readlist/rl758108 pve反虚拟化检测玩游戏