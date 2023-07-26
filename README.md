# The-Assembly-Gauntlet
Project made for the University of Brasília, Computer Science, Intruduction to Computer Systems 
- [Context](#context)
- [Methodology](#methodology)



# Context
Gauntlet (1985 - Atari) is a fantasy-themed hack-and-slash arcade developed and producted by Atari Games. Our job 
in this project was to recreate (with artistic liberty) this game using the Assembly RISC-V language. The main 
objective was to implement the following:
- [Graphics interface](##graphics-interface) (Bitmap Display, 320×240, 8 bits/pixel);
- Keyboard interface (Keyboard and Display MMIO simulator);
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
##Graphics Interface
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

The next problem was to remove the trail made by the character after moving. With the tutorial used, the player 
would need to move in tilesets, but we didn't want that. So we developed a logic for getting an specific 
section of a larger image in order to print it where the player previously was. The same logic used for 
printing into an specific coordinate from the bitmap display was used for the image address. The program would 
recieve the image address and add to it the player's old X position and Y*320 (Image address + X + 320 * Y), 
and, in the printing loop, it would also be adding 320 - the width of the player to the image address for every 
line printed. The code turned out to be like this:
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

