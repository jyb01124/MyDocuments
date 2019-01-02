#!/bin/bash

cd ~/Downloads

sudo apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE
sudo add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo xenial main" -u
sudo rm -f /etc/apt/sources.list.d/realsense-public.list
sudo apt-get -y update
sudo apt-get -y install librealsense2-dkms
sudo apt-get -y install librealsense2-utils
sudo apt-get -y install librealsense2-dev
sudo apt-get -y install librealsense2-dbg

cd ~/Downloads
wget https://raw.githubusercontent.com/oroca/oroca-ros-pkg/kinetic/ros_install.sh

sed -i 's/~\/catkin_ws/~\/\$name_catkinws/g' ros_install.sh
sed -i '99,101d' ros_install.sh

chmod +x ~/Downloads/ros_install.sh

./ros_install.sh xycar kinetic

sed -i 's/localhost/192.168.5.25/g' ~/.bashrc
sed -i 's/ROS_HOSTNAME=192.168.25.5/ROS_HOSTNAME=192.168.5.5/g' ~/.bashrc
source ~/.bashrc

cd ~/Downloads

git clone https://github.com/RacecarJ/installRACECARJ.git

cd ~/Downloads/installRACECARJ

sed -i 's/racecar-ws/xycar/g' installMITRACECAR.sh
sed -i 's/.\/scripts\/installROS.sh/#\.\/scripts\/installROS.sh/g' installMITRACECAR.sh

sed -i '15,21d' ~/Downloads/installRACECARJ/scripts/installCDCACM.sh

chmod +x ./installMITRACECAR.sh
./installMITRACECAR.sh

cd ~/xycar/src/
rm -rf ./zed-ros-wrapper/

source ~/xycar/devel/setup.bash
cd ~/xycar && catkin_make

cd ~/xycar/src/
git clone https://github.com/ros-drivers/usb_cam.git
git clone https://github.com/robopeak/rplidar_ros.git
git clone https://github.com/KristofRobot/razor_imu_9dof.git
git clone https://github.com/intel-ros/realsense.git

sudo apt-get -y install python-visual
sudo apt-get -y install ros-kinetic-gazebo-ros-pkgs ros-kinetic-gazebo-ros-control
sudo apt-get -y install ros-kinetic-ros-control ros-kinetic-ros-controllers
sudo apt-get -y install ros-kinetic-joint-state-controller
sudo apt-get -y install ros-kinetic-effort-controllers
sudo apt-get -y install ros-kinetic-position-controllers

cd ~/Desktop/
git clone https://github.com/XytronCo/xycar_viewer
cd ./xycar_viewer/install_file/xycontroller_package/
mv -f xycar_sim ~/xycar/src/

source ~/xycar/devel/setup.bash
cd ~/xycar && catkin_make

gazebo &
sleep 5s
killall -2 gazebo

cd ~/Desktop/xycar_viewer/install_file

mv -f ./display_3D_visualization.py ~/xycar/src/razor_imu_9dof/nodes/  
mv -f ./pointcloud.rviz ~/xycar/src/realsense/realsense2_camera/rviz/  
mv -f ./rplidar.rviz ~/xycar/src/rplidar_ros/rviz/  
mv -f ./xycar.rviz ~/xycar/src/xycar_sim/rviz/  
mv -f ./gui.ini ~/.gazebo  

cd ~/Desktop/xycar_viewer/launch/

mv -f ./usb_cam_remote_view.launch ~/xycar/src/usb_cam/launch/
mv -f ./imu_viewer.launch ~/xycar/src/razor_imu_9dof/launch/
mv -f ./display_lidar.launch ~/xycar/src/rplidar_ros/launch/
mv -f ./display_realsense.launch ~/xycar/src/realsense/realsense2_camera/launch/

cd ~/Desktop/xycar_viewer/ && mkdir pid

sudo apt install -y python-pip
pip install pyyaml

echo "complete!"

