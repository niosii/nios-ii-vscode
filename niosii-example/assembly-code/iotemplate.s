# Author: estKey
# Date: Jan, 7, 2019
# Nios II Assembly I/O Template

# Assign Configuration of Memory Addresses and Masks
.equ  LAST_RAM_WORD,  0x007FFFFC	# last word location in DRAM chip
.equ  JTAG_UART_BASE, 0x10001000	# address of first JTAG UART register
.equ  DATA_OFFSET,    0				# offset of JTAG UART data register
.equ  STATUS_OFFSET,  4				# offset of JTAG UART status register
.equ  WSPACE_MASK,    0xFFFF		# used in AND operation to check status
.equ  RVALID_MASK,	  0x8000		# used in AND operation to check if there is data to be read
.equ  DATA_MASK,	  0xFF			# used in AND operation to get the input data
# Assign Memory Location of TEXT & DATA
.equ  TEXT_RAM_LOC,	  0x00000000	# start memory location of code
.equ  DATA_RAM_LOC,	  0x00001000	# start memory location of variables

.section Code						# code Section
.text								# needed to indicate the start of a code segment
.global _start						# makes the _start symbol visible to the linker
.org 	TEXT_RAM_LOC

# Main
_start:	
	movia	sp,	LAST_RAM_WORD		# init stack pointer, otherwise you cannot use it
	movia 	r2,	MSG_STARTUP
	call 	PrintString
    call	STRING
    call	DIGHT
    call	HEXDIGHT
_end:	br 	_end
# End of the Main

#
STRING:
	subi	sp, sp, 4
    stw		ra, 0(sp)
    movia	r2, MSG_PRINTTYPE
    call	PrintString
    call	GetString
	movia	r2, STRING_BUFFER
    call	PrintString
    call	NEWLINE
    ldw		ra, 0(sp)
    addi	sp, sp, 4
    ret
    
#
DIGHT:
	subi	sp, sp, 4
    stw		ra, 0(sp)
    movia	r2, MSG_PRINTTYPE
    call	PrintString
    call	GetDightList
    call	NEWLINE
    movia	r2, NUMBER_BUFFER
    call	PrintDightList
    call	NEWLINE
    ldw		ra, 0(sp)
    addi	sp, sp, 4
    ret

#
HEXDIGHT:
	subi	sp, sp, 4
    stw		ra, 0(sp)
    movia	r2, MSG_PRINTTYPE
    call	PrintString
    call	GetHexDightList
    call	NEWLINE
    movia	r2, NUMBER_BUFFER
    call	PrintHexDightList
    call	NEWLINE
    ldw		ra, 0(sp)
    addi	sp, sp, 4
    ret

# helpers
NEWLINE:
	subi	sp, sp, 8
    stw		ra, 4(sp)
    stw		r2,	0(sp)
    movi	r2, '\n'
    call	PrintChar
    ldw		r2, 0(sp)
    ldw		ra, 4(sp)
    addi	sp, sp, 8
    ret
#

###////////////  Start of the Subroutine  \\\\\\\\\\\###
# GetChar Subroutine
GetChar:
	subi	sp, sp, 8
	stw		r3, 4(sp)				# temp to keep JTAG_UART_BASE address
	stw		r4, 0(sp)				# local st variable
	movia	r3, JTAG_UART_BASE		# put JTAG_UART_BASE address into r3
gc_loop:
	ldwio	r2, DATA_OFFSET(r3)		# read data register into r2
	andi	r4, r2, RVALID_MASK		# mask all bits except RVALID
	beq		r4, r0, gc_loop			# check to see if something can be read, if not keep checking
	andi	r2, r2, DATA_MASK		# replace the full data register bit pattern with the character data we actually want
end_gc_loop:	
    ldw 	r4, 0(sp)
	ldw		r3, 4(sp)
	addi	sp, sp, 8
	ret
    
# GetString Subroutine
### Will Terminate by typing Enter '\n'
GetString:
	subi 	sp, sp, 12
	stw 	ra, 8(sp)				# nested calls -- save ra
	stw 	r3, 4(sp)				# r3 is the buffer pointer
	stw 	r4, 0(sp)				# r4 will holds the condition that exit the loop
	movia	r3,	STRING_BUFFER		# place STRING_BUFFER address into r3
	movi 	r4, '\n'				# prepare the if condition
gs_loop:
	call 	GetChar					# get a charcter from io
	beq 	r2, r4, end_gs_loop		# newline causes exit from loop
	call	PrintChar				# print out what was just typed onto the screen (character still in r2)
	stb		r2, DATA_OFFSET(r3)		# store that character (byte size) into the first place in the string buffer
	addi	r3, r3, 1				# increment the address of buffer pointer by 1 byte
	br		gs_loop					# go back to start of loop and keep checking until you hit enter
end_gs_loop:
	stb 	r0, DATA_OFFSET(r3)		# write 0 to terminate the string
	movi 	r2, '\n'				# store '\n' in r2
	call 	PrintChar				# print a '\n'
    ldw		r4,	0(sp)
	ldw 	r3, 4(sp)
	ldw 	ra, 8(sp)
	addi 	sp, sp, 12
	ret
    
# GetDight Subroutine
# recieve input of dight, any other input will be omitted
GetDight:
	subi	sp, sp, 16
    stw		ra, 12(sp)
    stw		r3, 8(sp)
    stw		r4, 4(sp)
    stw		r5, 0(sp)
    movi	r3, '0'
    movi	r4, '9'
    movi	r5, '\n'
gd_loop:
	call	GetChar
    beq		r2,	r5,	end_gd_loop
    blt		r2,	r3, gd_loop
    bgt		r2,	r4, gd_loop
    subi	r2,	r2, '0'
end_gd_loop:
	ldw		r5, 0(sp)
    ldw		r4, 4(sp)
    ldw		r3, 8(sp)
    ldw		ra, 12(sp)
	addi	sp, sp, 16
    ret

# GetDightList Subroutine
# recieve a list of [word-size] dights, entering 0 will terminate the subroutine
GetDightList:
	subi	sp, sp, 12
    stw		ra, 8(sp)
    stw		r3, 4(sp)
    stw		r4,	0(sp)
    movia	r3,	NUMBER_BUFFER		# place NUMBER_BUFFER address into r3
    movi	r4,	'\n'
gdl_loop:
	call	GetDight
    beq		r2,	r4,	end_gdl_loop
    call	PrintDight
    stw		r2, DATA_OFFSET(r3)
    addi	r3,	r3, 4
    br		gdl_loop
end_gdl_loop:
	stw		r2, DATA_OFFSET(r3)		# put '\n' at the end of the list
    ldw		r4,	0(sp)
    ldw		r3, 4(sp)
    ldw		ra, 8(sp)
	addi	sp, sp, 12
    ret
    
# GetHexDight Subroutine
GetHexDight:
	subi	sp, sp, 8
    stw		ra, 4(sp)
    stw		r3, 0(sp)
ghd_loop:
	call	GetChar
    #movi	r3,	'\n'
    #beq		r2,	r3,	end_ghd_loop
ghd_check_number:					# check if the input is in range of 0-9
	movi	r3, '0'
    blt		r2, r3, ghd_check_alpha
    movi	r3, '9'
    bgt		r2,	r3, ghd_check_alpha
    br		ghd_handle_number
ghd_check_alpha:					# check if the input is in range of a-f (0x57) A-F (0x37)
	movi	r3, 'a'
    blt		r2, r3, ghd_loop		# keep check if not acceptable alpha
    movi	r3,	'f'
    bgt		r2, r3, ghd_loop
    br		ghd_handle_alpha
ghd_handle_number:					# do the same thing as the GetDight
	subi	r2, r2, '0'
    br		end_ghd_loop
ghd_handle_alpha:
	subi	r2,	r2,	0x57
end_ghd_loop:
    ldw		r3, 0(sp)
    ldw		ra, 4(sp)
	addi	sp, sp, 8
    ret
      
# GetHexDight Subroutine
# recieve a list of [word-size] dights, entering 0 will terminate the subroutine
GetHexDightList:
	subi	sp, sp, 12
    stw		ra, 8(sp)
    stw		r3, 4(sp)
    stw		r4,	0(sp)
    movia	r3,	NUMBER_BUFFER		# place NUMBER_BUFFER address into r3
    movi	r4,	'\n'
ghdl_loop:
	call	GetHexDight
    beq		r2,	r0,	end_ghdl_loop	# exit loop while recive enter
	call	PrintHexDight
    stw		r2, DATA_OFFSET(r3)		# store word
    addi	r3,	r3, 4				# increment by 1
    br		ghdl_loop
end_ghdl_loop:
	stw		r2, DATA_OFFSET(r3)		# put '\n' at the end of the list
    ldw		r4,	0(sp)
    ldw		r3, 4(sp)
    ldw		ra, 8(sp)
	addi	sp, sp, 12
    ret
    
# PrintChar Subroutine
PrintChar:							
	subi	sp,	sp,	8				# adjust stack pointer down to reserve space
    stw  	r3, 4(sp)				# save value of register r3 so it can be a temp
    stw  	r4, 0(sp)				# save value of register r4 so it can be a temp
    movia 	r3, JTAG_UART_BASE		# point to first memory-mapped I/O register
pc_loop:
    ldwio 	r4, STATUS_OFFSET(r3)	# read bits from status register
    andhi 	r4, r4, WSPACE_MASK		# mask off lower bits to isolate upper bits
    beq   	r4, r0, pc_loop			# if upper bits are zero, loop again
    stwio 	r2, DATA_OFFSET(r3)		# store the character into the JTAG_UART I/O location
end_pc_loop:  
    ldw   	r3, 4(sp)				# restore value of r3 from stack
    ldw   	r4, 0(sp)				# restore value of r4 from stack
    addi  	sp, sp, 8				# readjust stack pointer up to deallocate space
    ret								# return to calling routine

# PrintString Subroutine
PrintString:
    subi 	sp,	sp,	12				
    stw 	ra, 8(sp)				# nested calls -- save ra
    stw 	r3, 4(sp)				# for use as a local pointer in string
    stw 	r2, 0(sp)				# save original string pointer
    mov 	r3, r2					# prepare local pointer
ps_loop:
    ldb 	r2, DATA_OFFSET(r3)		# get character
    beq 	r2, r0, end_ps_loop		# check if character is zero
    call 	PrintChar				# non-zero, so print it
    addi 	r3,	r3,	1				# advance the pointer
    br 		ps_loop					# repeat the loop body
end_ps_loop:
    ldw 	ra, 8(sp)				# recover saved registers
    ldw 	r3, 4(sp)
    ldw 	r2, 0(sp)
    addi 	sp, sp, 12
    ret

# PrintDight Subroutine
PrintDight:
	subi	sp, sp, 8
    stw 	ra, 4(sp)				# nested calls -- save ra
    stw		r2, 0(sp)				# store the original content of register
    addi 	r2,	r2,	'0'				# advance the number to become a character
    call 	PrintChar				# non-zero, so print it
    ldw 	r2, 0(sp)
    ldw 	ra, 4(sp)				# recover saved registers
	addi	sp, sp, 8
    ret
  
# PrintDight Subroutine
PrintDightList:
    subi 	sp,	sp,	16				
    stw 	ra, 12(sp)				# nested calls -- save ra
    stw 	r2, 8(sp)				# save original string pointer
    stw 	r3, 4(sp)				# for use as a local pointer in string
    stw		r4,	0(sp)
    mov 	r3, r2					# prepare local pointer
    movi	r4,	'\n'
pdl_loop:
    ldw 	r2, DATA_OFFSET(r3)		# get character
    beq 	r2, r4, end_pdl_loop	# check if character is '\n' 0xa
    call 	PrintDight				# non-zero, so print it
    addi 	r3,	r3,	4				# advance the pointer
    br 		pdl_loop				# repeat the loop body
end_pdl_loop:
	ldw		r4,	0(sp)
    ldw 	r3, 4(sp)
    ldw 	r2, 8(sp)
	ldw 	ra, 12(sp)				# recover saved registers
    addi 	sp, sp, 16
    ret


# PrintHexDight Subroutine
PrintHexDight:
	subi	sp, sp, 12
    stw 	ra, 8(sp)				# nested calls -- save ra
    stw		r2, 4(sp)				# store the original content of register
    stw		r3, 0(sp)
    blt		r2,	r0,	end_phd			# check if the value exceed the lower boundary of hex decimal
    movi	r3, 0x0000000a
    blt		r2, r3, phd_handle_number
    movi	r3, 0x0000000f			# check if the value exceed the upper boundary of hex decimal
    ble		r2, r3, phd_handle_alpha
    br		end_phd					
phd_handle_number:
    addi 	r2,	r2,	'0'				# advance the number to become a character
    br		end_phd
phd_handle_alpha:
	addi	r2, r2, 0x57			# make the hex number become related capitalized alpha
end_phd:
    call 	PrintChar				# non-zero, so print it
    ldw		r3, 0(sp)
    ldw 	r2, 4(sp)
    ldw 	ra, 8(sp)				# recover saved registers
	addi	sp, sp, 12
    ret
	
# PrintHexDightList Subroutine
PrintHexDightList:
    subi 	sp,	sp,	16				
    stw 	ra, 12(sp)				# nested calls -- save ra
    stw 	r2, 8(sp)				# save original string pointer
    stw 	r3, 4(sp)				# for use as a local pointer in string
    stw		r4,	0(sp)
    mov 	r3, r2					# prepare local pointer
    movi	r4,	'\n'	
phdl_loop:
    ldb 	r2, DATA_OFFSET(r3)		# get character
    beq 	r2, r0, end_phdl_loop	# check if character is zero
    call 	PrintHexDight			# non-zero, so print it
    addi 	r3,	r3,	4				# advance the pointer
    br 		phdl_loop				# repeat the loop body
end_phdl_loop:
	ldw		r4,	0(sp)
    ldw 	r3, 4(sp)
    ldw 	r2, 8(sp)
	ldw 	ra, 12(sp)				# recover saved registers
    addi 	sp, sp, 16
    ret


.section Variables					# variables declaration sections
.data
.org	DATA_RAM_LOC
MSG_STARTUP:	.asciz	"NIOS II Assembly Language\n"
MSG_INTRO:		.asciz	"Wellcome to NISO II Assembly, press:" 
MSG_PRINTTYPE:	.asciz	"You Typed:\n"

N_STRING:		.word	100
N_NUMBER:		.word	100
STRING_BUFFER: 	.skip	100
NUMBER_BUFFER:	.skip	400
.end 
# End of the Program