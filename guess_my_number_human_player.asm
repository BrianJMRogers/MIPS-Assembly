# This lab assignment was written by Brian Rogers and Rowan Castellanos


.data
	too_low: .asciiz "That guess was too low\n"
    too_high: .asciiz  "that guess was too high\n"
    correct_message: .asciiz "\nCorrect!\n"
    welcome_message: .asciiz "My number is between 1 and 100 (inclusive)\n"
    guess_message: .asciiz "Guess my number: "
	invalid_input: .asciiz "Invalid input\n"
	exit_message: .asciiz "Thanks for playing!\n"
	took_this_many_guesses: .asciiz "It took you this many guesses: "
	play_again_message: .asciiz "Would you like to play again? Yes == 1, no == 0\n"
	the_number_is_message: .asciiz "The number is: "
	new_line: .asciiz "\n"
.text

	# # # # # # DATA TABLE # # # # # # # 
	#	$s0			number to guess
	#	$s1			player's guess
	#	$s2			number of player's guesses

	BEGIN:
		# # # # # # # # # # # # # # # # # # # # # # #
		# GET RANDOM NUMBER
		# # # # # # # # # # # # # # # # # # # # # # #
		li $a1, 100 # upper bound
		li $v0, 42   # random num between 0-99
		syscall # stores random number in $a0
	
		addi $a0 $a0 1 # incrememnt so it's between 1-100
		move $s0 $a0 # store in $s0
	
		# # # # # # # # # # # # # # # # # # # # # # #
		# CALL WELCOME FUNCTION
		# # # # # # # # # # # # # # # # # # # # # # #
		jal WELCOME
	
			# # # # # # # # # # # # # # # # # # # # # # #
		# WHILE LOOP
		# # # # # # # # # # # # # # # # # # # # # # #
	
		WHILE_LOOP:
			jal GET_INPUT # input is in $v0

			add $s2 $s2 1
			
			move $a0 $v0 # move input val from $v0 to $a0 for argument passing
			la $a1 0($s0) # put address of correct num into $a1
		
			# determine if the guess was too high, too low, correct
			# answer report is stored in $v0. If negative, guess too low,
			# if positive, guess too high, if 0, guess correct
			jal ANSWER_REPORT 
			
			# move return value from $v0 to $t0
			move $t0 $v0
	
			bgtz $t0 WHILE_LOOP_TOO_HIGH # if too high, go to too high
			bltz $t0 WHILE_LOOP_TOO_LOW # if too low, go to too low
	
				# otherwise we fall through to correct since that's the
			# only other possibility
	
			WHILE_LOOP_CORRECT:
				la $a0 took_this_many_guesses
				li $v0 4
				syscall
				
				la $a0 0($s2)
				li $v0 1
				syscall

				la $a0 new_line
				li $v0 4
				syscall


		
				# CHANGE TO PLAY AGAIN
				j PLAY_AGAIN 
		
			WHILE_LOOP_TOO_HIGH:
				la $a0 too_high
				li $v0 4
				syscall
	
				j WHILE_LOOP
		
			WHILE_LOOP_TOO_LOW:
				la $a0 too_low
				li $v0 4
				syscall
	
				j WHILE_LOOP

	

	j EXIT

	PLAY_AGAIN:
		# PROLOGUE
		# nothing here since we wont return to that location
		li $s2 0
		# BODY
		la $a0 play_again_message
		li $v0 4
		syscall

		# take in input.
		li $v0, 5
		syscall

		bgtz $v0 BEGIN

		j EXIT

	ANSWER_REPORT:
		# PROLOGUE
		sw $ra 0($sp)

		# BODY
		sub $v0 $a0 $a1 # $t0 = guess - num. Pass back via $v0 retval

		# EPILOGUE
		lw $ra 0($sp)
		jr $ra



	GET_INPUT:
		# PROLOGUE
		sw $ra 0($sp)

		# BODY
		# prompt user for input
		la $a0 guess_message
		li $v0 4
		syscall

		# take in input. It will remain in the return val register $v0
		li $v0, 5
		syscall

		# EPILOGUE
		lw $ra 0($sp)
		jr $ra



 	# WELCOME FUNCTION
	WELCOME:
		# PROLOGUE - not much to do here since we don't have values yet
		sw $ra 0($sp)
		
		# BODY	
		la $a0 welcome_message
		li $v0 4
		syscall
		
		# EPILOGUE
		lw $ra 0($sp)
		jr $ra



	# EXIT FUNCTION
	EXIT:
 	   # print newline 
		la $a0 new_line
		li $v0 4
		syscall 
	
   		# print exit message
		la $a0 exit_message
		li $v0 4
		syscall
		
   		# exit program
		li $v0, 10
		syscall

		

