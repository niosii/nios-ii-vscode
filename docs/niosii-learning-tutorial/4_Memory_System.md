# Number of transistors
- a SRAM cell: 6
- a DRAM cell: 1
- a ROM cell: 1
# The Primary difference between Basic EEPROM and the Flash type
- In EEPROM you can read and write individual cells;
- Flash, while based on EEPROM, was made faster by reading and writing cells in larger blocks not individually
# The difference in handling of address pins for SRAM and DRAM
- SRAM has as many pins as there are address bits; while in DRAM address pins are multiplexed to reduce package cost
- SRAM's address bits are provided to the chip at the same time; while in DRAM, row bits are provided firest then column bits
# The purpose of including a clock input for synchronous DRAM chips
- SDRAM uses internal column counter which is automatically increased by clock cycle input, which is faster than using external memory controller
## Memory Controller
- This hardware feature enables several such modules to be plugged into connectors on common data wires
# Direct-mapped cache
## Derive the address bit breakdown for a direct-mapped cache with a capacity of 64 kbytes and a block size of four 32-bit words
- capacity in bytes: 64 * 2^10 = 2^16 bytes => 4 offset bits
- block size: 4 * 32 bit = 2^4 bytes => 12 index bits
- tag bits = 32 - 12 - 4 = 16
- the address 0x1F2A86C0
- (0001 1111 0010 1010) (1000 0110 1100) (0000)
- tag 0x1F2A, index 0x86C, offset 0
## If the cache organization in part (g) is used for a writeback data cache, give an unsimplified expression for the number of bits of storage in one block
- storage block = 15 tag bit + 1 valid bit + 1 modified bit
# Set-associative cache
## Derive the address bit breakdown for a two-way set-associative cache organzition with 256-kbyte capaciy and 64-byte block size
- Two-way = 2 blocks/set
- 64 byte block size = 2^6 bytes/block => 6 word bits
- 256 kbyte capacity size = 2^18 bytes
- 2^18 bytes/2^6 bytes per block = 2^12 blocks
- 2^12 blocks/2 blocks per set = 2^11 sets => 11 set bits
- tag bits = 32 total bits - 11 set bits - 6 word bits = 15 tag
# the different types of locality exploited by cashed
- Tempoeral Locality: instructions and data that have been recently accessed are likely to be accessed again
- Spatial Locality: nearby instructions and data are likely to be accessed after current access
# Cache/Virtual memory
- cache memory makes memory appear to be faster than it actually is
- virtual memory makes memory appear to be bigger than it actually is
# The purpos of the TLB
- Translation lookaside buffer makes translations faster by storing recently-accessed entries of the page table.
