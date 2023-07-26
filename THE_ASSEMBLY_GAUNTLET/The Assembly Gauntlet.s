#Jogo criado por Eduardo Pereira, Luca Megiorin e Manuella dos Santos :D
#The Assembly Gauntlet, jogo inspirado por Gauntlet(Atari)

.include "MACROSv21.s"		# Macros for bitmap display
.include "gamemacros.s"		# Macros for better organization

.data #Includes game-related informations

# Time-related data
.eqv frame_rate 90 # T ms per frame
.eqv update_timer_rate 12 # every N times a loop is realized, will update GAME_TIMER
RUN_TIME: .word 0 # Stores time passed (will update frequently)
GAME_TIMER: .half 0,0 # Stores times it went through the game loop (resets when reaching 10) and time passed when starting game
ATTACK_TIMER: .word 0 # Stores time when an attack started

# Level/Menu Info
.eqv loading_screen 3000 # Time when black screen stays between each level (ms)
LOADING_SCREEN_TIMER: .word 0	# Stores the time when player entered a loading screen
LEVEL_INFO: .half 0,0,0	# Stores the level of player (0 = menu), the section of a level and whether it is the first time entering it or not
SELECT_STATUS: .half 0	#Stores selection arrows status 0 = start, 1 = exit game
LEVEL_MAP: .word 0 # Level Map ADDRESS
LEVEL_HIT_MAP: .word 0 # Level Hitbox Map ADDRESS

# Player Info
.eqv attack_delay 50		# Delay of attack animation
.eqv attack_time 20		# Time a player projectile will stay on screen
.eqv max_plyr_projectile 4	# Max number of player projectiles
.eqv player_speed 4		# Speed of player
.eqv magic_speed 4		# Speed of magic
PLYR_POS: .half 10, 40, 0, 0 # Stores Player position (top left x,y) and old position (top left x,y)
PLYR_HITBOX: .half 0,0	     # Stores Player's hitbox coordinates  (top left x,y)
PLYR_STATUS: .half 1,0,0,0,0 # Stores Player status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), attack animation phase (0,1,2))
.eqv player_health 500 # Player health
PLYR_INFO: .half 0,0,0 # Stores health/time, score and number of keys

# Death info
.eqv death_time 80	# Time for each frame in death animation
.eqv pause_between 1000 # Pause before starting Game Over animation
.eqv game_over_time 100 # Time for each frame in game over animation
DEATH_TIMER: .word 0 # Stores time for death animation
DEATH_ITERATOR: .half 0	# Stores a6 for death animation (animation index)

# Background decoration (LVL 1.1)
.eqv backgroud_delay 300 # Animation delay for background
WAVE_DOWN_1.1_POS: .half 0,0 # Stores the positions (top left x,y) of a wave sprite
WAVE_DOWN_1.1_STATUS: .half 0,0,0 # Stores wave status (sprite number, spriteinfo (0 if ascending, 1 if descending), and whether it should get timer or not)
WAVE_DOWN_1.1_timer: .word 0 # Stores time when wave is rendered, so that it knows when to update it's animation status

WAVE_LEFT_1.1_POS: .half 0,0 # Stores the positions (top left x,y) of a wave sprite
WAVE_LEFT_1.1_STATUS: .half 0,0,0 # Stores wave status (sprite number, spriteinfo (0 if ascending, 1 if descending), and whether it should get timer or not)
WAVE_LEFT_1.1_timer: .word 0 # Stores time when wave is rendered, so that it knows when to update it's animation status




# Entities Info
Warp_Box_1: .half 0,0 # Stores the positions (top left x,y) of the first warp box
Warp_Pos_1: .half 0,0,0 # Stores the positions (top left x,y) of where the first warp box will tp player and the level section
Warp_Box_2: .half 0,0 # Stores the positions (top left x,y) of the second warp box
Warp_Pos_2: .half 0,0,0 # Stores the positions (top left x,y) of where the second warp box will tp player and the level section
Warp_Box_3: .half 0,0 # Stores the positions (top left x,y) of the third warp box
Warp_Pos_3: .half 0,0,0 # Stores the positions (top left x,y) of where the third warp box will tp player and the level section
Warp_Box_4: .half 0,0 # Stores the positions (top left x,y) of the fourth warp box
Warp_Pos_4: .half 0,0,0 # Stores the positions (top left x,y) of where the fourth warp box will tp player and the level section

Door_H_Pos1: .half 0,0 # Stores the positions (top left x,y) of the first horizontal door
Door_H_Status1: .half 0 # Stores the states of the first horizontal door (0 = closed, 1 = open)
Door_H_Pos2: .half 0,0 # Stores the positions (top left x,y) of the second horizontal door
Door_H_Status2: .half 0 # Stores the states of the second horizontal door doors (0 = closed, 1 = open)

Door_V_Pos1: .half 0,0# Stores the positions (top left x,y) of the first vertical door
Door_V_Status1: .half 0 # Stores the states of the first vertical door (0 = closed, 1 = open)
Door_V_Pos2: .half 0,0# Stores the positions (top left x,y) of the second vertical door
Door_V_Status2: .half 0 # Stores the states of the second vertical door doors (0 = closed, 1 = open)

Key_Pos1: .half 0,0 # Stores the position (top left x,y) of Key 1
Key_Hitbox1: .half 0,0 # Stores the hitbox (top left x,y) of Key 1
Key_Status1: .half 0 # Stores the states of Key1 (0 = not collected, 1 = collected)
Key_Pos2: .half 0,0 # Stores the position (top left x,y) of Key 2
Key_Hitbox2: .half 0,0 # Stores the hitbox (top left x,y) of Key 2
Key_Status2: .half 0 # Stores the states of Key2 (0 = not collected, 1 = collected)

Battery_Pos1: .half 0,0 # Stores the position (top left x,y) of Battery 1
Battery_Hitbox1: .half 0,0 # Stores the hitbox (top left x,y) of Battery 1
Battery_Status1: .half 0 # Stores the states of Battery1 (0 = not collected, 1 = collected)
Battery_Pos2: .half 0,0 # Stores the position (top left x,y) of Battery 2
Battery_Hitbox2: .half 0,0 # Stores the hitbox (top left x,y) of Battery 2
Battery_Status2: .half 0 # Stores the states of Battery2 (0 = not collected, 1 = collected)

Chest_Pos1: .half 0,0 # Stores the position (top left x,y) of Chest 1
Chest_Hitbox1: .half 0,0 # Stores the hitbox (top left x,y) of Chest 1
Chest_Status1: .half 0 # Stores the states of Chest1 (0 = not collected, 1 = collected)
Chest_Pos2: .half 0,0 # Stores the position (top left x,y) of Chest 2
Chest_Hitbox2: .half 0,0 # Stores the hitbox (top left x,y) of Chest 2
Chest_Status2: .half 0 # Stores the states of Chest2 (0 = not collected, 1 = collected)

MAGIC_ARRAY: # To facilitate understanding iterations (every 8 bytes for going from Pos to Status, every 16 bytes for going from Pos to Pos) 
Magic_Pos1: .half 0,0,0,0 # Stores magic 1 position (top left x,y) and old position (top left x,y)
Magic_Status1: .half 0,0,0,0 # Stores magic 1 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)
Magic_Pos2: .half 0,0,0,0 # Stores magic 2 position (top left x,y) and old position (top left x,y)
Magic_Status2: .half 0,0,0,0 # Stores magic 2 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)
Magic_Pos3: .half 0,0,0,0 # Stores magic 3 position (top left x,y) and old position (top left x,y)
Magic_Status3: .half 0,0,0,0 # Stores magic 3 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)
Magic_Pos4: .half 0,0,0,0 # Stores magic 4 position (top left x,y) and old position (top left x,y)
Magic_Status4: .half 0,0,0,0 # Stores magic 4 status (sprite number, spriteinfo (0 if ascending, 1 if descending),direction (0 = down, 1 = up, 2 = right, 3 = left),attack state (0 = not attacking,1 = attacking), times rendered)

.text

# s0 corresponds to frame number (try not to use it anywhere else ;)
MENU:	# Game Menu
	la t0, LEVEL_INFO		# Loads LEVEL_INFO address
	lh t0,2(t0)			# Checks what section of the menu it is at
	bnez t0,SKIP_MAIN_MENU		# and if it's not equal to 0, will skip
	j MAIN_MENU			# otherwise it equals to 0, jumping towards main menu
	SKIP_MAIN_MENU:
	li t1,1				# If it's not equal to 1 (game over menu),
	bne t1,t0,SKIP_GAME_OVER_MENU	# it'll skip it again (probably due to an error, so it'll go to main menu)
	j GAME_OVER_MENU		# otherwise it equals to 1, jumping towards game over menu
	SKIP_GAME_OVER_MENU:
	MAIN_MENU:
		li s0,0					# Frame 0
		renderi(Menu,0,0,320,240,s0,0,0)	# Renders menu on frame 0
		li s0,1					# Frame 1
		renderi(Menu,0,0,320,240,s0,0,0)	# Renders menu on frame 1
		
		call STOP_SOUND # Stops all soundtracks/sound effects
		
		la t0,PLYR_INFO		# Loads PLYR_INFO
		li t1,player_health	# Loads player health
		sh t1,0(t0)		# and stores it
		li t1,0			# Loads 0	
		sh t1,2(t0)		# and stores it in score counter
		sh t1,4(t0)		# and in key counter
		
		
		MAIN_MENU_LOOP:	# Loop for game menu
			reset_soundtrack(MENU_MSC)	# Sets music for MENU
			
			call PLAY_SOUND		# Plays menu music
			
			call INPUT_CHECK	# Checks if there is player input
			
			la t0, SELECT_STATUS	# Loads SELECT_STATUS address
			lh t0,0(t0)		# t0 is the status of selection (0 = start, 1 = exit game)
			
			beqz t0, MAIN_SEL_START	# if selection is 0, go to SEL_START, otherwise, go to SEL_EXIT
			MAIN_SEL_EXIT:
				renderi(SelectionArrows,4,141,148,18,s0,1,0)	# Renders selection on "Exit Game" option
				j MAIN_SEL_OUT					# Goes out of selection branch
			MAIN_SEL_START:
				renderi(SelectionArrows,4,118,148,18,s0,0,0)	# Renders selection on "Start" option
				j MAIN_SEL_OUT					# Goes out of selection branch
			MAIN_SEL_OUT:
			show_frame(s0)		#Shows frame s0
			
			switch_frame_value()		# Switches frame value
			mv a5,s0			# Moves current frame to a5
			la t0, SELECT_STATUS		# Loads SELECT_STATUS address
			lh t0,0(t0)			# t0 is the status of selection (0 = start, 1 = exit game)
			beqz t0, MAIN_SEL_START_TRAIL 	# if "Start" is selected, will remove trail from Start, otherwise, remove trail from Exit Game
			MAIN_SEL_EXIT_TRAIL:
				renderi(Menu,4,118,148,18,a5,0,1)		# Removes trail made by Exit Game selection
				j MAIN_SEL_OUT_TRAIL				# Goes out of selection trail branch
			MAIN_SEL_START_TRAIL:
				renderi(Menu,4,141,148,18,a5,0,1)		# Removes trail made by Start selection
				j MAIN_SEL_OUT_TRAIL				# Goes out of selection trail branch
			MAIN_SEL_OUT_TRAIL:
			
			la t0, LEVEL_INFO	# Loads LEVEL_INFO address
			lh t0,0(t0)		# Checks what level it is on (0 for menu)
			li t1,1			# and if it equals to 1 (Level 1)
			bne t1,t0,MAIN_MENU_LOOP	# it will go to SETUP (Game has started)
			j START_GAME	# otherwise continue the MENU_LOOP
	
	GAME_OVER_MENU:
		li s0,0						# Frame 0
		renderi(Game_Over_Menu,0,0,320,240,s0,0,0)	# Renders menu on frame 0
		li s0,1						# Frame 1
		renderi(Game_Over_Menu,0,0,320,240,s0,0,0)	# Renders menu on frame 1
		
		la t0,PLYR_INFO		# Loads PLYR_INFO
		li t1,player_health	# Loads player health
		sh t1,0(t0)		# and stores it
		li t1,0			# Loads 0	
		sh t1,2(t0)		# and stores it in score counter
		sh t1,4(t0)		# and in key counter
		
		G.O_MENU_LOOP:	# Loop for game menu
			reset_soundtrack(G.O_MENU_MSC)	# Sets music for MENU
			
			call PLAY_SOUND	# Plays game over menu song
			
			call INPUT_CHECK	# Checks if there is player input
			
			la t0, SELECT_STATUS	# Loads SELECT_STATUS address
			lh t0,0(t0)		# t0 is the status of selection (0 = start, 1 = exit game)
			
			beqz t0, G.O_SEL_START	# if selection is 0, go to SEL_START,
			li t1,1			#  otherwise, if selection is 1 go to SEL_RETURN_MENU
			beq t0,t1,G.O_SEL_RETURN_MENU # otherwise, go to SEL_EXIT
			G.O_SEL_EXIT:
				renderi(SelectionArrows_Game_Over,48,172,228,18,s0,0,0)	# Renders selection on "Exit Game" option
				j G.O_SEL_OUT					# Goes out of selection branch
			G.O_SEL_RETURN_MENU:
				renderi(SelectionArrows_Game_Over,48,148,228,18,s0,1,0)	# Renders selection on "Return to Menu" option
				j G.O_SEL_OUT	
			G.O_SEL_START:
				renderi(SelectionArrows_Game_Over,48,120,228,18,s0,0,0)	# Renders selection on "Restart" option
				j G.O_SEL_OUT					# Goes out of selection branch
			G.O_SEL_OUT:
			show_frame(s0)		#Shows frame s0
			
			switch_frame_value()		# Switches frame value
			mv a5,s0			# Moves current frame to a5
			la t0, SELECT_STATUS		# Loads SELECT_STATUS address
			lh t0,0(t0)			# t0 is the status of selection (0 = start, 1 = exit game)
			
			beqz t0, G.O_SEL_START_TRAIL	# if selection is 0, go to SEL_START_TRAIL,
			li t1,1			#  otherwise, if selection is 1 go to SEL_RETURN_MENU_TRAIL
			beq t0,t1,G.O_SEL_RETURN_MENU_TRAIL # otherwise, go to SEL_EXIT_TRAIL
			G.O_SEL_EXIT_TRAIL:
				renderi(Game_Over_Menu,48,120,228,18,a5,0,1)		# Removes trail made by Start selection
				renderi(Game_Over_Menu,48,148,228,18,a5,0,1)		# Removes trail made by Return to Menu selection
				j G.O_SEL_OUT_TRAIL				# Goes out of selection trail branch
			G.O_SEL_RETURN_MENU_TRAIL:
				renderi(Game_Over_Menu,48,172,228,18,a5,0,1)		# Removes trail made by Exit Game selection
				renderi(Game_Over_Menu,48,120,228,18,a5,0,1)		# Removes trail made by Start selection
				j G.O_SEL_OUT_TRAIL				# Goes out of selection trail branch
			G.O_SEL_START_TRAIL:
				renderi(Game_Over_Menu,48,172,228,18,a5,0,1)		# Removes trail made by Exit Game selection
				renderi(Game_Over_Menu,48,148,228,18,a5,0,1)		# Removes trail made by Return to Menu selection
				j G.O_SEL_OUT_TRAIL				# Goes out of selection trail branch
			G.O_SEL_OUT_TRAIL:
			
			la t0, LEVEL_INFO	# Loads LEVEL_INFO address
			lh t0,0(t0)		# Checks what level it is on (0 for menu)
			li t1,1			# and if it equals to 1 (Level 1)
			bne t1,t0,G.O_MENU_LOOP	# it will go to SETUP (Game has started)
			j START_GAME	# otherwise continue the MENU_LOOP

START_GAME: # Sets player's health and starts game
	call STOP_SOUND # Stops all soundtracks/sound effects
		
	la t0,PLYR_INFO	# Loads PLYR_INFO
	lh t1,0(t0)	# and gets player's health
	bnez t1, SETUP	# if it's not equal to zero (aka, player still has health), go to SETUP
	li t1,player_health	# otherwise, restore player's health (after all, this is a cheat)
	sh t1,0(t0)	# and store it again
	j SETUP
			
# s0 corresponds to frame number (try not to use it anywhere else ;)
# Go to dynamic colision check to edit player position when entering sections through warp boxes
SETUP:	
	
	la t0, LEVEL_INFO		# Loads LEVEL_INFO address
	lh t1,4(t0)			# Checks whether it's the first time loading a level (NOT A SECTION)
	bnez t1, AFTER_DEFAULT_RESET	# and skips the reseting if it isn't the first time
	DEFAULT_RESET:
		call RESET_PARAMETERS	# Resets keys, doors, chests and collectibles alike
		call STOP_SOUND # Stops all soundtracks/sound effects
		
	AFTER_DEFAULT_RESET:
		call RESET_PROJECTILES_AND_ENEMIES	# Despawns every enemy and projectile
		
		la t0, LEVEL_INFO	# Loads LEVEL_INFO address
		lh t0,0(t0)		# Checks what level it is at (0 for menu)
		li t1,1			# and if it equals to 1 (Level 1)
		bne t1,t0,SKIP_LEVEL1_SETUP	# it'll go to to the first level setup 
		j LEVEL1_SETUP
		SKIP_LEVEL1_SETUP:
		li t1,2			# otherwise if it equals to 2 (Level 2)
		bne t1,t0,SKIP_LEVEL2_SETUP	# it'll go to to the first level setup 
		j LEVEL2_SETUP
		SKIP_LEVEL2_SETUP:
		li t1,3			# otherwise if it equals to 3 (Level 3)
		bne t1,t0,SKIP_LEVEL3_SETUP	# it'll go to to the first level setup 
		j LEVEL3_SETUP
		SKIP_LEVEL3_SETUP:
		li t1,4			# otherwise if it equals to 4 (End game)
		bne t1,t0,SKIP_END_ANM	# it'll go to to end game animation
		j END_ANM
		SKIP_END_ANM:
		LEVEL1_SETUP:
			reset_soundtrack(LVL1_MSC)	# Sets music for LVL1		
		
			la t0, LEVEL_INFO		# Loads LEVEL_INFO address
			lh t0,2(t0)			# Checks what section of the level it is at
			bnez t0,SKIP_LEVEL1_START_SCREEN	# and if it equals to 0, it'll go to the level's Start Screen
			j LEVEL1_START_SCREEN
			SKIP_LEVEL1_START_SCREEN:
			li t1,1				# otherwise, if it equals to 1 (Level 1.1),
			bne t1,t0,SKIP_LEVEL1.1_SETUP	# it'll go to to the first level 1 section setup 
			j LEVEL1.1_SETUP
			SKIP_LEVEL1.1_SETUP:
			li t1,2				# otherwise, if it equals to 2 (Level 1.2)
			bne t1,t0,SKIP_LEVEL1.2_SETUP	# it'll go to to the second level 1 section setup 
			j LEVEL1.2_SETUP
			SKIP_LEVEL1.2_SETUP:
			j SETUP
			LEVEL1_START_SCREEN: #Loop Before Level Starts
				li a7,30	# gets time passed
				ecall 		# syscall
				la t0,LOADING_SCREEN_TIMER	# Loads LOADING_SCREEN_TIMER address
				sw a0,0(t0)			# new time is stored in LOADING_SCREEN_TIMER, in order to be compared later
				# Rendering Info Screen
				li s0,0
				renderi(Black,0,0,320,240,s0,0,0)
				li s0,1
				renderi(Black,0,0,320,240,s0,0,0)
				li s0,0
				j LEVEL1_START_SCREEN_LOOP	# Start Start Screen Loop	
				
				
				LEVEL1_START_SCREEN_LOOP:
					li a7,30				#gets time passed
					ecall 					# syscall
					la t0,LOADING_SCREEN_TIMER		# Loads LOADING_SCREEN_TIMER address
					lw t1,0(t0)				# loads last time stored
					sub t1,a0,t1				# new time - old time
					li t2,loading_screen			# loads frame rate (T ms per frame)
					blt t1,t2,LEVEL1_START_SCREEN_LOOP	# if new time - old time < loading screen (ms), repeat Start Screen Loop,
					
					la t0, LEVEL_INFO		# Otherwise, loads LEVEL_INFO address
					li t1,1				# gets t1 = 1, and stores it in
					sh t1,2(t0)			# LEVEL_INFO level section
					j SETUP				# Going back to Setup
					
			LEVEL1.1_SETUP:
				# Pre-render map
				li s0,0
				renderi(Map1.1,0,0,320,240,s0,0,0)
				li s0,1
				renderi(Map1.1,0,0,320,240,s0,0,0)
				li s0,0
			
				# Sets Background Animation
				set_position(WAVE_DOWN_1.1_POS,32,208)
				set_position(WAVE_LEFT_1.1_POS,16,16)
				# Sets Warp Boxes and Positions
				set_position(Warp_Box_1,148,0)
				set_position(Warp_Pos_1,200,216)
				set_warp(Warp_Pos_1,2)
				# Sets Sprites Positions
				set_position_with_hitbox(Chest_Pos1,184,144,Chest_Hitbox1,4,4)
				
				set_position(Slime_Pos_0,216,112)
				set_enemy(Slime_0,1,40,100,0,Slime_Process_1.1.0)
				set_position(Slime_Pos_1,40,96)
				set_enemy(Slime_1,1,40,100,0,Slime_Process_1.1.1)
				
				la t0, LEVEL_INFO		# Loads LEVEL_INFO address
				lh t1,4(t0)			# Checks whether it's the first time loading a level 1.1
				bnez t1, AFTER_LEVEL1_POSITION	# and skips setting player position if it's not equal to 0
				SET_LEVEL1_POSITION:
					set_position_with_hitbox_mov(PLYR_POS,68,40,PLYR_HITBOX,4,4)
				AFTER_LEVEL1_POSITION:
					# Stores Map1's address in LEVEL_MAP, so that rendering trail works propperly
					la t0,Map1.1
					la t1,LEVEL_MAP
					sw t0,0(t1)
					
					la t0,Map1.1_Hit
					la t1,LEVEL_HIT_MAP
					sw t0,0(t1)
					
					j START_SETUP
				
			LEVEL1.2_SETUP:			
				# Pre-render map
				li s0,0
				renderi(Map1.2,0,0,320,240,s0,0,0)
				li s0,1
				renderi(Map1.2,0,0,320,240,s0,0,0)
				li s0,0
			
				# Sets Warp Boxes and Positions
				set_position(Warp_Box_1,148,237)
				set_position(Warp_Pos_1,200,4)
				set_warp(Warp_Pos_1,1)
				# Sets Sprites Positions
				set_position(Door_H_Pos1,232,114)
				set_position_with_hitbox(Key_Pos1,180,150,Key_Hitbox1,4,4)
				
				set_position(Slime_Pos_0,216,192)
				set_enemy(Slime_0,1,40,100,0,Slime_Process_1.2.0)
				set_position(Slime_Pos_1,232,32)
				set_enemy(Slime_1,1,40,100,0,Slime_Process_1.2.1)
				set_position(Slime_Pos_2,24,64)
				set_enemy(Slime_2,1,40,100,0,Slime_Process_1.2.2)
				set_position(Slime_Pos_3,40,96)
				set_enemy(Slime_3,1,40,100,0,Slime_Process_1.2.3)
				
				# Stores Map1's address in LEVEL_MAP, so that rendering trail works propperly
				la t0,Map1.2
				la t1,LEVEL_MAP
				sw t0,0(t1)
				
				la t0,Map1.2_Hit
				la t1,LEVEL_HIT_MAP
				sw t0,0(t1)
				
				j START_SETUP
		
		LEVEL2_SETUP:
			reset_soundtrack(LVL2_MSC)	# Sets music for LVL2

			la t0, LEVEL_INFO		# Loads LEVEL_INFO address
			lh t0,2(t0)			# Checks what section of the level it is at
			bnez t0,SKIP_LEVEL2_START_SCREEN	# and if it equals to 0, it'll go to the level's Start Screen
			j LEVEL2_START_SCREEN
			SKIP_LEVEL2_START_SCREEN:
			li t1,1				# otherwise, if it equals to 1 (Level 1.1),
			bne t1,t0,SKIP_LEVEL2.1_SETUP	# it'll go to to the first level 1 section setup 
			j LEVEL2.1_SETUP
			SKIP_LEVEL2.1_SETUP:
			li t1,2				# otherwise, if it equals to 2 (Level 1.2)
			bne t1,t0,SKIP_LEVEL2.2_SETUP	# it'll go to to the second level 1 section setup 
			j LEVEL2.2_SETUP
			SKIP_LEVEL2.2_SETUP:
			li t1,3				# otherwise, if it equals to 1 (Level 2.3)
			bne t1,t0,SKIP_LEVEL2.3_SETUP	# it'll go to to the third level 2 section setup 
			j LEVEL2.3_SETUP
			SKIP_LEVEL2.3_SETUP:
			
			LEVEL2_START_SCREEN: #Loop Before Level Starts
				li a7,30	# gets time passed
				ecall 		# syscall
				la t0,LOADING_SCREEN_TIMER	# Loads LOADING_SCREEN_TIMER address
				sw a0,0(t0)			# new time is stored in LOADING_SCREEN_TIMER, in order to be compared later
				# Rendering Info Screen
				li s0,0
				renderi(Black,0,0,320,240,s0,0,0)
				li s0,1
				renderi(Black,0,0,320,240,s0,0,0)
				li s0,0
				j LEVEL2_START_SCREEN_LOOP	# Start Start Screen Loop	
				
				
				LEVEL2_START_SCREEN_LOOP:
					li a7,30				#gets time passed
					ecall 					# syscall
					la t0,LOADING_SCREEN_TIMER		# Loads LOADING_SCREEN_TIMER address
					lw t1,0(t0)				# loads last time stored
					sub t1,a0,t1				# new time - old time
					li t2,loading_screen			# loads frame rate (T ms per frame)
					blt t1,t2,LEVEL2_START_SCREEN_LOOP	# if new time - old time < loading screen (ms), repeat Start Screen Loop,
					
					la t0, LEVEL_INFO		# Otherwise, loads LEVEL_INFO address
					li t1,1				# gets t1 = 1, and stores it in
					sh t1,2(t0)			# LEVEL_INFO level section
					j SETUP				# Going back to Setup
					
			LEVEL2.1_SETUP:
				# Pre-render map
				li s0,0
				renderi(Map2.1,0,0,320,240,s0,0,0)
				li s0,1
				renderi(Map2.1,0,0,320,240,s0,0,0)
				li s0,0
			
				# Sets Warp Boxes and Positions
				set_position(Warp_Box_1,0,0)
				set_position(Warp_Pos_1,248,216)
				set_warp(Warp_Pos_1,2)
				
				set_position(Warp_Box_2,0,237)
				set_position(Warp_Pos_2,200,4)
				set_warp(Warp_Pos_2,3)
				# Sets Sprites Positions
				set_position(Door_V_Pos1,140,59)
				set_position_with_hitbox(Key_Pos1,24,192,Key_Hitbox1,4,4)
				
				set_position(Slime_Pos_0,240,48)
				set_enemy(Slime_0,1,40,100,1,Slime_Process_2.1.0)
				set_position(Slime_Pos_1,56,24)
				set_enemy(Slime_1,1,40,100,1,Slime_Process_2.1.1)
				set_position(Slime_Pos_2,168,80 )
				set_enemy(Slime_2,1,40,100,1,Slime_Process_2.1.2)
				set_position(Slime_Pos_3,104,128)
				set_enemy(Slime_3,1,40,100,1,Slime_Process_2.1.3)
				#set_position_with_hitbox(Chest_Pos1,180,150,Chest_Hitbox1,4,4)
				la t0, LEVEL_INFO		# Loads LEVEL_INFO address
				lh t1,4(t0)			# Checks whether it's the first time loading a level 1.1
				bnez t1, AFTER_LEVEL2_POSITION	# and skips setting player position if it's not equal to 0
				SET_LEVEL2_POSITION:
					set_position_with_hitbox_mov(PLYR_POS,240,198,PLYR_HITBOX,4,4)
					la t0,PLYR_STATUS	# Loads PLYR_STATUS
					li t1,1			# Loads direction (1 = Up)
					sh t1,4(t0)		# Stores in player status
				AFTER_LEVEL2_POSITION:
					# Stores Map1's address in LEVEL_MAP, so that rendering trail works propperly
					la t0,Map2.1
					la t1,LEVEL_MAP
					sw t0,0(t1)
					
					la t0,Map2.1_Hit
					la t1,LEVEL_HIT_MAP
					sw t0,0(t1)
					
					j START_SETUP
			LEVEL2.2_SETUP:
				# Pre-render map
				li s0,0
				renderi(Map2.2,0,0,320,240,s0,0,0)
				li s0,1
				renderi(Map2.2,0,0,320,240,s0,0,0)
				li s0,0
			
				# Sets Sprites Positions
				set_position(Warp_Box_1,270,0)
				set_position(Warp_Pos_1,4,4)
				set_warp(Warp_Pos_1,1)
				# Sets Sprites Positions
				set_position_with_hitbox(Key_Pos2,88,128,Key_Hitbox2,4,4)
				set_position(Door_H_Pos1,216,162)
				set_position(Door_H_Pos2,216,98)
				set_position_with_hitbox(Chest_Pos1,152,128,Chest_Hitbox1,4,4)
				
				set_position(Slime_Pos_0,72,48)
				set_enemy(Slime_0,1,40,100,1,Slime_Process_2.2.0)
				set_position_mov(ULA_Pos_0,24,24)
				set_enemy(ULA_0,1,40,2000,0,ULA_Process_2.2.0)
				set_position_mov(ULA_Pos_1,24,72)
				set_enemy(ULA_1,1,40,2000,0,ULA_Process_2.2.1)
				set_position_mov(ULA_Pos_2,24,192)
				set_enemy(ULA_2,1,40,2000,0,ULA_Process_2.2.2)
				
				# Stores Map1's address in LEVEL_MAP, so that rendering trail works propperly
				la t0,Map2.2
				la t1,LEVEL_MAP
				sw t0,0(t1)
				
				la t0,Map2.2_Hit
				la t1,LEVEL_HIT_MAP
				sw t0,0(t1)
				
				j START_SETUP
				
			LEVEL2.3_SETUP:
				# Pre-render map
				li s0,0
				renderi(Map2.3,0,0,320,240,s0,0,0)
				li s0,1
				renderi(Map2.3,0,0,320,240,s0,0,0)
				li s0,0
			
				# Sets Sprites Positions
				set_position(Warp_Box_1,0,0)
				set_position(Warp_Pos_1,200,216)
				set_warp(Warp_Pos_1,1)
				# Sets Sprites Positions
				set_position_with_hitbox(Battery_Pos1,164,120,Battery_Hitbox1,4,4)
				
				set_position(Slime_Pos_0,232,16)
				set_enemy(Slime_0,1,40,100,1,Slime_Process_2.3.0)
				set_position(Slime_Pos_2,96,32)
				set_enemy(Slime_2,1,40,100,1,Slime_Process_2.3.2)
				set_position_mov(ULA_Pos_0,24,32)
				set_enemy(ULA_0,1,40,2000,0,ULA_Process_2.3.0)
				set_position_mov(ULA_Pos_1,24,128)
				set_enemy(ULA_1,1,40,2000,0,ULA_Process_2.3.1)
				set_position_mov(ULA_Pos_2,96,192)
				set_enemy(ULA_2,1,40,2000,0,ULA_Process_2.3.2)
				set_position_mov(ULA_Pos_3,232,192)
				set_enemy(ULA_3,1,40,2000,0,ULA_Process_2.3.3)
				# Stores Map1's address in LEVEL_MAP, so that rendering trail works propperly
				la t0,Map2.3
				la t1,LEVEL_MAP
				sw t0,0(t1)
				
				la t0,Map2.3_Hit
				la t1,LEVEL_HIT_MAP
				sw t0,0(t1)
				
				j START_SETUP
		
		LEVEL3_SETUP:
			reset_soundtrack(LVL3_MSC)	# Sets music for LVL3
		
			la t0, LEVEL_INFO		# Loads LEVEL_INFO address
			lh t0,2(t0)			# Checks what section of the level it is at
			bnez t0,SKIP_LEVEL3_START_SCREEN	# and if it equals to 0, it'll go to the level's Start Screen
			j LEVEL3_START_SCREEN
			SKIP_LEVEL3_START_SCREEN:
			li t1,1				# otherwise, if it equals to 1 (Level 3.1),
			bne t1,t0,SKIP_LEVEL3.1_SETUP	# it'll go to to the first level 3 section setup 
			j LEVEL3.1_SETUP
			SKIP_LEVEL3.1_SETUP:
			li t1,2				# otherwise, if it equals to 2 (Level 3.2)
			bne t1,t0,SKIP_LEVEL3.2_SETUP	# it'll go to to the second level 3 section setup 
			j LEVEL3.2_SETUP
			SKIP_LEVEL3.2_SETUP:
			li t1,3				# otherwise, if it equals to 2 (Level 3.3)
			bne t1,t0,SKIP_LEVEL3.3_SETUP	# it'll go to to the third level 3 section setup 
			j LEVEL3.3_SETUP
			SKIP_LEVEL3.3_SETUP:
			li t1,4				# otherwise, if it equals to 4 (Level 3.4)
			bne t1,t0,SKIP_LEVEL3.4_SETUP	# it'll go to to the fourth level 3 section setup 
			j LEVEL3.4_SETUP
			SKIP_LEVEL3.4_SETUP:
			
			LEVEL3_START_SCREEN: #Loop Before Level Starts
				li a7,30	# gets time passed
				ecall 		# syscall
				la t0,LOADING_SCREEN_TIMER	# Loads LOADING_SCREEN_TIMER address
				sw a0,0(t0)			# new time is stored in LOADING_SCREEN_TIMER, in order to be compared later
				# Rendering Info Screen
				li s0,0
				renderi(Black,0,0,320,240,s0,0,0)
				li s0,1
				renderi(Black,0,0,320,240,s0,0,0)
				li s0,0
				j LEVEL3_START_SCREEN_LOOP	# Start Start Screen Loop	
				
				
				LEVEL3_START_SCREEN_LOOP:
					li a7,30				#gets time passed
					ecall 					# syscall
					la t0,LOADING_SCREEN_TIMER		# Loads LOADING_SCREEN_TIMER address
					lw t1,0(t0)				# loads last time stored
					sub t1,a0,t1				# new time - old time
					li t2,loading_screen			# loads frame rate (T ms per frame)
					blt t1,t2,LEVEL3_START_SCREEN_LOOP	# if new time - old time < loading screen (ms), repeat Start Screen Loop,
					
					la t0, LEVEL_INFO		# Otherwise, loads LEVEL_INFO address
					li t1,1				# gets t1 = 1, and stores it in
					sh t1,2(t0)			# LEVEL_INFO level section
					j SETUP				# Going back to Setup
					
			LEVEL3.1_SETUP:	
				# Pre-render map
				li s0,0
				renderi(Map3.1,0,0,320,240,s0,0,0)
				li s0,1
				renderi(Map3.1,0,0,320,240,s0,0,0)
				li s0,0
			
				# Sets Warp Boxes and Positions
				set_position(Warp_Box_1,270,0)
				set_position(Warp_Pos_1,4,4)
				set_warp(Warp_Pos_1,2)
				
				set_position(Warp_Box_2,0,237)
				set_position(Warp_Pos_2,200,4)
				set_warp(Warp_Pos_2,4)
				# Sets Sprites Positions
				set_position_with_hitbox(Key_Pos1,40,80,Key_Hitbox1,4,4)
				set_position_with_hitbox(Battery_Pos1,152,112,Battery_Hitbox1,4,4)
				
				set_position_mov(ULA_Pos_0,104,80)
				set_enemy(ULA_0,1,40,500,1,ULA_Process_3.1.0)
				set_position_mov(ULA_Pos_1,200,128)
				set_enemy(ULA_1,1,40,500,1,ULA_Process_3.1.1)
				#set_position_with_hitbox(Chest_Pos1,180,150,Chest_Hitbox1,4,4)
				la t0, LEVEL_INFO		# Loads LEVEL_INFO address
				lh t1,4(t0)			# Checks whether it's the first time loading a level 1.1
				bnez t1, AFTER_LEVEL3_POSITION	# and skips setting player position if it's not equal to 0
				SET_LEVEL3_POSITION:
					set_position_with_hitbox_mov(PLYR_POS,232,32,PLYR_HITBOX,4,4)
					la t0,PLYR_STATUS	# Loads PLYR_STATUS
					li t1,0			# Loads direction (0 = Down)
					sh t1,4(t0)		# Stores in player status
				AFTER_LEVEL3_POSITION:
					# Stores Map1's address in LEVEL_MAP, so that rendering trail works propperly
					la t0,Map3.1
					la t1,LEVEL_MAP
					sw t0,0(t1)
					
					la t0,Map3.1_Hit
					la t1,LEVEL_HIT_MAP
					sw t0,0(t1)
					
					j START_SETUP
			LEVEL3.2_SETUP:
				# Pre-render map
				li s0,0
				renderi(Map3.2,0,0,320,240,s0,0,0)
				li s0,1
				renderi(Map3.2,0,0,320,240,s0,0,0)
				li s0,0
			
				# Sets Warp Boxes and Positions
				set_position(Warp_Box_1,0,0)
				set_position(Warp_Pos_1,248,216)
				set_warp(Warp_Pos_1,1)
				
				set_position(Warp_Box_2,0,238)
				set_position(Warp_Pos_2,200,4)
				set_warp(Warp_Pos_2,3)
				# Sets Sprites Positions
				
				set_position_mov(ULA_Pos_0,96,100)
				set_enemy(ULA_0,1,40,1000,1,ULA_Process_3.2.0)
				set_position_mov(ULA_Pos_1,152,112)
				set_enemy(ULA_1,1,40,1000,1,ULA_Process_3.2.1)
				set_position_mov(ULA_Pos_2,188,156)
				set_enemy(ULA_2,1,40,1000,1,ULA_Process_3.2.2)
				
				# Stores Map1's address in LEVEL_MAP, so that rendering trail works propperly
				la t0,Map3.2
				la t1,LEVEL_MAP
				sw t0,0(t1)
				
				la t0,Map3.2_Hit
				la t1,LEVEL_HIT_MAP
				sw t0,0(t1)
				
				j START_SETUP
			LEVEL3.3_SETUP:
				# Pre-render map
				li s0,0
				renderi(Map3.3,0,0,320,240,s0,0,0)
				li s0,1
				renderi(Map3.3,0,0,320,240,s0,0,0)
				li s0,0
			
				# Sets Warp Boxes and Positions
				set_position(Warp_Box_1,0,4)
				set_position(Warp_Pos_1,248,216)
				set_warp(Warp_Pos_1,4)
				
				set_position(Warp_Box_2,0,0)	# Can't be 0,0 otherwise will conflict with Warp_Box_1
				set_position(Warp_Pos_2,200,216)
				set_warp(Warp_Pos_2,2)
				
				
				
				# Sets Sprites Positions
				set_position(Door_H_Pos1,92,160)
				set_position_with_hitbox(Chest_Pos1,100,216,Chest_Hitbox1,4,4)
				
				set_position_mov(ULA_Pos_0,60,36)
				set_enemy(ULA_0,1,40,500,1,ULA_Process_3.3.0)
				set_position_mov(ULA_Pos_1,192,44)
				set_enemy(ULA_1,1,40,1200,1,ULA_Process_3.3.1)
				
				# Stores Map3.3's address in LEVEL_MAP, so that rendering trail works propperly
				la t0,Map3.3
				la t1,LEVEL_MAP
				sw t0,0(t1)
				
				la t0,Map3.3_Hit
				la t1,LEVEL_HIT_MAP
				sw t0,0(t1)
				
				j START_SETUP
			LEVEL3.4_SETUP:
				# Pre-render map
				li s0,0
				renderi(Map3.4,0,0,320,240,s0,0,0)
				li s0,1
				renderi(Map3.4,0,0,320,240,s0,0,0)
				li s0,0
			
				# Sets Warp Boxes and Positions
				set_position(Warp_Box_1,0,0)
				set_position(Warp_Pos_1,200,216)
				set_warp(Warp_Pos_1,1)
				
				set_position(Warp_Box_2,270,0)
				set_position(Warp_Pos_2,4,4)
				set_warp(Warp_Pos_2,3)
				# Sets Sprites Positions
				set_position_with_hitbox(Chest_Pos1,24,96,Chest_Hitbox1,4,4)
				
				set_position(Slime_Pos_0,56,16)
				set_enemy(Slime_0,1,40,100,2,Slime_Process_3.4.0)
				set_position(Slime_Pos_1,136,128)
				set_enemy(Slime_1,1,40,100,2,Slime_Process_3.4.1)
				
				set_position_mov(ULA_Pos_0,208,48)
				set_enemy(ULA_0,1,40,1000,1,ULA_Process_3.4.0)
				set_position_mov(ULA_Pos_1,152,40)
				set_enemy(ULA_1,1,40,500,1,ULA_Process_3.4.1)
				set_position_mov(ULA_Pos_2,40,136)
				set_enemy(ULA_2,1,40,500,1,ULA_Process_3.4.2)
				
				# Stores Map3.4's address in LEVEL_MAP, so that rendering trail works propperly
				la t0,Map3.4
				la t1,LEVEL_MAP
				sw t0,0(t1)
				
				la t0,Map3.4_Hit
				la t1,LEVEL_HIT_MAP
				sw t0,0(t1)
				
				j START_SETUP
					
	START_SETUP:			
		li a7,30	# gets time passed
		ecall 		# syscall
		la t0,RUN_TIME	# Loads RUN_TIME address
		sw a0,0(t0)	# new time is stored in RUN_TIME, in order to be compared later
		j ENGINE_LOOP # Start game loop	
	
ENGINE_LOOP:
	call PLAY_SOUND

	li a7,30		#gets time passed
	ecall 			# syscall
	la t0,RUN_TIME		# Loads RUN_TIME address
	lw t1,0(t0)		# loads last time stored
	sub t1,a0,t1		# new time - old time
	li t2,frame_rate	# loads frame rate (T ms per frame)
	bge t1,t2,GAME_LOOP	# if new time - old time >= frame rate (T ms per frame), go into game loop,
	j ENGINE_LOOP		# otherwise go back to the begining of loop
	GAME_LOOP:

		call INPUT_CHECK	# Checks if there is player input
		
		call UPDATE_ENEMIES	# Updates enemies based on their level's pattern
		
		call LEVEL_CHECK	# Checks what level is the player in, in order to render propper entities
						
		call RENDER_PLAYER	# Renders player
		
		call RENDER_MAGIC	# Renders player magic based on the colisions
	
		call RENDER_UI_INFO	# Renders UI informations
												
		show_frame(s0)		# Shows frame s0
		
		call MAGIC_COLISION	# Checks level colision for player's magic
			
		call ULA_MAGIC_COLISION	# and for enemies' magic
		
		remove_trail(PLYR_POS,LEVEL_MAP,32,32)	# Removes player trail
		
		switch_frame_value() # Switches s0
		
		call GAME_TIMER_UPDATE	# Updates timer/health
				
		j ENGINE_LOOP	# Returns to Engine Loop

		
LEVEL_CHECK:
	la t0, LEVEL_INFO	# Checks current level
	lh t0,0(t0)
	li t1,1
	bne t1,t0,SKIP_LEVEL1
	j LEVEL1
	SKIP_LEVEL1:
	li t1,2
	bne t1,t0,SKIP_LEVEL2
	j LEVEL2
	SKIP_LEVEL2:
	li t1,3
	bne t1,t0,SKIP_LEVEL3
	j LEVEL3
	SKIP_LEVEL3:
	li t1,4
	bne t1,t0,SKIP_LEVEL4
	j LEVEL4
	SKIP_LEVEL4:
	ret
	
	LEVEL1:
		reset_soundtrack(LVL1_MSC)	# Sets music for LVL1

		la t0, LEVEL_INFO	# Loads LEVEL_INFO address
		lh t0,2(t0)		# Checks what section of the level it is at
		li t1,1			# and if it equals to 1,
		bne t1,t0,SKIP_LEVEL1.1	# it'll go to to the first level 1 section
		j LEVEL1.1
		SKIP_LEVEL1.1:
		li t1,2			# otherwise, if it equals to 1 (Level 1.2)
		bne t1,t0,SKIP_LEVEL1.2	# it'll go to to the second level 1 section
		j LEVEL1.2
		SKIP_LEVEL1.2:
		
		LEVEL1.1:
			# Rendering Background animation (waves)
			LV1.1_BACKGROUNDS:
				la t0,WAVE_DOWN_1.1_POS		# Loads address of wave down position
				lh a1,0(t0)			# X coordinate where rendering will start (top left)
				lh a2,2(t0)			# Y coordinate where rendering will start (top left)
				la t0,WAVE_DOWN_1.1_STATUS	# Loads WAVE_DOWN_1.1_STATUS address
				lh a6,0(t0)			# Loads Wave Status
				render(Waves_Down_1.1,a1,a2,236,16,s0,a6,0)
				
				la t0,WAVE_DOWN_1.1_STATUS	# Loads WAVE_DOWN_1.1_STATUS address
				lh t1,4(t0)			# Loads status information and checks
				bnez t1,LV1.1_NO_TIMER_WAVE_DOWN # whether program should get timer or not
				LV1.1_GET_TIMER_WAVE_DOWN:
					li t1,1		# t1 = 1,
					sh t1,4(t0)	# meaning it won't get the time next turn
					
					li a7,30	# gets time passed
					ecall 		# syscall
					la t0,WAVE_DOWN_1.1_timer	# Loads RUN_TIME address
					sw a0,0(t0)	# new time is stored in RUN_TIME, in order to be compared later
				LV1.1_NO_TIMER_WAVE_DOWN:	
					li a7,30	# gets time passed
					ecall 		# syscall
					la t0,WAVE_DOWN_1.1_timer	# Loads RUN_TIME address
					lw a1,0(t0)	# loads old time from RUN_TIME, in order to be compared later
					sub a0,a0,a1	# a0 -= a1,
					li t0,backgroud_delay	# and if the result is greater or equal than backgroud_delay time
					bge t0,a0,LV1.1_DONT_UPDATE_WAVE_DOWN	# branch to LV1.1_DONT_UPDATE_WAVE_DOWN ( animation still playing )
					LV1.1_UPDATE_WAVE_DOWN:
						sprite_status_update(WAVE_DOWN_1.1_STATUS, 2, 2) # otherwise, update sprite status
						la t0,WAVE_DOWN_1.1_STATUS	# Loads WAVE_DOWN_1.1_STATUS
						li t1,0				# t1 = 0 and stores it, so that the
						sh t1,4(t0)			# program gets timer next turn
					LV1.1_DONT_UPDATE_WAVE_DOWN:
				# Rendering WAVE_LEFT
				la t0,WAVE_LEFT_1.1_POS		# Loads address of wave down position
				lh a1,0(t0)			# X coordinate where rendering will start (top left)
				lh a2,2(t0)			# Y coordinate where rendering will start (top left)
				la t0,WAVE_LEFT_1.1_STATUS	# Loads WAVE_LEFT_1.1_STATUS address
				lh a6,0(t0)			# Loads Wave Status
				render(Waves_Left_1.1,a1,a2,16,192,s0,a6,0)
				
				la t0,WAVE_LEFT_1.1_STATUS	# Loads WAVE_LEFT_1.1_STATUS address
				lh t1,4(t0)			# Loads status information and checks
				bnez t1,LV1.1_NO_TIMER_WAVE_LEFT # whether program should get timer or not
				LV1.1_GET_TIMER_WAVE_LEFT:
					li t1,1		# t1 = 1,
					sh t1,4(t0)	# meaning it won't get the time next turn
					
					li a7,30	# gets time passed
					ecall 		# syscall
					la t0,WAVE_LEFT_1.1_timer	# Loads RUN_TIME address
					sw a0,0(t0)	# new time is stored in RUN_TIME, in order to be compared later
				LV1.1_NO_TIMER_WAVE_LEFT:	
					li a7,30	# gets time passed
					ecall 		# syscall
					la t0,WAVE_LEFT_1.1_timer	# Loads RUN_TIME address
					lw a1,0(t0)	# loads old time from RUN_TIME, in order to be compared later
					sub a0,a0,a1	# a0 -= a1,
					li t0,backgroud_delay	# and if the result is greater or equal than backgroud_delay time
					bge t0,a0,LV1.1_DONT_UPDATE_WAVE_LEFT	# branch to LV1.1_DONT_UPDATE_WAVE_LEFT ( animation still playing )
					LV1.1_UPDATE_WAVE_LEFT:
						sprite_status_update(WAVE_LEFT_1.1_STATUS, 2, 2) # otherwise, update sprite status
						la t0,WAVE_LEFT_1.1_STATUS	# Loads WAVE_LEFT_1.1_STATUS
						li t1,0				# t1 = 0 and stores it, so that the
						sh t1,4(t0)			# program gets timer next turn
					LV1.1_DONT_UPDATE_WAVE_LEFT:
				
			# There are no doors in Level 1.1
			# There are no keys in Level 1.1
			LV1.1_CHESTS: # Chests Rendering
				la t0, Chest_Status1
				lh t1,0(t0)
				beqz t1, LV1.1_CHEST1_NOT_COLLECTED
				LV1.1_CHEST1_COLLECTED:
					j LV1.1_ENEMIES
				LV1.1_CHEST1_NOT_COLLECTED:
					la t0,Chest_Pos1		# Loads address of door position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)					
					li a6, 0
					render(ChestB,a1,a2,16,16,s0,a6,0)
					j LV1.1_ENEMIES
			LV1.1_ENEMIES:
				la t0,Slime_Pos_0
				lh a1,0(t0)
				lh a1,0(t0)		# X coordinate where rendering will start (top left)
				lh a2,2(t0)		# Y coordinate where rendering will start (top left)					
				la t0,Slime_Status_0
				lh a6,0(t0)
				render_enemy(Slime_0)
				remove_trail(Slime_Pos_0,LEVEL_MAP,24,24)
				render_enemy(Slime_1)
				remove_trail(Slime_Pos_1,LEVEL_MAP,24,24)
				ret
			
		LEVEL1.2:	
			LV1.2_DOORS: # Doors rendering
				la t0, Door_H_Status1
				lh t1,0(t0)
				beqz t1, LV1.2_DOOR1_CLOSED
				LV1.2_DOOR1_OPEN:
					la t0,Door_H_Pos1	# Loads address of door position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)
					la t0, Door_H_Status1					
					lh a6, 0(t0)	
					render(Wood_Door_H,a1,a2,32,12,s0,a6,0)
					j LV1.2_KEYS
				LV1.2_DOOR1_CLOSED:		
					la t0,Door_H_Pos1	# Loads address of door position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)
					la t0, Door_H_Status1					
					lh a6, 0(t0)	
					render(Wood_Door_H,a1,a2,32,12,s0,a6,0)
					j LV1.2_KEYS
			LV1.2_KEYS: # Keys Rendering
				la t0, Key_Status1
				lh t1,0(t0)
				beqz t1, LV1.2_KEY1_NOT_COLLECTED
				LV1.2_KEY1_COLLECTED:
					j LV1.2_ENEMIES
				LV1.2_KEY1_NOT_COLLECTED:
					la t0,Key_Pos1		# Loads address of door position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)					
					li a6, 0
					render(KeyB,a1,a2,16,16,s0,a6,0)
					j LV1.2_ENEMIES
			LV1.2_ENEMIES:
				render_enemy(Slime_0)
				remove_trail(Slime_Pos_0,LEVEL_MAP,24,24)
				render_enemy(Slime_1)
				remove_trail(Slime_Pos_1,LEVEL_MAP,24,24)
				render_enemy(Slime_2)
				remove_trail(Slime_Pos_2,LEVEL_MAP,24,24)
				render_enemy(Slime_3)
				remove_trail(Slime_Pos_3,LEVEL_MAP,24,24)
				ret		
		
	LEVEL2:
		reset_soundtrack(LVL2_MSC)	# Sets music for LVL2

		la t0, LEVEL_INFO	# Loads LEVEL_INFO address
		lh t0,2(t0)		# Checks what section of the level it is at
		li t1,1			# and if it equals to 1,
		bne t1,t0,SKIP_LEVEL2.1	# it'll go to to the first level 2 section
		j LEVEL2.1
		SKIP_LEVEL2.1:
		li t1,2			# otherwise, if it equals to 1 (Level 2.2)
		bne t1,t0,SKIP_LEVEL2.2	# it'll go to to the second level 2 section
		j LEVEL2.2
		SKIP_LEVEL2.2:
		li t1,3			# otherwise, if it equals to 2 (Level 2.3)
		bne t1,t0,SKIP_LEVEL2.3	# it'll go to to the third level 2 section
		j LEVEL2.3
		SKIP_LEVEL2.3:
		
		LEVEL2.1:	
			LV2.1_DOORS: # Doors rendering
				la t0, Door_V_Status1
				lh t1,0(t0)
				beqz t1, LV2.1_DOOR1_CLOSED
				LV2.1_DOOR1_OPEN:
					la t0,Door_V_Pos1	# Loads address of door position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)
					la t0, Door_V_Status1					
					lh a6, 0(t0)
					render(Jungle_Door_V,a1,a2,8,38,s0,a6,0)
					j LV2.1_KEYS
				LV2.1_DOOR1_CLOSED:		
					la t0,Door_V_Pos1	# Loads address of door position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)
					la t0, Door_V_Status1					
					lh a6, 0(t0)	
					render(Jungle_Door_V,a1,a2,8,38,s0,a6,0)
					j LV2.1_KEYS
			LV2.1_KEYS: # Keys Rendering
				la t0, Key_Status1
				lh t1,0(t0)
				beqz t1, LV2.1_KEY1_NOT_COLLECTED
				LV2.1_KEY1_COLLECTED:
					j LV2.1_ENEMIES
				LV2.1_KEY1_NOT_COLLECTED:
					la t0,Key_Pos1		# Loads address of key position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)					
					li a6, 0
					render(KeyY,a1,a2,16,16,s0,a6,0)
					j LV2.1_ENEMIES
			LV2.1_ENEMIES:
				render_enemy(Slime_0)
				remove_trail(Slime_Pos_0,LEVEL_MAP,24,24)
				render_enemy(Slime_1)
				remove_trail(Slime_Pos_1,LEVEL_MAP,24,24)
				render_enemy(Slime_2)
				remove_trail(Slime_Pos_2,LEVEL_MAP,24,24)
				render_enemy(Slime_3)
				remove_trail(Slime_Pos_3,LEVEL_MAP,24,24)
				ret
		LEVEL2.2:	
			LV2.2_DOORS: # Doors rendering
				# Linking Both Doors
				la t0, Door_H_Status1
				lh t1,0(t0)
				la t0, Door_H_Status2
				lh t2,0(t0)
				beq t1,t2,LV2.2_LINKED
				li t3,1	# Priority status
				beq t2,t3, LV2.2_LINK_V2
				LV2.2_LINK_V1:	# Door H_1 is open and H_2 isn't
					la t0, Door_H_Status2
					sh t1,0(t0)
					remove_static_trail(Door_H_Pos2,LEVEL_MAP,32,12)
					j LV2.2_LINKED
				LV2.2_LINK_V2:	# Door H_2 is open and H_1 isn't
					la t0, Door_H_Status1
					sh t2,0(t0)
					remove_static_trail(Door_H_Pos1,LEVEL_MAP,32,12)
					j LV2.2_LINKED
				LV2.2_LINKED:
					la t0, Door_H_Status1
					lh t1,0(t0)
					beqz t1, LV2.2_DOOR1_CLOSED
					LV2.2_DOOR1_OPEN:
						la t0,Door_H_Pos1	# Loads address of door position
						lh a1,0(t0)		# X coordinate where rendering will start (top left)
						lh a2,2(t0)		# Y coordinate where rendering will start (top left)
						la t0, Door_H_Status1					
						lh a6, 0(t0)
						render(Jungle_Door_H,a1,a2,32,12,s0,a6,0)
						la t0,Door_H_Pos2	# Loads address of door position
						lh a1,0(t0)		# X coordinate where rendering will start (top left)
						lh a2,2(t0)		# Y coordinate where rendering will start (top left)
						la t0, Door_H_Status2					
						lh a6, 0(t0)
						render(Jungle_Door_H,a1,a2,32,12,s0,a6,0)
						j LV2.2_KEYS
					LV2.2_DOOR1_CLOSED:		
						la t0,Door_H_Pos1	# Loads address of door position
						lh a1,0(t0)		# X coordinate where rendering will start (top left)
						lh a2,2(t0)		# Y coordinate where rendering will start (top left)
						la t0, Door_H_Status1					
						lh a6, 0(t0)	
						render(Jungle_Door_H,a1,a2,32,12,s0,a6,0)
						la t0,Door_H_Pos2	# Loads address of door position
						lh a1,0(t0)		# X coordinate where rendering will start (top left)
						lh a2,2(t0)		# Y coordinate where rendering will start (top left)
						la t0, Door_H_Status2					
						lh a6, 0(t0)
						render(Jungle_Door_H,a1,a2,32,12,s0,a6,0)
						j LV2.2_KEYS
			LV2.2_KEYS: # Keys Rendering
				la t0, Key_Status2
				lh t1,0(t0)
				beqz t1, LV2.2_KEY2_NOT_COLLECTED
				LV2.2_KEY2_COLLECTED:
					j LV2.2_CHESTS
				LV2.2_KEY2_NOT_COLLECTED:
					la t0,Key_Pos2		# Loads address of key position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)					
					li a6, 0
					render(KeyY,a1,a2,16,16,s0,a6,0)
					j LV2.2_CHESTS
			LV2.2_CHESTS: # Chests Rendering
				la t0, Chest_Status1
				lh t1,0(t0)
				beqz t1, LV2.2_CHEST1_NOT_COLLECTED
				LV2.2_CHEST1_COLLECTED:
					j LV2.2_ENEMIES
				LV2.2_CHEST1_NOT_COLLECTED:
					la t0,Chest_Pos1		# Loads address of door position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)					
					li a6, 0
					render(ChestY,a1,a2,16,16,s0,a6,0)
					j LV2.2_ENEMIES
			LV2.2_ENEMIES:
				render_enemy(Slime_0)
				remove_trail(Slime_Pos_0,LEVEL_MAP,24,24)
				render_enemy(ULA_0)
				remove_trail(ULA_Pos_0,LEVEL_MAP,24,24)
				render_enemy(ULA_1)
				remove_trail(ULA_Pos_1,LEVEL_MAP,24,24)
				render_enemy(ULA_2)
				remove_trail(ULA_Pos_2,LEVEL_MAP,24,24)
				ret
		LEVEL2.3:
			LV2.3_BATTERIES: # Batteries Rendering
				la t0, Battery_Status1
				lh t1,0(t0)
				beqz t1, LV2.3_BATTERY1_NOT_COLLECTED
				LV2.3_BATTERY1_COLLECTED:
					j LV2.3_ENEMIES
				LV2.3_BATTERY1_NOT_COLLECTED:
					la t0,Battery_Pos1	# Loads address of door position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)					
					li a6, 0
					render(Battery,a1,a2,16,16,s0,a6,0)
					j LV2.3_ENEMIES
			LV2.3_ENEMIES:
				render_enemy(Slime_0)
				remove_trail(Slime_Pos_0,LEVEL_MAP,24,24)
				render_enemy(Slime_2)
				remove_trail(Slime_Pos_2,LEVEL_MAP,24,24)
				render_enemy(ULA_0)
				remove_trail(ULA_Pos_0,LEVEL_MAP,24,24)
				render_enemy(ULA_1)
				remove_trail(ULA_Pos_1,LEVEL_MAP,24,24)
				render_enemy(ULA_2)
				remove_trail(ULA_Pos_2,LEVEL_MAP,24,24)
				render_enemy(ULA_3)
				remove_trail(ULA_Pos_3,LEVEL_MAP,24,24)
				
				ret	
	LEVEL3:
		reset_soundtrack(LVL3_MSC)	# Sets music for LVL3

		la t0, LEVEL_INFO	# Loads LEVEL_INFO address
		lh t0,2(t0)		# Checks what section of the level it is at
		li t1,1			# and if it equals to 1,
		bne t1,t0,SKIP_LEVEL3.1	# it'll go to to the first level 3 section
		j LEVEL3.1
		SKIP_LEVEL3.1:
		li t1,2			# otherwise, if it equals to 2 (Level 3.2)
		bne t1,t0,SKIP_LEVEL3.2	# it'll go to to the second level 2 section
		j LEVEL3.2
		SKIP_LEVEL3.2:
		li t1,3			# otherwise, if it equals to 3 (Level 3.3)
		bne t1,t0,SKIP_LEVEL3.3	# it'll go to to the third level 3 section
		j LEVEL3.3
		SKIP_LEVEL3.3:
		li t1,4			# otherwise, if it equals to 4 (Level 3.4)
		bne t1,t0,SKIP_LEVEL3.4	# it'll go to to the fourth level 3 section
		j LEVEL3.4
		SKIP_LEVEL3.4:
		
		LEVEL3.1:	
			# There are no doors in Level 1.1
			LV3.1_BATTERIES: # Batteries Rendering
				la t0, Battery_Status1
				lh t1,0(t0)
				beqz t1, LV3.1_BATTERY1_NOT_COLLECTED
				LV3.1_BATTERY1_COLLECTED:
					j LV3.1_KEYS
				LV3.1_BATTERY1_NOT_COLLECTED:
					la t0,Battery_Pos1	# Loads address of door position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)					
					li a6, 0
					render(Battery,a1,a2,16,16,s0,a6,0)
					j LV3.1_KEYS
					
			LV3.1_KEYS: # Keys Rendering
				la t0, Key_Status1
				lh t1,0(t0)
				beqz t1, LV3.1_KEY1_NOT_COLLECTED
				LV3.1_KEY1_COLLECTED:
					j LV3.1_ENEMIES
				LV3.1_KEY1_NOT_COLLECTED:
					la t0,Key_Pos1		# Loads address of key position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)					
					li a6, 0
					render(KeyY,a1,a2,16,16,s0,a6,0)
					j LV3.1_ENEMIES
			LV3.1_ENEMIES:
				render_enemy(ULA_0)
				remove_trail(ULA_Pos_0,LEVEL_MAP,24,24)
				render_enemy(ULA_1)
				remove_trail(ULA_Pos_1,LEVEL_MAP,24,24)
				ret
		LEVEL3.2:
			LV3.2_ENEMIES:
				render_enemy(ULA_0)
				remove_trail(ULA_Pos_0,LEVEL_MAP,24,24)
				render_enemy(ULA_1)
				remove_trail(ULA_Pos_1,LEVEL_MAP,24,24)
				render_enemy(ULA_2)
				remove_trail(ULA_Pos_2,LEVEL_MAP,24,24)
				ret
		LEVEL3.3:
			LV3.3_DOORS: # Doors rendering
				la t0, Door_H_Status1
				lh t1,0(t0)
				beqz t1, LV3.3_DOOR1_CLOSED
				LV3.3_DOOR1_OPEN:
					la t0,Door_H_Pos1	# Loads address of door position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)
					la t0, Door_H_Status1					
					lh a6, 0(t0)
					render(Magma_Door_H,a1,a2,32,54,s0,a6,0)
					j LV3.3_CHESTS
				LV3.3_DOOR1_CLOSED:		
					la t0,Door_H_Pos1	# Loads address of door position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)
					la t0, Door_H_Status1					
					lh a6, 0(t0)	
					render(Magma_Door_H,a1,a2,32,54,s0,a6,0)
					j LV3.3_CHESTS
			
			LV3.3_CHESTS: # Chests Rendering
				la t0, Chest_Status1
				lh t1,0(t0)
				beqz t1, LV3.3_CHEST1_NOT_COLLECTED
				LV3.3_CHEST1_COLLECTED:
					j LV3.3_ENEMIES
				LV3.3_CHEST1_NOT_COLLECTED:
					la t0,Chest_Pos1		# Loads address of door position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)					
					li a6, 0
					render(ChestY,a1,a2,16,16,s0,a6,0)
					j LV3.3_ENEMIES
			LV3.3_ENEMIES:
				render_enemy(ULA_0)
				remove_trail(ULA_Pos_0,LEVEL_MAP,24,24)
				render_enemy(ULA_1)
				remove_trail(ULA_Pos_1,LEVEL_MAP,24,24)
				ret
		LEVEL3.4:
			LV3.4_CHESTS: # Chests Rendering
				la t0, Chest_Status1
				lh t1,0(t0)
				beqz t1, LV3.4_CHEST1_NOT_COLLECTED
				LV3.4_CHEST1_COLLECTED:
					j LV3.4_ENEMIES
				LV3.4_CHEST1_NOT_COLLECTED:
					la t0,Chest_Pos1		# Loads address of door position
					lh a1,0(t0)		# X coordinate where rendering will start (top left)
					lh a2,2(t0)		# Y coordinate where rendering will start (top left)					
					li a6, 0
					render(ChestY,a1,a2,16,16,s0,a6,0)
					j LV3.4_ENEMIES
			LV3.4_ENEMIES:
				render_enemy(Slime_0)
				remove_trail(Slime_Pos_0,LEVEL_MAP,24,24)
				render_enemy(Slime_1)
				remove_trail(Slime_Pos_1,LEVEL_MAP,24,24)
				
				render_enemy(ULA_0)
				remove_trail(ULA_Pos_0,LEVEL_MAP,24,24)
				render_enemy(ULA_1)
				remove_trail(ULA_Pos_1,LEVEL_MAP,24,24)
				render_enemy(ULA_2)
				remove_trail(ULA_Pos_2,LEVEL_MAP,24,24)
				ret
	LEVEL4:
		ret

GAME_TIMER_UPDATE:		
	la t0,GAME_TIMER	# Loads GAME_TIMER address (see in .data to see its functions)
	lh t1,0(t0)		# Loads number of times the game loop has been entered
	addi t1,t1,1		# and adds 1 to it,
	sh t1,0(t0)		# then stores the updated counter in the same place
	li t2,update_timer_rate	# Loads update_timer_rate
	bne t2,t1,NOT1SECOND	# and checks if it is the same as the GAME_TIMER counter, going to PASSED1SECOND
	PASSED1SECOND:	# Will update GAME_TIMER, saying 1 in-game second has passed, discounting it on player's health
		li t2,0		# Loads 0 to t2
		sh t2,0(t0)	# and stores it on GAME_TIMER, so that the counter is reset
		lh t1,2(t0)	# Loads the GAME_TIMER timer (time passed in-game)
		addi t1,t1,1	# and adds 1 to it,
		sh t1,2(t0)	# storing it afterwards in the same place
		la t0,PLYR_INFO	# Loads PLAYER_INFO address
		lh t1,0(t0)	# Loads player's health
		addi t1,t1,-1	# and subtracts 1 from it (since health is tied to time passed),
		sh t1,0(t0)	# storing it afterwards in the same place
	NOT1SECOND:
		la t0,PLYR_INFO	# Loads PLAYER_INFO address
		lh t1,0(t0)	# Loads player's health
		blez t1, KILL_PLYR # If Player's health <= 0, he dies
		li a7,30	# gets time passed
		ecall 		# syscall
		la t0,RUN_TIME	# Loads RUN_TIME address
		sw a0,0(t0)	# new time is stored in RUN_TIME, in order to be compared later		
		ret			
	
	KILL_PLYR:
		call STOP_SOUND
		reset_soundtrack(DEATH_MSC)	# Sets music for MENU
	
		la t0,LEVEL_INFO
		lh t0,0(t0)
		beqz t0,NO_INPUT_MENU	# If t2 = 0, it is on menu
		li a6,0
		la t0,DEATH_ITERATOR	# Loads DEATH_ITERATOR address
		sh a6,0(t0)		# and stores status for animation
		
		DEATH_LOOP:			
			li a7,30		# gets time passed
			ecall 			# syscall
			la t0,DEATH_TIMER	# Loads DEATH_TIMER address
			sw a0,0(t0)		# new time is stored in DEATH_TIMER, in order to be compared later
	
		DEATH_TIMER_LOOP:	# Start animation loop	


			li a7,30			#gets time passed
			ecall 				# syscall
			la t0,DEATH_TIMER		# Loads DEATH_TIMER address
			lw t1,0(t0)			# loads last time stored
			sub t1,a0,t1			# new time - old time
			li t2,death_time		# loads death_time (ms)
			bge t1,t2,PRINT_ANIMATION	# if new time - old time >= death_time (ms), go into game loop,
			j DEATH_TIMER_LOOP		# otherwise go back to the begining of loop
	
		PRINT_ANIMATION:	# Rendering all frames

			la t0,PLYR_INFO	# Loads PLAYER_INFO address
			li t1,0		# Making sure player's health = 0 (if coming from input check)
			sh t1,0(t0)	# Loads player's health	
			
			# Printing Death animation
			la a0,PLYR_POS		# Loads address of player position
			lh s1,0(a0)		# Gets player X
			lh s2,2(a0)		# Gets player Y
			# Gets coordinate from Death Image (620 x 456) based on player's position
			neg s1,s1		# s1 = -X
			addi s1,s1,298		# s1 = 298 - X
			neg s2,s2		# s2 = -Y
			addi s2,s2,216		# s2 = 216 - Y
			
			la t0,DEATH_ITERATOR	# Loads DEATH_ITERATOR address
			lh a6,0(t0)		# Gets status for animation
			render_big(Death_Anm,0,0,320,240,s0,a6,2,s1,s2,620,456)	# Renders circle arround player
			addi a6,a6,1		# adds 1 to a6
			la t0,DEATH_ITERATOR	# Loads DEATH_ITERATOR address
			sh a6,0(t0)		# Stores new status for animation
			
			show_frame(s0)		# Shows frame s0
		
			remove_trail(PLYR_POS,LEVEL_MAP,32,32)	# Removes player trail
					
			switch_frame_value()
			
			# Checking loop condition
			la t0,DEATH_ITERATOR	# Loads DEATH_ITERATOR address
			lh a6,0(t0)		# Gets status for animation
			li t0,5			# If a6 < 5 (number of frames this animation has)
			blt a6,t0,DEATH_LOOP	# continue loop, otherwise, get out of loop
		
		
		# Rendering once more the last frame of the animation on the other frame
		la t0,PLYR_INFO	# Loads PLAYER_INFO address
		li t1,0		# Making sure player's health = 0 (if coming from input check)
		sh t1,0(t0)	# Loads player's health	
		
		# Printing Death animation
		la a0,PLYR_POS		# Loads address of player position
		lh s1,0(a0)		# Gets player X
		lh s2,2(a0)		# Gets player Y
		# Gets coordinate from Death Image (620 x 456) based on player's position
		neg s1,s1		# s1 = -X
		addi s1,s1,298		# s1 = 298 - X
		neg s2,s2		# s2 = -Y
		addi s2,s2,216		# s2 = 216 - Y
		
		li a6,4
		render_big(Death_Anm,0,0,320,240,s0,a6,2,s1,s2,620,456)	# Renders circle arround player
		
		# Pause for reflection that you're a noob :)
		PAUSE_LOOP:
			li a7,30		# gets time passed
			ecall 			# syscall
			la t0,DEATH_TIMER	# Loads DEATH_TIMER address
			sw a0,0(t0)		# new time is stored in DEATH_TIMER, in order to be compared later
			
		PAUSE_TIMER_LOOP:		# Start animation loop	
			call PLAY_SOUND
			li a7,30			#gets time passed
			ecall 				# syscall
			la t0,DEATH_TIMER		# Loads DEATH_TIMER address
			lw t1,0(t0)			# loads last time stored
			sub t1,a0,t1			# new time - old time
			li t2,3000		# loads death_time (ms)
			bge t1,t2,GAME_OVER	# if new time - old time >= death_time (ms), go into game loop,
			j PAUSE_TIMER_LOOP		# otherwise go back to the begining of loop
		
		# Game over animation
		GAME_OVER:
		li a6,0	
		GAME_OVER_LOOP:
			li a7,30		# gets time passed
			ecall 			# syscall
			la t0,DEATH_TIMER	# Loads DEATH_TIMER address
			sw a0,0(t0)		# new time is stored in DEATH_TIMER, in order to be compared later
			
		GAME_OVER_TIMER_LOOP:		# Start animation loop	
			call PLAY_SOUND
		
			li a7,30			#gets time passed
			ecall 				# syscall
			la t0,DEATH_TIMER		# Loads DEATH_TIMER address
			lw t1,0(t0)			# loads last time stored
			sub t1,a0,t1			# new time - old time
			li t2,game_over_time		# loads death_time (ms)
			bge t1,t2,PRINT_ANIMATION_G.O	# if new time - old time >= death_time (ms), go into game loop,
			j GAME_OVER_TIMER_LOOP		# otherwise go back to the begining of loop
			
		PRINT_ANIMATION_G.O:
		
			
			li a1,0		# X coordinate where rendering will start (top left)
			li a2,0 	# Y coordinate where rendering will start (top left)
			render(Game_Over_Anm,a1,a2,320,240,s0,a6,0)	# Renders game over screen appearing slowly
			addi a6,a6,1		# adds 1 to a6
			
			show_frame(s0)		# Shows frame s0
				
			switch_frame_value()
			
			# Checking loop condition
			li t0,10			# If a6 < 10 (number of frames this animation has)
			blt a6,t0,GAME_OVER_LOOP	# continue loop, otherwise, get out of loop
		
		la t0, LEVEL_INFO	# Loads LEVEL_INFO address
		li t1,0			# Loads 0 to t1
		sh t1,0(t0)		# and stores 0 in LEVEL_INFO (Menu)
		li t1,1			# Loads 1 to t1
		sh t1,2(t0)		# and stores 1 in LEVEL_INFO section (Game over menu)
		j MENU

END_ANM:
	reset_soundtrack(END_GAME_MSC)	# Sets music for END GAME
			
	li a6,0	
	END_ANM_LOOP:
		li a7,30		# gets time passed
		ecall 			# syscall
		la t0,RUN_TIME		# Loads DEATH_TIMER address
		sw a0,0(t0)		# new time is stored in DEATH_TIMER, in order to be compared later
		
	END_ANM_TIMER_LOOP:		# Start animation loop	
		
		li a7,30			#gets time passed
		ecall 				# syscall
		la t0,RUN_TIME			# Loads DEATH_TIMER address
		lw t1,0(t0)			# loads last time stored
		sub t1,a0,t1			# new time - old time
		li t2,300		# loads game over time (ms)
		bge t1,t2,PRINT_ANIMATION_END_ANM	# if new time - old time >= death_time (ms), go into game loop,
		j END_ANM_TIMER_LOOP		# otherwise go back to the begining of loop
		
	PRINT_ANIMATION_END_ANM:
		li a1,0		# X coordinate where rendering will start (top left)
		li a2,0 	# Y coordinate where rendering will start (top left)
		render(End_Anm,a1,a2,320,240,s0,a6,0)	# Renders game over screen appearing slowly
		addi a6,a6,1		# adds 1 to a6
		
		show_frame(s0)		# Shows frame s0
			
		switch_frame_value()
		
		# Checking loop condition
		li t0,3				# If a6 < 6 (number of frames this animation has)
		blt a6,t0,END_ANM_LOOP	# continue loop, otherwise, get out of loop
	
	PAUSE_END_LOOP:
			li a7,30		# gets time passed
			ecall 			# syscall
			la t0,RUN_TIME	# Loads DEATH_TIMER address
			sw a0,0(t0)		# new time is stored in DEATH_TIMER, in order to be compared later
			
		PAUSE_END_TIMER_LOOP:		# Start animation loop	
			call PLAY_SOUND
		
			li a7,30			#gets time passed
			ecall 				# syscall
			la t0,RUN_TIME		# Loads DEATH_TIMER address
			lw t1,0(t0)			# loads last time stored
			sub t1,a0,t1			# new time - old time
			li t2,10000		
			bge t1,t2,END_PROCESS	# if new time - old time >= death_time (ms), go into game loop,
			j PAUSE_END_TIMER_LOOP		# otherwise go back to the begining of loop
	END_PROCESS:
	la t0, LEVEL_INFO	# Loads LEVEL_INFO address
	li t1,0			# Loads 0 to t1
	sh t1,0(t0)		# and stores 0 in LEVEL_INFO (Menu)
	sh t1,2(t0)		# and stores 1 in LEVEL_INFO section (Main Menu)
	j MENU
		
.include "soundtracks.s"										
.include "gameenemies.s"																												
.include "gamelonglabels.s"
.include "colisionlabels.s"
.include "gamerender.s"
.include "SYSTEMv21.s"

.data #Includes Sprites

# Player Sprites
.include "sprites/PC_Back.data"
.include "sprites/PC_Front.data"
.include "sprites/PC_Left.data"
.include "sprites/PC_Right.data"
.include "sprites/PC_Attack_Back.data"
.include "sprites/PC_Attack_Front.data"
.include "sprites/PC_Attack_Left.data"
.include "sprites/PC_Attack_Right.data"
.include "sprites/PC_Melee_Attack_Back.data"
.include "sprites/PC_Melee_Attack_Front.data"
.include "sprites/PC_Melee_Attack_Left.data"
.include "sprites/PC_Melee_Attack_Right.data"
.include "sprites/PC_Death.data"

# Map Sprites
.include "sprites/Map1.1.data"
.include "sprites/Map1.1_Hit.data"
.include "sprites/Map1.2.data"
.include "sprites/Map1.2_Hit.data"
.include "sprites/Map2.1.data"
.include "sprites/Map2.1_Hit.data"
.include "sprites/Map2.2.data"
.include "sprites/Map2.2_Hit.data"
.include "sprites/Map2.3.data"
.include "sprites/Map2.3_Hit.data"
.include "sprites/Map3.1.data"
.include "sprites/Map3.1_Hit.data"
.include "sprites/Map3.2.data"
.include "sprites/Map3.2_Hit.data"
.include "sprites/Map3.3.data"
.include "sprites/Map3.3_Hit.data"
.include "sprites/Map3.4.data"
.include "sprites/Map3.4_Hit.data"
.include "sprites/Black.data"

.include "sprites/Waves_Down_1.1.data"
.include "sprites/Waves_Left_1.1.data"

.include"sprites/Death_Anm.data"
.include"sprites/Game_Over_Anm.data"
.include"sprites/End_Anm.data"

# Entites Sprites
	# 1 Inanimate
.include "sprites/Wood_Door_H.data"
.include "sprites/Jungle_Door_H.data"
.include "sprites/Jungle_Door_V.data"
.include "sprites/Magma_Door_H.data"
.include "sprites/KeyB.data"
.include "sprites/KeyY.data"
.include "sprites/ChestB.data"
.include "sprites/ChestY.data"
.include "sprites/Battery.data"

	# 2 Magic Sprites
.include "sprites/Magic_Back.data"
.include "sprites/Magic_Front.data"
.include "sprites/Magic_Left.data"
.include "sprites/Magic_Right.data"
.include "sprites/Stone_ULA_Magic_Back.data"
.include "sprites/Stone_ULA_Magic_Front.data"
.include "sprites/Stone_ULA_Magic_Left.data"
.include "sprites/Stone_ULA_Magic_Right.data"
.include "sprites/Magma_ULA_Magic_Back.data"
.include "sprites/Magma_ULA_Magic_Front.data"
.include "sprites/Magma_ULA_Magic_Left.data"
.include "sprites/Magma_ULA_Magic_Right.data"


	
	# 3 Enemy Sprites
.include "sprites/Water_Slime_Back.data"
.include "sprites/Water_Slime_Front.data"
.include "sprites/Water_Slime_Left.data"
.include "sprites/Water_Slime_Right.data"
.include "sprites/Stone_Slime_Back.data"
.include "sprites/Stone_Slime_Front.data"
.include "sprites/Stone_Slime_Left.data"
.include "sprites/Stone_Slime_Right.data"
.include "sprites/Magma_Slime_Back.data"
.include "sprites/Magma_Slime_Front.data"
.include "sprites/Magma_Slime_Left.data"
.include "sprites/Magma_Slime_Right.data"
.include "sprites/Stone_ULA_Flower.data"
.include "sprites/Magma_ULA_Flower.data"
# Menu Sprites
.include "sprites/Menu.data"
.include "sprites/SelectionArrows.data"
.include"sprites/Game_Over_Menu.data"
.include "sprites/SelectionArrows_Game_Over.data"
