# ----> Summary: gameenemies.s is the brain for enemy actions in this game :)
# .data includes:
#	1 - Enemy Labels
# 	2 - Enemy Patterns
# .text includes
#	1 - UPDATE ENEMIES (calls for moving enemies or making them attack
#	2 - MOVE ENEMIES (moves enemies according to their pattern and updates their sprites)
#	3 - SUMMON ATTACK ENEMY ( for enemies that don't move: summons a new attack)

.data
#	ENEMY LABELS
# ENEMY_N:
# (0) ENEMY_timer_N: .word 0 --> stores time when an action started
# (4) ENEMY_Info_N: .half a,b,c,d 
#  +--> stores: (4) a: Whether sprite should be rendered or not (0 no, 1 yes)
#		(6) b: Entity health
#		(8) c: Entity type (0 = walks, but dies on contact; 2 = stays still, but fires)
#		(10) d: Mov/Atk delay (time (ms) for another movement/attack) 
#
# (12) ENEMY_Status_N: .half 1,0,0,0
#  +--> stores: (12) a: Entity sprite status (number of sprite)
#		(14) b: Entity sprite info (0 if ascending sprite status, 1 if descending sprite status)
#		(16) c: Direction facing (0 = down, 1 = up, 2 = right, 3 = left)
#		(18) d: Sprite type (enemies use different sprites depending on levels)
#
# (20 - 28) ENEMY_Pos_N: .half 0,0,0,0 --> Stores entity's position (top left x,y) and old position (top left x,y)

Slime_0:
Slime_timer_0: .word 0
Slime_Info_0: .half 1,0,0,0 # Stores whether sprite should be rendered or not (0 no, 1 yes) | Entity health | Entity type | Mov/Atk delay
Slime_Status_0: .half 1,0,0,0 # Stores entity status (sprite number | sprite info (0 if ascending, 1 if descending) | direction facing (0 = down, 1 = up, 2 = right, 3 = left) | sprite type (enemies use different sprites depending on levels)
Slime_Pos_0: .half 0,0,0,0 # Stores entity's position (top left x,y) and old position (top left x,y)

Slime_1:
Slime_timer_1: .word 0
Slime_Info_1: .half 1,0,0,0 # Stores whether sprite should be rendered or not (0 no, 1 yes) | Entity health | Entity type | Mov/Atk delay
Slime_Status_1: .half 1,0,0,0 # Stores entity status (sprite number | sprite info (0 if ascending, 1 if descending) | direction facing (0 = down, 1 = up, 2 = right, 3 = left) | sprite type (enemies use different sprites depending on levels)
Slime_Pos_1: .half 0,0,0,0 # Stores entity's position (top left x,y) and old position (top left x,y)

Slime_2:
Slime_timer_2: .word 0
Slime_Info_2: .half 1,0,0,0 # Stores whether sprite should be rendered or not (0 no, 1 yes) | Entity health | Entity type | Mov/Atk delay
Slime_Status_2: .half 1,0,0,0 # Stores entity status (sprite number | sprite info (0 if ascending, 1 if descending) | direction facing (0 = down, 1 = up, 2 = right, 3 = left) | sprite type (enemies use different sprites depending on levels)
Slime_Pos_2: .half 0,0,0,0 # Stores entity's position (top left x,y) and old position (top left x,y)

Slime_3:
Slime_timer_3: .word 0
Slime_Info_3: .half 1,0,0,0 # Stores whether sprite should be rendered or not (0 no, 1 yes) | Entity health | Entity type | Mov/Atk delay
Slime_Status_3: .half 1,0,0,0 # Stores entity status (sprite number | sprite info (0 if ascending, 1 if descending) | direction facing (0 = down, 1 = up, 2 = right, 3 = left) | sprite type (enemies use different sprites depending on levels)
Slime_Pos_3: .half 0,0,0,0 # Stores entity's position (top left x,y) and old position (top left x,y)



ULA_0:
ULA_timer_0: .word 0
ULA_Info_0: .half 1,0,2,0 # Stores whether sprite should be rendered or not (0 no, 1 yes) | Entity health | Entity type | Mov/Atk delay
ULA_Status_0: .half 1,0,0,0 # Stores entity status (sprite number | sprite info (0 if ascending, 1 if descending) | direction facing (0 = down, 1 = up, 2 = right, 3 = left) | sprite type (enemies use different sprites depending on levels)
ULA_Pos_0: .half 0,0,0,0 # Stores entity's position (top left x,y) and old position (top left x,y)

ULA_1:
ULA_timer_1: .word 0
ULA_Info_1: .half 1,0,2,0 # Stores whether sprite should be rendered or not (0 no, 1 yes) | Entity health | Entity type | Mov/Atk delay
ULA_Status_1: .half 1,0,0,0 # Stores entity status (sprite number | sprite info (0 if ascending, 1 if descending) | direction facing (0 = down, 1 = up, 2 = right, 3 = left) | sprite type (enemies use different sprites depending on levels)
ULA_Pos_1: .half 0,0,0,0 # Stores entity's position (top left x,y) and old position (top left x,y)

ULA_2:
ULA_timer_2: .word 0
ULA_Info_2: .half 1,0,2,0 # Stores whether sprite should be rendered or not (0 no, 1 yes) | Entity health | Entity type | Mov/Atk delay
ULA_Status_2: .half 1,0,0,0 # Stores entity status (sprite number | sprite info (0 if ascending, 1 if descending) | direction facing (0 = down, 1 = up, 2 = right, 3 = left) | sprite type (enemies use different sprites depending on levels)
ULA_Pos_2: .half 0,0,0,0 # Stores entity's position (top left x,y) and old position (top left x,y)

ULA_3:
ULA_timer_3: .word 0
ULA_Info_3: .half 1,0,2,0 # Stores whether sprite should be rendered or not (0 no, 1 yes) | Entity health | Entity type | Mov/Atk delay
ULA_Status_3: .half 1,0,0,0 # Stores entity status (sprite number | sprite info (0 if ascending, 1 if descending) | direction facing (0 = down, 1 = up, 2 = right, 3 = left) | sprite type (enemies use different sprites depending on levels)
ULA_Pos_3: .half 0,0,0,0 # Stores entity's position (top left x,y) and old position (top left x,y)




#	ENEMY PATTERN
# ENEMY_Process_N: .half a,b,c,d
#  +--> stores: a: Total number of patterns to be run through
#		b: Number of patterns already run (is reset every loop)
#		c: Will store the number of times a pattern has been repeated
#		d: Probably will stay empty. Space used so that patterns stay in the same row
#
# ENEMY_Pattern_N: .half a,b,c,d,...
#  +--> stores: a: Mov speed X ( + for right; - for left) | Direction of attack
#		b: Number of repetitions
#		c: Mov speed Y ( + for down; - for up)| Direction of attack
#		d: Number of repetitions
# afterwards, e and f will be for mov speed X and repetitions, g and h for mov speed Y and repetitions, so on and so forth

# Patterns for 1.1
Slime_Process_1.1.0: .half 4,0,0,0
Slime_Pattern_1.1.0: .half -4,16,4,16,4,16,-4,16	# Stores in order X movement, number of times, Y movement, number of times ....

Slime_Process_1.1.1: .half 4,0,0,0
Slime_Pattern_1.1.1: .half 4,16,4,20,-4,16,-4,20	# Stores in order X movement, number of times, Y movement, number of times ....

Slime_Process_1.2.0: .half 4,0,0,0
Slime_Pattern_1.2.0: .half -4,16,-4,16,4,16,4,16	# Stores in order X movement, number of times, Y movement, number of times ....

Slime_Process_1.2.1: .half 4,0,0,0
Slime_Pattern_1.2.1: .half -4,16,4,16,4,16,-4,16	# Stores in order X movement, number of times, Y movement, number of times ....

Slime_Process_1.2.2: .half 4,0,0,0
Slime_Pattern_1.2.2: .half 4,20,-4,12,-4,20,4,12	# Stores in order X movement, number of times, Y movement, number of times ....

Slime_Process_1.2.3: .half 12,0,0,0
Slime_Pattern_1.2.3: .half 4,8,4,8,-4,8,4,8,4,8,4,8,-4,8,-4,8,4,8,-4,8,-4,8,-4,8	# Stores in order X movement, number of times, Y movement, number of times ....

Slime_Process_2.1.0 : .half 4,0,0,0
Slime_Pattern_2.1.0: .half 4,1,4,24,-4,1,-4,24	# Stores in order X movement, number of times, Y movement, number of times ....

Slime_Process_2.1.1: .half 4,0,0,0
Slime_Pattern_2.1.1: .half 4,32,4,1,-4,32,-4,1	# Stores in order X movement, number of times, Y movement, number of times ....

Slime_Process_2.1.2: .half 4,0,0,0
Slime_Pattern_2.1.2: .half 4,1,4,32,-4,1,-4,32	# Stores in order X movement, number of times, Y movement, number of times ....

Slime_Process_2.1.3: .half 4,0,0,0
Slime_Pattern_2.1.3: .half -4,1,4,20,4,1,-4,20	# Stores in order X movement, number of times, Y movement, number of times ....

Slime_Process_2.2.0 : .half 4,0,0,0
Slime_Pattern_2.2.0: .half 4,8,4,28,-4,8,-4,28	# Stores in order X movement, number of times, Y movement, number of times ....

ULA_Process_2.2.0: .half 1,0,0,0
ULA_Pattern_2.2.0: .half 2,1	# Stores in order attack direction, number of times,  attack direction, number of times ....

ULA_Process_2.2.1: .half 1,0,0,0
ULA_Pattern_2.2.1: .half 2,1	# Stores in order attack direction, number of times,  attack direction, number of times ....

ULA_Process_2.2.2: .half 1,0,0,0
ULA_Pattern_2.2.2: .half 2,1	# Stores in order attack direction, number of times,  attack direction, number of times ....

Slime_Process_2.3.0: .half 4,0,0,0
Slime_Pattern_2.3.0: .half -4,20,4,12,4,20,-4,12	# Stores in order X movement, number of times, Y movement, number of times ....

Slime_Process_2.3.1 : .half 4,0,0,0
Slime_Pattern_2.3.1: .half -4,24,4,1,4,24,-4,1	# Stores in order X movement, number of times, Y movement, number of times ....

Slime_Process_2.3.2 : .half 4,0,0,0
Slime_Pattern_2.3.2: .half -4,1,4,12,4,1,-4,12	# Stores in order X movement, number of times, Y movement, number of times ....

ULA_Process_2.3.0: .half 1,0,0,0
ULA_Pattern_2.3.0: .half 2,1	# Stores in order attack direction, number of times,  attack direction, number of times ....

ULA_Process_2.3.1: .half 1,0,0,0
ULA_Pattern_2.3.1: .half 2,1	# Stores in order attack direction, number of times,  attack direction, number of times ....

ULA_Process_2.3.2: .half 1,0,0,0
ULA_Pattern_2.3.2: .half 1,1	# Stores in order attack direction, number of times,  attack direction, number of times ....

ULA_Process_2.3.3: .half 1,0,0,0
ULA_Pattern_2.3.3: .half 1,1	# Stores in order attack direction, number of times,  attack direction, number of times ....


ULA_Process_3.1.0: .half 4,0,0,0
ULA_Pattern_3.1.0: .half 0,1,2,1,1,1,3,1	# Stores in order attack direction, number of times,  attack direction, number of times ....

ULA_Process_3.1.1: .half 4,0,0,0
ULA_Pattern_3.1.1: .half 0,1,2,1,1,1,3,1	# Stores in order attack direction, number of times,  attack direction, number of times ....


ULA_Process_3.2.0: .half 1,0,0,0
ULA_Pattern_3.2.0: .half 0,1	# Stores in order attack direction, number of times,  attack direction, number of times ....

ULA_Process_3.2.1: .half 1,0,0,0
ULA_Pattern_3.2.1: .half 0,1	# Stores in order attack direction, number of times,  attack direction, number of times ....

ULA_Process_3.2.2: .half 1,0,0,0
ULA_Pattern_3.2.2: .half 3,1	# Stores in order attack direction, number of times,  attack direction, number of times ....

ULA_Process_3.3.0: .half 2,0,0,0
ULA_Pattern_3.3.0: .half 0,1,2,1	# Stores in order attack direction, number of times,  attack direction, number of times ....

ULA_Process_3.3.1: .half 1,0,0,0
ULA_Pattern_3.3.1: .half 3,1	# Stores in order attack direction, number of times,  attack direction, number of times ....

ULA_Process_3.3.2: .half 1,0,0,0
ULA_Pattern_3.3.2: .half 1,1	# Stores in order attack direction, number of times,  attack direction, number of times ....

Slime_Process_3.4.0: .half 4,0,0,0
Slime_Pattern_3.4.0: .half 4,8,4,16,-4,8,-4,16	# Stores in order X movement, number of times, Y movement, number of times ....

Slime_Process_3.4.1 : .half 4,0,0,0
Slime_Pattern_3.4.1: .half 4,20,-4,8,-4,20,4,8	# Stores in order X movement, number of times, Y movement, number of times ....

ULA_Process_3.4.0: .half 1,0,0,0
ULA_Pattern_3.4.0: .half 0,1	# Stores in order attack direction, number of times,  attack direction, number of times ....

ULA_Process_3.4.1: .half 2,0,0,0
ULA_Pattern_3.4.1: .half 0,1,3,1	# Stores in order attack direction, number of times,  attack direction, number of times ....

ULA_Process_3.4.2: .half 2,0,0,0
ULA_Pattern_3.4.2: .half 2,1,1,1	# Stores in order attack direction, number of times,  attack direction, number of times ....


.eqv ula_2_attack_time 50
.eqv ula_3_attack_time 20
.eqv max_enmy_projectile 12	# Max number of enemy projectiles
ULA_MAGIC_ARRAY:
ULA_Magic_Pos1: .half 0,0,0,0 # Stores magic 1 position (top left x,y) and old position (top left x,y)
ULA_Magic_Status1: .half 0,0,0,0 # Stores magic 1 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)
ULA_Magic_Pos2: .half 0,0,0,0 # Stores magic 2 position (top left x,y) and old position (top left x,y)
ULA_Magic_Status2: .half 0,0,0,0 # Stores magic 2 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)
ULA_Magic_Pos3: .half 0,0,0,0 # Stores magic 3 position (top left x,y) and old position (top left x,y)
ULA_Magic_Status3: .half 0,0,0,0 # Stores magic 3 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)
ULA_Magic_Pos4: .half 0,0,0,0 # Stores magic 4 position (top left x,y) and old position (top left x,y)
ULA_Magic_Status4: .half 0,0,0,0 # Stores magic 4 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)

ULA_Magic_Pos5: .half 0,0,0,0 # Stores magic 1 position (top left x,y) and old position (top left x,y)
ULA_Magic_Status5: .half 0,0,0,0 # Stores magic 1 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)
ULA_Magic_Pos6: .half 0,0,0,0 # Stores magic 2 position (top left x,y) and old position (top left x,y)
ULA_Magic_Status6: .half 0,0,0,0 # Stores magic 2 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)
ULA_Magic_Pos7: .half 0,0,0,0 # Stores magic 3 position (top left x,y) and old position (top left x,y)
ULA_Magic_Status7: .half 0,0,0,0 # Stores magic 3 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)
ULA_Magic_Pos8: .half 0,0,0,0 # Stores magic 4 position (top left x,y) and old position (top left x,y)
ULA_Magic_Status8: .half 0,0,0,0 # Stores magic 4 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)

ULA_Magic_Pos9: .half 0,0,0,0 # Stores magic 1 position (top left x,y) and old position (top left x,y)
ULA_Magic_Status9: .half 0,0,0,0 # Stores magic 1 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)
ULA_Magic_Pos10: .half 0,0,0,0 # Stores magic 2 position (top left x,y) and old position (top left x,y)
ULA_Magic_Status10: .half 0,0,0,0 # Stores magic 2 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)
ULA_Magic_Pos11: .half 0,0,0,0 # Stores magic 3 position (top left x,y) and old position (top left x,y)
ULA_Magic_Status11: .half 0,0,0,0 # Stores magic 3 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)
ULA_Magic_Pos12: .half 0,0,0,0 # Stores magic 4 position (top left x,y) and old position (top left x,y)
ULA_Magic_Status12: .half 0,0,0,0 # Stores magic 4 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)



.text
###########      UPDATE ENEMIES       #############
#						  #
#        Calls labels that move enemies		  #
#              or make them attack		  #
#						  #
###################################################	

UPDATE_ENEMIES:
	la t0, LEVEL_INFO			# Loads LEVEL_INFO address
	lh t0,0(t0)				# Checks what level player is at
	li t1,1					# and if it equals to 1 (Level 1)
	bne t1,t0,SKIP_UPDATE_LEVEL1_ENEMIES		# it'll go to to the first level setup
	j UPDATE_LEVEL1_ENEMIES	
	SKIP_UPDATE_LEVEL1_ENEMIES:	 
	li t1,2					# otherwise if it equals to 2 (Level 2)
	bne t1,t0,SKIP_UPDATE_LEVEL2_ENEMIES			# it'll go to to the first level setup 
	j UPDATE_LEVEL2_ENEMIES	
	SKIP_UPDATE_LEVEL2_ENEMIES:
	li t1,3					# otherwise if it equals to 3 (Level 3)
	bne t1,t0,SKIP_UPDATE_LEVEL3_ENEMIES			# it'll go to to the first level setup 
	j UPDATE_LEVEL3_ENEMIES	
	SKIP_UPDATE_LEVEL3_ENEMIES:
	ret
	UPDATE_LEVEL1_ENEMIES:
		la t0, LEVEL_INFO			# Loads LEVEL_INFO address
		lh t0,2(t0)				# Checks what section of the level it is at
		li t1,1					# otherwise, if it equals to 1 (Level 1.1),
		bne t1,t0,SKIP_UPDATE_LEVEL1.1_ENEMIES		# it'll go to to the first level 1 section setup 
		j UPDATE_LEVEL1.1_ENEMIES
		SKIP_UPDATE_LEVEL1.1_ENEMIES:
		li t1,2					# otherwise, if it equals to 2 (Level 1.2)
		bne t1,t0,SKIP_UPDATE_LEVEL1.2_ENEMIES		# it'll go to to the second level 1 section setup 
		j UPDATE_LEVEL1.2_ENEMIES
		SKIP_UPDATE_LEVEL1.2_ENEMIES:
		ret
		UPDATE_LEVEL1.1_ENEMIES:
			move_enemy(Slime_0,Slime_Process_1.1.0)
			move_enemy(Slime_1,Slime_Process_1.1.1)
			ret
		UPDATE_LEVEL1.2_ENEMIES:
			move_enemy(Slime_0,Slime_Process_1.2.0)
			move_enemy(Slime_1,Slime_Process_1.2.1)
			move_enemy(Slime_2,Slime_Process_1.2.2)
			move_enemy(Slime_3,Slime_Process_1.2.3)
			ret
	UPDATE_LEVEL2_ENEMIES:
		la t0, LEVEL_INFO			# Loads LEVEL_INFO address
		lh t0,2(t0)				# Checks what section of the level it is at
		li t1,1					# otherwise, if it equals to 1 (Level 2.1),
		bne t1,t0,SKIP_UPDATE_LEVEL2.1_ENEMIES		# it'll go to to the first level 2 section setup 
		j UPDATE_LEVEL2.1_ENEMIES
		SKIP_UPDATE_LEVEL2.1_ENEMIES:
		li t1,2					# otherwise, if it equals to 2 (Level 2.2)
		bne t1,t0,SKIP_UPDATE_LEVEL2.2_ENEMIES		# it'll go to to the second level 2 section setup 
		j UPDATE_LEVEL2.2_ENEMIES
		SKIP_UPDATE_LEVEL2.2_ENEMIES:
		li t1,3					# otherwise, if it equals to 3 (Level 2.3)
		bne t1,t0,SKIP_UPDATE_LEVEL2.3_ENEMIES		# it'll go to to the third level 2 section setup 
		j UPDATE_LEVEL2.3_ENEMIES
		SKIP_UPDATE_LEVEL2.3_ENEMIES:
		ret
		UPDATE_LEVEL2.1_ENEMIES:
			move_enemy(Slime_0,Slime_Process_2.1.0)
			move_enemy(Slime_1,Slime_Process_2.1.1)
			move_enemy(Slime_2,Slime_Process_2.1.2)
			move_enemy(Slime_3,Slime_Process_2.1.3)
			ret
		UPDATE_LEVEL2.2_ENEMIES:
			move_enemy(Slime_0,Slime_Process_2.2.0)
			enemy_attack(ULA_0,ULA_Process_2.2.0)
			enemy_attack(ULA_1,ULA_Process_2.2.1)
			enemy_attack(ULA_2,ULA_Process_2.2.2)
			ret
		UPDATE_LEVEL2.3_ENEMIES:
			move_enemy(Slime_0,Slime_Process_2.3.0)
			move_enemy(Slime_2,Slime_Process_2.3.2)
			enemy_attack(ULA_0,ULA_Process_2.3.0)
			enemy_attack(ULA_1,ULA_Process_2.3.1)
			enemy_attack(ULA_2,ULA_Process_2.3.2)
			enemy_attack(ULA_3,ULA_Process_2.3.3)
			ret
	UPDATE_LEVEL3_ENEMIES:
		la t0, LEVEL_INFO			# Loads LEVEL_INFO address
		lh t0,2(t0)				# Checks what section of the level it is at
		li t1,1					# otherwise, if it equals to 1 (Level 3.1),
		bne t1,t0,SKIP_UPDATE_LEVEL3.1_ENEMIES	# it'll go to to the first level 2 section setup 
		j UPDATE_LEVEL3.1_ENEMIES
		SKIP_UPDATE_LEVEL3.1_ENEMIES:
		li t1,2					# otherwise, if it equals to 2 (Level 3.2)
		bne t1,t0,SKIP_UPDATE_LEVEL3.2_ENEMIES	# it'll go to to the second level 2 section setup 
		j UPDATE_LEVEL3.2_ENEMIES
		SKIP_UPDATE_LEVEL3.2_ENEMIES:
		li t1,3					# otherwise, if it equals to 3 (Level 3.3)
		bne t1,t0,SKIP_UPDATE_LEVEL3.3_ENEMIES	# it'll go to to the third level 2 section setup 
		j UPDATE_LEVEL3.3_ENEMIES
		SKIP_UPDATE_LEVEL3.3_ENEMIES:
		li t1,4					# otherwise, if it equals to 4 (Level 3.4)
		bne t1,t0,SKIP_UPDATE_LEVEL3.4_ENEMIES	# it'll go to to the fourht level 4 section setup 
		j UPDATE_LEVEL3.4_ENEMIES
		SKIP_UPDATE_LEVEL3.4_ENEMIES:
		ret
		UPDATE_LEVEL3.1_ENEMIES:
			enemy_attack(ULA_0,ULA_Process_3.1.0)
			enemy_attack(ULA_1,ULA_Process_3.1.1)
			ret
		UPDATE_LEVEL3.2_ENEMIES:
			enemy_attack(ULA_0,ULA_Process_3.2.0)
			enemy_attack(ULA_1,ULA_Process_3.2.1)
			enemy_attack(ULA_2,ULA_Process_3.2.2)
			ret
		UPDATE_LEVEL3.3_ENEMIES:
			enemy_attack(ULA_0,ULA_Process_3.3.0)
			enemy_attack(ULA_1,ULA_Process_3.3.1)
			ret
		UPDATE_LEVEL3.4_ENEMIES:
			move_enemy(Slime_0,Slime_Process_3.4.0)
			move_enemy(Slime_1,Slime_Process_3.4.1)
			
			enemy_attack(ULA_0,ULA_Process_3.4.0)
			enemy_attack(ULA_1,ULA_Process_3.4.1)
			enemy_attack(ULA_2,ULA_Process_3.4.2)
			ret


#################       MOVE ENEMY      #################
#							#
#         Moves enemy based on its pattern label	#
#							#
#   -------------    registers used	-------------   #
#	s1 is the address of entity label		#
#	s2 is the address for entity pattern		#
# 	s3 has the address for a specific pattern	#
#							#
#########################################################	
MOVE_ENEMY:
	lh t0,4(s1)	 # Loads whether entity should be processed
	bnez t0,CONTINUE_MOVE_ENEMY
	j END_MOVE_ENEMY
	CONTINUE_MOVE_ENEMY:
		lh t0,6(s1)	 # Loads entity should be rendered
		beqz t0,END_MOVE_ENEMY	# if it is 0 (don't proceed)
		# Seeing if position should be updated
		lw t0,0(s1)	# Gets time enemy started moving
		beqz t0,START_MOVE_ENEMY
		
		li a7,30	# Gets new time
		ecall
		sub t0,a0,t0	# t0 = new time - starting time
		
		lh t1,10(s1)	# Gets movement delay
		bge t0,t1,START_MOVE_ENEMY	# and if the difference is greater or equal to the movement delay, proceed
		j END_MOVE_ENEMY
		
		START_MOVE_ENEMY:
			li a7,30	# Gets new time
			ecall
			sw a0,0(s1)	# and stores new time enemy started moving
		
			lh t1,2(s2)
			slli t2,t1,2
			add s3,s2,t2 # s3 will access specific process
			# if index is even, update x, otherwise, update y
			li t0,2
			rem t0,t1,t0
			bnez t0,UPDATE_ENEMY_Y
			UPDATE_ENEMY_X:
				lh t0,22(s1)	# Loads enemy y
				sh t0,26(s1)	# Stores enemy old y
				
				lh t0,20(s1)	# Loads enemy x
				sh t0,24(s1)	# Stores enemy old x
				lh t1,8(s3)	# Loads mov speed
				add t0,t0,t1	# Increments x position
				sh t0,20(s1)
				bltz t1,X_LEFT
				X_RIGHT:	# Enemy is moving right
					li t0,2		# facing right
					sh t0,16(s1)	# stores in status
					j CHECK_ENEMY_STATUS_INDEX
				X_LEFT:		# Enemy is moving left	
					li t0,3		# facing left
					sh t0,16(s1)	# stores in status
					j CHECK_ENEMY_STATUS_INDEX
			UPDATE_ENEMY_Y:
				lh t0,20(s1)	# Loads enemy x
				sh t0,24(s1)	# Stores enemy old x
				
				lh t0,22(s1)	# Loads enemy y
				sh t0,26(s1)	# Stores enemy old y
				lh t1,8(s3)	# Loads mov speed
				add t0,t0,t1	# Increments x position
				sh t0,22(s1)
				bltz t1,Y_UP
				Y_DOWN:		# Enemy is moving down
					li t0,0		# facing down
					sh t0,16(s1)	# stores in status
					j CHECK_ENEMY_STATUS_INDEX
				Y_UP:		# Enemy is moving up	
					li t0,1		# facing up
					sh t0,16(s1)	# stores in status
					j CHECK_ENEMY_STATUS_INDEX
			
			CHECK_ENEMY_STATUS_INDEX:
				sh t1,6(s2) # Stores movement in status
				
				lh t0,4(s2)	# Loads process counter 
				addi t0,t0,1	# and adds 1 to it
				sh t0,4(s2)	# and stores it in the counter
				lh t1,10(s3)	# Loads the number of times this process has to be repeated
				bne t1,t0,UPDATE_ENEMY_SPRITE_STATUS	# and if the number of times has been reached, continue, otherwise, skip next section
					# Reseting counter and updating index to the next one
					li t0,0		# Loads 0 to t0
					sh t0,4(s2)	# and stores it in the counter
					# checking if number of total processes has been reached
					lh t1,2(s2)			# Loads process index
					addi t1,t1,1			# and adds 1 to it
					sh t1,2(s2)			# and stores it in the process index
					lh t0,0(s2)			# Loads number of processes
					blt t1,t0,UPDATE_ENEMY_SPRITE_STATUS	# and while t1 < t0, the whole process won't be reset
						# otherwise, will reset the index so that the whole process can start over
						li t1,0		# Loads 0 to t1
						sh t1,2(s2)	# and store it in the index 
				  
			UPDATE_ENEMY_SPRITE_STATUS:
				# Checks if enemy is moving or not
				lh t1,6(s2) # Loads movement from status
				beqz t1, RESET_ENEMY_SPRITE_STATUS	# and if enemy is not moving, reset it's status
				# Otherwise, do normal procedure
					lh t1,12(s1)	# Loads Sprite Status 
					lh t2,14(s1)	# Loads Sprite Info (0 if ascending - ADDSTATUS, 1 if descending - LOWERSTATUS)
					beqz t2,ENEMY_SPRITE_ADD_STATUS
					ENEMY_SPRITE_LOWER_STATUS:
						addi t1,t1,-1
						sh t1,12(s1)
						j ENEMY_SPRITE_CHECK_STATUS
					ENEMY_SPRITE_ADD_STATUS:
						addi t1,t1,1
						sh t1,12(s1)
					ENEMY_SPRITE_CHECK_STATUS:
						beqz t1,ENEMY_SPRITE_UPDATE
						li t3,2
						beq t1,t3,ENEMY_SPRITE_UPDATE
						j END_MOVE_ENEMY
						ENEMY_SPRITE_UPDATE:
							xori t2,t2,1
							sh t2,14(s1)
							j END_MOVE_ENEMY
				RESET_ENEMY_SPRITE_STATUS:
					# Resets sprite status to 1 and sprite info to 0
					li t1,1
					sh t1,10(s1)
					sh zero,14(s1)
					j END_MOVE_ENEMY
					
	END_MOVE_ENEMY:
		ret


###############        SUMMON ATTACK ENEMY      #################
#								#
#          Once an enemy attacks, it'll summon a new attack	#
#			based on its pattern			#
#								#
#      -------------      registers used   	-------------   #
#	s1 is the address of entity label			#
#	s2 is the address for entity pattern			#
# 	s3 has the address for a specific pattern		#
#								#
#################################################################
SUMMON_ATTACK_ENEMY:
#pause(12000)
	lh t0,4(s1)	 # Loads whether entity should be processed
	bnez t0,CONTINUE_SUMMON_ATTACK_ENEMY
	j END_SUMMON_ATTACK_ENEMY
	CONTINUE_SUMMON_ATTACK_ENEMY:
		lh t0,6(s1)	 # Loads entity should be rendered
		beqz t0,END_SUMMON_ATTACK_ENEMY	# if it is 0 (don't proceed)
		# Seeing if enemy should attack
		lw t0,0(s1)	# Gets time enemy started attacking
		beqz t0,START_SUMMON_ATTACK_ENEMY
		
		li a7,30	# Gets new time
		ecall
		sub t0,a0,t0	# t0 = new time - starting time
		
		lh t1,10(s1)	# Gets attack delay
		bge t0,t1,START_SUMMON_ATTACK_ENEMY	# and if the difference is greater or equal to the attack delay, proceed
		j END_SUMMON_ATTACK_ENEMY
		
		START_SUMMON_ATTACK_ENEMY:
			li a7,30	# Gets new time
			ecall
			sw a0,0(s1)	# and stores new time enemy started attacking
		
			lh t1,2(s2)
			slli t2,t1,2
			add s3,s2,t2 # s3 will access specific process
			
			lh t0,10(s3)	# Loads the number of times this process has to be repeated
			beqz t0,AFTER_SUMMON_ATTACK_ENEMY # If it equals to zero, it means it won't try to summon attack
			
			la s4, ULA_MAGIC_ARRAY		# Loads ULA_MAGIC_ARRAY address to s4	
			li t1,0				# Counter for attack loop
			li t2,max_enmy_projectile	# Loads maximum number of enemy projectiles											
			SUMMON_NEW_ATTACK_ENEMY:	# Will see if player can summon a new magic ball		
				lh t0, 14(s4)		# Loads the number of times MagicN has been rendered (ULA_Magic_StatusN)
				beqz t0,SET_ENEMY_MAGIC_POSITION	# If 0, it means it is inactive, thus, can be rendered from a new position
			  	addi s4,s4,16		# otherwise, add 16 to s4 (skip to the next ULA_Magic)
			  	addi t1,t1,1		# and add 1 to counter
			  	blt t1,t2,SUMMON_NEW_ATTACK_ENEMY	# if counter < max enemy projectiles, continue checking
		  		
				# If it reaches this point, all magic has been fired, so it'll skip summoning
			 	j AFTER_SUMMON_ATTACK_ENEMY
		 	SET_ENEMY_MAGIC_POSITION:
		 		lh t0,8(s3)	# Loads direction for firing attack
		 		
		 		lh t2,20(s1)	# Loads enemy x
				lh t3,22(s1)	# Loads enemy y
		 		
		 		beqz t0,SET_ENEMY_MAGIC_FRONT	# If direction is down
				li t1,1
				beq t0,t1,SET_ENEMY_MAGIC_BACK # If direction is up
				li t1,2
				beq t0,t1,SET_ENEMY_MAGIC_RIGHT # If direction is right
				li t1,3
				beq t0,t1,SET_ENEMY_MAGIC_LEFT # If direction is left
		 		
		 		SET_ENEMY_MAGIC_FRONT:
		  			addi t2,t2,0	# Adds 0 pixel offset (in order to center it on enemy)
		  			addi t3,t3,16	# Adds 4 pixel offset (to look like it is leaving from enemy)
		  			li t0,240	# Screen height
		  			bge t3,t0,AFTER_SUMMON_ATTACK_ENEMY	# If Y >= 240, it's out of range, so it won't be rendered
		  			sh t2,0(s4)	# Will store X on of given Magic_Pos
		  			sh t3,2(s4)	# Will store Y on given Magic_Pos
		  			li t0,0		# Sets t0 to 0,
		  			sh t0,12(s4)	# storing in Magic_Status' direction (0 = Down)
					j AFTER_SUMMON_ATTACK_ENEMY
				
				SET_ENEMY_MAGIC_BACK:
		  			addi t2,t2,0	# Adds 0 pixel offset (in order to center it on enemy)
		  			addi t3,t3,-4	# Subtracts 4 pixel offset (to look like it is leaving from enemy)
		  			li t0,0		# Top of string
		  			blt t3,t0,AFTER_SUMMON_ATTACK_ENEMY	# If Y < 0, it's out of range, so it won't be rendered
		  			sh t2,0(s4)	# Will store X on of given Magic_Pos
		  			sh t3,2(s4)	# Will store Y on given Magic_Pos
		  			li t0,1		# Sets t0 to 1,
		  			sh t0,12(s4)	# storing in Magic_Status' direction (1 = Up)
					j AFTER_SUMMON_ATTACK_ENEMY
					
					
				SET_ENEMY_MAGIC_RIGHT:
		  			addi t2,t2,16	# Adds 16 pixel offset (to look like it is leaving from player)
		  			addi t3,t3,0	# Adds 0 pixel offset (in order to center it on player)
		  			li t0,272	# Screen width (whithout UI)
		  			bge t2,t0,AFTER_SUMMON_ATTACK_ENEMY	# If Y > 272, it's out of range, so it won't be rendered
		  			sh t2,0(s4)	# Will store X on of given Magic_Pos
		  			sh t3,2(s4)	# Will store Y on given Magic_Pos
		  			li t0,2		# Sets t0 to 2,
		  			sh t0,12(s4)	# storing in Magic_Status' direction (2 = Right)
					j AFTER_SUMMON_ATTACK_ENEMY
					
				SET_ENEMY_MAGIC_LEFT:
		  			addi t2,t2,-16	# Subtracts 16 pixel offset (to look like it is leaving from player)
		  			addi t3,t3,0	# Adds 4 pixel offset (in order to center it on player)
		  			li t0,0		# Top of screen
		  			blt t2,t0,AFTER_SUMMON_ATTACK_ENEMY	# If X < 0, it's out of range, so it won't be rendered
		  			sh t2,0(s4)	# Will store X on of given Magic_Pos
		  			sh t3,2(s4)	# Will store Y on given Magic_Pos
		  			li t0,3		# Sets t0 to 3,
		  			sh t0,12(s4)	# storing in Magic_Status' direction (3 = Left)
					j AFTER_SUMMON_ATTACK_ENEMY
			AFTER_SUMMON_ATTACK_ENEMY:
			  	lh t1,12(s4)		# Loads direction of magic to be summoned
				li t2,magic_speed	# Loads magic speed
				projectile_static_colision_check(s4,LEVEL_HIT_MAP,16,16,t1,t2,1)
				li t0,1						# Since if it's returned number 2, it won't despawn
				beq a0,t0,CHECK_ENEMY_ATTACK_STATUS_INDEX	# If a0 = 1, despawn
				# otherwise, will be summoned
				li t0,1		# Sets t0 to 1,
				sh t0,14(s4)	# storing Magic_Status as if it was rendered once, so that algorithm knows that it has to be rendered			
			
			CHECK_ENEMY_ATTACK_STATUS_INDEX:
				lh t0,4(s2)	# Loads process counter 
				addi t0,t0,1	# and adds 1 to it
				sh t0,4(s2)	# and stores it in the counter
				lh t1,10(s3)	# Loads the number of times this process has to be repeated
				bne t1,t0,UPDATE_ENEMY_ATTACK_SPRITE_STATUS	# and if the number of times has been reached, continue, otherwise, skip next section
					# Reseting counter and updating index to the next one
					li t0,0		# Loads 0 to t0
					sh t0,4(s2)	# and stores it in the counter
					# checking if number of total processes has been reached
					lh t1,2(s2)			# Loads process index
					addi t1,t1,1			# and adds 1 to it
					sh t1,2(s2)			# and stores it in the process index
					lh t0,0(s2)			# Loads number of processes
					blt t1,t0,UPDATE_ENEMY_ATTACK_SPRITE_STATUS	# and while t1 < t0, the whole process won't be reset
						# otherwise, will reset the index so that the whole process can start over
						li t1,0		# Loads 0 to t1
						sh t1,2(s2)	# and store it in the index 
				  
			UPDATE_ENEMY_ATTACK_SPRITE_STATUS:
				lh t1,12(s1)	# Loads Sprite Status 
				li t2,2		# Max index (all enemies have 3 animation sprites)
				beq t1,t2,SET_ZERO_ENEMY_SPRITE
				ADDSTATUS_ENEMY_SPRITE:
					addi t1,t1,1
					sh t1,12(s1)
					j END_SUMMON_ATTACK_ENEMY
				SET_ZERO_ENEMY_SPRITE:
					li t1,0
					sh t1,12(s1)
					j END_SUMMON_ATTACK_ENEMY
					
	END_SUMMON_ATTACK_ENEMY:
		ret
