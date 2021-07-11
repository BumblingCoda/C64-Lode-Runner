// ------------------------------------------------------------------------------------------------------------- //
// CPU Port Data Direction Register
// ------------------------------------------------------------------------------------------------------------- //
.label D6510   = $00   // 6510 On-Chip I/O Data Direction
                //   0: Input  = Corresponding bit in R6510 can only be read
                //   1: Output = Corresponding bit in R6510 can also be written
                //
                // default: $2f = 0010 1111
// ------------------------------------------------------------------------------------------------------------- //
// CPU Port Data Register
// ------------------------------------------------------------------------------------------------------------- //                
.label R6510   = $01   // 6510 On-Chip I/O Data
                //
                // Bits 0�2: Select Memory Configuration
                //
.label LORAM     = $01 // Bit 0: = L  1=BASIC  0=RAM
.label HIRAM     = $02 // Bit 1: = H  1=Kernal 0=RAM & BASIC switched out too as it needs the KERNAL
.label CHAREN    = $04 // Bit 2: = C  1=I/O    0=ROM
                // Bit 3: Tape - Data Output Signal Level
                // Bit 4: Tape - Play Button Status 
                //        0=one of PLAY/RECORD/F.FWD/REW pressed
                //        1=no button Pressed
                // Bit 5: Tape - Motor Control
                //        0=motor on
                //        1=motor off
                // Bit 6: Not Implemented
                // Bit 7: Not Implemented
                //
                // default: $37 = 0011 0111
                // -------------------------------------
                //              $D000     $E000    $A000
                //       CHL    $DFFF     $FFFF    $BFFF
                // -------------------------------------
                // ..... 000 -> ram       ram      ram  
                // ..... 001 -> Charset   ram      ram  
                // ..... 010 -> Charset   Kernal   ram  
                // ..... 011 -> Charset   Kernal   BASIC
                // ..... 100 -> ram       ram      ram  
                // ..... 101 -> I/O       ram      ram  
                // ..... 110 -> I/O       Kernal   ram  
                // ..... 111 -> I/O       Kernal   BASIC <-- default
// ---------------------------------------------------------------------------------------------------------- //                
.label BIKon     = $37 // ..##. ### -> IO   ---  Kernal - Basic  - switch all on
.label B__off    = $36 // ..##. ##. -> IO   ---  Kernal - RAM   
.label B_Koff    = $35 // ..##. #.# -> IO   ---  RAM    - RAM   
.label BIKoff    = $34 // ..##. #.. -> RAM  ---  RAM    - RAM   
.label BcKoff    = $33 // ..##. .## -> CHAR ---  RAM    - RAM    - switch char on
// ------------------------------------------------------------------------------------------------------------- //                
.label STACK     = $0100 // 
// ------------------------------------------------------------------------------------------------------------- //                
.label CHARGEN   = $d000 // character generator ROM
.label CHR_UP    = $d000 // upper case
.label CHR_UPR   = $d400 // upper case / reversed
.label CHR_LO    = $d800 // lower case
.label CHR_LOR   = $dc00 // lower case / reversed
// ------------------------------------------------------------------------------------------------------------- //                
