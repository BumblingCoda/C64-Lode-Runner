
#importonce

// ------------------------------------------------------------------------------------------------------------- //
// Kernel jump table
// ------------------------------------------------------------------------------------------------------------- //
                // Errors: Carry Set / Code in AC
                // 1 = TOO MANY FILES
                // 2 = FILE OPEN
                // 3 = FILE NOT OPEN
                // 4 = FILE NOT FOUND
                // 5 = DEVICE NOT PRESENT
                // 6 = NOT INPUT FILE
                // 7 = NOT OUTPUT FILE
                // 8 = MISSING FILE NAME
                // 9 = ILLEGAL DEVICE NUMBER
// ------------------------------------------------------------------------------------------------------------- //
.label CINT    = $FF81 // initialize screen editor and video chip ................. $FF5B
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label IOINIT  = $FF84 // initialize I/O devices .................................. $FDA3
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label RAMTAS  = $FF87 // initialize RAM, tape buffer, screen ..................... $FD50
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label RESTOR  = $FF8A // restore default I/O vectors ............................. $FD15
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label VECTOR  = $FF8D // read/set I/O vector table ............................... $FD1A
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label SETMSG  = $FF90 // set Kernal message control flag ......................... $FE18
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label SECOND  = $FF93 // send secondary address after LISTEN ..................... $EDB9
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label TKSA    = $FF96 // send secondary address after TALK ....................... $EDC7
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label MEMTOP  = $FF99 // read/set top of memory pointer .......................... $FE25
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label MEMBOT  = $FF9C // read/set bottom of memory pointer ....................... $FE34
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label SCNKEY  = $FF9F // scan the keyboard ....................................... $EA87
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label SETTMO  = $FFA2 // set time-out flag for IEEE bus .......................... $FE21
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label ACPTR   = $FFA5 // input byte from serial bus .............................. $FE13
                //   Regs used: A
                //   Regs modi: A, X
                //   Prep     : TALK, TKSA
                //   Errors   : 
.label CIOUT   = $FFA8 // output byte to serial bus ............................... $EDDD
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label UNTLK   = $FFAB // command serial bus device to UNTALK ..................... $EDEF
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label UNLSN   = $FFAE // command serial bus device to UNLISTEN ................... $EDFE
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label LISTEN  = $FFB1 // command serial bus device to LISTEN ..................... $ED0C
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label TALK    = $FFB4 // command serial bus device to TALK ....................... $ED09
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label READST  = $FFB7 // read I/O status word .................................... $FE07
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
                //
                //   Bit 7 = Device not present/End of Tape
                //   Bit 6 = End of File
                //   Bit 5 = Checksum Error
                //   Bit 4 = Error
                //   Bit 3 = Too many Bytes
                //   Bit 2 = Too few Bytes
                //   Bit 1 = Timeout Read
                //   Bit 0 = Timeout Write
                //
.label SETLFS  = $FFBA // set logical file parameters ............................. $FE00
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label SETNAM  = $FFBD // set filename parameters ................................. $FDF9
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label OPEN    = $FFC0 // open a logical file ..................................... via $31A to $F34A
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label CLOSE   = $FFC3 // close a logical file .................................... via $31C to $F291
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label CHKIN   = $FFC6 // define an input channel ................................. via $31E to $F20E
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label CHKOUT  = $FFC9 // define an output channel ................................ via $320 to $F250
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label CLRCHN  = $FFCC // restore default devices ................................. via $322 to $F333
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label CHRIN   = $FFCF // input a character ....................................... via $324 to $F157
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label CHROUT  = $FFD2 // output a character ...................................... via $326 to $F1CA
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label LOAD    = $FFD5 // load from device ........................................ via $330 to $F49E
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label SAVE    = $FFD8 // save to a device ........................................ via $332 to $F5DD
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label SETTIM  = $FFDB // set the software clock .................................. $F6E4
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label RDTIM   = $FFDE // read the software clock ................................. $F6DD
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label STOP    = $FFE1 // check the STOP key ...................................... via $328 to $F6ED
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label GETIN   = $FFE4 // get a character ......................................... via $32A to $F13E
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label CLALL   = $FFE7 // close all files ......................................... via $32C to $F32F
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label UDTIM   = $FFEA // update the software clock ............................... $F69B
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label SCREEN  = $FFED // read number of screen rows and columns .................. $E505
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label PLOT    = $FFF0 // read/set position of cursor on screen ................... $E50A
                //   Regs used: 
                //   Regs modi: 
                //   Prep     : 
                //   Errors   : 
.label IOBASE  = $FFF3 // read base address of I/O devices ........................ $E500

.label VNMI    = $FFFA // Non-Maskable Interrupt Hardware Vector .................. $FE43
.label VRES    = $FFFC // System Reset (RES) Hardware Vector ...................... $FCE2
.label VBRK    = $FFFE // Maskable Interrupt Request and Break Hardware Vectors ... $FF48
