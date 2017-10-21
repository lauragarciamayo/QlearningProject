import random
import struct
import time
import csv
import os
import sys
import binascii
import numpy as np

################
#adc
import Adafruit_BBIO.ADC as ADC
ADC.setup()
from time import sleep

pin1="P9_35"  #ain0
pin2="P9_37"  #ain2
pin3="P9_39"  #ain6
################
#pwm and GPIO
import Adafruit_BBIO.PWM as PWM
import Adafruit_BBIO.GPIO as GPIO
from time import sleep

#set GPIO

#control pins left motor
input_1A="P8_12"
input_2A="P8_14"
#control pins right motor
input_3A="P8_8"
input_4A="P8_10"

#set pins as output
GPIO.setup(input_1A,GPIO.OUT)
GPIO.setup(input_2A,GPIO.OUT)
GPIO.setup(input_3A,GPIO.OUT)
GPIO.setup(input_4A,GPIO.OUT)

#set PWM
motor1="P9_14"
motor2="P9_16"

################
class trajectory(object):
	def __init__(self,x_coord_origin,y_coord_origin,x_coord_s1,y_coord_s1,x_coord_s2,y_coord_s2,x_coord_s3,y_coord_s3):
		self.x_coord_origin=x_coord_origin
		self.y_coord_origin=y_coord_origin
		self.x_coord_s1=x_coord_s1
		self.y_coord_s1=y_coord_s1
		self.x_coord_s2=x_coord_s2
		self.y_coord_s2=y_coord_s2
		self.x_coord_s3=x_coord_s3
		self.y_coord_s3=y_coord_s3

class state_transition(object):
	def __init__(self, reward, next_s_type,next_state,terminal,emergency):	
	#def __init__(self, agent_next_location, reward, next_s_type,next_state,terminal,emergency):
	     #self.agent_next_location = agent_next_location 
	     self.reward = reward
	     self.next_s_type = next_s_type
	     self.next_state = next_state
	     self.terminal= terminal
	     self.emergency=emergency


def readSensors(pin1,pin2,pin3):
	
	# Read ADC voltages#################################
	#read sensor 1 (right)
	sensor1Val=ADC.read(pin1)
	sensor1Volts=sensor1Val*1.8 #range (0.96v : >=10cms to 0.13v: >70cms)
	
	#read sensor 2 (front)
	sensor2Val=ADC.read(pin2)
	sensor2Volts=sensor2Val*1.8 #range (0.96v : >=10cms to 0.13v: >70cms)

	#read sensor 3 (left)
	sensor3Val=ADC.read(pin3)
	sensor3Volts=sensor3Val*1.8 #range (0.96v : >=10cms to 0.13v: >70cms)

	#print "the ADC voltage is= : ",sensor1Volts,sensor2Volts,sensor3Volts

	sensors=list()
	sensors.append(sensor1Volts)
	sensors.append(sensor2Volts)
	sensors.append(sensor3Volts)	

	print sensors
	return sensors
	
def euclideanDistance2integers(sensors):
	
	#array of integers	
	state_vector=np.zeros(3)  #array of 3 elements
	
	state_vector[sensors.index(max(sensors))]=1
	state_vector[sensors.index(min(sensors))]=3

	for i in range(0,3):
		if state_vector[i]==0:
	       		state_vector[i]=2
  
	return	state_vector

def state_type(sensors,critical_voltage):

	# Find out the type of state: health or subhealth
	if sensors[0]>critical_voltage or sensors[1]>critical_voltage or sensors[2]>critical_voltage: 
		s_type=1 #subhealth state	        
	else:
	        s_type=2 #health state
    
	return s_type

def trans_reward(action,s_type,current_state):

	# assign rewards to state vector

	if action==4: #special action, emergency
	    reward=0
	else:
	    #action=
		# 1=forward,2=left,3=right
		
	    if current_state.argmax()==action: #best reward
		if s_type==1: #subhealth state
			reward=0
		else: #health state
		        reward=5
		
	    elif current_state.argmin()==action: #worst reward
		if s_type==1: #subhealth state
			reward=-3
		else: #health state
		        reward=0
	    else:

		if s_type==1: #subhealth state
			reward=-1
		else: #health state
		        reward=1

	return reward

def gotoRight():  #turn on 1st motor (left motor)
	
	#set pins high/low
	# 1a high and 2a low =right
	# 1a low  and 2a high=left
	# both high/both low =stop
	GPIO.output(input_1A,GPIO.HIGH)
	GPIO.output(input_2A,GPIO.LOW)
	GPIO.output(input_3A,GPIO.LOW)
	GPIO.output(input_4A,GPIO.LOW)

	duty=30
	
	PWM.start(motor1, duty)
	sleep(0.2)
	PWM.stop(motor1) #disable pwm immediately to rotate few angles
	PWM.cleanup()

def gotoLeft():  #turn on 2nd motor (right motor)
	
	#set pins high/low
	# 1a high and 2a low =right
	# 1a low  and 2a high=left
	# both high/both low =stop
	GPIO.output(input_1A,GPIO.LOW)
	GPIO.output(input_2A,GPIO.LOW)
	GPIO.output(input_3A,GPIO.HIGH)
	GPIO.output(input_4A,GPIO.LOW)

	duty=30
	PWM.start(motor2, duty)
	sleep(0.2)
	PWM.stop(motor2) #disable pwm immediately to rotate few angles
	PWM.cleanup()

def goForward():
	
	#set pins high/low
	# 1a higsh and 2a low =right
	# 1a low  and 2a high=left
	# both high/both low =stop
	GPIO.output(input_1A,GPIO.HIGH)
	GPIO.output(input_2A,GPIO.LOW)
	GPIO.output(input_3A,GPIO.HIGH)
	GPIO.output(input_4A,GPIO.LOW)

	duty=100
	
	PWM.start(motor1, duty)
	PWM.start(motor2, duty)
	#sleep(0.2)
	PWM.stop(motor1) #disable pwm immediately to rotate few angles
	PWM.stop(motor2)
	PWM.cleanup()

def goBackward():
	
	#set pins high/low
	# 1a high and 2a low =right
	# 1a low  and 2a high=left
	# both high/both low =stoP
	GPIO.output(input_1A,GPIO.LOW)
	GPIO.output(input_2A,GPIO.HIGH)
	GPIO.output(input_3A,GPIO.LOW)
	GPIO.output(input_4A,GPIO.HIGH)

	duty=30
	
	PWM.start(motor1, duty)
	PWM.start(motor2, duty)
	sleep(0.4)
	PWM.stop(motor1) #disable pwm immediately to rotate few angles
	PWM.stop(motor2)
	PWM.cleanup()

def execute_action(action):

#set of actions: 1:forward, 2:left 3:right 4:backwards/emergency
	duty=40
	if action==1: #forward
		goForward()
	elif action==2: #left
		gotoLeft()
	elif action==3: #right
		gotoRight()
	elif action==4: #backward	
		goBackward()
	elif action==5: #right and forward
		gotoRight()
		goForward()
	else: #left and forward
		gotoLeft()
		goForward()
		


def environment(action,current_state,s_type,critical_voltage,emergency_voltage,termination_voltage):	
	
	#execute action
	execute_action(action)	

	#obtain sensors measurement (voltages)
	sensors=readSensors(pin1,pin2,pin3)

	#check emergency case
	if (sensors[1]>=emergency_voltage):
		emergency=1

	else:
		emergency=0
			
	
	#find out the type of state (health or subhealth)
	next_s_type=state_type(sensors,critical_voltage)    	
	#print "state_type=",next_s_type

	#convert voltage/distance to interger verctor (state vector)
	next_state=euclideanDistance2integers(sensors)  #vector of 3 integers from 1-3
	#print "state= ",next_state
	
	#detect terminal state (3 sensors must give a voltage equal or greater than 0.9v
	if sensors[0]<=termination_voltage and sensors[1]<=termination_voltage and sensors[2]<=termination_voltage:
		terminal=1
	else:
		terminal=0

	#rewards
	reward=trans_reward(action,s_type,current_state)

	return state_transition(reward, next_s_type,next_state,terminal,emergency)
	#return state_transition(agent_next_location, reward, next_s_type,next_state,terminal,emergency)


def state_index(s,s_type):

	ref_state1=np.array([1,2,3])
	ref_state2=np.array([1,3,2])
	ref_state3=np.array([3,2,1])
	ref_state4=np.array([3,1,2])
	ref_state5=np.array([2,3,1])
	ref_state6=np.array([2,1,3])

	if np.array_equal(s,ref_state1)== True:
		s_index=1
	elif np.array_equal(s,ref_state2)== True:
		s_index=2
	elif np.array_equal(s,ref_state3)== True:
		s_index=3
	elif np.array_equal(s,ref_state4)== True:
		s_index=4
	elif np.array_equal(s,ref_state5)== True:
		s_index=5
	else:
		s_index=6
	
	if s_type==1: #subhealth state
	    s_index=s_index+6
	    
	s_index=s_index-1  #array indexing goes from 0 to 11
	
	return s_index


#MAIN
if __name__ == "__main__":
	
	#define start state
	#define emergengy flag
	#agent's trajectory coordinates array (coordinates of origin, s1,s2,s3)
	robotTrajectory=trajectory([],[],[],[],[],[],[],[])  #define original coordinates
	#inicializar state_transition

	Nepisodes=1

	critical_voltage=0.4 # ~15cms from the maze
	emergency_voltage=0.85 # 10cms or less from the maze
	termination_voltage=0.18 #[v]
	
	#actions
	a=[1,2,3]	#set of actions: 1:forward, 2:left 3:right
	Nactions=3 #number of actions

	#states
	Nstates=12	#12 states: 6 health and 6 subhealth

	#action value function Q
	Q=np.zeros((Nstates,Nactions)) 
	Q[0,2]=100
	Q[1,1]=100
	Q[2,0]=100
	Q[3,0]=100
	Q[4,1]=100
	Q[5,2]=100
	Q[6,2]=100
	Q[7,1]=100
	Q[8,0]=100
	Q[9,0]=100
	Q[10,1]=100
	Q[11,2]=100

	#Qlearning parameters
	gamma=0.9 #discount factor
	alpha=0.1 #step size constant
	epsilon=0.1 #epsilon for e-greedy policy

	#INITIAL STATE
	#obtain sensors measurement (voltages)
	sensors=readSensors(pin1,pin2,pin3)
	
	#check emergency case
	if (sensors[1]>=emergency_voltage):
		emergency=1
	else:
		emergency=0

	
	#find out the type of state (health or subhealth)
	s_type_start=state_type(sensors,critical_voltage)    	
	print "s_type_start",s_type_start
	
	#convert voltage/distance to interger verctor (state vector)
	start_state=euclideanDistance2integers(sensors)  #vector of 3 integers from 1-3
	print "start_state=",start_state

	#index of next state
	s_index=state_index(start_state,s_type_start)
	print "s_index_start=",s_index
	
	for i in range(0,Nepisodes):
	
		terminal=0
		#initialize state
		s=start_state
		s_type=s_type_start
#		location=initial_location

		#run until we find a terminal state
		while terminal==0:
			#choose next action (e-greedy)
			if (emergency == 1):
				a=4 #go backwards 
			else:

				Q_row=Q[s_index-1]
				if random.random()<(1-epsilon):
					
					if np.all(Q_row==0):
						a=random.randint(1,3)
					else:
						a=Q_row.argmax() +1
				else:
					a=random.randint(1,3)
			
			print "action=",a
	
			#execute the selected action and reach next state
			#s_transition=environment(a,s,s_type,location,critical_voltage,emergency_voltage,termination_voltage)	
			s_transition=environment(a,s,s_type,critical_voltage,emergency_voltage,termination_voltage)
			
			#index of next state
			s_index_next=state_index(s_transition.next_state,s_transition.next_s_type)
	
			if a !=4:  #emergency
				#update Q
				Q[s_index,a-1]=Q[s_index,a-1]+alpha*(s_transition.reward+gamma*max(Q[s_index_next,:])-Q[s_index,a-1])
	
			#update state, type of state and location
			s=s_transition.next_state
			s_type=s_transition.next_s_type
			s_index=s_index_next
			
			print "next_state=",s
			print "next_s_type=",s_type
			print "next_s_index=",s_index
			print "next_Q=",Q
			print "\n\n"
			#location.x_coord_origin=s_transition.x_coord_origin
			#location.y_coord_origin=s_transition.x_coord_origin
			#location.x_coord_s1=s_transition.x_coord_s1
			#location.y_coord_s1=s_transition.x_coord_s1
			#location.y_coord_s2=s_transition.x_coord_s2
			#location.x_coord_s2=s_transition.x_coord_s2
			#location.y_coord_s3=s_transition.x_coord_s3
			#location.x_coord_s3=s_transition.x_coord_s3

			#update trajectory array (array of set of coordinates) 
			#robotTrajectory.x_coord_origin.append(s_transition.agent_next_location.x_coord_origin)
			#robotTrajectory.y_coord_origin.append(s_transition.agent_next_location.y_coord_origin)
			#robotTrajectory.x_coord_s1.append(s_transition.agent_next_location.x_coord_s1)
			#robotTrajectory.y_coord_s1.append(s_transition.agent_next_location.y_coord_s1)
			#robotTrajectory.x_coord_s2.append(s_transition.agent_next_location.x_coord_s2)
			#robotTrajectory.y_coord_s2.append(s_transition.agent_next_location.y_coord_s2)
			#robotTrajectory.x_coord_s3.append(s_transition.agent_next_location.x_coord_s3)
			#robotTrajectory.y_coord_s3.append(s_transition.agent_next_location.y_coord_s3)

			emergency=s_transition.emergency
			terminal=s_transition.terminal
	
			print "emergency=",emergency
			print "terminal=",terminal
			#print "type=",s_type
			
			#sleep(0.25)
       
        
        
      


