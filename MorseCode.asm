##############################################################
# Homework #2
# name: YanLiang Li
# sbuid: 110644059
##############################################################

.text

##############################
# PART 1 FUNCTIONS 
##############################

#--------------------------------------------------------------------------------------------
#toUpper: takes string parameter from a0 and convert the string to upper case-----
# take $a0 store input array
# return $v0 store ouput array
#--------------------------------------------------------------------------------------------
	toUpper:
	#Define your code here	
	move $s0, $0			# $s0 = array base register
	move $t1, $0
	la $s0, ($a0)          		# move the string input to $s0
	la $s1, toUpperArray
	addi $sp, $sp, -8		# make space on the stack
	sw $s0, 0($sp)			# save $s0 on the stack 
	sw $s1, 4($sp)
	
	loopUpper: 
	lb $t1, ($s0)			# load a character from the input string
	bge $t1, 41, checkUpper2	# and if ASCII of char is greater or equal to 41, char is uppercase
	checkUpper2:
	ble $t1, 90, doNoting		# if ASCII of char is less or equal to 90
	bgt $t1, 96, checkLower2	# char > 96
	checkLower2:
	blt $t1, 123, isLower		# and char < 123,   then char is lower case
	j doNoting
	isLower:
	addi $t1, $t1,-32		# if char is not already uppercase,  subtract 32 in ASCII to convert to upper
	doNoting:
	sb $t1, ($s1)
	addi $s1, $s1, 1		# $s0 ++
	addi $s0, $s0, 1		# $t0 ++
	bne $t1, 0, loopUpper		# loop until it hits a null termiantor
	la $v0, toUpperArray		# put final output in $v0
	lw $s0, 0($sp)			# store final array from stack
	lw $s1, 4($sp)
	addi $sp, $sp, 8		# deallocate stack space
	jr $ra

#--------------------------------------------------------------------------------------------
#length2Char: takes string parameter from a0 and a character parameter from a1,
#then calcualte and return the index of the first character in a1 appears in the 
#string (a0).
#--------------------------------------------------------------------------------------------
length2Char:
	move $s0, $0    		# $s0 = length = 0
	move $t0, $0
	move $t1, $0
	move $t3, $0
	move $t2, $0			# zero out registers
	la $t0,($a0)			# $t0 = input string
	move $t1, $a1			# t1 = char to find
	lb $t3, ($t1)
	addi $sp, $sp, -4		# store local varible on stack
	sw $s0, 4($sp)			# index = 0

	l2CharLoop:
	lb $t2, ($t0)			# load a char from input array in t2
	addi $s0, $s0, 1		# length++
	addi $t0, $t0, 1		# increment input array
	beq $t2, $t3, foundIt
	bne $t2, 0, l2CharLoop      	# loop till hit the null terminator	
	foundIt:
	addi $s0, $s0, -1		# do not count the null terminator
	move $v0, $s0			# put final output in $v0
	
	lw $s0, 4($sp)
	addi $sp, $sp, 4
	jr $ra

#--------------------------------------------------------------------------------------------
#strcmp: compare specific amount of characters in two strings, return the number of matching
# characters before returning,   and return 1 if all compared characters in str 1 match str2,
# 0, if otherwise
#-----------------------------------
# - strating with -
# str1  =  $a0
# str2  =  $a1
# number of char to compare =  $a2
# - return -
# $v0 = return 1
# $v1 = return 2
#--------------------------------------------------------------------------------------------
strcmp:
	move $s0, $0    		# $s0 = numMatch = 0
	move $s1, $0			# $s1 = 1 if str1 match str2,  0 otherwise
	move $t0, $0
	move $t1, $0
	move $t3, $0
	move $t2, $0
	move $t4, $0			# $t4 = loop counter
	move $t7, $0			# out of bounce condition checker	
	move $t5, $0			# zero out registers
	move $t6, $0
	addi $sp, $sp, -8		# make space on the stack
	sw $s0, 0($sp)			# save $s0 on the stack
	sw $s1, 4($sp)			# save $s1 
	la $t1, ($a0)			# $t1 = str1
	la $t2, ($a1)			# $t2 = str2
	la $t0, ($a2)
	move $t3, $a2			# $t3 = number of char to compare
	add $t7, $t3, $0		# check out of bounce
	bnez $t3, outofboundcheck	# if agr2 is not 0, compare given length
	
	# if arg2 is 0, compare till '\0' of str1
	looptillend:
	lb $t0, ($t1)			# str1[i]
	lb $t5, ($t2)			# str2[i]
	bnez $t0, cccont
	bnez $t5, cccont
	j theyaresame
	cccont: 
	bne $t0,$t5,endcmp		# if str1[i] != str2[i], end method
	addi $t2, $t2, 1		# length++
	addi $t1, $t1, 1		# increment input array
	addi $s0, $s0, 1
	bne $t1, 0, looptillend    	# loop till hit the null terminator
	theyaresame:
	addi $s1, $s1, 1		# if both str ended, -> all char str1 match str2
	j endcmp
	
	
	
	outofboundcheck:
	lb $t0, ($t1)			# read a char from str1 store in t0 
	beqz $t0, obcheck
	addi $t7, $t7, -1
	addi $t1, $t1, 1
	addi $t4, $t4, 1
	bne $t4, $t3, outofboundcheck
	obcheck:
	bnez $t7, outofbound
	move $t1, $0
	la $t1, ($a0)
	move $t4, $0			# check for out of bound
	
	strcmpLoop:
	lb $t0, ($t1)			# read a char from str1 store in t0 
	lb $t5, ($t2)			# read a char from str2 store in t5
	bne $t0, $t5, endcmp		# if str1[i] != str2[i]
	addi $t1, $t1, 1		# str1[i++]
	addi $t2, $t2, 1		# str2[i++]
	addi $t4, $t4, 1		# count++
	addi $s0, $s0, 1		# numMatch++
	bne $t4, $t3, strcmpLoop	# loop while count < arg3
	addi $s1, $s1, 1
	j endcmp
	
	outofbound:
	move $s0, $0
	move $s1, $0			# if out of bounce, return 0, 0
	endcmp:
	addi $t2, $t2, 1
	move $v0, $s0			# v0 = number of match
	move $v1, $s1			# v1 = 1 if all compared char in str1 match str2, 0 otherwise
	lw $s0, 0($sp)			# pop
	lw $s1, 4($sp)			# pop from stack
	addi $sp, $sp, 8
	jr $ra

#--------------------------------------------------------------------------------------------
#toMorse: Converts a plaintext message to morse code
#-----------------------------------
# - strating with -
# plaintex msg  			=  $a0
# morsecode  				=  $a1
# total number of bytes allocated 	=  $a2
# - return -
# $v0 = return int Returns length of morsecode
# $v1 = return int Returns 1 if plaintext message was
# completely and correctly encoded into morsecode,
# 0 otherwise (not enough space, error, etc).
#--------------------------------------------------------------------------------------------
toMorse:
	# empty the register to store local variables
	move $s0, $0			#$s0 = plaintext msg
	move $s1, $0			#$s1 = morsecode msg
	move $s2, $0			#$s2 = total number of bytes allocated 
	move $t0, $0
	move $t1, $0			
	move $t2, $0
	move $t3, $0			
	move $t4, $0
	move $t5, $0
	move $t6, $0			# out put size counter
	move $t7, $0			#empty regs
	move $v0, $0
	move $v1, $0
	addi $sp, $sp, -12		# make space on the stack
	sw $s0, 0($sp)			# push $s0 on the stack
	sw $s1, 4($sp)			# push $s1
	sw $s2, 8($sp)			# push $s2
	
	la $s0, ($a0)			# load plaintext msg into s0
	la $s1, ($a1)			# load return msg into s1
	move $s2, $a2			# load arg3
	addi $t6, $0, 1                 # counter++ (stores null terminator \0)
	bltz $s2, tomorseterminate	# return 0,0 for invaild input
	lb $t1, ($s0)			# read a byte from plaintext msg 
	bnez $t1, starttomorse
	addi $v0,$0,1
	addi $v1,$0,1
	j tomorseterminate
	starttomorse:
	la $t0, MorseCode		# t0 = off set morsecode array 
	bne $t1, 32, gogogomorse	# if space ,   print x
	addi $t6, $t6, 1		# count++
	j printax		
	gogogomorse:
	bgt $t1, 90, skipAchar		# if it is a lower case, go on to next 
	addi $t3, $t1, -33		# mius 33 to get the index of that byte in morsecode    
	sll $t3, $t3, 2			# ans * 4 (each element in morsecode array is 4 bytes)    
	add $t0, $t0, $t3		# increment morsecode array			
	lw $t2, ($t0)			# load the actual morsecode,  in t2         
	
	morsebuf:
	lb $t4, ($t2)			# write morsecode in outpur array byte by byte		
	sb $t4, ($s1)			# writ
	addi $t2, $t2, 1		# increment morsecode 
	addi $s1, $s1, 1		# increment outpur array
	addi $t6, $t6, 1		# counter++
	bnez $t4, morsebuf
	addi $s1, $s1, -1
	#addi $t6, $t6, 1
	printax:
	addi $t7, $0, 120
	sb $t7, ($s1)			# write
	addi $s1, $s1, 1		# print x
	
	skipAchar:
	addi $s0, $s0, 1
	lb $t1, ($s0)			# read a byte from plaintext msg
	bne $t1, 0, starttomorse
	addi $t0, $0, 120
	sb $t0, ($s1)			# print the termination x
	addi $t6, $t6, 1
	###########

	# getting out of the loop
	bge $s2, $t6, dontomorsefit 	# if counter <= size, return counter and 1
	sub $t4, $s2, $t6               # size - counter  ( - some number)
	add $s1, $s1, $t4		# index of chop off char
	addi $s1, $s1, 1		# real index
	move $t5, $0
	sb $t5, ($s1)			# cut off the string
	move $v0, $s2			# return size
	move $v1, $0			# and return 0
	j tomorseterminate
	
	dontomorsefit:		
	move $v0, $t6			# v0 = number of bytes allocated to store morse code sequence and '\0' terminator
	addi $v1, $0, 1			# v1 = 1 if plaintext msg was completly encoded into morsecode, 0 otherwise
	
	tomorseterminate:
	lw $s0, 0($sp)			# pop
	lw $s1, 4($sp)			# pop from stack
	lw $s2, 8($sp)			# push $s2
	addi $sp, $sp, 12
	jr $ra





#--------------------------------------------------------------------------------------------
#createKey: Extracts all unique alphabet characters from the
#input string 'phrase' in the order of their appearance
# and places them into key. 
#-----------------------------------
# - strating with -
# $v0 = to upper array
# phrase Starting address of the `phrase` to extract 				=  $a0
# key Starting address of 26-bytes of memory to store the output message. 	=  $a1
# - return -
# $v0 = input
# $v1 = key 
#--------------------------------------------------------------------------------------------
createKey:
	move $t0, $0
	move $t1, $0
	move $t2, $0
	move $t3, $0
	move $t4, $0
	move $t5, $0
	move $t6, $0			# ouput array countter i
	move $t7, $0
	addi $sp, $sp, -16
	
	sw $s0, 0($sp)	
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)
	jal toUpper
	la $s0, toUpperArray         	# returned arry with no lower cases
	la $s1, ($a1)			# output array
	la $s2, truethTable
	zeroout:
	sb $0, ($s2)
	addi $s2, $s2, 1
	addi $t4, $t4, 1
	blt $t4, 26, zeroout         	# zero out the truth table
	
	loopkey:
	la $s2, truethTable	
	lb $t0, ($s0)			#load a letter
	blt $t0, 65, skipletter
	bgt $t0, 90, skipletter        
	addi $t1, $t0, -65  		# letter - A,,, index of truthTable
	add $s2, $s2, $t1
	lb $t3, ($s2)          		# load index x from truethtable
	beq $t3, 1, skipletter
	addi $t3, $t3, 1
	sb $t3, ($s2)			# 1/0 switch
	sb $t0, ($s1)			# store the letter
	addi $s1, $s1, 1		# increment output array
	addi $t6, $t6, 1		#i ++
	skipletter:
	addi $s0, $s0, 1
	bnez $t0, loopkey
	#end of this loop... output array should fill with upper case letters cuts off input array
	bgt $t6, 26, terminatekey	#if size alrady full, skip and return the functio
	
	la $s2, truethTable		# offset of truth table
	move $t4, $0
	move $t5, $0
	filltherest:
	lb $t3, ($s2)
	bnez $t3, alreadythere
	addi $t5, $t4, 65        	# index + 65 = actual letter
	sb $t5, ($s1)
	addi $s1, $s1, 1		# store the nect letter
	alreadythere:
	addi $s2, $s2, 1
	addi $t4, $t4, 1
	blt $t4, 26, filltherest
	
	terminatekey:
	lw $ra, 12($sp)
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	
	addi $sp, $sp, 16
	jr $ra



#--------------------------------------------------------------------------------------------
#keyIndex:  Match the first 3 characters of the morse code message
# and return the corresponding key index value. 
#----------------------------------------------
# - strating with -
# 
# mcmg Starting address of string to match				=  $a0
# - return --
# $v0 = Return the key index of the 3 character match  or -1 if no match 
#--------------------------------------------------------------------------------------------
keyIndex:
	move $t0, $0			#
	move $t1, $0			#
	move $t3, $0			#
	move $t2, $0			#
	move $t4, $0			# 
	move $t7, $0			# 
	move $t5, $0			# zero out registers
	move $t6, $0
	
	la $s0, ($a0)			# input address
	lb $t1, ($s0)		
	bnez $t1, continuekeyindex
	addi $v0, $0, -1
	jr $ra
	continuekeyindex:
	la $s1, FMorseCipherArray	# $s1 has str2
	addi $s2, $0, 3			# s2 has 3
	addi $s3, $0, 0
	addi $sp, $sp, -20
	sw $s0, 4($sp)			# push on stack
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	addi $s1, $s1, -3
	
	calltostrcmp:
	addi $t4, $0, 3  		# t4 = 3
	sw $ra, 0($sp)
	la $a0, ($s0)			# arg1  str1
	la $a1, ($s1)			# arg2  str2
	addi $a1, $a1, 3
	addi $a2, $s2, 0		# arg3  int 
	jal strcmp
	lw $ra, 0($sp)           	
	move $t7, $v1
	bnez $t7, foundit
	la $s0,($a0)
	la $s1,($a1)
	addi $s3, $s3, 1		# index++	
	ble $s3, 25, calltostrcmp
	# braking out the loop, if not found, return -1
	addi $v0, $0, -1
	j popkeyindex
	foundit:
	move $v0, $s3
	
	popkeyindex:
	lw $s0, 4($sp)			# pop from stack
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20
	jr $ra

#--------------------------------------------------------------------------------------------
#FMCEncrypt:  Encrypt the plaintext message into the encryptBuffer
# with the Fractionated Morse Cipher. Use the phrase to
# create the key. 
#----------------------------------------------
# - strating with -
# 
# 
# - return --
# $v0 = address of encrytped 
# $v1 = Return the key index of the 3 character match  or -1 if no match 
#--------------------------------------------------------------------------------------------
FMCEncrypt:
	move $t0, $0			#
	move $t1, $0			#
	move $t3, $0			#
	move $t2, $0			#
	move $t4, $0			# 
	move $t5, $0			# zero out registers
	move $t6, $0
	move $t7, $0			# 
	
	
	
	la $s0, ($a0)			#plain text
	la $s1, ($a1)			#pharse
	la $s2, ($a2)			# encode buffer
	move $s3, $a3			# size 
	addi $s4, $0, 0			# return 1 or 0 in end
	la $s5, intermediateMorseCode	# morsecode 
	la $s6, intermediateKey		# keys
	addi $s7, $0, -3		# loop index
	
	addi $sp, $sp, -36
	sw $s5, 0($sp)
	sw $s0, 4($sp)			# push on stack
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)			# push on stack
	
	sw $ra, 32($sp)
	la $a0, ($s0)			# arg1 = plain text
	la $a1, ($s5)			# agr2 = morse code array
	la $a2, ($s3)			# arg3 = size
	jal toMorse
	sw $v1, 20($sp)
	lw $ra, 32($sp)			# return from morse code
	lw $s5, 0($sp)			# s5 as morse code array
	lw $s0, 4($sp)			# restore s0 as plain text
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)			# s3 as size
	lw $s4, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)			# restore s0-s7

	
	
	sw $ra, 32($sp)
	la $a0, ($s1)
	la $a1, ($s6)
	jal createKey
	lw $ra, 32($sp)
	lw $s5, 0($sp)			# s5 as morse code array
	lw $s0, 4($sp)			# restore s0 as plain text
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)			# s3 as size
	lw $s4, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)			# restore s0-s7
	
	
	theLastLoop:
	sw $ra, 32($sp)
	la $a0, ($s5)
	jal keyIndex
	sw $v0, 28($sp)
	
	lw $ra, 32($sp)
	la $s5, ($a0)			# s5 as morse code array
	lw $s0, 4($sp)			# restore s0 as plain text
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)			# s3 as size
	lw $s4, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)			# restore s0-s7
	
	move $t7, $s7
	la $t3, ($s2)
	finnnnnd:
	la $t0, ($s6)
	add $t0, $t0, $t7
	lb $t1, ($t0)
	sb $t1, ($t3)
	addi $t3,$t3,1
	
	
	
	
	la $v0, ($s2)
	move $v1, $s4
	
	lw $s5, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 36		#pop off stack
	
	jr $ra

##############################
# EXTRA CREDIT FUNCTIONS
##############################

FMCDecrypt:
	#Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	la $v0, FMorseCipherArray
	############################################
	jr $ra

fromMorse:
	#Define your code here
	jr $ra


.data

MorseCode: .word MorseExclamation, MorseDblQoute, MorseHashtag, Morse$, MorsePercent, MorseAmp, MorseSglQoute, MorseOParen, MorseCParen, MorseStar, MorsePlus, MorseComma, MorseDash, MorsePeriod, MorseFSlash, Morse0, Morse1,  Morse2, Morse3, Morse4, Morse5, Morse6, Morse7, Morse8, Morse9, MorseColon, MorseSemiColon, MorseLT, MorseEQ, MorseGT, MorseQuestion, MorseAt, MorseA, MorseB, MorseC, MorseD, MorseE, MorseF, MorseG, MorseH, MorseI, MorseJ, MorseK, MorseL, MorseM, MorseN, MorseO, MorseP, MorseQ, MorseR, MorseS, MorseT, MorseU, MorseV, MorseW, MorseX, MorseY, MorseZ 

MorseExclamation: .asciiz "-.-.--"
MorseDblQoute: .asciiz ".-..-."
MorseHashtag: .ascii ""
Morse$: .ascii ""
MorsePercent: .ascii ""
MorseAmp: .ascii ""
MorseSglQoute: .asciiz ".----."
MorseOParen: .asciiz "-.--."
MorseCParen: .asciiz "-.--.-"
MorseStar: .ascii ""
MorsePlus: .ascii ""
MorseComma: .asciiz "--..--"
MorseDash: .asciiz "-....-"
MorsePeriod: .asciiz ".-.-.-"
MorseFSlash: .ascii ""
Morse0: .asciiz "-----"
Morse1: .asciiz ".----"
Morse2: .asciiz "..---"
Morse3: .asciiz "...--"
Morse4: .asciiz "....-"
Morse5: .asciiz "....."
Morse6: .asciiz "-...."
Morse7: .asciiz "--..."
Morse8: .asciiz "---.."
Morse9: .asciiz "----."
MorseColon: .asciiz "---..."
MorseSemiColon: .asciiz "-.-.-."
MorseLT: .ascii ""
MorseEQ: .asciiz "-...-"
MorseGT: .ascii ""
MorseQuestion: .asciiz "..--.."
MorseAt: .asciiz ".--.-."
MorseA: .asciiz ".-"
MorseB:	.asciiz "-..."
MorseC:	.asciiz "-.-."
MorseD:	.asciiz "-.."
MorseE:	.asciiz "."
MorseF:	.asciiz "..-."
MorseG:	.asciiz "--."
MorseH:	.asciiz "...."
MorseI:	.asciiz ".."
MorseJ:	.asciiz ".---"
MorseK:	.asciiz "-.-"
MorseL:	.asciiz ".-.."
MorseM:	.asciiz "--"
MorseN: .asciiz "-."
MorseO: .asciiz "---"
MorseP: .asciiz ".--."
MorseQ: .asciiz "--.-"
MorseR: .asciiz ".-."
MorseS: .asciiz "..."
MorseT: .asciiz "-"
MorseU: .asciiz "..-"
MorseV: .asciiz "...-"
MorseW: .asciiz ".--"
MorseX: .asciiz "-..-"
MorseY: .asciiz "-.--"
MorseZ: .asciiz "--.."

FMorseCipherArray: .asciiz ".....-..x.-..--.-x.x..x-.xx-..-.--.x--.-----x-x.-x--xxx..x.-x.xx-.x--x-xxx.xx-"
toUpperArray: .word 0
toMorseArray: .space 400
truethTable: .space 30
intermediateMorseCode: .space 100
intermediateKey: .space 26

