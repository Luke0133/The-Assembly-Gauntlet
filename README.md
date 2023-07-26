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
- At least 3 levels with different layouts;
- Animation and movement of player and their attacks;
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
The project was started with implementing graphics interface and the character movement. We followed a tutorial 
made by [Davi Paturi](https://youtu.be/2BBPNgLP6_s) teaching us the basics for rendering a character in the 
Bitmap Display. After some initial problems due to our lack of Assemlby experience, we were able to make the 
character and map to be rendered by using the following logic: after getting the ammount of lines and columns 
that needed to be rendered, the program would get t
