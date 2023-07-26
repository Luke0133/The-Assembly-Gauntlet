# ----> Summary: soundtracks.s stores labels assotiated with soundtracks/sound effects in order to make the main file less jarring
# 1 - PLAY MUSIC (Literally the brains of playing soundtrack/sound effect)
# 2 - PLAY SOUND (Calls all enabled soundtracks/sound effects to play)
# 3 - STOP SOUND (Stops all sounds that are playing)
# 4 - RESET SOUNDTRACK (Enables given soundtrack to play - or loop, if it has ended)

.eqv volume 50	# sound volume

.data
ATK_SFX:
ATK_SFX_TIME: .word 0
.half
ATK_SFX_STATUS: 0,0,7 # Stores whether soundtrack should be played (0 = no, 1 = yes) and note index to be played, and instrument
ATK_SFX_LENGTH: 3
ATK_SFX_NOTES: 20,100,40,100,60,100

COLLECT_SFX:
COLLECT_SFX_TIME: .word 0
.half
COLLECT_SFX_STATUS: 0,0,7 # Stores whether soundtrack should be played (0 = no, 1 = yes) and note index to be played, and instrument
COLLECT_SFX_LENGTH: 3
COLLECT_SFX_NOTES: 77,100,78,100,67,100

DAMAGE_SFX:
DAMAGE_SFX_TIME: .word 0
.half
DAMAGE_SFX_STATUS: 0,0,7 # Stores whether soundtrack should be played (0 = no, 1 = yes) and note index to be played, and instrument
DAMAGE_SFX_LENGTH: 5
DAMAGE_SFX_NOTES:  40,50,35,50,30,50,35,50,20,50

KILL_ENEMY_SFX:
KILL_ENEMY_SFX_TIME: .word 0
.half
KILL_ENEMY_SFX_STATUS: 0,0,31 # Stores whether soundtrack should be played (0 = no, 1 = yes) and note index to be played, and instrument
KILL_ENEMY_SFX_LENGTH: 3
KILL_ENEMY_SFX_NOTES: 20,100,40,100,60,100


# MENU: Final Fantasy VII OST - Aerith's Theme 
MENU_MSC:
MENU_MSC_TIME: .word 0
.half
MENU_MSC_STATUS: 0,0,72 # Stores whether soundtrack should be played (0 = no, 1 = yes) and note index to be played, and instrument
MENU_MSC_LENGTH: 17
MENU_MSC_NOTES: 60,469,64,469,72,2814,71,469,67,469,62,2345,60,234,62,234,60,1876,63,469,62,469,60,469,62,469,60,1876,65,938,72,938,72,3504

# GAME OVER MENU: Mario Kart Wii OST - Losing Results (Race)
G.O_MENU_MSC:
G.O_MENU_MSC_TIME: .word 0
.half
G.O_MENU_MSC_STATUS: 0,0,114 # Stores whether soundtrack should be played (0 = no, 1 = yes) and note index to be played, and instrument
G.O_MENU_MSC_LENGTH: 165
G.O_MENU_MSC_NOTES: 66,437,71,24,71,296,75,12,75,143,76,9,76,296,75,12,75,426,71,34,71,143,73,9,73,296,66,12,66,143,68,9,68,296,71,12,71,426,68,34,68,143,71,9,71,296,75,12,75,143,78,9,78,437,75,24,75,437,78,24,78,437,80,24,80,437,81,24,81,437,80,24,80,296,78,12,78,1020,66,55,66,437,71,24,71,296,75,12,75,143,76,9,76,296,75,12,75,426,71,34,71,143,73,9,73,296,66,12,66,143,68,9,68,296,71,12,71,426,75,34,75,143,78,9,78,296,75,12,75,143,83,9,83,437,81,24,81,437,79,24,79,296,81,12,81,426,78,34,78,143,79,9,79,296,78,12,78,143,76,9,76,296,78,12,78,1020,66,55,66,437,71,24,71,296,75,12,75,150,76,1,76,307,75,426,71,34,71,150,73,1,73,296,66,12,66,150,68,1,68,296,71,12,71,426,68,34,68,150,71,1,71,296,75,12,75,150,78,1,78,437,75,24,75,437,78,24,78,437,80,24,80,437,81,24,81,437,80,24,80,307,78,1020,66,55,66,437,71,24,71,296,75,12,75,150,76,1,76,307,75,426,71,34,71,150,73,1,73,296,66,12,66,150,68,1,68,296,71,12,71,426,75,34,75,426,71,34,71,143,78,9,78,437,74,24,74,296,71,12,71,143,74,9,74,307,73,426,71,34,71,440,71,21,71,150,69,1,69,296,67,12,67,150,66,1,66,437,66,24,66,437

# LEVEL 1: Bowser's Inside Story OST  - Plack Beach
LVL1_MSC:
LVL1_MSC_TIME: .word 0
.half
LVL1_MSC_STATUS: 0,0,114 # Stores whether soundtrack should be played (0 = no, 1 = yes) and note index to be played, and instrument
LVL1_MSC_LENGTH: 103
LVL1_MSC_NOTES: 67,441,72,735,65,441,72,294,72,147,70,147,68,147,67,441,60,735,62,441,65,441,64,147,62,147,64,294,60,147,55,735,62,441,65,294,65,147,64,147,62,147,64,294,72,147,72,1323,74,294,76,294,67,441,72,735,65,441,72,294,72,147,70,147,68,147,67,441,60,735,62,441,65,441,64,147,62,147,64,294,60,147,55,735,62,441,65,294,65,147,64,147,62,147,64,294,72,147,72,1323,74,294,76,294,72,147,72,147,71,147,72,147,74,147,76,294,74,294,72,147,71,147,72,735,72,147,72,147,71,147,72,147,74,147,76,294,74,294,76,147,77,147,76,147,74,147,72,147,71,147,69,147,67,441,72,735,65,441,72,294,72,147,70,147,68,147,67,441,60,735,62,441,65,441,64,147,62,147,64,294,60,147,55,735,62,441,65,294,65,147,64,147,62,147,64,294,72,147,72,1029,74,294,77,294,76,294

# LEVEL 2: Deltarune OST - Scarlet Forest  
LVL2_MSC:
LVL2_TIME: .word 0
.half
LVL2_MSC_STATUS: 0,0,1 # Stores whether soundtrack should be played (0 = no, 1 = yes) and note index to be played, and instrument
LVL2_LENGTH: 158
LVL2_NOTES: 62,756,60,252,62,756,60,252,55,756,53,252,55,882,57,126,59,756,57,252,59,756,57,252,53,756,52,252,53,756,55,126,53,126,52,504,55,504,62,504,64,504,65,504,60,504,62,504,64,504,67,1764,64,126,65,126,67,756,65,126,64,126,67,1008,62,756,60,252,62,756,60,252,55,756,53,252,55,882,57,126,59,756,60,252,59,252,57,252,55,252,57,252,53,252,52,252,53,252,55,252,53,756,55,126,53,126,52,504,55,504,62,504,64,504,65,504,67,504,71,504,72,504,67,1764,64,126,65,126,67,756,65,126,64,126,67,1008,55,248,57,248,60,248,57,248,55,248,57,248,64,248,57,248,55,248,57,248,64,248,62,248,60,248,62,248,64,992,67,248,65,248,64,248,65,248,67,248,71,248,70,248,65,248,67,496,72,992,55,248,57,248,60,248,57,248,55,248,57,248,64,248,57,248,55,248,57,248,67,248,65,248,64,248,65,248,67,744,67,124,69,124,71,248,71,248,71,248,71,248,64,496,62,496,60,496,62,496,76,992,76,248,74,248,72,248,74,248,76,992,76,248,74,248,72,248,74,248,76,744,74,248,71,744,69,248,67,744,65,248,64,248,65,248,67,248,69,248,71,248,71,248,71,248,71,248,71,496,64,248,67,248,65,248,65,248,65,248,65,248,65,496,79,248,77,248,76,1488,71,496,79,496,81,496,77,496,76,496

# LEVEL 3: Final Fantasy VII OST - One Winged Angel 
LVL3_MSC:
LVL3_MSC_TIME: .word 0
.half
LVL3_MSC_STATUS: 0,0,26 # Stores whether soundtrack should be played (0 = no, 1 = yes) and note index to be played, and instrument
LVL3_MSC_LENGTH: 92
LVL3_MSC_NOTES: 60,469,55,234,52,234,60,234,55,234,64,234,60,234,66,234,64,1641,67,469,69,234,67,234,66,234,67,1172,69,234,67,234,71,351,70,351,69,234,67,3752,66,234,64,234,66,234,64,234,66,117,65,117,64,234,62,234,64,234,66,117,65,117,64,234,62,234,64,234,65,234,64,234,66,234,64,234,67,234,64,234,67,234,64,234,67,117,65,117,64,234,62,234,64,234,67,117,65,117,64,234,62,234,64,234,65,234,64,234,67,234,64,234,66,234,64,234,66,234,64,234,66,117,65,117,64,234,62,234,64,234,66,117,65,117,64,234,62,234,64,234,65,234,64,234,66,234,64,234,67,234,64,234,67,234,64,234,67,117,65,117,64,234,62,234,64,234,67,117,65,117,64,234,62,234,64,234,65,234,64,234,67,234,64,234

# LEVEL 4: The Legend Of Zelda Ocarina of Time OST - Song of Storms
LVL4_MSC:
LVL4_MSC_TIME: .word 0
.half
LVL4_MSC_STATUS: 0,0,1 # Stores whether soundtrack should be played (0 = no, 1 = yes) and note index to be played, and instrument
LVL4_MSC_LENGTH: 43
LVL4_MSC_NOTES: 60,149,64,149,72,598,60,149,64,149,72,598,74,448,76,149,74,149,76,149,74,149,71,149,67,598,67,299,60,299,64,149,65,149,67,897,67,299,60,299,64,149,65,149,62,897,60,149,64,149,72,598,60,149,64,149,72,598,74,448,76,149,74,149,76,149,74,149,71,149,67,598,67,299,60,299,64,149,65,149,67,598,67,299,60,1794


# DEATH: Kirby's Dreamland OST - Death Theme
DEATH_MSC:
DEATH_MSC_TIME: .word 0
.half
DEATH_MSC_STATUS: 0,0,26 # Stores whether soundtrack should be played (0 = no, 1 = yes) and note index to be played, and instrument
DEATH_MSC_LENGTH: 18
DEATH_MSC_NOTES: 84,236,83,23,83,138,82,26,82,236,81,13,81,118,80,6,80,236,75,13,75,355,80,19,80,118,79,6,79,711,78,38,78,63,79,650

# END GAME: Kirby's Dreamland OST - Kirby Victory Theme
END_GAME_MSC:
END_GAME_MSC_TIME: .word 0
.half
END_GAME_MSC_STATUS: 0,0,40 # Stores whether soundtrack should be played (0 = no, 1 = yes) and note index to be played, and instrument
END_GAME_MSC_LENGTH: 33
END_GAME_MSC_NOTES: 65,120,67,120,69,120,71,120,69,120,71,120,72,240,67,120,64,360,65,120,67,120,69,120,71,120,69,120,71,120,72,360,64,360,65,120,67,120,69,120,71,120,69,120,71,120,72,240,67,120,64,240,79,120,77,240,76,120,74,240,76,120,72,360,84,360

.text
####################       PLAY MUSIC       ######################
#								 #
#     Literally the brains of playing soundtrack/sound effect 	 #
#								 #
##################################################################



PLAY_MUSIC:	
# s1 is the address of an array of informations as followed:
# (0)	  SONGNAME: 
# (0) 	  SONGNAME_TIME: .word 0  --- stores the time when note started playing
#     	  .half
# (4,6,8) SONGNAME_STATUS: 0,0,0
#	 		   | | |
#			   | | +--> Stores instrument
#			   | +----> Index of note to be played (note address = 2 * index)
#			   +------> Stores whether soundtrack should be played (0 = no, 1 = yes) -- enabler
#
# (10)	   SONGNAME_LENGTH: 0   --- stores the lenght of song
# (12,14)  SONGNAME_NOTES: 0,0,.... --- stores note and duration, respectively

	lh t0,4(s1)		# Loads Given Address' first status (enabler)
	beqz t0,CANT_PLAY_SOUND	# If enabler = 0 (can't play soundtrack/sound effect)
	WILL_PLAY_SOUND:
		lh t0,6(s1)	# Gets note index
		slli t0,t0,2	# t0 = 4 * index
		add s2,s1,t0	# address used for getting notes and durations
		
		lw t0,0(s1)	# Gets time note started playing
		beqz t0,PLAY_NOTE	# If t0 = 0, it means the song just started
		# Otherwise, check if enough time has passed to play a new note
		li a7,30	# Gets new time
		ecall
		sub t0,a0,t0	# t0 = new time - starting time
		
		lh t1,14(s2)
		bge t0,t1,PLAY_NEW_NOTE
		j DONT_PLAY_NOTE
		
		
		PLAY_NEW_NOTE:
			lh t0,6(s1)	# Gets note index
			addi t0,t0,1	# New index
			sh t0,6(s1)	# Stores new note index
			slli t0,t0,2	# t0 = 4 * index
			add s2,s1,t0	# address used for getting notes and durations
		PLAY_NOTE:
		
			lh a0,12(s2)	# Loads note 
			lh a1,14(s2)	# Loads note duration		
			lh a2,8(s1)	# Loads instrument
			li a3,volume	# Loads volume
			li a7,31	# syscall play midi
			ecall
			
			li a7,30	# Gets new time
			ecall
			
			sw a0,0(s1)	# and stores it
			
		DONT_PLAY_NOTE:
			lh t0,10(s1)	# loads soundtrack length
			lh t1,6(s1)	# loads note index
			blt t1,t0,CONTINUE_PLAYING
			STOP_PLAYING:
				li t0, 0 	# loads 0 to t0
				sh t0, 4(s1)	# and stores it in SOUNDNAME conditions (to stop playing)
				sh t0, 6(s1)	# DON'T FORGET TO RESET THE INDEX DUMBO
				ret
			CONTINUE_PLAYING:	
				ret
	CANT_PLAY_SOUND:
		ret


####################       PLAY SOUND       ######################
#								 #
#	Plays all permited soundtracks/sound effects		 #
#								 #
##################################################################

PLAY_SOUND:
	
	play(MENU_MSC)
	
	play(LVL1_MSC)
	
	play(LVL2_MSC)

	play(LVL3_MSC)
	
	play(LVL4_MSC)

	play(ATK_SFX)	
	
	play(COLLECT_SFX)	
	
	play(DAMAGE_SFX)	
	
	play(KILL_ENEMY_SFX)
	
	play(END_GAME_MSC)
	
	play(DEATH_MSC)
	
	play(G.O_MENU_MSC)
	
	ret

####################       STOP SOUND       #####################
#								#
#		   Resets all soundtracks/sound			#
#    		 effects (stops them from playing) 		#
#								#
#################################################################
STOP_SOUND:
	li t1,0		# Loads 0 to t1 (0 is for stopping a soundtrack/sound effect)(0 is for reseting note index) 
	
	la t0,MENU_MSC_STATUS		# Loads MENU music status
	sh t1,0(t0)			# Stores 0 to MENU_MSC_STATUS' first address (stop soundtrack/effect)
	sh t1,2(t0)			# Stores 0 to MENU_MSC_STATUS' second address (resets note index)
	
	la t0,LVL1_MSC_STATUS		# Loads LVL1 music status
	sh t1,0(t0)			# Stores 0 to LVL1_MSC_STATUS' first address (stop soundtrack/effect)
	sh t1,2(t0)			# Stores 0 to LVL1_MSC_STATUS' second address (resets note index)
	
	la t0,LVL2_MSC_STATUS		# Loads LVL2 music status
	sh t1,0(t0)			# Stores 0 to LVL2_MSC_STATUS' first address (stop soundtrack/effect)
	sh t1,2(t0)			# Stores 0 to LVL2_MSC_STATUS' second address (resets note index)
	
	la t0,LVL3_MSC_STATUS		# Loads LVL3 music status
	sh t1,0(t0)			# Stores 0 to LVL3_MSC_STATUS' first address (stop soundtrack/effect)
	sh t1,2(t0)			# Stores 0 to LVL3_MSC_STATUS' second address (resets note index)
	
	la t0,LVL4_MSC_STATUS		# Loads LVL4 music status
	sh t1,0(t0)			# Stores 0 to LVL4_MSC_STATUS' first address (stop soundtrack/effect)
	sh t1,2(t0)			# Stores 0 to LVL4_MSC_STATUS' second address (resets note index)
	
	la t0,ATK_SFX_STATUS		# Loads ATK_SFX_STATUS music status
	sh t1,0(t0)			# Stores 0 to ATK_SFX_MSC_STATUS' first address (stop soundtrack/effect)
	sh t1,2(t0)			# Stores 0 to ATK_SFX_MSC_STATUS' second address (resets note index)
	
	la t0,COLLECT_SFX_STATUS	# Loads COLLECT_SFX_STATUS music status
	sh t1,0(t0)			# Stores 0 to COLLECT_SFX_MSC_STATUS' first address (stop soundtrack/effect)
	sh t1,2(t0)			# Stores 0 to COLLECT_SFX_MSC_STATUS' second address (resets note index)
	
	la t0,DAMAGE_SFX_STATUS		# Loads DAMAGE_SFX_STATUS music status
	sh t1,0(t0)			# Stores 0 to DAMAGE_SFX_MSC_STATUS' first address (stop soundtrack/effect)
	sh t1,2(t0)			# Stores 0 to DAMAGE_SFX_MSC_STATUS' second address (resets note index)
	
	la t0,END_GAME_MSC_STATUS	# Loads END_GAME_MSC_STATUS music status
	sh t1,0(t0)			# Stores 0 to END_GAME_MSC_STATUS' first address (stop soundtrack/effect)
	sh t1,2(t0)			# Stores 0 to END_GAME_MSC_STATUS' second address (resets note index)
	
	la t0,DEATH_MSC_STATUS		# Loads DEATH_MSC_STATUS music status
	sh t1,0(t0)			# Stores 0 to DEATH_MSC_STATUS' first address (stop soundtrack/effect)
	sh t1,2(t0)			# Stores 0 to DEATH_MSC_STATUS' second address (resets note index)
	
	la t0,G.O_MENU_MSC_STATUS	# Loads G.O_MENU_MSC_STATUS music status
	sh t1,0(t0)			# Stores 0 to G.O_MENU_MSC_STATUS' first address (stop soundtrack/effect)
	sh t1,2(t0)			# Stores 0 to G.O_MENU_MSC_STATUS' second address (resets note index)
	
	ret

	
#################       RESET SOUNDTRACK       ##################
#								#
#		   Enables given soundtrack to			#
#    		keep playing (even after ending) 		#
#								#
#################################################################		
				
RESET_SOUNDTRACK:
	lh t0,4(s1)	# Loads music label's first status (enabler)
	bnez t0,STILL_PLAYING # and if it equals to 0, it is still playing
	STOPED_PLAYING:	# Otherwise, reset note's index to 0
		li t1,0		# Loads 0 to t1 (0 is for reseting note index) 
		sw t1,0(s1)	# Stores 0 in the timer for given label
		sh t1,6(s1)	# Stores 0 in given label's second address (resets note index)
	STILL_PLAYING:	# Guarantee that music is enabled
		li t1,1		# Loads 1 to t1 (1 is for enabling a soundtrack/sound effect to play)
		sh t1,4(s1)	# Stores 1 to given label's (in macro) first address (enable soundtrack/effect)
	ret
