#-*- coding: utf-8 -*-

import serial
import math

import rospy
from geometry_msgs.msg import Quaternion, Twist
from tf.broadcaster import TransformBroadcaster
from sensor_msgs.msg import Imu

class MPU_9250:
    
    ser = 0
    pub = 0
    imuMsg = 0
    Accelration = []
    Gyro = []
    Compass = []

    def __init__(self):
        self.ser = serial.Serial()
        self.ser.port = "/dev/ttyUSB0"
        self.ser.baudrate = 115200
        self.ser.open()

        rospy.init_node("node")
        self.pub = rospy.Publisher('imu', Imu, queue_size = 10)
        self.imuMsg = Imu()

    def __del__(self):
        self.ser.close()

    def ROS_receive(self):
        data = self.ser.readline()

        str_data = str(data).split(":")
        self.Accelration = self.str_int(str_data[0])
        self.Gyro = self.str_int(str_data[1])
        self.Compass = self.str_int(str_data[2])

    def str_int(self, str_v):
        str_list = []
        int_list = []

        str_list = str_v.split(",")

        for count in range(0,3):
            int_list.append(int(str_list[count]))
        return int_list

    def ROS_calc(self):
        roll = 180*math.atan(self.Accelration[1]/(math.sqrt((self.Accelration[0]**2)+(self.Accelration[2]**2))))/math.pi
        pitch = 180*math.atan(self.Accelration[0]/(math.sqrt((self.Accelration[1]**2)+(self.Accelration[2]**2))))/math.pi
        

    def ROS_send(self, pitch, roll, yaw):
        quaternion = self.O_Q_convention(pitch, roll, yaw)
        
        self.imuMsg.orientation.x = quaternion[0] #magnetometer
        self.imuMsg.orientation.y = quaternion[1]
        self.imuMsg.orientation.z = quaternion[2]
        self.imuMsg.orientation.w = quaternion[3]

        self.imuMsg.header.stamp= rospy.Time.now()
        self.imuMsg.header.frame_id = 'IMU_Rviz'
        self.pub.publish(self.imuMsg)

    def O_Q_convention(self, pitch, roll, yaw):  # yaw (Z), pitch (Y), roll (X)

        cy = float(math.cos(yaw * 0.5))
        sy = float(math.sin(yaw * 0.5))
        cp = float(math.cos(pitch * 0.5))
        sp = float(math.sin(pitch * 0.5))
        cr = float(math.cos(roll * 0.5))
        sr = float(math.sin(roll * 0.5))

        q = []

        q.append(cy * cp * cr + sy * sp * sr)
        q.append(cy * cp * sr - sy * sp * cr)
        q.append(sy * cp * sr + cy * sp * cr)
        q.append(sy * cp * cr - cy * sp * sr)
        
        return q





if __name__ == "__main__":
    dan = MPU_9250()
    while True:
        dan.ROS_send()
