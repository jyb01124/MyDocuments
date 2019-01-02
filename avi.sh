#!/bin/bash

cmp=""

cmd=("roscore" "rosrun image_view video_recorder image:='/usb_cam/image_raw' _filename:='Driving_video.avi' _image_transport:='compressed'" "rosbag play out.bag")

process=("rosout" "record" "video_recorder")

cd ~/Desktop/$1

for i in {0..2}; do
	gnome-terminal -x sh -c "${cmd[i]}"
	while [ True ]; do
		cmp=$(echo `ps -ef | grep ${process[i]} | grep -v "grep"`)
		echo "${process[i]}"
		if [ "$cmp" != "" ]; then
			break
		fi
	done
	cmp=""
done

