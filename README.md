# The-Assembly-Gauntlet
Project made for the University of Brasília, Computer Science, Intruduction to Computer Systems 
- [Context](#context)
- [Methodology](#methodology)



# Context
Gauntlet (1985 - Atari) is a fantasy-themed hack-and-slash arcade developed and producted by Atari Games. Our job 
in this project was to recreate (with artistic liberty) this game using the Assembly RISC-V language. The main 
objective was to implement the following:
- [Graphics interface](#graphics-interface) (Bitmap Display, 320×240, 8 bits/pixel);
- [Keyboard interface](#keyboard-interface) (Keyboard and Display MMIO simulator);
- Animation and movement of player and their attacks;
- At least 3 levels with different layouts;
- Colision with walls and enemies
- System for opening doors with keys collected
- Condition for winning levels or failing them (losing due to lack of life points)
- At least two types of enemies that move and attack the player;
- Menu with score, level and player's health;
- Audio interface, music and sound effects.

# Methodology
The Assembly Gauntlet was made using a custom version of the RISC-V Assembler and Runtime Simulator (RARS), 
available in the game directory.

## Graphics Interface

***Obs.: this section is made based on a 320 x 240 resolution. It's possible to use the same logic for other
resolutions, but some tweaking would be necessary.***

The project was started with implementing graphics interface (320 x 240 resolution) and the character movement. 
We followed a tutorial made by [Davi Paturi](https://youtu.be/2BBPNgLP6_s) teaching us the basics for rendering 
a character in the Bitmap Display. After some initial problems due to our lack of Assemlby experience, we were 
able to make the character and map to be rendered by using the following logic: after getting the ammount of 
lines and columns that needed to be rendered, the program would get the first Bitmap Display address (0x0FF0), 
add the frame value to it (0 or 1), make a shift of 20 bits to correct the address (0xFF00 0000 or 0xFF10 0000),
add the top left X coordinate and Y*320 (for skipping lines). The printing address would turn out to be 
0xFF00 0000 + X + (Y * 320) or 0xFF10 0000 + X + (Y * 320). Afterwards the image is ready to be printed; with 
some registers used as counters, the program would load a word from the image and store it in the calculated 
display address, for j columns for i lines.

The next problem was to remove the trail made by the character after moving. With the tutorial used, the 
player would need to move in tilesets, but we didn't want that. So we developed a logic for getting an 
specific section of a larger image in order to print it where the player previously was. The same logic used 
for printing into an specific coordinate from the bitmap display was used for the image address. The program 
would recieve the image address and add to it the player's old X position and Y*320 (Image address + X + 320 * 
Y), and, in the printing loop, it would also be adding 320 - the width of the player to the image address for 
every line printed. The code turned out to be like this:
#### Example 1:
```
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
```
## Keyboard Interface

The [same tutorial](https://youtu.be/2BBPNgLP6_s) also helped us with the keyboard interface, where the KDMMIO 
address was loaded and read to see whether the player was giving any input and, afterwards, which key was 
being pressed. Since the keys are assotiated with ASCII characters, they are case sensitive (_since 'A' is 65 
and 'a' is 97_). Using a [macro](#about-macros) we quickly made every key check possible, which sent the 
program to an specific label to process that input. The results are as following:
```
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
```

### About Macros
I should say this now already: macros are a **bad idea**. We used them based on old projects, but there are 
some important things that newcomers like us need to know about them: Macros arent like high-level languages' 
functions. They litteraly write the code put into them every time they are called, so in a case like this:
```
.macro check_key(%key,%label,%input,%label2)
li t1,%key
bne t1,%input,%label2
j  %label
%label2 :
.end_macro

check_key('s', MOV_DOWN, t0,SKIP_A)	# Checks if key pressed is 's'
check_key('w', MOV_UP, t0,SKIP_B)	# Checks if key pressed is 'w'
check_key('d', MOV_RIGHT, t0,SKIP_C)	# Checks if key pressed is 'd'
check_key('a', MOV_LEFT, t0,SKIP_D)	# Checks if key pressed is 'a'
	
```
every row that calls for check_key will processed as:
```
li t1,'s'
bne t1,t0,SKIP_A
j  MOV_DOWN
SKIP_A:
li t1,'w'
bne t1,t0,SKIP_B
j  MOV_UP
SKIP_B:
li t1,'d'
bne t1,t0,SKIP_C
j  MOV_RIGHT
SKIP_C:
li t1,'a'
bne t1,t0,SKIP_D
j  MOV_LEFT
SKIP_D:
```
so make sure that your codes used in macros arent too long, otherwise, you may fall victim to the 12-bit 
branch limit range exceeded very very quickly. ***If*** you are to use this, make sure to remember this, but
if you are new to Assembly and can avoid it, do it (don't make the same mistake as we did)
