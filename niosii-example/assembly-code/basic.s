# Nios II Basic Example

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
	/*
  Some Code
  */
InfiniteLoop:	                            # Subroutine
  br InfiniteLoop
_end:	br 	_end

.section Variables					      # variables declaration sections
.data
.org	DATA_RAM_LOC
BYTE:           .BYTE   0x1
WORD:           .word   1
STRING:         .asciz  "String"
EMPTY:          .skip
/*
Some Data
*/
.end 
# End of the Program