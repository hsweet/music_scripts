import pyautogui as pg
import time
import os

print('Press Ctrl-C to quit.')
pg.FAILSAFE = True 
os.chdir("/home/harry/Music/charts/Jake/musescore")
cf = "/home/harry/Music/Jake/musescore"

s=-5 #  How many half steps up or down
# clarinet =
# Eb =
# open muse files from list

#for files in xxx
#f = open ('file','r')

def mousepos():
	while True: 
		print (pg.position())
		time.sleep(.5)


pg.click(440,440);pg.hotkey ('ctrl','a') # get focus + select all

for steps in range(s):  #how many 1/2 steps
	if s > 0:
		pg.press('up')   #transpose
	elif s < 0:
		pf.press('down')
	
pg.hotkey('ctrl','s')
pg.hotkey('ctrl','q')



 
