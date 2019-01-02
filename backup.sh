sudo rm -rf /media/nvidia/JetSonSSD
sudo rm -r /home/nvidia/.ros/log
sudo rm /home/nvidia/.bash_history

cd /
sudo tar --acls -cvpzf AAA.tar.gz --exclude=/AAA.tar.gz --one-file-system /

sudo mv /AAA.tar.gz /home/nvidia/2018_1121_SSD_backup_tr.tar.gz
