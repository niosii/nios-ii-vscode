# Nios II Basic

# Assign Configuration of Memory Addresses and Masks
.equ  LAST_RAM_WORD,  0x007FFFFC	# last word location in DRAM chip
# Assign Memory Location of TEXT & DATA
.equ  TEXT_RAM_LOC,	  0x00000000	# start memory location of code
.equ  DATA_RAM_LOC,	  0x00001000	# start memory location of variables

.section Code						          # code Section
.text								              # needed to indicate the start of a code segment
.global _start						        # makes the _start symbol visible to the linker
.org 	TEXT_RAM_LOC
# Entry of the Program
_start:	                          # Mainroutine
	movia	    sp,	    LAST_RAM_WORD		# init stack pointer, otherwise you cannot use it
	movia		r2,		List1
    movia		r3,		List2
    ldw		    r4,		N(r0)        # counter
    muli		r5,		r4,		4
    call		Reverse

_end:
    br		_end

Reverse:
	subi	sp, sp, 12
    stw 	ra, 8(sp)				# nested calls -- save ra
    stw		r2, 4(sp)				# store the original content of register
    stw		r3, 0(sp)
    movi	r4,		0

r_loop:
    ldw		r6,		24(r2)
    stw		r6,		0(r3)
    addi	r3,		r3,		4
    subi	r5,		r5,		4
    bne		r5,		0,		r_loop

r_end:
    ldw 	r3, 0(sp)
	ldw		r2, 4(sp)
	ldw		ra, 8(sp)
	addi	sp, sp, 12
	ret

.section Variables					      # variables declaration sections
.data
.org	DATA_RAM_LOC

N:          .word       7
List1:		.word		1,2,3,4,5,6,7
List2:		.skip       100

/*
Some Data
*/
.end
# End of the Program
