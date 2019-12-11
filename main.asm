.data
intro: .asciiz "------------------------------\nTable Operation Program\n------------------------------\nThis program performs different operations on a pre-initialized 5x5 table.\nNote that numbers with more than 5 digits may cause formatting issues for the table display.\n"
prompt: .asciiz "\nChoose a command using the given number, or enter 0 to quit:\n"
desc1: .asciiz "1. Find sum of diagonal\n"
desc2: .asciiz "2. Find sum of a specific row\n"
desc3: .asciiz "3. Find sum of a specific column\n"
desc4: .asciiz "4. Reverse a specific row\n"
desc5: .asciiz "5. Reverse a specific column\n"
desc6: .asciiz "6. Add any two specified rows and place results in a given row\n"
desc7: .asciiz "7. Multiply each element of a row by a constant and place results in a given row\n"

table: 
.word 1, 2, 3, 4, 5
.word 10, 20, 30, 40, 50
.word 100, 200, 300, 400, 500
.word -1, -2, -3, -4, -5 
.word -10, -20, -30, -40, -50

horizontal: .asciiz "-----------------------------------------\n"
vertical: .asciiz "| "
nl: .asciiz "\n"
space: .asciiz " "
sum: .asciiz "Sum = "
plus: .asciiz " + "
invalid: .asciiz "Invalid entry, returning to menu\n"
enterrow: .asciiz "Enter row number (1-5):\n"
entercolumn: .asciiz "Enter column number (1-5):\n"
enterconstant: .asciiz "Enter multiplication constant:\n"
firstrow: .asciiz "Enter the first row to add:\n"
secondrow: .asciiz "Enter the second row to add:\n"
sumrow: .asciiz "Enter the row for each sum to be stored in:\n"

.text
#----------------------------------------
#Main
#----------------------------------------

main:
li $v0, 4
la $a0, intro
syscall
j loop
exit: li $v0, 10
syscall

#----------------------------------------
#UI Functions
#----------------------------------------

#Printing table and command list
loop:
jal printtable
li $v0, 4
la $a0, prompt
syscall
li $v0, 4
la $a0, desc1
syscall
li $v0, 4
la $a0, desc2
syscall
li $v0, 4
la $a0, desc3
syscall
li $v0, 4
la $a0, desc4
syscall
li $v0, 4
la $a0, desc5
syscall
li $v0, 4
la $a0, desc6
syscall
li $v0, 4
la $a0, desc7
syscall

#Reading input and sending to subroutine
li $v0, 5
syscall
beq $v0, 0, exit
beq $v0, 1, start1
beq $v0, 2, start2
beq $v0, 3, start3
beq $v0, 4, start4
beq $v0, 5, start5
beq $v0, 6, start6
beq $v0, 7, start7
j loop

#----------------------------------------
#Diagonal Sum Operation
#----------------------------------------

start1: jal diagonal
j loop
diagonal:
la $a0, table($zero) #Table start address
li $a1, 5 #Column size
li $v0, 0 #Will store sum
li $t4, 0 #Will also store sum
li $t0, 0 #Row number
diagloop: mul $t1, $t0, $a1
add $t1, $t1, $t0
mul $t1, $t1, 4
lw $t2, table($t1)
add $v0, $v0, $t2
addi $t0, $t0, 1
blt $t0, $a1, diagloop
move $t4, $v0
la $a0, sum
li $v0, 4
syscall
move $a0, $t4
li $v0, 1
syscall
la $a0, nl
li $v0, 4
syscall
syscall
jr $ra

#----------------------------------------
#Row Sum Operation
#----------------------------------------

start2: jal rowsum
j loop
rowsum:
move $t2, $zero #Row number from user input
move $t3, $zero #Sum
move $t5, $zero 
li $t6, -1
move $s5, $zero #Number being added to sum
la $a0, enterrow
li $v0, 4
syscall
li $v0, 5
syscall 
blt $v0, 1, outsiderange
bgt $v0, 5, outsiderange
sub $t5, $v0, 1
move $k0, $ra
rowloop: 
addi $t6, $t6, 1
jal calculate
lw $s5, table($s4)
add $t3, $t3, $s5
blt $t6, 4, rowloop
li $v0, 4
la $a0, sum
syscall
la $v0, 1
move $a0, $t3
syscall
la $v0, 4
la $a0, nl
syscall
syscall
jr $k0

#----------------------------------------
#Column Sum Operation
#----------------------------------------

start3: jal colsum
j loop
colsum:
move $t2, $zero #Row number from user input
move $t3, $zero #Sum
move $t5, $zero 
li $t5, -1
move $s5, $zero #Number being added to sum
la $a0, entercolumn
li $v0, 4
syscall
li $v0, 5
syscall 
blt $v0, 1, outsiderange
bgt $v0, 5, outsiderange
sub $t6, $v0, 1
move $k0, $ra
columnloop: 
addi $t5, $t5, 1
jal calculate
lw $s5, table($s4)
add $t3, $t3, $s5
blt $t5, 4, columnloop
li $v0, 4
la $a0, sum
syscall
la $v0, 1
move $a0, $t3
syscall
la $v0, 4
la $a0, nl
syscall
syscall
jr $k0

#----------------------------------------
#Reverse Row Operation
#----------------------------------------

start4: jal reverserow
j loop
reverserow:
li $t0, 0
li $t1, 0
li $t2, 0
li $t3, 0
li $t4, 0
la $a0, enterrow
li $v0, 4
syscall
li $v0, 5
syscall
blt $v0, 1, outsiderange
bgt $v0, 5, outsiderange
subi $t5, $v0, 1
li $t6, 0
move $k0, $ra
jal calculate
lw $t0, table($s4)
addi $s4, $s4, 4
lw $t1, table($s4)
addi $s4, $s4, 4
lw $t2, table($s4)
addi $s4, $s4, 4
lw $t3, table($s4)
addi $s4, $s4, 4
lw $t4, table($s4)
sw $t0, table($s4)
subi $s4, $s4, 4
sw $t1, table($s4)
subi $s4, $s4, 4
sw $t2, table($s4)
subi $s4, $s4, 4
sw $t3, table($s4)
subi $s4, $s4, 4
sw $t4, table($s4)
la $v0, 4
la $a0, nl
syscall
jr $k0

#----------------------------------------
#Reverse Column Operation
#----------------------------------------

start5: jal reversecol
j loop
reversecol:
li $t0, 0
li $t1, 0
li $t2, 0
li $t3, 0
li $t4, 0
la $a0, entercolumn
li $v0, 4
syscall
li $v0, 5
syscall
blt $v0, 1, outsiderange
bgt $v0, 5, outsiderange
subi $t6, $v0, 1
li $t5, 0
move $k0, $ra
jal calculate
lw $t0, table($s4)
addi $s4, $s4, 20
lw $t1, table($s4)
addi $s4, $s4, 20
lw $t2, table($s4)
addi $s4, $s4, 20
lw $t3, table($s4)
addi $s4, $s4, 20
lw $t4, table($s4)
sw $t0, table($s4)
subi $s4, $s4, 20
sw $t1, table($s4)
subi $s4, $s4, 20
sw $t2, table($s4)
subi $s4, $s4, 20
sw $t3, table($s4)
subi $s4, $s4, 20
sw $t4, table($s4)
la $v0, 4
la $a0, nl
syscall
jr $k0

#----------------------------------------
#Add Rows
#----------------------------------------

start6: jal addrows
j loop
addrows:
li $t0, 0
li $t1, 0
li $t2, 0
li $t3, 0
li $t4, 0
move $ra, $k0
#First row start
la $a0, firstrow
li $v0, 4
syscall
li $v0, 5
syscall
blt $v0, 1, outsiderange
bgt $v0, 5, outsiderange
subi $t5, $v0, 1
li $t6, 0 
jal calculate
move $t0, $s4 #$t0 has first row start
#Second row start
la $a0, secondrow
li $v0, 4
syscall
li $v0, 5
syscall
blt $v0, 1, outsiderange
bgt $v0, 5, outsiderange
subi $t5, $v0, 1
li $t6, 0 
jal calculate
move $t1, $s4 #$t1 has second row start
#Get storing row
li $v0, 4
la $a0, sumrow
syscall
li $v0, 5
syscall
blt $v0, 1, outsiderange
bgt $v0, 5, outsiderange
subi $t5, $v0, 1
li $t6, 0 
jal calculate
move $t2, $s4 #$t3 has storing row start
#1
lw $t3, table($t0)
lw $t4, table($t1)
add $t4, $t4, $t3
sw $t4, table($t2)
addi $t0, $t0, 4
addi $t1, $t1, 4
addi $t2, $t2, 4
#2
lw $t3, table($t0)
lw $t4, table($t1)
add $t4, $t4, $t3
sw $t4, table($t2)
addi $t0, $t0, 4
addi $t1, $t1, 4
addi $t2, $t2, 4
#3
lw $t3, table($t0)
lw $t4, table($t1)
add $t4, $t4, $t3
sw $t4, table($t2)
addi $t0, $t0, 4
addi $t1, $t1, 4
addi $t2, $t2, 4
#4
lw $t3, table($t0)
lw $t4, table($t1)
add $t4, $t4, $t3
sw $t4, table($t2)
addi $t0, $t0, 4
addi $t1, $t1, 4
addi $t2, $t2, 4
#5
lw $t3, table($t0)
lw $t4, table($t1)
add $t4, $t4, $t3
sw $t4, table($t2)
li $v0, 4
la $a0, nl
syscall
jr $k0

#----------------------------------------
#Multiply Row By Constant
#----------------------------------------
start7: jal multrow
j loop
multrow:
li $t0, 0
li $t1, 0
li $t2, 0
li $t3, 0
li $t4, 0
la $a0, enterrow
li $v0, 4
syscall
li $v0, 5
syscall
blt $v0, 1, outsiderange
bgt $v0, 5, outsiderange
subi $t5, $v0, 1
li $t6, 0
move $k0, $ra
jal calculate
li $v0, 4
la $a0, enterconstant
syscall
li $v0, 5
syscall
move $t0, $v0
#1
lw $t1, table($s4)
mul $t1, $t1, $t0
sw $t1, table($s4)
addi $s4, $s4, 4
#2
lw $t1, table($s4)
mul $t1, $t1, $t0
sw $t1, table($s4)
addi $s4, $s4, 4
#3
lw $t1, table($s4)
mul $t1, $t1, $t0
sw $t1, table($s4)
addi $s4, $s4, 4
#4
lw $t1, table($s4)
mul $t1, $t1, $t0
sw $t1, table($s4)
addi $s4, $s4, 4
#5
lw $t1, table($s4)
mul $t1, $t1, $t0
sw $t1, table($s4)
li $v0, 4
la $a0, nl
syscall
jr $k0

#----------------------------------------
#Other Functions
#----------------------------------------

#Uses formula to find arbitrary table address
calculate:
#row index is stored in $t5
#column index is stored in $t6
li $s1, 0
li $s2, 0
li $s3, 0
li $s4, 0
li $s1, 4 #data size
li $a3, 5 #column amount
mult $t6, $s1 #column index * data size
mflo $s2
mult $t5, $a3 #row index * column amount
mflo $s3
mult $s3, $s1 #(row index * column amount) * data size
mflo $s3
add $s4, $s3, $s2 #(row index * column amount * data size) + (column index * data size)
jr $ra

#Prints error and returns to menu if given index is outside 1-5 range
outsiderange:
li $v0, 4
la $a0, invalid
syscall
j loop

#----------------------------------------
#Printing Functions
#----------------------------------------

#Prints table
printtable:
move $t8, $zero
#Row 1
li $v0, 4
la $a0, horizontal
addi $k1, $k1, 1
syscall
move $k0, $ra
add $t9, $zero, $zero
jal cell
#Row 2
li $v0, 4
la $a0, vertical
syscall
la $a0, nl
syscall
la $a0, horizontal
syscall
add $t9, $zero, $zero
jal cell
#Row 3
li $v0, 4
la $a0, vertical
syscall
la $a0, nl
syscall
la $a0, horizontal
syscall
add $t9, $zero, $zero
jal cell
#Row 4
li $v0, 4
la $a0, vertical
syscall
la $a0, nl
syscall
la $a0, horizontal
syscall
add $t9, $zero, $zero
jal cell
#Row 5
li $v0, 4
la $a0, vertical
syscall
la $a0, nl
syscall
la $a0, horizontal
syscall
add $t9, $zero, $zero
jal cell
li $v0, 4
la $a0, vertical
syscall
la $a0, nl
syscall
la $a0, horizontal
syscall
add $t9, $zero, $zero
jr $k0

#Create each table cell
cell:
beq $t9, 5, backtoprint
li $v0, 4
la $a0, vertical
syscall
li $v0, 1
lw $a0, table($t8)
syscall
addi $t8, $t8, 4
addi $t9, $t9, 1
bgt $a0, 9999, onespace
blt $a0, -999, onespace
bgt $a0, 999, twospace
blt $a0, -99, twospace
bgt $a0, 99, threespace
blt $a0, -9, threespace
bgt $a0, 9, fourspace
blt $a0, 0, fourspace
bgt $a0, -1, fivespace
backtoprint: jr $ra

#Prints five spaces for table to show up correctly with one digit numbers
fivespace:
li $v0, 4
la $a0, space
syscall
syscall
syscall
syscall
syscall
j cell

#Prints four spaces for table to show up correctly with two digit numbers
fourspace:
li $v0, 4
la $a0, space
syscall
syscall
syscall
syscall
j cell

#Prints three spaces for table to show up correctly with three digit numbers
threespace:
li $v0, 4
la $a0, space
syscall
syscall
syscall
j cell

#Prints two spaces for table to show up correctly with four digit numbers
twospace:
li $v0, 4
la $a0, space
syscall
syscall
j cell

#Prints one space for table to show up correctly with five digit numbers
onespace:
li $v0, 4
la $a0, space
syscall
j cell
