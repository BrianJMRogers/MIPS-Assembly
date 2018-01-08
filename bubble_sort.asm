.data
	a: .word 8 52 30 71 88 93 15 2 6 48 29 84 29 27 62
	unsorted_message: .asciiz "The unsorted array: "
	sorted_message: .asciiz "The sorted array: "
	exit_message: .asciiz "Exiting...\n"
	comparing_message: .asciiz "\tComparing: "
	new_line: .asciiz "\n"
	space: .asciiz " "
.text
	
	# print unsorted array
	la $a0 unsorted_message
	li $v0 4
	syscall
	jal PRINT_ARRAY

	jal SORT_ARRAY
	
	# print sorted array
	la $a0 sorted_message
	li $v0 4
	syscall
	jal PRINT_ARRAY

	
	jal EXIT	


	SORT_ARRAY:
		sw $ra, 0($sp)
			
		# # # # #  c to mips values # # # # # # 
		# $t0 	i
		# $t1	k
		# $t2 	k+1
		# $t4	size
		# $t5	temp
		# $t6	a[k]
		# $t7	a[k+1]
		# # # # # # # # # # # # # # # # 
		
		li $t0 0 	# assign i 
		li $t1 0	# assign k 
		li $t2 4	# assign k+1 
		li $t4 56	# assign size 
		li $t5 0	# assign temp 
		li $t6 0	# assign a[k]
		li $t7 0	# assign a[k+1]

		SORT_ARRAY_OUTER_LOOP_BEGIN:
			# check that we're still in the bounds
			beq $t0 $t4 SORT_ARRAY_END

			SORT_ARRAY_INNER_LOOP_BEGIN:
				beq $t1 $t4 SORT_ARRAY_OUTER_LOOP_END
				
				# load a[k] and a[k+1]
				lw $t6 a($t1)	# $t6 = a[k]
				lw $t7 a($t2)	# $t7 = a[k+1]

				# if a[k] >= a[k+1], don't swap
				bge $t6 $t7 SORT_ARRAY_SWAP_END
				
				SORT_ARRAY_SWAP_BEGIN:
					sw $t7 a($t1)	# a[k] = a[k+1]
					sw $t6 a($t2)	# a[k+1] = temp

				SORT_ARRAY_SWAP_END:		

			SORT_ARRAY_INNER_LOOP_END:
				add $t1 $t1 4 	# iterate k
				add $t2 $t2 4 	# iterate k+1
				j SORT_ARRAY_INNER_LOOP_BEGIN	# go to top of loop
			
		SORT_ARRAY_OUTER_LOOP_END:
			add $t0 $t0 4 # iterate i
			li $t1 0	# assign k 
			li $t2 4	# assign k+1 
			j SORT_ARRAY_OUTER_LOOP_BEGIN	# go to top of loop



	SORT_ARRAY_END:
		lw $ra, 0($sp)
		jr $ra
	


	PRINT_ARRAY:
		sw $ra, 0($sp)
		li $t0 60 # this is the byte size of our array
		li $t1 0
		
		PRINT_ARRAY_LOOP_BEGIN:
			# print item from array
			lw $a0 a($t1)		
			li $v0 1
			syscall  			

			# print space char
			la $a0 space
			li $v0 4
			syscall  			
			add $t1 $t1 4
			
			# loop back
			beq $t0 $t1 PRINT_ARRAY_LOOP_END
			j PRINT_ARRAY_LOOP_BEGIN
		
		PRINT_ARRAY_LOOP_END:
			la $a0 new_line
			li $v0 4
			syscall

			lw $ra, 0($sp)
			jr $ra



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
		

# bubble sort in C
#for(i = 0; i < size; i++) {
#        for (k = 0; k < size - 1; k++) {
#            if (a[k] < a[k+1]){
#                temp = a[k];
#                a[k] = a[k+1];
#                a[k+1] = temp;
#            }
#        }
#    }

