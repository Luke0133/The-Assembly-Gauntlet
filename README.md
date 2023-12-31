Para a versão em português, [clique aqui](#the-assembly-gauntlet-português)
# The-Assembly-Gauntlet
Project made for the University of Brasilia, Computer Science, Intruduction to Computer Systems

By Luca Heringer Megiorin, Eduardo Pereira de Sousa and Manuella dos Santos Araujo
- [Context](#context)
- [Methodology](#methodology)
- [Conclusion](#conclusion)

Please, be respectful and use this as research purposes and/or individual purposes. Remember that copying codes from public projects for public means is considered ***plagiarism***.

There is a .txt in the game directory teaching how to play

# Context
Gauntlet (1985 - Atari) is a fantasy-themed hack-and-slash arcade developed and producted by Atari Games. Our job in this project was to recreate (with artistic liberty) this game using the Assembly RISC-V language. The main objective was to implement the following:
- [Graphics interface](#graphics-interface) (Bitmap Display, 320×240, 8 bits/pixel);
- [Keyboard interface](#keyboard-interface) (Keyboard and Display MMIO simulator);
- [Audio interface, music and sound effects](#audio-interface);
- [Animation and movement of player and their attacks](#animation-and-player-movement);
- [Colision](#colisions) with [walls](#static-colision) and [enemies](#dynamic-colision);
- [System for opening doors with keys collected](#dynamic-colision);
- [Condition for winning levels](#static-colision) or [failing them (losing due to lack of life points)](#players-death);
- [At least two types of enemies that move and attack the player](#enemies);
- [At least 3 levels with different layouts](#art-direction-level-design-and-menu);
- [Menu with score, level and player's health](#art-direction-level-design-and-menu);


# Methodology
The Assembly Gauntlet was made using a custom version of the RISC-V Assembler and Runtime Simulator (RARS), available in the game directory.

## Graphics Interface

***Obs.: this section is made based on a 320 x 240 resolution. It's possible to use the same logic for otherresolutions, but some tweaking would be necessary.***

The project was started with implementing graphics interface (320 x 240 resolution) and the character movement. We followed a tutorial made by [Davi Paturi](https://youtu.be/2BBPNgLP6_s) teaching us the basics for rendering a character in the Bitmap Display. After some initial problems due to our lack of Assemlby experience, we were able to make the character and map to be rendered by using the following logic: after getting the ammount of lines and columns that needed to be rendered, the program would get the first Bitmap Display address (0x0FF0), add the frame value to it (0 or 1), make a shift of 20 bits to correct the address (0xFF00 0000 or 0xFF10 0000),add the top left X coordinate and Y*320 (for skipping lines). The printing address would turn out to be 0xFF00 0000 + X + (Y * 320) or 0xFF10 0000 + X + (Y * 320). Afterwards the image is ready to be printed; with some registers used as counters, the program would load a word from the image and store it in the calculated display address, for j columns for i lines.

The next problem was to remove the trail made by the character after moving. With the tutorial used, the player would need to move in tilesets, but we didn't want that. So we developed a logic for getting an specific section of a larger image in order to print it where the player previously was. The same logic used for printing into an specific coordinate from the bitmap display was used for the image address. The program would recieve the image address and add to it the player's old X position and Y*320 (Image address + X + 320 * Y), and, in the printing loop, it would also be adding 320 - the width of the player to the image address for every line printed. The code turned out to be like this:

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

The [same tutorial](https://youtu.be/2BBPNgLP6_s) also helped us with the keyboard interface, where the KDMMIO address was loaded and read to see whether the player was giving any input and, afterwards, which key was being pressed. Since the keys are assotiated with ASCII characters, they are case sensitive (_since 'A' is 65 and 'a' is 97_). Using a [macro](#about-macros) we quickly made every key check possible, which sent the program to an specific label to process that input. The results are as following:

#### Example 2:
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
## Audio Interface
For the audio interface, we used syscalls 30 and 31. We couldn't use syscall 32 (pause), since every time a note would play, the program would stop. Thus, we used the syscall 30 (Time), which gets the current time (milliseconds since 1 January 1970), and stored the time returned in a0 into a data label every time a note starts playing. Afterwards, it is compared every time a play sound is called with a new time, and if the **new time - time note started** is greater or equal to the note's duration, it could play another note. We also stored an index to know which note was being played and if the sound should be played or not. During the program itself we would stop all sounds and call only specific musics at a time. The algorythm is as follows:

#### Example 3:
```
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
```
As for the music itself, we were able to get the list containing the note-duration sequence with help from [Davi Paturi's Hooktheory program](https://gist.github.com/davipatury/cc32ee5b5929cb6d1b682d21cd89ae83) and with a tweaked version (in order to work) of the program from [Gabriel B. G.](https://github.com/Zen-o/Tradutor_MIDI-RISC-V/blob/main/tradutor_midi_risc-v.py)(also available in this main repository, [tutorial on how to use](#midi-converter-usage)), that can convert any midi file into this list.


## Animation and Player Movement

As previously said, we didn't want to make the player movement to be linked to a tileset, thus, instead of the player's sprite (24x24) move 24 pixels per input, they move 4 pixels per input. After every input related with movement, the player's coordinates will be updated (adding/subtracting 4 to a coordinate, storing player's old coordinates in a memory address). _It's importatn to remember that if you are printing using words, every coordinate must be a multiple of 4, hence the player speed being 4_.

As for the animations, it was decided that every animation set for a sprite would be in the same file. With an index being used for skipping lines ([see the use of the a6 register in the rendering algorythm](#example-1)) based on which animation phase is the sprite at. This index will multiply a pre-determined sprite height and will skip height*index lines in the image file. For updating the index, we used different systems in order to make an animation cycle: for the player, projectiles and attacks, every input will update the indexes; for background objects (such as the waves), the indexes are updated every _time_ ms; and for the enemies, every action is tied to an index update. Here are some exemple images:   

![Sprite animation examples](https://github.com/Luke0133/The-Assembly-Gauntlet/assets/68027676/f96f3a15-5de6-4de5-a2e6-bb42519d3c37)
<sub>Exemple of sprite images used</sub>

## Colisions

### Static Colision
Making a colision system was at first a daunting task. With a bit of help from [Victor Manuel and Nathália Pereira's Celeste Assembly Project](https://github.com/tilnoene/celeste-assembly), it was decided that the colision with maps (**we named as static colison**) would work with a mirror version of the map the player is currently at, which was color-coded indicating whether player could walk or not. When a static colision check was called, four pixels from a the direction the player was facing at would be checked before allowing them to move or not. If any of them returned a number different than zero, the player wouldn't be able to move. Additionally, projectiles would stop at normal walls (blue), but could go through some barriers (orange). The colors are as following:
1. Blue: wall
2. Orange: wall for player, but projectiles can go through
3. Purple: go to another level (adds 1 to level counter, making player go to another level)
4. Green: no barriers

![Colision example 1](https://github.com/Luke0133/The-Assembly-Gauntlet/assets/68027676/9daecc3d-056b-43b9-8dfe-d8dbd1a7119c)
<sub>Map 2.1 and it's mirror version with hitbox</sub>

![image](https://github.com/Luke0133/The-Assembly-Gauntlet/assets/68027676/0c82bb82-d015-4d8c-a5c0-2d0866d97d7c)
<sub>**Left:** Player trying to go through a wall; **Middle:** The red rectangle represents the boundaries of the player sprite (just for representation purposes), and the yellow pixels represent the player's hitbox pixels that are to be tested; **Right:** Since player is trying to move foward, the 4 front pixels from the hitbox are the only to be tested, and their coordinates are added by 4 in the Y axis in order to check whether player can move foward (spoiler: he can't)</sub>

### Dynamic Colision
Afterwards, we needed to make the player collide with enemies, enemy projectiles, keys etc. The logic used was from checking whether two rectangles are intersecting each other. With help from [this high-level language article](https://www.geeksforgeeks.org/find-two-rectangles-overlap/) we found out that two rectangles aren't intersecting each other only when one rectangle is above top edge of other rectangle or when one rectangle is on left side of left edge of other rectangle. With that we knew when the player was coliding with an entity or a door and then we would process acoordingly. For keys, a simple counter that would be stored in a data label would show when the player can go through a door or not. The same logic is used for changing level sections, where when the player collides with a Warp Box, they are transported into a predetermined level sections.

## Enemies
There are two type of enemies: the slimes walk on a predetermined path and the ULA flowers shoots based on a predetermined pattern. Much like the [music algorythm](#audio-interface), each enemy takes into account a data label that lets it be rendered or not, another one with its life points, its position/old position, animation labels and finally, a pattern, which contains:
- an index that stores which pattern should be processed
- a list containing the movement speed and direction alternately or the direction and number of times to shoot alternately, depending on enemy type
After that, every enemy in each level section will have a different pattern to be processed. The player can shoot them and their projectiles, or walk into them, taking some damage and gaining less points, but killing them nontheless.
### Player's Death
When the player dies, a circle is rendered arround them. The coordinates are determined by getting the coordinate in the original death image and comparing it to player's coordinate. For instance, if player is at 0;0, the coordinate where rendering will start in the death image is 298;216. The logic for doing this is as follows:

```
Find coordinates of Death Screen (620 x 456) based on player's coordinates:
TOP LEFT X = 298 - PLYR X
TOP LEFT Y = 216 - PLYR Y

For rendering:
Y x 620 (aka width) + X = image address for rendering
for every row, add 620 (aka width) - 320 (printing width)
until printing height (240) is achieved
--------------------------------------------------------------------------------
Find any coordinate of any bigger image (ImgWidth x ImgHeight) based on player's coordinates:
TOP LEFT X = ImgWidth - PLYR X
TOP LEFT Y = ImgHeight - PLYR Y

For rendering:
Y x ImgWidth + X = image address for rendering
for every row, add ImgWidth - 320 (printing width)
until printing height (240) is achieved
```


## Art direction, level design and menu
The sprites were made with [krita](https://krita.org/en/) and the menu was also put into the level map images. The information available in the menu info is updated according to the time/damage player has (shown as health), the ammount of score player has (gained by killing enemies and collecting keys or chests), and depending on how many digits there are, the numbers will be rendered centered in the menu. As for the Main Menu and Game Over menu, a simple counter that stores the option being selected indicates where the selection arrows should be rendered

![Game screenshot](https://github.com/Luke0133/The-Assembly-Gauntlet/assets/68027676/02176585-cc33-42c6-8e4b-bac932f896dc)

![Game menus](https://github.com/Luke0133/The-Assembly-Gauntlet/assets/68027676/fef23cc7-0b3a-4fba-a1ec-d9872693728d)

## Final Observations
### 12-bit Limit Range
Branches have a 12-bit limit range. In order to avoid this (do it since the beggining of the code) do:
```
# instead of doing:
beq t1,t2,label
	# code
label:

# invert the logic and do:
bne t1,t2,skip_label
j label
skip_label:
```

### About Macros
I should say this now already: macros are a ***bad idea***. We used them based on old projects, but there are 
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
so make sure that your codes used in macros arent too long, otherwise, you may fall victim to the [12-bit 
branch limit range](#12-bit-limit-range) exceeded very very quickly. ***If*** you are to use this, make sure to remember this, but
if you are new to Assembly and can avoid it, do it (don't make the same mistake as we did)

### MIDI Converter Usage
- You need to have python and mido installed `py -m pip install mido` for windows powershell or `pip install mido` for linux
- Usage: windows: `py MIDI-RISCV-CONVERTER.py "NAME-OF-FILE.mid"` in powershell; linux `MIDI-RISCV-CONVERTER.py "NAME-OF-FILE.mid"`
- A .data file will be created, containing a list with note,duration,note,duration...

# Conclusion
The Assembly Gauntlet wasn't an easy task for a first semester project. Nonetheless, there are still bugs, with the main problem is that RARS can't assemble the game due to the [branch 12-bit limit range](#12-bit-limit-range), since the code became too big and it was only noticed as the project was nearing its end, where a whole re-edit in the code would be needed in order to fix it, so run it using fpgrars by dragging and dropping the main file (The Assembly Gauntlet.s) into the .exe 


# The Assembly Gauntlet Português
Projeto feito para a Universidade de Brasília, graduação em Ciências da Computação, matéria de Introdução a Sistemas Computacionais

Feito por Luca Heringer Megiorin, Eduardo Pereira de Sousa e Manuella dos Santos Araujo
- [Contexto](#contexto)
- [Metodologia](#metodologia)
- [Conclusão](#conclusão)

Por favor, seja respeitoso e use isso apenas para pesquisa e/ou uso individual. Lembre-se que copiar códigos de projetos publicados para uso público é considerado ***plágio*** e pode resultar na jubilação do aluno no curso.

Há um .txt no diretório do jogo ensinando como jogar

# Contexto
Gauntlet (1985 - Atari) é um jogo arcade de fantasia estilo hack-and-slash desenvolvido e produzido pela Atari Games. Nesse projeto, nosso trabalho foi recriar (com liberdade artística) esse jogo usando a linguagem Assembly RISC-V. O objetivo principal era implementar os seguinte tópicos:
- [Interface gráfica](#interface-gráfica) (Bitmap Display, 320×240, 8 bits/pixel);
- [Interface com Teclado](#interface-com-teclado) (Keyboard and Display MMIO simulator);
- [Interface de áudio, música e efeitos sonoros](#interface-de-áudio);
- [Animação e movimentação do jogador e seus ataques](#movimentação-e-animção-do-jogador);
- [Colisão](#colisões) com [paredes](#colisão-estática) e com [inimigos](#colisão-dinâmica);
- [Sistema de coleta de chaves e abertura de portas](#colisão-dinâmica);
- [Condição de vitória em uma fase](#colisão-estática) e [de derrota (em razão de zerar a vida ou acabar o tempo)](#morte-do-jogador);
- [Pelo menos dois tipos de inimigos que andam e atacam o jogador](#inimigos);
- [Pelo menos 3 layouts de mapas](#direção-artística-design-dos-níveis-e-do-menu);
- [Menu com score, nível e vida do jogador](#direção-artística-design-dos-níveis-e-do-menu);


# Metodologia
The Assembly Gauntlet foi feito usando uma versão customizada do RISC-V Assembler and Runtime Simulator (RARS), disponível no diretório do jogo.

## Interface Gráfica

***Obs.: essa seção foi feita baseada em uma resolução de 320 x 240. É possível usar a mesma lógica para outras resoluções, mas algumas alterações são necessárias.***

O projeto começou com a implementação da interface gráfica (resolução de 320 x 240) e com a movimentação do personagem. Nós seguimos o tutorial feito por [Davi Paturi](https://youtu.be/2BBPNgLP6_s) que nos ensinava o básico da renderização do personagem em um Bitmap Diplay. Depois de uns problemas iniciais devido à nossa falta de experiência com Assemlby, conseguimos renderizar o personagem e o mapa usando a lógica a seguir: depois de receber o número de linhas e de colunas para renderizar, o programa pega o o primeiro endereço do Bitmap Display  (0x0FF0), adiciona o valor do frame (0 or 1), faz um shift de 20 bits para corrigir o endereço (0xFF00 0000 ou 0xFF10 0000), adiciona o X do canto esquerdo superior e o Y*320 (para pular as linhas). O endereço em que a imagem será printada é 0xFF00 0000 + X + (Y * 320) ou 0xFF10 0000 + X + (Y * 320). Depois disso, a imagem está pronta para ser printada; com alguns registradores sendo usados como contadores, o programa carrega uma word da imagem e guarda-a no endereço calculado, por j colunas e i linhas.

O próximo problema foi remover o rastro criado pelo personagem após a movimentação. Com o tutorial usado, o jogador precisaria se mover em tilesets, mas não queríamos isso. Assim, desenvolvemos uma lógica para obter uma seção específica de uma imagem maior para imprimi-la onde o jogador estava anteriormente. A mesma lógica usada para imprimir em uma coordenada específica do Bitmap Diplay foi usada para o endereço da imagem. O programa recebe o endereço da imagem e adiciona a ele a antiga posição X do jogador e Y*320 (endereço da imagem + X + 320 * Y), e, no loop de impressão, também adiciona 320 - a largura do jogador no endereço da imagem para cada linha impressa. O código ficou assim:

#### Exemplo 1:
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
## Interface com Teclado

O [mesmo tutorial](https://youtu.be/2BBPNgLP6_s) também nos ajudou com a interface do teclado, onde o endereço KDMMIO foi carregado e lido para ver se o jogador está realizando algum input e, depois, qual tecla está sendo pressionada. Como as teclas são associadas a caracteres ASCII, elas diferenciam maiúsculas de minúsculas (_já que 'A' é 65 e 'a' é 97_). Usando um [macro](#sobre-macros), fizemos rapidamente todas as verificações de chave possíveis, as quais mandavam o programa para uma label específica para processar essa entrada. Os resultados são os seguintes:

#### Exemplo 2:
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
## Interface de Áudio
Para a interface de áudio, usamos as syscalls 30 e 31. Não poderíamos usar a syscall 32 (pausa), pois toda vez que uma nota tocava, o programa parava. Assim, usamos a syscall 30 (Time), que obtém a hora atual (milissegundos desde 1º de janeiro de 1970) e armazenamos o tempo retornado em a0 em uma label de dados toda vez que uma nota começa a tocar. Depois, compara-se toda vez que um som é chamado para ser tocado com um novo tempo, e se o **novo tempo - tempo da nota iniciada** for maior ou igual à duração da nota, ele poderá tocar outra nota. Também armazenamos um índice para saber qual nota está sendo tocada e se o som deve ser tocado ou não. Durante o próprio programa, paramos todos os sons e chamamos apenas músicas específicas a cada vez. O algoritmo é o seguinte:

#### Exemplo 3:
```
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
```
Quanto à música em si, conseguimos obter a lista contendo a sequência de nota,duração com a ajuda do [programa Hooktheory de Davi Paturi](https://gist.github.com/davipatury/cc32ee5b5929cb6d1b682d21cd89ae83) e com uma versão aprimorada (para poder funcionar) do programa do [Gabriel B. G.](https://github.com/Zen-o/Tradutor_MIDI-RISC-V/blob/main/tradutor_midi_risc-v.py)(também disponível neste repositório principal, [ tutorial sobre como usar](#como-usar-conversor-midi)), que pode converter qualquer arquivo MIDI em uma lista contendo nota e duração intercaladas.

## Movimentação e Animção do Jogador

Como dito anteriormente, não queríamos fazer com que o jogador tivesse movimentação vinculada a um tileset. Portanto, em vez da sprite do jogador (24x24) mover 24 pixels por input, ele moveria 4 pixels por entrada. Após cada input relacionado ao movimento, as coordenadas do jogador são atualizadas (adicionando/subtraindo 4 a uma coordenada e armazenando as coordenadas antigas do jogador em um endereço de memória). _É importante lembrar que se você estiver imprimindo usando words, cada coordenada deve ser um múltiplo de 4, portanto a velocidade do jogador é 4_.

Quanto às animações, foi decidido que todas as animações definidas para uma sprite estariam no mesmo arquivo. Com um índice sendo usado para pular linhas ([veja o uso do registrador a6 no algoritmo de renderização](#examplo-1)) com base em qual fase da animação o sprite está. Este índice multiplicará uma altura predeterminada da sprite e pulará altura * índice de linhas no arquivo da imagem. Para atualizar o índice, usamos diferentes sistemas para fazer um ciclo de animação: para o jogador, projéteis e ataques, cada entrada atualizará os índices; para objetos no background (como as ondas), os índices são atualizados a cada _tempo_ ms; e para os inimigos, cada ação está vinculada a uma atualização de índice. Seguem algumas imagens de exemplo:

![Exemplos de animação de sprites](https://github.com/Luke0133/The-Assembly-Gauntlet/assets/68027676/f96f3a15-5de6-4de5-a2e6-bb42519d3c37)
<sub>Exemplo de imagens de sprites usadas</sub>

## Colisões

### Colisão Estática
Fazer um sistema de colisão foi inicialmente uma tarefa assustadora. Com uma pequena ajuda do [projeto de OAC do Victor Manuel e da Nathália Pereira's (Celeste Assembly)](https://github.com/tilnoene/celeste-assembly), foi decidido que a colisão com mapas (**chamamos de colisão estática** ) funcionaria com uma versão paralela do mapa em que o jogador está atualmente, que foi codificada com cores indicando se o jogador pode andar ou não. Quando uma verificação de colisão estática era chamada, quatro pixels da direção para a qual o jogador está virado são verificados antes de permitir que ele se mova ou não. Se algum deles retornar um número diferente de zero, o jogador não pode se mover. Além disso, os projéteis param em paredes normais (azul), mas podem passar por algumas barreiras (laranja). As cores são as seguintes:
1. Azul: parede
2. Laranja: parede para o jogador, mas projéteis podem atravessar
3. Roxo: vai para outro nível (adiciona 1 ao contador de nível, fazendo o jogador ir para outro nível)
4. Verde: sem barreiras

![Exemplo de colisão 1](https://github.com/Luke0133/The-Assembly-Gauntlet/assets/68027676/9daecc3d-056b-43b9-8dfe-d8dbd1a7119c)
<sub>Mapa 2.1 e sua versão espelhada com hitbox</sub>

![Exemplo de colisão 2](https://github.com/Luke0133/The-Assembly-Gauntlet/assets/68027676/0c82bb82-d015-4d8c-a5c0-2d0866d97d7c)
<sub>**Esquerda:** Jogador tentando atravessar uma parede; **Meio:** O retângulo vermelho representa os limites da sprite do jogador (apenas para fins de representação) e os pixels amarelos representam os pixels da hitbox do jogador que serão testados; **Direita:** Como o jogador está tentando se mover para frente, os 4 pixels frontais do hitbox são os únicos a serem testados, e suas coordenadas são somadas a 4 no eixo Y para verificar se o jogador pode se mover para frente (spoiler : ele não pode)</sub>

### Colisão Dinâmica
Depois, precisávamos de fazer o jogador colidir com inimigos, projéteis inimigos, chaves etc. A lógica utilizada foi verificar se dois retângulos estão se cruzando. Com a ajuda de [este artigo de linguagem de alto nível](https://www.geeksforgeeks.org/find-two-rectangles-overlap/), descobrimos que dois retângulos não se cruzam apenas quando um retângulo está acima de outro retângulo ou quando um retângulo está no lado esquerdo de outro retângulo. Com isso sabíamos quando o jogador estava colidindo com uma entidade ou uma porta e então processávamos de forma coordenada. Para as chaves, um simples contador que é armazenado em uma label de memória mostraria quando o jogador pode ou não passar por uma porta. A mesma lógica é usada para alterar as seções do nível, nas quais quando o jogador colide com uma Warp Box, eles são transportados para seções dos níveis predeterminadas.

## Inimigos
Existem dois tipos de inimigos: as slimes andam por um caminho predeterminado e as flores ULA atiram com base em um padrão predeterminado. Assim como o [algoritmo para música](#interface-de-áudio), cada inimigo leva em conta uma label de dados que o permite renderizar ou não, outra com seus pontos de vida, sua posição/posição antiga, labels de animação e por fim, um padrão, que contém:
- um índice que armazena qual padrão deve ser processado
- uma lista contendo a velocidade de movimento e direção intercaladas ou a direção e número de vezes para atirar intercaladas, dependendo do tipo de inimigo
Depois disso, cada inimigo em cada seção de nível terá um padrão diferente a ser processado. O jogador pode atirar neles e nos seus projéteis, ou colidir com eles, sofrendo algum dano e ganhando menos pontos, mas matando-os mesmo assim.
### Morte do Jogador
Quando o jogador morre, um círculo é gerado ao seu redor. As coordenadas são determinadas obtendo a coordenada na imagem original da morte e comparando-a com a coordenada do jogador. Por exemplo, se o jogador estiver em 0;0, a coordenada onde a renderização começará na imagem da morte é 298;216. A lógica para fazer isso é a seguinte:

```
Encontrar as coordenadas da Tela de Morte (620 x 456) com base nas coordenadas do jogador:
X SUPERIOR ESQUERDO = 298 - PLYR X
Y SUPERIOR ESQUERDO = 216 - PLYR Y

Para renderização:
Y x 620 (aka largura) + X = endereço da imagem para renderização
para cada linha, adicione 620 (aka largura) - 320 (largura de impressão)
até que a altura de impressão (240) seja alcançada
-------------------------------------------------- -------------------------
Encontre qualquer coordenada de qualquer imagem maior (ImgWidth x ImgHeight) com base nas coordenadas do jogador:
X SUPERIOR ESQUERDO = ImgWidth - PLYR X
Y SUPERIOR ESQUERDO = ImgHeight - PLYR Y

Para renderização:
Y x ImgWidth + X = endereço da imagem para renderização
para cada linha, adicione ImgWidth - 320 (largura de impressão)
até que a altura de impressão (240) seja alcançada
```


## Direção artística, design dos níveis e do menu
As sprites foram feitos com [krita](https://krita.org/en/) e o menu também foi colocado nas imagens do mapa. As informações disponíveis nas informações do menu são atualizadas de acordo com o tempo/dano que o jogador possui (mostrado como vida), a quantidade de pontuação que o jogador possui (obtida ao matar inimigos e coletar chaves ou baús) e, dependendo de quantos dígitos existem, os números serão renderizados centralizados no menu. Quanto ao menu principal e ao menu Game Over, um contador simples que armazena a opção que está sendo selecionada indica onde as setas de seleção devem ser renderizadas

![Captura de tela do jogo](https://github.com/Luke0133/The-Assembly-Gauntlet/assets/68027676/02176585-cc33-42c6-8e4b-bac932f896dc)

![Menus do jogo](https://github.com/Luke0133/The-Assembly-Gauntlet/assets/68027676/fef23cc7-0b3a-4fba-a1ec-d9872693728d)

## Observações finais
### Limite de 12 bits
Os branches têm um limite de 12 bits. Para evitar isso (faça isso desde o início do código) faça:
```
# ao invés de fazer:
beq t1,t2,label
# código
label:

# inverta a lógica e faça:
bne t1,t2,skip_label
j label
skip_label:
```

### Sobre Macros
Eu já digo isso: macros são uma ***má ideia***. Nós os usamos com base em projetos antigos, mas há algumas coisas importantes que iniciantes como nós precisam saber sobre eles: Macros não são como funções de linguagens de alto nível. Eles literalmente escrevem o código escrito neles toda vez que são chamados, portanto, em um caso como este:

```
.macro check_key(%key,%label,%input,%label2)
li t1,%key
bne t1,%input,%label2
j %label
%label2:
.end_macro

check_key('s', MOV_DOWN, t0,SKIP_A) # Verifica se a tecla pressionada é 's'
check_key('w', MOV_UP, t0,SKIP_B) # Verifica se a tecla pressionada é 'w'
check_key('d', MOV_RIGHT, t0,SKIP_C) # Verifica se a tecla pressionada é 'd'
check_key('a', MOV_LEFT, t0,SKIP_D) # Verifica se a tecla pressionada é 'a'

```
cada linha que chama check_key será processada como:
```
li t1,'s'
bne t1,t0,SKIP_A
j MOV_DOWN
SKIP_A:
li t1,'w'
bne t1,t0,SKIP_B
j MOV_UP
SKIP_B:
li t1,'d'
bne t1,t0,SKIP_C
j MOV_RIGHT
SKIP_C:
li t1,'a'
bne t1,t0,SKIP_D
j MOV_LEFT
SKIP_D:
```
portanto, certifique-se de que seus códigos escritos nos macros não sejam muito longos, caso contrário, você pode ser vítima do [limite de 12-bit do branch](#limite-de-12-bits) excedido muito, muito rapidamente. ***Se*** você for usar isso, lembre-se disso, mas se você é novo no Assembly e pode evitá-los, faça-o (não cometa o mesmo erro que nós).

### Como usar Conversor MIDI
- Você precisa ter python e mido instalados `py -m pip install mido` no windows powershell ou `pip install mido` para linux
- Uso: windows: `py MIDI-RISCV-CONVERTER.py "NAME-OF-FILE.mid"` no powershell; linux `MIDI-RISCV-CONVERTER.py "NAME-OF-FILE.mid"`
- Será criado um arquivo .data, contendo uma lista com nota,duração,nota,duração...

# Conclusão
O Assembly Gauntlet não foi uma tarefa fácil para um projeto do primeiro semestre. Tanto que ainda existem bugs, sendo que o principal problema é que o RARS não consegue realizar o assemble do jogo devido ao [limite de 12-bit do branch excedido](#limite-de-12-bits), pois o código ficou muito grande e só foi notado quando o projeto estava chegando ao fim, onde seria necessária uma reestruturação completa no código para corrigi-lo, então execute-o usando fpgrars arrastando e soltando o arquivo principal (The Assembly Gauntlet.s) no .exe

Muito obrigado pela leitura :3
