# ----> Summary: gamerender.s stores labels assotiated to rendering in order to make the main file less jarring
# 1 - RENDER IMAGE (Renders sprites and removes trails made by them)
# 2 - RENDER BIG IMAGE (Used for rendering parts of sprites bigger than the 320 x 240 resolution)
# 3 - RENDER PLAYER (Renders player, taking no arguments)
# 4 - RENDER MAGIC (Renders player's attacks)
# 5 - RENDER UI INFO (Renders UI)
# 6 - RENDER ENEMY (renders enemy)


.text
##########################     RENDER IMAGE    ##########################
#     -----------           argument registers           -----------    #
#	a0 = Image Address						#
#	a1 = X coordinate where rendering will start (top left)		#
#	a2 = Y coordinate where rendering will start (top left)		#
#	a3 = width of printing area (usually the size of the sprite)	#
# 	a4 = height of printing area (usually the size of the sprite)	#
#	a5 = frame (0 or 1)						#
#	a6 = status of sprite (usually 0 for sprites that are alone)	#
#	a7 = operation (0 if normal printing, 1 if replacing trail)	#
#     -----------          temporary registers           -----------    #
#	t0 = bitmap display printing address				#
#	t1 = image address						#
#	t2 = line counter						#
# 	t3 = column counter						#
# 	t4 = temporary operations					#
#########################################################################
RENDER:
beqz a7,NORMAL
	TRAIL_OP:	# Only when replacing trail; proceeds to NOT_TRAIL	
		add a0,a0,a1	# Image address + X
		li t3,320	# t4 = 320
		mul t3,t3,a2	# t4 = t4 * Y
		add a0,a0,t3	# a0 = Image address + X + 320 * Y
	NORMAL:		# Executed even if on trail operation
		mul t4,a6,a4	# Sprite offset (for files that have more than one sprite)
		mul t4,t4,a3	# Sprite Line offset (skips the first %width lines)
		addi a0,a0,8	# Skip image size info
		add a0,a0,t4	# Adds offset to image address

	#Propper rendering

	li t0,0x0FF0	#t0 = 0x0FF0
	add t0,t0,a5	#Printing address corresponds to 0x0FF0 + frame
	slli t0,t0,20	#shifts 20 bits, making printing adress correct (0xFF00 0000 or 0xFF10 0000)
	add t0,t0,a1	# t0 = 0xFF00 0000 + X or 0xFF10 0000 + X
	li t4,320	# t4 = 320
	mul t4,t4,a2	# t4 = 320 * Y 
	add t0,t0,t4	# t0 = 0xFF00 0000 + X + (Y * 320) or 0xFF10 0000 + X + (Y * 320)
	mv t2,zero	# t2 = 0
	mv t3,zero	# t3 = 0
	
	PRINT_LINE:	
		lw t4,0(a0)	# loads word(4 pixels) on t4
		sw t4,0(t0)	# prints 4 pixels from t4
		
		addi t0,t0,4	# increments bitmap address
		addi a0,a0,4	# increments image address
		
		addi t3,t3,4	# increments column counter
		blt t3,a3,PRINT_LINE	# if column counter < width, repeat
		
		addi t0,t0,320
		sub t0,t0,a3
		
		beqz a7, NORMAL_PRINT
		TRAIL_PRINT:
			addi a0,a0,320	# a0 +=320	
			sub a0,a0,a3	# a0 -= width
		NORMAL_PRINT: 
			mv t3,zero		# t3 = 0
			addi t2,t2,1		# increments line counter
			bgt a4,t2,PRINT_LINE	#if height > line counter, repeat
			ret

#######################     RENDE RBIG IMAGE    ############################
# Used for rendering parts of sprites bigger than the 320 x 240 resolution #
#     -----------           argument registers           -----------       #
#	a0 = Image Address						   #
#	a1 = X coordinate where rendering will start (top left)		   #
#	a2 = Y coordinate where rendering will start (top left)		   #
#	a3 = width of printing area (usually the size of the sprite)	   #
# 	a4 = height of printing area (usually the size of the sprite)	   #
#	a5 = frame (0 or 1)						   #
#	a6 = status of sprite (usually 0 for sprites that are alone)	   #
#	a7 = operation (0 if normal printing, 1 if replacing trail)	   #
#	s1 = X coordinate in the sprite					   #
#	s2 = Y coordinate in the sprite					   #
#	s3 = width of sprite (greater than 320)				   #
#	s4 = height of sprite (greater than 240)			   #
#									   #
#     -----------          temporary registers           -----------       #
#	t0 = bitmap display printing address				   #
#	t1 = image address						   #
#	t2 = line counter						   #
#  	t3 = column counter						   #
#  	t4 = temporary operations					   #
############################################################################
RENDER_BIG:
	add a0,a0,s1	# Image address + X (in the sprite)
	mul t4,s3,s2	# t4 = (sprite width) * Y (in the sprite)
	add a0,a0,t4	# a0 = Image address + X (in the sprite) + (sprite width) * Y (in the sprite)
	mul t4,a6,s4	# Sprite offset (for files that have more than one sprite)
	mul t4,t4,s3	# Sprite Line offset (skips the first %width lines)
	addi a0,a0,8	# Skip image size info
	add a0,a0,t4	# Adds offset to image address

	#Propper rendering

	li t0,0x0FF0	# t0 = 0x0FF0
	add t0,t0,a5	# Printing address corresponds to 0x0FF0 + frame
	slli t0,t0,20	# shifts 20 bits, making printing adress correct (0xFF00 0000 or 0xFF10 0000)
	add t0,t0,a1	# t0 = 0xFF00 0000 + X or 0xFF10 0000 + X
	li t4,320	# t4 = 320
	mul t4,t4,a2	# t4 = 320 * Y 
	add t0,t0,t4	# The starting address for printing is t0 = 0xFF00 0000 + X + (Y * 320) or 0xFF10 0000 + X + (Y * 320)
	mv t2,zero	# t2 = 0 (line counter - assotiated with height and Y)
	mv t3,zero	# t3 = 0 (column counter - assotiated with width and X)
	
	PRINT_LINE_BIG:
		lb t4,0(a0)	# loads word(4 pixels) on t4
		sb t4,0(t0)	# prints 4 pixels from t4
		
		addi t0,t0,1	# increments bitmap address (since 4 pixels were stored, it'll skip 4 pixels)
		addi a0,a0,1	# increments image address (since it loaded 4 pixels, it'll skip 4 pixels)
		
		addi t3,t3,1	# increments column counter (since 4 pixels were stored, it'll add 4 to the counter)
		blt t3,a3,PRINT_LINE_BIG	# if column counter < width, repeat
		
		addi t0,t0,320	# Goes to next row in screen address
		sub t0,t0,a3	# Subtracts the width printed (in order to go to the first column from given position in the next row)
		
		add a0,a0,s3	# a0 += s3 
		sub a0,a0,a3	# a0 -= width
		mv t3,zero		# t3 = 0
		addi t2,t2,1		# increments line counter
		bgt a4,t2,PRINT_LINE_BIG	# if height > line counter, repeat
		ret
			
			
#################################################
#	    	RENDER PLAYER			#
#	    Renders a player based 		#
#       on which position it is facing at	#
#             (takes no arguments)		#
#################################################

RENDER_PLAYER:
	la a0,PLYR_POS		# Loads address of player position
	lh a1,0(a0)		# X coordinate where rendering will start (top left)
	lh a2,2(a0)		# Y coordinate where rendering will start (top left)
	la a0, PLYR_STATUS	# Loads player status (which part of sprite is to be rendered)				
	lh a6, 0(a0)		# Sprite status
		
	la t0,PLYR_STATUS	# Loads address of player status
	lh t0,6(t0)		# Checks whether player is attacking
	bnez t0,SKIP_RENDER_NOT_ATTACKING
	j RENDER_NOT_ATTACKING
	SKIP_RENDER_NOT_ATTACKING:
	li t1,1
	bne t0,t1,SKIP_RENDER_RANGE_ATTACKING
	j RENDER_RANGE_ATTACKING
	SKIP_RENDER_RANGE_ATTACKING:
	li t1,2
	bne t0,t1,SKIP_RENDER_MELEE_ATTACKING
	j RENDER_MELEE_ATTACKING
	SKIP_RENDER_MELEE_ATTACKING:
	j RENDER_NOT_ATTACKING
	RENDER_MELEE_ATTACKING:
		la t0,PLYR_STATUS		# Loads address of player status
		lh t0,4(t0)			# Checks direction player is facing at
		beqz t0,RENDER_MELEE_ATTACK_FRONT
		li t1,1
		beq t0,t1,RENDER_MELEE_ATTACK_BACK
		li t1,2
		beq t0,t1,RENDER_MELEE_ATTACK_RIGHT
		li t1,3
		beq t0,t1,RENDER_MELEE_ATTACK_LEFT
		j STOP_RENDER
	RENDER_RANGE_ATTACKING:
		la t0,PLYR_STATUS		# Loads address of player status
		lh t0,4(t0)			# Checks direction player is facing at
		beqz t0,RENDER_ATTACK_FRONT
		li t1,1
		beq t0,t1,RENDER_ATTACK_BACK
		li t1,2
		beq t0,t1,RENDER_ATTACK_RIGHT
		li t1,3
		beq t0,t1,RENDER_ATTACK_LEFT
		j STOP_RENDER
	RENDER_NOT_ATTACKING:
		la t0,PLYR_STATUS		# Loads address of player status
		lh t0,4(t0)			# Checks direction player is facing at
		beqz t0,RENDER_FRONT
		li t1,1
		beq t0,t1,RENDER_BACK
		li t1,2
		beq t0,t1,RENDER_RIGHT
		li t1,3
		beq t0,t1,RENDER_LEFT
		j STOP_RENDER
			
	RENDER_FRONT:	
		la a0,PC_Front
		j START_RENDER_PLAYER
	
	RENDER_BACK:	
		la a0,PC_Back
		j START_RENDER_PLAYER
		
	RENDER_RIGHT:	
		la a0,PC_Right
		j START_RENDER_PLAYER
		
	RENDER_LEFT:	
		la a0,PC_Left
		j START_RENDER_PLAYER
		
	RENDER_ATTACK_FRONT:	
		la a0,PC_Attack_Front
		j START_RENDER_PLAYER
		
	RENDER_ATTACK_BACK:	
		la a0,PC_Attack_Back
		j START_RENDER_PLAYER
		
	RENDER_ATTACK_RIGHT:	
		la a0,PC_Attack_Right
		j START_RENDER_PLAYER
		
	RENDER_ATTACK_LEFT:	
		la a0,PC_Attack_Left
		j START_RENDER_PLAYER
		
	RENDER_MELEE_ATTACK_FRONT:	
		la a0,PC_Melee_Attack_Front
		j START_RENDER_PLAYER
		
	RENDER_MELEE_ATTACK_BACK:	
		la a0,PC_Melee_Attack_Back
		j START_RENDER_PLAYER
		
	RENDER_MELEE_ATTACK_RIGHT:	
		la a0,PC_Melee_Attack_Right
		j START_RENDER_PLAYER
		
	RENDER_MELEE_ATTACK_LEFT:	
		la a0,PC_Melee_Attack_Left
		j START_RENDER_PLAYER
	
	
	START_RENDER_PLAYER:
		render_add(a0,a1,a2,24,24,s0,a6,0)
	STOP_RENDER:
		ret			

#################################################
#		   RENDER MAGIC			#
#	Renders projectiles based on which 	#
#	    position they are facing at		#
#             (takes no arguments)		#
#	s1 stores the current address on 	#
#	    the array loops bellow		#
#################################################
.data
enter: .string "\n"
.text
RENDER_MAGIC:
	li s2, 0 			# S2 is a counter in START_RENDERING_MAGIC
	la s1, MAGIC_ARRAY		# Loads MAGIC_ARRAY address to s1
	START_RENDERING_MAGIC:
		lh t0, 14(s1)			# Loads the number of times Magic has been rendered (Magic_Status)
		beqz t0,AFTER_RENDER_MAGIC	# If 0, it means it is inactive, thus, can be rendered from a new position
		PROPER_MAGIC_RENDERING:
			lh a1,0(s1)		# X coordinate where rendering will start (top left)
			lh a2,2(s1)		# Y coordinate where rendering will start (top left)
			lh a6, 8(s1)		# Sprite status
			lh t0,14(s1)
			addi t0,t0,1
			li t1,attack_time
			bne t1,t0,UPDATED_ATTACK_TIME
			RESET_ATTACK_TIME:
				li t0,0
				sh t0,14(s1)
				j AFTER_RENDER_MAGIC
			UPDATED_ATTACK_TIME:
				sh t0,14(s1)
				lh t0,12(s1)			# Checks direction magic is facing at
				beqz t0,RENDER_MAGIC_FRONT
				li t1,1
				beq t0,t1,RENDER_MAGIC_BACK
				li t1,2
				beq t0,t1,RENDER_MAGIC_RIGHT
				li t1,3
				beq t0,t1,RENDER_MAGIC_LEFT
				j AFTER_RENDER_MAGIC
				RENDER_MAGIC_FRONT:	
					render(Magic_Front,a1,a2,16,16,s0,s0,0)
					j AFTER_RENDER_MAGIC
				
				RENDER_MAGIC_BACK:	
					render(Magic_Back,a1,a2,16,16,s0,s0,0)
					j AFTER_RENDER_MAGIC
					
				RENDER_MAGIC_RIGHT:	
					render(Magic_Right,a1,a2,16,16,s0,s0,0)
					j AFTER_RENDER_MAGIC
					
				RENDER_MAGIC_LEFT:	
					render(Magic_Left,a1,a2,16,16,s0,s0,0)
					j AFTER_RENDER_MAGIC
			
		AFTER_RENDER_MAGIC:
			addi s1,s1,16			# Goes to the next Magic_Pos in the array
			li t0,max_plyr_projectile	# Max number of projectiles
			addi s2,s2,1			# s2 += 1
			bge s2,t0,RENDER_ULA_MAGIC	# if s2 >= t0, stops loop 
			
 			j START_RENDERING_MAGIC

RENDER_ULA_MAGIC:
	li s2, 0 			# S2 is a counter in START_RENDERING_MAGIC
	la s1, ULA_MAGIC_ARRAY		# Loads MAGIC_ARRAY address to s1
	START_RENDERING_ULA_MAGIC:
		lh t0, 14(s1)			# Loads the number of times Magic has been rendered (Magic_Status)
		beqz t0,AFTER_ULA_RENDER_MAGIC	# If 0, it means it is inactive, thus, can be rendered from a new position
		PROPER_ULA_MAGIC_RENDERING:
			lh a1,0(s1)		# X coordinate where rendering will start (top left)
			lh a2,2(s1)		# Y coordinate where rendering will start (top left)
			lh a6, 8(s1)		# Sprite status
			lh t0,14(s1)
			addi t0,t0,1
			
			la t1, LEVEL_INFO		# Loads LEVEL_INFO address
			lh t1,0(t1)			# Gets level number
			li t2,3
			beq t1,t2,LEVEL_3_ATK_TIME
			LEVEL_2_ATK_TIME:
				li t1,ula_2_attack_time
				bne t1,t0,UPDATED_ULA_ATTACK_TIME
				j RESET_ULA_ATTACK_TIME
			LEVEL_3_ATK_TIME:
				li t1,ula_3_attack_time
				bne t1,t0,UPDATED_ULA_ATTACK_TIME
			RESET_ULA_ATTACK_TIME:
				li t0,0
				sh t0,14(s1)
				j AFTER_ULA_RENDER_MAGIC
			UPDATED_ULA_ATTACK_TIME:
				sh t0,14(s1)
				la t0,LEVEL_INFO	# Loads level info
				lh t0,0(t0)		# Loads level (if level is 2 (stone) or level is 3 (magma))
				
				li t1,2				# Level 2
				beq t1,t0,ULA_STONE_MAGIC	# Level 2
				li t1,3				# Level 3
				beq t1,t0,ULA_MAGMA_MAGIC	# Level 3
				j AFTER_ULA_RENDER_MAGIC
				ULA_STONE_MAGIC:
					lh t0,12(s1)			# Checks direction magic is facing at
					beqz t0,RENDER_STONE_ULA_MAGIC_FRONT
					li t1,1
					beq t0,t1,RENDER_STONE_ULA_MAGIC_BACK
					li t1,2
					beq t0,t1,RENDER_STONE_ULA_MAGIC_RIGHT
					li t1,3
					beq t0,t1,RENDER_STONE_ULA_MAGIC_LEFT
					j AFTER_ULA_RENDER_MAGIC
					RENDER_STONE_ULA_MAGIC_FRONT:	
						render(Stone_ULA_Magic_Front,a1,a2,16,16,s0,s0,0)
						j AFTER_ULA_RENDER_MAGIC
					
					RENDER_STONE_ULA_MAGIC_BACK:	
						render(Stone_ULA_Magic_Back,a1,a2,16,16,s0,s0,0)
						j AFTER_ULA_RENDER_MAGIC
						
					RENDER_STONE_ULA_MAGIC_RIGHT:	
						render(Stone_ULA_Magic_Right,a1,a2,16,16,s0,s0,0)
						j AFTER_ULA_RENDER_MAGIC
						
					RENDER_STONE_ULA_MAGIC_LEFT:	
						render(Stone_ULA_Magic_Left,a1,a2,16,16,s0,s0,0)
						j AFTER_ULA_RENDER_MAGIC
						
				ULA_MAGMA_MAGIC:
					lh t0,12(s1)			# Checks direction magic is facing at
					beqz t0,RENDER_MAGMA_ULA_MAGIC_FRONT
					li t1,1
					beq t0,t1,RENDER_MAGMA_ULA_MAGIC_BACK
					li t1,2
					beq t0,t1,RENDER_MAGMA_ULA_MAGIC_RIGHT
					li t1,3
					beq t0,t1,RENDER_MAGMA_ULA_MAGIC_LEFT
					j AFTER_ULA_RENDER_MAGIC
					RENDER_MAGMA_ULA_MAGIC_FRONT:	
						render(Magma_ULA_Magic_Front,a1,a2,16,16,s0,s0,0)
						j AFTER_ULA_RENDER_MAGIC
					
					RENDER_MAGMA_ULA_MAGIC_BACK:	
						render(Magma_ULA_Magic_Back,a1,a2,16,16,s0,s0,0)
						j AFTER_ULA_RENDER_MAGIC
						
					RENDER_MAGMA_ULA_MAGIC_RIGHT:	
						render(Magma_ULA_Magic_Right,a1,a2,16,16,s0,s0,0)
						j AFTER_ULA_RENDER_MAGIC
						
					RENDER_MAGMA_ULA_MAGIC_LEFT:	
						render(Magma_ULA_Magic_Left,a1,a2,16,16,s0,s0,0)
						j AFTER_ULA_RENDER_MAGIC
			
		AFTER_ULA_RENDER_MAGIC:
			addi s1,s1,16			# Goes to the next Magic_Pos in the array
			li t0,max_enmy_projectile	# Max number of projectiles
			addi s2,s2,1			# s2 += 1
			bge s2,t0,ENDRENDERMAGIC	# if s2 >= t0, stops loop 
			
 			j START_RENDERING_ULA_MAGIC
 ENDRENDERMAGIC:
	ret
		
############     RENDER UI INFO    ##############
#						#
#  Checks how many digits each player info has  #
#	and prints acoordingly on screen	#
#						#
#################################################

RENDER_UI_INFO:
	render_mapi(LEVEL_MAP,280,86,36,140,s0,0,1)
	la t0,PLYR_INFO
	lh a0,0(t0)
	bgez a0,NORMAL_HEALTH
	SET_HEALTH_TO_ZERO:
		li a0,0
	NORMAL_HEALTH:
	count_digit()
	li t0,292
	li t1,-4
	addi a1,a1,-1
	mul t1,t1,a1
	add t0,t1,t0
	print_int(a0,t0,86,0x00FF,s0)
	la t0,PLYR_INFO
	lh a0,2(t0)
	count_digit()
	li t0,292
	li t1,-4
	addi a1,a1,-1
	mul t1,t1,a1
	add t0,t1,t0
	print_int(a0,t0,150,0x00FF,s0)
	la t0,PLYR_INFO
	lh t0,4(t0)
	li t1,288
	print_int(t0,t1,215,0x00FF,s0)
	ret

#################################################
#	    	   RENDER ENEMY			#
#	      Renders an enemy based 		#
#       on which position it is facing at	#
#             (takes no arguments)		#
#################################################

RENDER_ENEMY:
	lh t0,6(s1)	# Gets enemy health
	bnez t0,SKIP_STOP_RENDER_ENEMY	# and if it equals to 0, enemy is dead (don't render)
	j STOP_RENDER_ENEMY
	SKIP_STOP_RENDER_ENEMY:
	# otherwise, continue, checking enemy type
	lh t0,8(s1)		# Gets enemy type
	bnez t0,SKIP_RENDER_SLIME	# if it equals to 0, it's a slime
	j RENDER_SLIME
	SKIP_RENDER_SLIME:
	li t1,2
	bne t0,t1,SKIP_RENDER_ULA	# if it equals to 2, it's an ULA
	j RENDER_ULA
	SKIP_RENDER_ULA:
	j STOP_RENDER_ENEMY
	RENDER_SLIME:
		lh t0,18(s1)		# Gets sprite type
		bnez t0,SKIP_RENDER_WATER_SLIME	# if it equals to 0, it's a water slime
		j RENDER_WATER_SLIME
		SKIP_RENDER_WATER_SLIME:
		li t1,1
		bne t1,t0,SKIP_RENDER_STONE_SLIME
		j RENDER_STONE_SLIME
		SKIP_RENDER_STONE_SLIME:
		li t1,2
		bne t1,t0,SKIP_RENDER_MAGMA_SLIME
		j RENDER_MAGMA_SLIME
		SKIP_RENDER_MAGMA_SLIME:
		j STOP_RENDER_ENEMY
		RENDER_WATER_SLIME:
			lh a1,20(s1)		# Gets X coordinate where rendering will start (top left)
			lh a2,22(s1)		# Gets Y coordinate where rendering will start (top left)
			lh a6,12(s1)		# Gets enemy sprite status
			
			lh t0,16(s1)		# Gets direction enemy is facing at
			beqz t0,RENDER_WATER_SLIME_FRONT
			li t1,1
			beq t0,t1,RENDER_WATER_SLIME_BACK
			li t1,2
			beq t0,t1,RENDER_WATER_SLIME_RIGHT
			li t1,3
			beq t0,t1,RENDER_WATER_SLIME_LEFT
			j STOP_RENDER_ENEMY
			RENDER_WATER_SLIME_FRONT:	
				la a0,Water_Slime_Front
				j START_RENDER_ENEMY
			
			RENDER_WATER_SLIME_BACK:	
				la a0,Water_Slime_Back
				j START_RENDER_ENEMY
				
			RENDER_WATER_SLIME_RIGHT:	
				la a0,Water_Slime_Right
				j START_RENDER_ENEMY
				
			RENDER_WATER_SLIME_LEFT:	
				la a0,Water_Slime_Left
				j START_RENDER_ENEMY
				
				
		RENDER_STONE_SLIME:
			lh a1,20(s1)		# Gets X coordinate where rendering will start (top left)
			lh a2,22(s1)		# Gets Y coordinate where rendering will start (top left)
			lh a6,12(s1)		# Gets enemy sprite status
			
			lh t0,16(s1)		# Gets direction enemy is facing at
			beqz t0,RENDER_STONE_SLIME_FRONT
			li t1,1
			beq t0,t1,RENDER_STONE_SLIME_BACK
			li t1,2
			beq t0,t1,RENDER_STONE_SLIME_RIGHT
			li t1,3
			beq t0,t1,RENDER_STONE_SLIME_LEFT
			j STOP_RENDER_ENEMY
			RENDER_STONE_SLIME_FRONT:	
				la a0,Stone_Slime_Front
				j START_RENDER_ENEMY
			
			RENDER_STONE_SLIME_BACK:	
				la a0,Stone_Slime_Back
				j START_RENDER_ENEMY
				
			RENDER_STONE_SLIME_RIGHT:	
				la a0,Stone_Slime_Right
				j START_RENDER_ENEMY
				
			RENDER_STONE_SLIME_LEFT:	
				la a0,Stone_Slime_Left
				j START_RENDER_ENEMY
				
				
		RENDER_MAGMA_SLIME:
			lh a1,20(s1)		# Gets X coordinate where rendering will start (top left)
			lh a2,22(s1)		# Gets Y coordinate where rendering will start (top left)
			lh a6,12(s1)		# Gets enemy sprite status
			
			lh t0,16(s1)		# Gets direction enemy is facing at
			beqz t0,RENDER_MAGMA_SLIME_FRONT
			li t1,1
			beq t0,t1,RENDER_MAGMA_SLIME_BACK
			li t1,2
			beq t0,t1,RENDER_MAGMA_SLIME_RIGHT
			li t1,3
			beq t0,t1,RENDER_MAGMA_SLIME_LEFT
			j STOP_RENDER_ENEMY
			RENDER_MAGMA_SLIME_FRONT:	
				la a0,Magma_Slime_Front
				j START_RENDER_ENEMY
			
			RENDER_MAGMA_SLIME_BACK:	
				la a0,Magma_Slime_Back
				j START_RENDER_ENEMY
				
			RENDER_MAGMA_SLIME_RIGHT:	
				la a0,Magma_Slime_Right
				j START_RENDER_ENEMY
				
			RENDER_MAGMA_SLIME_LEFT:	
				la a0,Magma_Slime_Left
				j START_RENDER_ENEMY
				
				
	RENDER_ULA:
		lh t0,18(s1)		# Gets sprite type
		beqz t0,RENDER_STONE_ULA
		li t1,1
		beq t0,t1,RENDER_MAGMA_ULA	# if it equals to 1, it's a magma ULA
		j STOP_RENDER_ENEMY
		RENDER_STONE_ULA:
			lh a1,20(s1)		# Gets X coordinate where rendering will start (top left)
			lh a2,22(s1)		# Gets Y coordinate where rendering will start (top left)
			lh a6,12(s1)		# Gets enemy sprite status
			
			la a0,Stone_ULA_Flower
			j START_RENDER_ENEMY
		RENDER_MAGMA_ULA:
			lh a1,20(s1)		# Gets X coordinate where rendering will start (top left)
			lh a2,22(s1)		# Gets Y coordinate where rendering will start (top left)
			lh a6,12(s1)		# Gets enemy sprite status
			
			la a0,Magma_ULA_Flower
			j START_RENDER_ENEMY
			
			
	START_RENDER_ENEMY:
		render_add(a0,a1,a2,16,16,s0,a6,0)
	STOP_RENDER_ENEMY:
		ret
