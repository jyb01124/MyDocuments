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

    def ROS_send(self):
        data = self.ser.readline()

        str_data = str(data).split(",")
        
        pitch = float(str_data[0])
        roll = float(str_data[1])
        yaw = float(str_data[2])

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
