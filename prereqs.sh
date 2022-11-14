touch /etc/rc.local
chmod 0755 /etc/rc.local
echo 
apt install linux-generic qemu uml-utilities virt-manager git wget libguestfs-tools p7zip-full make dmg2img fish libguestfs-tools uml-utilities
touch /etc/wsl.conf
echo '[boot]
systemd=true' > /etc/wsl.conf
echo '[Unit]
Description=enable /etc/rc.local
ConditionPathExists=/etc/rc.local

[Service]
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target' > /etc/rc.local
echo '
ip tuntap add dev tap0 mode tap
ip link set tap0 up promisc on
brctl addif virbr0 tap0

ip link set dev virbr0 up
ip link set dev tap0 master virbr0' >> /etc/rc.local
mkdir /home/$USER 2> /dev/null
ln -s ./OSX-KVM /home/$USER/OSX-KVM
systemctl enable rc-local
echo 1 | tee /sys/module/kvm/parameters/ignore_msrs
cp kvm.conf /etc/modprobe.d/kvm.conf  

apt-get install  virt-manager

ip tuntap add dev tap0 mode tap
ip link set tap0 up promisc on
brctl addif virbr0 tap0
ip link set dev virbr0 up
ip link set dev tap0 master virbr0
virsh net-start default
virsh net-autostart default



usermod -aG kvm $(whoami)
usermod -aG libvirt $(whoami)
usermod -aG input $(whoami)
setfacl -m u:libvirt-qemu:rx /home/$USER
setfacl -R -m u:libvirt-qemu:rx /home/$USER/OSX-KVM
setfacl -R -m u:libvirt-qemu:rx /home/$USER

