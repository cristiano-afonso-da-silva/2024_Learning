# # L01: Hello Assembly
# .data
    # myMessage: .asciiz "Hello World \n"

# .text
    # # v is action register
    # li $v0, 4
    # la $a0, myMessage
    # syscall
    
###########################################################################

# # L02: Printing a Character
# .data
    # myCharacter: .byte 'm'

# .text
    # li $v0, 4
    # la $a0, myCharacter
    # syscall
    
###########################################################################

# # L03: Printing an Integer
# .data
    # # this is a word or interger
    # age: .word 909

# .text
    # # print integer to the screen
    # # v0 with value 1 is to prepare for printing an integer or what we called word
    # li $v0, 1
    # # lw -> load word in argument address $a0
    # lw $a0, age
    # syscall
    
###########################################################################
    
# # L04: Addition
# .data
    # number1: .word 5
    # number2: .word 10

# .text
    # lw $t0, number1
    # lw $t1, number2
    
    # # t2 = t0 + t1
    # add $t2, $t0, $t1
    
    # # More Complicated Way
    # li $v0, 1
    # add $a0, $zero, $t2 #move the value to a argument
    # syscall
    
###########################################################################

# # L05: Substraction
# .data
    # number1: .word 20
    # number2: .word 8

# .text
    # lw $s0, number1     # s0 = 20
    # lw $s1, number2     # s1 = 8
    
    # sub $t0, $s0, $s1   # t0 = 20 - 8
    
    # li $v0, 1
    # move $a0, $t0       # Instead of add $a0, $zero, $t2, use move $a0, $t0
    # syscall
    
###########################################################################
    
# # L06: Multiplication with mul
# .data
# .text
    # # mul: takes 3 register
    # # mult: takes 2 register
    # # sll: shift left logical, efficient but less flexibility
    # addi $s0, $zero, 10     # s0 = 0 + 10
    # addi $s1, $zero, 5     # s1 = 0 + 4
    
    # mul $t0, $s0, $s1
    
    # li $v0, 1
    # # add $a0, $zero, $t0
    # move $a0, $t0           # same as add $a0, $zero, $t0 but simpler
    # syscall
    
###########################################################################
    
# # L07: Multiplication with mult
# .data
# .text
    # addi $t0, $zero, 2000
    # addi $t1, $zero, 10
    
    # mult $t0, $t1
    
    # mflo $s0    # move $t0 * $t1 to $s0
    
    # li $v0, 1
    # add $a0, $zero, $s0
    # syscall
    
###########################################################################

# # L08: Multiplication with sll
# .data
# .text
    # addi $s0, $zero, 4
    
    # sll $t0, $s0, 3 # $t0 = $s0 * 2^3
    
    # li $v0, 1
    # move $a0, $t0
    # syscall
    
###########################################################################
    
# # L09: Division (Part1)
# .data
# .text
    # addi $t0, $zero, 30
    # addi $t1, $zero, 5
    
    # div $s0, $t0, $t1
    
    # li $v0, 1
    # move $a0, $s0
    # syscall
    
###########################################################################
    
# # L10: Division (Part2)
# .data
# .text
    # addi $t0, $zero, 30
    # addi $t1, $zero, 5
    
    # div $t0, $t1
    
    # mflo $s0    # Quotient
    # mfhi $s1    # Remainder
    
    # li $v0, 1
    # move $a0, $s0
    # syscall
    
###########################################################################

# # L11: Function Introduction
# .data
    # message: .asciiz "Hi, Everybody. \nMy Name is Cristiano.\n"
# .text
    # main:
        # jal displayMessage
        
        # addi $s0, $zero, 5
        
        # li, $v0, 1
        # add $a0, $zero, $s0
        # syscall
    
    # # Tell the system that the program is done
    # li $v0, 10
    # syscall
    
    # displayMessage:
        # li $v0, 4
        # la $a0, message
        # syscall
        
        # jr $ra
        
###########################################################################
        
# # L12: Function Arguments and Return Values
# .data
# .text
    # main:
        # addi $a1, $zero, 50
        # addi $a2, $zero, 100
        
        # jal addNumbers
        
        # li $v0, 1
        # move $a0, $v1
        # syscall
        
    # li $v0, 10
    # syscall
    
    # addNumbers:
        # add $v1, $a1, $a2
        # jr $

###########################################################################
        
# # L13: Saving Registers to the Stack
# .data
    # newline: .asciiz "\n"
# .text
    # main:
        # addi $s0, $zero, 10
        
        # jal increaseMyRegister
        
        # li $v0, 4
        # la $a0, newline
        # syscall
        
        # li $v0, 1
        # move $a0, $s0
        # syscall
    
    # li $v0, 10
    # syscall
    
    # increaseMyRegister:
        # addi $sp, $sp, -4   # stack goes down in 4 multiply, sp -> stack pointer
        # sw $s0, 0($sp)
        
        # addi $s0, $s0, 30
        
        # li $v0, 1
        # move $a0, $s0
        # syscall
        
        # lw $s0, 0 ($sp)
        # addi $sp, $sp, 4
        
        # jr $ra

###########################################################################

# # L14: Nested Procedure
# .data
    # newline: .asciiz "\n"
# .text
    # main:
        # addi $s0, $zero, 10
        
        # jal increaseMyRegister
        
        # li $v0, 4
        # la $a0, newline
        # syscall
        
        # jal printNum
    
    # li $v0, 10
    # syscall
    
    # increaseMyRegister:
        # addi $sp, $sp, -8   # stack goes down in 4 multiply, sp -> stack pointer, rmb every value is 4 byte
        # sw $s0, 0($sp)
        # sw $ra, 4($sp)
        
        # addi $s0, $s0, 30
        
        # jal printNum
        
        # lw $s0, 0($sp)
        # lw $ra, 4($sp)  # restore the addres, return address
        # addi $sp, $sp, 4
        
        # jr $ra
        
    # printNum:
        # li $v0, 1
        # move $a0, $s0
        # syscall
        
        # jr $ra

###########################################################################

# # L15: Branch equal / not equal
# .data
    # message: .asciiz "The numbers are different."
    # message2: .asciiz "Nothing happened."
# .text
    # main:
        # addi $t0, $zero, 5
        # addi $t1, $zero, 10
        
        # bne $t0, $t1, numbersDifferent
        
        # li $v0, 10
        # syscall
        
    # numbersDifferent:
        # li $v0, 4
        # la $a0, message
        # syscall

###########################################################################

# # L16: Checking if a Number is less than another slt
# .data
    # message: .asciiz "The number is less than the other."
    # message2: .asciiz "The number is not less than the other."
# .text
    # main:
    # addi $t0, $zero, 400
    # addi $t1, $zero, 200
    # slt $s0, $t0, $t1
    # beq $s0, 1, printMessage
    # beq $s0, $zero, printMessage2
    
    # li $v0, 10
    # syscall
    
    # printMessage:
        # li $v0, 4
        # la $a0, message
        # syscall
        # j end
        
    # printMessage2:
        # li $v0, 4
        # la $a0, message2
        # syscall
        # j end
        
    # end:


###########################################################################

# # L17: Branching Pseudo Instruction
# .data
    # message: .asciiz "Hi, how are you?"
# .text
    # main:
        # addi $s0, $zero, 14
        
        # bgtz $s0, displayHi  
        
    # li $v0, 10
    # syscall
    
    # displayHi:
        # li $v0, 4
        # la $a0, message
        # syscall
        
###########################################################################

# # L18: While Loop
# .data
    # message: .asciiz "after while loop is done"
    # space: .asciiz ", "
# .text
    # main:
        # addi $t0, $zero, 0
        
        # while: 
            # bgt $t0, 10, exit
            # jal printNumber
            # addi $t0, $t0, 2
            
            # j while
        
        # exit:
            # li $v0, 4
            # la $a0, message
        
        # li $v0, 10
        # syscall
        
    # printNumber:
        # li $v0, 1
        # move $a0, $t0
        # syscall
        
        # li $v0, 4
        # la $a0, space
        # syscall
        
        # jr $ra
        
###########################################################################

# # L19: Arrays
# .data
    # myArray: .space 12 # 12 bytes for 3 integers
# .text
    # addi $s0, $zero, 4
    # addi $s1, $zero, 10
    # addi $s2, $zero, 12
    
    # # Index / Offset
    # addi $t0, $zero, 0
    
    # sw $s0, myArray($t0)
    # addi $t0, $t0, 4
    # sw $s1, myArray($t0)
    # addi $t0, $t0, 4
    # sw $s2, myArray($t0)





















