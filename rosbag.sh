#!/bin/bash

cmd=("roslaunch racecar teleop.launch" "rosbag record /usb_cam/image_raw/compressed  /ackermann_cmd /ackermann_cmd_mux/active /ackermann_cmd_mux/input/default /ackermann_cmd_mux/input/navigation /ackermann_cmd_mux/input/teleop /ackermann_cmd_mux/output /ackermann_cmd_mux/parameter_descriptions /ackermann_cmd_mux/parameter_updates /ackermann_cmd_mux_nodelet_manager/bond /diagnostics /joy /odom /tf /tf_static /vehicle_geometry/footprint /vesc/commands/motor/brake /vesc/commands/motor/current /vesc/commands/motor/duty_cycle /vesc/commands/motor/position /vesc/commands/motor/speed /vesc/commands/servo/position /vesc/sensors/core /vesc/sensors/servo_position_command /vesc/vesc_to_odom/reset_odometry -O out.bag")

cd ~/Desktop/

echo `gnome-terminal -x sh -c "${cmd[0]}"`
mkdir $1
cd ./$1
echo `${cmd[1]}`
