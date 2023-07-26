# ----> Summary: colisionlabels.s stores labels assotiated to colision checks in order to make the main file less jarring
# 1 - STATIC COLISION CHECK (Checks colision from a map)
# 2 - STATIC COLISION INFO (Contains informations for processing the prior colision check)
# 3 - DYNAMIC COLISION CHECK (Checks colision from entities - mooving or not)
# 4 - LEVEL COLISION (Prepares colision checks for each level)

.text
#########################     STATIC COLISION CHECK    ##########################
#    	 -----------           argument registers           -----------   	#
#		a0 = Map Hitbox Address						#
#		a1 = X coordinate (top left)					#
#		a2 = Y coordinate (top left					#
#		a3 = width of sprite						#
# 		a4 = height of sprite						#
#		a5 = direction (0 = down, 1 = up, 2 = right, 3 = left)		#
#		a6 = movement speed (for player: 4 pixels per frame)		#
#		a7 = entity type (0 for player, 1 for anything else)		#
#		s10 = stores original ra					#
#  	 -----------          returning registers           -----------   	#
#		a0 = 0(can go through) 1,(can't go through)or 2 		#
#		(can't go through and take damage)				#
#################################################################################

STATIC_COLISION_CHECK:
	mv s10,ra		# stores original ra
	addi a0,a0,8		# skips size information
	add a0,a0,a1		# a0 = a0 + X
	li t0,320		# t0 = 320
	mul t0,t0,a2		# t0 = 320 * Y 
	add a0,a0,t0		# a0 = a0 + X + (320 * Y) -- TOP LEFT PIXEL OF SPRITE LOCATION

	beqz a5,STATIC_CHECK_DOWN 	# if direction = 0, go to CHECK_DOWN
	li t0,1
	beq a5,t0,STATIC_CHECK_UP 	# if direction = 1, go to CHECK_UP
	li t0,2
	beq a5,t0,STATIC_CHECK_RIGHT	# if direction = 2, go to CHECK_RIGHT
	li t0,3
	beq a5,t0,STATIC_CHECK_LEFT	# if direction = 3, go to CHECK_LEFT
	j ENDSTATICCOLISIONCHECK

	STATIC_CHECK_DOWN:	# Checks 4 pixels on the bottom of the player sprite (bottom left - Pixel 1, bottom pixel 8, bottom pixel 16 and bottom right - Pixel 24)
		li t0,320
		mul t0,t0,a6 	# Hypothetical Y value if player were to go down
		add a0,a0,t0	# THE TOP LEFT PIXEL OF PLAYER CORRESPONDS TO a0 = a0 + X + (320 * Y) + (320 * Y')
	
		li t0,320
		mul t0,a4,t0	# t0 = height * 320 
		add t0,a0,t0	# THE BOTTOM LEFT PIXEL OF PLAYER CORRESPONDS TO t0 = a0 + X + (320 * Y) + (320 * Y') + (height * 320)
	
		#Checking values of colision
		li a0,0
		mv a1,t0
		call STATIC_COLISION_INFO	# a1, corresponds to the 1st pixel on the bottom row (bottom left)
		li t2,3
		div t2,a3,t2
		add a1,a1,t2		# a1, corresponds to the 8th pixel on the bottom row
		call STATIC_COLISION_INFO
		add a1,a1,t2		# a1, corresponds to the 16th pixel on the bottom row
		call STATIC_COLISION_INFO
		add a1,a1,t2		# a1, corresponds to the 24th pixel on the bottom row (bottom right)
		call STATIC_COLISION_INFO
		j ENDSTATICCOLISIONCHECK
	
	STATIC_CHECK_UP: # Checks 4 pixels on the top of the player sprite (top left - Pixel 1, top pixel 8, top pixel 16 and top right - Pixel 24)
		li t0,320
		mul t0,t0,a6 	# Hypothetical Y value if player were to go down
		add t0,a0,t0	# THE TOP LEFT PIXEL OF PLAYER CORRESPONDS TO a0 = a0 + X + (320 * Y) + (320 * Y')
	
		li a0,0
		mv a1,t0
		call STATIC_COLISION_INFO	# a1, corresponds to the 1st pixel on the top row (top left)
		li t2,3
		div t2,a3,t2
		add a1,a1,t2		# a1, corresponds to the 8th pixel on the top row
		call STATIC_COLISION_INFO
		add a1,a1,t2		# a1, corresponds to the 16th pixel on the top row
		call STATIC_COLISION_INFO
		add a1,a1,t2		# a1, corresponds to the 24th pixel on the top row (bottom right)
		call STATIC_COLISION_INFO
		j ENDSTATICCOLISIONCHECK
	STATIC_CHECK_RIGHT: # Checks 4 pixels on the rightmost column of the player sprite (top right - Pixel 1, pixel 8, pixel 16 and bottom right - Pixel 24)
		add a0,a0,a6		# THE TOP LEFT PIXEL OF PLAYER CORRESPONDS TO a0 = a0 + X + (320 * Y) + X' --> (a6)
		add t0,a0,a3		# THE TOP RIGHT PIXEL OF PLAYER CORRESPONDS TO a0 = a0 + X + (320 * Y) + X' + width
		
		li a0,0
		mv a1,t0
		call STATIC_COLISION_INFO	# a1, corresponds to the 1st pixel on the leftmost column (top left)
		li t2,3
		div t2,a4,t2		# t1 = %height/3
		li t3,320
		mul t2,t2,t3		# t1 = %height/3 * 320
		add a1,a1,t2		# a1, corresponds to the 8th pixel on the leftmost column
		call STATIC_COLISION_INFO
		add a1,a1,t2		# a1, corresponds to the 16th pixel on the leftmost column
		call STATIC_COLISION_INFO
		add a1,a1,t2		# a1, corresponds to the 24th pixel on the leftmost row (bottom left)
		call STATIC_COLISION_INFO
		j ENDSTATICCOLISIONCHECK
	STATIC_CHECK_LEFT: # Checks 4 pixels on the leftmost column of the player sprite (top left - Pixel 1, pixel 8, pixel 16 and bottom left - Pixel 24)
		add t0,a0,a6		# THE TOP LEFT PIXEL OF PLAYER CORRESPONDS TO a0 = a0 + X + (320 * Y) + X' --> (a6)
		
		li a0,0
		mv a1,t0
		call STATIC_COLISION_INFO	# a1, corresponds to the 1st pixel on the leftmost column (top left)
		li t2,3
		div t2,a4,t2		# t1 = %height/3
		li t3,320
		mul t2,t2,t3		# t1 = %height/3 * 320
		add a1,a1,t2		# a1, corresponds to the 8th pixel on the leftmost column
		call STATIC_COLISION_INFO
		add a1,a1,t2		# a1, corresponds to the 16th pixel on the leftmost column
		call STATIC_COLISION_INFO
		add a1,a1,t2		# a1, corresponds to the 24th pixel on the leftmost row (bottom left)
		call STATIC_COLISION_INFO
		j ENDSTATICCOLISIONCHECK
ENDSTATICCOLISIONCHECK:
	mv ra,s10		# retrieves original ra
	ret

##################################################################
#		      STATIC COLISION INFO 			 #
#	Checks the position given by position_check in the	 #
#     hitbox map, associating the colors to their respective	 #
# values, returning in a0 0(can go through) 1,(can't go through) #
#  or 2 (go to next level). Here are the values			 #
# 			in order of priority:			 #
#   -> -64 - A2(blue): wall					 #
#   -> 47 - 2F(orange): wall that projectiles can pass through	 #
#   -> -58 - C6(purple): level exit				 #
#   -> 56 - 38(light_green): blank space 			 #
##################################################################

STATIC_COLISION_INFO:
	lb a2, 0(a1)
	
	# Testing if hits a wall
	li t3, -64		# Color of a wall hitbox
	beq a2,t3,INFO_WALL	# If wall detected, go to INFO_WALL
	li t4,1			# 1 is the return value if a wall was detected, so:
	beq a0,t4,ENDSTATICCOLISIONINFO	# if a wall was previously detected, player shouldn't move at all
	# Testing if hits level exit
	li t3,47			# Color of a projectile wall hitbox
	beq a2,t3,INFO_PROJECTILE_WALL	# If exit detected, go to INFO_PROJECTILE_WALL
	# Testing if hits level exit
	li t3,-58		# Color of a exit hitbox
	beq a2,t3,INFO_EXIT	# If exit detected, go to INFO_EXIT
	# Testing if doesn't hit anything at all
	li t3, 56		# Color of space hitbox (walkable)
	beq a2,t3,INFO_SPACE	# If space detected, go to INFO_SPACE
	j ENDSTATICCOLISIONINFO	# If nothing was detected (probably an error), abort
		INFO_WALL:
			li a0,1
			j ENDSTATICCOLISIONINFO
		INFO_PROJECTILE_WALL:
			li a0,2			# Magic colision will process this differently
			j ENDSTATICCOLISIONINFO
		INFO_EXIT:
			li a0,0
			bnez a7,ENDSTATICCOLISIONINFO	# If entity coliding with exit isn't player, won't process
			la t0,LEVEL_INFO
			lh t1,0(t0)	# Loads Level Index
			addi t1,t1,1	# and adds 1 to it
			sh t1,0(t0)	# storing it afterwards
			li t1,0		# t1 = 0
			sh t1,2(t0)	# level section = 0
			sh t1,4(t0)	# reset parameters = 0 (will reset)
			
			j SETUP
		INFO_SPACE:
			li a0,0
			j ENDSTATICCOLISIONINFO	
ENDSTATICCOLISIONINFO:
	ret
	
########################     DYNAMIC COLISION CHECK    ##########################
#    	 -----------           argument registers           -----------   	#
#		a0 = X coordinate (top left) - First				#
#		a1 = Y coordinate (top left) - First				#			
#		a2 = width of FIRST sprite					#
# 		a3 = height of FIRST sprite					#
#		s7 = type of entity - First					#
#		a4 = X coordinate (top left) - Second				#
#		a5 = Y coordinate (top left) - Second				#
#		a6 = width of SECOND sprite					#
#		a7 = height of SECOND sprite					#
#		s8 = type of entity - Second					#
#										#
#		s6 = enemy label address - when processing enemies		#
#   -------------------------------------------------------------------------   #
# 	Two rectangles won't overlap only if the lowest coordinate of one	#
#   is above the highest coordinate of the other or if the leftmost coordinate  #
#	of one is greater then the rightmost coordinate of the other		#
#################################################################################

DYNAMIC_COLISION_CHECK:
	add t0,a0,a2		# X coordinate (bottom right) - First
	add t1,a1,a3		# Y coordinate (bottom right) - First
	add t4,a4,a6		# X coordinate (bottom right) - Second
	add t5,a5,a7		# Y coordinate (bottom right) - Second

	bgt a0,t4,PRE_NO_COLISION	# Is the leftmost X (First) greater than the rightmost X (Second)? 1(True) if no colision
	bgt a4,t0,PRE_NO_COLISION	# Is the leftmost X (Second) greater than the rightmost X (First)? 1(True) if no colision

	bgt a5,t1,PRE_NO_COLISION	# Is the lowest Y (First) greater than the highest Y (Second)? 1(True) if no colision
	bgt a1,t5,PRE_NO_COLISION	# Is the lowest Y (Second) greater than the highest Y (First)? 1(True) if no colision
	j START_DYNAMIC_COLISION_CHECK
	PRE_NO_COLISION:
	j NO_COLISION
	# If program reaches this point, there was indeed a colision between the entities, now it will check what operation to do
	# 0 - Player
	# 1 - Player Projectile
	# 2 - Enemy
	# 3 - Enemy Projectile
	# 4 - Key
	# 5 - Door
	# 6 - Chest
	# 7 - Warp Block
	# 8 - Battery
	START_DYNAMIC_COLISION_CHECK:
	bnez s7,SKIP_PLAYER_ENTITY
	j PLAYER_ENTITY
	SKIP_PLAYER_ENTITY:
	li t0,1
	bne t0,s7,SKIP_MAGIC_ENTITY
	j MAGIC_ENTITY
	SKIP_MAGIC_ENTITY:
	li t0,3
	bne t0,s7,SKIP_ENEMY_MAGIC_ENTITY
	j ENEMY_MAGIC_ENTITY
	SKIP_ENEMY_MAGIC_ENTITY:
	PLAYER_ENTITY:
		li a0,0
		li t0,2
		bne t0,s8,SKIP_Process.enemy.player
		j Process.enemy.player
		SKIP_Process.enemy.player:
		li t0,4
		bne t0,s8,SKIP_Process.key.player
		j Process.key.player
		SKIP_Process.key.player:
		li t0,5
		bne t0,s8,SKIP_Process.door.player
		j Process.door.player
		SKIP_Process.door.player:
		li t0,6
		bne t0,s8,SKIP_Process.chest.player
		j Process.chest.player
		SKIP_Process.chest.player:
		li t0,7
		bne t0,s8,SKIP_Process.warp.player
		j Process.warp.player
		SKIP_Process.warp.player:
		li t0,8
		bne t0,s8,SKIP_Process.battery.player
		j Process.battery.player
		SKIP_Process.battery.player:
		j ENDDYNAMICCOLISIONCHECK
		Process.enemy.player:
			li a0,1
			lh t0,8(s6)	# Gets enemy type
			beqz t0,Process.slime.player
			li t1,2
			beq t1,t0,Process.ULA.player
			Process.slime.player:	# Slimes die upon contact to player, but take away 10 poitns of the player's health 
				lh t0,4(s6)		# Loads slime's health
				beqz t0,NO_COLISION_ENEMY	# if slime is dead, don't check colision
				lh t0,6(s6)		# Loads slime's health
				beqz t0,NO_COLISION_ENEMY	# if slime is dead, don't check colision
				la t0,PLYR_INFO	# otherwise, load PLYR_INFO
				lh t2,0(t0)	# and load player health
				addi t2,t2,-10	# Takes away 10 HP
				sh t2,0(t0)	# and stores it
				lh t2,2(t0)	# Loads player's score
				addi t2,t2,50	# and adds 50 to it
				sh t2,2(t0)	# storing it afterwards
				li t0,0		# t0 = 0
				sh t0,6(s6)	# and stores it in slime health
				la t0,DAMAGE_SFX_STATUS
				li t1,1
				sh t1,0(t0)
				j ATTACK_ANIMATION_MELEE
				
			Process.ULA.player:
				lh t0,4(s6)		# Loads ULA's health
				beqz t0,NO_COLISION_ENEMY	# if ULA is dead, don't check colision
				lh t0,6(s6)		# Loads ULA's health
				beqz t0,NO_COLISION_ENEMY	# if slime is dead, don't check colision
				la t0,PLYR_INFO	# otherwise, load PLYR_INFO
				lh t2,0(t0)	# and load player health
				addi t2,t2,-10	# Takes away 10 HP
				sh t2,0(t0)	# and stores it
				la t0,DAMAGE_SFX_STATUS
				li t1,1
				sh t1,0(t0)
				j ENDDYNAMICCOLISIONCHECK
			NO_COLISION_ENEMY:
				j NO_COLISION
		Process.key.player:
			la t0, Key_Hitbox1
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			slli t1,a5,16
			add t1,t1,a4
			bne t0,t1,PROCESS_KEY2.player
			PROCESS_KEY1.player:
				la t0, Key_Status1
				lh t0,0(t0)
				beqz t0,NOT_COLLECTED_KEY1.player
				COLLECTED_KEY1.player:
					j ENDDYNAMICCOLISIONCHECK
				NOT_COLLECTED_KEY1.player:
					li t1,1
					la t0,PLYR_INFO
					lh t2,4(t0)
					add t2,t2,t1
					sh t2,4(t0)
					lh t2,2(t0)
					addi t2,t2,10
					sh t2,2(t0)
					la t0,Key_Status1
					sh t1,0(t0)
					remove_static_trail(Key_Pos1,LEVEL_MAP,16,16)
					la t0,COLLECT_SFX_STATUS
					li t1,1
					sh t1,0(t0)
					j ENDDYNAMICCOLISIONCHECK
			PROCESS_KEY2.player:
				la t0, Key_Status2
				lh t0,0(t0)
				beqz t0,NOT_COLLECTED_KEY2.player
				COLLECTED_KEY2.player:
					j ENDDYNAMICCOLISIONCHECK
				NOT_COLLECTED_KEY2.player:
					li t1,1
					la t0,PLYR_INFO
					lh t2,4(t0)
					add t2,t2,t1
					sh t2,4(t0)
					lh t2,2(t0)
					addi t2,t2,10
					sh t2,2(t0)
					la t0,Key_Status2
					sh t1,0(t0)
					remove_static_trail(Key_Pos2,LEVEL_MAP,16,16)
					la t0,COLLECT_SFX_STATUS
					li t1,1
					sh t1,0(t0)
					j ENDDYNAMICCOLISIONCHECK
		Process.door.player:
			# Turning both X and Y into a single word
			slli t2,a5,16
			add t2,t2,a4
			# Checking X and Y of each Door and seeing which one is being tested
			la t0, Door_H_Pos1
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			beq t0,t2,PROCESS_HORIZONTAL_DOOR1.player
			la t0, Door_H_Pos2
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			beq t0,t2,PROCESS_HORIZONTAL_DOOR2.player
			la t0, Door_V_Pos1
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			beq t0,t2,PROCESS_VERTICAL_DOOR1.player
			j PROCESS_VERTICAL_DOOR2.player
			PROCESS_HORIZONTAL_DOOR1.player:
				la t0,Door_H_Status1
				lh t1,0(t0)
				beqz t1,IS_CLOSED_HORIZONTAL_DOOR1.player
				IS_OPEN_HORIZONTAL_DOOR1.player:
					li a0,0
					j ENDDYNAMICCOLISIONCHECK
				IS_CLOSED_HORIZONTAL_DOOR1.player:
					la t0,PLYR_INFO
					lh t1,4(t0)
					beqz t1,DONT_OPEN_HORIZONTAL_DOOR1.player
					OPEN_HORIZONTAL_DOOR1.player:
						la t0,Door_H_Status1
						li t1,1
						sh t1,0(t0)
						remove_static_trail(Door_H_Pos1,LEVEL_MAP,32,12)
						la t0,PLYR_INFO
						lh t1,4(t0)
						addi t1,t1,-1
						sh t1,4(t0)
						li a0,0
						j ENDDYNAMICCOLISIONCHECK
					DONT_OPEN_HORIZONTAL_DOOR1.player:	
						li a0,1
						j ENDDYNAMICCOLISIONCHECK
			PROCESS_HORIZONTAL_DOOR2.player:
				la t0,Door_H_Status2
				lh t1,0(t0)
				beqz t1,IS_CLOSED_HORIZONTAL_DOOR2.player
				IS_OPEN_HORIZONTAL_DOOR2.player:
					li a0,0
					j ENDDYNAMICCOLISIONCHECK
				IS_CLOSED_HORIZONTAL_DOOR2.player:
					la t0,PLYR_INFO
					lh t1,4(t0)
					beqz t1,DONT_OPEN_HORIZONTAL_DOOR2.player
					OPEN_HORIZONTAL_DOOR2.player:
						la t0,Door_H_Status2
						li t1,1
						sh t1,0(t0)
						remove_static_trail(Door_H_Pos2,LEVEL_MAP,32,12)
						la t0,PLYR_INFO
						lh t1,4(t0)
						addi t1,t1,-1
						sh t1,4(t0)
						li a0,0
						j ENDDYNAMICCOLISIONCHECK
					DONT_OPEN_HORIZONTAL_DOOR2.player:	
						li a0,1
						j ENDDYNAMICCOLISIONCHECK
			PROCESS_VERTICAL_DOOR1.player:
				la t0,Door_V_Status1
				lh t1,0(t0)
				beqz t1,IS_CLOSED_VERTICAL_DOOR1.player
				IS_OPEN_VERTICAL_DOOR1.player:
					li a0,0
					j ENDDYNAMICCOLISIONCHECK
				IS_CLOSED_VERTICAL_DOOR1.player:
					la t0,PLYR_INFO
					lh t1,4(t0)
					beqz t1,DONT_OPEN_VERTICAL_DOOR1.player
					OPEN_VERTICAL_DOOR1.player:
						la t0,Door_V_Status1
						li t1,1
						sh t1,0(t0)
						remove_static_trail(Door_V_Pos1,LEVEL_MAP,8,38)
						la t0,PLYR_INFO
						lh t1,4(t0)
						addi t1,t1,-1
						sh t1,4(t0)
						li a0,0
						j ENDDYNAMICCOLISIONCHECK
					DONT_OPEN_VERTICAL_DOOR1.player:	
						li a0,1
						j ENDDYNAMICCOLISIONCHECK
			PROCESS_VERTICAL_DOOR2.player:
				la t0,Door_V_Status2
				lh t1,0(t0)
				beqz t1,IS_CLOSED_VERTICAL_DOOR2.player
				IS_OPEN_VERTICAL_DOOR2.player:
					li a0,0
					j ENDDYNAMICCOLISIONCHECK
				IS_CLOSED_VERTICAL_DOOR2.player:
					la t0,PLYR_INFO
					lh t1,4(t0)
					beqz t1,DONT_OPEN_VERTICAL_DOOR2.player
					OPEN_VERTICAL_DOOR2.player:
						la t0,Door_V_Status2
						li t1,1
						sh t1,0(t0)
						remove_static_trail(Door_V_Pos2,LEVEL_MAP,8,38)
						la t0,PLYR_INFO
						lh t1,4(t0)
						addi t1,t1,-1
						sh t1,4(t0)
						li a0,0
						j ENDDYNAMICCOLISIONCHECK
					DONT_OPEN_VERTICAL_DOOR2.player:	
						li a0,1
						j ENDDYNAMICCOLISIONCHECK
		Process.chest.player:
			la t0, Chest_Hitbox1
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			slli t1,a5,16
			add t1,t1,a4
			bne t0,t1,PROCESS_CHEST2.player
			PROCESS_CHEST1.player:
				la t0, Chest_Status1
				lh t0,0(t0)
				beqz t0,NOT_COLLECTED_CHEST1.player 
				COLLECTED_CHEST1.player:
					j ENDDYNAMICCOLISIONCHECK
				NOT_COLLECTED_CHEST1.player:
					la t0,PLYR_INFO
					lh t2,2(t0)
					addi t2,t2,100
					sh t2,2(t0)
					la t0,Chest_Status1
					li t1,1
					sh t1,0(t0)
					remove_static_trail(Chest_Pos1,LEVEL_MAP,16,16)
					la t0,COLLECT_SFX_STATUS
					li t1,1
					sh t1,0(t0)
					j ENDDYNAMICCOLISIONCHECK
			PROCESS_CHEST2.player:
				la t0, Key_Status2
				lh t0,0(t0)
				beqz t0,NOT_COLLECTED_CHEST2.player 
				COLLECTED_CHEST2.player:
					j ENDDYNAMICCOLISIONCHECK
				NOT_COLLECTED_CHEST2.player:
					la t0,PLYR_INFO
					lh t2,2(t0)
					addi t2,t2,100
					sh t2,2(t0)
					la t0,Chest_Status2
					li t1,1
					sh t1,0(t0)
					remove_static_trail(Chest_Pos2,LEVEL_MAP,16,16)
					la t0,COLLECT_SFX_STATUS
					li t1,1
					sh t1,0(t0)
					j ENDDYNAMICCOLISIONCHECK
		Process.warp.player:
			# Turning both X and Y into a single word
			slli t2,a5,16
			add t2,t2,a4
			# Checking X and Y of each Door and seeing which one is being tested
			la t0, Warp_Box_1
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			beq t0,t2,PROCESS_WARP1.player
			la t0, Warp_Box_2
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			beq t0,t2,PROCESS_WARP2.player
			la t0, Warp_Box_3
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			beq t0,t2,PROCESS_WARP3.player
			j PROCESS_WARP4.player
			PROCESS_WARP1.player:
				la a0,Warp_Pos_1	# Stores the positions (top left x,y) of where the first warp box will tp player			
				j WARP_SETUP
			PROCESS_WARP2.player:
				la a0,Warp_Pos_2	# Stores the positions (top left x,y) of where the first warp box will tp player
				
				j WARP_SETUP
			PROCESS_WARP3.player:
				la a0,Warp_Pos_3	# Stores the positions (top left x,y) of where the first warp box will tp player
				
				j WARP_SETUP
			PROCESS_WARP4.player:
				la a0,Warp_Pos_4	# Stores the positions (top left x,y) of where the first warp box will tp player
				
				j WARP_SETUP
		WARP_SETUP:
			bge a6,a7,HORIZONTAL_WARP # If warp box width > height, it means it's horizontal (and player's X won't be changed),
			# otherwise, it's vertical (and player's Y won't be changed)
			VERTICAL_WARP:
			la t1,PLYR_POS		  # Loads PLYR_POS
			lh t2,0(a0)		  # Loads X from Warp_Pos_(n)
			sh t2,0(t1)		  # Stores X in PLYR_POS
			sh t2,4(t1)		  # Stores X in PLYR_POS (old position)
			addi t2,t2,4		  # X offset (hitbox)
			la t1,PLYR_HITBOX	  # Loads PLYR_HITBOX
			sh t2,0(t1)		  # Stores hitbox X
			j PRE_SETUP
			HORIZONTAL_WARP:
			la t1,PLYR_POS		  # Loads PLYR_POS
			lh t2,2(a0)		  # Loads Y from Warp_Pos_(n)
			sh t2,2(t1)		  # Stores Y in PLYR_POS
			sh t2,6(t1)		  # Stores Y in PLYR_POS (old position)
			addi t2,t2,4		  # X offset (hitbox)
			la t1,PLYR_HITBOX	  # Loads PLYR_HITBOX
			sh t2,2(t1)		  # Stores hitbox X
			
			PRE_SETUP:
			la t1,LEVEL_INFO	  # Loads LEVEL_INFO
			lh t2,4(a0)		  # Loads Warp_Pos_(n) level section
			sh t2,2(t1)	  	  # And stores it in LEVEL_INFO level section
			li t2,1			  # Loads 1, so that SETUP knows not to reset parameters
			sh t2,4(t1)		  # and stores it on LEVEL_INFO (n)
			
			j SETUP			  # Jump to level SETUP (end of this process)
		
		Process.battery.player:
			la t0, Battery_Hitbox1
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			slli t1,a5,16
			add t1,t1,a4
			bne t0,t1,PROCESS_BATTERY2.player
			PROCESS_BATTERY1.player:
				la t0, Battery_Status1
				lh t0,0(t0)
				beqz t0,NOT_COLLECTED_BATTERY1.player
				COLLECTED_BATTERY1.player:
					j ENDDYNAMICCOLISIONCHECK
				NOT_COLLECTED_BATTERY1.player:
					li t1,1
					la t0,PLYR_INFO
					lh t2,0(t0)
					addi t2,t2,50
					sh t2,0(t0)
					lh t2,2(t0)
					addi t2,t2,10
					sh t2,2(t0)
					la t0,Battery_Status1
					sh t1,0(t0)
					remove_static_trail(Battery_Pos1,LEVEL_MAP,16,16)
					la t0,COLLECT_SFX_STATUS
					li t1,1
					sh t1,0(t0)
					j ENDDYNAMICCOLISIONCHECK	
			PROCESS_BATTERY2.player:
				la t0, Battery_Status2
				lh t0,0(t0)
				beqz t0,NOT_COLLECTED_BATTERY2.player
				COLLECTED_BATTERY2.player:
					j ENDDYNAMICCOLISIONCHECK
				NOT_COLLECTED_BATTERY2.player:
					li t1,1
					la t0,PLYR_INFO
					lh t2,0(t0)
					addi t2,t2,50
					sh t2,0(t0)
					lh t2,2(t0)
					addi t2,t2,10
					sh t2,2(t0)
					la t0,Battery_Status2
					sh t1,0(t0)
					remove_static_trail(Battery_Pos2,LEVEL_MAP,16,16)
					la t0,COLLECT_SFX_STATUS
					li t1,1
					sh t1,0(t0)
					j ENDDYNAMICCOLISIONCHECK	
	MAGIC_ENTITY:
		li a0,0
		li t0,2
		bne t0,s8,SKIP_Process.enemy.entity
		j Process.enemy.entity
		SKIP_Process.enemy.entity:
		li t0,5
		bne t0,s8,SKIP_Process.door.entity
		j Process.door.entity
		SKIP_Process.door.entity:
		j ENDDYNAMICCOLISIONCHECK
		Process.enemy.entity:
			li a0,1
			lh t0,8(s6)	# Gets enemy type
			beqz t0,Process.slime.entity
			Process.slime.entity:	# Slimes die upon contact to player, but take away 10 poitns of the player's health 
				lh t0,6(s6)		# Loads slime's health
				beqz t0,NO_COLISION	# if slime is dead, don't check colision
				la t0,PLYR_INFO	# Loads PLYR_INFO
				lh t2,2(t0)	# Loads player's score
				addi t2,t2,150	# and adds 150 to it
				sh t2,2(t0)	# storing it afterwards
				li t0,0		# t0 = 0
				sh t0,6(s6)	# and stores it in slime health
				la t0,KILL_ENEMY_SFX_STATUS
				li t1,1
				sh t1,0(t0)
				j ENDDYNAMICCOLISIONCHECK
				
			Process.ULA.entity:
				lh t0,6(s6)		# Loads ULA's health
				beqz t0,NO_COLISION	# if slime is dead, don't check colision
				
				la t0,PLYR_INFO	# Loads PLYR_INFO
				lh t2,2(t0)	# Loads player's score
				addi t2,t2,150	# and adds 150 to it
				sh t2,2(t0)	# storing it afterwards
				
				li t0,0		# t0 = 0
				sh t0,6(s6)	# and stores it in ULA health
				la t0,KILL_ENEMY_SFX_STATUS
				li t1,1
				sh t1,0(t0)
				j ENDDYNAMICCOLISIONCHECK
		Process.door.entity:
			# Turning both X and Y into a single word
			slli t2,a5,16
			add t2,t2,a4
			# Checking X and Y of each Door and seeing which one is being tested
			la t0, Door_H_Pos1
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			beq t0,t2,PROCESS_HORIZONTAL_DOOR1.entity
			la t0, Door_H_Pos2
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			beq t0,t2,PROCESS_HORIZONTAL_DOOR2.entity
			la t0, Door_V_Pos1
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			beq t0,t2,PROCESS_VERTICAL_DOOR1.entity
			j PROCESS_VERTICAL_DOOR2.entity
			PROCESS_HORIZONTAL_DOOR1.entity:
				la t0,Door_H_Status1
				lh t1,0(t0)
				beqz t1,IS_CLOSED_HORIZONTAL_DOOR1.entity
				IS_OPEN_HORIZONTAL_DOOR1.entity:
					li a0,0
					j ENDDYNAMICCOLISIONCHECK
				IS_CLOSED_HORIZONTAL_DOOR1.entity:
					li a0,1
					j ENDDYNAMICCOLISIONCHECK
			PROCESS_HORIZONTAL_DOOR2.entity:
				la t0,Door_H_Status2
				lh t1,0(t0)
				beqz t1,IS_CLOSED_HORIZONTAL_DOOR2.entity
				IS_OPEN_HORIZONTAL_DOOR2.entity:
					li a0,0
					j ENDDYNAMICCOLISIONCHECK
				IS_CLOSED_HORIZONTAL_DOOR2.entity:
					li a0,1
					j ENDDYNAMICCOLISIONCHECK
			PROCESS_VERTICAL_DOOR1.entity:
				la t0,Door_V_Status1
				lh t1,0(t0)
				beqz t1,IS_CLOSED_VERTICAL_DOOR1.entity
				IS_OPEN_VERTICAL_DOOR1.entity:
					li a0,0
					j ENDDYNAMICCOLISIONCHECK
				IS_CLOSED_VERTICAL_DOOR1.entity:
					li a0,1
					j ENDDYNAMICCOLISIONCHECK
			PROCESS_VERTICAL_DOOR2.entity:
				la t0,Door_V_Status2
				lh t1,0(t0)
				beqz t1,IS_CLOSED_VERTICAL_DOOR2.entity
				IS_OPEN_VERTICAL_DOOR2.entity:
					li a0,0
					j ENDDYNAMICCOLISIONCHECK
				IS_CLOSED_VERTICAL_DOOR2.entity:
					li a0,1
					j ENDDYNAMICCOLISIONCHECK
			
		
	ENEMY_MAGIC_ENTITY:
		li a0,0
		bnez s8,SKIP_Process.player.enemy
		j Process.player.enemy
		SKIP_Process.player.enemy:
		li t0,1
		bne t0,s8,SKIP_Process.plymagic.enemy
		j Process.plymagic.enemy
		SKIP_Process.plymagic.enemy:
		j ENDDYNAMICCOLISIONCHECK
		
		Process.player.enemy:
			li a0,1
			la t0,PLYR_INFO	# otherwise, load PLYR_INFO
			lh t2,0(t0)	# and load player health
			addi t2,t2,-10	# Takes away 10 HP
			sh t2,0(t0)	# and stores it

			la t0,DAMAGE_SFX_STATUS
			li t1,1
			sh t1,0(t0)
			j ENDDYNAMICCOLISIONCHECK
		Process.plymagic.enemy:
			li a0,1	# Will stop projectile from rendering
			# Turning both X and Y into a single word
			slli t2,a5,16
			add t2,t2,a4
			# Checking X and Y of each Door and seeing which one is being tested
			la t0, Magic_Pos1
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			beq t0,t2,PROCESS_PLYRMAGIC1.enemy
			la t0, Magic_Pos2
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			beq t0,t2,PROCESS_PLYRMAGIC2.enemy
			la t0, Magic_Pos3
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			beq t0,t2,PROCESS_PLYRMAGIC3.enemy
			j PROCESS_PLYRMAGIC4.enemy
			PROCESS_PLYRMAGIC1.enemy:
				la t0,Magic_Status1
				lh t1, 6(t0)			# Loads if magic is rendered
				beqz t1,NO_COLISION
				li t1,0				# If projectile can't move, stops rendering it
				sh t1, 6(t0)			# stores 0 in times rendered
				li a0,1
				j ENDDYNAMICCOLISIONCHECK
			PROCESS_PLYRMAGIC2.enemy:
				la t0,Magic_Status2
				lh t1, 6(t0)			# Loads if magic is rendered
				beqz t1,NO_COLISION
				li t1,0				# If projectile can't move, stops rendering it
				sh t1, 6(t0)			# stores 0 in times rendered
				li a0,1
				j ENDDYNAMICCOLISIONCHECK
			PROCESS_PLYRMAGIC3.enemy:
				la t0,Magic_Status3
				lh t1, 6(t0)			# Loads if magic is rendered
				beqz t1,NO_COLISION
				li t1,0				# If projectile can't move, stops rendering it
				sh t1, 6(t0)			# stores 0 in times rendered
				li a0,1
				j ENDDYNAMICCOLISIONCHECK
			PROCESS_PLYRMAGIC4.enemy:
				la t0,Magic_Status4
				lh t1, 6(t0)			# Loads if magic is rendered
				beqz t1,NO_COLISION
				li t1,0				# If projectile can't move, stops rendering it
				sh t1, 6(t0)			# stores 0 in times rendered
				li a0,1
				j ENDDYNAMICCOLISIONCHECK
		Process.door.enemy:
			la t0, Door_H_Pos1
			lh t1,2(t0)
			slli t1,t1,16
			lh t0,0(t0)
			add t0,t1,t0
			slli t1,a5,16
			add t1,t1,a4
			bne t0,t1,PROCESS_HORIZONTAL_DOOR2.enemy
			PROCESS_HORIZONTAL_DOOR1.enemy:
				la t0,Door_H_Status1
				lh t1,0(t0)
				beqz t1,IS_CLOSED_HORIZONTAL_DOOR1.enemy
				IS_OPEN_HORIZONTAL_DOOR1.enemy:
					li a0,0
					j ENDDYNAMICCOLISIONCHECK
				IS_CLOSED_HORIZONTAL_DOOR1.enemy:
					li a0,1
					j ENDDYNAMICCOLISIONCHECK
			PROCESS_HORIZONTAL_DOOR2.enemy:
				la t0,Door_H_Status2
				lh t1,0(t0)
				beqz t1,IS_CLOSED_HORIZONTAL_DOOR2.enemy
				IS_OPEN_HORIZONTAL_DOOR2.enemy:
					li a0,0
					j ENDDYNAMICCOLISIONCHECK
				IS_CLOSED_HORIZONTAL_DOOR2.enemy:
					li a0,1
					j ENDDYNAMICCOLISIONCHECK				
											
	ATTACK_ANIMATION_MELEE:
		la a0,PLYR_STATUS
		li t0,0
		sh t0,0(a0)	# Loads Sprite Status 
		sh t0,2(a0)	# Loads Sprite Info (0 if ascending - ADDSTATUS, 1 if descending - LOWERSTATUS)
		li t0,2
		sh t0,6(a0)
		
		li a7,30	# gets time passed
		ecall 		# syscall
		la t0,ATTACK_TIMER	# Loads RUN_TIME address
		sw a0,0(t0)	# new time is stored in RUN_TIME, in order to be compared later
		j ENDDYNAMICCOLISIONCHECK
	
	NO_COLISION:
		li a0,0
ENDDYNAMICCOLISIONCHECK:
	ret

####################     MAGIC COLISION    ######################
#       	     (takes no arguments)			#
#	------------------------------------------------	#
#	Will check possibility of projectile to moving and	#
# 		call rendering afterwards			#
#################################################################
.data
# PROCESS_MAGIC_INFO stores the following:
PROCESS_MAGIC_INFO: .half 0,0,0,0
#		          | | | |
#		          | | | +-> moving speed (Y)
#		          | | +---> moving speed (X)
#		          | +-----> main moving speed (is player moving in the X axis or Y axis? this will store the speed in that axis)
#		          +-------> direction entity is facing. 0: down; 1: up; 2: right; 3: left

.text
MAGIC_COLISION:
	li s2, 0 			# S2 is a counter in START_RENDERING_MAGIC
	la s1, MAGIC_ARRAY		# Loads MAGIC_ARRAY address to s1
	
MAGIC_COLISION_LOOP:
	remove_array_trail(s1,LEVEL_MAP,20,20)
	lh t0, 14(s1)			# Loads the number of times Magic has been rendered (Magic_Status)
	bnez t0,SKIP_LOOP_OPERATIONS		# If 0, it means it is inactive, thus, shouldn't be checked
	j LOOP_OPERATIONS
	SKIP_LOOP_OPERATIONS:
	# Checking direction where projectile is going
	
	lh t2,12(s1)
	la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
	sh t2,0(t0)		# Coming into this label, t1 tells the direction the entity is facing at (storing in PROCESS_INFO)
	bnez t2, SKIP_MAGIC_CHECK_DOWN	# Is entity going down?
	j MAGIC_CHECK_DOWN
	SKIP_MAGIC_CHECK_DOWN:
	li t1,1			# Number that correspond to up direction		
	bne t1,t2, SKIP_MAGIC_CHECK_UP	# Is entity going up?
	j MAGIC_CHECK_UP
	SKIP_MAGIC_CHECK_UP:
	li t1,2			# Number that correspond to right direction
	bne t1,t2, SKIP_MAGIC_CHECK_RIGHT	# Is entity going right?
	j MAGIC_CHECK_RIGHT
	SKIP_MAGIC_CHECK_RIGHT:
	li t1,3			# Number that correspond to left direction
	bne t1,t2, SKIP_MAGIC_CHECK_LEFT	# Is entity going left?
	j MAGIC_CHECK_LEFT
	SKIP_MAGIC_CHECK_LEFT:
	ret			# If no information, abort
	MAGIC_CHECK_DOWN:	# Stores info that player is going down
		li t1,0			# moving speed (X)
		sh t1,4(t0)		# Stores X speed in PROCESS_INFO
		li t2,magic_speed	# moving speed (Y)
		sh t2,6(t0)		# Stores Y speed in PROCESS_INFO
		sh t2,2(t0)		# Stores Y speed in PROCESS_INFO main moving speed
		
		j START_MAGIC_COLISION
	MAGIC_CHECK_UP:	# Stores info that player is going up
		li t1,0			# moving speed (X)
		sh t1,4(t0)		# Stores X speed in PROCESS_INFO
		li t2,magic_speed	# moving speed (Y)
		neg t2,t2		# negates Y speed (since it's going up)
		sh t2,6(t0)		# Stores Y speed in PROCESS_INFO
		sh t2,2(t0)		# Stores Y speed in PROCESS_INFO main moving speed
		
		j START_MAGIC_COLISION
	MAGIC_CHECK_RIGHT:	# Stores info that player is going right
		li t1,magic_speed	# moving speed (X)
		sh t1,4(t0)		# Stores X speed in PROCESS_INFO
		li t2,0			# moving speed (Y)
		sh t2,6(t0)		# Stores Y speed in PROCESS_INFO
		sh t1,2(t0)		# Stores X speed in PROCESS_INFO main moving speed
		
		j START_MAGIC_COLISION
	MAGIC_CHECK_LEFT:	# Stores info that player is going left
		li t1,magic_speed	# moving speed (X)
		neg t1,t1		# negates X speed (since it's going left)
		sh t1,4(t0)		# Stores X speed in PROCESS_INFO
		li t2,0			# moving speed (Y)
		sh t2,6(t0)		# Stores Y speed in PROCESS_INFO
		sh t1,2(t0)		# Stores X speed in PROCESS_INFO main moving speed

		j START_MAGIC_COLISION	
		
	START_MAGIC_COLISION:	# checking level player is at (so colision checks can be made)	
		la t0,LEVEL_INFO
		lh t0,0(t0)
		li t1,1
		bne t0,t1,SKIP_MAGIC_LEVEL1_COLISION
		j MAGIC_LEVEL1_COLISION
		SKIP_MAGIC_LEVEL1_COLISION:
		li t1,2
		bne t0,t1,SKIP_MAGIC_LEVEL2_COLISION
		j MAGIC_LEVEL2_COLISION
		SKIP_MAGIC_LEVEL2_COLISION:
		li t1,3
		bne t0,t1,SKIP_MAGIC_LEVEL3_COLISION
		j MAGIC_LEVEL3_COLISION
		SKIP_MAGIC_LEVEL3_COLISION:
		li t1,4
		bne t0,t1,SKIP_MAGIC_LEVEL4_COLISION
		j MAGIC_LEVEL4_COLISION
		SKIP_MAGIC_LEVEL4_COLISION:
		li t1,0
		li t2,0
		j AFTER_MAGIC_COLISION
		MAGIC_LEVEL1_COLISION:
			la t0,LEVEL_INFO
			lh t0,2(t0)
			li t1,1
			bne t1,t0,SKIP_MAGIC_LEVEL1.1_COLISION
			j MAGIC_LEVEL1.1_COLISION
			SKIP_MAGIC_LEVEL1.1_COLISION:
			li t1,2
			bne t1,t0,SKIP_MAGIC_LEVEL1.2_COLISION
			j MAGIC_LEVEL1.2_COLISION
			SKIP_MAGIC_LEVEL1.2_COLISION:
			j AFTER_MAGIC_COLISION
			MAGIC_LEVEL1.1_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,Slime_Pos_0,2,16,16,Slime_0)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE1.1	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,Slime_Pos_1,2,16,16,Slime_1)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE1.1	# If a0 != 0, despawn
				
				j AFTER_MAGIC_COLISION
				SKIP_PROJECTILE_CANT_MOVE1.1:
				j PROJECTILE_CANT_MOVE
			MAGIC_LEVEL1.2_COLISION:
				projectile_dynamic_colision_check(s1,1,16,16,t1,t2,Door_H_Pos1,5,32,4)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE1.2	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,Slime_Pos_0,2,16,16,Slime_0)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE1.2	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,Slime_Pos_1,2,16,16,Slime_1)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE1.2	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,Slime_Pos_2,2,16,16,Slime_2)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE1.2	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,Slime_Pos_3,2,16,16,Slime_3)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE1.2	# If a0 != 0, despawn
				j AFTER_MAGIC_COLISION
				SKIP_PROJECTILE_CANT_MOVE1.2:
				j PROJECTILE_CANT_MOVE
		MAGIC_LEVEL2_COLISION:
			la t0,LEVEL_INFO
			lh t0,2(t0)
			li t1,1
			bne t1,t0,SKIP_MAGIC_LEVEL2.1_COLISION
			j MAGIC_LEVEL2.1_COLISION
			SKIP_MAGIC_LEVEL2.1_COLISION:
			li t1,2
			bne t1,t0,SKIP_MAGIC_LEVEL2.2_COLISION
			j MAGIC_LEVEL2.2_COLISION
			SKIP_MAGIC_LEVEL2.2_COLISION:
			li t1,3
			bne t1,t0,SKIP_MAGIC_LEVEL2.3_COLISION
			j MAGIC_LEVEL2.3_COLISION
			SKIP_MAGIC_LEVEL2.3_COLISION:
			j AFTER_MAGIC_COLISION
			MAGIC_LEVEL2.1_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check(s1,1,16,16,t1,t2,Door_V_Pos1,5,8,38)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE2.1	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,Slime_Pos_0,2,16,16,Slime_0)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE2.1	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,Slime_Pos_1,2,16,16,Slime_1)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE2.1	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,Slime_Pos_2,2,16,16,Slime_2)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE2.1	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,Slime_Pos_3,2,16,16,Slime_3)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE2.1	# If a0 != 0, despawn
				j AFTER_MAGIC_COLISION
				SKIP_PROJECTILE_CANT_MOVE2.1:
				j PROJECTILE_CANT_MOVE
			MAGIC_LEVEL2.2_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check(s1,1,16,16,t1,t2,Door_H_Pos1,5,32,4)
				bnez a0,PROJECTILE_CANT_MOVE2.2	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check(s1,1,16,16,t1,t2,Door_H_Pos2,5,32,4)
				bnez a0,PROJECTILE_CANT_MOVE2.2	# If a0 != 0, despawn
				
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,Slime_Pos_0,2,16,16,Slime_0)
				bnez a0,PROJECTILE_CANT_MOVE2.2	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO				
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_0,2,16,16,ULA_0)
				bnez a0,PROJECTILE_CANT_MOVE2.2	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_1,2,16,16,ULA_1)
				bnez a0,PROJECTILE_CANT_MOVE2.2	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_2,2,16,16,ULA_2)
				bnez a0,PROJECTILE_CANT_MOVE2.2	# If a0 != 0, despawn
				j AFTER_MAGIC_COLISION
				
				PROJECTILE_CANT_MOVE2.2:
				j PROJECTILE_CANT_MOVE
			MAGIC_LEVEL2.3_COLISION:
				#la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,Slime_Pos_0,2,16,16,Slime_0)
				bnez a0,PROJECTILE_CANT_MOVE2.3	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,Slime_Pos_2,2,16,16,Slime_2)
				bnez a0,PROJECTILE_CANT_MOVE2.3	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO				
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_0,2,16,16,ULA_0)
				bnez a0,PROJECTILE_CANT_MOVE2.3	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_1,2,16,16,ULA_1)
				bnez a0,PROJECTILE_CANT_MOVE2.3	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_2,2,16,16,ULA_2)
				bnez a0,PROJECTILE_CANT_MOVE2.3	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_3,2,16,16,ULA_3)
				bnez a0,PROJECTILE_CANT_MOVE2.3	# If a0 != 0, despawn
				
				j AFTER_MAGIC_COLISION
				PROJECTILE_CANT_MOVE2.3:
				j PROJECTILE_CANT_MOVE
		MAGIC_LEVEL3_COLISION:
			la t0,LEVEL_INFO
			lh t0,2(t0)
			li t1,1
			bne t1,t0,SKIP_MAGIC_LEVEL3.1_COLISION
			j MAGIC_LEVEL3.1_COLISION
			SKIP_MAGIC_LEVEL3.1_COLISION:
			li t1,2
			bne t1,t0,SKIP_MAGIC_LEVEL3.2_COLISION
			j MAGIC_LEVEL3.2_COLISION
			SKIP_MAGIC_LEVEL3.2_COLISION:
			li t1,3
			bne t1,t0,SKIP_MAGIC_LEVEL3.3_COLISION
			j MAGIC_LEVEL3.3_COLISION
			SKIP_MAGIC_LEVEL3.3_COLISION:
			li t1,4
			bne t1,t0,SKIP_MAGIC_LEVEL3.4_COLISION
			j MAGIC_LEVEL3.4_COLISION
			SKIP_MAGIC_LEVEL3.4_COLISION:
			j AFTER_MAGIC_COLISION
			MAGIC_LEVEL3.1_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_0,2,16,16,ULA_0)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE3.1	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_1,2,16,16,ULA_1)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE3.1	# If a0 != 0, despawn
				
				j AFTER_MAGIC_COLISION
				SKIP_PROJECTILE_CANT_MOVE3.1:
				j PROJECTILE_CANT_MOVE
				
			MAGIC_LEVEL3.2_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_0,2,16,16,ULA_0)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE3.2	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_1,2,16,16,ULA_1)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE3.2	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_2,2,16,16,ULA_2)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE3.2	# If a0 != 0, despawn
				j AFTER_MAGIC_COLISION
				
				SKIP_PROJECTILE_CANT_MOVE3.2:
				j PROJECTILE_CANT_MOVE
			MAGIC_LEVEL3.3_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check(s1,1,16,16,t1,t2,Door_H_Pos1,5,28,6)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE3.3	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO				
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_0,2,16,16,ULA_0)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE3.3	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_1,2,16,16,ULA_1)
				bnez a0,SKIP_PROJECTILE_CANT_MOVE3.3	# If a0 != 0, despawn
				
				j AFTER_MAGIC_COLISION
				
				SKIP_PROJECTILE_CANT_MOVE3.3:
				j PROJECTILE_CANT_MOVE
			MAGIC_LEVEL3.4_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_0,2,16,16,ULA_0)
				bnez a0,PROJECTILE_CANT_MOVE3.4	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_1,2,16,16,ULA_1)
				bnez a0,PROJECTILE_CANT_MOVE3.4	# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,ULA_Pos_2,2,16,16,ULA_2)
				bnez a0,PROJECTILE_CANT_MOVE3.4	# If a0 != 0, despawn
				
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,Slime_Pos_0,2,16,16,Slime_0)
				bnez a0,PROJECTILE_CANT_MOVE3.4# If a0 != 0, despawn
				la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check_enemy(s1,1,16,16,t1,t2,Slime_Pos_1,2,16,16,Slime_1)
				bnez a0,PROJECTILE_CANT_MOVE2.3	# If a0 != 0, despawn
				
				
				j AFTER_MAGIC_COLISION
				
				PROJECTILE_CANT_MOVE3.4:
				j PROJECTILE_CANT_MOVE
		MAGIC_LEVEL4_COLISION:
			j AFTER_MAGIC_COLISION
	
	PROJECTILE_CANT_MOVE:
		li t0,0		# If projectile can't move, stops rendering it
		sh t0, 14(s1)	# stores 0 in times rendered
		# Gets speed
		la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
		lh t1,4(t0)		# Loads X speed from PROCESS_INFO
		lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
		# Gets X position and updates it	
		lh t3,0(s1)
		sh t3,4(s1)
		add t3,t3,t1
		# Gets Y position and updates it
		lh t4,2(s1)
		sh t4,6(s1)
		add t4,t4,t2
		
		remove_array_trail(s1,LEVEL_MAP,20,20)
		
		# Operations for loop
		addi s1,s1,16			# Goes to the next Magic_Pos in the array
		li t0,max_plyr_projectile	# Max number of projectiles
		addi s2,s2,1			# s2 += 1
		bge s2,t0,ENDMAGICCOLISION	# if s2 >= t0, stops loop 
 		j MAGIC_COLISION_LOOP
	AFTER_MAGIC_COLISION:
		la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
		lh t1,0(t0)	# Loads direction entity is facing
		lh t2,2(t0)	# Loads main movement speed
		projectile_static_colision_check(s1,LEVEL_HIT_MAP,16,16,t1,t2,1)
		li t0,1				# Since if it's returned number 2, it won't despawn
		beq a0,t0,PROJECTILE_CANT_MOVE	# If a0 = 1, despawn	
		# Gets speed
		la t0, PROCESS_MAGIC_INFO	# Loads PROCESS_INFO address
		lh t1,4(t0)		# Loads X speed from PROCESS_INFO
		lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
		# Gets X position and updates it	
		lh t3,0(s1)
		sh t3,4(s1)
		add t3,t3,t1
		# Gets Y position and updates it
		lh t4,2(s1)
		sh t4,6(s1)
		add t4,t4,t2
		# Checks if update is in range
		li t0,0		# Top of screen
  		blt t3,t0,PROJECTILE_CANT_MOVE	# If X < 0, it's out of range, so it won't be rendered
  		li t0,272	# Screen width (whithout UI)
  		bge t3,t0,PROJECTILE_CANT_MOVE	# If Y > 272, it's out of range, so it won't be rendered
  		li t0,0		# Top of screen
  		blt t4,t0,PROJECTILE_CANT_MOVE	# If Y < 0, it's out of range, so it won't be rendered
  		li t0,240	# Screen height
  		bge t4,t0,PROJECTILE_CANT_MOVE	# If Y >= 240, it's out of range, so it won't be rendered
  		# If passes tests above, store new positions
  		sh t3,0(s1)
		sh t4,2(s1)
		LOOP_OPERATIONS:
		# Operations for loop
		addi s1,s1,16			# Goes to the next Magic_Pos in the array
		li t0,max_plyr_projectile	# Max number of projectiles
		addi s2,s2,1			# s2 += 1
		bge s2,t0,ENDMAGICCOLISION	# if s2 >= t0, stops loop 
 		j MAGIC_COLISION_LOOP	
ENDMAGICCOLISION:
	ret		

####################     MAGIC COLISION    ######################
#       	     (takes no arguments)			#
#	------------------------------------------------	#
#	Will check possibility of projectile to moving and	#
# 		call rendering afterwards			#
#################################################################
.data
# PROCESS_MAGIC_INFO stores the following:
PROCESS_ULA_MAGIC_INFO: .half 0,0,0,0
#		              | | | |
#		              | | | +-> moving speed (Y)
#		              | | +---> moving speed (X)
#		              | +-----> main moving speed (is player moving in the X axis or Y axis? this will store the speed in that axis)
#		              +-------> direction entity is facing. 0: down; 1: up; 2: right; 3: left

.text
ULA_MAGIC_COLISION:
	li s2, 0 			# S2 is a counter in START_RENDERING_MAGIC
	la s1, ULA_MAGIC_ARRAY		# Loads MAGIC_ARRAY address to s1
	
ULA_MAGIC_COLISION_LOOP:
	remove_array_trail(s1,LEVEL_MAP,20,20)
	lh t0, 14(s1)			# Loads the number of times Magic has been rendered (Magic_Status)
	beqz t0,ULA_LOOP_OPERATIONS		# If 0, it means it is inactive, thus, shouldn't be checked
	# Checking direction where projectile is going
	
	lh t2,12(s1)
	la t0, PROCESS_ULA_MAGIC_INFO	# Loads PROCESS_INFO address
	sh t2,0(t0)		# Coming into this label, t1 tells the direction the entity is facing at (storing in PROCESS_INFO)
	bnez t2, SKIP_ULA_MAGIC_CHECK_DOWN	# Is entity going down?
	j ULA_MAGIC_CHECK_DOWN
	SKIP_ULA_MAGIC_CHECK_DOWN:
	li t1,1			# Number that correspond to up direction		
	bne t1,t2, SKIP_ULA_MAGIC_CHECK_UP	# Is entity going up?
	j ULA_MAGIC_CHECK_UP
	SKIP_ULA_MAGIC_CHECK_UP:
	li t1,2			# Number that correspond to right direction
	bne t1,t2, SKIP_ULA_MAGIC_CHECK_RIGHT	# Is entity going right?
	j ULA_MAGIC_CHECK_RIGHT
	SKIP_ULA_MAGIC_CHECK_RIGHT:
	li t1,3			# Number that correspond to left direction
	bne t1,t2, SKIP_ULA_MAGIC_CHECK_LEFT	# Is entity going left?
	j ULA_MAGIC_CHECK_LEFT
	SKIP_ULA_MAGIC_CHECK_LEFT:
	ret			# If no information, abort
	ULA_MAGIC_CHECK_DOWN:	# Stores info that player is going down
		li t1,0			# moving speed (X)
		sh t1,4(t0)		# Stores X speed in PROCESS_INFO
		li t2,magic_speed	# moving speed (Y)
		sh t2,6(t0)		# Stores Y speed in PROCESS_INFO
		sh t2,2(t0)		# Stores Y speed in PROCESS_INFO main moving speed
		
		j START_ULA_MAGIC_COLISION
	ULA_MAGIC_CHECK_UP:	# Stores info that player is going up
		li t1,0			# moving speed (X)
		sh t1,4(t0)		# Stores X speed in PROCESS_INFO
		li t2,magic_speed	# moving speed (Y)
		neg t2,t2		# negates Y speed (since it's going up)
		sh t2,6(t0)		# Stores Y speed in PROCESS_INFO
		sh t2,2(t0)		# Stores Y speed in PROCESS_INFO main moving speed
		
		j START_ULA_MAGIC_COLISION
	ULA_MAGIC_CHECK_RIGHT:	# Stores info that player is going right
		li t1,magic_speed	# moving speed (X)
		sh t1,4(t0)		# Stores X speed in PROCESS_INFO
		li t2,0			# moving speed (Y)
		sh t2,6(t0)		# Stores Y speed in PROCESS_INFO
		sh t1,2(t0)		# Stores X speed in PROCESS_INFO main moving speed
		
		j START_ULA_MAGIC_COLISION
	ULA_MAGIC_CHECK_LEFT:	# Stores info that player is going left
		li t1,magic_speed	# moving speed (X)
		neg t1,t1		# negates X speed (since it's going left)
		sh t1,4(t0)		# Stores X speed in PROCESS_INFO
		li t2,0			# moving speed (Y)
		sh t2,6(t0)		# Stores Y speed in PROCESS_INFO
		sh t1,2(t0)		# Stores X speed in PROCESS_INFO main moving speed

		j START_ULA_MAGIC_COLISION	
		
	START_ULA_MAGIC_COLISION:	# checking level player is at (so colision checks can be made)	
		la t0,LEVEL_INFO
		lh t0,0(t0)
		li t1,1
		bne t0,t1,SKIP_ULA_MAGIC_LEVEL1_COLISION
		j ULA_MAGIC_LEVEL1_COLISION
		SKIP_ULA_MAGIC_LEVEL1_COLISION:
		li t1,2
		bne t0,t1,SKIP_ULA_MAGIC_LEVEL2_COLISION
		j ULA_MAGIC_LEVEL2_COLISION
		SKIP_ULA_MAGIC_LEVEL2_COLISION:
		li t1,3
		bne t0,t1,SKIP_ULA_MAGIC_LEVEL3_COLISION
		j ULA_MAGIC_LEVEL3_COLISION
		SKIP_ULA_MAGIC_LEVEL3_COLISION:
		li t1,4
		bne t0,t1,SKIP_ULA_MAGIC_LEVEL4_COLISION
		j ULA_MAGIC_LEVEL4_COLISION
		SKIP_ULA_MAGIC_LEVEL4_COLISION:
		li t1,0
		li t2,0
		j AFTER_MAGIC_COLISION
		ULA_MAGIC_LEVEL1_COLISION:
			la t0,LEVEL_INFO
			lh t0,2(t0)
			li t1,1
			bne t1,t0,SKIP_ULA_MAGIC_LEVEL1.1_COLISION
			j ULA_MAGIC_LEVEL1.1_COLISION
			SKIP_ULA_MAGIC_LEVEL1.1_COLISION:
			li t1,2
			bne t1,t0,SKIP_ULA_MAGIC_LEVEL1.2_COLISION
			j ULA_MAGIC_LEVEL1.2_COLISION
			SKIP_ULA_MAGIC_LEVEL1.2_COLISION:
			j AFTER_MAGIC_COLISION
			
			ULA_MAGIC_LEVEL1.1_COLISION:
				j AFTER_ULA_MAGIC_COLISION
			ULA_MAGIC_LEVEL1.2_COLISION:
				projectile_dynamic_colision_check(s1,1,16,16,t1,t2,Door_H_Pos1,5,32,4)
				bnez a0,SKIP_ULA_PROJECTILE_CANT_MOVE1.2	# If a0 != 0, despawn
				j AFTER_ULA_MAGIC_COLISION
				SKIP_ULA_PROJECTILE_CANT_MOVE1.2:
				j ULA_PROJECTILE_CANT_MOVE
		ULA_MAGIC_LEVEL2_COLISION:
			la t0,LEVEL_INFO
			lh t0,2(t0)
			li t1,1
			bne t1,t0,SKIP_ULA_MAGIC_LEVEL2.1_COLISION
			j ULA_MAGIC_LEVEL2.1_COLISION
			SKIP_ULA_MAGIC_LEVEL2.1_COLISION:
			li t1,2
			bne t1,t0,SKIP_ULA_MAGIC_LEVEL2.2_COLISION
			j ULA_MAGIC_LEVEL2.2_COLISION
			SKIP_ULA_MAGIC_LEVEL2.2_COLISION:
			li t1,3
			bne t1,t0,SKIP_ULA_MAGIC_LEVEL2.3_COLISION
			j ULA_MAGIC_LEVEL2.3_COLISION
			SKIP_ULA_MAGIC_LEVEL2.3_COLISION:
			j AFTER_MAGIC_COLISION
			ULA_MAGIC_LEVEL2.1_COLISION:
				j AFTER_ULA_MAGIC_COLISION
			ULA_MAGIC_LEVEL2.2_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_ULA_MAGIC_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check(s1,1,16,16,t1,t2,Door_H_Pos1,5,32,4)
				bnez a0,SKIP_ULA_PROJECTILE_CANT_MOVE2.1	# If a0 != 0, despawn
				la t0, PROCESS_ULA_MAGIC_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check(s1,1,16,16,t1,t2,Door_H_Pos2,5,32,4)
				bnez a0,SKIP_ULA_PROJECTILE_CANT_MOVE2.1	# If a0 != 0, despawn
				j AFTER_ULA_MAGIC_COLISION
				SKIP_ULA_PROJECTILE_CANT_MOVE2.1:
				j ULA_PROJECTILE_CANT_MOVE
			ULA_MAGIC_LEVEL2.3_COLISION:
				j AFTER_ULA_MAGIC_COLISION
		ULA_MAGIC_LEVEL3_COLISION:
			la t0,LEVEL_INFO
			lh t0,2(t0)
			li t1,1
			bne t1,t0,SKIP_ULA_MAGIC_LEVEL3.1_COLISION
			j ULA_MAGIC_LEVEL3.1_COLISION
			SKIP_ULA_MAGIC_LEVEL3.1_COLISION:
			li t1,2
			bne t1,t0,SKIP_ULA_MAGIC_LEVEL3.2_COLISION
			j ULA_MAGIC_LEVEL3.2_COLISION
			SKIP_ULA_MAGIC_LEVEL3.2_COLISION:
			li t1,3
			bne t1,t0,SKIP_ULA_MAGIC_LEVEL3.3_COLISION
			j ULA_MAGIC_LEVEL3.3_COLISION
			SKIP_ULA_MAGIC_LEVEL3.3_COLISION:
			li t1,4
			bne t1,t0,SKIP_ULA_MAGIC_LEVEL3.4_COLISION
			j ULA_MAGIC_LEVEL3.4_COLISION
			SKIP_ULA_MAGIC_LEVEL3.4_COLISION:
			j AFTER_ULA_MAGIC_COLISION
			ULA_MAGIC_LEVEL3.1_COLISION:
				j AFTER_ULA_MAGIC_COLISION
			ULA_MAGIC_LEVEL3.2_COLISION:
				j AFTER_ULA_MAGIC_COLISION
			ULA_MAGIC_LEVEL3.3_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_ULA_MAGIC_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				projectile_dynamic_colision_check(s1,1,16,16,t1,t2,Door_H_Pos1,5,28,6)
				bnez a0,SKIP_ULA_PROJECTILE_CANT_MOVE3.3	# If a0 != 0, despawn
				j AFTER_ULA_MAGIC_COLISION
				SKIP_ULA_PROJECTILE_CANT_MOVE3.3:
				j ULA_PROJECTILE_CANT_MOVE
			ULA_MAGIC_LEVEL3.4_COLISION:
				j AFTER_ULA_MAGIC_COLISION
				
		ULA_MAGIC_LEVEL4_COLISION:
			j AFTER_ULA_MAGIC_COLISION
	
	ULA_PROJECTILE_CANT_MOVE:
		li t0,0		# If projectile can't move, stops rendering it
		sh t0, 14(s1)	# stores 0 in times rendered
		# Gets speed
		la t0, PROCESS_ULA_MAGIC_INFO	# Loads PROCESS_INFO address
		lh t1,4(t0)		# Loads X speed from PROCESS_INFO
		lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
		# Gets X position and updates it	
		lh t3,0(s1)
		sh t3,4(s1)
		add t3,t3,t1
		# Gets Y position and updates it
		lh t4,2(s1)
		sh t4,6(s1)
		add t4,t4,t2
		
		remove_array_trail(s1,LEVEL_MAP,20,20)
		
		# Operations for loop
		addi s1,s1,16			# Goes to the next Magic_Pos in the array
		li t0,max_plyr_projectile	# Max number of projectiles
		addi s2,s2,1			# s2 += 1
		bge s2,t0,ENDULAMAGICCOLISION	# if s2 >= t0, stops loop 
 		j MAGIC_COLISION_LOOP
	AFTER_ULA_MAGIC_COLISION:
		la t0, PROCESS_ULA_MAGIC_INFO	# Loads PROCESS_INFO address
		lh t1,0(t0)	# Loads direction entity is facing
		lh t2,2(t0)	# Loads main movement speed
		projectile_static_colision_check(s1,LEVEL_HIT_MAP,16,16,t1,t2,1)
		li t0,1				# Since if it's returned number 2, it won't despawn
		beq a0,t0,ULA_PROJECTILE_CANT_MOVE	# If a0 = 1, despawn

		la t0, PROCESS_ULA_MAGIC_INFO	# Loads PROCESS_INFO address
		lh t1,4(t0)			# Loads X speed from PROCESS_INFO
		lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
		projectile_dynamic_colision_check(s1,3,16,16,t1,t2,Magic_Pos1,1,16,16)
		bnez a0,ULA_PROJECTILE_CANT_MOVE	# If a0 != 0, can't walk
		la t0, PROCESS_ULA_MAGIC_INFO	# Loads PROCESS_INFO address
		lh t1,4(t0)			# Loads X speed from PROCESS_INFO
		lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
		projectile_dynamic_colision_check(s1,3,16,16,t1,t2,Magic_Pos2,1,16,16)
		bnez a0,ULA_PROJECTILE_CANT_MOVE	# If a0 != 0, can't walk
		la t0, PROCESS_ULA_MAGIC_INFO	# Loads PROCESS_INFO address
		lh t1,4(t0)			# Loads X speed from PROCESS_INFO
		lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
		projectile_dynamic_colision_check(s1,3,16,16,t1,t2,Magic_Pos3,1,16,16)
		bnez a0,ULA_PROJECTILE_CANT_MOVE	# If a0 != 0, can't walk
		la t0, PROCESS_ULA_MAGIC_INFO	# Loads PROCESS_INFO address
		lh t1,4(t0)			# Loads X speed from PROCESS_INFO
		lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
		projectile_dynamic_colision_check(s1,3,16,16,t1,t2,Magic_Pos4,1,16,16)
		bnez a0,ULA_PROJECTILE_CANT_MOVE	# If a0 != 0, can't walk
		

		
		la t0, PROCESS_ULA_MAGIC_INFO	# Loads PROCESS_INFO address
		lh t1,4(t0)			# Loads X speed from PROCESS_INFO
		lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
		projectile_dynamic_colision_check(s1,3,16,16,t1,t2,PLYR_HITBOX,0,15,15)
		bnez a0,ULA_PROJECTILE_CANT_MOVE	# If a0 != 0, can't walk		
		
		
		
		# Gets speed
		la t0, PROCESS_ULA_MAGIC_INFO	# Loads PROCESS_INFO address
		lh t1,4(t0)		# Loads X speed from PROCESS_INFO
		lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
		# Gets X position and updates it	
		lh t3,0(s1)
		sh t3,4(s1)
		add t3,t3,t1
		# Gets Y position and updates it
		lh t4,2(s1)
		sh t4,6(s1)
		add t4,t4,t2
		# Checks if update is in range
		li t0,0		# Top of screen
  		blt t3,t0,ULA_PROJECTILE_CANT_MOVE	# If X < 0, it's out of range, so it won't be rendered
  		li t0,272	# Screen width (whithout UI)
  		bge t3,t0,ULA_PROJECTILE_CANT_MOVE	# If Y > 272, it's out of range, so it won't be rendered
  		li t0,0		# Top of screen
  		blt t4,t0,ULA_PROJECTILE_CANT_MOVE	# If Y < 0, it's out of range, so it won't be rendered
  		li t0,240	# Screen height
  		bge t4,t0,ULA_PROJECTILE_CANT_MOVE	# If Y >= 240, it's out of range, so it won't be rendered
  		# If passes tests above, store new positions
  		sh t3,0(s1)
		sh t4,2(s1)
		ULA_LOOP_OPERATIONS:
		# Operations for loop
		addi s1,s1,16			# Goes to the next Magic_Pos in the array
		li t0,max_enmy_projectile	# Max number of projectiles
		addi s2,s2,1			# s2 += 1
		bge s2,t0,ENDULAMAGICCOLISION	# if s2 >= t0, stops loop 
 		j ULA_MAGIC_COLISION_LOOP	
ENDULAMAGICCOLISION:
	ret		
		
				
####################     LEVEL COLISION    ######################
#       ---------         registers used         ---------      #
#	s5 = X mov speed					#			
#	s6 = Y mov speed					#
# 	s7 = entity type (will be set in another label)		#
#	s8 = entity type (will be set in another label)		#
#	s9 = ra storer						#
#	s10 = ra storer	(will be set in another label)		#
#	s11 = ra storer	(will be set in another label)		#
#	------------------------------------------------	#
#	returns a0, indicating possibility of movement		#
#################################################################
.data
# PROCESS_INFO stores the following:
PROCESS_INFO: .half 0,0,0,0
#		    | | | |
#		    | | | +-> moving speed (Y)
#		    | | +---> moving speed (X)
#		    | +-----> main moving speed (is player moving in the X axis or Y axis? this will store the speed in that axis)
#		    +-------> direction entity is facing. 0: down; 1: up; 2: right; 3: left

.text
LEVEL_COLISION:
	bnez t0, MOVING	# Coming into this label, t0 tells whether entity is moving or not
	j NOT_MOVING
	MOVING:
		la t0, PROCESS_INFO	# Loads PROCESS_INFO address
		sh t2,0(t0)		# Coming into this label, t1 tells the direction the entity is facing at (storing in PROCESS_INFO)
		bnez t2, SKIP_CHECK_DOWN	# Is entity going down?
		j CHECK_DOWN
		SKIP_CHECK_DOWN:
		li t1,1			# Number that correspond to up direction		
		bne t1,t2, SKIP_CHECK_UP	# Is entity going up?
		j CHECK_UP
		SKIP_CHECK_UP:
		li t1,2			# Number that correspond to right direction
		bne t1,t2, SKIP_CHECK_RIGHT	# Is entity going right?
		j CHECK_RIGHT
		SKIP_CHECK_RIGHT:
		li t1,3			# Number that correspond to left direction
		bne t1,t2, SKIP_CHECK_LEFT	# Is entity going left?
		j CHECK_LEFT
		SKIP_CHECK_LEFT:
		ret			# If no information, abort
		CHECK_DOWN:	# Stores info that player is going down
			li t1,0		# moving speed (X)
			sh t1,4(t0)	# Stores X speed in PROCESS_INFO
			li t2,4		# moving speed (Y)
			sh t2,6(t0)	# Stores Y speed in PROCESS_INFO
			
			sh t2,2(t0)	# Stores Y speed in PROCESS_INFO main moving speed
			j START_LEVEL_CHECK
		CHECK_UP:	# Stores info that player is going up
			li t1,0		# moving speed (X)
			sh t1,4(t0)	# Stores X speed in PROCESS_INFO
			li t2,-4	# moving speed (Y)
			sh t2,6(t0)	# Stores Y speed in PROCESS_INFO
			
			sh t2,2(t0)	# Stores Y speed in PROCESS_INFO main moving speed
			j START_LEVEL_CHECK
		CHECK_RIGHT:	# Stores info that player is going right
			li t1,4		# moving speed (X)
			sh t1,4(t0)	# Stores X speed in PROCESS_INFO
			li t2,0		# moving speed (Y)
			sh t2,6(t0)	# Stores Y speed in PROCESS_INFO
			
			sh t1,2(t0)	# Stores X speed in PROCESS_INFO main moving speed
			j START_LEVEL_CHECK
		CHECK_LEFT:	# Stores info that player is going left
			li t1,-4	# moving speed (X)
			sh t1,4(t0)	# Stores X speed in PROCESS_INFO
			li t2,0		# moving speed (Y)
			sh t2,6(t0)	# Stores Y speed in PROCESS_INFO
			
			sh t1,2(t0)	# Stores X speed in PROCESS_INFO main moving speed
			j START_LEVEL_CHECK
	NOT_MOVING:

		la t0, PROCESS_INFO	# Loads PROCESS_INFO address
		li t1,0			# moving speed (X)
		sh t1,4(t0)		# Stores X speed in PROCESS_INFO
		li t2,0			# moving speed (Y)
		sh t2,6(t0)		# Stores Y speed in PROCESS_INFO	
		sh t1,2(t0)		# Stores X speed in PROCESS_INFO main moving speed ( = 0)
		j START_LEVEL_CHECK
		
	START_LEVEL_CHECK:	
		la t0,LEVEL_INFO
		lh t0,0(t0)
		li t1,1
		bne t0,t1,SKIP_LEVEL1_COLISION
		j LEVEL1_COLISION
		SKIP_LEVEL1_COLISION:
		li t1,2
		bne t0,t1,SKIP_LEVEL2_COLISION
		j LEVEL2_COLISION
		SKIP_LEVEL2_COLISION:
		li t1,3
		bne t0,t1,SKIP_LEVEL3_COLISION
		j LEVEL3_COLISION
		SKIP_LEVEL3_COLISION:
		li t1,4
		bne t0,t1,SKIP_LEVEL4_COLISION
		j MAGIC_LEVEL4_COLISION
		SKIP_LEVEL4_COLISION:
		li t1,0
		li t2,0
		j AFTER_MAGIC_COLISION
		LEVEL1_COLISION:	
			la t0,LEVEL_INFO
			lh t0,2(t0)
			li t1,1
			bne t1,t0,SKIP_LEVEL1.1_COLISION
			j LEVEL1.1_COLISION
			SKIP_LEVEL1.1_COLISION:
			li t1,2
			bne t1,t0,SKIP_LEVEL1.2_COLISION
			j LEVEL1.2_COLISION
			SKIP_LEVEL1.2_COLISION:
			j HITBOX_COLISION_CHECK
			LEVEL1.1_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Warp_Box_1,7,120,3)
				bnez a0,CANT_MOVE1.1	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Chest_Hitbox1,6,8,8)
				bnez a0,CANT_MOVE1.1	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check_enemy(PLYR_HITBOX,0,15,15,t1,t2,Slime_Pos_0,2,16,16,Slime_0)
				bnez a0,CANT_MOVE1.1	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check_enemy(PLYR_HITBOX,0,15,15,t1,t2,Slime_Pos_1,2,16,16,Slime_1)
				bnez a0,CANT_MOVE1.1	# If a0 != 0, can't walk
				
				j HITBOX_COLISION_CHECK
				CANT_MOVE1.1:
				j CANT_MOVE
			LEVEL1.2_COLISION:
				#la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Warp_Box_1,7,120,3)
				bnez a0,CANT_MOVE1.2	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Key_Hitbox1,4,8,8)
				bnez a0,CANT_MOVE1.2	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Door_H_Pos1,5,32,4)
				bnez a0,CANT_MOVE1.2	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check_enemy(PLYR_HITBOX,0,15,15,t1,t2,Slime_Pos_0,2,16,16,Slime_0)
				bnez a0,CANT_MOVE1.2	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check_enemy(PLYR_HITBOX,0,15,15,t1,t2,Slime_Pos_1,2,16,16,Slime_1)
				bnez a0,CANT_MOVE1.2	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check_enemy(PLYR_HITBOX,0,15,15,t1,t2,Slime_Pos_2,2,16,16,Slime_2)
				bnez a0,CANT_MOVE1.2	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check_enemy(PLYR_HITBOX,0,15,15,t1,t2,Slime_Pos_3,2,16,16,Slime_3)
				bnez a0,CANT_MOVE1.2	# If a0 != 0, can't walk
				j HITBOX_COLISION_CHECK
				CANT_MOVE1.2:
				j CANT_MOVE				
		LEVEL2_COLISION:
			la t0,LEVEL_INFO
			lh t0,2(t0)
			li t1,1
			bne t1,t0,SKIP_LEVEL2.1_COLISION
			j LEVEL2.1_COLISION
			SKIP_LEVEL2.1_COLISION:
			li t1,2
			bne t1,t0,SKIP_LEVEL2.2_COLISION
			j LEVEL2.2_COLISION
			SKIP_LEVEL2.2_COLISION:
			li t1,3
			bne t1,t0,SKIP_LEVEL2.3_COLISION
			j LEVEL2.3_COLISION
			SKIP_LEVEL2.3_COLISION:
			j HITBOX_COLISION_CHECK
			LEVEL2.1_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Warp_Box_1,7,2,240)
				bnez a0,CANT_MOVE2.1	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Warp_Box_2,7,272,3)
				bnez a0,CANT_MOVE2.1	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Key_Hitbox1,4,8,8)
				bnez a0,CANT_MOVE2.1	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Door_V_Pos1,5,8,38)
				bnez a0,CANT_MOVE2.1	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check_enemy(PLYR_HITBOX,0,15,15,t1,t2,Slime_Pos_0,2,16,16,Slime_0)
				bnez a0,CANT_MOVE2.1	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check_enemy(PLYR_HITBOX,0,15,15,t1,t2,Slime_Pos_1,2,16,16,Slime_1)
				bnez a0,CANT_MOVE2.1	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check_enemy(PLYR_HITBOX,0,15,15,t1,t2,Slime_Pos_2,2,16,16,Slime_2)
				bnez a0,CANT_MOVE2.1	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check_enemy(PLYR_HITBOX,0,15,15,t1,t2,Slime_Pos_3,2,16,16,Slime_3)
				bnez a0,CANT_MOVE2.1	# If a0 != 0, can't walk
				j HITBOX_COLISION_CHECK
				CANT_MOVE2.1:
				j CANT_MOVE	
			LEVEL2.2_COLISION:
				#la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Warp_Box_1,7,4,240)
				bnez a0,CANT_MOVE2.2	# If a0 != 0, can't walk
				la t0, PROCESS_INFO		# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Key_Hitbox2,4,8,8)
				bnez a0,CANT_MOVE2.2	# If a0 != 0, can't walk
				la t0, PROCESS_INFO		# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Door_H_Pos1,5,32,4)
				bnez a0,CANT_MOVE2.2	# If a0 != 0, can't walk
				la t0, PROCESS_INFO		# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Door_H_Pos2,5,32,4)
				bnez a0,CANT_MOVE2.2	# If a0 != 0, can't walk
				la t0, PROCESS_INFO		# Loads PROCESS_INFO address
				lh t1,4(t0)			# Loads X speed from PROCESS_INFO
				lh t2,6(t0)			# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Chest_Hitbox1,6,8,8)
				bnez a0,CANT_MOVE2.2	# If a0 != 0, can't walk
				
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check_enemy(PLYR_HITBOX,0,15,15,t1,t2,Slime_Pos_0,2,16,16,Slime_0)
				bnez a0,CANT_MOVE2.2	# If a0 != 0, can't walk
				
			
				j HITBOX_COLISION_CHECK
				CANT_MOVE2.2:
				j CANT_MOVE
			LEVEL2.3_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Warp_Box_1,7,272,3)
				bnez a0,CANT_MOVE2.3	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Battery_Hitbox1,8,8,8)
				bnez a0,CANT_MOVE2.3	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check_enemy(PLYR_HITBOX,0,15,15,t1,t2,Slime_Pos_0,2,16,16,Slime_0)
				bnez a0,CANT_MOVE2.3	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check_enemy(PLYR_HITBOX,0,15,15,t1,t2,Slime_Pos_2,2,16,16,Slime_2)
				bnez a0,CANT_MOVE2.3	# If a0 != 0, can't walk
				j HITBOX_COLISION_CHECK
				CANT_MOVE2.3:
				j CANT_MOVE
		LEVEL3_COLISION:
			la t0,LEVEL_INFO
			lh t0,2(t0)
			li t1,1
			bne t1,t0,SKIP_LEVEL3.1_COLISION
			j LEVEL3.1_COLISION
			SKIP_LEVEL3.1_COLISION:
			li t1,2
			bne t1,t0,SKIP_LEVEL3.2_COLISION
			j LEVEL3.2_COLISION
			SKIP_LEVEL3.2_COLISION:
			li t1,3
			bne t1,t0,SKIP_LEVEL3.3_COLISION
			j LEVEL3.3_COLISION
			SKIP_LEVEL3.3_COLISION:
			li t1,4
			bne t1,t0,SKIP_LEVEL3.4_COLISION
			j LEVEL3.4_COLISION
			SKIP_LEVEL3.4_COLISION:
			j HITBOX_COLISION_CHECK
			LEVEL3.1_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Warp_Box_1,7,4,240)
				bnez a0,PLYR_CANT_MOVE3.1	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Warp_Box_2,7,272,3)
				bnez a0,PLYR_CANT_MOVE3.1	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Battery_Hitbox1,8,8,8)
				bnez a0,PLYR_CANT_MOVE3.1	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Key_Hitbox1,4,8,8)
				bnez a0,PLYR_CANT_MOVE3.1	# If a0 != 0, can't walk
				j HITBOX_COLISION_CHECK
				PLYR_CANT_MOVE3.1:
				j CANT_MOVE
			LEVEL3.2_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Warp_Box_1,7,2,240)
				bnez a0,PLYR_CANT_MOVE3.2	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Warp_Box_2,7,272,3)
				bnez a0,PLYR_CANT_MOVE3.2	# If a0 != 0, can't walk
				j HITBOX_COLISION_CHECK
				PLYR_CANT_MOVE3.2:
				j CANT_MOVE
			LEVEL3.3_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Warp_Box_1,7,4,236)
				bnez a0,PLYR_CANT_MOVE3.3	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Warp_Box_2,7,272,3)
				bnez a0,PLYR_CANT_MOVE3.3	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Chest_Hitbox1,6,8,8)
				bnez a0,PLYR_CANT_MOVE3.3	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Door_H_Pos1,5,32,6)
				bnez a0,PLYR_CANT_MOVE3.3	# If a0 != 0, can't walk
				j HITBOX_COLISION_CHECK
				PLYR_CANT_MOVE3.3:
				j CANT_MOVE
			LEVEL3.4_COLISION:
				#dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
				#la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				#lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				#lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Warp_Box_1,7,272,3)
				bnez a0,CANT_MOVE3.4	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Warp_Box_2,7,4,240)
				bnez a0,CANT_MOVE3.4	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check(PLYR_HITBOX,0,15,15,t1,t2,Chest_Hitbox1,6,8,8)
				bnez a0,CANT_MOVE3.4	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check_enemy(PLYR_HITBOX,0,15,15,t1,t2,Slime_Pos_0,2,16,16,Slime_0)
				bnez a0,CANT_MOVE3.4	# If a0 != 0, can't walk
				la t0, PROCESS_INFO	# Loads PROCESS_INFO address
				lh t1,4(t0)		# Loads X speed from PROCESS_INFO
				lh t2,6(t0)		# Loads Y speed from PROCESS_INFO
				dynamic_colision_check_enemy(PLYR_HITBOX,0,15,15,t1,t2,Slime_Pos_1,2,16,16,Slime_1)
				bnez a0,CANT_MOVE3.4	# If a0 != 0, can't walk
				j HITBOX_COLISION_CHECK
				CANT_MOVE3.4:
				j CANT_MOVE
			j HITBOX_COLISION_CHECK
		LEVEL4_COLISION:
			j HITBOX_COLISION_CHECK
	
	CANT_MOVE:
		mv ra,s9
		j NO_MOVEMENT
	HITBOX_COLISION_CHECK:
		la t0, PROCESS_INFO	# Loads PROCESS_INFO address
		lh t1,0(t0)		# Loads direction entity is facing
		lh t2,2(t0)		# Loads main movement speed
		static_colision_check(PLYR_HITBOX,LEVEL_HIT_MAP,15,15,t1,t2,0)
		bnez a0,CANT_MOVE	# If a0 != 0, can't walk
		ret
