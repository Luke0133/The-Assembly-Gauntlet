#########################################################
#			RENDERING			#
#		More info in gamerender.s		#
#########################################################

.macro render(%sprite,%x,%y,%width,%height,%frame,%status,%operation) #most of the inputs are registers
la a0, %sprite 		# Gets sprite address
mv a1, %x		# X coordinate where rendering will start (top left) --- register
mv a2, %y		# Y coordinate where rendering will start (top left) --- register		
li a3, %width		# Width of printing area (usually the size of the sprite) --- immediate
li a4, %height		# Height of printing area (usually the size of the sprite) --- immediate	
mv a5, %frame		# Frame (0 or 1) --- register						
mv a6, %status		# Sprite status --- register
li a7, %operation	# Operation (0 if normal printing, 1 if replacing trail) --- register

mv s11,ra			# Stores ra to s11
call RENDER
mv ra,s11			# Retrieves s11 to ra

.end_macro

.macro renderi(%sprite,%x,%y,%width,%height,%frame,%status,%operation) #all input are immediates (except the name of image)
la a0, %sprite 		# Gets sprite address
li a1, %x		# X coordinate where rendering will start (top left) --- immediate
li a2, %y		# Y coordinate where rendering will start (top left) --- immediate		
li a3, %width		# Width of printing area (usually the size of the sprite) --- immediate
li a4, %height		# Height of printing area (usually the size of the sprite) --- immediate	
mv a5, %frame		# Frame (0 or 1) --- immediate						
li a6, %status		# Sprite status --- immediate
li a7, %operation	# Operation (0 if normal printing, 1 if replacing trail) --- immediate

mv s11,ra			# Stores ra to s11
call RENDER
mv ra,s11			# Retrieves s11 to ra

.end_macro

#########################################################
#		      RENDER ADDRESS			#
#    Will render based on an address, not it's label	#
#########################################################

.macro render_add(%imgaddress,%x,%y,%width,%height,%frame,%status,%operation) #most of the inputs are registers
mv a0, %imgaddress 	# Image address --- address
mv a1, %x		# X coordinate where rendering will start (top left) --- register
mv a2, %y		# Y coordinate where rendering will start (top left) --- register		
li a3, %width		# Width of printing area (usually the size of the sprite) --- immediate
li a4, %height		# Height of printing area (usually the size of the sprite) --- immediate	
mv a5, %frame		# Frame (0 or 1) --- register						
mv a6, %status		# Sprite status --- register
li a7, %operation	# Operation (0 if normal printing, 1 if replacing trail) --- register

mv s11,ra			# Stores ra to s11
call RENDER
mv ra,s11			# Retrieves s11 to ra

.end_macro

.macro render_addi(%imgaddress,%x,%y,%width,%height,%frame,%status,%operation) #most of the inputs are registers
mv a0, %imgaddress 	# Image address --- address
li a1, %x		# X coordinate where rendering will start (top left) --- immediate
li a2, %y		# Y coordinate where rendering will start (top left) --- immediate		
li a3, %width		# Width of printing area (usually the size of the sprite) --- immediate
li a4, %height		# Height of printing area (usually the size of the sprite) --- immediate	
mv a5, %frame		# Frame (0 or 1) --- immediate						
li a6, %status		# Sprite status --- immediate
li a7, %operation	# Operation (0 if normal printing, 1 if replacing trail) --- immediate

mv s11,ra			# Stores ra to s11
call RENDER
mv ra,s11			# Retrieves s11 to ra

.end_macro

#########################################
#	       RENDER MAP 		#
#	Render %map_address map		#
#########################################

.macro render_map(%levelmap,%x,%y,%width,%height,%frame,%status,%operation) #most of the inputs are registers
la t0,%levelmap		# %levelmap contains the address of current level
lw a0, 0(t0) 		# Gets sprite address
mv a1, %x		# X coordinate where rendering will start (top left) --- register
mv a2, %y		# Y coordinate where rendering will start (top left) --- register		
li a3, %width		# Width of printing area (usually the size of the sprite) --- immediate
li a4, %height		# Height of printing area (usually the size of the sprite) --- immediate	
mv a5, %frame		# Frame (0 or 1) --- register						
mv a6, %status		# Sprite status --- register
li a7, %operation	# Operation (0 if normal printing, 1 if replacing trail) --- register

mv s11,ra			# Stores ra to s11
call RENDER
mv ra,s11			# Retrieves s11 to ra

.end_macro

.macro render_mapi(%levelmap,%x,%y,%width,%height,%frame,%status,%operation) #all input are immediates (except the name of image)
la t0,%levelmap		# %levelmap contains the address of current level
lw a0, 0(t0) 		# Gets sprite address
li a1, %x		# X coordinate where rendering will start (top left) --- immediate
li a2, %y		# Y coordinate where rendering will start (top left) --- immediate		
li a3, %width		# Width of printing area (usually the size of the sprite) --- immediate
li a4, %height		# Height of printing area (usually the size of the sprite) --- immediate	
mv a5, %frame		# Frame (0 or 1) --- immediate						
li a6, %status		# Sprite status --- immediate
li a7, %operation	# Operation (0 if normal printing, 1 if replacing trail) --- immediate

mv s11,ra			# Stores ra to s11
call RENDER
mv ra,s11			# Retrieves s11 to ra

.end_macro

#################################################################
#		    	REMOVE TRAIL 				#
#	Gets the position and the map desired to remove the	#
#       trail made by a %width x %height sprite when moving	#
#################################################################

.macro remove_trail(%pos_address,%map_address,%width,%height)
la a0,%pos_address	# Loads pos_address
lh a1,4(a0)		# Loads X position in a1
mv s11,ra
call TRAIL_COORDINATE_CHECK
mv ra,s11
mv a5,s0		# Moves current frame to a5
xori a5,a5,1		# inverts a5						
li a6, 0		# Sprite status
render_map(%map_address,a1,a2,%width,%height,a5,a6,1) #renders acordingly

.end_macro

.macro remove_array_trail(%pos_address,%map_address,%width,%height)
lh a1,4(%pos_address)		# Loads X position in a1
lh a2,6(%pos_address)		# Loads old Y position in a2
mv a5,s0		# Moves current frame to a5
xori a5,a5,1		# inverts a5						
li a6, 0		# Sprite status
render_map(%map_address,a1,a2,%width,%height,a5,a6,1) #renders acordingly

.end_macro
#################################################################
#		    	REMOVE STATIC TRAIL 			#
#	Gets the position and the map desired to remove the	#
#    trail made by a %width x %height sprite that won't move	#
#################################################################

.macro remove_static_trail(%pos_address,%map_address,%width,%height)
la t0,%pos_address	# Loads pos_address
lh a1,0(t0)		# Loads X position in a1
lh a2,2(t0)		# Loads Y position in a2
mv a5,s0		# Moves current frame to a5
li a6, 0
render_map(%map_address,a1,a2,%width,%height,a5,a6,1) #renders acordingly
xori a5,a5,1		# inverts a5						
li a6, 0		# Sprite status
render_map(%map_address,a1,a2,%width,%height,a5,a6,1) #renders acordingly

.end_macro


#########################################################
#		  RENDER BIGGER SPRITES			#
#		More info in gamerender.s		#
#########################################################

.macro render_big(%imgaddress,%x,%y,%width,%height,%frame,%status,%operation,%file_x,%file_y,%file_width,%file_height) #most of the inputs are registers
la a0, %imgaddress 	# Image address --- Name of Image
li a1, %x		# X coordinate where rendering will start (top left) --- register
li a2, %y		# Y coordinate where rendering will start (top left) --- register		
li a3, %width		# Width of printing area (usually the size of the sprite) --- immediate
li a4, %height		# Height of printing area (usually the size of the sprite) --- immediate	
mv a5, %frame		# Frame (0 or 1) --- register						
mv a6, %status		# Sprite status --- register
li a7, 2		# Operation (2 = render bigger sprite) (OBSOLETE)
mv s1, %file_x		# X coordinate on the sprite file
mv s2, %file_y		# Y coordinate on the sprite file
li s3, %file_width	# width of sprite (greater than 320) --- immediate
li s4, %file_height	# height of sprite (greater than 240) --- immediate

mv s11,ra			# Stores ra to s11
call RENDER_BIG
mv ra,s11			# Retrieves s11 to ra

.end_macro




#################################################################
#		    STATIC COLISION CHECK 			#
#     Checks for colisions from unmovable objects, contained	#
#     in a map .data file: walls and end level checkpoints	#
#      directions: down - 0, up - 1, right - 2, left - 3	#
#       	More info in gamelonglabels.s			#
#################################################################

.macro static_colision_check(%hitbox,%map_hitbox,%width,%height,%direction,%mov_speed,%entity_type)
la t0,%map_hitbox		# MAP hitbox
lw a0,(t0)			# MAP hitbox address
la t0,%hitbox			# Player hitbox
lh a1,0(t0)			# Loads hitbox's X position in a1
lh a2,2(t0)			# Loads hitbox's Y position in a2
li a3,%width			# Width of hitbox
li a4,%height			# Height of hitbox
mv a5,%direction		# Direction (down - 0, up - 1, right - 2, left - 3)
mv a6,%mov_speed		# Mov 'speed'
li a7,%entity_type		# Entity type (0 for player, 1 for anything else)
mv s11,ra			# Stores ra to s11
call STATIC_COLISION_CHECK	# Checks static colision
mv ra,s11			# Retrieves s11 to ra
.end_macro

.macro projectile_static_colision_check(%projectile_address,%map_hitbox,%width,%height,%direction,%mov_speed,%entity_type)
la t0,%map_hitbox		# MAP hitbox
lw a0,(t0)			# MAP hitbox address
lh a1,0(%projectile_address)	# Loads hitbox's X position in a1
lh a2,2(%projectile_address)	# Loads hitbox's Y position in a2
li a3,%width			# Width of hitbox
li a4,%height			# Height of hitbox
mv a5,%direction		# Direction (down - 0, up - 1, right - 2, left - 3)
mv a6,%mov_speed		# Mov 'speed'
li a7,%entity_type		# Entity type (0 for player, 1 for anything else)
mv s11,ra			# Stores ra to s11
call STATIC_COLISION_CHECK	# Checks static colision
mv ra,s11			# Retrieves s11 to ra
.end_macro
#################################################################
#		    	LEVEL COLISON				#
#       Prepares for checking colisions from a given level 	#
#       	More info in gamelonglabels.s			#
#################################################################
#     s7,s8(type of entity)       s9,s10,s11(stores ra)
.macro level_colision(%is_moving,%direction)
#%is_moving,%direction
li t0,%is_moving
li t2,%direction
mv s9,ra
call LEVEL_COLISION
mv ra,s9
.end_macro

#################################################################
#		    DYNAMIC COLISION CHECK 			#
#     Checks for colisions from movable objects, contained	#
#       	More info in colisionlabels.s			#
#################################################################

.macro dynamic_colision_check(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
la t0,%hitbox1			# Player hitbox
lh a0,0(t0)			# Loads hitbox's X position in a1
lh a1,2(t0)			# Loads hitbox's Y position in a2
add a0,a0,%mov_speedX
add a1,a1,%mov_speedY
li a2,%width1			# Width of hitbox
li a3,%height1			# Height of hitbox
li s7,%type1
la t0,%hitbox2
lh a4,0(t0)			# Loads hitbox's X position in a1
lh a5,2(t0)			# Loads hitbox's Y position in a2
li a6,%width2			# Width of hitbox
li a7,%height2			# Height of hitbox
li s8,%type2

mv s10,ra			# Stores ra to s11
call DYNAMIC_COLISION_CHECK	# Checks dynamic colision
mv ra,s10			# Retrieves s11 to ra
.end_macro

.macro projectile_dynamic_colision_check(%projectile_address,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2)
lh a0,0(%projectile_address)			# Loads hitbox's X position in a1
lh a1,2(%projectile_address)			# Loads hitbox's Y position in a2
add a0,a0,%mov_speedX
add a1,a1,%mov_speedY
li a2,%width1			# Width of hitbox
li a3,%height1			# Height of hitbox
li s7,%type1
la t0,%hitbox2
lh a4,0(t0)			# Loads hitbox's X position in a1
lh a5,2(t0)			# Loads hitbox's Y position in a2
li a6,%width2			# Width of hitbox
li a7,%height2			# Height of hitbox
li s8,%type2

mv s10,ra			# Stores ra to s11
call DYNAMIC_COLISION_CHECK	# Checks dynamic colision
mv ra,s10			# Retrieves s11 to ra
.end_macro
#########################################################
#			KEY CHECK			#
#	Checks if %key key is being pressed, going	#
#	 to a %label label to process an input		#
#########################################################
.macro check_key(%key,%label,%input,%label2)
li t1,%key
bne t1,%input,%label2
j  %label
%label2 :
.end_macro

#################################################
#	   	   SET WARP			#
# 	Sets a level section for warping 	#
#################################################

.macro set_warp(%pos_address,%level_section)
la t0,%pos_address	# Loads position address
li t1, %level_section	# Loads level section
sh t1,4(t0)		# Stores warp section
.end_macro

#################################################
#	   	 SET POSITION			#
# 	 Sets a position for a sprite 		#
#################################################

.macro set_position(%pos_address,%x,%y)
la t0,%pos_address	# Loads position address
li t1, %x 		# Player X
li t2, %y 		# Player Y
sh t1,0(t0)		# Stores player X
sh t2,2(t0)		# Stores player Y
.end_macro

# stores old x y position already
.macro set_position_mov(%pos_address,%x,%y)
la t0,%pos_address	# Loads position address
li t1, %x 		# Player X
li t2, %y 		# Player Y
sh t1,0(t0)		# Stores player X
sh t1,4(t0)		# Stores player old X
sh t2,2(t0)		# Stores player Y
sh t2,6(t0)		# Stores player old Y
.end_macro



#################################################
#	    SET POSITION WITH HITBOX		#
#  Sets a position for a sprite and its hitbox  #
#################################################

.macro set_position_with_hitbox(%pos_address,%x,%y,%hitbox_address,%x_offset,%y_offset)
la t0,%pos_address	# Loads position address
li t1, %x 		# Player X
li t2, %y 		# Player Y
sh t1,0(t0)		# Stores player X
sh t2,2(t0)		# Stores player Y

la t3,%hitbox_address
addi t1,t1,%x_offset
addi t2,t2,%y_offset
sh t1,0(t3)
sh t2,2(t3)
.end_macro

# stores old x y position already
.macro set_position_with_hitbox_mov(%pos_address,%x,%y,%hitbox_address,%x_offset,%y_offset)
la t0,%pos_address	# Loads position address
li t1, %x 		# Player X
li t2, %y 		# Player Y
sh t1,0(t0)		# Stores player X
sh t1,4(t0)		# Stores player old X
sh t2,2(t0)		# Stores player Y
sh t2,6(t0)		# Stores player old Y

la t3,%hitbox_address
addi t1,t1,%x_offset
addi t2,t2,%y_offset
sh t1,0(t3)
sh t2,2(t3)
.end_macro


#########################################################
#		 INCREMENT POSITION 			#
#	Increments desired position by an amount	#
#     stores old position in characters' position	#
#########################################################

.macro increment_position_x(%amount, %pos_address,%hitbox_address)
#saving old position
la t0,%pos_address
lw t2,0(t0)
sw t2,4(t0)
#incrementing x coordinate:
la t0,%pos_address
lh t1,0(t0)			# loads x coordinate from pos_address
mv t2,%amount
add t1,t1,t2		# increments ammount to coordinate
sh t1,0(t0)			# stores new x coordinate in pos_address
# Incrementing Hitbox
la t0,%hitbox_address
addi t1,t1,4
sh t1,0(t0)

.end_macro

.macro increment_position_y(%amount, %pos_address,%hitbox_address)
#saving old position
la t0,%pos_address
lw t2,0(t0)
sw t2,4(t0)
#incrementing y coordinate:
la t0,%pos_address
lh t1,2(t0)			# loads y coordinate from pos_address
mv t2,%amount
add t1,t1,t2		# increments ammount to coordinate
sh t1,2(t0)			# stores new y coordinate in pos_address
# Incrementing Hitbox
la t0,%hitbox_address
addi t1,t1,4
sh t1,2(t0)
.end_macro

#################################################################
#		    SPRITE STATUS UPDATE 			#
#	Updates sprite status for animation purposes		#
#    if %reset = 1, the status will be reset to 1 (middle)	#
#	%top_value represents when it should descend		#
#################################################################

.macro sprite_status_update(%status_address, %reset,%top_value)
la a0,%status_address
li a1,%reset
li a2,%top_value

mv s9,ra
call SPRITE_STATUS_UPDATE
mv ra,s9
.end_macro

#################################################
#	    	  SHOW FRAME			#
#	Shows desired frame (%frame_num)	#
#################################################

.macro show_frame(%frame_num)
li t0,0xFF200604	# Loads address responsible for frame switches
sw %frame_num,0(t0)	# Stores desired frame number

.end_macro

#########################################
#	        PRINT INT		#
#     Prints an int on the screen	#
#########################################

.macro print_int(%int,%x,%y,%color,%frame)
mv a0, %int	# loads integer in a0
mv a1, %x	# loads column in a1
li a2, %y	# loads line in a2
li a3, %color	# loads color in a3
mv a4, %frame	# loads frame in a4
li a7,101
ecall
.end_macro

#################################
#	    COUNT DIGIT		#
#	calls NUMBER_SIZE	#
#################################

.macro count_digit()
mv s11,ra
call NUMBERSIZE
mv ra,s11
.end_macro

#########################################
#	    SWITCH FRAME VALUE		#
#	   Inverts frame value		#
#########################################

.macro switch_frame_value()
xori s0,s0,1		# Inverts frame value
.end_macro

#########################################
#		  PLAY			#
#    Plays soundtrack/sound effect	#
#########################################

.macro play(%array_label)
la s1,%array_label

mv s11,ra
call PLAY_MUSIC
mv ra,s11
.end_macro

#################################################################
#	    		RESET SOUNDTRACK			#
#	Resets given soundtrack label, so that it can play	#
#		    a note from the begining			#
#################################################################

.macro reset_soundtrack(%soundtrack_label)
la s1,%soundtrack_label
	
mv s11,ra
call RESET_SOUNDTRACK
mv ra,s11
.end_macro

#########################################
#	       MOVE ENEMY		#
#	     Moves an enemy		#
#########################################

.macro move_enemy(%enemy_label,%process_label)
la s1,%enemy_label
la s2,%process_label
mv s11,ra
call MOVE_ENEMY
mv ra,s11
.end_macro

#########################################
#	       ENEMY ATTACK		#
#	  Makes an enemy attack		#
#########################################

.macro enemy_attack(%enemy_label,%process_label)
la s1,%enemy_label
la s2,%process_label
mv s9,ra
call SUMMON_ATTACK_ENEMY
mv ra,s9
.end_macro

#########################################################
#		    SET ENEMY HEALTH			#
#	sets enemy health and allows it to spawn	#
#########################################################

.macro set_enemy(%enemy_label,%should_render,%enemy_health,%mov_atk_delay,%sprite_type,%process_label)
la t0,%enemy_label
li t1,%should_render
sh t1,4(t0)
li t1,%enemy_health
sh t1,6(t0)
li t1,%mov_atk_delay
sh t1,10(t0)
li t1,%sprite_type
sh t1,18(t0)
# Reseting process counter
la t0,%process_label
li t1,0
sh t1,2(t0)
sh t1,4(t0)
sh t1,6(t0)
.end_macro

#########################################
#	       RENDER ENEMY		#
#	     Renders an enemy		#
#########################################

.macro render_enemy(%enemy_label)
la s1,%enemy_label
 
mv s9,ra
call RENDER_ENEMY
mv ra,s9
.end_macro

#################################################################
#		 DYNAMIC COLISION CHECK ENEMY			#
#     Checks for colisions from movable objects, contained	#
#       	More info in colisionlabels.s			#
#################################################################
.macro dynamic_colision_check_enemy(%hitbox1,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2,%enemy_label)
la t0,%hitbox1			# Player hitbox
lh a0,0(t0)			# Loads hitbox's X position in a1
lh a1,2(t0)			# Loads hitbox's Y position in a2
add a0,a0,%mov_speedX
add a1,a1,%mov_speedY
li a2,%width1			# Width of hitbox
li a3,%height1			# Height of hitbox
li s7,%type1
la t0,%hitbox2
lh a4,0(t0)			# Loads hitbox's X position in a1
lh a5,2(t0)			# Loads hitbox's Y position in a2
li a6,%width2			# Width of hitbox
li a7,%height2			# Height of hitbox
li s8,%type2

la s6,%enemy_label		# Loads enemy label

mv s10,ra			# Stores ra to s11
call DYNAMIC_COLISION_CHECK	# Checks dynamic colision
mv ra,s10			# Retrieves s11 to ra
.end_macro

.macro projectile_dynamic_colision_check_enemy(%projectile_address,%type1,%width1,%height1,%mov_speedX,%mov_speedY,%hitbox2,%type2,%width2,%height2,%enemy_label)
lh a0,0(%projectile_address)			# Loads hitbox's X position in a1
lh a1,2(%projectile_address)			# Loads hitbox's Y position in a2
add a0,a0,%mov_speedX
add a1,a1,%mov_speedY
li a2,%width1			# Width of hitbox
li a3,%height1			# Height of hitbox
li s7,%type1
la t0,%hitbox2
lh a4,0(t0)			# Loads hitbox's X position in a1
lh a5,2(t0)			# Loads hitbox's Y position in a2
li a6,%width2			# Width of hitbox
li a7,%height2			# Height of hitbox
li s8,%type2

la s6,%enemy_label		# Loads enemy label

mv s10,ra			# Stores ra to s11
call DYNAMIC_COLISION_CHECK	# Checks dynamic colision
mv ra,s10			# Retrieves s11 to ra
.end_macro

#########################################
#	   	 PAUSE			#
#	Pauses for %ms milisseconds	#
#	    eases debugging		#
#########################################

.macro pause(%ms)
li a7, 32
li a0, %ms
ecall	
.end_macro

