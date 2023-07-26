# ----> Summary: gamelonglabels.s stores longer texts of code in order to make the main file less jarring
# 1 - SUMMON ATTACK (Will set player's attack positions)
# 2 - RESET PARAMETERS (Resets all variables to their default states)
# 3 - RESET PROJECTILES AND ENEMIES (Despawns every enemy and projectile)
# 4 - NUMBER SIZE (Checks the number of digits of a number)
# 5 - SPRITE STATUS UPDATE (Updates Sprite Status Number)
# 6 - INPUT CHECK  (Checks if user has made any input)

.text
#################################################
#		SUMMON ATTACK			#
#	   Once you start an attack,		#
#	   it'll summon a new attack		#
#	     (takes no arguments)		#
#################################################
										
SUMMON_NEW_ATTACK:	# Will see if player can summon a new magic ball
	la s1, MAGIC_ARRAY	# Loads MAGIC_ARRAY address to s1				
	lh t0, 14(s1)		# Loads the number of times Magic1 has been rendered (Magic_Status1)
	beqz t0,SET_MAGIC_POSITION	# If 0, it means it is inactive, thus, can be rendered from a new position
  		
	addi s1,s1,16		# Goes to the next Magic_Pos in the array
 	lh t0, 14(s1)		# Loads the number of times Magic1 has been rendered (Magic_Status2)
	beqz t0,SET_MAGIC_POSITION	# If 0, it means it is inactive, thus, can be rendered from a new position
		
	addi s1,s1,16		# Goes to the next Magic_Pos in the array
 	lh t0, 14(s1)		# Loads the number of times Magic1 has been rendered (Magic_Status3)
	beqz t0,SET_MAGIC_POSITION	# If 0, it means it is inactive, thus, can be rendered from a new position
		
	addi s1,s1,16		# Goes to the next Magic_Pos in the array
 	lh t0, 14(s1)		# Loads the number of times Magic1 has been rendered (Magic_Status4)
	beqz t0,SET_MAGIC_POSITION
	# If it reaches this point, all magic has been fired, so it'll skip to rendering
 	j ENDSUMMONNEWATTACK
 	SET_MAGIC_POSITION:
 		la t0,PLYR_STATUS	# Loads Player Status
 		lh t0,4(t0)		# Gets Player direction
 		beqz t0,SET_MAGIC_FRONT	# If player's looking down
		li t1,1
		beq t0,t1,SET_MAGIC_BACK # If player's looking up
		li t1,2
		beq t0,t1,SET_MAGIC_RIGHT # If player's looking right
		li t1,3
		beq t0,t1,SET_MAGIC_LEFT # If player's looking left
 		
 		SET_MAGIC_FRONT:
  			la t0,PLYR_POS	# Loads Player Position
  			lh t1,0(t0)	# Player's X
  			lh t2,2(t0)	# Player's Y
  			addi t1,t1,4	# Adds 4 pixel offset (in order to center it on player)
  			addi t2,t2,6	# Adds 6 pixel offset (to look like it is leaving from player)
  			li t0,240	# Screen height
  			bge t2,t0,ENDSUMMONNEWATTACK	# If Y >= 240, it's out of range, so it won't be rendered
  			sh t1,0(s1)	# Will store X on of given Magic_Pos
  			sh t2,2(s1)	# Will store Y on given Magic_Pos
  			li t0,0		# Sets t0 to 0,
  			sh t0,12(s1)	# storing in Magic_Status' direction (0 = Down)
			j ENDSUMMONNEWATTACK
		
		SET_MAGIC_BACK:
  			la t0,PLYR_POS	# Loads Player Position
  			lh t1,0(t0)	# Player's X
  			lh t2,2(t0)	# Player's Y
  			addi t1,t1,4	# Adds 4 pixel offset (in order to center it on player)
  			addi t2,t2,-8	# Subtracts 8 pixel offset (to look like it is leaving from player)
  			li t0,0		# Top of string
  			blt t2,t0,ENDSUMMONNEWATTACK	# If Y < 0, it's out of range, so it won't be rendered
  			sh t1,0(s1)	# Will store X on of given Magic_Pos
  			sh t2,2(s1)	# Will store Y on given Magic_Pos
  			li t0,1		# Sets t0 to 1,
  			sh t0,12(s1)	# storing in Magic_Status' direction (1 = Up)
			j ENDSUMMONNEWATTACK
			
			
		SET_MAGIC_RIGHT:
  			la t0,PLYR_POS	# Loads Player Position
  			lh t1,0(t0)	# Player's X
  			lh t2,2(t0)	# Player's Y
  			addi t1,t1,16	# Adds 12 pixel offset (to look like it is leaving from player)
  			addi t2,t2,4	# Adds 4 pixel offset (in order to center it on player)
  			li t0,272	# Screen width (whithout UI)
  			bge t1,t0,ENDSUMMONNEWATTACK	# If Y > 272, it's out of range, so it won't be rendered
  			sh t1,0(s1)	# Will store X on of given Magic_Pos
  			sh t2,2(s1)	# Will store Y on given Magic_Pos
  			li t0,2		# Sets t0 to 2,
  			sh t0,12(s1)	# storing in Magic_Status' direction (2 = Right)
			j ENDSUMMONNEWATTACK
			
		SET_MAGIC_LEFT:
  			la t0,PLYR_POS	# Loads Player Position
  			lh t1,0(t0)	# Player's X
  			lh t2,2(t0)	# Player's Y
  			addi t1,t1,-8	# Subtracts 8 pixel offset (to look like it is leaving from player)
  			addi t2,t2,4	# Adds 4 pixel offset (in order to center it on player)
  			li t0,0		# Top of screen
  			blt t1,t0,ENDSUMMONNEWATTACK	# If X < 0, it's out of range, so it won't be rendered
  			sh t1,0(s1)	# Will store X on of given Magic_Pos
  			sh t2,2(s1)	# Will store Y on given Magic_Pos
  			li t0,3		# Sets t0 to 3,
  			sh t0,12(s1)	# storing in Magic_Status' direction (3 = Left)
			j ENDSUMMONNEWATTACK
ENDSUMMONNEWATTACK:
  	lh t1,12(s1)		# Loads direction of magic to be summoned
	li t2,magic_speed	# Loads magic speed
	projectile_static_colision_check(s1,LEVEL_HIT_MAP,16,16,t1,t2,1)
	li t0,1					# Since if it's returned number 2, it won't despawn
	beq a0,t0,OUT_ENDSUMMONNEWATTACK	# If a0 = 1, despawn
	# otherwise, will be summoned
	li t0,1		# Sets t0 to 1,
	sh t0,14(s1)	# storing Magic_Status as if it was rendered once, so that algorithm knows that it has to be rendered			
	OUT_ENDSUMMONNEWATTACK:		
		ret

#################################################
#		RESET PARAMETERS		#
#	Resets parameter to their default	#
#	    state (takes no arguments)		#
#	     					#
#################################################
RESET_PARAMETERS:
	# Reseting Doors (default = closed (0))
	li t1,0			# Default value for doors (closed)
	la t0,Door_H_Status1	# Stores the states of the first horizontal door (0 = closed, 1 = open)
	sh t1,0(t0)		# Storing default value to Door_H_Status1
	la t0,Door_H_Status2	# Stores the states of the second horizontal door doors (0 = closed, 1 = open)
	sh t1,0(t0)		# Storing default value to Door_H_Status2
	la t0,Door_V_Status1	# Stores the states of the first vertical door (0 = closed, 1 = open)
	sh t1,0(t0)		# Storing default value to Door_V_Status1
	la t0,Door_V_Status2	# Stores the states of the second vertical door doors (0 = closed, 1 = open)
	sh t1,0(t0)		# Storing default value to Door_V_Status2
	
	# Reseting Keys (default = not collected (0))
	li t1,0			# Default value for keys (not collected)
	la t0,Key_Status1	# Stores the states of Key1 (0 = not collected, 1 = collected)
	sh t1,0(t0)		# Storing default value to Key_Status1
	la t0,Key_Status2	# Stores the states of Key2 (0 = not collected, 1 = collected)
	sh t1,0(t0)		# Storing default value to Key_Status2
	
	# Reseting Batteries (default = not collected (0))
	li t1,0			# Default value for batteries (not collected)
	la t0,Battery_Status1	# Stores the states of Battery1 (0 = not collected, 1 = collected)
	sh t1,0(t0)		# Storing default value to Battery_Status1
	la t0,Battery_Status2	# Stores the states of Battery2 (0 = not collected, 1 = collected)
	sh t1,0(t0)		# Storing default value to Battery_Status2
	
	# Reseting Chests (default = not collected (0))
	li t1,0			# Default value for chests (not collected)
	la t0,Chest_Status1	# Stores the states of Chest1 (0 = not collected, 1 = collected)
	sh t1,0(t0)		# Storing default value to Door_H_Status1
	la t0,Key_Status2	# Stores the states of Chest2 (0 = not collected, 1 = collected)
	sh t1,0(t0)		# Storing default value to Door_H_Status1
	
	# Reseting Warp Positions (default = 0,0)
	li t1,0
	la t0,Warp_Pos_1	# Stores the positions (top left x,y) of where the first warp box will tp player
	sh t1,0(t0)		# Storing 0 to X from Warp_Pos_1
	sh t1,2(t0)		# Storing 0 to Y from Warp_Pos_1
	sh t1,4(t0)		# Storing 0 to Warp_Pos_1 level section
	la t0,Warp_Pos_2	# Stores the positions (top left x,y) of where the second warp box will tp player
	sh t1,0(t0)		# Storing 0 to X from Warp_Pos_2
	sh t1,2(t0)		# Storing 0 to Y from Warp_Pos_2
	sh t1,4(t0)		# Storing 0 to Warp_Pos_2 level section
	la t0,Warp_Pos_2	# Stores the positions (top left x,y) of where the third warp box will tp player
	sh t1,0(t0)		# Storing 0 to X from Warp_Pos_3
	sh t1,2(t0)		# Storing 0 to Y from Warp_Pos_3
	sh t1,4(t0)		# Storing 0 to Warp_Pos_3 level section
	la t0,Warp_Pos_4	# Stores the positions (top left x,y) of where the fourth warp box will tp player
	sh t1,0(t0)		# Storing 0 to X from Warp_Pos_4
	sh t1,2(t0)		# Storing 0 to Y from Warp_Pos_4
	sh t1,4(t0)		# Storing 0 to Warp_Pos_4 level section
	
	ret

#################################################################
#		 RESET PROJECTILES AND ENEMIES 			#
#	   Despawns every projectile and every enemie		#
#	 is usually called when changing sections/levels	#
#################################################################

RESET_PROJECTILES_AND_ENEMIES:
	li s2, 0 			# S2 is a counter in START_RENDERING_MAGIC
	la s1, MAGIC_ARRAY		# Loads MAGIC_ARRAY address to s1
	START_RESETING_MAGIC:
		li t0,0				# If projectile can't move, stops rendering it
		sh t0, 14(s1)			# stores 0 in times rendered
		addi s1,s1,16			# Goes to the next Magic_Pos in the array
		li t0,max_plyr_projectile	# Max number of projectiles
		addi s2,s2,1			# s2 += 1
		bge s2,t0,RESET_ULA_PROJECTILES	# if s2 >= t0, stops loop 
		j START_RESETING_MAGIC
RESET_ULA_PROJECTILES: 		
	li s2, 0 			# S2 is a counter in START_RENDERING_MAGIC
	la s1, ULA_MAGIC_ARRAY		# Loads MAGIC_ARRAY address to s1
	START_RESETING_ULA_MAGIC:
		li t0,0				# If projectile can't move, stops rendering it
		sh t0, 14(s1)			# stores 0 in times rendered
		addi s1,s1,16			# Goes to the next Magic_Pos in the array
		li t0,max_enmy_projectile	# Max number of projectiles
		addi s2,s2,1			# s2 += 1
		bge s2,t0,RESET_ENEMIES	# if s2 >= t0, stops loop 
		j START_RESETING_ULA_MAGIC
RESET_ENEMIES:
	la s1,Slime_0											
	li t1,0
	sh t1,4(s1)	# disableing it's rendering
	
	la s1,Slime_1											
	li t1,0
	sh t1,4(s1)	# disableing it's rendering
	
	la s1,Slime_2											
	li t1,0
	sh t1,4(s1)	# disableing it's rendering
	
	la s1,Slime_3											
	li t1,0
	sh t1,4(s1)	# disableing it's rendering
	
	la s1,ULA_0											
	li t1,0
	sh t1,4(s1)	# disableing it's rendering
	
	la s1,ULA_1											
	li t1,0
	sh t1,4(s1)	# disableing it's rendering	
	
	la s1,ULA_2											
	li t1,0
	sh t1,4(s1)	# disableing it's rendering
	
	la s1,ULA_3											
	li t1,0
	sh t1,4(s1)	# disableing it's rendering
																																											
	ret																																															
												
##############     NUMBER SIZE    ###############
#						#
#    Checks how many digits a number has takes  #
#    a0 as argument and a1 as return register)  #
#						#
#################################################

NUMBERSIZE:
	bnez a0,NOTZERO	# If number is zero, it has one digit
	ZERO:
		li a1,1		# a1 stores the final digit count
		ret		# return
	NOTZERO:
		mv t0, a0	# Moves number to t0	
		li a1, 0 	# Digit counter
		li t2,10 	# Will be dividing numbers by 10
		NUMBER_LOOP:
			beqz t0,OUT_NUMBER_LOOP		# If t0 = 0, go out of the loop (there's no more digits to check)
			div t0,t0,t2			# Divides t0 (originally with a0's value) by t2 (10)
			addi a1,a1,1			# Adds 1 to the digit counte
			j NUMBER_LOOP			# Repeats loop
		OUT_NUMBER_LOOP:
			ret

#################################################################
#		    TRAIL COORDINATE CHECK 			#
#	Checks if the alterations of the old coordinates	#
#		for trail operation are valid			#
#################################################################

TRAIL_COORDINATE_CHECK:
	lh a1,4(a0)		# Loads X position in a1
	addi a1,a1,-4		# X -= 4 (to propperly remove trail when sprite stops moving)
	bgez a1,IS_OLD_X
	CANT_BE_OLD_X:
		addi a1,a1,4		# Reverts OLD X
	IS_OLD_X:
	lh a2,6(a0)		# Loads old Y position in a2
	addi a2,a2,-4		# X -= 4 (to propperly remove trail when sprite stops moving)
	bgez a2,IS_OLD_Y
	CANT_BE_OLD_Y:
		addi a2,a2,4		# Reverts OLD Y
	IS_OLD_Y:
	ret


#################################################################
#		    SPRITE STATUS UPDATE 			#
#	Updates sprite status for animation purposes		#
#								#
#################################################################

SPRITE_STATUS_UPDATE:
	li t2,1
	beq a1,t2, RESET
	li t2,2
	beq a1,t2,UPDATE_STATUS_V2
		lh t1,0(a0)	# Loads Sprite Status 
		lh t2,2(a0)	# Loads Sprite Info (0 if ascending - ADDSTATUS, 1 if descending - LOWERSTATUS)
		beqz t2,ADDSTATUS
		LOWERSTATUS:
			addi t1,t1,-1
			sh t1,0(a0)
			j CHECKSTATUS
		ADDSTATUS:
			addi t1,t1,1
			sh t1,0(a0)
		CHECKSTATUS:
			beqz t1,UPDATE
			beq t1,a2,UPDATE
			j ENDSPRITESTATUS
			UPDATE:
				xori t2,t2,1
				sh t2,2(a0)
				j ENDSPRITESTATUS
	UPDATE_STATUS_V2:
		lh t1,0(a0)	# Loads Sprite Status
		beq t1,a2,SET_ZERO_V2
		ADDSTATUS_V2:
			addi t1,t1,1
			sh t1,0(a0)
			j ENDSPRITESTATUS
		SET_ZERO_V2:
			li t1,0
			sh t1,0(a0)
			j ENDSPRITESTATUS
	
	RESET:
		# Resets sprite status to 1 and sprite info to 0
		li t1,1
		sh t1,0(a0)
		sh zero,2(a0)
	ENDSPRITESTATUS:
		ret

####################      INPUT CHECK       ######################
#								 #
#	Checks whether the player has pressed any key		 #
#								 #
##################################################################

INPUT_CHECK:		
	# Checks before seeing input
   	la t0, LEVEL_INFO		# Loads Level Info
   	lh t2,0(t0)			# t2 = level number (if t2 = 0, it means it is in the menu)
   	
	li t1,0xFF200000		# Loads KDMMIO Address
	lw t0,0(t1)			# Reads the Keybord Control bit
	andi t0,t0,0x0001		# masks least significant bit
   	beq t0,zero,NO_INPUT   	   	# If no input, get out of function
   	
   	# Checks before seeing input
   	la t0, LEVEL_INFO		# Loads Level Info
   	lh t2,0(t0)			# t2 = level number (if t2 = 0, it means it is in the menu)
   	la t0,PLYR_STATUS		# Loads Player Status
	lh t3,6(t0)			# t3 stores 0 if player isn't attacking and 1 if player is attacking
	bnez t3,ATTACK_UPDATE			# If player attacking, can't move, but it won't count as no input
  	
  	# Checking input
  	lw t0,4(t1)  			# Reads key value
  	check_key('s', MOV_DOWN, t0,SKIP_A)	# Checks if key pressed is 's'
	check_key('w', MOV_UP, t0,SKIP_B)	# Checks if key pressed is 'w'
	check_key('d', MOV_RIGHT, t0,SKIP_C)	# Checks if key pressed is 'd'
	check_key('a', MOV_LEFT, t0,SKIP_D)	# Checks if key pressed is 'a'
	check_key(32, ATTACK, t0,SKIP_E)	# Checks if key pressed is ' ' (SPACE)
	check_key('\n', SELECT, t0,SKIP_F)	# Checks if key pressed is '\n' (ENTER)
	check_key(127,KEY_KILL_PLYR, t0,SKIP_G)	# Checks if key pressed is (DELETE)
	check_key('1', SET_LEVEL_1, t0,SKIP_H)	# Checks if key pressed is '1' (LEVEL1)
	check_key('2', SET_LEVEL_2, t0,SKIP_I)	# Checks if key pressed is '2' (LEVEL2)
	check_key('3', SET_LEVEL_3, t0,SKIP_J)	# Checks if key pressed is '3' (LEVEL3)
	
	NO_INPUT_MENU:
		ret		
	NO_INPUT: 
		beqz t2,NO_INPUT_MENU	# If t2 = 0, it is on menu
		
		la t0,PLYR_STATUS		# Loads Player Status
		lh t3,6(t0)			# t3 stores 0 if player isn't attacking and 1 if player is attacking
		bnez t3,ATTACK_UPDATE			# If player attacking, can't move, but it won't count as no input
		level_colision(0,0)
		NO_MOVEMENT:
		li a0,0
		increment_position_y(a0, PLYR_POS, PLYR_HITBOX)
		sprite_status_update(PLYR_STATUS, 1, 0)
		ret	

	MOV_DOWN:
		beqz t2,SELECT_DOWN	# If t2 = 0, it is on menu
		
		level_colision(1,0)
		
		li a0,player_speed
		increment_position_y(a0, PLYR_POS, PLYR_HITBOX)
		la a0,PLYR_STATUS
		li t0,0
		sh t0,4(a0)
		sprite_status_update(PLYR_STATUS, 0, 2)
		ret
		
	MOV_UP:	
		beqz t2,SELECT_UP	# If t2 = 0, it is on menu
		
		level_colision(1,1)
		
		li a0,player_speed
		neg a0,a0
		increment_position_y(a0, PLYR_POS, PLYR_HITBOX)
		la a0,PLYR_STATUS
		li t0,1
		sh t0,4(a0)
		sprite_status_update(PLYR_STATUS, 0, 2)
		ret
		
	MOV_RIGHT:
		beqz t2,NO_INPUT_MENU	# If t2 = 0, it is on menu
		
		level_colision(1,2)
		
		li a0,player_speed
		increment_position_x(a0, PLYR_POS, PLYR_HITBOX)	# Increments Player's Y coordinate by 4, returning old position a1 = X and a2 = Y
		la a0,PLYR_STATUS
		li t0,2
		sh t0,4(a0)
		sprite_status_update(PLYR_STATUS, 0, 2)
		ret
		
	MOV_LEFT:
		beqz t2,NO_INPUT_MENU	# If t2 = 0, it is on menu
		
		level_colision(1,3)
		
		li a0,player_speed
		neg a0,a0
		increment_position_x(a0, PLYR_POS, PLYR_HITBOX)	# Increments Player's Y coordinate by 4, returning old position a1 = X and a2 = Y	
		la a0,PLYR_STATUS
		li t0,3
		sh t0,4(a0)
		sprite_status_update(PLYR_STATUS, 0, 2)
		ret
	
	ATTACK: # Used for attacks
		beqz t2,NO_INPUT_MENU	# If t2 = 0, it is on menu
		
		la a0,PLYR_STATUS
		li t0,0
		sh t0,0(a0)	# Loads Sprite Status 
		sh t0,2(a0)	# Loads Sprite Info (0 if ascending - ADDSTATUS, 1 if descending - LOWERSTATUS)
		li t0,1
		sh t0,6(a0)
		
		mv s9,ra
		call SUMMON_NEW_ATTACK
		mv ra,s9
		
		la t0,ATK_SFX_STATUS
		li t1,1
		sh t1,0(t0)
		
		li a7,30	# gets time passed
		ecall 		# syscall
		la t0,ATTACK_TIMER	# Loads RUN_TIME address
		sw a0,0(t0)	# new time is stored in RUN_TIME, in order to be compared later
		ret
	ATTACK_UPDATE:
		li a7,30	# gets time passed
		ecall 		# syscall
		la t0,ATTACK_TIMER	# Loads RUN_TIME address
		lw a1,0(t0)	# loads old time from RUN_TIME, in order to be compared later
		
		sub a0,a0,a1
		li t0,attack_delay
		bge t0,a0,DONT_UPDATE_ATTACK
		UPDATE_ATTACK:	
			la a0,PLYR_STATUS
			lh t0,8(a0)
			beqz t0,FIRST_ATTACK_UPDATE
			li t1,1
			beq t0,t1,SECOND_ATTACK_UPDATE
			li t1,2
			beq t0,t1,THIRD_ATTACK_UPDATE
			FIRST_ATTACK_UPDATE:
				li t0,1
				sh t0,0(a0)	# Stores Sprite Status 
				sh t0,2(a0)	# Stores Sprite Info (0 if ascending - ADDSTATUS, 1 if descending - LOWERSTATUS)
				sh t0,8(a0)	# Stores Sprite
				
				li a7,30	# gets time passed
				ecall 		# syscall
				la t0,ATTACK_TIMER	# Loads RUN_TIME address
				sw a0,0(t0)	# new time is stored in RUN_TIME, in order to be compared later
				j DONT_UPDATE_ATTACK
			SECOND_ATTACK_UPDATE:
				li t0,0
				sh t0,0(a0)	# Stores Sprite Status 
				sh t0,2(a0)	# Stores Sprite Info (0 if ascending - ADDSTATUS, 1 if descending - LOWERSTATUS)
				li t0,2
				sh t0,8(a0)	# Stores Sprite 
				
				li a7,30	# gets time passed
				ecall 		# syscall
				la t0,ATTACK_TIMER	# Loads RUN_TIME address
				sw a0,0(t0)	# new time is stored in RUN_TIME, in order to be compared later
				j DONT_UPDATE_ATTACK
			THIRD_ATTACK_UPDATE:
				li t0,1
				sh t0,0(a0)	# Stores Sprite Status
				li t0,0
				sh t0,2(a0)	# Stores Sprite Info (0 if ascending - ADDSTATUS, 1 if descending - LOWERSTATUS)
				sh t0,6(a0)	# Stores
				sh t0,8(a0)	# Stores Sprite 
				j DONT_UPDATE_ATTACK
		DONT_UPDATE_ATTACK:
			ret
	SELECT: # Probably ENTER will only be used for selecting stuff on menu :)
		la t0,LEVEL_INFO	# Loads LEVEL_INFO address
		lh t0,0(t0)		# And the Level index
		beqz t0, CONTINUE_SELECTION	# If player is in the menu (index = 0), continue selection
		ret				# otherwise, return
		CONTINUE_SELECTION:
			la t0, LEVEL_INFO		# Loads LEVEL_INFO address
			lh t0,2(t0)			# Checks what section of the menu it is at
			beqz t0,MAIN_SELECT		# and if it equals to 0, it'll go to main menu
			li t1,1				# otherwise, if it equals to 1 (game over menu),
			beq t1,t0,G.O_SELECT		# it'll go to to game over menu
			MAIN_SELECT:
				la t0, SELECT_STATUS		# Loads SELECT_STATUS address
				lh t0,0(t0)			# Loads the selection status
				beqz t0, MAIN_SELECT_START
				MAIN_SELECT_EXIT:
					li a7,10
					ecall
				MAIN_SELECT_START:
					# Will set first LEVEL_INFO to 1 
					la t0, LEVEL_INFO
					li t1,1
					sh t1,0(t0)
					ret
			G.O_SELECT:
				la t0, SELECT_STATUS		# Loads SELECT_STATUS address
				lh t0,0(t0)			# Loads the selection status
				beqz t0, G.O_SELECT_START
				li t1,1
				beq t1,t0,G.O_SELECT_MENU
				G.O_SELECT_EXIT:
					li a7,10
					ecall
				G.O_SELECT_MENU:
					la t0, LEVEL_INFO
					li t1,0
					sh t1,0(t0)
					sh t1,2(t0)
					la t0, SELECT_STATUS		# Loads SELECT_STATUS address
					sh t1,0(t0)
					j MENU
				G.O_SELECT_START:
					# Will set first LEVEL_INFO to 1 
					la t0, LEVEL_INFO
					li t1,1
					sh t1,0(t0)
					sh t1,2(t0)
					ret
		
		
	SELECT_DOWN:
		la t0, LEVEL_INFO		# Loads LEVEL_INFO address
		lh t0,2(t0)			# Checks what section of the menu it is at
		beqz t0,MAIN_SELECT_DOWN		# and if it equals to 0, it'll go to main menu
		li t1,1				# otherwise, if it equals to 1 (game over menu),
		beq t1,t0,G.O_SELECT_DOWN	# it'll go to to game over menu
		MAIN_SELECT_DOWN:
			la t0, SELECT_STATUS	# Gets selection status
			lh t1,0(t0)		# and loads it		
			beqz t1,MAIN_SELECT_DOWN_NORMAL	# if it's equal to zero, it'll set it to one
			MAIN_SELECT_DOWN_ARROUND: # otherwise
				li t1,0		  # loads 0
				sh t1,0(t0)	  # and stores it (wrap arround)
				ret
			MAIN_SELECT_DOWN_NORMAL:
				li t1,1		# loads 1
				sh t1,0(t0)	# and stores it
				ret
		G.O_SELECT_DOWN:
			la t0, SELECT_STATUS	# Gets selection status
			lh t1,0(t0)		# and loads it	
			li t2,2			# loads 2
			bne t1,t2,G.O_SELECT_DOWN_NORMAL # if it's not equal to 2, add 1 to it
			G.O_SELECT_DOWN_ARROUND: # otherwise
				li t1,0		 # loads 0
				sh t1,0(t0)	 # and stores it (wrap arround)
				ret
			G.O_SELECT_DOWN_NORMAL:
				addi t1,t1,1	# adds 1 to status
				sh t1,0(t0)	# and stores it
				ret
			
	SELECT_UP:
		la t0, LEVEL_INFO		# Loads LEVEL_INFO address
		lh t0,2(t0)			# Checks what section of the menu it is at
		beqz t0,MAIN_SELECT_UP		# and if it equals to 0, it'll go to main menu
		li t1,1				# otherwise, if it equals to 1 (game over menu),
		beq t1,t0,G.O_SELECT_UP		# it'll go to to game over menu
		MAIN_SELECT_UP:
			la t0, SELECT_STATUS	# Gets selection status
			lh t1,0(t0)		# and loads it
			bnez t1,MAIN_SELECT_UP_NORMAL	# if it's not equal to zero, it'll set it to zero
			MAIN_SELECT_UP_ARROUND:	# otherwise
				li t1,1		# loads 1
				sh t1,0(t0)	# and stores it (wrap arround)
				ret
			MAIN_SELECT_UP_NORMAL:
				li t1,0		# loads 0
				sh t1,0(t0)	# and stores it
				ret
		G.O_SELECT_UP:
			la t0, SELECT_STATUS	# Gets selection status
			lh t1,0(t0)		# and loads it
			bnez t1,G.O_SELECT_UP_NORMAL	# if it's not equal to zero, subtract 1 from it
			G.O_SELECT_UP_ARROUND:	# otherwise
				li t1,2		# loads 2
				sh t1,0(t0)	# and stores it (wrap arround)
				ret
			G.O_SELECT_UP_NORMAL:
				addi t1,t1,-1	# subtracts 1 from status (selection up)
				sh t1,0(t0)	# and stores it
				ret
	
	SET_LEVEL_1:
		la t0,LEVEL_INFO
		li t1,1		# Get Level 1 index
		sh t1,0(t0)	# and store it afterwards
		li t1,0		# t1 = 0
		sh t1,2(t0)	# level section = 0
		sh t1,4(t0)	# reset parameters = 0 (will reset)
		
		call STOP_SOUND	

		la t0,PLYR_INFO	# Loads PLYR_INFO
		li t1,player_health	# otherwise, restore player's health (after all, this is a cheat)
		sh t1,0(t0)	# and store it again
		
		j START_GAME
		
	SET_LEVEL_2:
		la t0,LEVEL_INFO
		li t1,2		# Get Level 2 index
		sh t1,0(t0)	# and store it afterwards
		li t1,0		# t1 = 0
		sh t1,2(t0)	# level section = 0
		sh t1,4(t0)	# reset parameters = 0 (will reset)
		
		call STOP_SOUND	

		la t0,PLYR_INFO	# Loads PLYR_INFO
		li t1,player_health	# otherwise, restore player's health (after all, this is a cheat)
		sh t1,0(t0)	# and store it again
		
		j START_GAME
		
	SET_LEVEL_3:
		la t0,LEVEL_INFO
		li t1,3		# Get Level 2 index
		sh t1,0(t0)	# and store it afterwards
		li t1,0		# t1 = 0
		sh t1,2(t0)	# level section = 0
		sh t1,4(t0)	# reset parameters = 0 (will reset)
		
		call STOP_SOUND	

		la t0,PLYR_INFO	# Loads PLYR_INFO
		li t1,player_health	# otherwise, restore player's health (after all, this is a cheat)
		sh t1,0(t0)	# and store it again
		j START_GAME

	KEY_KILL_PLYR:
		beqz t2,NO_INPUT_MENU	# If t2 = 0, it is on menu
		j KILL_PLYR