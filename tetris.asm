################ CSC258H1F Winter 2024 Assembly Final Project ##################
# This file contains our implementation of Tetris.
#
# Student 1: Name, Student Number
# Student 2: Name, Student Number (if applicable)
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       8
# - Unit height in pixels:      8
# - Display width in pixels:    160 = 20 x 8
# - Display height in pixels:   168 = 21 x 8
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
bitmap: .space 1680
tetro: .space 16
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL: .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD: .word 0xffff0000

##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

	# Run the Tetris game.
main:
    li $a0, 0xff0000            # Load the color red into $a0
    li $a1, 0x0000ff
    la $a2, bitmap              # Load the starting address of the bitmap
    lw $t0, ADDR_DSPL           # Load base address of display into $t0
    li $t1, 12                  # 20 units for each row (top border)
    li $t2, 21                  # 21 total rows minus the top and bottom borders
    li $t3, 0                   # Counter for loop
    li $t4, 1680                # Total words in bitmap
    li $t5 4
    
    # la $a2, bitmap
    # draw_background:
        # sw $a0, 0($a2)        # Set the bottom border unit to red, adjusting for the initial 4-byte offset
        # addi $a2, $a2, 4           # Move to the next unit in the row
        # addi $t4, $t4, -1           # Decrement the loop counter
        # bnez $t4, draw_background
    
    # Initialize the bottom border
    la $a2, bitmap              # Reset the address pointer to the start of bitmap
    bottom_border_loop:
        sw $a0, 1600($a2)        # Set the bottom border unit to red, adjusting for the initial 4-byte offset
        addi $a2, $a2, 4           # Move to the next unit in the row
        addi $t1, $t1, -1           # Decrement the loop counter
        bnez $t1, bottom_border_loop
    
    # Initialize the left and right borders
    la $a2, bitmap              # Reset the address pointer to the start of bitmap
    left_right_border_loop:
        sw $a0, 0($a2)              # Set the left border unit to red
        sw $a0, 44($a2)             # Set the right border unit to red
        addi $a2, $a2, 80          # Jump to the next row
        addi $t2, $t2, -1           # Decrement the loop counter
        bnez $t2, left_right_border_loop
        
    # Initialize the left and right borders
    la $a2, bitmap              # Reset the address pointer to the start of bitmap
    tetro:
        sw $a1, 16($a2)             # Set the right border unit to red
        addi $a2, $a2, 4          # Jump to the next row
        addi $t5, $t5, -1           # Decrement the loop counter
        bnez $t5, tetro

    j game_loop                 # Jump to the game loop after initialization    

game_loop:
    la $a2, bitmap              # Load address of bitmap

    # Example loop to draw the frame
    draw_loop:
        lw $t5, 0($a2)              # Load a word from the bitmap
        sw $t5, 0($t0)              # Store the word into the display memory
        addi $a2, $a2, 4           # Move to the next word in the bitmap
        addi $t0, $t0, 4           # Move to the next position in the display
        addi $t3, $t3, 1            # Increment counter
        blt $t3, $t4, draw_loop     # Loop until all words are written
        
    # Check for keyboard input
    li $v0, 32
	li $a0, 1
	syscall

    lw $t5, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t6, 0($t5)                  # Load first word from keyboard
    beq $t6, 1, keyboard_input      # If first word 1, key is pressed
    b main

    keyboard_input:                     # A key is pressed
        lw $a0, 4($t5)                  # Load second word from keyboard
        beq $a0, 0x71, respond_to_Q     # Check if the key q was pressed
        beq $a0, 0x73, respond_to_S     # Check if the key q was pressed
    
        li $v0, 1                       # ask system to print $a0
        syscall
    
        b main
    
    respond_to_Q:
    	li $v0, 10                      # Quit gracefully
    	syscall
    	
    respond_to_S:
        
        
	# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep

    #5. Go back to 1
    b game_loop
    