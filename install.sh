echo 9 | ./fetch-macOS-v2.py

read choice
if [ ! -f BaseSystem.$choice.img ]; 
then
echo $choice | ./fetch-macOS-v2.py
cp BaseSystem.dmg BaseSystem.$choice.dmg
fi
echo 'Re-Write img from master ?\
Anything except n triggers yes'
read choice1
if [ "$choice1" != "n" ]; 
then
echo 'rewriting from master'
dmg2img -i BaseSystem.$choice.dmg BaseSystem.$choice.img
rm -f mac_hdd_ng.$choice.img
qemu-img create -f qcow2 mac_hdd_ng.$choice.img 128G
fi
echo "Copy over current files?\
Anything except n triggers yes"
read choice2
if [ "$choice2" != "n" ];
then
echo 'writing over'
cp mac_hdd_ng.$choice.img mac_hdd_ng.img
cp BaseSystem.$choice.img BaseSystem.img
fi

