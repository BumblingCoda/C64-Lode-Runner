// ------------------------------------------------------------------------------------------------------------- //
// Complex Interface Adapter (CIA) #1 Registers - $DC00-$DC0F
// ------------------------------------------------------------------------------------------------------------- //
.label CIA1              = $DC00     // Base address
// ------------------------------------------------------------------------------------------------------------- //
.label CIA_Joy_Up        = %00000001 // Joystick 1/2 - Fire   0=pressed
.label CIA_Joy_Do        = %00000010 // Joystick 1/2 - Right  0=pressed
.label CIA_Joy_Le        = %00000100 // Joystick 1/2 - Left   0=pressed
.label CIA_Joy_Ri        = %00001000 // Joystick 1/2 - Down   0=pressed
.label CIA_Joy_Fi        = %00010000 // Joystick 1/2 - Up     0=pressed
// ------------------------------------------------------------------------------------------------------------- //
.label CIAPRA            = $DC00     // Data Port Register A
.label CIA_Joy_Pa        = %11000000 // Paddle Set Selection Port A or B (only one bit may be active)
                                     // 
.label CIA_KeySelRow_00  = %00000001 // Keyboard Check Row Selection
.label CIA_KeySelRow_01  = %00000010 // 0=read   this column
.label CIA_KeySelRow_02  = %00000100 // 1=ignore this column
.label CIA_KeySelRow_03  = %00001000 // 
.label CIA_KeySelRow_04  = %00010000 // 
.label CIA_KeySelRow_05  = %00100000 // 
.label CIA_KeySelRow_06  = %01000000 // 
.label CIA_KeySelRow_07  = %10000000 // 
// ------------------------------------------------------------------------------------------------------------- //
.label CIAPRB            = $DC01     // Data Port Register B
.label CIA_KeyResCol_00  = %00000001 // Keyboard Check Column Result
.label CIA_KeyResCol_01  = %00000010 // 0=pressed
.label CIA_KeyResCol_02  = %00000100 // 1=not pressed
.label CIA_KeyResCol_03  = %00001000 // 
.label CIA_KeyResCol_04  = %00010000 // 
.label CIA_KeyResCol_05  = %00100000 // 
.label CIA_KeyResCol_06  = %01000000 // 
.label CIA_KeyResCol_07  = %10000000 // 
                              // 
.label CIA_OutTypeTiA    = %01000000 // Toggle or pulse data output for Timer A
.label CIA_OutTypeTiB    = %10000000 // Toggle or pulse data output for Timer B
// ------------------------------------------------------------------------------------------------------------- //
                              //  CIDDRA/CIDDRB must be set 1st
                              //  Write to  Data Port A - set col to check=0/col to ignore=1
                              //  Read from Data Port B - for checked col the row of key pressed=0 
// -------------------------------------+--------+--------+--------+--------+--------+--------+--------+--------+
                              //        !  bit7  !  bit6  !  bit5  !  bit4  !  bit3  !  bit2  !  bit1  !  bit0  !
                              //  ------+--------+--------+--------+--------+--------+--------+--------+--------+
                              //  bit7  !  Stop  !   Q    !   C=   !  Space !   2    !  Ctrl  !   <-   !   1    !
                              //  ------+--------+--------+--------+--------+--------+--------+--------+--------+
                              //  bit6  !   /    !   ^    !   =    ! Shft_R !  Home  !   //    !   *    !  LIRA  !
                              //  ------+--------+--------+--------+--------+--------+--------+--------+--------+
                              //  bit5  !   ,    !   @    !   :    !   .    !   -    !   L    !   P    !   +    !
                              //  ------+--------+--------+--------+--------+--------+--------+--------+--------+
                              //  bit4  !   N    !   O    !   K    !   M    !   0    !   J    !   I    !   9    !
                              //  ------+--------+--------+--------+--------+--------+--------+--------+--------+
                              //  bit3  !   V    !   U    !   H    !   B    !   8    !   G    !   Y    !   7    !
                              //  ------+--------+--------+--------+--------+--------+--------+--------+--------+
                              //  bit2  !   X    !   T    !   F    !   C    !   6    !   D    !   R    !   5    !
                              //  ------+--------+--------+--------+--------+--------+--------+--------+--------+
                              //  bit1  ! Shft_L !   E    !   S    !   Z    !   4    !   A    !   W    !   3    !
                              //  ------+--------+--------+--------+--------+--------+--------+--------+--------+
                              //  bit0  ! Crsr_D !   F5   !   F3   !   F1   !   F7   ! Crsr_R ! Return ! Delete !
// -------------------------------------+--------+--------+--------+--------+--------+--------+--------+--------+
.label CIDDRA            = $DC02     // Data Direction Register A
                              //   for keybord scan set all for output ($ff=default)
                              //     Bit 0: Select Bit 0 of Data Port A for input or output (0=input, 1=output)
                              //     Bit 1: Select Bit 1 of Data Port A for input or output (0=input, 1=output)
                              //     Bit 2: Select Bit 2 of Data Port A for input or output (0=input, 1=output)
                              //     Bit 3: Select Bit 3 of Data Port A for input or output (0=input, 1=output)
                              //     Bit 4: Select Bit 4 of Data Port A for input or output (0=input, 1=output)
                              //     Bit 5: Select Bit 5 of Data Port A for input or output (0=input, 1=output)
                              //     Bit 6: Select Bit 6 of Data Port A for input or output (0=input, 1=output)
                              //     Bit 7: Select Bit 7 of Data Port A for input or output (0=input, 1=output)
// ------------------------------------------------------------------------------------------------------------- //
.label CIDDRB            = $DC03     // Data Direction Register B
                              //   for keybord scan set all for input ($00=default)
                              //     Bit 0: Select Bit 0 of Data Port B for input or output (0=input, 1=output)
                              //     Bit 1: Select Bit 1 of Data Port B for input or output (0=input, 1=output)
                              //     Bit 2: Select Bit 2 of Data Port B for input or output (0=input, 1=output)
                              //     Bit 3: Select Bit 3 of Data Port B for input or output (0=input, 1=output)
                              //     Bit 4: Select Bit 4 of Data Port B for input or output (0=input, 1=output)
                              //     Bit 5: Select Bit 5 of Data Port B for input or output (0=input, 1=output)
                              //     Bit 6: Select Bit 6 of Data Port B for input or output (0=input, 1=output)
                              //     Bit 7: Select Bit 7 of Data Port B for input or output (0=input, 1=output)
// ------------------------------------------------------------------------------------------------------------- //
.label TIMALO            = $DC04     // Timer A (low byte)  : TIME = LATCH VALUE / CLOCK SPEED
                              //   Read : Current State of Timer A
                              //   Write: Value to be loaded at next start of Timer A
                              //
                              //   LATCH VALUE = TIMER LOW + 256 * TIMER HIGH
                              //   CLOCK SPEED = 1,022,370 cycles per second for NTSC monitors
                              //               =   985,250 cycles per second for PAL  monitors
// ------------------------------------------------------------------------------------------------------------- //
.label TIMAHI            = $DC05     // Timer A (high byte) : TIME = LATCH VALUE / CLOCK SPEED
// ------------------------------------------------------------------------------------------------------------- //
.label TIMBLO            = $DC06     // Timer B (low byte)  : TIME = LATCH VALUE / CLOCK SPEED
// ------------------------------------------------------------------------------------------------------------- //
.label TIMBHI            = $DC07     // Timer B (high byte) : TIME = LATCH VALUE / CLOCK SPEED
// ------------------------------------------------------------------------------------------------------------- //
.label TODTEN            = $DC08     // Time of Day Clock Tenths of Seconds
                              //   Bits 0-3: Time of Day tenths of second digit (BCD)
                              //   Bits 4-7: Unused
// ------------------------------------------------------------------------------------------------------------- //
.label TODSEC            = $DC09     // Time of Day Clock Seconds
                              //   Bits 0-3: Second digit of Time of Day seconds (BCD)
                              //   Bits 4-6: First digit of Time of Day seconds  (BCD)
                              //   Bit    7: Unused
// ------------------------------------------------------------------------------------------------------------- //
.label TODMIN            = $DC0A     // Time of Day Clock Minutes
                              //   Bits 0-3: Second digit of Time of Day minutes (BCD)
                              //   Bits 4-6: First digit of Time of Day minutes (BCD)
                              //   Bit    7: Unused
// ------------------------------------------------------------------------------------------------------------- //
.label TODHRS            = $DC0B     // Time of Day Clock Hours
                              //   Bits 0-3: Second digit of Time of Day hours (BCD)
                              //   Bit    4: First digit of Time of Day hours (BCD)
                              //   Bits 5-6: Unused
                              //   Bit    7: AM/PM Flag (1=PM, 0=AM)
// ------------------------------------------------------------------------------------------------------------- //
.label CIASDR            = $DC0C     // Serial Data Port
// ------------------------------------------------------------------------------------------------------------- //
.label CIAICR            = $DC0D     // Interrupt Control Register
                              //   Bit 0:  Read / did Timer A count down to 0?         (1=yes)
                              //           Write/ enable or disable Timer A interrupt  (1=enable, 0=disable)
                              //   Bit 1:  Read / did Timer B count down to 0?         (1=yes)
                              //           Write/ enable or disable Timer B interrupt  (1=enable, 0=disable)
                              //   Bit 2:  Read / did Time of Day Clock reach the alarm time?  (1=yes)
                              //           Write/ enable or disable TOD clock alarm interrupt  (1=enable,
                              //           0=disable)
                              //   Bit 3:  Read / did the serial shift register finish a byte?       (1=yes)
                              //           Write/ enable or disable serial shift register interrupt  (1=enable, 0=disable)
                              //   Bit 4:  Read / was a signal sent on the flag line?    (1=yes)
                              //           Write/ enable or disable FLAG line interrupt  (1=enable, 0=disable)
                              //   Bit 5:  Not used
                              //   Bit 6:  Not used
                              //   Bit 7:  Read / did any CIA #1 source cause an interrupt?  (1=yes)
                              //           Write/ set or clear bits of this register         
                              //             (1=bits written with 1 will be set, 0=bits written with 1 will be cleared)
// ------------------------------------------------------------------------------------------------------------- //
.label CIACRA            = $DC0E     // Control Register A
                              //   Bit 0:  Start Timer A (1=start, 0=stop)
                              //   Bit 1:  Select Timer A output on Port B 
                              //             (1=Timer A output appears on Bit 6 of Port B)
                              //   Bit 2:  Port B output mode  (1=toggle Bit 6, 0=pulse Bit 6 for one cycle)
                              //   Bit 3:  Timer A run mode    (1=one-shot, 0=continuous)
                              //   Bit 4:  Force latched value to be loaded to Timer A counter (1=force load strobe)
                              //   Bit 5:  Timer A input mode  
                              //             (1=count microprocessor cycles, 0=count signals on CNT line at pin 4 of User Port)
                              //   Bit 6:  Serial Port (56332, $DC0C) mode (1=output, 0=input)
                              //   Bit 7:  Time of Day Clock frequency (1=50 Hz required on TOD pin, 0=60 Hz)
// ------------------------------------------------------------------------------------------------------------- //
.label CIACRB            = $DC0F     // Control Register B
                              //   Bit    0: Start Timer B (1=start, 0=stop)
                              //   Bit    1: Select Timer B output on Port B (1=Timer B output appears on Bit 7 of Port B)
                              //   Bit    2: Port B output mode (1=toggle Bit 7, 0=pulse Bit 7 for one cycle)
                              //   Bit    3: Timer B run mode (1=one-shot, 0=continuous)
                              //   Bit    4: Force latched value to be loaded to Timer B counter (1=force load strobe)
                              //   Bits 5-6: Timer B input mode
                              //               00 = Timer B counts microprocessor cycles
                              //               01 = Count signals on CNT line at pin 4 of User Port
                              //               10 = Count each time that Timer A counts down to 0
                              //               11 = Count Timer A 0's when CNT pulses are also present
                              //   Bit    7: Select Time of Day write
                              //               (0=writing to TOD registers sets alarm, 1=writing to TOD registers sets clock)
// ------------------------------------------------------------------------------------------------------------- //
// $DC10-$DCFF   // CIA #1 Register Images - Mirror of $DC00-$DC0F
// ------------------------------------------------------------------------------------------------------------- //
// CIAPRA  = $DCF0 // Data Port Register A
// CIAPRB  = $DCF1 // Data Port Register B
// CIDDRA  = $DCF2 // Data Direction Register A
// CIDDRB  = $DCF3 // Data Direction Register B
// TIMALO  = $DCF4 // Timer A (low byte)  : TIME = LATCH VALUE / CLOCK SPEED
// TIMAHI  = $DCF5 // Timer A (high byte) : TIME = LATCH VALUE / CLOCK SPEED
// TIMBLO  = $DCF6 // Timer B (low byte)  : TIME = LATCH VALUE / CLOCK SPEED
// TIMBHI  = $DCF7 // Timer B (high byte) : TIME = LATCH VALUE / CLOCK SPEED
// TODTEN  = $DCF8 // Time of Day Clock Tenths of Seconds
// TODSEC  = $DCF9 // Time of Day Clock Seconds
// TODMIN  = $DCFA // Time of Day Clock Minutes
// TODHRS  = $DCFB // Time of Day Clock Hours
// CIASDR  = $DCFC // Serial Data Port
// CIAICR  = $DCFD // Interrupt Control Register
// CIACRA  = $DCFE // Control Register A
// CIACRB  = $DCFF // Control Register B
// ------------------------------------------------------------------------------------------------------------- //
