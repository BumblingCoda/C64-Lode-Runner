// ------------------------------------------------------------------------------------------------------------- //
// Lode Runner - IT.PRG - Modified with some stolen ideas
// ------------------------------------------------------------------------------------------------------------- //
// Memory Map
// ------------------------------------------------------------------------------------------------------------- //
// $0000 - $00ff:  Zero Page Values
// $0200 - $02ff:  <not used>
// $0300 - $03ff:  <not used>
// $0400 - $04f7:  Multi Color Screen
// $04f8 - $04ff:  Sprite Pointers
// $0800 - $09c3:  Table Expanded Level Data - modified with    lr/en replacements/holes
// $0a00 - $0bc3:  Table Expanded Level Data - original without lr/en replacements/holes
// $0c00 - $0cff:  Sprite Store 01
// $0d00 - $0dff:  Sprite Store 02
// $0e00 - $0ec7:  Table Offsets HiRes Lo
// $0f00 - $0fc7:  Table Offsets HiRes Hi
// $1000 - $10ff:  Buffer Level Data Save/Load
// $1100 - $11ff:  Buffer High Score Save/Load
// $1200 - $12ff:  Table Dynamic Game Values
// $1300 - $133b:  Game Variables
// $1400 - $1fff:  Data Start Graphic
// $2000 - $3fff:  HighRes Display Screen
// $4000 - $5fff:  HighRes Prepare Screen
// $6000 - $....:  Program Code
// $c000 - $c0ff:  Tunes Play Time
// $c100 - $c1ff:  Tunes Data Ptr Voice 2
// $c200 - $c2ff:  Tunes Data Ptr Voice 3
// $c300 - $c3ff:  Tunes Sustain/Release/Volume (not used)
// $c400 - $c4ff:  Buffer Save Games List
// $c500 - $c5ff:  Table Non-Selected Level Numbers for Random Level Game
// $c600 - $c6ff:  Table Enlarged Hidden Ladders Position
// $c700 - $c7ff:  <not used>
// $c800 - $c8ff:  Buffer Temporary Values
// $c900 - $c9ff:  Table Image Addresses Low  Byte
// $ca00 - $caff:  Table Image Addresses High Byte
// $cb00 - $cfff:  <not used>
// ------------------------------------------------------------------------------------------------------------- //
                    * equ  $6000                       // Start address
// ------------------------------------------------------------------------------------------------------------- //
// compiler settings                                                                                             //
// ------------------------------------------------------------------------------------------------------------- //
                    incdir   ..\..\inc              // C64 System imports
                    
C64CIA1             .import  "cia1.asm"               // Complex Interface Adapter (CIA) #1 Registers  $DC00-$DC0F
C64CIA2             .import  "cia2.asm"               // Complex Interface Adapter (CIA) #2 Registers  $DD00-$DD0F
C64SID              .import  "sid.asm"                // Sound Interface Device (SID) Registers        $D400-$D41C
C64VicII            .import  "vic.asm"                // Video Interface Chip (VIC-II) Registers       $D000-$D02E
C64Kernel           .import  "kernel.asm"             // Kernel Vectors
C64Colors           .import  "color.asm"              // Colour RAM Address / Colours
C64Colors           .import  "mem.asm"                // Memory Layout
//                   
InGameVars          .import  "inc\LR_Vars.asm"        // Game Variables
InZeroPageVars      .import  "inc\LR_Zpg.asm"         // Zero Page Variables
//Data                       "inc\LR_Data.asm"        // included at the very end
// ------------------------------------------------------------------------------------------------------------- //
Start:
        lda #$00                        // 
        tax                             // 
!ClrStack:          sta STACK,x                     // 
        inx                             // 
        bne !ClrStack-                   // 
        dex                             // $ff
        txs                             // init stack pointer
        
        jsr GameInitOnce                //
        
        lda #LR_GameGame                // .hbu000. - force block load
        sta LR_GameCtrl                 // .hbu000.
        
        lda #LR_DiskRead                //
        jsr GetPutHiScores              // Target: $1100-$11ff with ac: $01=load $02=store 81= 82=
        
!ChkBadDisk:
        cmp #LR_DiskNoData              // was no load runner data disk
        bne ColdStart

SetGood:
        lda #LR_DiskWrite               // write back formatted high scores
        jsr GetPutHiScores              // Target: $1100-$11ff
// ------------------------------------------------------------------------------------------------------------- //
ColdStart:{
        lda #LR_VolumeMax
        sta LR_Volume
        sta LR_FallsDown                // $00=fall $20=no fall $ff=init
        sta LR_DeathTune
        sta LR_ShootMode
        
        lda #$00
        sta LR_PtrNxtTunePos            // pointer: next free tune buffer byte
        sta LR_PtrTuneToPlay
        sta LR_Shoots                   // $00=no $01=right $ff=left
        sta LR_DeathTune
        sta LR_KeyNew
        sta LR_KeyOld
        sta LR_JoyNew
        sta LR_JoyOld
        sta LR_SprtPosCtrl              // $00 - set sprites
        sta LR_LevelNoXmit              // .hbu017.
        sta LR_ExpertMode               // .hbu017.
        sta EXTCOL                      // .hbu017. - VIC 2 - $D020 = Border Color
        lda #>LR_LvlDataSavLod          // $10 - Target: $1000-$10ff
        sta Mod_GetDiskByte             // adapt ReadDiskData  command
        sta Mod_PutDiskByte             // adapt WriteDiskData command                  
        sta LR_Random                   // last valid RND beam pos
        lda LRZ_MatrixLastKey           // c64 - key value
        sta LR_KeyOld
        lda #$40                        // reset: $40=no key pressed
        sta LRZ_MatrixLastKey           // c64 - key value
        lda #LR_SpeedNormal             // wait 5 interupts before next move  (normal speed)
        sta LR_GameSpeed
        lda #LR_Joystick
        sta LR_ControllerTyp            // controler type  $ca=joystick  $cb=keyboard
        lda #LR_GameStart               // 
        sta LR_GameCtrl                 // $00=start $01=demo $02=game $03=play_level $05=Edit
        
ColdStartX:
        jmp StartGraphicOut
}
// ------------------------------------------------------------------------------------------------------------- //
GameStartInit:
        lda #LR_LevelDiskMin
        sta LR_LevelNoDisk              // 000-149
        
        lda #LR_LevelNoMin
        sta LR_LevelNoGame              // 001-150
        
        lda #LR_CheatedNo
        sta LR_Cheated                  // $01=no
        
        lda #LR_GameGame
        sta LR_GameCtrl                 // $00=start $01=demo $02=game $03=play_level $05=edit
        
        lda #LR_KeyNewNone              // .hbu000.
        sta LR_KeyNew                   // .hbu000. - avoid an immediate start
GameStartInitX
        sta LR_ScoreShown
// ------------------------------------------------------------------------------------------------------------- //
GameStart:
        lda #$00
        sta LRZ_DemoMoveTime            // reset duration demo move for possible next demo rounds
        sta LR_ScoreLo
        sta LR_ScoreMidLo
        sta LR_ScoreMidHi
        sta LR_ScoreHi
        sta LR_CntSpeedLaps
        sta LR_EnmyBirthCol             // actual enemy rebirth column (increases with every main loop)
        sta LR_RNDMode                  // .hbu014. - random level mode
        sta LR_RNDLevel                 // .hbu014. - the real level counter
        sta LR_TestLevel                // .hbu023. - switch off level test mode
        
        lda #LR_NumLivesInit            // $05
        sta LR_LvlReload                // <> LR_LevelNoDisk - force level load
        sta LR_NumLives
        
        lda #>LR_ScrnHiReDisp           // $20
        sta LRZ_GfxScreenOut            // target output  $20=$2000 $40=$4000
        
        jsr MelodyInit

!ClearAllScreens:
        jsr ClearHiresDisp
        jsr ClearHiresPrep
                    
GameStartX:
        jsr BaseLinesColor              // .hbu001. - output the baseline first before level load
// ------------------------------------------------------------------------------------------------------------- //
LevelStart:
        ldx #LR_LevelLoad               // force level rebuild
        jsr InitLevel
        
        ldy LR_EnmyNo                   // number of enemies - lr always set
        lda TabAllEnemyEnab,y           // 
        sta SPENA                       // VIC 2 - $D015 = Sprite Enable
        
        lda #$00
        sta LR_JoyUpDo
        sta LR_JoyLeRi
        
        sta LR_PtrTuneToPlay
        sta LR_PtrNxtTunePos            // pointer: next free tune buffer byte
        
!SaveScores:
        lda LR_ScoreLo                  // .hbu019. - loose collected level scores
        sta LR_ScoreOldLo               // .hbu019.
        lda LR_ScoreMidLo               // .hbu019.
        sta LR_ScoreOldMidLo            // .hbu019.
        lda LR_ScoreMidHi               // .hbu019.
        sta LR_ScoreOldMidHi            // .hbu019.
        lda LR_ScoreHi                  // .hbu019.
        sta LR_ScoreOldHi               // .hbu019.
        
        lda LR_GameCtrl                 // $00=start $01=demo $02=game $03=play_level $05=edit
        lsr a                           // 
        beq MainLoopInit                // demo must not wait
        
    !LevelStartWait:
        ldy #$07                        // .hbu013. - wait color tab pointer - 7 for a complete cycle
    !WaitLrGetColor:
        lda TabWaitColor,y              // .hbu013. - 
        sta SP0COL                      // .hbu013. - VIC 2 - $D027 = Color Sprite 0
        sty LR_Work                     // .hbu013. - save color
        
        ldx #$00                        // .hbu013. - waittime
        ldy #$06                        // .hbu013. - waittime
    !WaitLr:
        jsr ChkUserAction               // .hbu013.
        bcs .SetLrWhite                 // .hbu013. - user pressed key/fire
        dex                             // .hbu013. - wait
        bne !WaitLr-                     // .hbu013.
        dey                             // .hbu013. - wait
        bne !WaitLr-                     // .hbu013.
        
        ldy LR_Work                     // .hbu013. - dim player sprite
        dey                             // .hbu013. - from black to white
        bpl !WaitLrGetColor-             // .hbu013. - and vice versa
        bmi !LevelStartWait-             // .hbu013. - restart color counter
        
    !SetLrWhite:
        lda #WHITE                      // .hbu013.
        sta SP0COL                      // .hbu013. - VIC 2 - $D027 = Color Sprite 0
        
        lda LR_KeyNew                   // get pressed key
        cmp #$a4                        // special key: "M" - mirror level
        bne MainLoopInit
        
        jsr ToggleMirror                // toggle mirror flag - do NOT discount before start of play
        jmp LevelStart                  //
// ------------------------------------------------------------------------------------------------------------- //
TabAllEnemyEnab     dc.b $01 // .......#             // enable the selected amount of enemies
                    dc.b $05 // .....#.#
                    dc.b $0d // ....##.#
                    dc.b $1d // ...###.#
                    dc.b $5d // .#.###.#
                    dc.b $dd // ##.###.#
// ------------------------------------------------------------------------------------------------------------- //
TabWaitColor        dc.b WHITE
                    dc.b LT_GREY
                    dc.b GREY
                    dc.b DK_GREY
                    dc.b BLACK
                    dc.b DK_GREY
                    dc.b GREY
                    dc.b LT_GREY
// ------------------------------------------------------------------------------------------------------------- //
MainLoopInit:
        ldx #LR_ShootsNo
        stx LR_Shoots                   // $00=no $01=right $ff=left
        
        lda LR_CntSpeedLaps             // lap counter for speed up
        clc
        adc LR_EnmyNo                   // number of enemies
        tay
        
        ldx TabOffEnmyCycles,y          // offsets enemy move cycles tab
        lda TabEnmyCycles1,x            // enemy move cycles tab
        sta LRZ_EnmyMovCyc1
        lda TabEnmyCycles2,x            // enemy move cycles tab + 1
        sta LRZ_EnmyMovCyc2
        lda TabEnmyCycles3,x            // enemy move cycles tab + 2
        sta LRZ_EnmyMovCyc3
        
        ldy LR_CntSpeedLaps             // lap counter for speed up
        lda TabEnmyHoleTime,y           // time in hole tab
        sta LR_EnmyHoleTime             // enemy time in hole - values dynamically taken from TabEnmyHoleTime
        
        jsr GetTimerStart               // get time start values
// ------------------------------------------------------------------------------------------------------------- //
// Game Main Loop    
// ------------------------------------------------------------------------------------------------------------- //
MainLoop:
        jsr MoveLodeRunner              // move the lode runner

    !ChkLRAccident:
        lda LR_Alive
        beq LrDeath                     // -> LR had an accident

    !ChkAllGold:
        lda LR_Gold2Get
        bne !ChkLrOnTop+                 // some gold left

    !Victory:
        jsr VictoryTuneCopy             // prepare melody
        jsr VictoryMsg                  // .hbu007.
        jsr ShowExitLadders             // display hidden ladders

    !ChkLrOnTop:
        lda LRZ_LodeRunRow              // actual row lode runner
        bne !GoCloseHoles+               // not on top of the screen

    !ChkLrOnMidImg:
        lda LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        cmp #$02                        // $02=center of screen image
        bne !GoCloseHoles+
        
    !ChkGold4Finish:
        lda LR_Gold2Get                 // .hbu000. - fully on top of the screen
        beq LevelComplete               // and got all the money in the level
        bmi LevelComplete               // set negative in ShowExitLadders to avoid .Victory more than once

    !GoCloseHoles:
        jsr CloseHoles
    !ChkLRTrapped:
        lda LR_Alive
        beq LrDeath                     // -> LR trapped in hole

    !GoMoveEnemies:
        jsr MoveEnemies                 // move the enemies

    !ChkLRCaught:
        lda LR_Alive
        beq LrDeath                     // -> LR caught by enemies

    !ChkDemoDelay:
        lda LR_GameCtrl                 // .hbu003.
        lsr a                           // .hbu003.
        beq MainLoop                    // .hbu003. - demo max speed - next round

    !ChkDelay:
        lda LR_CountIRQs                // slow down game speed
        cmp LR_GameSpeed
        bcc !ChkDelay-

    !SetDelay
        lda #LR_IRQsDflt                // reinit wait cycle time
        sta LR_CountIRQs

!MainLoopX:
        jmp MainLoop                    // next round
// ------------------------------------------------------------------------------------------------------------- //
//
// ------------------------------------------------------------------------------------------------------------- //
LrDeath:
        ldx LR_TestLevel                // .hbu023.
        bmi !ChkDemo+                    // .hbu023. - do not discount lives in level test mode

    !DecLives:
        dec LR_NumLives                 // 

    !ChkDemo:
        lda LR_GameCtrl                 // $00=start $01=demo $02=game $03=play_level $05=edit
        lsr a                           // 
        beq !LrDeathX+                    // demo

!LrDeathGame:
        jmp LrDeathTune                 // game

!LrDeathX:
        jmp DemoDeath                   // .hbu002.
// ------------------------------------------------------------------------------------------------------------- //
//
// ------------------------------------------------------------------------------------------------------------- //
LevelComplete:
        ldx LR_TestLevel                // .hbu023.
        bpl !Complete+                   // .hbu023. - $00 - not in test mode

    !Return2Edit:
    jmp IGC_QuitLvlPlay                  // .hbu023. - no level completion handling necessary in test mode

    !Complete:
        jsr LevelTimeMsg                // .hbu007.

        lda LR_RNDMode                  // .hbu014. - U=play next level
        bpl !NextLevel+                  // .hbu014.

    !RandomLevel:
        jsr RND                         // .hbu014. - get a random number

        sta LR_LevelNoDisk              // .hbu014.
        sta LR_LevelNoGame              // .hbu014.
        inc LR_LevelNoGame              // .hbu014.
        inc LR_RNDLevel                 // .hbu014. - the real level counter
        jmp .FinishTunes                // .hbu014.
        
    !NextLevel:
        inc LR_LevelNoGame              // 001-150
        inc LR_LevelNoDisk              // 000-149

    !FinishTunes:
        lda LR_PtrNxtTunePos            // pointer: next free tune buffer byte
        cmp LR_PtrTuneToPlay
        bne !FinishTunes-
        
        jsr SetNextMelody
        
        inc LR_NumLives                 // get one extra chance for each completed level
        bne !ScoreTuneI+
        dec LR_NumLives                 // max $ff
        
    !ScoreTuneI:
        lda #LR_SoreValSub              // init score tune subtraction value
        sta $2f

        sei                             // not to be interrupted

    !ScoreTuneNext:
        lda #LR_SoreValStart
        sec
        sbc $2f
        sta FREHI1                      // SID - $D401 = Oscillator 1 Frequency Control (High Byte)
        
        ldy #$2c                        // wait time
    !ScoreTuneSet:
        ldx #$00                        // wait time
    !ScoreTuneWait:
        dex
        bne !ScoreTuneWait-
        dey
        bne !ScoreTuneSet-
        sty FREHI1                      // SID - $D401 = Oscillator 1 Frequency Control (High Byte)
        lda #<LR_ScoreFinLevel                        // ac=score  10s
        ldy #>LR_ScoreFinLevel / (LR_SoreValSub + 1)  // yr=score 100s
        jsr Score2BaseLine              // score increases whilst the
        dec $2f                         // tune gets higher and higher
        bpl .ScoreTuneNext
        cli                             // reallow interrupts

    !ChkDemo:
        lda LR_GameCtrl                 // $00=start $01=demo $02=game $03=play_level $05=edit
        lsr                             // 
        bne !ChkGameComplete+           // .hbu020. - game

    !WasDemo:
        lda #$01                        // .hbu002.
        jsr WaitAWhile                  // .hbu002. - wait a bit before highscore output
        bcs !GoLvlInit+                  // .hbu002.
        
    !DemoHighScore:
        jsr ShowHighScoreClr            // .hbu002.

        lda #$03                        // .hbu002. - high score list display time
        jsr WaitAWhile                  // .hbu002.
        bcc !GoLvlStartDemo+             // .hbu002. - no user interrupt

    !GoLvlInit:
        jmp GameStartInit               // .hbu002.

    !GoLvlStartDemo:
        jsr ClearHiresDisp              // .hbu000. - avoid flash on switch back to demo level
        jsr BaseLinesColor              // .hbu000.
    !GoLvlStart:
        jmp LevelStart

    !ChkGameComplete:
        lda LR_LevelNoGame              // .hbu020. - 001-150
        cmp #LR_LevelNoMax + 1          // .hbu020. - 151
        bne .GoLvlStart                 // .hbu020. - not reached so start next level
        
    !AddFinScore
        lda #<LR_ScoreFinGame           // .hbu020. - ac=score  10s
        ldy #>LR_ScoreFinGame           // .hbu020. - yr=score 100s
        jsr Score2BaseLine              // .hbu020.
        
        lda #$01                        // .hbu020.
        jsr WaitAWhile                  // .hbu020.
LevelCompleteX:
        jmp GameOver                    // .hbu020. - finish after last level
// ------------------------------------------------------------------------------------------------------------- //
//
//---------------------------------------------------------------------------------------------------------------//
LrDeathTune:{
        lda #LR_DeathTuneVal
        sta LR_DeathTune
        
    !WaitGameTuneX:
        lda LR_PtrNxtTunePos            // pointer: next free tune buffer byte
        cmp LR_PtrTuneToPlay
        bne !WaitGameTuneX-              // wait for all in game tunes to be finished

        lda #LR_ShootsNo
        sta LR_Shoots                   // $00=no $01=right $ff=left

        lda #LR_FallsNo
        sta LR_FallsDown                // $00=fall $20=no fall $ff=init

        jsr RestoreFromMsg              // .hbu007. - reset status line / display new no of lives
        
    !WaitDeathTuneX:
        lda LR_DeathTune
        bne !WaitDeathTuneX-

    !RestoreScores:
        lda LR_ScoreOldLo               // .hbu019. - loose collected level scores
        sta LR_ScoreLo                  // .hbu019.
        lda LR_ScoreOldMidLo            // .hbu019.
        sta LR_ScoreMidLo               // .hbu019.
        lda LR_ScoreOldMidHi            // .hbu019.
        sta LR_ScoreMidHi               // .hbu019.
        lda LR_ScoreOldHi               // .hbu019.
        sta LR_ScoreHi                  // .hbu019.
        
        lda #$00                        // .hbu019. - ac=score  10s
        tay                             // .hbu019. - yr=score 100s
        jsr Score2BaseLine              // .hbu019.
        
    !ChkGameOver:
        lda LR_NumLives
        beq GameOver                    // .hbu000.

LrDeathTuneX:
        jmp LevelStart                  // .hbu000.
}
// ------------------------------------------------------------------------------------------------------------- //
//
//---------------------------------------------------------------------------------------------------------------//
GameOver:{
        jsr ChkNewHighScore             // test new high score
        bcc .Flip                       // .hbu020. - none

    !ChkChamp:
        jsr ChkNewChampion              // .hbu020. - test new scorer
        bne !WaitI+                      // .hbu020. - disk write for new message - do not wait that long
        
        lda #$03                        // .hbu020. - wait a bit longer to compensate disk write
        bne !Wait+                       // .hbu020.
        
    !Flip:
        jsr FlipGmeOverSign             // .hbu000.

    !WaitI:
        lda #$01                        // .hbu000. - to be able to read the sign
    !Wait:
        jsr WaitAWhile                  // .hbu000. - before the start gfx starts
        bcs Wait4User                   // .hbu000. - carry set - user interrupt - no start gfx

        jmp StartGraphicOut             // .hbu000. - wait time up - show start gfx

GameOverX:
        jmp GameStartInit
}
// ------------------------------------------------------------------------------------------------------------- //
// Wait4User         Function: Wait for key/fire and check for edit/score special keys
//                           : Start demo mode if wait time expires before user interaction
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
Wait4UserClr:
        lda #LR_KeyNewNone
        sta LR_KeyNew

Wait4User:
        lda #$03
        jsr WaitAWhile
        bcc !GoDemo+                     // wait time expired
        beq !GoGameStartInit+            // fire pressed
        
    !WasUserKey:
        jsr ResetIRQ                    // switch back to game IRQ

    !GetUserKey:
        lda LR_KeyNew
    !ChkUserKeyEdit:
        cmp #$8e                        // special key: "E" - edit
        bne !ChkUserKeyEnter+

    !GoEdit:
        jmp BoardEditor

    !ChkUserKeyEnter:
        cmp #$01                        // special key: <enter>
        bne !GoGameStartInit+
        
        lda LR_ScoreShown               // .hbu000. - avoid highscores redisplay
        bne !GoGameStartInit+
        
        dec LR_ScoreShown               // .hbu000. - avoid highscores redisplay
        
    !GoHighScore:
        jmp HighScores

    !GoGameStartInit:
        jsr ResetIRQ                    // switch back to game IRQ
        jmp GameStartInit

    !GoDemo:
        jsr ResetIRQ                    // switch back to game IRQ
        
        ldx #LR_CheatedNo               // 
        stx LR_Cheated                  // 
        
        ldx #LR_GameDemo                // 
        stx LR_GameCtrl                 // $00=start $01=demo $02=game $03=play_level $05=edit
        
        ldx #LR_LevelNoMin              //
        stx LR_LevelNoGame              // 001-150
        
        dex                             // $00
        stx LR_LevelNoDisk              // 000-149
        
Wait4UserX:
        jmp GameStart
// ------------------------------------------------------------------------------------------------------------- //
// WaitAWhile        Function: Wait some time
//                   Parms   : ac contains the positive number of wait cycles - Starts with 00
//                   Returns : Carry set=user interrupt / Zero set=fire pressed - otherwise: ac=user-key-value
// ------------------------------------------------------------------------------------------------------------- //
WaitAWhile:{
        sta $50
    !WaitI:
        ldy #$00
        ldx #$00

    !ChkFire:
        lda CIAPRA                      // CIA 1 - $DC00 = Data Port A
        and #$10                        // ...#oooo - bit4=fire  bit3=right  bit2=left  bit1=down  bit0=up
        beq !WaitUser+                   // fire button pressed - zero flag set

    !ChkKey:
        lda LR_KeyNew
        bne !WaitUser+                   // key pressed         - zero flag not set

    !Wait1:
        dey
        bne !ChkFire-
    !Wait2:
        dex
        bne !ChkFire--
    !Wait3:
        dec $50
        bne !ChkFire---
        
    !WaitNoUser:
        clc                             // wait time expired -  z always set
        rts

    !WaitUser:
        sec                             // user interrupt    -  z_set=fire pressed  z_not_set=key pressed

WaitAWhileX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// DemoDeath         Function: Full Sound/End all tunes/Play death tune in demo levels
//                             Some code removed at the end of Wait4User
//                   Parms   :
//                   Returns :
//                   Label   : .hbu002.
// ------------------------------------------------------------------------------------------------------------- //
DemoDeath           subroutine
                    lda LR_PtrNxtTunePos            // .hbu002.
                    cmp LR_PtrTuneToPlay            // .hbu002.
                    bne DemoDeath                   // .hbu002. - end all in game tunes
                    
.InitDeath          lda #LR_DeathTuneVal
                    sta LR_DeathTune
.WaitDeath          lda LR_DeathTune
                    bne .WaitDeath                  // wait for end of death tune
                    
                    lda LR_NumLives                 // .hbu002.
                    bne .WaitLevel                  // .hbu002. - demo user interrupt in ContinueDemo
                    
                    jmp GameStartInit               // .hbu002. - demo lives are zero then
                    
.WaitLevel          lda #$02                        // .hbu002. - level display time
                    jsr WaitAWhile                  // .hbu002.
DemoDeathX          jmp StartGraphicOut             // .hbu002. - demo normal end
// ------------------------------------------------------------------------------------------------------------- //
HighScores          subroutine
                    jsr ClearHiresDisp              // .hbu000. - clear first to avoid flicker on switch back to MC
                    
.GoHighScores       jsr ShowHighScore
                    
                    lda #LR_GameGame
                    sta LR_GameCtrl                 // $00=start $01=demo $02=game $03=play_level $05=edit
                    
                    lda #$01
                    sta LR_ScoreShown               // set flag: scores already displayed
                    
HighScoresX         jmp Wait4UserClr                // avoid loop
// ------------------------------------------------------------------------------------------------------------- //
TabOffEnmyCycles    dc.b $00
                    dc.b $03
                    dc.b $06
                    dc.b $09
                    dc.b $0c
                    dc.b $0f
                    dc.b $12
                    dc.b $15
                    dc.b $18
                    dc.b $1b
                    dc.b $1e
// ------------------------------------------------------------------------------------------------------------- //
TabEnmyHoleTime     dc.b $26
                    dc.b $26
                    dc.b $2e
                    dc.b $44
                    dc.b $47
                    dc.b $49
                    dc.b $4a
                    dc.b $4b
                    dc.b $4c
                    dc.b $4d
                    dc.b $4e
                    dc.b $4f
                    dc.b $50
                    dc.b $51
                    dc.b $52
                    dc.b $53
                    dc.b $54
                    dc.b $55
                    dc.b $56
                    dc.b $57
                    dc.b $58
// ------------------------------------------------------------------------------------------------------------- //
// GetTimerStart     Function: 
//                   Parms   :
//                   Returns :
//                   ID      : .hbu013.
// ------------------------------------------------------------------------------------------------------------- //
GetTimerStart    	  subroutine
                    sei
                    
                	  lda #$00		                    // init
                	  sta TO2HRS
                	  sta TO2MIN
                	  sta TO2SEC
                	  sta TO2TEN
                	  
	                  cli
GetTimerStartX      rts
// ------------------------------------------------------------------------------------------------------------- //
// GetTimerEnd       Function: 
//                   Parms   :
//                   Returns :
//                   ID      : .hbu013.
// ------------------------------------------------------------------------------------------------------------- //
GetTimerStop     	  subroutine
                    sei
                    
.GetElapsedHours    lda TO2HRS
                    jsr SplitScoreDigit
                    
                    lda LR_Digit1
                    clc
                    adc #NoDigitsMin
                    sta TabMsgStdHrs1
                    
.GetElapsedMins     lda TO2MIN
                    jsr SplitScoreDigit
                    
                    lda LR_Digit10
                    clc
                    adc #NoDigitsMin
                    sta TabMsgStdMin10
                    lda LR_Digit1
                    clc
                    adc #NoDigitsMin
                    sta TabMsgStdMin1
                    
.GetElapsedSecs     lda TO2SEC
                    jsr SplitScoreDigit
                    
                    lda LR_Digit10
                    clc
                    adc #NoDigitsMin
                    sta TabMsgStdSec10
                    lda LR_Digit1
                    clc
                    adc #NoDigitsMin
                    sta TabMsgStdSec1
                    
.GetElapsed10th     lda TO2TEN
                    jsr SplitScoreDigit
                    
                    lda LR_Digit10
                    clc
                    adc #NoDigitsMin
                    sta TabMsgStdTen10
                    lda LR_Digit1
                    clc
                    adc #NoDigitsMin
                    sta TabMsgStdTen1
                    
	                  cli
	                  
GetTimerStopX       rts
// ------------------------------------------------------------------------------------------------------------- //
// VictoryMsg        Function: Print a yellow or white victory message
//                   Parms   :
//                   Returns :
//                   ID      : .hbu007.
// ------------------------------------------------------------------------------------------------------------- //
VictoryMsg          subroutine
                    jsr ColorLevelDyn               // set level/msg colors
                    
                    ldy #LR_LevelMsgIDLen           // message id length
.ChkMsgId           lda LR_LevelMsgID,y             // compare with message identifier
                    cmp TabMsgID,y
                    bne .ChkEdit                    // no valid message identifier found
                    
                    dey
                    bpl .ChkMsgId
                    bmi .CpyGameMsgI                // valid message id found
                    
.ChkEdit            lda LR_GameCtrl                 // clear msg area in edit mode only
                    cmp #LR_GameEdit                // 
                    bne .Exit                       // 
                    
.ClrGameMsgI        ldy #LR_LevelMsgLen             // message length
.ClrGameMsg         lda #$a0                        // <blank>
                    sta ..VictorBuffer,y            // clear message buffer
                    sta CR_InputBuf,y               // clear input   buffer
                    dey
                    bpl .ClrGameMsg                 // 
                    bmi .ClearBaseMsg               // 
                    
.Exit               rts                             // in game mode keep msg area unchanged if no msg exists
                    
.CpyGameMsgI        lda #$00                        // 
                    sta LRZ_Work                    // init blank msg indicator
                    ldy #LR_LevelMsgLen             // message length
.CpyGameMsg         lda LR_LevelMsg,y               // the message
                    sta ..VictorBuffer,y            // copy msg characters
                    sta CR_InputBuf,y               // prepare the input buffer for a possible edit
                    eor #$a0                        // <blank>
                    ora LRZ_Work                    // 
                    sta LRZ_Work                    // save text bit pattern
                    dey                             // 
                    bpl .CpyGameMsg                 // 
                    
.ChkBlankMsg        lda LRZ_Work                    // 
                    bne .ClearBaseMsg               // 
                                      
.ChkBlankEdit       lda LR_GameCtrl                 // display a blank message only in edit mode
                    cmp #LR_GameEdit                // 
                    bne .Exit                       // 
                    
.ClearBaseMsg       jsr ClearMsg                    // message area to black
                    
.SetOutput          lda #>LR_ScrnHiReDisp           // $20
                    sta LRZ_GfxScreenOut            // output to display screen only
                    
.CurPosSave         jsr LvlEdCurPosSave             // .hbu023. - save actual cursr pos
                    
.SetDisplay         jsr LvlEdCurSetMsg              // prepare display
                    jsr TextOut                     // <victory message>
..VictorBuffer      dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $00 // EndOfText
                    
.ChkEditMode        lda LR_GameCtrl                 //
                    cmp #LR_GameEdit                //
                    bne VictoryMsgX                 //
                    
.CurPosLoad         jsr LvlEdCurPosLoad             // .hbu023. - restore old cursor position
                    
.ColorMsg           lda #HR_YellowYellow            // 
                    sta Mod_ColorMsg                // only yellow messages in edit mode 
                    
VictoryMsgX         jmp ColorMsg                    //
// ------------------------------------------------------------------------------------------------------------- //
TabMsgID            dc.b $00 //                      // Champ LR message id
                    dc.b $00 //
                    dc.b $00 //
                    dc.b $cc // L
                    dc.b $cf // O
                    dc.b $c4 // D
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $d2 // R
                    dc.b $d5 // U
                    dc.b $ce // N
                    dc.b $ce // N
                    dc.b $c5 // E
                    dc.b $52 // r
// ------------------------------------------------------------------------------------------------------------- //
LevelTimeMsg        subroutine
                    jsr GetTimerStop                // .hbu0013. - get elapsed time as game standard message
                    
.ChkDemoMode        lda LR_GameCtrl                 // .hbu007.
                    lsr a                           // .hbu007.
                    bne .ChkVictoryMsg              // .hbu007.
                    
.Exit               rts                             // .hbu007. - no end times in demo mode
                     
.ChkVictoryMsg      lda LR_ScrnMCMsg - 1            // .hbu007. - status line fix part colour
                    cmp LR_ScrnMCMsg                // .hbu007. - status line msg part colour
                    bne .SetCursor                  // .hbu007. - a victory msg was already displayed
                    
.ClearBaseMsg       jsr ClearMsg
                    jsr ColorLevelDyn               // set level/msg colors
                    
.SetCursor          jsr LvlEdCurSetMsg              // prepare display
                    jsr TextOut                     // <time>
TabMsgStd           dc.b $d4 // T                    // .hbu007.
                    dc.b $c9 // I
                    dc.b $cd // M
                    dc.b $c5 // E
                    dc.b $be // >
TabMsgStdHrs1       dc.b $a0 // h
                    dc.b $ba // :
TabMsgStdMin10      dc.b $a0 // m 
TabMsgStdMin1       dc.b $a0 // m
                    dc.b $ba // :
TabMsgStdSec10      dc.b $a0 // s
TabMsgStdSec1       dc.b $a0 // s
                    dc.b $ae // .
TabMsgStdTen10      dc.b $a0 // t
TabMsgStdTen1       dc.b $a0 // t
                    dc.b $00 // EndOfText
                    
LevelTimeMsgX       jmp ColorMsg                    //
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
StartGraphicOut     subroutine
                    jsr ClearHiresDisp
                    
.Title              jsr SetIRQ                      // title IRQ
                    
                    ldy #$4f
.ColourRegions      lda #HR_LtBlueBlack
                    sta LR_ScrnMultColor+$0000,y    // "Broderbund Software"
                    sta LR_ScrnMultColor+$0050,y
                    sta LR_ScrnMultColor+$00a0,y
                    sta LR_ScrnMultColor+$00c8,y    // "Presents"
                    sta LR_ScrnMultColor+$02f8,y    // "Dough Smith, ..."
                    
                    lda #HR_WhiteBlack
                    sta LR_ScrnMultColor+$0118,y    // "Hansmanns"
                    sta LR_ScrnMultColor+$0168,y
                    sta LR_ScrnMultColor+$01b8,y    // "Lode Runner"
                    sta LR_ScrnMultColor+$0208,y
                    sta LR_ScrnMultColor+$0250,y
                    
                    lda #HR_OrangeBlack
                    sta LR_ScrnMultColor+$02a8,y    // "By"
                    
                    lda #HR_LtGreyBlack
                    sta LR_ScrnMultColor+$0348,y    // "(C) 1983, ..."
                    
                    dey
                    bpl .ColourRegions
                    
.CopyDataI          lda #<LR_StartGfx
                    sta $0f
                    lda #>LR_StartGfx
                    sta $10                         // ($0f/$10) -> graphic data start  address
                    
                    lda #<(LR_ScrnHiReDisp-1)
                    sta $0d
                    lda #>(LR_ScrnHiReDisp-1)
                    sta $0e                         // ($0d/$0e) -> graphic data target address
                    
.GetData            ldy #$00
                    lda ($0f),y
                    sta LRZ_Work                    // first  byte is counter
                    iny
                    lda ($0f),y
                    sta $1f                         // second byte is data
                    
                    lda $0f
                    clc
                    adc #$02                        // set pointer to next pair of data
                    sta $0f
                    bcc .SetCounter                  
                    inc $10
                    
.SetCounter         lda LRZ_Work                    // counter
                    tay
                    lda $1f                         // data
.CopyData           sta ($0d),y
                    dey
                    bne .CopyData
                    
                    lda $0d                         // set next target pos
                    clc
                    adc LRZ_Work                    // counter
                    sta $0d
                    bcc .ChkEnd
                    inc $0e
                    
.ChkEnd             lda $0e
                    cmp #$3f
                    bcc .GetData
                    
.ChkChamp           jsr OutNewChampion              // .hbu020.
                    bcs .GoExit                     // .hbu020. - victory message displayed
                    
.ChkScores          lda LR_HiScoreNam1 + 0          // .hbu018.
                    bne .ColorNameI                 // .hbu018.
                    
.GoExit             jmp StartGraphicOutX            // .hbu018. - no high score data yet
                    
.ColorNameI         tax                             // .hbu018. - save first chr
                    
                    ldy #$27                        // .hbu018. - amount
                    lda #LR_ColorTopScore           // .hbu018. - color scores
.ColorScores        sta LR_ScrnMCTitle,y            // .hbu018.
                    dey                             // .hbu018.
                    bpl .ColorScores                // .hbu018.
                    
                    ldy #$0c                        // .hbu018. - amount
                    lda #LR_ColorTopName            // .hbu018. - color name
.ColorName          sta LR_ScrnMCTitle,y            // .hbu018.
                    dey                             // .hbu018.
                    bpl .ColorName                  // .hbu018.
                    
                    txa                             // .hbu018. - restore first chr
.Fill               sta .InfoNam       + $00        // .hbu018.
                    lda LR_HiScoreNam1 + $01        // .hbu018.
                    sta .InfoNam       + $01        // .hbu018.
                    lda LR_HiScoreNam1 + $02        // .hbu018.
                    sta .InfoNam       + $02        // .hbu018.
                    lda LR_HiScoreNam2 + $00        // .hbu018.
                    sta .InfoNam       + $03        // .hbu018.
                    lda LR_HiScoreNam2 + $01        // .hbu018.
                    sta .InfoNam       + $04        // .hbu018.
                    lda LR_HiScoreNam2 + $02        // .hbu018.
                    sta .InfoNam       + $05        // .hbu018.
                    lda LR_HiScoreNam2 + $03        // .hbu018.
                    sta .InfoNam       + $06        // .hbu018.
                    lda LR_HiScoreNam2 + $04        // .hbu018.
                    sta .InfoNam       + $07        // .hbu018.
                    
.Scores             lda LR_HiScoreHi                // .hbu018. - score byte
                    jsr SplitScoreDigit             // .hbu018.
                    lda LR_Digit1                   // .hbu018. - use only right nybble discard left nybble
                    clc                             // .hbu018.
                    adc #NoDigitsMin                // .hbu018.  map to digit image data numbers
                    sta .InfoScore    + $00         // .hbu018.
                    
                    lda LR_HiScoreMidHi             // .hbu018. -  score byte
                    jsr SplitScoreDigit             // .hbu018.
                    lda LR_Digit10                  // .hbu018.
                    clc                             // .hbu018.
                    adc #NoDigitsMin                // .hbu018. - map to digit image data numbers
                    sta .InfoScore    + $01         // .hbu018.
                    lda LR_Digit1                   // .hbu018.
                    clc                             // .hbu018.
                    adc #NoDigitsMin                // .hbu018. - map to digit image data numbers
                    sta .InfoScore    + $02         // .hbu018.
                    
                    lda LR_HiScoreMidLo             // .hbu018. - score byte
                    jsr SplitScoreDigit             // .hbu018.
                    lda LR_Digit10                  // .hbu018.
                    clc                             // .hbu018.
                    adc #NoDigitsMin                // .hbu018. - map to digit image data numbers
                    sta .InfoScore    + $03         // .hbu018.
                    lda LR_Digit1                   // .hbu018.
                    clc                             // .hbu018.
                    adc #NoDigitsMin                // .hbu018. - map to digit image data numbers
                    sta .InfoScore    + $04         // .hbu018.
                    
                    lda LR_HiScoreLo                // .hbu018. - score byte
                    jsr SplitScoreDigit             // .hbu018.
                    lda LR_Digit10                  // .hbu018.
                    clc                             // .hbu018.
                    adc #NoDigitsMin                // .hbu018. - map to digit image data numbers
                    sta .InfoScore    + $05         // .hbu018.
                    lda LR_Digit1                   // .hbu018.
                    clc                             // .hbu018.
                    adc #NoDigitsMin                // .hbu018. - map to digit image data numbers
                    sta .InfoScore    + $06         // .hbu018.
                    
.Level              lda LR_HiScoreLevel             // .hbu018. - level byte
                    jsr ConvertHex2Dec              // .hbu018.
                    lda LR_Digit100                 // .hbu018.
                    clc                             // .hbu018.
                    adc #NoDigitsMin                // .hbu018. - map to digit image data numbers
                    sta .InfoLevel    + $00         // .hbu018.
                    lda LR_Digit10                  // .hbu018.
                    clc                             // .hbu018.
                    adc #NoDigitsMin                // .hbu018. - map to digit image data numbers
                    sta .InfoLevel    + $01         // .hbu018.
                    lda LR_Digit1                   // .hbu018.
                    clc                             // .hbu018.
                    adc #NoDigitsMin                // .hbu018. - map to digit image data numbers
                    sta .InfoLevel    + $02         // .hbu018.
                    
.InfoLine           jsr LvlEdCurSetHero             // .hbu018.
                    jsr TextOut                     // <hero>
.InfoNam            dc.b $c8 // H                    // .hbu018.
                    dc.b $c1 // A                    // .hbu018.
                    dc.b $ce // N                    // .hbu018.
                    dc.b $d3 // S                    // .hbu018.
                    dc.b $cd // M                    // .hbu018.
                    dc.b $c1 // A                    // .hbu018.
                    dc.b $ce // N                    // .hbu018.
                    dc.b $ce // N                    // .hbu018.
                    dc.b $a0 // <blank>              // .hbu018.
                    dc.b $d3 // S                    // .hbu018.
                    dc.b $c3 // C                    // .hbu018.
                    dc.b $cf // O                    // .hbu018.
                    dc.b $d2 // R                    // .hbu018.
                    dc.b $c5 // E                    // .hbu018.
.InfoScore          dc.b $3c // 0                    // .hbu018.
                    dc.b $3c // 0                    // .hbu018.
                    dc.b $3c // 0                    // .hbu018.
                    dc.b $3c // 0                    // .hbu018.
                    dc.b $3c // 0                    // .hbu018.
                    dc.b $3c // 0                    // .hbu018.
                    dc.b $3c // 0                    // .hbu018.
                    dc.b $a0 // <blank>              // .hbu018.
                    dc.b $cc // L                    // .hbu018.
                    dc.b $d6 // V                    // .hbu018.
                    dc.b $cc // L                    // .hbu018.
.InfoLevel          dc.b $3c // 0                    // .hbu018.
                    dc.b $3c // 0                    // .hbu018.
                    dc.b $3d // 0                    // .hbu018.
                    dc.b $00 // EndOfText            // .hbu018.
                    
StartGraphicOutX    jmp Wait4UserClr                //
// ------------------------------------------------------------------------------------------------------------- //
// SetIRQ            Function: Set title display IRQ to combine the 2 diiferent GFX modes
//                   Parms   :
//                   Returns :
//                   ID      : .hbu018.
// ------------------------------------------------------------------------------------------------------------- //
SetIRQ              subroutine
                    lda #HR_BlackBlack
                    tax                             //
                    ldy #WHITE                      //
                    jsr ColorLevelFix               //
                    
.HiresOn            lda SCROLY                      // VIC 2 - $D011 = VIC Control Register 1
                    and #$7f                        // clear bit7: no bit8 (high bit) of raster compare register at RASTER
                    ora #$20                        // 
                    sta SCROLY                      // VIC 2 - $D011 = VIC Control Register 1
                    
.MultiColorOff      lda SCROLX                      // VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)
                    and #$ef                        // 
                    sta SCROLX                      // VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)
                    
.ChrGen             lda VMCSB                       // VIC 2 - $D018 = Chip Memory Control
                    and #$f0                        // chr generator to video base + 2000-3fff
                    ora #$08
                    sta VMCSB                       // VIC 2 - $D018 = Chip Memory Control
                    
.SetRasterIRQ       sei                             // 
                    
.TitleIRQ           lda #<IRQTitle                  // set Title IRQ routine
                    sta C64_PtrIRQ                  // 
                    lda #>IRQTitle                  // 
                    sta C64_PtrIRQ + $01            // 
                    
                    lda #LR_IRQTitleTop             // 1st raster line for interrupt
                    sta RASTER                      // VIC 2 - $D012 = Write: Line to Compare for Raster IRQ 
                    
.SetIRQ             lda #$01                        // allow raster IRQs
                    sta IRQMASK                     // VIC 2 - $D01A = IRQ Mask Register
                    
.ResetPending       lda CIAICR                      // CIA 1 - $DC0D = Interrupt Control Register - cleared on read
                    lda CI2ICR                      // CIA 2 - $DD0D = Interrupt Control Register - cleared on read
                    
                    lda VICIRQ                      // VIC 2 - $D019 = Interrupt Flag Register - Latched flags cleared if set to 1
                    sta VICIRQ                      // VIC 2 - $D019 = Interrupt Flag Register - Latched flags cleared if set to 1
                    
                    cli                             // 
                    
SetIRQX             rts                             //
// ------------------------------------------------------------------------------------------------------------- //
// ResetIRQ          Function: Switch back to game IRQ
//                   Parms   :
//                   Returns :
//                   ID      : .hbu018.
// ------------------------------------------------------------------------------------------------------------- //
ResetIRQ            subroutine
                    lda #HR_BlackBlack
                    tax                             // .hbu001.
                    ldy #BLACK                      // .hbu001.
                    jsr ColorLevelFix               // .hbu001.
                    
.ResetRasterIRQ     sei                             //
                    
.GameIRQ            lda #<IRQ                       // set Game IRQ
                    sta C64_PtrIRQ                  //
                    lda #>IRQ                       //
                    sta C64_PtrIRQ + $01            // IRQ vector
                    
.ResetIRQ           lda #$00                        // disallow raster IRQs
                    sta IRQMASK                     // VIC 2 - $D01A = IRQ Mask Register
                    
.ResetPending       lda CIAICR                      // CIA 1 - $DC0D = Interrupt Control Register - cleared on read
                    lda CI2ICR                      // CIA 2 - $DD0D = Interrupt Control Register - cleared on read
                    
                    lda VICIRQ                      // VIC 2 - $D019 = Interrupt Flag Register - Latched flags cleared if set to 1
                    sta VICIRQ                      // VIC 2 - $D019 = Interrupt Flag Register - Latched flags cleared if set to 1
                    
.MultiColorOn       lda SCROLX                      // .hbu000. - VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)
                    ora #$10                        // set bit4: enable Multicolor Bitmap Mode
                    sta SCROLX                      // .hbu000. - VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)
                    
                    cli                             //
                    
ResetIRQX           rts                             //
// ------------------------------------------------------------------------------------------------------------- //
// NMI               Function: Cut off RESTORE key
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
NMI                 rti
// ------------------------------------------------------------------------------------------------------------- //
// IRQ               Function: The 60 times a second action
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
IRQ                 subroutine
                    inc LR_CountIRQs
                    
                    lda #$00
                    sta LRZ_TuneVoc1                // tune value voice 1
                    
                    lda LR_Volume
                    and #$0f
                    sta SIGVOL                      // SID - $D418 = Volume and Filter Select
                    lda LR_FallsDown                // $00=fall $20=no fall $ff=init
                    bne .BeepInit
                    
                    ldx LR_FallBeep
                    stx LRZ_TuneVoc1                // tune value voice 1
                    jmp .ChkShoot
                    
.BeepInit           lda #LR_FallBeepIni             // fall beep start value
                    sta LR_FallBeep
                    
.ChkShoot           lda LR_Shoots                   // $00=no $01=right $ff=left
                    beq .ShootInit
                    
                    lda LR_ShootSound
                    sec
                    sbc #LR_ShootSoundSub
                    sta LR_ShootSound
                    sta LRZ_TuneVoc1                // tune value voice 1
                    beq .ShootInit
                    
                    jmp .ChkDeath
                    
.ShootInit          lda #LR_ShootSoundIni
                    sta LR_ShootSound
.ChkDeath           lda LR_DeathTune
                    beq .SetTune
                    
                    sec
                    sbc #LR_DeathTuneSub
                    sta LRZ_TuneVoc1                // tune value voice 1
                    sta LR_DeathTune
                    
.SetTune            lda LRZ_TuneVoc1                // tune value voice 1
                    sta FREHI1                      // SID - $D401 = Oscillator 1 Frequency Control (High Byte)
                    jsr IRQ_PlaySounds
                    
.Keyboard           jsr IRQ_GetKey                  // handle keyboard
.JoyStick           jsr IRQ_GetJoy                  // .hbu024. - handle joystick
                    
IRQ_X               jmp C64_IRQ                     // system
// ------------------------------------------------------------------------------------------------------------- //
// IRQ_GetKey        Function: Store a pressed key code
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
IRQ_GetKey          subroutine
                    lda LRZ_MatrixLastKey           // c64 - key value
                    bne .ChkKey
                    
                    lda #$07                        // DELETE substitution - CRSR_D
                    
.ChkKey             cmp #$40                        // no key pressed
                    bne .ChkKeyFlag
                    
                    lda #$00
                    sta LR_KeyOld
.Exit               rts
                    
.ChkKeyFlag         ldx C64_KeyFlag                 // $01=shift $02=commodore $04=ctrl
                    beq .ChkKeyOld
                    
.SetShift           ora #$80                        // treat all special keys as shift
                    
.ChkKeyOld          cmp LR_KeyOld
                    beq IRQ_GetKeyX
                    
                    sta LR_KeyOld
                    sta LR_KeyNew
                    
IRQ_GetKeyX         rts
// ------------------------------------------------------------------------------------------------------------- //
// IRQ_GetJoy        Function: Store a joystick action
//                   Parms   : 
//                   Returns : 
//                   ID      : .hbu023.
// ------------------------------------------------------------------------------------------------------------- //
IRQ_GetJoy          subroutine
                    dec LR_JoyWait                  //
                    
.GetJoy             lda CIAPRA                      // CIA 1 - $DC00 = Data Port A
                    and #$1f                        // isolate actions
                    eor #$1f                        // flip bits
                    bne .ChkJoyOld                  // an action detected
                    
                    sta LR_JoyOld                   // reset 
.Exit               rts                             // 
                    
.ChkJoyOld          cmp LR_JoyOld                   // 
                    beq IRQ_GetJoyX                 // 
                    
                    sta LR_JoyOld                   // 
                    sta LR_JoyNew                   // 
                    
IRQ_GetJoyX         rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
// IRQTitle          Function: Display the top scorer on title screen in a different GFX mode
//                   Parms   :
//                   Returns :
//                   ID      : .hbu018.
// ------------------------------------------------------------------------------------------------------------- //
IRQTitle            subroutine
                    lda VICIRQ                      // VIC 2 - $D019 = Interrupt Flag Register
                    sta VICIRQ                      // clear interrupt flags 
                    bmi .Raster                     // Bit 7: Flag: At least one VIC IRQ's has happened
                    
                    lda CIAICR                      // CIA 1 - $DC0D - Interrupt Control Register - cleared on read
                    cli                             // still allow VIC IRQs
                    jmp C64_IRQ                     // handle timer IRQs
                    
.Raster             lda RASTER                      // VIC 2 - $D012 = Read: Current Raster Scan Line (Bits 7�0, Bit 8 in SCROLY = $D011)
                    cmp #LR_IRQTitleBot             // 2nd border
                    bcs .MultiColorOff              // higher/equal
                    
.MultiColorOn       lda SCROLX                      // .hbu000. - VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)
                    ora #$10                        // set bit4: enable Multicolor Bitmap Mode
                    sta SCROLX                      // .hbu000. - VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)
                    
                    lda #LR_IRQTitleBot             // set 2nd raster line for interrupt
                    jmp .SetNext                    // 
                    
.MultiColorOff      lda SCROLX                      // VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)
                    and #$ef                        // clear bit4: disable Multicolor Bitmap Mode
                    sta SCROLX                      // VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)
                    
.HiresOn            lda SCROLY                      // VIC 2 - $D011 = VIC Control Register 1
                    ora #$20                        // set bit5: enable Hires Bitmap Mode
                    sta SCROLY                      // VIC 2 - $D011 = VIC Control Register 1
                    
                    lda #LR_IRQTitleTop             // set 1st raster line for interrupt
                    
.SetNext            sta RASTER                      // VIC 2 - $D012 = Write: Write: Line to Compare for Raster IRQ
                    
.Keyboard           jsr IRQ_GetKey                  // handle keyboard 
                    
IRQTitleX           jmp C64_IRQExit                 // 
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
IRQ_PlaySounds      subroutine
                    ldx LR_PtrTuneToPlay
                    cpx LR_PtrNxtTunePos            // pointer: next free tune buffer byte
                    beq IRQ_SoundsReset             // all tunes completed
                    
                    lda #$11                        // triangle wave/start ADS
                    sta LR_WaveVoice2
                    sta LR_WaveVoice3
                    lda LR_TuneSuReVol,x            // tune s/r/volume  (not used)
                    lda #$f0
                    and LR_Volume
                    sta SUREL2                      // SID - $D40D = Oscillator 2 Sustain/Release
                    sta SUREL3                      // SID - $D414 = Oscillator 3 Sustain/Release
                    lda LR_TuneDataPtrV2,x          // tab tune data pointer voice 2
                    bne .Voice02
                    
                    sta LR_WaveVoice2
.Voice02            tay
                    lda TabVocsFreqDatLo,y
                    sta FRELO2                      // SID - $D407 = Oscillator 2 Frequency Control (Low Byte)
                    lda TabVocsFreqDatHi,y
                    sta FREHI2                      // SID - $D408 = Oscillator 2 Frequency Control (High Byte)
                    lda LR_TuneDataPtrV3,x          // tab tune data pointer voice 3
                    bpl .ChkVoice03
                    
                    lda LR_TuneDataPtrV2,x          // tab tune data pointer voice 2
                    tay
                    sec
                    lda TabVocsFreqDatLo,y
                    sbc #$80
                    sta FRELO3                      // SID - $D40E = Oscillator 3 Frequency Control (Low Byte)
                    lda TabVocsFreqDatHi,y
                    sbc #$00
                    sta FREHI3                      // SID - $D40F = Oscillator 3 Frequency Control (High Byte)
                    jmp .PlayTune
                    
.ChkVoice03         bne .Voice03
                    
                    sta LR_WaveVoice3
.Voice03            tay
                    lda TabVocsFreqDatLo,y
                    sta FRELO3                      // SID - $D40E = Oscillator 3 Frequency Control (Low Byte)
                    lda TabVocsFreqDatHi,y
                    sta FREHI3                      // SID - $D40F = Oscillator 3 Frequency Control (High Byte)
.PlayTune           lda LR_WaveVoice2
                    sta VCREG2                      // SID - $D40B = Oscillator 2 Control
                    lda LR_WaveVoice3
                    sta VCREG3                      // SID - $D412 = Oscillator 3 Control
.DecTime            dec LR_TunePlayTime,x           // tab tune times
                    bne IRQ_PlaySoundsX             // not completed yet
                    
                    inc LR_PtrTuneToPlay            // next tune to play
                    
IRQ_PlaySoundsX     rts
// ------------------------------------------------------------------------------------------------------------- //
IRQ_SoundsReset     subroutine
                    lda #$00
                    sta VCREG2                      // SID - $D40B = Oscillator 2 Control
                    sta VCREG3                      // SID - $D412 = Oscillator 3 Control
                    
IRQ_SoundsResetX    rts
// ------------------------------------------------------------------------------------------------------------- //
// SetTune           Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
SetTune             subroutine
                    pla                             // played during IRQ
                    sta LRZ_MelodyDataLo
                    pla
                    sta LRZ_MelodyDataHi            // ($7d/$7e) ptr melody data
                    bne .SetNext
                    
.CpyTune            sei
                    
                    ldy #$00
                    lda (LRZ_MelodyData),y
                    beq .PrepareXit
                    
                    ldx LR_PtrNxtTunePos            // pointer: next free tune buffer byte
                    sta LR_TunePlayTime,x           // tab tune times
                    iny
                    lda (LRZ_MelodyData),y
                    sta LR_TuneDataPtrV2,x          // tab tune data pointer voice 2
                    iny
                    lda (LRZ_MelodyData),y
                    sta LR_TuneDataPtrV3,x          // tab tune data pointer voice 3
                    iny
                    lda (LRZ_MelodyData),y
                    sta LR_TuneSuReVol,x            // tune s/r/volume  (not used)
                    inc LR_PtrNxtTunePos            // pointer: next free tune buffer byte
                    lda LRZ_MelodyDataLo
                    
                    clc
                    adc #$04                        // tune entry length $04
                    sta LRZ_MelodyDataLo
                    lda LRZ_MelodyDataHi
                    adc #$00
                    sta LRZ_MelodyDataHi
                    bne .CpyTune
                    
.SetNext            inc LRZ_MelodyDataLo
                    bne .CpyTune
                    inc LRZ_MelodyDataHi
                    bne .CpyTune
                    
.PrepareXit         lda LRZ_MelodyDataHi            // point behind melody data
                    pha
                    lda LRZ_MelodyDataLo
                    pha
                    
                    cli
                    
SetTuneX            rts
// ------------------------------------------------------------------------------------------------------------- //
// RND               Function: Return a unique random disk level number
//                   Parms   :
//                   Returns :
//                   ID      : .hbu014.
// ------------------------------------------------------------------------------------------------------------- //
RNDInit             subroutine
                    lda #LR_LevelDiskMax+1
                    sta LR_RNDMax
                    
                    ldy #$00
.Fill               tya 
                    sta LR_RandomField,y
                    iny
                    cpy LR_RNDMax
                    bne .Fill
                    
RNDInitX            rts
// ------------------------------------------------------------------------------------------------------------- //
RND                 subroutine
                    lda TIMALO                      // CIA 1 - $DC04 = Timer A (low byte)
                    eor TIMAHI                      // CIA 1 - $DC05 = Timer A (high byte)
                    eor TI2ALO                      // CIA 2 - $DD04 = Timer A (low byte)
                    adc TI2AHI                      // CIA 2 - $DD05 = Timer A (high byte)
                    eor TI2BLO                      // CIA 2 - $DD06 = Timer B (low byte)
                    eor TI2BHI                      // CIA 2 - $DD07 = Timer B (high byte)
                    
                    cmp LR_RNDMax                   // upper limit
                    bcs RND
                    
.SavRnd             tay
                    lda LR_RandomField,y
                    sta LR_RND                      // save random level no
                    
.Reduce             lda LR_RandomField+1,y          // Move the entire field one position up 
                    sta LR_RandomField,y            // to the position found
                    iny
                    cpy LR_RNDMax
                    bne .Reduce
                    
                    dec LR_RNDMax                   // reduce the max value
                    bne .GetRnd                     // is one more than max disk level - no underflow
                    
                    jsr RNDInit                     // refill field and max counter
                    
.GetRnd             lda LR_RND                      // restore random level no
                    
RNDX                rts
// ------------------------------------------------------------------------------------------------------------- //
// Randomizer        Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
Randomizer          subroutine
                    sta LR_RandomAc                 // save accumulator
.GetBeam            lda RASTER                      // VIC 2 - $D012 = Read: Raster Scan Line/ Write: Line for Raster IRQ
                    sta LR_RasterBeamPos
                    cpx LR_RasterBeamPos
                    bcc .ChkBeam
                    beq .ChkBeam
                    jmp .GetBeam
                    
.ChkBeam            cpy LR_RasterBeamPos
                    bcc .GetBeam
                    
                    sec
                    sbc LR_Random
                    bcs .ChkAc
                    
                    eor #$ff
                    adc #$01
.ChkAc              cmp LR_RandomAc
                    bcc .GetBeam
                    
                    lda LR_RasterBeamPos
                    sta LR_Random
                    
RandomizerX         rts
// ------------------------------------------------------------------------------------------------------------- //
// MelodyInit        Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MelodyInit          subroutine
                    lda MelodyMaxNo
                    sta LR_MelodyNo
                    lda MelodyMinHight
                    sta LR_MelodyHeight
                    
MelodyInitX         rts
// ------------------------------------------------------------------------------------------------------------- //
// SetNextMelody     Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
SetNextMelody       subroutine
                    dec LR_MelodyNo
                    bpl SetNextMelodyX
                    
                    inc LR_MelodyHeight
                    lda LR_MelodyHeight
                    cmp MelodyMaxHight
                    bcc .GetMax
                    
                    lda MelodyMinHight
                    sta LR_MelodyHeight
.GetMax             lda MelodyMaxNo
                    sta LR_MelodyNo
                    
SetNextMelodyX      rts
// ------------------------------------------------------------------------------------------------------------- //
// VictoryTuneCopy   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
VictoryTuneCopy     subroutine
                    lda LR_MelodyNo
                    asl a
                    tax
                    lda TabMelodyPtr,x
                    sta LRZ_MelodyDataLo
                    lda TabMelodyPtr+1,x
                    sta LRZ_MelodyDataHi            // ($7d/$7e) -> melody data
                    
.CpyTune            sei
                    
                    ldy #$00
                    lda (LRZ_MelodyData),y
                    beq .PrepXit
                    
                    ldx LR_PtrNxtTunePos            // pointer: next free tune buffer byte
                    sta LR_TunePlayTime,x           // tab tune times
                    iny
                    lda (LRZ_MelodyData),y
                    beq .Voice01
                    
                    clc
                    adc LR_MelodyHeight
.Voice01            sta LR_TuneDataPtrV2,x          // tab tune data pointer voice 2
                    iny
                    lda (LRZ_MelodyData),y
                    beq .Voice02
                    bmi .Voice02
                    
                    clc
                    adc LR_MelodyHeight
.Voice02            sta LR_TuneDataPtrV3,x          // tab tune data pointer voice 3
                    iny
                    lda (LRZ_MelodyData),y
                    sta LR_TuneSuReVol,x            // tune s/r/volume  (not used)
                    inc LR_PtrNxtTunePos            // pointer: next free tune buffer byte
                    lda LRZ_MelodyDataLo
                    clc
                    adc #$04
                    sta LRZ_MelodyDataLo
                    lda LRZ_MelodyDataHi
                    adc #$00
                    sta LRZ_MelodyDataHi
                    bne .CpyTune
                    
.PrepXit            cli
VictoryTuneCopyX    rts
// ------------------------------------------------------------------------------------------------------------- //
// GameInitOnce      Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
GameInitOnce        subroutine
                    lda $01
                    and #$fe                        // basic off
                    sta $01
                    
                    lda #$00
                    sta LRZ_Work
                    sta $1f
                    
.CreateGfxPtrTab    ldy #$00
                    lda #$19                        // 25
                    sta LR_Counter
.GetAmount          ldx #$08
.GetValue           lda $1f
                    sta LR_TabOffHiresHi,y          // offset grafic output high
                    lda LRZ_Work
                    sta LR_TabOffHiresLo,y          // offset grafic output low
                    inc LRZ_Work
                    iny
                    dex
                    bne .GetValue
                    
                    clc
                    adc #$39
                    sta LRZ_Work
                    lda $1f
                    adc #$01
                    sta $1f
                    
                    dec LR_Counter
                    bne .GetAmount
                    
.CreateImageAdrTab  lda #<DatImages                 // .hbu026. - set start address
                    sta $1e                         // .hbu026.
                    lda #>DatImages                 // .hbu026.
                    sta $1f                         // .hbu026.
                    
                    ldx #$00                        // .hbu026. - counter
.GetImageAdrLo      lda $1f                         // .hbu026.
                    sta LR_ImageAdrHi,x             // .hbu026. - image address table high byte
.GetImageAdrHi      lda $1e                         // .hbu026.
                    sta LR_ImageAdrLo,x             // .hbu026. - image address table low  byte
                    
                    clc                             // .hbu026.
                    adc #($0b * $03)                // .hbu026. - $21 image bytes
                    sta $1e                         // .hbu026.
                    bcc .SetNextTabPos              // .hbu026.
                    inc $1f                         // .hbu026.
                    
.SetNextTabPos      inx                             // .hbu026.
                    bne .GetImageAdrLo              // .hbu026. - fill in $ff image addresses

.SetNMI             lda #<NMI
                    sta C64_PtrNMI
                    lda #>NMI
                    sta C64_PtrNMI + 1              // point NMI vector to rti
                    
                    jsr ClearHiresDisp
                    
                    lda #BLACK
                    sta BGCOL0                      // VIC 2 - $D021 = BackGround Color 0
                    sta EXTCOL                      // VIC 2 - $D020 = Border Color
                    
                    lda #$b0
                    sta SUREL1                      // SID - $D406 = Oscillator 1 Sustain/Release
                    lda #$11
                    sta VCREG1                      // SID - $D404 = Oscillator 1 Control
                    
                    ldx #$30                        // $30*$40=$0c00
                    stx LR_SpritePtr00              // sprite 0 data at $0c00
                    inx
                    stx LR_SpritePtr02              // sprite 2 data at $0c40
                    inx
                    stx LR_SpritePtr03              // sprite 3 data at $0c80
                    inx
                    stx LR_SpritePtr04              // sprite 4 data at $0cc0
                    inx
                    stx LR_SpritePtr06              // sprite 6 data at $0d00
                    inx
                    stx LR_SpritePtr07              // sprite 7 data at $0d40
                    
                    lda #$00
                    sta SPBGPR                      // VIC 2 - $D01B = Sprite to Foreground Priority
                    tay
.Clear              sta $02,y                       // zero page
                    sta LR_SpriteStore01,y          // sprite data store $0c00
                    sta LR_SpriteStore02,y          // sprite data store
                    iny
                    bne .Clear
                    
                    lda #$ff
                    sta SPENA                       // VIC 2 - $D015 = Sprite Enable
                    
.SetIRQ             sei
                    
                    lda #<IRQ
                    sta C64_PtrIRQ
                    lda #>IRQ
                    sta C64_PtrIRQ + 1              // IRQ vector
                    
                    cli
                    
GameInitOnceX       rts
// ------------------------------------------------------------------------------------------------------------- //
// ColorLevel...     Function: Select a new colour combination every 10th level
//                             Do not select the RED/RED one again
//                   Parms   : ac=color level tiles  xr=color status lines
//                   Returns :
//                   Label   : .hbu001.
// ------------------------------------------------------------------------------------------------------------- //
ColorLevelFix       subroutine
                    sta Mod_ColorLevelF             // .hbu001. - front
                    sty Mod_ColorLevelB             // .hbu001. - background
                    stx Mod_ColorStatusF            // .hbu001. - status lines
                    sty Mod_ColorStatusB            // .hbu001. - status lines
                    
                    jsr ColorLevel                  // .hbu001.
                    
ColorLevelFixX      jmp ColorStatus                 // .hbu001.
// ------------------------------------------------------------------------------------------------------------- //
ColorLevelDyn       subroutine
                    lda LR_GameCtrl                 // .hbu001. - $00=start $01=demo $02=game $03=play_level $05=edit
                    lsr a                           // .hbu001.
                    bne .Game                       // .hbu001.
                    
.Demo               ldx #NoSpColorDemo              // .hbu001.
                    ldy #GREY                       // .hbu001. - get background
                    bne .SetColor                   // .hbu001. - always
                    
.Game               lda LR_LevelNoGame              // .hbu001.
                    cmp #151                        // .hbu001. - 10*15 different color sets
                    bcc .GetColorPtrI               // .hbu001. - still first 150 levels
                    
.Adjust             sbc #140                        // .hbu001. - do not select red/red again
                    
.GetColorPtrI       ldx #$ff                        // .hbu001.
                    sec                             // .hbu001.
.GetColorPtr        inx                             // .hbu001. - calculate pointer for table of colors
                    sbc #$0a                        // .hbu001.
                    bcs .GetColorPtr                // .hbu001.
                    
                    ldy #WHITE                      // .hbu001. - get background
                    
.SetColor           sty Mod_ColorLevelB             // .hbu001. - set background
                    
                    lda TabLevelColor,x             // .hbu001.
                    sta Mod_ColorLevelF             // .hbu001.
                    sta Mod_ColorStatusB            // .hbu001.
                    lda TabStatusColor,x            // .hbu001.
                    sta Mod_ColorStatusF            // .hbu001.
                    lda TabMsgColor,x               // .hbu001.
                    sta Mod_ColorMsg                // .hbu001. - set msgcolor
                    
                    jsr ColorSprites
                    
ColorLevelDynX      rts                             // .hbu001.
// ------------------------------------------------------------------------------------------------------------- //
ColorLevel          subroutine
                    ldy #$00                        // .hbu001.
.ColorLevel         lda #HR_OrangeBlue              // .hbu001.
Mod_ColorLevelF     equ *-1                         // .hbu001.
                    sta LR_ScrnMCPage0,y            // .hbu001. - Multi Color RAM
                    sta LR_ScrnMCPage1,y            // .hbu001.
                    sta LR_ScrnMCPage2,y            // .hbu001.
                    sta LR_ScrnMCPage3,y            // .hbu001.
                    lda #WHITE                      // .hbu001.
Mod_ColorLevelB     equ *-1                         // .hbu001.
                    sta LR_ColRamPage0,y            // .hbu001. - Color RAM
                    sta LR_ColRamPage1,y            // .hbu001.
                    sta LR_ColRamPage2,y            // .hbu001.
                    sta LR_ColRamPage3,y            // .hbu001.
                    dey                             // .hbu001.
                    bne .ColorLevel                 // .hbu001.
                    
ColorLevelX         rts                             // .hbu001.
// ------------------------------------------------------------------------------------------------------------- //
ColorStatus         subroutine
                    ldy #$4f                        // .hbu001.
.ColorStatus        lda #HR_OrangeBlue              // .hbu001.
Mod_ColorStatusF    equ *-1                         // .hbu001.
                    sta LR_ScrnMCStatus,y           // .hbu001.
                    
                    lda #WHITE                      // .hbu001.
Mod_ColorStatusB    equ *-1                         // .hbu001.
                    sta LR_ColRamStatus,y           // .hbu001.
                    dey                             // .hbu001.
                    bpl .ColorStatus                // .hbu001.
                    
ColorStatusX        rts                             // .hbu001.
// ------------------------------------------------------------------------------------------------------------- //
ColorMsg            subroutine
                    ldy #$13                        // .hbu007. - quick recolor after ClearMsg
                    lda #HR_OrangeBlue              // .hbu007.
Mod_ColorMsg        equ *-1                         // .hbu007.
.ColorLoop          sta LR_ScrnMCMsg,y              // .hbu007. - recolor message part of status row
                    dey                             // .hbu007.
                    bpl .ColorLoop                  // .hbu007.
                    
ColorMsgX           rts                             // .hbu007.
// ------------------------------------------------------------------------------------------------------------- //
ClearMsg            subroutine
                    ldy #$13                        // .hbu007. - quick clear by setting both colors to black
                    lda #HR_BlackBlack              // .hbu007.
.ColorLoop          sta LR_ScrnMCMsg,y              // .hbu007. - recolor message part of status row
                    dey                             // .hbu007.
                    bpl .ColorLoop                  // .hbu007.
                    
ClearMsgX           rts                             // .hbu007.
// ------------------------------------------------------------------------------------------------------------- //
TabLevelColor       dc.b HR_CyanRed                // 00 .hbu001. - start
                    dc.b HR_CyanPurple             // 01 .hbu001.
                    dc.b HR_CyanLtGreen            // 02 .hbu001.
                    dc.b HR_CyanBlue               // 03 .hbu001.
                    dc.b HR_CyanOrange             // 04 .hbu001.
                    dc.b HR_CyanYellow             // 05 .hbu001.
                    dc.b HR_CyanLtRed              // 06 .hbu001.
                    dc.b HR_CyanGreen              // 07 .hbu001.
                    dc.b HR_CyanPurple             // 08 .hbu001.
                    dc.b HR_CyanLtGreen            // 09 .hbu001.
                    dc.b HR_CyanBlue               // 0a .hbu001.
                    dc.b HR_CyanOrange             // 0b .hbu001.
                    dc.b HR_CyanLtBlue             // 0c .hbu001.
                    dc.b HR_CyanLtRed              // 0d .hbu001.
                    dc.b HR_CyanGreen              // 0e .hbu001.
                    dc.b HR_CyanPurple             // 0f .hbu001. - level 150
                    
                    dc.b HR_WhiteLtGrey            // 10 .hbu001. - demo 
                    
TabStatusColor      dc.b HR_CyanRed                // 00 .hbu001. - start
                    dc.b HR_CyanLtBlue             // 01 .hbu001.
                    dc.b HR_CyanLtRed              // 02 .hbu001.
                    dc.b HR_CyanPurple             // 03 .hbu001.
                    dc.b HR_CyanLtRed              // 04 .hbu001.
                    dc.b HR_CyanLtGreen            // 05 .hbu001.
                    dc.b HR_CyanPurple             // 06 .hbu001.
                    dc.b HR_CyanOrange             // 07 .hbu001.
                    dc.b HR_CyanLtBlue             // 08 .hbu001.
                    dc.b HR_CyanLtRed              // 09 .hbu001.
                    dc.b HR_CyanPurple             // 0a .hbu001.
                    dc.b HR_CyanLtRed              // 0b .hbu001.
                    dc.b HR_CyanLtGreen            // 0c .hbu001.
                    dc.b HR_CyanPurple             // 0d .hbu001.
                    dc.b HR_CyanYellow             // 0e .hbu001.
                    dc.b HR_CyanLtBlue             // 0f .hbu001. - level 150
                    
                    dc.b HR_GreyDkGrey             // 10 .hbu001. - demo
                    
TabMsgColor         dc.b HR_YellowYellow           // 00 .hbu001. - start
                    dc.b HR_LtRedLtRed             // 01 .hbu001.
                    dc.b HR_LtBlueLtBlue           // 02 .hbu001.
                    dc.b HR_LtGreenLtGreen         // 03 .hbu001.
                    dc.b HR_YellowYellow           // 04 .hbu001.
                    dc.b HR_LtRedLtRed             // 05 .hbu001.
                    dc.b HR_LtGreenLtGreen         // 06 .hbu001.
                    dc.b HR_LtRedLtRed             // 07 .hbu001.
                    dc.b HR_YellowYellow           // 08 .hbu001.
                    dc.b HR_LtBlueLtBlue           // 09 .hbu001.
                    dc.b HR_LtGreenLtGreen         // 0a .hbu001.
                    dc.b HR_LtBlueLtBlue           // 0b .hbu001.
                    dc.b HR_LtRedLtRed             // 0c .hbu001.
                    dc.b HR_YellowYellow           // 0d .hbu001.
                    dc.b HR_LtBlueLtBlue           // 0e .hbu001.
                    dc.b HR_LtGreenLtGreen         // 0f .hbu001. - level 150
                    
                    dc.b HR_WhiteWhite             // 10 .hbu001. - demo
// ------------------------------------------------------------------------------------------------------------- //
// ColorSprites      Function: Set/Reset sprite colors
//                   Parms   : carry - set=old colors  clear=new colors
//                   Returns :
//                   Label   : .hbu004.
// ------------------------------------------------------------------------------------------------------------- //
ColorSprites        subroutine
                    txa                             // .hbu004.
                    asl                             // .hbu004. - *2
                    asl                             // .hbu004. - *4
                    asl                             // .hbu004. - *8
                    sta LR_ColorSetEnemy            // .hbu004. - save for enemy rebirth
                    clc                             // .hbu004. -
                    adc #$07                        // .hbu004. - set to end of set - will be decremented
                    tax                             // .hbu004.
                    
                    ldy #$07                        // .hbu004.
.GetNewColors       lda TabSpColorSets,x            // .hbu004.
.SetNewColors       sta SP0COL,y                    // .hbu004. - recolor all sprites
                    dex                             // .hbu004. - set new color
                    dey                             // .hbu004.
                    bpl .GetNewColors               // .hbu004.
                    
ColorSpritesX       rts                             // .hbu004.
// ------------------------------------------------------------------------------------------------------------- //
TabSpColorSets      equ *
TabSpColorStart     dc.b WHITE  ,BLACK  ,CYAN     ,CYAN     ,CYAN      ,BLACK  ,CYAN     ,CYAN     // .hbu004.
                    
TabSpColorSet010    dc.b WHITE  ,BLACK  ,YELLOW   ,LT_GREEN ,LT_RED    ,BLACK  ,LT_GREY  ,CYAN     // .hbu004.
TabSpColorSet020    dc.b WHITE  ,BLACK  ,LT_RED   ,LT_BLUE  ,PURPLE    ,BLACK  ,YELLOW   ,LT_GREY  // .hbu004.
TabSpColorSet030    dc.b WHITE  ,BLACK  ,LT_GREEN ,LT_RED   ,YELLOW    ,BLACK  ,CYAN     ,LT_GREY  // .hbu004.
TabSpColorSet040    dc.b WHITE  ,BLACK  ,YELLOW   ,PURPLE   ,LT_BLUE   ,BLACK  ,LT_GREEN ,LT_GREY  // .hbu004.
TabSpColorSet050    dc.b WHITE  ,BLACK  ,LT_RED   ,LT_BLUE  ,PURPLE    ,BLACK  ,LT_GREY  ,CYAN     // .hbu004.
TabSpColorSet060    dc.b WHITE  ,BLACK  ,LT_BLUE  ,YELLOW   ,LT_GREEN  ,BLACK  ,CYAN     ,LT_GREY  // .hbu004.
TabSpColorSet070    dc.b WHITE  ,BLACK  ,YELLOW   ,LT_RED   ,LT_BLUE   ,BLACK  ,PURPLE   ,LT_GREY  // .hbu004.
TabSpColorSet080    dc.b WHITE  ,BLACK  ,CYAN     ,YELLOW   ,LT_GREEN  ,BLACK  ,LT_RED   ,LT_BLUE  // .hbu004.
TabSpColorSet090    dc.b WHITE  ,BLACK  ,LT_BLUE  ,PURPLE   ,YELLOW    ,BLACK  ,CYAN     ,LT_RED   // .hbu004.
TabSpColorSet100    dc.b WHITE  ,BLACK  ,YELLOW   ,LT_GREEN ,LT_RED    ,BLACK  ,LT_GREY  ,CYAN     // .hbu004.
TabSpColorSet110    dc.b WHITE  ,BLACK  ,LT_GREEN ,CYAN     ,LT_BLUE   ,BLACK  ,PURPLE   ,YELLOW   // .hbu004.
TabSpColorSet120    dc.b WHITE  ,BLACK  ,YELLOW   ,PURPLE   ,LT_RED    ,BLACK  ,LT_GREY  ,CYAN     // .hbu004.
TabSpColorSet130    dc.b WHITE  ,BLACK  ,LT_GREY  ,LT_BLUE  ,CYAN      ,BLACK  ,YELLOW   ,LT_GREEN // .hbu004.
TabSpColorSet140    dc.b WHITE  ,BLACK  ,PURPLE   ,LT_RED   ,LT_BLUE   ,BLACK  ,CYAN     ,LT_GREY  // .hbu004.
TabSpColorSet150    dc.b WHITE  ,BLACK  ,LT_GREEN ,LT_RED   ,CYAN      ,BLACK  ,YELLOW   ,LT_GREY  // .hbu004.
                    
TabSpColorDemo      dc.b WHITE  ,BLACK  ,YELLOW   ,LT_GREEN ,LT_RED    ,BLACK  ,LT_BLUE  ,PURPLE   // .hbu004.
// ------------------------------------------------------------------------------------------------------------- //
NoSpColorDemo       equ  (TabSpColorDemo - TabSpColorSets) / (TabSpColorSet020 - TabSpColorSet010)
// ------------------------------------------------------------------------------------------------------------- //
// CommandTables     Function: In game command tables
//                   Parms   : 
//                   Returns : The routines start addresses will be put on the stack and called with RTS afterwards
// ------------------------------------------------------------------------------------------------------------- //
TabInGameCmdChr     dc.b $9e // U                          - Try Next Level
                    dc.b $a9 // P                          - Try Previous Level
                    dc.b $be // Q - Quit                   - Quit level test and return to editor
                    dc.b $95 // F                          - Inc Number of Lives
                    dc.b $3f // <run/stop>                 - Pause game
                    dc.b $91 // R                          - Resign
                    dc.b $8a // A                          - Restart Level
                    dc.b $a2 // J                          - Set Joystick Control
                    dc.b $a5 // K                          - Set Keyboard Control
                    dc.b $a4 // M                          - Load Level Mirrored
                    dc.b $aa // L                          - Load Game
                    dc.b $8d // S                          - Save Game
                    dc.b $97 // X                          - Transmit level to a slot of drive 9
                    dc.b $9a // G                          - Set all Gold collected in expert mode
                    dc.b $8c // Z                          - Random (Zufall) level mode
                    dc.b $92 // D                          - Toggle Shoot Mode
                    dc.b $28 // +                          - Inc Game Speed
                    dc.b $a8 // + plus <commodore>         - Inc Game Speed + <commodore> key
                    dc.b $2b // -                          - Dec Game Speed
                    dc.b $ab // - plus <commodore>         - Dec Game Speed + <commodore> key
                    dc.b $00 // <end_of_tab>
                    
TabInGameCmdSub     dc.w IGC_NextLvl     - 1 // U          - Try Next Level
                    dc.w IGC_PrevLvl     - 1 // P          - Try Previous Level
                    dc.w IGC_QuitLvl     - 1 // Q          - Quit level test and return to editor 
                    dc.w IGC_IncNumLife  - 1 // F          - Inc Number of Lives
                    dc.w IGC_Pause       - 1 // <run/stop> - Pause game
                    dc.w IGC_Resign      - 1 // R          - Resign
                    dc.w IGC_Suicide     - 1 // A          - Restart Level
                    dc.w IGC_SetJoy      - 1 // J          - Set Joystick Control
                    dc.w IGC_SetKey      - 1 // K          - Set Keyboard Control
                    dc.w IGC_SetMirror   - 1 // M          - Load Level Mirrored
                    dc.w IGC_SetLoad     - 1 // L          - Load Game
                    dc.w IGC_SetSave     - 1 // S          - Save Game
                    dc.w IGC_Xmit        - 1 // X          - Transmit level to a slot of drive 9
                    dc.w IGC_Success     - 1 // G          - Set all Gold collected in expert mode
                    dc.w IGC_Random      - 1 // Z          - Random (Zufall) level mode
                    dc.w IGC_ShootMode   - 1 // D          - Toggle Shoot Mode
                    dc.w IGC_IncSpeed    - 1 // +          - Inc Game Speed
                    dc.w IGC_IncSpeed    - 1 // +          - Inc Game Speed + <commodore> key
                    dc.w IGC_DecSpeed    - 1 // -          - Dec Game Speed
                    dc.w IGC_DecSpeed    - 1 // -          - Dec Game Speed + <commodore> key
// ------------------------------------------------------------------------------------------------------------- //
TabBoardEdCmdChr    dc.b $29 // p - Play  level
                    dc.b $14 // c - Clear level
                    dc.b $0e // e - Edit  level
                    dc.b $24 // m - Move  level
                    dc.b $17 // x - Swap  level
                    dc.b $21 // i - Initialize disk
                    dc.b $0d // s - Show  high scores - .hbu011.
                    dc.b $8d // S - Clear high scores - .hbu011.
                    dc.b $00 // EndOfCmds
                    
TabBoardEdCmdSub    dc.w BED_PlayLevel   - 1
                    dc.w BED_ClearLevel  - 1
                    dc.w BED_Edit        - 1
                    dc.w BED_MoveLevel   - 1
                    dc.w BED_SwapLevels  - 1
                    dc.w BED_InitDisk    - 1
                    dc.w BED_ShowScore   - 1        // .hbu011.
                    dc.w BED_ClearScore  - 1        // .hbu011.
// ------------------------------------------------------------------------------------------------------------- //
TabLevelEdCmdChr    dc.b $21 // i - up
                    dc.b $24 // m - down
                    dc.b $22 // j - left
                    dc.b $25 // k - right
                    
                    dc.b $87 // <cursor up>          // .hbu009.
                    dc.b $07 // <cursor down>        // .hbu009.
                    dc.b $82 // <cursor left>        // .hbu009.
                    dc.b $02 // <cursor right>       // .hbu009.
                    
                    dc.b $8d // S - Save 
                    dc.b $96 // T - Test     level   // .hbu009.
                    dc.b $8a // A - Reload   level   // .hbu009.
                    dc.b $95 // F - Forward  level 
                    dc.b $9e // U - Forward  level   // .hbu009.
                    dc.b $9c // B - Backward level 
                    dc.b $a9 // P - Backward level   // .hbu009.
                    dc.b $97 // X - Transmit level   // .hbu017.
                    dc.b $a4 // M - Mirror   level   // .hbu012.
                    dc.b $16 // t - edit msg text    // .hbu009.
                    dc.b $be // Q - Quit 
                    dc.b $00 // EndOfCmdTab
                    
TabLevelEdCmdSub    dc.w LED_CurUp     - 1
                    dc.w LED_CurDo     - 1
                    dc.w LED_CurLe     - 1
                    dc.w LED_CurRi     - 1
                    
                    dc.w LED_CurUp     - 1          // .hbu009.
                    dc.w LED_CurDo     - 1          // .hbu009.
                    dc.w LED_CurLe     - 1          // .hbu009.
                    dc.w LED_CurRi     - 1          // .hbu009.
                    
                    dc.w LED_SaveLvl   - 1
                    dc.w LED_TestLvl   - 1          // .hbu023.
                    dc.w LED_SameLvl   - 1          // .hbu009.
                    dc.w LED_NextLvl   - 1
                    dc.w LED_NextLvl   - 1
                    dc.w LED_PrevLvl   - 1
                    dc.w LED_PrevLvl   - 1
                    dc.w LED_XmitLvl   - 1          // .hbu017.
                    dc.w LED_MirrorLvl - 1          // .hbu012.
                    dc.w LED_MsgTxtLvl - 1          // .hbu009.
                    dc.w LED_Quit      - 1
// ------------------------------------------------------------------------------------------------------------- //
BoardEditor         subroutine
                    ldy #$00                        // 
                    sty LR_ScoreLo                  // 
                    sty LR_ScoreMidLo               // 
                    sty LR_ScoreMidHi               // 
                    sty LR_ScoreHi                  // 
                    
                    dey                             // 
                    sty LR_LvlReload                // <> LR_LevelNoDisk - force level load
                    
                    lda #LR_NumLivesInit            // 
                    sta LR_NumLives                 // 
                    
                    lda #LR_GameEdit                // 
                    sta LR_GameCtrl                 // $00=start $01=demo $02=game $03=play_level $05=edit
                    sta LR_SprtPosCtrl              // <> $00 - no sprites
                    
                    lda LR_ControllerTyp            // controler type  $ca=joystick  $cb=keyboard
                    sta Mod_CtrlerTyp               // 
                    
                    lda #LR_Keyboard                // 
                    sta LR_ControllerTyp            // controler type  $ca=joystick  $cb=keyboard
                    
                    lda LR_LevelNoDisk              // 000-149
                    cmp #LR_LevelDiskMax+1          // 150
                    bcc .ClearScrnDispA             // .hbu000. - lower - clear hires display screen
                    
.ResetDiskLevel     lda #LR_LevelDiskMin            // 
                    sta LR_LevelNoDisk              // 000-149
                    
.ClearScrnDispA     jsr ClearHiresDisp              // .hbu000. - first clear before switch back to multicolor - avoid flicker
                    jsr ClearHiresPrep              // .hbu000. - avoid weird screen after an edit from StartGraphicOut
                    jmp .SetEdCmdWaitColr           // .hbu000.
                    
GoClearScrnDisp     jsr ClearHiresDisp              // global return point - multi color is switched on already
                    
.SetEdCmdWaitColr   lda #HR_YellowCyan              // 
                    tax                             // .hbu001.
                    ldy #WHITE                      // .hbu001.
                    jsr ColorLevelFix               // .hbu001.
                    
                    lda #>LR_ScrnHiReDisp           // $20
                    sta LRZ_GfxScreenOut            // target output  $20=$2000 $40=$4000
                    
                    lda #LR_KeyNewNone
                    sta LR_KeyNew
                    
                    jsr LvlEdCurPosInit             // set cursor to top left screen pos
                    jsr TextOut                     // <lode runner board editor>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $cf // O
                    dc.b $c4 // D
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $d2 // R
                    dc.b $d5 // U
                    dc.b $ce // N
                    dc.b $ce // N
                    dc.b $c5 // E
                    dc.b $d2 // R
                    dc.b $a0 // <blank>
                    dc.b $c2 // B
                    dc.b $cf // O
                    dc.b $c1 // A
                    dc.b $d2 // R
                    dc.b $c4 // D
                    dc.b $a0 // <blank>
                    dc.b $c5 // E
                    dc.b $c4 // D
                    dc.b $c9 // I
                    dc.b $d4 // T
                    dc.b $cf // O
                    dc.b $d2 // R
                    dc.b $8d // <new line>
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $d2 // R
                    dc.b $af // /
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $cb // K
                    dc.b $c5 // E
                    dc.b $d9 // Y
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $c2 // B
                    dc.b $cf // O
                    dc.b $d2 // R
                    dc.b $d4 // T
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $ce // N
                    dc.b $d9 // Y
                    dc.b $a0 // <blank>
                    dc.b $c3 // C
                    dc.b $cf // O
                    dc.b $cd // M
                    dc.b $cd // M
                    dc.b $c1 // A
                    dc.b $ce // N
                    dc.b $c4 // D
                    dc.b $8d // <new line>
BoardEditorX        dc.b $00 // EndOfText
// ------------------------------------------------------------------------------------------------------------- //
BoEdWaitCmd         subroutine
                    lda LRZ_ScreenRow               // screen row  (00-0f)
                    cmp #LR_BEDCmdLinMax
                    bcs GoClearScrnDisp             // clear hires display screen
                    
                    jsr TextOut                     // <command>
                    dc.b $8d // <new line>
                    dc.b $c3 // C
                    dc.b $cf // O
                    dc.b $cd // M
                    dc.b $cd // M
                    dc.b $c1 // A
                    dc.b $ce // N
                    dc.b $c4 // D
                    dc.b $be // >
                    dc.b $00 // EndOfText
                    
.BoEdWaitCmd        jsr GetCheckKey                 // ac=value
                    
.FindEditCmd        ldy TabBoardEdCmdChr,x
                    beq GoBeepWaitCmd
                    
                    cmp TabBoardEdCmdChr,x
                    beq .CallEdCmdHandler
                    
                    inx
                    bne .FindEditCmd
                    
GoBeepWaitCmd       jsr Beep
                    jmp BoEdWaitCmd
                    
.CallEdCmdHandler   txa
                    asl a
                    tax
                    lda TabBoardEdCmdSub+1,x
                    pha
                    lda TabBoardEdCmdSub,x
                    pha
                    
BoEdWaitCmdX        rts                             // call edit command routines
// ------------------------------------------------------------------------------------------------------------- //
BED_SwapLevels      subroutine
                    jsr TextOut                     // .hbu011. - <swap level>
                    dc.b $8d // <new line>
                    dc.b $be // >
                    dc.b $be // >
                    dc.b $d3 // S
                    dc.b $d7 // W
                    dc.b $c1 // A
                    dc.b $d0 // P
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $cc // L
                    dc.b $00 // EndOfText
                    
.GetSourceNo        jsr DisplayGetLvlNo             // get level number
                    bcs .Beep                       // bad
                    
.SavSourceNo        sty LR_MoveLvlNoFrom            // save source level number
                    
                    jsr TextOut                     // <with level>
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $d7 // W
                    dc.b $c9 // I
                    dc.b $d4 // T
                    dc.b $c8 // H
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $cc // L
                    dc.b $00 // EndOfText
                    
.GetTargetNo        jsr DisplayGetLvlNo             // get level number
                    bcs .Beep                       // bad
                    
.ChkBothNumbers     cpy LR_MoveLvlNoFrom            // saved source level number
                    beq .Beep                       // equal - error
                    
.SavTargetNo        sty LR_MoveLvlNoTo              // save target level number
                    jmp .CheckDisk
                    
.Beep               jmp GoBeepWaitCmd
                    
.CheckDisk          jsr CheckLRDisk                 // check disk
                    
.SetTargetRead      lda LR_MoveLvlNoTo              // saved target level number
                    sta LR_LevelNoDisk              // to disk level number
                    
                    lda #>LR_WorkBuffer
.SetTargetBuffer    sta Mod_GetDiskByte             // set buffer pointer to store target level data
                    
                    lda #LR_DiskRead
.ReadTarget         jsr ControlDiskOper             // read target level data from disk
                    
                    lda #>LR_LvlDataSavLod
.RstTargetBuffer    sta Mod_GetDiskByte             // reset buffer pointer
                    
.SetSourceRead      lda LR_MoveLvlNoFrom            // saved source level number
                    sta LR_LevelNoDisk              // to disk level number
                    
                    lda #LR_DiskRead
.ReadSource         jsr ControlDiskOper             // read source level data from disk
                    
.SetTargetWrite     lda LR_MoveLvlNoTo              // saved target level number
                    sta LR_LevelNoDisk
                    
                    lda #LR_DiskWrite
.WriteTarget        jsr ControlDiskOper             // disk write source level data to target level data
                    
.SetSourceWrite     ldy LR_MoveLvlNoFrom            // saved source level number
                    sty LR_LevelNoDisk
                    dey
                    sty LR_LvlReload                // <> LR_LevelNoDisk forces a level reload
                    
                    lda #>LR_WorkBuffer
.SetSourceBuffer    sta Mod_PutDiskByte             // set buffer pointer to store target level data
                    
                    lda #LR_DiskWrite
.WriteSource        jsr ControlDiskOper             // disk write target level data to source level data
                    
                    lda #>LR_LvlDataSavLod
.RstSourceBuffer    sta Mod_PutDiskByte             // reset buffer pointer
                    
BED_SwapLevelsX     jmp BoEdWaitCmd                 // wait for next command
// ------------------------------------------------------------------------------------------------------------- //
BED_ShowScore       subroutine
                    jsr ShowHighScoreClr            // .hbu011.
                    jsr TextOut                     // <hit a key to continue>
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $c8 // H
                    dc.b $c9 // I
                    dc.b $d4 // T
                    dc.b $a0 //  <blank> 
                    dc.b $c1 // A
                    dc.b $a0 // <blank>
                    dc.b $cb // K
                    dc.b $c5 // E
                    dc.b $d9 // Y
                    dc.b $a0 // <blank>
                    dc.b $d4 // T
                    dc.b $cf // O
                    dc.b $a0 // <blank>
                    dc.b $c3 // C
                    dc.b $cf // O
                    dc.b $ce // N
                    dc.b $d4 // T
                    dc.b $c9 // I
                    dc.b $ce // N
                    dc.b $d5 // U
                    dc.b $c5 // E
                    dc.b $00 // EndOfText
                    
.WaitForKey         jsr ChkUserAction               // wait
                    bcc .WaitForKey                 // and wait
                    
BED_ShowScoreX      jmp BoardEditor
// ------------------------------------------------------------------------------------------------------------- //
BED_PlayLevel       subroutine
                    jsr TextOut                     // <play level>
                    dc.b $8d // <new line>
                    dc.b $be // >
                    dc.b $be // >
                    dc.b $d0 // P
                    dc.b $cc // L
                    dc.b $c1 // A
                    dc.b $d9 // Y
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $cc // L
                    dc.b $00 // EndOfText
                    
.EdPlayLevel        jsr DisplayGetLvlNo
                    bcs BED_PlayLevelX
                    
                    lda #$00
Mod_CtrlerTyp       equ *-1
                    sta LR_ControllerTyp            // controler type  $ca=joystick  $cb=keyboard
                    
                    lda #LR_GamePlay
                    sta LR_GameCtrl                 // $00=start $01=demo $02=game $03=play_level $05=edit
                    
                    lda #LR_CheatedNo
                    sta LR_Cheated                  // $01=not cheated
                    
                    lda #$00
                    sta LR_SprtPosCtrl              // $00 - set sprites
                    
                    lda LR_LevelNoDisk              // 000-149
                    beq .GoGameStart                // no cheating if level=$00
                    
                    lsr LR_Cheated                  // $00=cheated
                    
.GoGameStart        jmp GameStart                   // play selected level
                    
BED_PlayLevelX      jmp GoBeepWaitCmd
// ------------------------------------------------------------------------------------------------------------- //
BED_ClearLevel      subroutine
                    jsr TextOut                     // <clear level>
                    dc.b $8d // <new line>
                    dc.b $be // >
                    dc.b $be // >
                    dc.b $c3 // C
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $c1 // A
                    dc.b $d2 // R
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $cc // L
                    dc.b $00 // EndOfText
                    
.EdClearLevel       jsr DisplayGetLvlNo
                    bcs BED_ClearLevelX
                    
                    jsr CheckLRDisk
                    
                    ldy #$00
                    tya
.Clear              sta LR_LvlDataSavLod,y          // clear level store
                    iny
                    bne .Clear
                    
                    lda #LR_DiskWrite
                    jsr ControlDiskOper
                    
                    jmp BoEdWaitCmd
BED_ClearLevelX     jmp GoBeepWaitCmd
// ------------------------------------------------------------------------------------------------------------- //
BED_Edit            subroutine
                    jsr TextOut                     // <edit level>
                    dc.b $8d // <new line>
                    dc.b $be // >
                    dc.b $be // >
                    dc.b $c5 // E
                    dc.b $c4 // D
                    dc.b $c9 // I
                    dc.b $d4 // T
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $cc // L
                    dc.b $00 // EndOfText
                    
.EdLevel            jsr DisplayGetLvlNo
                    bcs BED_EditX
                    
.GoEdit             jmp LevelEditor
                    
BED_EditX           jmp GoBeepWaitCmd
// ------------------------------------------------------------------------------------------------------------- //
BED_MoveLevel       subroutine
                    jsr TextOut                     // <move level>
                    dc.b $8d // <new line>
                    dc.b $be // >
                    dc.b $be // >
                    dc.b $cd // M
                    dc.b $cf // O
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $cc // L
                    dc.b $00 // EndOfText
                    
.EdMoveLevelFrom    jsr DisplayGetLvlNo
                    bcs BED_MoveLevelX              // greater 150
                    
                    sty LR_MoveLvlNoFrom
                    jsr TextOut                     // <to level>
                    dc.b $a0 // <blank>
                    dc.b $d4 // T
                    dc.b $cf // O
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $cc // L
                    dc.b $00 // EndOfText
                    
.EdMoveLevelTo      jsr DisplayGetLvlNo
                    bcs BED_MoveLevelX              // greater 150
                    
                    sty LR_MoveLvlNoTo
                    jsr TextOut                     // <source diskette>
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $d3 // S
                    dc.b $cf // O
                    dc.b $d5 // U
                    dc.b $d2 // R
                    dc.b $c3 // C
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $c4 // D
                    dc.b $c9 // I
                    dc.b $d3 // S
                    dc.b $cb // K
                    dc.b $c5 // E
                    dc.b $d4 // T
                    dc.b $d4 // T
                    dc.b $c5 // E
                    dc.b $00 // EndOfText
                    
.EdMoveLevelR       jsr GetCheckKey                 // read level
                    jsr CheckLRDisk
                    
                    lda LR_MoveLvlNoFrom
                    sta LR_LevelNoDisk              // 000-149
                    
                    lda #LR_DiskRead
                    jsr ControlDiskOper
                    
                    jsr TextOut                     // <destination diskette>
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $c4 // D
                    dc.b $c5 // E
                    dc.b $d3 // S
                    dc.b $d4 // T
                    dc.b $c9 // I
                    dc.b $ce // N
                    dc.b $c1 // A
                    dc.b $d4 // T
                    dc.b $c9 // I
                    dc.b $cf // O
                    dc.b $ce // N
                    dc.b $a0 // <blank>
                    dc.b $c4 // D
                    dc.b $c9 // I
                    dc.b $d3 // S
                    dc.b $cb // K
                    dc.b $c5 // E
                    dc.b $d4 // T
                    dc.b $d4 // T
                    dc.b $c5 // E
                    dc.b $00 // EndOfText
                    
.EdMoveLevelW       jsr GetCheckKey                 // write level
                    jsr CheckLRDisk
                    
                    lda LR_MoveLvlNoTo
                    sta LR_LevelNoDisk              // 000-149
                    
                    lda #LR_DiskWrite
                    jsr ControlDiskOper
                    
.GoEDWaitCmd        jmp BoEdWaitCmd
                    
BED_MoveLevelX      jmp GoBeepWaitCmd
// ------------------------------------------------------------------------------------------------------------- //
BED_InitDisk        subroutine
                    jsr TextOut                     // <initialze>
                    dc.b $8d // <new line>
                    dc.b $be // >
                    dc.b $be // >
                    dc.b $c9 // I
                    dc.b $ce // N
                    dc.b $c9 // I
                    dc.b $d4 // T
                    dc.b $c9 // I
                    dc.b $c1 // A
                    dc.b $cc // L
                    dc.b $c9 // I
                    dc.b $da // Z
                    dc.b $c5 // E
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $d4 // T
                    dc.b $c8 // H
                    dc.b $c9 // I
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $d0 // P
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $d0 // P
                    dc.b $c1 // A
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $ce // N
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $cc // L
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $c1 // A
                    dc.b $c4 // D
                    dc.b $d9 // Y
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $c6 // F
                    dc.b $cf // O
                    dc.b $d2 // R
                    dc.b $cd // M
                    dc.b $c1 // A
                    dc.b $d4 // T
                    dc.b $d4 // T
                    dc.b $c5 // E
                    dc.b $c4 // D
                    dc.b $a0 // <blank>
                    dc.b $c4 // D
                    dc.b $c9 // I
                    dc.b $d3 // S
                    dc.b $cb // K
                    dc.b $a0 // <blank>
                    dc.b $c6 // F
                    dc.b $cf // O
                    dc.b $d2 // R
                    dc.b $a0 // <blank>
                    dc.b $d5 // U
                    dc.b $d3 // S
                    dc.b $c5 // E
                    dc.b $d2 // R
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $c3 // C
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $c1 // A
                    dc.b $d4 // T
                    dc.b $c5 // E
                    dc.b $c4 // D
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $cc // L
                    dc.b $d3 // S
                    dc.b $ae // .
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a8 // (
                    dc.b $d7 // W
                    dc.b $c9 // I
                    dc.b $cc // L
                    dc.b $cc // L
                    dc.b $a0 // <blank>
                    dc.b $c4 // D
                    dc.b $c5 // E
                    dc.b $d3 // S
                    dc.b $d4 // T
                    dc.b $d2 // R
                    dc.b $cf // O
                    dc.b $d9 // Y
                    dc.b $a0 // <blank>
                    dc.b $cf // O
                    dc.b $cc // L
                    dc.b $c4 // D
                    dc.b $a0 // <blank>
                    dc.b $c4 // D
                    dc.b $c1 // A
                    dc.b $d4 // T
                    dc.b $c1 // A
                    dc.b $a9 // )
                    dc.b $ae // .
                    dc.b $8d // <new line>
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $d9 // Y
                    dc.b $cf // O
                    dc.b $d5 // U
                    dc.b $a0 // <blank>
                    dc.b $d3 // S
                    dc.b $d5 // U
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $a8 // (
                    dc.b $d9 // Y
                    dc.b $af // /
                    dc.b $ce // N
                    dc.b $a9 // )
                    dc.b $a0 // <blank>
                    dc.b $00 // EndOfText
                    
.EdInitDisk         jsr GetCheckKey
                    cmp #$19                        // y(es)
                    bne BED_InitDiskX
                    
                    lda #LR_DiskRead
                    jsr GetPutHiScores              // Target: $1100-$11ff
                    
                    cmp #LR_DiskMaster              // lr master disk
                    bne .GetDiskLvlNo               // no
                    
                    jsr MsgMasterDisk
                    jmp GoClearScrnDisp             // clear hires display screen
                    
.GetDiskLvlNo       lda LR_LevelNoDisk              // 000-149
                    pha
                    lda #LR_DiskInit
                    jsr ControlDiskOper
                    
                    pla
                    sta LR_LevelNoDisk              // 000-149
BED_InitDiskX       jmp BoEdWaitCmd
// ------------------------------------------------------------------------------------------------------------- //
BED_ClearScore      subroutine
                    jsr TextOut                     // <clear score>
                    dc.b $8d // <new line>
                    dc.b $be // >
                    dc.b $be // >
                    dc.b $c3 // C
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $c1 // A
                    dc.b $d2 // R
                    dc.b $a0 // <blank>
                    dc.b $d3 // S
                    dc.b $c3 // C
                    dc.b $cf // O
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $c6 // F
                    dc.b $c9 // I
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $d4 // T
                    dc.b $c8 // H
                    dc.b $c9 // I
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $c3 // C
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $c1 // A
                    dc.b $d2 // R
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $d4 // T
                    dc.b $c8 // H
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $c8 // H
                    dc.b $c9 // I
                    dc.b $c7 // G
                    dc.b $c8 // H
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $d3 // S
                    dc.b $c3 // C
                    dc.b $cf // O
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $c6 // F
                    dc.b $c9 // I
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $cf // O
                    dc.b $c6 // F
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $cc // L
                    dc.b $cc // L
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $c5 // E
                    dc.b $ce // N
                    dc.b $d4 // T
                    dc.b $d2 // R
                    dc.b $c9 // I
                    dc.b $c5 // E
                    dc.b $d3 // S
                    dc.b $ae // .
                    dc.b $8d // <new line>
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $d9 // Y
                    dc.b $cf // O
                    dc.b $d5 // U
                    dc.b $a0 // <blank>
                    dc.b $d3 // S
                    dc.b $d5 // U
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $a8 // (
                    dc.b $d9 // Y
                    dc.b $af // /
                    dc.b $ce // N
                    dc.b $a9 // )
                    dc.b $a0 // <blank>
                    dc.b $00 // EndOfText
                    
.EdClearScore       jsr GetCheckKey
                    cmp #$19                        // y(es)
                    bne BED_ClearScoreX
                    
                    lda #LR_DiskRead
                    jsr GetPutHiScores              // Target: $1100-$11ff
                    
                    cmp #LR_DiskNoData              // no lode runner data disk
                    beq .GoMsgNoLRDisk
                    
                    lda #$00
                    ldy #LR_HiScoreLen              // $7f=length high scores
.ClearScores        sta LR_HiScore,y
                    dey
                    bpl .ClearScores
                    
                    ldy #CR_BestMsgLen + CR_BestScrLen  // .hbu020.
.ClearMsg           sta CR_BestMsg,y                // .hbu020.
                    dey                             // .hbu020.
                    bpl .ClearMsg                   // .hbu020.
                    
                    lda #LR_DiskWrite
                    jsr GetPutHiScores              // Target: $1100-$11ff
.EdClearScoreX      jmp BoEdWaitCmd
                    
.GoMsgNoLRDisk      jsr MsgNoLRDisk
                    
BED_ClearScoreX     jmp BoEdWaitCmd
// ------------------------------------------------------------------------------------------------------------- //
// LevelEditor       Function: Edit level data (sic!)
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
LevelEditor         subroutine
                    ldx #LR_BEDLvlModNo             // .hbu023. - level data not modified
                    stx LRZ_EditStatus              // .hbu023. - edit status - $00=modified
                    
                    jsr ClearHiresDisp              // 
                    jsr CheckLRDisk                 // 
.SetCurTopLeft      jsr LvlEdCurPosInit             // .hbu023. - set cursor to top left screen pos
                    
LevelEditorTst      lda #HR_LtBlueLtRed             // .hbu001.hbu023. - entry from Edit-Test to preserve mofify flag in LRZ_EditStatus
                    ldx #HR_CyanRed                 // .hbu001.
                    ldy #WHITE                      // .hbu001.
                    jsr ColorLevelFix               // .hbu001.
                    
                    lda #>LR_ScrnHiReDisp           // .hbu001. - $20
                    sta LRZ_GfxScreenOut            // .hbu001. - target output  $20=$2000 $40=$40000
                    jsr BaseLines                   // .hbu001. - display baselines before level data                  
                    
                    lda #>LR_ScrnHiRePrep           // .hbu001. - $40
                    sta LRZ_GfxScreenOut            // target output  $20=$2000 $40=$40000
                    jsr BaseLines
                    
                    ldx #LR_LevelPrep               // .hbu000.
                    jsr InitLevel                   // 
                    bcc .GetOldCurPos               // .hbu009. - good so care for level msg
                    
.BadLevel           jmp GoBeepWaitCmd               // bad - beep - get next command
                    
.GetOldCurPos       jsr LvlEdCurPosLoad             // .hbu023. - restore old cursor position
.InitMsg            jsr VictoryMsg                  // .hbu009. - output the level msg text or a default msg text
                    
LevelEdInputLoop    jsr SetEditDataPtr              // global return point - set edit level data pointer ($0800-$09c3)
.GetInput           jsr WaitKeyBlink                // wait for input key and blink cursor
                    
.ChkDigit           jsr GetDigSubst                 // check for a digit and substitute to $00-$09
                    bcs .SetCommand                 // .hbu024. - no digit - check for command/joystick move
                    
.SetDigit           sta LRZ_EditTile                // level input tile $00-$09
                    
                    ldy LRZ_ScreenRow               // screen row  (00-0f)
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi
                    ldy LRZ_ScreenCol               // screen col  (00-1b)
                    
.ChkNewTile         lda LRZ_EditTile                // level input tile $00-$09
                    eor (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    beq .GetTile                    // same as input data so do not set modify flag
                    
.SetMofified        lsr LRZ_EditStatus              // edit status  $00=modified
                    
.GetTile            lda LRZ_EditTile                // level input tile $00-$09
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    jsr ImageOut2Disp               // direct output to display screen
.GetNextInput       jmp LevelEdInputLoop            // 
                    
.SetCommand         sta LRZ_EditTile                // .hbu024. - keyboard/joystick value
                    ldy LR_TypeUI                   // .hbu024. - flag key or joystick interaction
                    bne .WaitJoyI                   // .hbu024.
                    
.ChkCommand         lda TabLevelEdCmdChr,y          // 
                    beq .BeepBadInput               // $00 - end of command table reached
                    
                    cmp LRZ_EditCmd                 // .hbu024. - check for a command
                    beq .Dispatch                   // .hbu024. - found one
                    
                    iny                             // .hbu024.
                    bne .ChkCommand                 // .hbu024. - test next command
                    
.WaitJoyI           ldy #$03                        // .hbu024. - set debounce delay
                    sty LR_JoyWait                  // .hbu024.
.WaitJoy            ldy LR_JoyWait                  // .hbu024. - wait debounce time
                    bne .WaitJoy                    // .hbu024.
                    
.GetJoyMoves        lda LR_JoyNew                   // .hbu024.
.ChkJoyMoves        ror a                           // .hbu024. - up
                    bcs .Dispatch                   // .hbu024.
                    
                    iny                             // .hbu024. - LED_CurDo
                    ror a                           // .hbu024. - down
                    bcs .Dispatch                   // .hbu024.
                    
                    iny                             // .hbu024. - LED_CurLe
                    ror a                           // .hbu024. - left
                    bcs .Dispatch                   // .hbu024.
                    
                    iny                             // .hbu024. - LED_CurRi
                    ror a                           // .hbu024. - right
                    bcs .Dispatch                   // .hbu024.
                    
.BeepBadInput       jsr Beep                        // .hbu024. - no valid input found - no beeps for joy checks
.GoGetNextInput     jmp LevelEdInputLoop            // .hbu024. - so get next input
                    
.Dispatch           tya
                    asl a                           // *2
                    tay
                    lda TabLevelEdCmdSub+1,y        // high byte command routine
                    pha
                    lda TabLevelEdCmdSub,y          // low  byte command routine
                    pha
                    
LevelEditorX        rts                             // dispatch command routine
// ------------------------------------------------------------------------------------------------------------- //
LED_TestLvl         subroutine
                    lsr LR_Cheated                  // .hbu023. - $00=cheated
                    
                    lda #>LR_ScrnHiReDisp           // .hbu023. - $20
                    sta LRZ_GfxScreenOut            // .hbu023. - target output  $20=$2000 $40=$4000
                    
                    lda #LR_GamePlay                // .hbu023.
                    sta LR_GameCtrl                 // .hbu023. - $00=start $01=demo $02=game $03=play_level $05=edit
                    
                    lda Mod_CtrlerTyp               // .hbu023. - restore 
                    sta LR_ControllerTyp            // .hbu023. - controler type  $ca=joystick  $cb=keyboard
                    
                    lda #LR_KeyNewNone              // .hbu023.
                    sta LR_KeyNew                   // .hbu023.
                    sta LR_ScoreShown               // .hbu023.
                    sta LR_SprtPosCtrl              // .hbu023. - $00 - set sprites
                    
                    lda LR_LevelNoDisk              // .hbu023.
                    sta LR_LvlReload                // .hbu023.
                    
                    lda #LR_TestLevelOn             // .hbu023.
                    sta LR_TestLevel                // .hbu023. - set test level mode
                    
                    jsr LvlEdCurPosSave             // .hbu023. - save actual cursor position
                    jsr PackLevel                   // .hbu023.
                    
                    lda #$00                        // .hbu023.
                    sta LR_CntSpeedLaps             // .hbu023.
                    sta LR_EnmyBirthCol             // .hbu023. - reset birth col pointer
                    
LED_TestLvlX        jmp LevelStart                  // .hbu023. - play edited level
// ------------------------------------------------------------------------------------------------------------- //
LED_MirrorLvl       subroutine
                    jsr ToggleMirror                // 
                    
LED_MirrorLvlX      jmp LevelEditor                 // 
// ------------------------------------------------------------------------------------------------------------- //
LED_CurUp           subroutine
                    lda LRZ_ScreenRow               // screen row  (00-0f) - i=cursor up
                    cmp #LR_ScrnMinRows             // .hbu009.
                    bne .Up                         // .hbu009.
                    
                    lda #LR_ScrnMaxRows             // .hbu009. - $00=max up reached
                    sta LRZ_ScreenRow               // .hbu009.
                    jmp LevelEdInputLoop            // .hbu009.
                    
.Up                 dec LRZ_ScreenRow               // screen row  (00-0f)
LED_CurUpX          jmp LevelEdInputLoop
// ------------------------------------------------------------------------------------------------------------- //
LED_CurLe           subroutine
                    lda LRZ_ScreenCol               // screen col  (00-1b) - j=cursor left
                    cmp #LR_ScrnMinCols             // .hbu009.
                    bne .Left                       // .hbu009.
                    
                    lda #LR_ScrnMaxCols             // .hbu009. - $00=max left reached
                    sta LRZ_ScreenCol               // .hbu009.
                    jmp LevelEdInputLoop            // .hbu009.
                    
.Left               dec LRZ_ScreenCol               // screen col  (00-1b)
LED_CurLeX          jmp LevelEdInputLoop
// ------------------------------------------------------------------------------------------------------------- //
LED_CurRi           subroutine
                    lda LRZ_ScreenCol               // screen col  (00-1b) - k=cursor right
                    cmp #LR_ScrnMaxCols             // .hbu009.
                    bne .Right                      // .hbu009.
                    
                    lda #LR_ScrnMinCols             // .hbu009. - $1b - max 27 cols reached
                    sta LRZ_ScreenCol               // .hbu009.
                    jmp LevelEdInputLoop            // .hbu009.
                    
.Right              inc LRZ_ScreenCol               // screen col  (00-1b)
LED_CurRiX          jmp LevelEdInputLoop
// ------------------------------------------------------------------------------------------------------------- //
LED_CurDo           subroutine
                    lda LRZ_ScreenRow               // screen row  (00-0f) - m=cursor down
                    cmp #LR_ScrnMaxRows             // .hbu009.
                    bne .Down                       // .hbu009.
                    
                    lda #LR_ScrnMinRows             // .hbu009. - $0f - max 15 rows reached
                    sta LRZ_ScreenRow               // .hbu009.
                    jmp LevelEdInputLoop            // .hbu009.
                    
.Down               inc LRZ_ScreenRow               // screen row  (00-0f)
LED_CurDoX          jmp LevelEdInputLoop
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
LvlEdChkSave        subroutine
                    lda #LR_DiskRead
                    jsr GetPutHiScores              // Target: $1100-$11ff
                    
.ChkData            cmp #LR_DiskNoData              // no lode runner data disk
                    bne .ChkMaster                  // 
                    
                    jsr MsgNoLRDisk                 // 
                    jsr LvlEdCurPosInit             // set cursor to top left screen corner
                    jmp LevelEdInputLoop            // 
                    
.ChkMaster          cmp #LR_DiskMaster              // master disk
                    bne .GoPackLevel
                    
                    jsr MsgMasterDisk
                    jsr LvlEdCurPosInit             // set cursor to top left screen corner
                    jmp LevelEdInputLoop
                    
.GoPackLevel        jsr PackLevel
                    
.SaveLevel          lda #LR_DiskWrite
                    jsr ControlDiskOper             // write and exit
                    
.CurPosLoad         jsr LvlEdCurPosLoad             // restore old cursor position
                    
                    lda #LR_BEDLvlModNo             // level data not modified
                    sta LRZ_EditStatus              // edit status
                    
LvlEdChkSaveX       rts
// ------------------------------------------------------------------------------------------------------------- //
LED_SaveLvl         subroutine
                    jsr LvlEdChAsk                  // S=save level
                    jsr VictoryMsg                  // redisplay a possible level message or clear
                    
LED_SaveLvlX        jmp LevelEdInputLoop
// ------------------------------------------------------------------------------------------------------------- //
LED_SameLvl         subroutine
                    jsr LvlEdChkChFlag              // .hbu009.
                    
                    inc LR_LvlReload                // .hbu009. - force level reload if <> LR_LevelNoDisk
                    
LED_SameLvlX        jmp LevelEditor                 // .hbu009.
// ------------------------------------------------------------------------------------------------------------- //
LED_NextLvl         subroutine
                    jsr LvlEdChkChFlag              // .hbu009.
.GoIncLevelNo       jsr IncGameLevelNo              // increase level number
                    
LED_NextLvlX        jmp LevelEditor
// ------------------------------------------------------------------------------------------------------------- //
LED_PrevLvl         subroutine
                    jsr LvlEdChkChFlag              // .hbu009.
.GoIncLevelNo       jsr DecGameLevelNo              // decrease level number
                    
LED_PrevLvlX        jmp LevelEditor
// ------------------------------------------------------------------------------------------------------------- //
LED_XmitLvl         subroutine                      // .hbu017. - transmit the active level a slot on drive 9
                    lda LR_ExpertMode               // .hbu017. - expert mode set after <run/stop>, <f7>, <run/stop>
                    bpl LED_XmitLvlX                // .hbu017. - off
                    
                    jsr LvlEdCurPosSave             // .hbu017. - save actual cursr pos
                    jsr Xmit                        // .hbu017. 
                    jsr LvlEdCurPosLoad             // .hbu017. - restore old cursor position
                    
LED_XmitLvlX        jmp LevelEdInputLoop            // .hbu017.
// ------------------------------------------------------------------------------------------------------------- //
LED_Quit            subroutine
                    jsr LvlEdChkChFlag              // .hbu023. - ask if level had changes
                    bcc LED_QuitX                   // .hbu023. - ok so leave
                    
.AbortQuit          jsr VictoryMsg                  // .hbu023. - abort so stay and redisplay a possible level message/clear
                    jmp LevelEdInputLoop            // .hbu023. - do not quit/keep change flag
                    
LED_QuitX           jmp GoClearScrnDisp             // clear hires display screen
// ------------------------------------------------------------------------------------------------------------- //
LED_MsgTxtLvl       subroutine
                    jsr LvlEdCurPosSave             // save actual cursr pos
                    
.SetCursor          jsr LvlEdCurSetMsg              // set cursor to input position
                    
.ColorMsg           lda #HR_YellowYellow            // .hbu001.
                    sta Mod_ColorMsg                // .hbu001. - only yellow messages in edit mode 
                    jsr ColorMsg                    // .hbu001.
                    
.StGfxScreen        lda #>LR_ScrnHiReDisp           // $20
                    sta LRZ_GfxScreenOut            // target output  $20=$2000 $40=$4000
                    
.SetBufferLen       ldy #LR_LevelMsgLen+1           // message buffer max length
                    clc                             // do not clear buffer - filled with LevelEditor/VictoryMsg
                    jsr InputControl                // get a message text
                    
.CurPosLoad         jsr LvlEdCurPosLoad             // restore old cursor position
                    
                    ldy #LR_LevelMsgLen
.GetMsg             lda CR_InputBuf,y               // copy the message text
                    sta LR_LevelMsg,y               // to the level message store
                    dey
                    bpl .GetMsg
                    
                    ldy #LR_LevelMsgIDLen
.CopyID             lda TabMsgID,y                  // copy the message id
                    sta LR_LevelMsgID,y             // behind the message text
                    dey
                    bpl .CopyID
                    
LED_MsgTxtLvlX      jmp LevelEdInputLoop
// ------------------------------------------------------------------------------------------------------------- //
LvlEdChkChFlag      subroutine
                    lda LRZ_EditStatus              // edit status  $00=modified
                    beq LvlEdChAsk
                    
LvlEdChkChFlagX     rts
// ------------------------------------------------------------------------------------------------------------- //
// LvlEdChAsk        Function: Ask to save level data
//                   Parms   :
//                   Returns :
//                   ID      : .hbu022.
// ------------------------------------------------------------------------------------------------------------- //
LvlEdChAsk          subroutine
                    jsr ClearMsg                    // 
                    
.InfoSetOutput      lda #>LR_ScrnHiReDisp           // 
                    sta LRZ_GfxScreenOut            // output to display screen only
                    
.CurPosSave         jsr LvlEdCurPosSave             // save actual cursr pos
                    
.InfoSetDisplay     jsr LvlEdCurSetMsg              // prepare display
                    jsr TextOut                     // <save data>
                    dc.b $d3 // S                    // 
                    dc.b $c1 // A                    // 
                    dc.b $d6 // V                    // 
                    dc.b $c5 // E                    // 
                    dc.b $a0 // <blank>              // 
                    dc.b $c4 // D                    // 
                    dc.b $c1 // A                    // 
                    dc.b $d4 // T                    // 
                    dc.b $c1 // A                    // 
                    dc.b $a0 // <blank>              // 
                    dc.b $a0 // <blank>              // 
                    dc.b $a0 // <blank>              // 
                    dc.b $d9 // Y                    // 
                    dc.b $af // /                    // 
                    dc.b $ce // N                    // 
                    dc.b $00 // EndOfText            // 
                    
.InfoColorSet       lda #HR_LtGreenLtGreen          // attention message color
                    sta Mod_ColorMsg                // 
                    jsr ColorMsg                    // 
                    
                    dec LRZ_ScreenCol               // 
                    
.WaitBlink          jsr Beep                        // 
                    
                    lda #$ce                        // "N" for blink
                    jsr GetChrSubst                 // map to character image data numbers
                    jsr WaitKeyBlink                // wait for input key and blink cursor
                    
.Clear              ldy #LR_KeyNewNone
                    sty LR_KeyNew                   // reset actual key value
                    
.ChkKey_RS          cmp #$3f                        // <run/stop>
                    bne .ChkKey_N
                    
.ExitRS             jsr LvlEdCurPosLoad             // restore old cursor position
                    sec                             // flag: abort
                    rts
                    
.ChkKey_N           cmp #$27                        // "n"
                    beq .ExitYN                     //
                    
.ChkKey_Y           cmp #$19                        // "y"
                    bne .WaitBlink                  // 
                    
                    jsr LvlEdChkSave                // check and save
                    
.ExitYN             jsr LvlEdCurPosLoad             // restore old cursor position
                    clc                             // flag: normal exit
LvlEdChAskX         rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
CheckLRDisk         subroutine
                    lda #LR_DiskRead
                    jsr GetPutHiScores              // Target: $1100-$11ff
                    
.ChkData            cmp #LR_DiskNoData
                    bne .ChkMaster
                    
                    jsr MsgNoLRDisk                 // no lode runner data disk
                    jmp GoClearScrnDisp             // clear hires display screen
                    
.ChkMaster          cmp #LR_DiskMaster
                    bne CheckLRDiskX
                    
                    jsr MsgMasterDisk               // master disk
                    jmp GoClearScrnDisp             // clear hires display screen
                    
CheckLRDiskX        rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MsgMasterDisk       subroutine
                    jsr ClearHiresDisp
                    
                    lda Mod_ColorLevelF             // save old colors
                    pha
                    
                    lda #>LR_ScrnHiReDisp           // $20
                    sta LRZ_GfxScreenOut            // target output  $20=$2000 $40=$4000
                    
                    lda #HR_YellowCyan
                    tax                             // .hbu001.
                    ldy #WHITE                      // .hbu001.
                    jsr ColorLevelFix               // .hbu001.
                    
                    jsr LvlEdCurPosInit             // set cursor to top left screen pos
                    jsr TextOut                     // <user not allowed>
                    dc.b $d5 // U
                    dc.b $d3 // S
                    dc.b $c5 // E
                    dc.b $d2 // R
                    dc.b $a0 // <blank>
                    dc.b $ce // N
                    dc.b $cf // O
                    dc.b $d4 // T
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $cc // L
                    dc.b $cc // L
                    dc.b $cf // O
                    dc.b $d7 // W
                    dc.b $c5 // E
                    dc.b $c4 // D
                    dc.b $a0 // <blank>
                    dc.b $d4 // T
                    dc.b $cf // O
                    dc.b $8d // <new line>
                    dc.b $cd // M
                    dc.b $c1 // A
                    dc.b $ce // N
                    dc.b $c9 // I
                    dc.b $d0 // P
                    dc.b $d5 // U
                    dc.b $cc // L
                    dc.b $c1 // A
                    dc.b $d4 // T
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $cd // M
                    dc.b $c1 // A
                    dc.b $d3 // S
                    dc.b $d4 // T
                    dc.b $c5 // E
                    dc.b $d2 // R
                    dc.b $a0 // <blank>
                    dc.b $c4 // D
                    dc.b $c9 // I
                    dc.b $d3 // S
                    dc.b $cb // K
                    dc.b $c5 // E
                    dc.b $d4 // T
                    dc.b $d4 // T
                    dc.b $c5 // E
                    dc.b $ae // .
MsgMasterDiskX      dc.b $00 // EndOfText
// ------------------------------------------------------------------------------------------------------------- //
MsgKey2Cont         subroutine
                    jsr TextOut                     // <hit a key to continue>
                    dc.b $8d // <new line>
                    dc.b $8d // <new line>
                    dc.b $c8 // H
                    dc.b $c9 // I
                    dc.b $d4 // T
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $a0 // <blank>
                    dc.b $cb // K
                    dc.b $c5 // E
                    dc.b $d9 // Y
                    dc.b $a0 // <blank>
                    dc.b $d4 // T
                    dc.b $cf // O
                    dc.b $a0 // <blank>
                    dc.b $c3 // C
                    dc.b $cf // O
                    dc.b $ce // N
                    dc.b $d4 // T
                    dc.b $c9 // I
                    dc.b $ce // N
                    dc.b $d5 // U
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $00 // EndOfText
                    
                    jsr Beep
                    
                    lda #$00                        // blank chr under cursor
                    jsr WaitKeyBlink                // wait for input key and blink cursor
                    
                    lda #LR_KeyNewNone
                    sta LR_KeyNew                   // reset actual key
                    
                    lda #>LR_ScrnHiRePrep           // $40
                    sta LRZ_GfxScreenOut            // target output  $20=$2000 $40=$4000
                    jsr BaseLines
                    
                    lda #LR_LevelPrep
                    sta LR_LevelCtrl                // level display control  $00=prepared copy already at $4000-$5fff
                    
                    pla                             // restore old colors
                    tax                             // .hbu001.
                    ldy #WHITE                      // .hbu001.
                    
MsgKey2ContX        jmp ColorLevelFix               // .hbu001.
// ------------------------------------------------------------------------------------------------------------- //
// MsgNoLRDisk       Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MsgNoLRDisk         subroutine
                    jsr ClearHiresDisp
                    lda Mod_ColorLevelF             // save old colors
                    pha
                    
                    lda #HR_YellowCyan
                    tax                             // .hbu001.
                    ldy #WHITE                      // .hbu001.
                    jsr ColorLevelFix               // .hbu001.
                    
                    lda #>LR_ScrnHiReDisp           // $20
                    sta LRZ_GfxScreenOut            // target output  $20=$2000 $40=$4000
                    
                    jsr LvlEdCurPosInit             // set cursor to top left screen pos
                    jsr TextOut                     // <not a lode runner data disk>
                    dc.b $c4 // D
                    dc.b $c9 // I
                    dc.b $d3 // S
                    dc.b $cb // K
                    dc.b $c5 // E
                    dc.b $d4 // T
                    dc.b $d4 // T
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $c9 // I
                    dc.b $ce // N
                    dc.b $a0 // <blank>
                    dc.b $c4 // D
                    dc.b $d2 // R
                    dc.b $c9 // I
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $c9 // I
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $ce // N
                    dc.b $cf // O
                    dc.b $d4 // T
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $8d // <new line>
                    dc.b $cc // L
                    dc.b $cf // O
                    dc.b $c4 // D
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $d2 // R
                    dc.b $d5 // U
                    dc.b $ce // N
                    dc.b $ce // N
                    dc.b $c5 // E
                    dc.b $d2 // R
                    dc.b $a0 // <blank>
                    dc.b $c4 // D
                    dc.b $c1 // A
                    dc.b $d4 // T
                    dc.b $c1 // A
                    dc.b $a0 // <blank>
                    dc.b $c4 // D
                    dc.b $c9 // I
                    dc.b $d3 // S
                    dc.b $cb // K
                    dc.b $ae // .
                    dc.b $00 // EndOfText
                    
MsgNoLRDiskX        jmp MsgKey2Cont
// ------------------------------------------------------------------------------------------------------------- //
// SetEditDataPtr    Function: Set pointer ($09/$0a) to expanded level data $0800-$09c3
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
SetEditDataPtr      subroutine
                    ldy LRZ_ScreenRow               // screen row  (00-0f)
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi            //
                    
                    ldy LRZ_ScreenCol               // screen col  (00-1b)
                    lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
SetEditDataPtrX     rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
DisplayGetLvlNo     subroutine
                    ldy LR_LevelNoDisk              // 000-149
                    iny
                    tya
                    jsr ConvertHex2Dec              // 1307=100 1308=10 1309=1
                    
                    lda LRZ_ScreenCol               // screen col  (00-1b)
                    sta LR_WrkScreenCol
                    
                    ldy #$00
.GetGigits          lda LR_Digit100,y               // digit 100/10/1 parts
                    sty LR_WrkCurrentPos            // current input screen pos
                    jsr PrepareDigitOut
                    
                    ldy LR_WrkCurrentPos            // current input screen pos
                    iny
                    cpy #LR_BEDLvlLenMax+1          // max 3
                    bcc .GetGigits                  // not reached
                    
                    lda LR_WrkScreenCol
                    sta LRZ_ScreenCol               // screen col  (00-1b)
                    
                    ldy #$00
                    sty LR_WrkCurrentPos            // current input screen pos
.GetCurrentPos      ldx LR_WrkCurrentPos            // current input screen pos
                    lda LR_Digit100,x
                    clc
                    adc #NoDigitsMin                // .hbu008. - prepare for grafic output
                    jsr WaitKeyBlink                // wait for input key and blink cursor
                    jsr GetDigSubst
                    bcc .LvlNumDigits
                    
.LvlNumNoDigits     cmp #$01                        // RETURN
                    beq .GetScreenCol
                    
                    cmp #$07                        // CURSOR DOWN
                    beq .ChkCurDown
                    
                    cmp #$82                        // SHIFT CURSOR RIGHT
                    bne .ChkCurRight
                    
.ChkCurDown         ldx LR_WrkCurrentPos            // CURSOR DOWN
                    beq .GoBeep
                    
                    dec LR_WrkCurrentPos            // current input screen pos
                    dec LRZ_ScreenCol               // screen col  (00-1b)
                    jmp .GetCurrentPos
                    
.ChkCurRight        cmp #$02                        // CURSOR RIGHT
                    bne .ChkKeyRS
                    
                    ldx LR_WrkCurrentPos            // current input screen pos
                    cpx #LR_BEDLvlLenMax
                    beq .GoBeep
                    
                    inc LRZ_ScreenCol               // screen col  (00-1b)
                    inc LR_WrkCurrentPos            // current input screen pos
                    jmp .GetCurrentPos
                    
.ChkKeyRS           cmp #$3f                        // <run/stop>
                    bne .RSAbort
                    jmp BoEdWaitCmd
                    
.RSAbort            jsr GetDigSubst
                    bcs .GoBeep
                    
.LvlNumDigits       ldy LR_WrkCurrentPos            // current input screen pos
                    sta LR_Digit100,y               // update digit under screen pos
                    jsr PrepareDigitOut
                    
                    inc LR_WrkCurrentPos            // current input screen pos
                    lda LR_WrkCurrentPos            // current input screen pos
                    cmp #LR_BEDLvlLenMax+1          // max right
                    bcc .GetCurrentPos
                    
                    dec LR_WrkCurrentPos            // current input screen pos
                    dec LRZ_ScreenCol               // screen col  (00-1b)
                    jmp .GetCurrentPos
                    
.GoBeep             jsr Beep
                    jmp .GetCurrentPos
                    
.GetScreenCol       lda LR_WrkScreenCol
                    clc
                    adc #LR_BEDLvlLenMax+1          // rightmost digit
                    sta LRZ_ScreenCol               // screen col  (00-1b)
                    
                    jsr Dec2Hex
                    bcs DisplayGetLvlNoX
                    
                    sta LR_LevelNoGame              // 001-150
                    tay
                    dey
                    sty LR_LevelNoDisk              // 000-149
                    
                    cpy #LR_LevelNoMax              // set carry if too large
                    
DisplayGetLvlNoX    rts
// ------------------------------------------------------------------------------------------------------------- //
// LvlEdCurPosInit   Function: Set cursor to top left screen corner
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
LvlEdCurPosInit     subroutine
                    lda #$00                        // top left corner
                    sta LRZ_ScreenCol               // screen col  (00-1b)
                    sta LR_SavePosCol               // 
                    sta LRZ_ScreenRow               // screen row  (00-0f)
                    sta LR_SavePosRow               // 
                    
LvlEdCurPosInitX    rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
// LvlEdCurPosSave   Function: Save the actual cursor position
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
LvlEdCurPosSave     subroutine
                    lda LRZ_ScreenCol               // screen col  (00-1b)
                    sta LR_SavePosCol               // 
                    lda LRZ_ScreenRow               // screen row  (00-0f)
                    sta LR_SavePosRow               // 
                    
LvlEdCurPosSaveX    rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
// LvlEdCurPosLoad   Function: Restore the saved cursor position
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
LvlEdCurPosLoad     subroutine
                    lda LR_SavePosRow               // 
                    sta LRZ_ScreenRow               // screen row  (00-0f)
                    lda LR_SavePosCol                 // 
                    sta LRZ_ScreenCol               // screen col  (00-1b)
                    
LvlEdCurPosLoadX    rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
// LvlEdCurSetMsg    Function: Set cursor to message position
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
LvlEdCurSetMsg      lda #LR_BasLinRowStat           // 
                    sta LRZ_ScreenRow               // screen row  (00-0f)
                    lda #LR_BasLinColMsg            // 
                    sta LRZ_ScreenCol               // screen col  (00-1b)
                    
LvlEdCurSetMsgX     rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
// LvlEdCurSetHero   Function: Set cursor to top scorer position
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
LvlEdCurSetHero     lda #LR_BasLinRowStat           // .hbu018.
                    sta LRZ_ScreenRow               // .hbu018. - screen row  (00-0f)
                    lda #$00                        // .hbu018.
                    sta LRZ_ScreenCol               // .hbu018. - screen col  (00-1b)
                    
LvlEdCurSetHeroX    rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetCheckKey         subroutine
                    lda #$00                        // blank chr under cursor
                    jsr WaitKeyBlink                // wait for input key and blink cursor
                    
                    ldx #LR_KeyNewNone
                    stx LR_KeyNew                   // reset actual key
                    
                    cmp #$3f                        // <run/stop>
                    bne GetCheckKeyX
                    
                    jmp BoEdWaitCmd
                    
GetCheckKeyX        rts
// ------------------------------------------------------------------------------------------------------------- //
// GetDigSubst       Function: Map digit input keys to $00-$09
//                   Parms   : ac=value to compare
//                   Returns : ac=digit substitution + clear carry / set carry if no digit 
// ------------------------------------------------------------------------------------------------------------- //
GetDigSubst         subroutine
                    lda LR_KeyNew                   // get actual key
                    
                    ldy #LR_KeyNewNone
                    sty LR_KeyNew                   // reset actual key
// ------------------------------------------------------------------------------------------------------------- //
GetDigSubstChk      subroutine
                    ldy #$09                        // length digit key tab
.Check              cmp TabKeyDigits,y
                    beq .SetDigit
                    
                    dey
                    bpl .Check
                    
.SetNoDigit         sec                             // was no digit
                    rts
                    
.SetDigit           tya                             // set substitution
                    clc                             // was a digit
GetDigSubstX        rts
// ------------------------------------------------------------------------------------------------------------- //
TabKeyDigits        dc.b $23 // $00 - from KeyMatrix - translated into $00-$09
                    dc.b $38 // $01
                    dc.b $3b // $02
                    dc.b $08 // $03
                    dc.b $0b // $04
                    dc.b $10 // $05
                    dc.b $13 // $06
                    dc.b $18 // $07
                    dc.b $1b // $08
                    dc.b $20 // $09
// ------------------------------------------------------------------------------------------------------------- //
// ChkNewChampion    Function: Check for a new chamipon
//                   Parms   :
//                   Returns :
//                   ID      : .hbu020.
// ------------------------------------------------------------------------------------------------------------- //
ChkNewChampionXX    subroutine
                    clc                             // shortcut
                    rts                             //
                    
ChkNewChampion      lda LR_LevelNoGame              // 001-150
                    cmp #LR_LevelNoMax + 1          // 151
                    bcc ChkNewChampionXX            // lower
                    
                    jsr ClearHiresDisp              // 
                    
                    lda #>LR_ScrnHiReDisp           //
                    sta LRZ_GfxScreenOut            // control gfx screen output - display=$20(00) hidden=$40(00)
                    
                    lda #HR_YellowCyan              //
                    tax                             //
                    ldy #WHITE                      //
                    jsr ColorLevelFix               //
                    
                    jsr LvlEdCurPosInit             // set cursor to top left screen pos
                    jsr TextOut                     // <congratulations>
                    dc.b $8d // <newline>
                    dc.b $8d // <newline>
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $a0 // <blank>
                    dc.b $c3 // C
                    dc.b $cf // O
                    dc.b $ce // N
                    dc.b $c7 // G
                    dc.b $d2 // R
                    dc.b $c1 // A
                    dc.b $d4 // T
                    dc.b $d5 // U
                    dc.b $cc // L
                    dc.b $c1 // A
                    dc.b $d4 // T
                    dc.b $c9 // I
                    dc.b $cf // O
                    dc.b $ce // N
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $8d // <newline>
                    dc.b $8d // <newline>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $d9 // Y
                    dc.b $cf // O
                    dc.b $d5 // U
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $8d // <newline>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $cf // O
                    dc.b $c4 // D
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $d2 // R
                    dc.b $d5 // U
                    dc.b $ce // N
                    dc.b $ce // N
                    dc.b $c5 // E
                    dc.b $d2 // R
                    dc.b $a0 // <blank>
                    dc.b $d3 // S
                    dc.b $cf // O
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $c9 // I
                    dc.b $c7 // G
                    dc.b $ce // N
                    dc.b $8d // <newline>
                    dc.b $8d // <newline>
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $a0 // <blank>
                    dc.b $c3 // C
                    dc.b $cf // O
                    dc.b $ce // N
                    dc.b $c7 // G
                    dc.b $d2 // R
                    dc.b $c1 // A
                    dc.b $d4 // T
                    dc.b $d5 // U
                    dc.b $cc // L
                    dc.b $c1 // A
                    dc.b $d4 // T
                    dc.b $c9 // I
                    dc.b $cf // O
                    dc.b $ce // N
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $00 // EndOfText
                    
.ChkOldSavHi        lda CR_BestHi                   // saved old best score 
                    cmp LR_ScoreHi                  // 
                    beq .ChkOldSavMidHi             // 
                    bcs .GoXitWithCarry             // 
                    
                    jmp .SuperMsgColorI             // 
                    
.ChkOldSavMidHi     lda CR_BestMiHi                 // 
                    cmp LR_ScoreMidHi               // 
                    beq .ChkOldSavMidLo             // 
                    bcs .GoXitWithCarry             // 
                    
                    jmp .SuperMsgColorI             // 
                    
.ChkOldSavMidLo     lda CR_BestMiLo                 // 
                    cmp LR_ScoreMidLo               // 
                    beq .ChkOldSavLo                // 
                    bcs .GoXitWithCarry             // 
                    
                    jmp .SuperMsgColorI             // 
.ChkOldSavLo        lda CR_BestLo                   // 
                    cmp LR_ScoreLo                  // 
                    bcc .SuperMsgColorI             // 
                    
.GoXitWithCarry     lda #$00                        // zero flag set - won but set no new hero message
                    jmp .ExitSetCarry               // 
                    
.SuperMsgColorI     lda #$20                        //
                    lda #HR_GreenGreen              //
                    ldx #$a0                        // amount
.SuperMsgColor      sta LR_ScrnMultColor+$00c8,x    //
                    dex                             //
                    bne .SuperMsgColor              //
                    
                    lda #$00                        //
                    sta LRZ_ScreenCol               // screen col ($00 - $1b)
                    lda #$09                        //
                    sta LRZ_ScreenRow               // screen row ($00 - $0f)
                    jsr TextOut                     // <your score is the best ever>
                    dc.b $d9 // Y
                    dc.b $cf // O
                    dc.b $d5 // U
                    dc.b $d2 // R
                    dc.b $a0 // <blank>
                    dc.b $d3 // S
                    dc.b $c3 // C
                    dc.b $cf // O
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $c9 // I
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $d4 // T
                    dc.b $c8 // H
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $c2 // B
                    dc.b $c5 // E
                    dc.b $d3 // S
                    dc.b $d4 // T
                    dc.b $a0 // <blank>
                    dc.b $c5 // E
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $d2 // R
                    dc.b $8d // <newline>
                    dc.b $8d // <newline>
                    dc.b $a0 // <blank>
                    dc.b $c5 // E
                    dc.b $ce // N
                    dc.b $d4 // T
                    dc.b $c5 // E
                    dc.b $d2 // R
                    dc.b $a0 // <blank>
                    dc.b $d4 // T
                    dc.b $c8 // H
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $d6 // V
                    dc.b $c9 // I
                    dc.b $c3 // C
                    dc.b $d4 // T
                    dc.b $cf // O
                    dc.b $d2 // R
                    dc.b $d9 // Y
                    dc.b $a0 // <blank>
                    dc.b $cd // M
                    dc.b $c5 // E
                    dc.b $d3 // S
                    dc.b $d3 // S
                    dc.b $c1 // A
                    dc.b $c7 // G
                    dc.b $c5 // E
                    dc.b $8d // <newline>
                    dc.b $8d // <newline>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $be // >
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $bc // <
                    dc.b $00 // EndOfText
                    
                    lda #$04                        //
                    sta LRZ_ScreenCol               // screen col ($00 - $1b)
                    
                    sec                             // clear buffer first
                    ldy #CR_BestMsgLen              //
                    jsr InputControl                //
                    beq .ExitSetCarry               // 
                    
                    ldx #CR_BestMsgLen              // 
.CpyMessage         lda CR_InputBuf,x               // copy msg to high score data
                    sta CR_BestMsg,x                // 
                    dex                             //
                    bpl .CpyMessage                 // 
                    
.CpyScore           lda LR_ScoreLo                  // copy score to high score data
                    sta CR_BestLo                   //
                    lda LR_ScoreMidLo               // 
                    sta CR_BestMiLo                 //
                    lda LR_ScoreMidHi               // 
                    sta CR_BestMiHi                 //
                    lda LR_ScoreHi                  // 
                    sta CR_BestHi                   //
                    
.SetScore           lda #LR_DiskWrite               // write back high scoreblock
                    jsr GetPutHiScores              // ac: $01=load $02=store 81= 82=
                    
                    lda #$01                        // zero flag clear - won and set new hero message
                    
.ExitSetCarry       sec                             //
ChkNewChampionX     rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
// OutNewChampion    Function: Put out the champions score and victory message
//                   Parms   :
//                   Returns :
//                   ID      : .hbu020.
// ------------------------------------------------------------------------------------------------------------- //
OutNewChampionXX    subroutine
                    clc                             // mark no message set
                    rts                             //
                    
                    
OutNewChampion      lda CR_BestHi                   // check champion scores
                    ora CR_BestMiHi                 // 
                    ora CR_BestMiLo                 //
                    ora CR_BestLo                   //
                    beq OutNewChampionXX            // nobody passed the last level so far
                    
                    jsr LvlEdCurSetHero             //
                    
                    ldx #$00                        //
                    stx LRZ_Work                    // check for blank message text
                    stx LR_Work                     //
                    
                    lda #>LR_ScrnHiReDisp           //
                    sta LRZ_GfxScreenOut            // control gfx screen output - display=$20(00) hidden=$40(00)
                    
                    ldy #$27                        // amount
                    lda #LR_ColorVicMsg             // color scores
.HeroesMsgColor     sta LR_ScrnMCTitle,y            //
                    dey                             //
                    bpl .HeroesMsgColor             //
                    
.HeroesMsgOut       lda CR_BestMsg,x                // 
                    pha                             //
                    
                    eor #$a0                        // <blank>
                    ora LRZ_Work                    // check for blank message text
                    sta LRZ_Work                    // 
                    
                    pla                             //
                    jsr PrepareChrOut               //
                    
                    inc LR_Work                     //
                    ldx LR_Work                     //
                    cpx #CR_BestMsgLen              //
                    bcc .HeroesMsgOut               // lower
                    
                    lda LRZ_Work                    // check for blank message text
                    beq OutNewChampionXX            // was blank message text
                    
                    inc LRZ_ScreenCol               // screen col ($00 - $1b)
                    
.HeroesScoreOut     lda CR_BestHi                   //
                    jsr SplitDecOut                 //
                    
                    lda CR_BestMiHi                 //
                    jsr SplitDecOut                 //
                    
                    lda CR_BestMiLo                 //
                    jsr SplitDecOut                 //
                    
                    lda CR_BestLo                   //
                    jsr SplitDecOut                 //
                    
.ExitSetCarry       sec                             // mark message set
OutNewChampionX     rts                             //
// ------------------------------------------------------------------------------------------------------------- //
// ChkNewHighScore   Function: Check for a new high score entry
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ChkNewHighScore     subroutine
                    lda LR_Cheated
                    beq .ExitClrCarry               // no scores for cheating
                    
                    lda LR_ScoreLo
                    ora LR_ScoreMidLo
                    ora LR_ScoreMidHi
                    ora LR_ScoreHi
                    beq .ExitClrCarry               // no game scores acquired yet
                    
                    lda #LR_DiskRead
                    jsr GetPutHiScores              // Target: $1100-$11ff
                    beq .ExitClrCarry               // no lr data disk
                    
.SetEntryNo         ldy #$01                        // start with entry 1
                    
.ChkEmpty           lda LR_HiScore
                    cmp #$00                        // no entry set so far
                    beq SetNewHighScore             // no checks for an empty high score table
                    
.Checks             ldx TabHiScRowPtr,y             // high score rows offsets
                    
.ChkLevel           lda LR_LevelNoGame              // 001-150
                    cmp LR_HiScoreLevel,x           // score board entry - level
                    bcc .NextEntry
                    bne SetNewHighScore
                    
.ChkScoreHi         lda LR_ScoreHi
                    cmp LR_HiScoreHi,x              // score board entry - score
                    bcc .NextEntry
                    bne SetNewHighScore
                    
.ChkScoreMidHi      lda LR_ScoreMidHi
                    cmp LR_HiScoreMidHi,x           // score board entry - score
                    bcc .NextEntry
                    bne SetNewHighScore
                    
.ChkScoreMidLo      lda LR_ScoreMidLo
                    cmp LR_HiScoreMidLo,x           // score board entry - score
                    bcc .NextEntry
                    bne SetNewHighScore
                    
.ChkScoreLo         lda LR_ScoreLo
                    cmp LR_HiScoreLo,x              // score board entry - score
                    bcc .NextEntry
                    bne SetNewHighScore
                    
.ChkLives           lda LR_NumLives
                    cmp LR_HiScoreMen,x             // score board entry - lives
                    bcc .NextEntry
                    bne SetNewHighScore
                    
.NextEntry          iny
                    cpy #LR_HiScoreMaxIDs+1         // max 10 high score entries
                    bcc .Checks                     // lower
                    
.ExitClrCarry       clc                             // .hbu000. - mark no new high scorer set
ChkNewHighScoreX    rts
// ------------------------------------------------------------------------------------------------------------- //
// SetNewHighScore   Function: Get new name in parts of 3/5 and write back
//                   Parms   :
//                   Returns :
//                   ID      // .hbu010. - Rewritten and high score working sets removed
// ------------------------------------------------------------------------------------------------------------- //
SetNewHighScore     subroutine
                    sty $29                         // row offset of new entry
                    
.ChkMax             cpy #LR_HiScoreMaxIDs           // no insertion for last entry
                    beq .Insert                     // simply overwrite
                    
.ChkEmpty           ldy LR_HiScore
                    cpy #$ff
                    beq SetNewHighScore             // no insertion for last entry
                    
                    ldy #LR_HiScoreMaxIDs-1         // $0a - max entries to move
.MoveDownI          ldx TabHiScRowPtr,y             // high score rows offsets
                    
                    lda #LR_HiScoreLEntry           // high score entry length
                    sta LRZ_WrkHiScorLen
                    
.MoveDown           lda LR_HiScoreMain,x            // main part one row down
                    sta LR_HiScoreMain + LR_HiScoreLEntry,x
                    lda LR_HiScoreXtra,x            // extension one row down
                    sta LR_HiScoreXtra + LR_HiScoreLEntry,x
                    inx
                    dec LRZ_WrkHiScorLen
                    bne .MoveDown
                    
                    cpy $29                         // row offset of new entry
                    beq .Insert
                    
                    dey                             // number of new entry not reached
                    bne .MoveDownI                  // move next entry
                    
.Insert             sty $39                         // row number of new entry
                    
                    ldx TabHiScRowPtr,y             // high score rows offsets
                    lda #$a0                        // shift blank
.ClrName            sta LR_HiScoreNam1,x            // .hbu010. - initial 1
                    sta LR_HiScoreNam1+1,x          // .hbu010. - initial 2
                    sta LR_HiScoreNam1+2,x          // .hbu010. - initial 3
                    sta LR_HiScoreNam2,x            // .hbu010. - initial 3
                    sta LR_HiScoreNam2+1,x          // .hbu010. - initial 3
                    sta LR_HiScoreNam2+2,x          // .hbu010. - initial 3
                    sta LR_HiScoreNam2+3,x          // .hbu010. - initial 3
                    sta LR_HiScoreNam2+4,x          // .hbu010. - initial 3
                    
.SetLevel           lda LR_LevelNoGame              // 001-150
                    sta LR_HiScoreLevel,x           // level
                    
.SetScore           lda LR_ScoreLo
                    sta LR_HiScoreLo,x              // score
                    lda LR_ScoreMidLo
                    sta LR_HiScoreMidLo,x           // score
                    lda LR_ScoreMidHi
                    sta LR_HiScoreMidHi,x           // score
                    lda LR_ScoreHi
                    sta LR_HiScoreHi,x              // score
                    
.SetLives           lda LR_NumLives                 // men left
                    sta LR_HiScoreMen,x             // directly behind 2nd part of name
                    
                    jsr ShowHighScoreClr
                    
.GetScorerName      lda #LR_HiScColOffNam
                    sta LRZ_ScreenCol
                    lda #LR_HiScRowOff1St           // number first score line
                    clc
                    adc $39                         // add number of this heroes high score entry
                    sta LRZ_ScreenRow               // is row offset
                    
.SetHighScorePtr    lda #<TabSubstRowHighS          //  set grouped high score pointer
                    sta Mod__RowGfxL
                    lda #>TabSubstRowHighS
                    sta Mod__RowGfxH
                    
                    sec                             // clear buffer first
.SetBufferLen       ldy #LR_HiScoreNamLen+1         // input buffer max length
                    jsr InputControl                // fill input buffer
                    
.RstHighScorePtr    lda #<TabSubstRow               // restore pointer to game row offsets
                    sta Mod__RowGfxL
                    lda #>TabSubstRow
                    sta Mod__RowGfxH
                    
.OutNew             ldy $39
                    ldx TabHiScRowPtr,y             // high score rows offsets
                    
.SetName            lda CR_InputBuf
                    sta LR_HiScoreNam1,x            // name 1.1
                    lda CR_InputBuf+1
                    sta LR_HiScoreNam1+1,x          // name 1.2
                    lda CR_InputBuf+2
                    sta LR_HiScoreNam1+2,x          // name 1.3
                    
                    lda CR_InputBuf+3
                    sta LR_HiScoreNam2,x            // name 2.1
                    lda CR_InputBuf+4
                    sta LR_HiScoreNam2+1,x          // name 2.2
                    lda CR_InputBuf+5
                    sta LR_HiScoreNam2+2,x          // name 2.3
                    lda CR_InputBuf+6
                    sta LR_HiScoreNam2+3,x          // name 2.4
                    lda CR_InputBuf+7
                    sta LR_HiScoreNam2+4,x          // name 3.5
                    
                    lda #LR_DiskWrite
                    jsr GetPutHiScores              // Target: $1100-$11ff
                    
.ExitSetCarry       sec                             // .hbu000. - mark new high scorer set
SetNewHighScoreX    rts                             //
// ------------------------------------------------------------------------------------------------------------- //
// ColorHighScores   Function: Select a new color for each high score group
//                   Parms   :
//                   Returns :
//                   ID      : .hbu010.
// ------------------------------------------------------------------------------------------------------------- //
ColorHighScores     subroutine
                    lda #<LR_ScrnMultColor          // set color screen pointer
                    sta $44
                    lda #>LR_ScrnMultColor
                    sta $45 
                    
                    ldx #$00
.SetRowCount        ldy #$27                        // 28 color row positions
                    lda TabScoreColors,x            // get a color
.SetColor           sta ($44),y                     // put a color
                    cpy #$06                        // check for rank area
                    bne .SetColPtr
                    
                    lda #HR_WhiteWhite              // rank color
                    
.SetColPtr          dey                             // next color screen coloumn
                    bpl .SetColor
                    
.SetRowPtr          lda #$28                        // set color screen to next row
                    clc
                    adc $44
                    sta $44
                    bcc .SetNextColorRow
                    inc $45
                    
.SetNextColorRow    inx
                    cpx #TabScoreColorsX-TabScoreColors
                    bne .SetRowCount
                    
ColorHighScoresX    rts
// ------------------------------------------------------------------------------------------------------------- //
TabScoreColors      dc.b HR_CyanCyan               // title line
                    dc.b HR_CyanCyan               // 
                    dc.b HR_CyanCyan               // 
                    dc.b HR_CyanCyan               // 
                    
                    dc.b HR_WhiteWhite             // header line
                    dc.b HR_WhiteWhite             // 
                    
                    dc.b HR_WhiteWhite             // separation line
                    
                    dc.b HR_YellowYellow           // the 1st
                    dc.b HR_LtGreenLtGreen         // the 2nd
                    dc.b HR_LtGreenLtGreen         // 
                    dc.b HR_LtRedLtRed             // the 3rd
                    
                    dc.b HR_PurpleLtBlue           // group 4-6
                    dc.b HR_PurpleLtBlue           // 
                    dc.b HR_PurpleLtBlue           // 
                    dc.b HR_PurpleLtBlue           // 
                    dc.b HR_PurpleLtBlue           // 
                    
                    dc.b HR_GreyLtGrey             // group 7-9
                    dc.b HR_GreyLtGrey             // 
                    dc.b HR_GreyLtGrey             // 
                    dc.b HR_GreyLtGrey             // 
                    dc.b HR_GreyLtGrey             // 
                    
                    dc.b HR_DkGreyDkGrey           // the last 
                    dc.b HR_DkGreyDkGrey           // 
                    
TabScoreColorsX     dc.b HR_CyanCyan               // message area
// ------------------------------------------------------------------------------------------------------------- //
// ShowHighScore     Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ShowHighScoreClr    subroutine
                    jsr ClearHiresDisp
                    
ShowHighScore       lda #<TabSubstRowHighS          // .hbu000. - 2nd entry point for calls from StartGraphicOut
                    sta Mod__RowGfxL                // .hbu010.
                    lda #>TabSubstRowHighS          // .hbu010.
                    sta Mod__RowGfxH                // .hbu010.
                    jsr ColorHighScores             // .hbu010.
                    
                    jsr LvlEdCurPosInit             // set cursor to top left screen pos
                    jsr TextOut                     // <lode runner high scores>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $cf // O
                    dc.b $c4 // D
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $d2 // R
                    dc.b $d5 // U
                    dc.b $ce // N
                    dc.b $ce // N
                    dc.b $c5 // E
                    dc.b $d2 // R
                    dc.b $a0 // <blank>
                    dc.b $c8 // H
                    dc.b $c9 // I
                    dc.b $c7 // G
                    dc.b $c8 // H
                    dc.b $a0 // <blank>
                    dc.b $d3 // S
                    dc.b $c3 // C
                    dc.b $cf // O
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $d3 // S
                    dc.b $8d // <new line>
                    dc.b $8d // <new line>
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank> .hbu010. - title line changed
                    dc.b $a0 // <blank>
                    dc.b $ce // N
                    dc.b $c1 // A
                    dc.b $cd // M
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $d6 // V
                    dc.b $cc // L
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $d3 // S
                    dc.b $c3 // C
                    dc.b $cf // O
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $cd // M
                    dc.b $c5 // E
                    dc.b $ce // N
                    dc.b $8d // <new line>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $a0 // <blank>
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $a0 // <blank>
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $a0 // <blank>
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $8d // <new line>
                    dc.b $00 // EndOfText
                    
                    lda #$01
                    sta $28                         // actual rank
                    
.ShowScores         cmp #$0a                        // 10
                    bne .Not10
                    
                    lda #$01                        // rank 10  - start with "1"
                    jsr PrepareDigitOut
                    
                    lda #$00
                    jsr PrepareDigitOut
                    jmp .SepRankName
                    
.Not10              lda #$a0                        // rank 1-9 - start with " "
                    jsr PrepareChrOut
                    
                    lda $28                         // actual rank
                    jsr PrepareDigitOut
                    
.SepRankName        jsr TextOut
                    dc.b $ae // <dot>               // .hbu008. - 4 <blank> removed
                    dc.b $00 // EndOfText
                    
                    ldx $28                         // actual rank
                    ldy TabHiScRowPtr,x             // high score rows offsets
                    sty $29                         // score board offset
                    
                    lda LR_HiScoreLevel,y           // get level no
                    bne .ScoreInitialsP1
                    
                    jmp .NextLine
                    
.ScoreInitialsP1    ldy $29                         // get score board offset - put out first part of name
                    lda LR_HiScoreNam1,y            // .hbu010. - name chr 1
                    jsr ControlOutput               // .hbu010.
                    
                    ldy $29                         // score board offset
                    lda LR_HiScoreNam1+1,y          // .hbu010. - name chr 2
                    jsr ControlOutput               // .hbu010.
                    
                    ldy $29                         // score board offset
                    lda LR_HiScoreNam1+2,y          // .hbu010. - name chr 3
                    jsr ControlOutput               // .hbu010.
                    
.ScoreInitialsP2    ldy $29                         // get score board offset - put out first part of name
                    lda LR_HiScoreNam2,y            // .hbu010. - name chr 4
                    jsr ControlOutput               // .hbu010.
                    
                    ldy $29                         // score board offset
                    lda LR_HiScoreNam2+1,y          // .hbu010. - name chr 5
                    jsr ControlOutput               // .hbu010.
                    
                    ldy $29                         // score board offset
                    lda LR_HiScoreNam2+2,y          // .hbu010. - name chr 6
                    jsr ControlOutput               // .hbu010.
                    
                    ldy $29                         // score board offset
                    lda LR_HiScoreNam2+3,y          // .hbu010. - name chr 7
                    jsr ControlOutput               // .hbu010.
                    
                    ldy $29                         // score board offset
                    lda LR_HiScoreNam2+4,y          // .hbu010. - name chr 8
                    jsr ControlOutput               // .hbu010.
                    
                    jsr TextOut
.SepNameLevel       dc.b $a0 // <blank>             // .hbu008. - 3 <blank> removed
                    dc.b $00 // EndOfText
                    
                    ldy $29                         // score board offset
                    lda LR_HiScoreLevel,y           // level reached
                    jsr SplitHexOut                 //
                    
                    jsr TextOut
.SepLevelScore      dc.b $a0 // <blank>             // .hbu008. - 1 <blank> removed
                    dc.b $00 // EndOfText
                    
                    ldy $29                         // score board offset
                    lda LR_HiScoreHi,y              // score hi byte
                    jsr SplitDecOut
                    
                    ldy $29                         // score board offset
                    lda LR_HiScoreMidHi,y
                    jsr SplitDecOut
                    
                    ldy $29                         // score board offset
                    lda LR_HiScoreMidLo,y
                    jsr SplitDecOut
                    
                    ldy $29                         // score board offset
                    lda LR_HiScoreLo,y
                    jsr SplitDecOut
                    
                    jsr TextOut                     // .hbu010. - output the no of men left
.SepScoreMen        dc.b $a0
                    dc.b $00                       // .hbu010. - <end_of_text>
                    
                    ldy $29	                        // .hbu010. - score board offset
                    lda LR_HiScoreMen,y             // .hbu010. - men left
                    jsr SplitHexOut
                    
.NextLine           inc LRZ_ScreenRow               // .hbu010. - next  screen row  (00-0f)
                    lda #$00                        // .hbu010.
                    sta LRZ_ScreenCol               // .hbu010. - first screen col  (00-1b)
                    
.NextRank           inc $28                         // actual rank
                    lda $28                         // actual rank
                    cmp #LR_HiScoreMaxIDs+1         // max 10
                    bcs .RstHighScorePtr            // .hbu010.
                    
.NextRow            jmp .ShowScores                 // next row
                    
.RstHighScorePtr    lda #<TabSubstRow               // .hbu010. - restore pointer to game row offsets
                    sta Mod__RowGfxL                // .hbu010.
                    lda #>TabSubstRow               // .hbu010.
                    sta Mod__RowGfxH                // .hbu010.
                    
ShowHighScoresX     jmp OutNewChampion              // .hbu020. - test for victiry message
// ------------------------------------------------------------------------------------------------------------- //
TabHiScRowPtr       dc.b $00
                    dc.b $00
                    dc.b $08
                    dc.b $10
                    dc.b $18
                    dc.b $20
                    dc.b $28
                    dc.b $30
                    dc.b $38
                    dc.b $40
                    dc.b $48
// ------------------------------------------------------------------------------------------------------------- //
// ControlOutput     Function: Control output of image/digits/prepared digits/characters
//                   Parms   : ac=chr/digit
//                   Returns : 
//                   ID      : .hbu010.
// ------------------------------------------------------------------------------------------------------------- //
ControlOutput       subroutine
                    cmp #$0a
                    bcc .DigitOut                   // pure digit
                    
.ChkPrep            cmp #NoDigitsMin
                    bcc .GetBlank                   // image - no output
                    
.ChkChr             cmp #NoDigitsMax+1
                    bcc ControlOutputX              // digit
                    bcs .ChrOut                     // character
                    
.GetBlank           lda #$a0                        // " " 
                    
.ChrOut             jmp PrepareChrOut               // Character
.DigitOut           jmp PrepareDigitOut             // digit
ControlOutputX      jmp DigitOut2Screen             // prepared digit
// ------------------------------------------------------------------------------------------------------------- //
// InputControl      Function: String input and control modifications 
//                   Parms   : LRZ_ScreenCol/LRZ_ScreenRow=screen_pos  yr=length of input field + 1
//                           : Carry_Set  =Clear Buffer first 
//                           : Carry_Clear=Buffer already filled
//                   Returns : 
//                   ID      : .hbu009.
// ------------------------------------------------------------------------------------------------------------- //
InputControl        subroutine
                    sty CR_InputBufMax              // input field length
                    bcc .Init                       // do not clear input buffer
                    
                    lda #$a0                        // <blank>
                    ldx #CR_InputBufLen
.ClrInputBuffer     sta CR_InputBuf,x               //
                    dex                             //
                    bpl .ClrInputBuffer             //
                    
.Init               ldx #$00
                    stx LR_WrkCurrentPos            // current input screen pos
                    stx LR_KeyNew                   // reset key pressed
                    
.GetNewInput        ldx LR_WrkCurrentPos            // current input screen pos
                    lda CR_InputBuf,x
                    
.ChkDigit           cmp #NoDigitsMin                // no substitution for digits
                    bcc .SetChr                     // character
                    
                    cmp #NoDigitsMax+1
                    bcc .WaitKey                    // digit
                    
.SetChr             jsr GetChrSubst                 // map to character image data numbers
                    
.WaitKey            jsr WaitKeyBlink
                    
                    lda LR_KeyNew                   // care only for keyboard interactions
                    ldy #LR_KeyNewNone              // reset value
                    sty LR_KeyNew                   // do not handle this key more than once
                    
.SetDigit           jsr GetDigSubstChk              // check digital keys and map to $00-$09
                    bcc .OutDigit                   // was digit
                    
.ChkRunStop         cmp #$3f                        // <run/stop> - abort edit
                    bne .GetKeySubst                // 
                    
.ExitAbort          sec                             // <run/stop> pressed
                    ldx #$00
                    rts
                    
.GetKeySubst        jsr GetKeySubst                 // map allowed keys
                                      
.ChkReturn          cmp #$8d                        // <return> - end of edit
                    beq .ExitRet
                    
.ChkCursorUD        cmp #$88                        // <cursor up/down>
                    bne .ChkCursorLR
                    
                    ldx LR_WrkCurrentPos            // current input screen pos
                    beq .Beep
                    
                    dec LR_WrkCurrentPos            // current input screen pos
                    dec LRZ_ScreenCol
                    jmp .GetNewInput
                    
.ChkCursorLR        cmp #$95                        // <cursor left/right>
                    bne .ChkChars
                    
                    ldx CR_InputBufMax
                    dex
                    cpx LR_WrkCurrentPos            // current input screen pos
                    beq .Beep
                    
                    inc LRZ_ScreenCol
                    inc LR_WrkCurrentPos            // current input screen pos
                    jmp .GetNewInput
                    
.ChkChars           cmp #$a0                        // <blank>
                    beq .OutChr
                    
                    cmp #$ae                        // "."
                    beq .OutChr
                    
                    cmp #$c1                        // "A"
                    bcc .Beep
                    
                    cmp #$db                        // "Z" + 1
                    bcs .Beep
                    
.OutChr             ldy LR_WrkCurrentPos            // current input screen pos
.StoreMsgChr        sta CR_InputBuf,y
                    jsr PrepareChrOut
                    
                    jmp .SetModified
                    
.OutDigit           clc
                    adc #NoChrDigitsMin             // .hbu015. - map to chr digit image data numbers - must not be $00-$09 because $00 ist EndOfText
                    ldy LR_WrkCurrentPos            // current input screen pos
.StoreMsgDigit      sta CR_InputBuf,y
                    jsr DigitOut2Screen
                    
.SetModified        lsr LRZ_EditStatus              // flag: data was changed
                    
                    inc LR_WrkCurrentPos            // current input screen pos
                    lda LR_WrkCurrentPos            // current input screen pos
                    cmp CR_InputBufMax              // maximum right
                    bcc .GoGetNewInput
                    
.SetNewPos          dec LR_WrkCurrentPos            // current input screen pos
                    dec LRZ_ScreenCol
                    
.GoGetNewInput      jmp .GetNewInput
                    
.Beep               jsr Beep
                    jmp .GetNewInput
                    
.ExitRet            ldx CR_InputBufMax              // <enter> pressed
.ChkBlanks          lda CR_InputBuf,x               // 
                    cmp #$a0                        // <blank>
                    bne .ExitWithInput              // some text found
                    
                    dex                             //
                    bpl .ChkBlanks                  // 
                    
.ExitNoInput        clc                             // enter with no text
                    ldx #$00
                    rts
                    
.ExitWithInput      clc                             // enter with text
                    ldx #$01
InputControlX       rts
// ------------------------------------------------------------------------------------------------------------- //
// GetKeySubst       Function: Substitute a value for allowed keys
//                   Parms   : ac=key value
//                   Returns : ac=key substitution with bit7 set
// ------------------------------------------------------------------------------------------------------------- //
GetKeySubst         subroutine
                    cmp #$82                        // replaced by $07
                    bne .GetSubst
                    
                    lda #$07
                    
.GetSubst           tay
                    lda TabKeySubst,y
                    ora #$80                        // set bit7
                    
GetKeySubstX        rts
// ------------------------------------------------------------------------------------------------------------- //
TabKeySubst         equ *
KeyMatrixColBit0    dc.b $00 // $00 - DELETE
                    dc.b $0d // $01 - RETURN
                    dc.b $15 // $02 - CRSR_R
                    dc.b $ff // $03 - F7
                    dc.b $ff // $04 - F1
                    dc.b $ff // $05 - F3
                    dc.b $ff // $06 - F5
                    dc.b $08 // $07 - CRSR_D
                    
KeyMatrixColBit1    dc.b $33 // $08 - 3
                    dc.b $57 // $09 - W
                    dc.b $41 // $0a - A
                    dc.b $34 // $0b - 4
                    dc.b $5a // $0c - Z
                    dc.b $53 // $0d - S
                    dc.b $45 // $0e - E
                    dc.b $ff // $0f - LSHIFT
                    
KeyMatrixColBit2    dc.b $35 // $10 - 5
                    dc.b $52 // $11 - R
                    dc.b $44 // $12 - D
                    dc.b $36 // $13 - 6
                    dc.b $43 // $14 - C
                    dc.b $46 // $15 - F
                    dc.b $54 // $16 - T
                    dc.b $58 // $17 - X
                    
KeyMatrixColBit3    dc.b $37 // $18 - 7
                    dc.b $59 // $19 - Y
                    dc.b $47 // $1a - G
                    dc.b $38 // $1b - 8
                    dc.b $42 // $1c - B
                    dc.b $48 // $1d - H
                    dc.b $55 // $1e - U
                    dc.b $56 // $1f - V
                    
KeyMatrixColBit4    dc.b $39 // $20 - 9
                    dc.b $49 // $21 - I
                    dc.b $4a // $22 - J
                    dc.b $30 // $23 - 0
                    dc.b $4d // $24 - M
                    dc.b $4b // $25 - K
                    dc.b $4f // $26 - O
                    dc.b $4e // $27 - N
                    
KeyMatrixColBit5    dc.b $2b // $28 - +
                    dc.b $50 // $29 - P
                    dc.b $4c // $2a - L
                    dc.b $2d // $2b - -
                    dc.b $2e // $2c - .
                    dc.b $3a // $2d - :
                    dc.b $ff // $2e - @
                    dc.b $2c // $2f - ,
                    
KeyMatrixColBit6    dc.b $5c // $30 - LIRA
                    dc.b $2a // $31 - *
                    dc.b $3b // $32 - //
                    dc.b $ff // $33 - HOME
                    dc.b $ff // $34 - RSHIFT
                    dc.b $3d // $35 - =
                    dc.b $ff // $36 - ^
                    dc.b $2f // $37 - /
                    
KeyMatrixColBit7    dc.b $31 // $38 - 1
                    dc.b $ff // $39 - <-
                    dc.b $ff // $3a - CTRL
                    dc.b $32 // $3b - 2
                    dc.b $20 // $3c - SPACE
                    dc.b $ff // $3d - C=
                    dc.b $51 // $3e - Q
                    dc.b $ff // $3f - STOP
// ------------------------------------------------------------------------------------------------------------- //
// InitLevel         Function:
//                   Parms   : xr=$00 prepared level already existing at 4000-5fff
//                           : xr=$01 level needs to be prepared
//                           // xr=$ff InitLevel failure
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
InitLevel           subroutine
                    stx LR_LevelCtrl                // level display control  $00=prepared copy already at 4000-5fff
                    
                    ldx #$ff                        // init to no lr found
                    stx LRZ_LodeRunCol              // actual col lode runner
                    
                    inx                             // $00
                    stx LR_NumXitLadders            // # hidden ladders
                    stx LR_Gold2Get                 // # gold
                    stx LR_EnmyNo                   // # enemies
                    stx LR_NoEnemy2Move             // # enemies to move
                    stx LRZ_Work                    // left right nybble 00=right
                    stx LRZ_ScreenRow               // screen row  (00-0f)
                    stx $53                         // disk level data offset
                    stx $54
                    
                    txa                             // $00
                    ldx #LR_TabHoleMax              // max 30
.HoleTime           sta LR_TabHoleOpenTime,x        // hole open time tab
                    dex
                    bpl .HoleTime
                    
                    ldx #LR_TabEnemyRebLen          // max 6
.ENReBirthStep      sta LR_TabEnemyRebTime,x        // enemy rebirth step time
                    dex
                    bpl .ENReBirthStep
                    
                    lda #LR_Life
                    sta LR_Alive
                    
                    lda LR_LevelNoDisk              // 000-149
                    cmp LR_LvlReload
                    beq .SameLevel                  // same - no load from disk
                    
.NewLevel           lda #LR_DiskRead
                    jsr ControlDiskOper
                    
.SameLevel          lda LR_LevelNoDisk              // 000-149
                    sta LR_LvlReload                // same - no load from disk
                    
                    ldy LRZ_ScreenRow               // screen row  (00-0f)
.ExpandDataI        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    
                    lda #$00
                    sta LRZ_ScreenCol               // screen col  (00-1b)
                    
.GetDataBytes       lda LRZ_Work                    // control left/right nybble to process  00=right
.Carry4RightLeft    lsr a                           // carry flag
                    
                    ldy $53                         // disk level data offset
.GetOneDataByte     lda LR_LvlDataSavLod,y          // get a packed level data byte
                    bcs .LeftNybble                 // carry possibly set by .Carry4RightLeft
                    
.RightNybble        and #$0f                        // isolate right nybble
                    bpl .InitNybbleMark             // always
                    
.LeftNybble         lsr a                           // isolate left nybble
                    lsr a
                    lsr a
                    lsr a
                    inc $53                         // both nybbles processed so point to next byte
                    
.InitNybbleMark     inc LRZ_Work                    // force carry set the next round by .Carry4RightLeft
                    
                    ldy LRZ_ScreenCol               // screen col  (00-1b)
                    
.ChkValid           cmp #NoTileNumMax+1             // valid byte range is $00-$09
                    bcc .PutDataBytes               // lower
                    
.SetEmpty           lda #NoTileBlank                // not valid so store a $00
                    
.PutDataBytes       sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
.PutCtrlBytes       sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    inc LRZ_ScreenCol               // screen col  (00-1b)
                    lda LRZ_ScreenCol               // screen col  (00-1b)
                    cmp #LR_ScrnMaxCols+1           // $1b - max 27 cols
                    bcc .GetDataBytes
                    
                    inc LRZ_ScreenRow               // screen row  (00-0f)
                    ldy LRZ_ScreenRow               // screen row  (00-0f)
                    cpy #LR_ScrnMaxRows+1           // $0f - max 15 rows
                    bcc .ExpandDataI
                    
.GoCheckLevel       jsr CheckLevel
.NoError            bcc InitLevelX                  // good
                    
.LevelError         lda LR_LevelNoDisk              // 000-149
                    beq GoColdStart
                    
                    ldx #$00                        // force ColdStart the next time
                    stx LR_LevelNoDisk              // 000-149
                    
.ChkGameSpeed       lda LR_CntSpeedLaps
                    cmp #LR_CntSpeedMax+1           // max 9
                    bcs .SetFF
                    
                    inc LR_CntSpeedLaps             // increase game speed
                    
.SetFF              dex
.Loop               jmp InitLevel                   // restart
                    
InitLevelX          rts
// ------------------------------------------------------------------------------------------------------------- //
GoColdStart         jmp ColdStart
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
PackLevel           subroutine
                    lda #$00
                    sta $53                         // disk level data offset
                    sta LRZ_Work                    // left/right nybble 00=right
                    sta LRZ_ScreenRow               // screen row  (00-0f)
.PackLevelI         ldy LRZ_ScreenRow               // screen row  (00-0f)
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi
                    
                    ldy #$00
                    sty LRZ_ScreenCol               // screen col  (00-1b)
.GetDataBytes       lda LRZ_Work                    // control left/right nybble to process  00=right
                    lsr a
.GetOneDataByte     lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    bcs .LeftNybble                 // set from lsr prev
                    
.RightNybble        sta LRZ_ImageNo                 // level input tile $00-$09 - store as right nybble
                    bpl .InitNybbleMark             // always
                    
.LeftNybble         asl a                           // isolate left nybble
                    asl a
                    asl a
                    asl a
                    ora LRZ_ImageNo                 // level input tile $00-$09 - merge with right nybble
                    
                    ldy $53                         // disk level data offset
.PutOneDataByte     sta LR_LvlDataSavLod,y
                    
                    inc $53                         // disk level data offset
                    
.InitNybbleMark     inc LRZ_Work                    // will set carry the next round
                    inc LRZ_ScreenCol               // screen col  (00-1b)
                    ldy LRZ_ScreenCol               // screen col  (00-1b)
                    cpy #LR_ScrnMaxCols+1           // $1b - max 27 cols
                    bcc .GetDataBytes
                    
                    inc LRZ_ScreenRow               // screen row  (00-0f)
                    lda LRZ_ScreenRow               // screen row  (00-0f)
                    cmp #LR_ScrnMaxRows+1           // $0f - max 15 rows
                    bcc .PackLevelI
                    
PackLevelX          rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
//                   Function: Decide whether a level is to be loaded from disk or not (demo)
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ControlDiskOper     subroutine
                    sta LR_DiskAction               // .hbu000. - $01=read $02=write $04=init
                    
.ChkGameCtrl        lda LR_GameCtrl                 // $00=start $01=demo $02=game $03=play_level $05=edit
                    lsr a                           // 
                    beq .IsDemo                     // 
                    
.IsGame             jmp DiskRW                      // only game levels have to be loaded
                    
.IsDemo             lda LR_LevelNoDisk              // 000-149
                    cmp #LR_LevelNoMaxDmo           // max built in demo levels
                    bcc .SetDemoLvlData
                    
.RestartDemo        lda #$00                        // restart at level 1
                    sta LR_LevelNoDisk              // 000-149
                    
.SetDemoLvlData     asl a                           // .hbu005.
                    tay                             // .hbu005.
                    lda TabDemoLvlData,y            // .hbu005.
                    sta ..ModCpyDemoLvlL            // .hbu005.
                    lda TabDemoLvlData+1,y          // .hbu005.
                    sta ..ModCpyDemoLvlH            // .hbu005.
                    
.SetDemoLvlMoves    lda TabDemoLvlMoves,y           // .hbu005.
                    sta LRZ_DemoMoveDatLo           // .hbu005.
                    lda TabDemoLvlMoves+1,y         // .hbu005.
                    sta LRZ_DemoMoveDatHi           // .hbu005. - ($55/$56) -> DemoMoveData
                    
                    ldy #$00
.CpyDemoLvlData     lda TabDemoLevels,y             // .hbu005. - get demo level data
..ModCpyDemoLvlH    equ *-1
..ModCpyDemoLvlL    equ *-2                         // .hbu005.
                    sta LR_LvlDataSavLod,y
                    iny
                    bne .CpyDemoLvlData
                    
ControlDiskOperX    rts
// ------------------------------------------------------------------------------------------------------------- //
TabDemoLvlData      dc.w TabDemoDataLvl01          // .hbu005.
                    dc.w TabDemoDataLvl02          // .hbu005.
                    dc.w TabDemoDataLvl03          // .hbu005.
                    dc.w TabDemoDataLvl01          // .hbu005.
TabDemoLvlMoves     dc.w TabDemoMoveLvl01          // .hbu005. must be called one after the other
                    dc.w TabDemoMoveLvl02          // .hbu005. otherwise enemy behaviour differs
                    dc.w TabDemoMoveLvl03          // .hbu005.
                    dc.w TabDemoMoveLvl04          // .hbu005.
// ------------------------------------------------------------------------------------------------------------- //
// GetPutHiScores    Function:
//                   Parms   : ac=action $01=load $02=store
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetPutHiScores      subroutine
                    tax                             // save action $01=load $02=store
                    
                    lda LR_LevelNoDisk              // 000-149
                    pha                             // save actual disk level no
                    
.SavBufferPtr       lda Mod_GetDiskByte             // .hbu000. - save pointer
                    pha                             // .hbu000.
                    
.SetScoreBuffer     lda #>LR_ScoreSavLod            // .hbu000.
                    sta Mod_GetDiskByte             // .hbu000. - set to LR_ScoreSavLod
                    sta Mod_PutDiskByte             // .hbu000.
                    
                    lda #LR_LevelDiskScor           // disk level 151 is the high score store
                    sta LR_LevelNoDisk              // 000-149 151/152
                    
                    txa                             // restore action $01=load $02=store
                    jsr ControlDiskOper
                    
                    pla                             // .hbu000.
.ResScoreBuffer     sta Mod_GetDiskByte             // .hbu000. - reset to old value
                    sta Mod_PutDiskByte
                    
                    pla                             // restore disk level no
                    sta LR_LevelNoDisk              // 000-149
                    
                    ldy #LR_HiScoreIdLen            // length lr disk id
.ChkDiskID          lda LR_HiScoreDiskId,y          // lr disk id
                    cmp TabLrDiskId,y               // .hbu000.
                    bne .ClrScoresI                 // .hbu000.
                    
                    dey                             // .hbu000.
                    bpl .ChkDiskID                  // .hbu000.
                    
.ChkMasterDisk      lda #LR_DiskMaster              // $01 - disk in drive is a load runner master disk
                    ldx LR_HiScoreDiskUM            // offset indicator store in high score block
                    bne GetPutHiScoresX             // master disk
                    
.SetUserDisk        lda #LR_DiskData                // mark disk in drive as a load runner user disk
                    rts
                    
.ClrScoresI         ldy #$00                        // .hbu000.
                    tya                             // .hbu000.
.ClrScores          sta LR_ScoreSavLod,y            // .hbu000. - clear the score buffer
                    dey                             // .hbu000.
                    bne .ClrScores                  // .hbu000.
                    
                    ldy #LR_HiScoreIdLen            // .hbu000. - "DANE BIGHAM"
.SetScoresID        lda TabLrDiskId,y               // .hbu000.
                    sta LR_HiScoreDiskId,y          // .hbu000.
                    dey                             // .hbu000.
                    bpl .SetScoresID                // .hbu000.
                    
                    iny
                    sty LR_HiScoreDiskUM            // .hbu000. - mark as user data disk
                    
.SetBadDisk         lda #LR_DiskNoData              // return no load runner data disk this time
GetPutHiScoresX     rts
// ------------------------------------------------------------------------------------------------------------- //
// Xmit              Function: Transmit the active level to drive 9
//                   Parms   :
//                   Returns :
//                   ID      : .hbu017.
// ------------------------------------------------------------------------------------------------------------- //
Xmit                subroutine
                    lda LR_LevelNoXmit              // target level no
                    ldx #$09                        // drive no
                    jsr SetDiskCmd                  // 
                    bcs .DiskError                  // disk error
                    
.DiskOk             jsr ExecDiskCmdWrite            // write block
                    
                    lda #$d8                        // "X"
                    sta Mod_InfoTxt1                // 
                    lda #$cd                        // "M"
                    sta Mod_InfoTxt2                // 
                    lda #$c9                        // "I"
                    sta Mod_InfoTxt3                // 
                    jsr XmitInfo                    // message
                    
                    inc LR_LevelNoXmit              // set next xmit level
.ExitOK             rts                             // 
                    
.DiskError          jsr Beep                        // double beep/reset and return
                    jsr Beep                        // 
XmitX               jmp ResetDisk                   // 
// ------------------------------------------------------------------------------------------------------------- //
// XmitInfo          Function: Print an info message after successful xmit and wait for user key
//                   Parms   :
//                   Returns :
//                   ID      : .hbu017.
// ------------------------------------------------------------------------------------------------------------- //
XmitInfo            subroutine
                    ldx LR_LevelNoXmit              // xmit target    000-149
                    inx                             // display target 001-150
                    txa
.Split              jsr ConvertHex2Dec              // 1307=100 1308=10 1309=1
                    
.InfoGet100         lda LR_Digit100                 // 
.Prepare100         clc                             // 
                    adc #NoDigitsMin                // map to digit image data numbers                  
.InfoSet100         sta .InfoMsg100                 // 
.InfoGet10          lda LR_Digit10                  // 
.Prepare10          clc                             // 
                    adc #NoDigitsMin                // map to digit image data numbers                  
.InfoSet10          sta .InfoMsg10                  // 
.InfoGet1           lda LR_Digit1                   // 
.Prepare1           clc                             // 
                    adc #NoDigitsMin                // map to digit image data numbers                  
.InfoSet1           sta .InfoMsg1                   // 
                    
.InfoClearMsg       jsr ClearMsg                    // 
                    
.InfoSetOutput      lda #>LR_ScrnHiReDisp           // 
                    sta LRZ_GfxScreenOut            // output to display screen only
                    
.InfoSetDisplay     jsr LvlEdCurSetMsg              // prepare display
                    jsr TextOut                     // <lvl xmit>
.InfoMsg            dc.b $cc // L                    // 
                    dc.b $d6 // V                    // 
                    dc.b $cc // L                    // 
                    dc.b $a0 // <blank>              // 
.InfoMsg100         dc.b $a0 // <blank>              // 
.InfoMsg10          dc.b $a0 // <blank>              // 
.InfoMsg1           dc.b $a0 // <blank>              // 
                    dc.b $a0 // <blank>              // 
Mod_InfoTxt1        dc.b $d8 // X                    // 
Mod_InfoTxt2        dc.b $cd // M                    // 
Mod_InfoTxt3        dc.b $c9 // I                    // 
                    dc.b $d4 // T                    // 
                    dc.b $a0 // <blank>              // 
                    dc.b $cf // O                    // 
                    dc.b $cb // K                    // 
                    dc.b $00 // EndOfText            // 
                    
.InfoColorSet       lda #HR_YellowYellow            // game message color
                    sta Mod_ColorMsg
XmitInfoX           jmp ColorMsg                    // 
// ------------------------------------------------------------------------------------------------------------- //
// DiskRW            Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
DiskRW              subroutine
                    lda #$00
                    sta SPENA                       // VIC 2 - $D015 = Sprite Enable
                    
.SetDiscCmd         lda LR_LevelNoDisk              // target level no
                    ldx #$08                        // drive no
                    jsr SetDiskCmd
                    bcs DiskError                   // disk error so DiskError
                    
.GetMode            lda LR_DiskAction               // read/write/init
                    lsr a
.ReadBlock          bcs ExecDiskCmdRead
                    
                    lsr a
.InitDisk           bcc .ClearDataI
                    
.WriteBlock         jmp ExecDiskCmdWrite
                    
.ClearDataI         ldy #NoTileBlank
                    tya
.ClearData          sta LR_HiScore,y                // clear high score storage
                    sta LR_LvlDataSavLod,y          // clear level storage
                    iny
                    bne .ClearData
                    
                    lda #LR_LevelDiskMax            // 149 blocks to write
                    sta LR_LevelNoDisk              // 000-149
                    jsr CLALL                       // KERNAL - $FFE7 = Close all Files
                    
.PutClearedData     lda #LR_DiskWrite               // write 150 empty levels to disk
                    jsr ControlDiskOper
                    
                    dec LR_LevelNoDisk              // 000-149
                    lda LR_LevelNoDisk              // 000-149
                    cmp #$ff
                    bne .PutClearedData
                    
                    ldy #LR_HiScoreIdLen            // length lr id
.SetDiskID          lda TabLrDiskId,y               // lr disk id=DANE BIGHAM
                    sta LR_HiScoreDiskId,y          // store as lr disk id in high score data block
                    dey
                    bpl .SetDiskID
                    
                    iny                             // $00 - LR_DiskNoData
                    sty LR_HiScoreDiskUM            // offset indicator store in high score block
.PutClearedScore    lda #LR_DiskWrite
                    jsr GetPutHiScores              // Target: $1100-$11ff
                    
DiskRWX             rts
// ------------------------------------------------------------------------------------------------------------- //
TabLrDiskId         dc.b $c4 // D
                    dc.b $c1 // A
                    dc.b $ce // N
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $c2 // B
                    dc.b $c9 // I
                    dc.b $c7 // G
                    dc.b $c8 // H
                    dc.b $c1 // A
                    dc.b $cd // M
// ------------------------------------------------------------------------------------------------------------- //
DiskError           jmp StartGraphicOut
// ------------------------------------------------------------------------------------------------------------- //
// ExecDiskCmdRead   Function: Generate Command for Disk Block Read
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ExecDiskCmdRead     subroutine
                    lda #"1"                        //
                    sta BlkRWCmd                    // u1=read
                    jsr CLRCHN                      // KERNAL - $FFCC = Restore Default Devices
                    
                    ldx #$0f                        // command channel
                    jsr CHKOUT                      // KERNAL - $FFC9 = Define an Output Channel
                    bcs DiskError
                    
                    ldy #$00
.CmdOut             lda BlkRWCmdString,y            // u1:02_0_tt_ss
                    beq .ChkDiskCC
                    
                    jsr CHROUT                      // KERNAL - $FFD2 = Output a Character
                    iny
                    jmp .CmdOut
                    
.ChkDiskCC          jsr CheckDiskCC
                    jsr CLRCHN                      // KERNAL - $FFCC = Restore Default Devices
                    ldx #$02                        // data channel
                    jsr CHKIN                       // KERNAL - $FFC6 = Define an Input Channel
                    bcs DiskError
                    
                    jsr CHRIN                       // KERNAL - $FFCF = Input a Character
                    
.ChkMirror          lda LR_Mirror                   // .hbu012. - ceck mirror flag
.GetMirror          bmi MirrorLevel                 // .hbu012. - read in the level mirrored
                    
                    ldy #$00
.ChrIn              jsr CHRIN                       // KERNAL - $FFCF = Input a Character
                    sta LR_LvlDataSavLod,y          // get disk data byte
Mod_GetDiskByte     equ *-1
                    iny
                    bne .ChrIn
                    
ExecDiskCmdReadX    jmp ResetDisk
// ------------------------------------------------------------------------------------------------------------- //
// ExecDiskCmdWrite   Function: Generate Command for Disk Block Write
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ExecDiskCmdWrite    subroutine
                    lda #"2"
                    sta BlkRWCmd                    // u2=write
                    jsr CLRCHN                      // KERNAL - $FFCC = Restore Default Devices
                    
                    ldx #$02                        // data channel
                    jsr CHKOUT                      // KERNAL - $FFC9 = Define an Output Channel
                    bcs DiskError
                    
                    ldy #$00
.ChrOut             lda LR_LvlDataSavLod,y          // put data byte
Mod_PutDiskByte     equ *-1
                    jsr CHROUT                      // KERNAL - $FFD2 = Output a Character
                    iny
                    bne .ChrOut
                    jsr CLRCHN                      // KERNAL - $FFCC = Restore Default Devices
                    
                    ldx #$0f                        // command channel
                    jsr CHKOUT                      // KERNAL - $FFC9 = Define an Output Channel
                    
                    ldy #$00
.CmdOut             lda BlkRWCmdString,y            // u2:02_0_tt_ss
                    beq .ChkDiskCC
                    
                    jsr CHROUT                      // KERNAL - $FFD2 = Output a Character
                    
                    iny
                    jmp .CmdOut
                    
.ChkDiskCC          jsr CheckDiskCC
                    
CalcDiskCmdX        jmp ResetDisk
// ------------------------------------------------------------------------------------------------------------- //
// MirrorLevel       Function: Load mirrored level from disk
//                   Parms   : 
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MirrorLevel         subroutine
                    ldx #LR_ScrnMaxRows + 1
.InitCol            ldy #LR_ScrnMaxCols / 2
                    
.GetChr             jsr CHRIN                       // get a chr from disk
                    sta LR_Work                     // save
                    lsr LR_Work                     // shift right nybble to the left
                    lsr LR_Work
                    lsr LR_Work
                    lsr LR_Work
                    asl                             // shift left nybble to the right
                    asl
                    asl
                    asl
                    ora LR_Work                     // insert former right nybble to the left
.MirrorOut          sta LR_LvlDataSavLod,y          // store swapped level byte
..ModMirrorOut      equ *-2
                    dey
                    bpl .GetChr
                    
.SetNextRow         lda ..ModMirrorOut
                    clc
                    adc #$0e
                    sta ..ModMirrorOut
                    
.SetNextCol         dex
                    bne .InitCol
                    
.InitXtra           ldy #$00                        // xtra level data must not be swapped
                    ldx #$1f
.GetXtraData        jsr CHRIN
                    sta LR_LevelXtra,y
                    iny
                    dex
                    bne .GetXtraData
                    
.PtrReset           lda #<LR_LvlDataSavLod          // reset mirror out
                    sta ..ModMirrorOut
                    
MirrorLevelX        jmp ResetDisk
// ------------------------------------------------------------------------------------------------------------- //
// SetDiskCmd        Function: Generate the block access command 
//                   Parms   : ac=level_no xr=drive_no
//                   Returns : carry clear=ok  carry set=disc error
// ------------------------------------------------------------------------------------------------------------- //
SetDiskCmd          subroutine
                    sta LR_DiscCmdLevel
                    stx LR_DiscCmdDriveNo
                    
                    jsr CLALL                       // KERNAL - $FFE7 = Close all Files
                    
                    lda LR_DiscCmdLevel             // 000-149
                    and #$0f                        // isolate right nybble for sector calculation
                    tax
                    lda TabSecHi,x
.PutSectorHi        sta BlkRWSecHi
                    lda TabSecLo,x
.PutSectorLo        sta BlkRWSecLo
                    
                    lda LR_DiscCmdLevel             // 000-149
                    lsr a                           // isolate left nybble for track calculation
                    lsr a
                    lsr a
                    lsr a
                    tax
                    lda TabTrkHi,x
.PutTrackHi         sta BlkRWTrkHi
                    lda TabTrkLo,x
.PutTrackLo         sta BlkRWTrkLo
                    
.CmdChannel         lda #$00
                    jsr SETNAM                      // KERNAL - $FFBD = Set Filename Parameters
                    
                    lda #$0f
                    ldx LR_DiscCmdDriveNo
                    ldy #$0f
                    jsr SETLFS                      // KERNAL - $FFBA = Set Logical File Parameters
                    jsr OPEN                        // KERNAL - $FFC0 = Open a Logical File
                    bcs SetDiskCmdX                 // disk error exit
                    
.DataChannel        lda #$01                        // length data set name
                    ldx #<FileNameString            // '#'
                    ldy #>FileNameString
                    jsr SETNAM                      // KERNAL - $FFBD = Set Filename Parameters
                    
                    lda #$02
                    ldx LR_DiscCmdDriveNo
                    ldy #$02
                    jsr SETLFS                      // KERNAL - $FFBA = Set Logical File Parameters
                    jsr OPEN                        // KERNAL - $FFC0 = Open a Logical File
                    
SetDiskCmdX         rts
// ------------------------------------------------------------------------------------------------------------- //
FileNameString      dc.b $23 // #
DiskInitString      dc.b $55 // u
                    dc.b $2b // +
                    dc.b $0d // <enter>
                    dc.b $00 // <end>
                    
BlkRWCmdString      dc.b $55 // u
BlkRWCmd            dc.b $31 // 1
                    dc.b $3a // :
                    dc.b $30 // 0
                    dc.b $32 // 2
                    dc.b $20 // <blank>
                    dc.b $30 // 0
                    dc.b $20 // <blank>
BlkRWTrkHi          dc.b $30 // 0 - Track
BlkRWTrkLo          dc.b $33 // 3 - Track
                    dc.b $20 // <blank>
BlkRWSecHi          dc.b $30 // 0 - Sector
BlkRWSecLo          dc.b $30 // 0 - Sector
                    dc.b $0d // <enter>
                    dc.b $00 // <end>
// ------------------------------------------------------------------------------------------------------------- //
TabTrkHi            dc.b $30, $30, $30, $30, $30, $30, $30, $31, $31, $31, $31, $31, $31, $31, $31, $31
TabTrkLo            dc.b $33, $34, $35, $36, $37, $38, $39, $30, $31, $32, $33, $34, $35, $36, $37, $39 // omit dir
                    
TabSecHi            dc.b $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $31, $31, $31, $31, $31, $31
TabSecLo            dc.b $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $30, $31, $32, $33, $34, $35
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
CheckDiskCC         subroutine
                    jsr CLRCHN                      // KERNAL - $FFCC = Restore Default Devices
                    
                    ldx #$0f
                    jsr CHKIN                       // KERNAL - $FFC6 = Define an Input Channel
                    jsr CHRIN                       // KERNAL - $FFCF = Input a Character
                    
                    sta LRZ_Work
                    jsr CHRIN                       // KERNAL - $FFCF = Input a Character
                    
                    ora LRZ_Work
                    sta LRZ_Work
.ChrIn              jsr CHRIN                       // KERNAL - $FFCF = Input a Character
                    cmp #$0d                        // ENTER
                    bne .ChrIn
                    
                    lda LRZ_Work
                    cmp #$30
                    beq CheckDiskCCX
                    
                    jmp ColdStart
                    
CheckDiskCCX        rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ResetDisk           subroutine
                    jsr CLRCHN                      // KERNAL - $FFCC = Restore Default Devices
                    
                    ldx #$0f
                    jsr CHKOUT                      // KERNAL - $FFC9 = Define an Output Channel
                    
                    ldy #$00
.CpyCmd             lda DiskInitString,y            // u+
                    beq ResetDiskX
                    
                    jsr CHROUT                      // KERNAL - $FFD2 = Output a Character
                    
                    iny
                    jmp .CpyCmd
                    
ResetDiskX          jmp CLALL                       // KERNAL - $FFE7 = Close all Files
// ------------------------------------------------------------------------------------------------------------- //
// CheckLevel        Function:
//                   Parms   : $03 set to $ff - let the first compare always work
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
CheckLevel          subroutine
                    lda #$00                        // off
                    sta SPENA                       // VIC 2 - $D015 = Sprite Enable
                    
                    ldy #LR_ScrnMaxRows             // $0f - max 15 rows => start at bottom of screen
                    sty LRZ_ScreenRow               // screen row  (00-0f)
                    
.SetLevelPtr        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    
                    ldy #LR_ScrnMaxCols             // start at end of each line = $1b - max 27 cols
                    sty LRZ_ScreenCol               // screen col  (00-1b)
                    
.GetLevelByte       lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    ldx LR_LevelCtrl                // level display control  $00=prepared copy already at $4000-$5fff
                    beq .ToGoGfxOutPrep
                    
.ChkXitLadder       cmp #NoTileLadderSec            // hidden ladder
                    bne .ChkGold
                    
                    ldx LR_NumXitLadders            // # hidden ladders
                    cpx #LR_NumXitLdrsMax           // 
                    bcs .SetEmptyByte
                    
.IncXitLadder       inc LR_NumXitLadders            // count  - inc no of hidden ladders
                    
.PutXitLadderAdr    inx
                    lda LRZ_ScreenRow               // screen row  (00-0f)
                    sta LR_TabXitLdrRow,x           // adr row hidden ladders tab
                    tya
                    sta LR_TabXitLdrCol,x           // adr column hidden ladder tab
                    
.SetEmptyByte       lda #NoTileBlank                // blank for hidden ladder/enemy
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
.ToGoGfxOutPrep     beq .GoGfxOutPrep               // always
                    
.ChkGold            cmp #NoTileGold
                    bne .ChkEnemy
                    
.IncGold            inc LR_Gold2Get                 // count  - inc no of gold to get
                    bne .GoGfxOutPrep
                    
.ChkEnemy           cmp #NoTileEnemy
                    bne .ChkLodeRunner
                    
                    ldx LR_EnmyNo                   // number of enemies
.ChkEnemyMax        cpx #LR_EnmyNoMax               // max 5
                    bcs .SetEmptyByte               // geater/equal
                    
.IncEnemy           inc LR_NoEnemy2Move             // count - inc no of enemies to move
                    inc LR_EnmyNo                   // count - inc no of enemies
                    
.PutEnemyData       inx
                    tya
.PutEnemyCol        sta LR_TabEnemyCol,x            // adr column enemies                  
                    lda LRZ_ScreenRow               // screen row  (00-0f)
.PutEnemyRow        sta LR_TabEnemyRow,x            // adr row enemies
                    
                    lda #$00
.PutEnemyGold       sta LR_TabEnemyGold,x           // enemy has gold tab
.PutEnemyNo         sta LR_TabEnemySprNo,x          // actual enemy sprite number
                    
                    lda #$02                        // center to
.PutEnemyCenter     sta LR_TabEnemyPosLR,x          // enemy pos on image left/right tab
                    sta LR_TabEnemyPosUD,x          // enemy pos on image up/down tab
                    
.ClrEnemyGfx        lda #NoTileBlank
                    sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    jsr ImageOut2Prep               // direct output to preparation screen
                    lda #NoTileEnemy
.SetEnemyGfx        bne .GoGfxOutPrep               // always
                    
.GoSetLevelPtr      bpl .SetLevelPtr
.GoGetLevelByte     bpl .GetLevelByte
                    
.ChkLodeRunner      cmp #NoTileLodeRunner
                    bne .ChkTrap
                    
                    ldx LRZ_LodeRunCol              // actual col lode runner
.ChkLodeRrExist     bpl .SetEmptyByte               // one lr found already so blank out this one
                    
.SetLodeRrCol       sty LRZ_LodeRunCol              // actual col lode runner
                    
                    ldx LRZ_ScreenRow               // screen row  (00-0f)
.SetLodeRrRow       stx LRZ_LodeRunRow              // actual row lode runner
                    
.SetLodeRrCenter    ldx #$02                        // center to
                    stx LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
                    stx LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    
.SetLodeRrSprtNo    ldx #NoLR_RunRiMin
                    stx LRZ_LodeRunSpriteNo         // lr sprite number
                    
                    lda #NoTileBlank
                    sta (LRZ_XLvlOriPos),y          // clear lr in original level data - without lr/en replacements/holes
.ClrLodeRrGfx       jsr ImageOut2Prep               // direct output to preparation screen
                    lda #NoSprite_RuRi00            // .hbu008.
.SetLodeRrGfx       bne .GoGfxOutPrep               // always
                    
.ChkTrap            cmp #NoTileWallTrap
                    bne .GoGfxOutPrep
                    
                    lda #NoTileWallWeak
                    
.GoGfxOutPrep       jsr ImageOut2Prep               // direct output to preparation screen
                    
.SetPrevCol         dec LRZ_ScreenCol               // next screen col  (00-1b) bottom up
                    ldy LRZ_ScreenCol               // screen col  (00-1b)
                    bpl .GoGetLevelByte
                    
.SetPrevRow         dec LRZ_ScreenRow               // next screen row  (00-0f) bottom up
                    ldy LRZ_ScreenRow               // screen row  (00-0f)
                    bpl .GoSetLevelPtr
                    
                    lda LR_LevelCtrl                // level display control  $00=prepared copy already at $4000-$5fff
                    beq ScreenPrep2Disp             // copy prepared hires screen data to display screen
                    
                    lda LRZ_LodeRunCol              // actual col lode runner
                    bpl ResetEnmyLodeR              // lode runner tile found
                    
.SetError           sec                             // no lode runner tile found
CheckLevelX         rts
// ------------------------------------------------------------------------------------------------------------- //
// ScreenPrep2Disp   Function: Copy prepared HiRes Screen Data to HiRes Display Screen
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ScreenPrep2Disp     subroutine
                    lda LR_GameCtrl                 // .hbu001. - $00=start $01=demo $02=game $03=play_level $05=edit
                    cmp #LR_GameEdit                // 
                    beq .ChkMsg                     // .hbu001. - edit colors already set
                    
                    jsr ColorLevelDyn               // .hbu001. - get new colors every 10th level
                    jsr ColorLevel                  // .hbu001. - set new colors
                    
.ChkMsg             lda LR_ScrnMCMsg - 1            // .hbu007. - status line msg color game
                    cmp LR_ScrnMCMsg                // .hbu007. - status line msg part colour
                    bne .Init
                    
                    jsr ClearMsg                    // .hbu007.
                    
.Init               lda #>LR_ScrnHiReDisp           // to:   display hires screen
                    sta $12
                    lda #>LR_ScrnHiRePrep           // from: prepare hires screen for direct output
                    sta $10
                    
                    lda #$00
                    sta $11
                    sta $0f
                    
                    tay
.Copy               lda ($0f),y
                    sta ($11),y
                    iny
                    bne .Copy
                    
                    inc $12
                    inc $10
                    
                    ldx $10
                    cpx #>(LR_ScrnHiRePrep + $2000) // end of screen data $5fff reached
                    bcc .Copy                       // no
                    
                    jsr ColorStatus                 // .hbu001. - after copy to avoid a recolor when VictoryMsg is still set
                    
.SetNoError         clc
                    
ScreenPrep2DispX    rts
// ------------------------------------------------------------------------------------------------------------- //
// ResetEnmyLodeR    Function: Blank out Lode Runner and Enemies in preparation screen
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ResetEnmyLodeR      subroutine
                    lda #>LR_ScrnHiRePrep           // $40
                    sta LRZ_GfxScreenOut            // target output  $20=$2000 $40=$4000
                    jsr BaseLines
                    jsr ScreenPrep2Disp             // copy prepared hires screen data to display screen
                    
                    lda #>LR_ScrnHiReDisp           // $20
                    sta LRZ_GfxScreenOut            // target output  $20=$2000 $40=$4000
                    
.SetMaxRows         ldy #LR_ScrnMaxRows             // $0f - max 15 rows
                    sty LRZ_ScreenRow               // screen row  (00-0f)
                    
.SetLevelDataPtr    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi
                    
.SetMaxCols         ldy #LR_ScrnMaxCols             // $1b - max 27 cols
                    sty LRZ_ScreenCol               // screen col  (00-1b)
                    
.GetData            lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
.ChkLodeRunner      cmp #NoTileLodeRunner
                    beq .SetBlank
                    
.ChkEnemy           cmp #NoTileEnemy
                    bne .NextOutCol
                    
.SetBlank           lda #NoTileBlank                // blank substitution
                    jsr ImageOut2Prep               // direct output to preparation screen
                    
.NextOutCol         dec LRZ_ScreenCol               // screen col  (00-1b)
                    ldy LRZ_ScreenCol               // screen col  (00-1b)
                    bpl .GetData
                    
.NextOutRow         dec LRZ_ScreenRow               // screen row  (00-0f)
                    ldy LRZ_ScreenRow               // screen row  (00-0f)
                    bpl .SetLevelDataPtr
                    
                    clc
ResetEnmyLodeRX     rts
// ------------------------------------------------------------------------------------------------------------- //
// MoveLodeRunner    Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MoveLodeRunner      subroutine
                    lda #LR_GetGoldGot
                    sta LR_GetGold                  // get gold  $00=just gets it
                    
                    lda LR_Shoots                   // $00=no $01=right $ff=left
                    beq .MoveLR
                    bpl .GoFireRightLR
                    
.GoFireLeftLR       jmp LRFireLeft
.GoFireRightLR      jmp LRFireRight
                    
.MoveLR             ldy LRZ_LodeRunRow              // actual row lode runner
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes  = data �under� lr
                    cmp #NoTileLadder
                    beq .GoChkFallDown
                    
                    cmp #NoTilePole
                    bne .GetPosUD
                    
                    lda LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    cmp #$02                        // in middle of screen image
                    beq .GoChkFallDown
                    
.GetPosUD           lda LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    cmp #$02                        // in middle of screen image
                    bcc .SetFallDown
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    cpy #LR_ScrnMaxRows             // $0f - max 15 rows
                    beq .GoChkFallDown              // bottom reached
                    
                    lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlModRowHi+1,y        // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModifyBelow     sta LRZ_XLvlModRowHi
                    lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginBelow     sta LRZ_XLvlOriRowHi
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes + 1
                    cmp #$00                        // nothing
                    beq .SetFallDown
                    
                    cmp #NoTileEnemy
                    beq .GoChkFallDown
                    
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    cmp #NoTileWallWeak
                    beq .GoChkFallDown
                    
                    cmp #NoTileWallHard
                    beq .GoChkFallDown
                    
                    cmp #NoTileLadder
                    bne .SetFallDown
                    
.GoChkFallDown      jmp .EndFallDown
                    
.SetFallDown        lda #LR_Falls
                    sta LR_FallsDown                // $00=fall $20=no fall $ff=init
                    dec LR_FallBeep
                    jsr GetLRGfxOff
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    
                    lda #NoLR_FallLe
                    ldx $08                         // control shooter mode
                    bmi .SetSpriteNo
                    
                    lda #NoLR_FallRi
                    
.SetSpriteNo        sta LRZ_LodeRunSpriteNo         // lr sprite number
                    jsr MovLRWaitPosX
                    
                    inc LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    lda LRZ_LodeRunOnImgPosUD
                    cmp #$05                        // max
                    bcs .InitPosUD
                    
                    jsr MovLRGold                   // wait for center and handle the gold
                    jmp MovLRKill
                    
.InitPosUD          lda #$00
                    sta LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify01        sta LRZ_XLvlModRowHi
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin01        sta LRZ_XLvlOriRowHi
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    cmp #NoTileWallWeak
                    bne .Store
                    
                    lda #NoTileBlank                // empty substitution
                    
.Store              sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    inc LRZ_LodeRunRow              // actual row lode runner
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModifyBelow01   sta LRZ_XLvlModRowHi
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    lda #NoTileLodeRunner
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    jmp MovLRKill
                    
.EndFallDown        lda LR_FallsDown                // $00=fall $20=no fall $ff=init
                    bne .Always
                    
.Always             lda #LR_FallsNo                 // end
                    sta LR_FallsDown                // $00=fall $20=no fall $ff=init
                    
                    jsr GetPlayCmd                  // test in game commands
                    
                    lda LR_JoyUpDo
.ChkMoveUp          cmp #LR_JoyMoveUp               // move up
                    bne .ChkMoveDown
                    
.MoveUp             jsr MovLRUp
                    bcs .ChkMoveLeft
                    rts
                    
.ChkMoveDown        cmp #LR_JoyMoveDo               // move down
                    bne .ChkFireLeft
.MoveDown           jsr LRMoveDown
                    bcs .ChkMoveLeft
                    rts
                    
.ChkFireLeft        cmp #LR_JoyFireLe               // fire left
                    bne .ChkFireRight
.FireLeft           jsr MovLRFireLeft
                    bcs .ChkMoveLeft
                    rts
                    
.ChkFireRight       cmp #LR_JoyFireRi               // fire right
                    bne .ChkMoveLeft
.FireRight          jsr MovLRFireRight
                    bcs .ChkMoveLeft
                    rts
                    
.ChkMoveLeft        lda LR_JoyLeRi
                    cmp #LR_JoyMoveLe               // move left
                    bne .ChkMoveRight
                    
.MoveLeft           jmp MovLRLeft
                    
.ChkMoveRight       cmp #LR_JoyMoveRi               // move right
                    bne MoveLodeRunnerX
.MoveRight          jmp LRMoveRight
                    
MoveLodeRunnerX     rts
// ------------------------------------------------------------------------------------------------------------- //
MovLRLeft           subroutine
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    ldx LRZ_LodeRunOnImgPosLR
                    cpx #$03
                    bcs MovLRLeftABit               // not yet in center so MovLRLeftABit
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    beq MovLRLeftX
                    
                    dey
                    lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    cmp #NoTileWallHard
                    beq MovLRLeftX
                    
                    cmp #NoTileWallWeak
                    beq MovLRLeftX
                    
                    cmp #NoTileWallTrap
                    bne MovLRLeftABit
                    
MovLRLeftX          rts
// ------------------------------------------------------------------------------------------------------------- //
MovLRLeftABit       subroutine
                    jsr GetLRGfxOff
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    
                    lda #$ff
                    sta $08                         // control shooter mode
                    jsr MovLRWaitPosY
                    
                    dec LRZ_LodeRunOnImgPosLR       // lr pos on image left/right = one step left
                    bpl .Gold                       // move from actual to next left field not yet complete
                    
.NewField           ldy LRZ_LodeRunCol              // actual col lode runner
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    cmp #NoTileWallWeak
                    bne .Store
                    
                    lda #NoTileBlank                // empty substitution
                    
.Store              sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    dec LRZ_LodeRunCol              // actual col lode runner
                    dey
                    lda #NoTileLodeRunner
.SetLR              sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    lda #$04                        // max right to
                    sta LRZ_LodeRunOnImgPosLR       //   lr pos on image left/right
                    bne .SetNextPos                 // always
                    
.Gold               jsr MovLRGold                   // wait for center and handle the gold
                    
.SetNextPos         ldy LRZ_LodeRunCol              // actual col lode runner
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    cmp #NoTilePole
                    beq .PoleImage
                    
.RunImage           lda #NoLR_RunLeMin              // low image no
                    ldx #NoLR_RunLeMax              // high image no
                    bne .OutImage
                    
.PoleImage          lda #NoLR_PoleLeMin             // low image no
                    ldx #NoLR_PoleLeMax             // high image no
.OutImage           jsr MovLRSetImg
                    
MovLRLeftABitX      jmp MovLRKill
// ------------------------------------------------------------------------------------------------------------- //
LRMoveRight         subroutine
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    
                    ldx LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
                    cpx #$02
                    bcc MovLRRightABit              // not yet in center so MovLRRightABit
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    cpy #LR_ScrnMaxCols             // $1b - max 27 cols
                    beq LRMoveRightX
                    
                    iny
                    lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    cmp #NoTileWallHard
                    beq LRMoveRightX
                    
                    cmp #NoTileWallWeak
                    beq LRMoveRightX
                    
                    cmp #NoTileWallTrap
                    bne MovLRRightABit
                    
LRMoveRightX        rts
// ------------------------------------------------------------------------------------------------------------- //
MovLRRightABit      subroutine
                    jsr GetLRGfxOff
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    
                    lda #$01
                    sta $08                         // control shooter mode
                    jsr MovLRWaitPosY
                    
                    inc LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
                    lda LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
                    cmp #$05                        // max
                    bcc .Gold
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    cmp #NoTileWallWeak
                    bne .Store
                    
                    lda #NoTileBlank                // empty substitution
.Store              sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    inc LRZ_LodeRunCol              // actual col lode runner
                    iny
                    lda #NoTileLodeRunner
.SetLR              sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    lda #$00
                    sta LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
                    beq .SetNextPos                 // always
                    
.Gold               jsr MovLRGold                   // wait for center and handle the gold
                    
.SetNextPos         ldy LRZ_LodeRunCol              // actual col lode runner
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    cmp #NoTilePole
                    beq .PoleImage
                    
.RunImage           lda #NoLR_RunRiMin              // low image no
                    ldx #NoLR_RunRiMax              // high image no
                    bne .OutImage
                    
.PoleImage          lda #NoLR_PoleRiMin             // low image no
                    ldx #NoLR_PoleRiMax             // high image no
.OutImage           jsr MovLRSetImg
                    
MovLRRightABitX     jmp MovLRKill
// ------------------------------------------------------------------------------------------------------------- //
MovLRUp             subroutine
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes = data �under� lr
                    cmp #NoTileLadder
                    beq MovLRUpABit
                    
                    ldy LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    cpy #$03                        // in center
                    bcc MovUpXitSetCarry            // no
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginBelow     sta LRZ_XLvlOriRowHi
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes + 1 = data below lr
                    cmp #NoTileLadder
                    beq MovUpGetGfxOff
                    
MovUpXitSetCarry    sec
MovLRUpX            rts
// ------------------------------------------------------------------------------------------------------------- //
MovLRUpABit         subroutine
                    ldy LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    cpy #$03                        // in center
                    bcs MovUpGetGfxOff              // equal/higher
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    beq MovUpXitSetCarry
                    
                    lda TabExLvlDatRowLo-1,y        // expanded level data row pointer lo
                    sta LRZ_XLvlModRowLo
                    lda TabExLvlModRowHi-1,y        // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModifyAbove     sta LRZ_XLvlModRowHi
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes - 1 = data above lr
                    cmp #NoTileWallWeak
                    beq MovUpXitSetCarry
                    
                    cmp #NoTileWallHard
                    beq MovUpXitSetCarry
                    
                    cmp #NoTileWallTrap
                    beq MovUpXitSetCarry
                    
MovUpGetGfxOff      jsr GetLRGfxOff
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    jsr MovLRWaitPosX
                    
                    dec LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    bpl MovUpDownGold
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    cmp #NoTileWallWeak
                    bne .Store
                    
                    lda #NoTileBlank                // empty substitution
                    
.Store              sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    dec LRZ_LodeRunRow              // actual row lode runner
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModifyAbove01   sta LRZ_XLvlModRowHi
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    lda #NoTileLodeRunner
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    lda #$04
                    sta LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    bne MovUpDown                   // always
                    
MovUpDownGold       jsr MovLRGold                   // wait for center and handle the gold
                    
MovUpDown           lda #NoLR_LadderMin             // low image no
                    ldx #NoLR_LadderMax             // high image no
                    jsr MovLRSetImg
                    jsr MovLRKill
                    
                    clc
MovLRUpABitX        rts
// ------------------------------------------------------------------------------------------------------------- //
LRMoveDown          subroutine
                    ldy LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    cpy #$02                        // in center of screen image
                    bcc MovLRDownABit
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    cpy #LR_ScrnMaxRows             // $0f - max 15 rows
                    bcs .XitSetCarry
                    
                    lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    lda TabExLvlModRowHi+1,y        // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModifyBelow     sta LRZ_XLvlModRowHi
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes + 1
                    cmp #NoTileWallHard
                    beq .XitSetCarry
                    
                    cmp #NoTileWallWeak
                    bne MovLRDownABit
                    
.XitSetCarry        sec
LRMoveDownX         rts
// ------------------------------------------------------------------------------------------------------------- //
MovLRDownABit       subroutine
                    jsr GetLRGfxOff
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    
                    jsr MovLRWaitPosX
                    
                    inc LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    lda LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    cmp #$05                        // center screen image
                    bcc .GoMovUpDownGold
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    cmp #NoTileWallWeak
                    bne .Store
                    
                    lda #NoTileBlank                // empty substitution
                    
.Store              sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    inc LRZ_LodeRunRow              // actual row lode runner
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModifyBelow     sta LRZ_XLvlModRowHi
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    lda #NoTileLodeRunner
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    lda #$00
                    sta LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    jmp MovUpDown
                    
.GoMovUpDownGold    jmp MovUpDownGold
                    
FireLeftNone        jmp OutLRFireLeftNo
// ------------------------------------------------------------------------------------------------------------- //
MovLRFireLeft       subroutine
                    lda #LR_ShootsLe
                    sta LR_Shoots                   // $00=no $01=right $ff=left
                    sta LR_JoyUpDo
                    sta LR_JoyLeRi
                    lda #$00
                    sta $54                         // lr actual sprite number
                    
LRFireLeft          ldy LRZ_LodeRunRow              // actual row lode runner
                    cpy #LR_ScrnMaxRows             // $0f - max 15 rows
                    bcs FireLeftNone                // no walls left for shooting
                    
                    iny
                    jsr SetCtrlDataPtr              // set both expanded level data pointers
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    beq FireLeftNone                // leftmost position
                    
                    dey
                    lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    cmp #NoTileWallWeak
                    bne FireLeftNone
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    jsr SetCtrlDataPtr              // set both expanded level data pointers
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    dey
                    lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    cmp #NoTileBlank                // empty
                    bne OutLRFireLeft
                    
                    jsr GetLRGfxOff
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    
                    jsr MovLRWaitPosX
                    jsr MovLRWaitPosY
                    
                    ldx $54                         // lr actual sprite number
                    lda #NoLR_RunLeMin
                    
                    cpx #NoLR_FireLe
                    bcs .StoreSpriteNo
                    
                    lda #NoLR_FireLe
                    
.StoreSpriteNo      sta LRZ_LodeRunSpriteNo
                    jsr MovLRKill
                    
                    ldx $54                         // lr actual sprite number
                    cpx #$0c
                    beq MovLRSetHoleLe
                    
                    cpx #$00
                    beq .GetShootImage2
                    
.GetShootImage1     lda TabShootNoSpark-1,x
                    pha
                    
                    ldx LRZ_LodeRunCol              // actual col lode runner
                    dex
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    jsr GetColRowGfxOff             // offsets in xr=col yr=row
                    
                    pla
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    
                    ldx $54                         // lr actual sprite number
.GetShootImage2     lda TabShootNoSpark,x
                    pha                             // save image number
                    
                    ldx LRZ_LodeRunCol              // actual col lode runner
                    dex
                    stx LRZ_ScreenCol               // screen col  (00-1b)
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    sty LRZ_ScreenRow               // screen row  (00-0f)
                    jsr GetColRowGfxOff             // offsets in xr=col yr=row
                    
                    pla                             // restore image number
                    jsr ImageOutXtra                // set images on game screen (sprites/shoots/hidden ladders)
                    
                    ldx $54                         // lr actual sprite number
.GetMeltImage       lda TabShootMeltGrnd,x
                    inc LRZ_ScreenRow               // screen row  (00-0f)
.PutMeltImage       jsr ImageOut2Disp               // direct output to display screen
                    
                    inc $54                         // lr actual sprite number
                    
                    clc
MovLRFireLeftX      rts
// ------------------------------------------------------------------------------------------------------------- //
OutLRFireLeft       subroutine
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    iny                             // +1
                    sty LRZ_ScreenRow               // screen row  (00-0f)
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    dey
                    sty LRZ_ScreenCol               // screen col  (00-1b)
                    
                    lda #NoTileWallWeak
                    jsr ImageOut2Disp               // direct output to display screen
                    
                    ldx $54                         // lr actual sprite number
                    beq OutLRFireLeftNo
                    
                    dex
.GetShootImage      lda TabShootNoSpark,x
                    pha
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    ldx LRZ_LodeRunCol              // actual col lode runner
                    dex
                    jsr GetColRowGfxOff             // offsets in xr=col yr=row
                    
                    pla
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    
OutLRFireLeftNo     lda #LR_ShootsNo
                    sta LR_Shoots                   // $00=no $01=right $ff=left
                    
                    sec
OutLRFireLeftX      rts
// ------------------------------------------------------------------------------------------------------------- //
MovLRSetHoleLe      subroutine
                    ldx LRZ_LodeRunCol              // actual col lode runner
                    dex
                    
MovLRSetHoleLeX     jmp MovLRSetHole
// ------------------------------------------------------------------------------------------------------------- //
GoSetNoShoot        jmp SetNoShoot
// ------------------------------------------------------------------------------------------------------------- //
MovLRFireRight      subroutine
                    lda #LR_ShootsRi
                    sta LR_Shoots                   // $00=no $01=right $ff=left
                    sta LR_JoyUpDo
                    sta LR_JoyLeRi
                    lda #$0c
                    sta $54                         // lr actual sprite number
                    
LRFireRight         ldy LRZ_LodeRunRow              // actual row lode runner
                    cpy #LR_ScrnMaxRows             // $0f - max 15 rows
                    bcs GoSetNoShoot
                    
                    iny
                    jsr SetCtrlDataPtr              // set both expanded level data pointers
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    cpy #LR_ScrnMaxCols             // $1b - max 27 cols
                    bcs GoSetNoShoot
                    
                    iny
                    lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    cmp #NoTileWallWeak
                    bne GoSetNoShoot
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    jsr SetCtrlDataPtr              // set both expanded level data pointers
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    iny
                    lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    cmp #NoTileBlank                // empty
                    bne MovLRFireNoHole
                    
                    jsr GetLRGfxOff
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    jsr MovLRWaitPosX
                    jsr MovLRWaitPosY
                    
                    ldx $54                         // lr actual sprite number
                    lda #NoLR_RunRiMin
                    
                    cpx #$12
                    bcs .SetSprite
                    
                    lda #NoLR_FireRi
.SetSprite          sta LRZ_LodeRunSpriteNo         // lr sprite number
                    jsr MovLRKill
                    
                    ldx $54                         // lr actual sprite number
                    cpx #$18
                    beq MovLRSetHoleRi
                    
                    cpx #$0c
                    beq .GetShootImage2
                    
.GetShootImage1     lda TabShootNoSpark-1,x
                    pha
                    
                    ldx LRZ_LodeRunCol              // actual col lode runner
                    inx
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    jsr GetColRowGfxOff             // offsets in xr=col yr=row
                    
                    pla
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    
                    ldx $54                         // lr actual sprite number
.GetShootImage2     lda TabShootNoSpark,x
                    pha
                    
                    ldx LRZ_LodeRunCol              // actual col lode runner
                    inx
                    stx LRZ_ScreenCol               // screen col  (00-1b)
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    sty LRZ_ScreenRow               // screen row  (00-0f)
                    jsr GetColRowGfxOff             // offsets in xr=col yr=row
                    
                    pla
                    jsr ImageOutXtra                // set images on game screen (sprites/shoots/hidden ladders)
                    
                    inc LRZ_ScreenRow               // screen row  (00-0f)
                    ldx $54
.GetMeltImage       lda TabShootMelt,x
.PutMeltImage       jsr ImageOut2Disp               // direct output to display screen
                    
                    inc $54
                    clc
MovLRFireRightX     rts
// ------------------------------------------------------------------------------------------------------------- //
MovLRFireNoHole     subroutine
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    iny
                    sty LRZ_ScreenRow               // screen row  (00-0f)
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    iny
                    sty LRZ_ScreenCol               // screen col  (00-1b)
                    lda #NoTileWallWeak
                    jsr ImageOut2Disp               // direct output to display screen
                    
                    ldx $54                         // lr actual sprite number
                    cpx #$0c
                    beq SetNoShoot
                    
                    dex
.GetShootImage      lda TabShootNoSpark,x
                    pha
                    
                    ldx LRZ_LodeRunCol              // actual col lode runner
                    inx
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    jsr GetColRowGfxOff             // offsets in xr=col yr=row
                    
                    pla
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    
SetNoShoot          lda #LR_ShootsNo
                    sta LR_Shoots                   // $00=no $01=right $ff=left
                    
                    sec
MovLRFireNoHoleX    rts
// ------------------------------------------------------------------------------------------------------------- //
MovLRSetHoleRi      subroutine
                    ldx LRZ_LodeRunCol              // actual col lode runner
                    inx
                    
                    jmp MovLRSetHole
// ------------------------------------------------------------------------------------------------------------- //
TabSpriteNoLodeR    equ *
TabLR_RunLeMin      dc.b NoSprite_RuLe00 // $00 - run    left 01    - have lode runner sprite numbers from $01-$11
                    dc.b NoSprite_RuLe01 // $01 - run    left 02
TabLR_RunLeMax      dc.b NoSprite_RuLe02 // $02 - run    left 03
TabLR_PoleLeMin     dc.b NoSprite_PoLe00 // $03 - pole   left 01
                    dc.b NoSprite_PoLe01 // $04 - pole   left 02
TabLR_PoleLeMax     dc.b NoSprite_PoLe02 // $05 - pole   left 03
TabLR_FireLe        dc.b NoSprite_FireLe // $06 - fire   left
TabLR_FallLe        dc.b NoSprite_FallLe // $07 - fall   left
TabLR_RunRiMin      dc.b NoSprite_RuRi00 // $08 - run    right 01
                    dc.b NoSprite_RuRi01 // $09 - run    right 02
TabLR_RunRiMax      dc.b NoSprite_RuRi02 // $0a - run    right 03
TabLR_PoleRiMin     dc.b NoSprite_PoRi00 // $0b - pole   right 01
                    dc.b NoSprite_PoRi01 // $0c - pole   right 02
TabLR_PoleRiMax     dc.b NoSprite_PoRi02 // $0d - pole   right 03
TabLR_FireRi        dc.b NoSprite_FireRi // $0e - fire   right
TabLR_FallRi        dc.b NoSprite_FallRi // $0f - fall   right
TabLR_LadderMin     dc.b NoSprite_Ladr00 // $10 - ladder up/down 01
TabLR_LadderMax     dc.b NoSprite_Ladr01 // $11 - ladder up/down 02
// ------------------------------------------------------------------------------------------------------------- //
NoLR_RunLeMin       equ  TabLR_RunLeMin  - TabSpriteNoLodeR
NoLR_RunLeMax       equ  TabLR_RunLeMax  - TabSpriteNoLodeR
NoLR_PoleLeMin      equ  TabLR_PoleLeMin - TabSpriteNoLodeR
NoLR_PoleLeMax      equ  TabLR_PoleLeMax - TabSpriteNoLodeR
NoLR_RunRiMin       equ  TabLR_RunRiMin  - TabSpriteNoLodeR
NoLR_RunRiMax       equ  TabLR_RunRiMax  - TabSpriteNoLodeR
NoLR_PoleRiMin      equ  TabLR_PoleRiMin - TabSpriteNoLodeR
NoLR_PoleRiMax      equ  TabLR_PoleRiMax - TabSpriteNoLodeR
NoLR_LadderMin      equ  TabLR_LadderMin - TabSpriteNoLodeR
NoLR_LadderMax      equ  TabLR_LadderMax - TabSpriteNoLodeR
                    
NoLR_FireLe         equ  TabLR_FireLe    - TabSpriteNoLodeR
NoLR_FireRi         equ  TabLR_FireRi    - TabSpriteNoLodeR
                    
NoLR_FallLe         equ  TabLR_FallLe    - TabSpriteNoLodeR
NoLR_FallRi         equ  TabLR_FallRi    - TabSpriteNoLodeR
// ------------------------------------------------------------------------------------------------------------- //
TabShootNoSpark     dc.b NoShootSpark00  // $00 - shoot spark 00
                    dc.b NoShootSpark00  // $01 - shoot spark 00
                    dc.b NoShootSpark01  // $02 - shoot spark 01
                    dc.b NoShootSpark01  // $03 - shoot spark 01
                    dc.b NoShootSpark02  // $04 - shoot spark 02
                    dc.b NoShootSpark02  // $05 - shoot spark 02
                    dc.b NoShootSpark03  // $06 - shoot spark 03
                    dc.b NoShootSpark03  // $07 - shoot spark 03
                    dc.b NoTileBlank     // $08 - tile empty
                    dc.b NoTileBlank     // $09 - tile empty
                    dc.b NoTileBlank     // $0a - tile empty
                    dc.b NoTileBlank     // $0b - tile empty
// ------------------------------------------------------------------------------------------------------------- //
TabShootMelt        dc.b NoShootMelt00   // $00 - init melt above ground 01
                    dc.b NoShootMelt00   // $01 - init melt above ground 02
                    dc.b NoShootMelt01   // $02 - init melt above ground 01
                    dc.b NoShootMelt01   // $03 - init melt above ground 02
                    dc.b NoShootSpark02  // $04 - shoot spark 02
                    dc.b NoShootSpark02  // $05 - shoot spark 02
                    dc.b NoShootSpark03  // $06 - shoot spark 03
                    dc.b NoShootSpark03  // $07 - shoot spark 03
                    dc.b NoTileBlank     // $08 - tile empty
                    dc.b NoTileBlank     // $09 - tile empty
                    dc.b NoTileBlank     // $0a - tile empty
                    dc.b NoTileBlank     // $0b - tile empty
// ------------------------------------------------------------------------------------------------------------- //
TabShootMeltGrnd    dc.b NoShootMeltGr00 // $00 - shoot melt ground 01
                    dc.b NoShootMeltGr00 // $01 - shoot melt ground 01
                    dc.b NoShootMeltGr01 // $02 - shoot melt ground 02
                    dc.b NoShootMeltGr01 // $03 - shoot melt ground 02
                    dc.b NoShootMeltGr02 // $04 - shoot melt ground 03
                    dc.b NoShootMeltGr02 // $05 - shoot melt ground 03
                    dc.b NoShootMeltGr03 // $06 - shoot melt ground 04
                    dc.b NoShootMeltGr03 // $07 - shoot melt ground 04
                    dc.b NoShootMeltGr04 // $08 - shoot melt ground 05
                    dc.b NoShootMeltGr04 // $09 - shoot melt ground 05
                    dc.b NoShootMeltGr05 // $0a - shoot melt ground 06
                    dc.b NoShootMeltGr05 // $0b - shoot melt ground 06
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ContinueDemo        subroutine
                    lda LR_KeyNew
.ChkKey             bne .Pressed
                    
                    lda CIAPRA                      // CIA 1 - $DC00 = Data Port A
                    and #$10                        // isolate fire button
.ChkFire            bne RunDemo
                    
.Pressed            lsr LR_Alive                    // kill LR ends the level immediately
                    lda #$01
                    sta LR_NumLives                 // last live used up ends the demo immediately
                    
ContinueDemoX       rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
RunDemo             subroutine
                    lda LRZ_DemoMoveTime            // duration demo move
                    bne .DoMove                     // not ended yet
                    
                    ldy #$00
.GetMove            lda (LRZ_DemoMoveDat),y         // demo data pointer
                    sta LRZ_DemoMoveType            // type of demo move  (l/r/u/d/fire)
                    
.GetTime            iny
                    lda (LRZ_DemoMoveDat),y         // demo data pointer
                    sta LRZ_DemoMoveTime            // duration demo move
                    
.IncMovePtr         lda LRZ_DemoMoveDatLo
                    clc
                    adc #$02
                    sta LRZ_DemoMoveDatLo
                    bcc .DoMove
                    inc LRZ_DemoMoveDatHi           // demo data pointer high
                    
.DoMove             lda LRZ_DemoMoveType            // type demo move  (l/r/u/d/fire)
                    and #$0f                        // isolate right nybble for up/down moves
                    tax
                    lda TabDemoJoyActn,x            // demo joystick action tab
.SetUpDo            sta LR_JoyUpDo
                    
                    lda LRZ_DemoMoveType            // type demo move  (l/r/u/d/fire)
                    lsr a                           // isolate left nybble for left/right moves
                    lsr a
                    lsr a
                    lsr a
                    tax
                    lda TabDemoJoyActn,x
.SetLeRi            sta LR_JoyLeRi
                    
.DecTime            dec LRZ_DemoMoveTime            // duration demo move
                    
RunDemoX            rts
// ------------------------------------------------------------------------------------------------------------- //
TabDemoJoyActn      dc.b LR_JoyMoveUp    // 0 - $21=up
                    dc.b LR_JoyMoveLe    // 1 - $22=left
                    dc.b LR_JoyMoveDo    // 2 - $25=down
                    dc.b LR_JoyMoveRi    // 3 - $2a=right
                    dc.b LR_JoyFireRi    // 4 - $26=fire-right
                    dc.b LR_JoyFireLe    // 5 - $1e=fire-left
                    dc.b LR_JoyMoveNone  // 6 - $00=no move
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetPlayCmd          subroutine
                    lda LR_GameCtrl                 // $00=start $01=demo $02=game $03=play_level $05=edit
                    cmp #LR_GameDemo
                    bne .GameMode
                    
.DemoMode           jmp ContinueDemo
                    
.GameMode           ldx LR_KeyNew
                    bne .ChkKeyI                    // pressed
                    
                    lda LR_ControllerTyp            // controler type  $ca=joystick  $cb=keyboard
                    cmp #LR_Keyboard
                    beq GetPlayCmdX
                    
.GoChkJoyPort       jmp ChkJoyPort
                    
.ChkKeyI            lda #LR_KeyNewNone
                    sta LR_KeyNew                   // reset actual key
                    
                    stx LRZ_WrkGetKey               // save actual key
                    
                    ldy #$ff
.ChkKey             iny
                    lda TabInGameCmdChr,y           // in game keys tab  (U F <run/stop> R A J K + - D)
                    beq .ChkCtrlType                // end of tab - no legal command key found
                    
                    cmp LRZ_WrkGetKey               // still actual key
                    bne .ChkKey
                    
                    tya
                    asl a                           // *2
                    tay
.PrepareCmd         lda TabInGameCmdSub+1,y
                    pha                             // set return address for rts
                    lda TabInGameCmdSub,y
                    pha                             // set return address for rts
                    
.DispatchCmd        rts                             // dispatch command
                    
.ChkCtrlType        lda LR_ControllerTyp            // controler type  $ca=joystick  $cb=keyboard
                    cmp #LR_Joystick
                    beq .GoChkJoyPort
                    
                    ldx LRZ_WrkGetKey               // saved actual key
                    stx LR_JoyUpDo
                    stx LR_JoyLeRi
                    
GetPlayCmdX         rts
// ------------------------------------------------------------------------------------------------------------- //
IGC_Success         subroutine
                    lda LR_ExpertMode               // .hbu017. - expert mode set after <run/stop>, <f7>, <run/stop>
                    bpl IGC_SuccessX                // .hbu017. - off
                    
.Chk_Co             lda C64_KeyFlag                 // $01=shift $02=commodore $04=ctrl
                    and #$02                        //
                    cmp #$02                        // <commodore>
                    bne IGC_SuccessX                //
                    
.SpritesOn          lda #$00                        // .hbu017.
                    sta LR_Gold2Get                 // .hbu017. - no more gold to collect
                    
IGC_SuccessX        jmp GetPlayCmd                  // .hbu017.
// ------------------------------------------------------------------------------------------------------------- //
IGC_Xmit            subroutine
                    lda LR_ExpertMode               // .hbu017. - expert mode set after <run/stop>, <f7>, <run/stop>
                    bpl IGC_XmitX                   // .hbu017. - off
                    
                    lda SPENA                       // .hbu017. - VIC 2 - $D015 = Sprite Enable
                    sta LR_Work                     // .hbu017. - save active sprites
                    
.SpritesOff         lda #$00                        // .hbu017. - Transmit the active level to drive 9
                    sta SPENA                       // .hbu017. - VIC 2 - $D015 = Sprite Enable
                    
                    jsr Xmit                        // .hbu017. - transmit the active level to drive 9
                    
.SpritesOn          lda LR_Work                     // .hbu017. - restore active sprites
                    sta SPENA                       // .hbu017. - VIC 2 - $D015 = Sprite Enable
                    
IGC_XmitX           jmp GetPlayCmd                  // .hbu017.
// ------------------------------------------------------------------------------------------------------------- //
IGC_Random          subroutine
                    lda LR_TestLevel                // .hbu023. - flag: level testmode on/off
                    bmi IGC_RandomX                 // .hbu023.
                    
                    lda #LR_NumLivesInit+1          // Z=random level mode
                    sta LR_NumLives                 // one more because of the following kill
                    lsr LR_Alive                    // $00=lr killed
                    
                    lda LR_RNDMode                  //
                    eor #LR_RNDModeOn               // toggle mode
                    sta LR_RNDMode                  // 
                    beq .Off                        // was ON
                    
.On                 jsr RNDInit                     // setup
                    jsr RND                         // get a random level no and rts
                    sta LR_LevelNoDisk
                    sta LR_LevelNoGame
                    inc LR_LevelNoGame
                    inc LR_RNDLevel                 // the real level counter
                    jmp IGC_RandomX                 //
                    
.Off                ldy #LR_LevelDiskMin            // 
                    sty LR_LevelNoDisk              //
                    iny                             //
                    sty LR_LevelNoGame              //
                    
IGC_RandomX         rts                             //
// ------------------------------------------------------------------------------------------------------------- //
IGC_NextLvl         subroutine                      //  U=play next level
                    lda LR_TestLevel                // .hbu023. - flag: level testmode on/off
                    bmi IGC_NextLvlX                // .hbu023.
                    
                    lda LR_RNDMode                  // .hbu014.
                    bpl .GoIncLevelNo               // .hbu021.
                    
.RandomLevel        jsr RND                         // .hbu014. - get a random number
                    
                    sta LR_LevelNoDisk              // .hbu014.
                    sta LR_LevelNoGame              // .hbu014.
                    inc LR_LevelNoGame              // .hbu014.
                    inc LR_RNDLevel                 // .hbu014. - the real level counter
                    jmp .Kill                       // .hbu014.
                    
.GoIncLevelNo       jsr IncGameLevelNo              // increase level number
                    
.Kill               lsr LR_Alive                    // $00=lr killed
                    inc LR_NumLives                 // compensate the previous kill
                    
.ChkExpert          lda LR_ExpertMode               // .hbu017. - expert mode set after <run/stop>, <f7>, <run/stop>
.NoCheating         bmi IGC_NextLvlX                // .hbu017. - do not set cheat flag in expert mode
                    
                    lsr LR_Cheated                  // set cheated
                    
IGC_NextLvlX        rts
// ------------------------------------------------------------------------------------------------------------- //
IGC_PrevLvl         subroutine
                    lda LR_TestLevel                // .hbu023. - flag: level testmode on/off
                    bmi IGC_PrevLvlX                // .hbu023.
                    
                    lda LR_RNDMode                  // .hbu014. - U=play next level
                    bpl .GoDecLevelNo               // .hbu021.
                    
.RandomLevel        jsr RND                         // .hbu014. -get a random number
                    
                    sta LR_LevelNoDisk              // .hbu014.
                    sta LR_LevelNoGame              // .hbu014.
                    inc LR_LevelNoGame              // .hbu014.
                    inc LR_RNDLevel                 // .hbu014. - the real level counter
                    jmp .Kill                       // .hbu014.
                    
.GoDecLevelNo       jsr DecGameLevelNo              // deccrease level number
                    
.Kill               lsr LR_Alive                    // $00=lr killed
                    inc LR_NumLives                 // one more because of the previous kill
                    
.ChkExpert          lda LR_ExpertMode               // .hbu017. - expert mode set after <run/stop>, <f7>, <run/stop>
.NoCheating         bmi IGC_PrevLvlX                // .hbu017. - do not set cheat flag in expert mode
                    
                    lsr LR_Cheated                  // set cheated
                    
IGC_PrevLvlX        rts
// ------------------------------------------------------------------------------------------------------------- //
IGC_QuitLvl         subroutine
                    lda LR_TestLevel                // .hbu023. - flag: level testmode on/off
                    bpl IGC_QuitLvlX                // .hbu023. - $ff=off
                    
                    pla                             // 
                    pla                             // .hbu023. - remove WaitKeyBlink
                    pla                             // 
                    pla                             // .hbu023. - remove GetPlayCmd
                    
IGC_QuitLvlPlay     subroutine                      // .hbu023. - entry point after reaching LevelComplete
                    lda #LR_TestLevelOff            // .hbu023. - switch test level mode off
                    sta LR_TestLevel                // .hbu023.
                    
                    lda #LR_NumLivesInit            // .hbu023.
                    sta LR_NumLives                 // .hbu023.
                    
                    lda #LR_GameEdit                // .hbu023.
                    sta LR_GameCtrl                 // .hbu023. - $00=start $01=demo $02=game $03=play_level $05=edit
                    sta LR_SprtPosCtrl              // .hbu023. - <> $00 - no sprites
                    
                    lda #$00                        // disable all sprites
                    sta SPENA                       // VIC 2 - $D015 = Sprite Enable
                    jsr LvlEdCurPosLoad             // .hbu023. - restore old cursor position
                    
.Back2Edit          jmp LevelEditorTst              // .hbu023.
                    
IGC_QuitLvlX        rts                             // .hbu023.
// ------------------------------------------------------------------------------------------------------------- //
IGC_IncNumLife      subroutine
                    lda C64_KeyFlag                 // .hbu021. - F=increase life counter
                    and #$02                        // .hbu021. - $01=shift $02=commodore $04=ctrl
                    cmp #$02                        // .hbu021. - <commodore>
                    bne .IncLives01                 // .hbu021.
                    
.IncLives10         lda LR_NumLives                 // .hbu021. - 000-149 - <commodore> plus f=get next level plus 10
                    clc                             // .hbu021.
                    adc #$0a                        // .hbu021.
                    bcc .SetLives                   // .hbu021.
                    bcs .GetLivesMax                // .hbu021.
                    
.IncLives01         inc LR_NumLives                 // get next level plus 1
                    bne .OutLives                   // 
                    
.GetLivesMax        lda #$ff                        // .hbu021. - max $ff
.SetLives           sta LR_NumLives
.OutLives           jsr RestoreFromMsg              // .hbu007. - reset status line / display new no of lives
                    
.ChkExpert          lda LR_ExpertMode               // .hbu017. - expert mode set after <run/stop>, <f7>, <run/stop>
.NoCheating         bmi IGC_IncNumLifeX             // .hbu017. - do not set cheat flag in expert mode
                    
                    lsr LR_Cheated                  // $00=yes  $01=no
                    
IGC_IncNumLifeX     jmp GetPlayCmd
// ------------------------------------------------------------------------------------------------------------- //
IGC_Pause           subroutine
                    jsr GetAKey                     //
                    
.Chk_f7             cmp #$03                        // .hbu017. - <f7>
                    bne .Chk_RunStop                // .hbu017.
                    
.ToggleExpert       lda LR_ExpertMode               // .hbu017.
                    eor #LR_ExpertModeOn            // .hbu017. - toggle expert mode
                    sta LR_ExpertMode               // .hbu017.
                    bpl .MarkOff                    // .hbu017.
                    
.MarkOn             lda #DK_GREY                    // .hbu017.
                    bne .SetMark                    // .hbu017. - always
                    
.MarkOff            lda #BLACK                      // .hbu017.
.SetMark            sta EXTCOL                      // .hbu017. - VIC 2 - $D020 = Border Color
                    jsr Beep                        // .hbu017. - announce
                    
.Chk_RunStop        cmp #$3f                        // <run/stop>
                    bne IGC_Pause                   //
                    
IGC_PauseX          jmp GetPlayCmd                  //
// ------------------------------------------------------------------------------------------------------------- //
IGC_Resign          subroutine
                    ldx LR_TestLevel                // .hbu023. - R=give up
                    bpl IGC_ResignX                 // .hbu023.
                    
.GoQuit             jmp IGC_QuitLvl                 // .hbu023. - only quits in test level mode
                    
IGC_ResignX         jmp GameOver                    // 
// ------------------------------------------------------------------------------------------------------------- //
IGC_Suicide         subroutine
                    lsr LR_Alive                    // A=suicide - $00=lr killed
                     
IGC_SuicideX        rts
// ------------------------------------------------------------------------------------------------------------- //
IGC_SetJoy          subroutine
                    lda #LR_Joystick
                    sta LR_ControllerTyp            // controler type  $ca=joystick  $cb=keyboard
                    
IGC_SetJoyX         jmp GetPlayCmd
// ------------------------------------------------------------------------------------------------------------- //
IGC_SetLoad         subroutine                      // L=load saved game
                    lda LR_TestLevel                // .hbu023. - flag: level testmode on/off
                    bpl .SetLoadCmd                 // .hbu023.
                    
.Exit               rts                             // no loads in test mode
                    
.SetLoadCmd         lda #$aa                        // "L"
                    jsr InitLodSavGame              //
                    
                    pla                             // discard return address of mainloop
                    pla                             //   avoids death tune
                    
IGC_SetLoadX        jmp LevelStart                  //
// ------------------------------------------------------------------------------------------------------------- //
IGC_SetSave         subroutine                      // S=save game
                    lda LR_TestLevel                // .hbu023. - flag: level testmode on/off
                    bpl .ChkCheat                   // .hbu023.
                    
.Exit               rts                             // no saves in test mode
                    
.ChkCheat           lda LR_Cheated                  // 
                    bne .SetSaveCmd                 //
                    
                    jmp GetPlayCmd                  // no saves after cheating
                    
.SetSaveCmd         lda #$8d                        // "S"
                    dec LR_NumLives                 // discount a live here to avoid live savings
                    jsr Lives2BaseLine              // and out
                    jsr InitLodSavGame              //
                    
                    pla                             // discard return address of mainloop
                    pla                             //  avoids death tune
                    
IGC_SetSaveX        jmp LevelStart                  //
// ------------------------------------------------------------------------------------------------------------- //
IGC_SetMirror       subroutine
                    jsr ToggleMirror                // M=discount a live here to avoid in game mirrors to save lives
                    
IGC_SetMirrorX      jmp GetPlayCmd
// ------------------------------------------------------------------------------------------------------------- //
IGC_SetKey          subroutine
                    lda #LR_Keyboard
                    sta LR_ControllerTyp            // controler type  $ca=joystick  $cb=keyboard
                    
IGC_SetKeyX         jmp GetPlayCmd
// ------------------------------------------------------------------------------------------------------------- //
IGC_DecSpeed        subroutine                      // -=decrease game speed
                    lda LR_ExpertMode               // .hbu017.
                    bpl .GameMode                   // .hbu017.
                    
                    jsr DecXmitLevelNo              // .hbu017. - decrease Xmit level number
.Exit               jmp GetPlayCmd                  // .hbu017.
                    
.GameMode           lda LR_GameSpeed                // 
                    cmp #LR_SpeedMax                // 
                    beq IGC_DecSpeedX               // 
                    
                    inc LR_GameSpeed                // apply the brake a bit
                    
IGC_DecSpeedX       jmp GetPlayCmd                  // 
// ------------------------------------------------------------------------------------------------------------- //
IGC_IncSpeed        subroutine                      // +=increase game speed
                    lda LR_ExpertMode               // .hbu017. - expert mode - set xmit level
                    bpl .GameMode                   // .hbu017. - game mode   - inc speed
                    
                    jsr IncXmitLevelNo              // .hbu017. - increase Xmit level number
.Exit               jmp GetPlayCmd                  // .hbu017.
                    
.GameMode           lda LR_GameSpeed                // 
                    cmp #LR_SpeedMin                // 
                    beq IGC_DecSpeedX               // 
                    
                    dec LR_GameSpeed                // release the brake a bit
                    
IGC_IncSpeedX       jmp GetPlayCmd                  // 
// ------------------------------------------------------------------------------------------------------------- //
IGC_ShootMode       subroutine
                    lda LR_ShootMode                // D=toggle shooter mode
                    eor #$ff
                    sta LR_ShootMode
                    
IGC_ShootModeX      jmp GetPlayCmd
// ------------------------------------------------------------------------------------------------------------- //
DecGameLevelNo      subroutine
.Chk_Co             lda C64_KeyFlag                 // .hbu021. - $01=shift $02=commodore $04=ctrl
                    and #$02                        // .hbu021.
                    cmp #$02                        // .hbu021. - <commodore>
                    bne .NextLevel                  // .hbu021.
                    
.NextLevel10        lda LR_LevelNoDisk              // .hbu021. - 000-149 - <commodore>f=get next level plus 10
                    sec                             // .hbu021.
                    sbc #$0a                        // .hbu021.
                    bcs .StoreLevel10               // .hbu021.
                    
                    IF  LR_LevelDiskMax > 10        // .hbu021. - only in code if more than 10 levels allowed
                    lda #LR_LevelDiskMax - 9        // .hbu021. - was lower 10 - underflow
                    clc                             // .hbu021.
                    adc LR_LevelNoDisk              // .hbu021.
                    
.StoreLevel10       sta LR_LevelNoDisk              // .hbu021.
                    sta LR_LevelNoGame              // .hbu021.
                    inc LR_LevelNoGame              // .hbu021.
.Exit10             rts                             // .hbu021.
                    
.NextLevel          lda LR_LevelNoDisk              // .hbu009. - 000-149 - F=get next level
                    cmp #LR_LevelDiskMin            // .hbu009.
                    bne .PrevDisk                   // .hbu009.
                    ENDIF
                    
                    ldy #LR_LevelDiskMax            // .hbu009.
                    sty LR_LevelNoDisk              // .hbu009. - 000-149
                    iny                             // .hbu009.
                    sty LR_LevelNoGame              // .hbu009. - 001-150
.Exit1              rts                             // .hbu009.
                    
.PrevDisk           dec LR_LevelNoDisk              // 000-149
.PrevGame           dec LR_LevelNoGame              // 001-150
                    
DecGameLevelNoX     rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
IncGameLevelNo      subroutine
.Chk_Co             lda C64_KeyFlag                 // .hbu021. - $01=shift $02=commodore $04=ctrl
                    and #$02                        // .hbu021.
                    cmp #$02                        // .hbu021. - <commodore>
                    bne .NextLevel                  // .hbu021.
                    
                    IF  LR_LevelDiskMax > 10        // .hbu021. - only in code if more than 10 levels allowed
.NextLevel10        lda LR_LevelNoDisk              // .hbu021. - 000-149 - <commodore>f=get next level plus 10
                    tay                             // .hbu021. - save LR_LevelNoDisk
                    clc                             // .hbu021.
                    adc #$0a                        // .hbu021.
                    bcc .ChkMax                     // .hbu021. - no byte overflow
                    
                    tya                             // .hbu021. - restore LR_LevelNoDisk
                    sbc #$00                        // .hbu021.
                    and #$0f                        // .hbu021.
                    jmp .StoreLevel10               // .hbu021.
                    
.ChkMax             cmp #LR_LevelDiskMax + 1        // .hbu021.
                    bcc .StoreLevel10               // .hbu021.
                    
                    sec                             // .hbu021.
                    sbc #LR_LevelDiskMax + 1        // .hbu021. - too high so reduce with the max + 1
                    
.StoreLevel10       sta LR_LevelNoDisk              // .hbu021.
                    sta LR_LevelNoGame              // .hbu021.
                    jmp .NextGame                   // .hbu021. - add 1 to disk level number
                    ENDIF
                    
.NextLevel          lda LR_LevelNoDisk              // .hbu009. - 000-149 - F=get next level
                    cmp #LR_LevelDiskMax            // .hbu009.
                    bne .NextDisk                   // .hbu009.
                    
                    ldy #LR_LevelDiskMin            // .hbu009.
                    sty LR_LevelNoDisk              // .hbu009. - 000-149
                    iny                             // .hbu009.
                    sty LR_LevelNoGame              // .hbu009. - 001-150
.Exit               rts                             // .hbu009.
                    
.NextDisk           inc LR_LevelNoDisk              // 000-149
.NextGame           inc LR_LevelNoGame              // 001-150
                    
IncGameLevelNoX     rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
DecXmitLevelNo      subroutine
.ChkMsg             lda LR_ScrnMCMsg - 1            // .hbu017. - status line msg color game
                    cmp LR_ScrnMCMsg                // .hbu017. - status line msg part colour
                    beq .InfoMsg                    // .hbu017. - info msg only at first call - no dec
                    
.Chk_Co             lda C64_KeyFlag                 // .hbu017. - $01=shift $02=commodore $04=ctrl
                    and #$02                        // .hbu017.
                    cmp #$02                        // .hbu017. - <commodore>
                    bne .ChkXmit01                  // .hbu017.
                    
.SubXmit10          lda LR_LevelNoXmit              // .hbu017. - 000-149 - <commodore>f=get next level plus 10
                    sec                             // .hbu017.
                    sbc #$0a                        // .hbu017.
                    bcs .SetXmit10                  // .hbu017.
                    
                    lda #LR_LevelDiskMax - 9        // .hbu017. - was lower 10 - underflow
                    clc                             // .hbu017.
                    adc LR_LevelNoDisk              // .hbu017.
.SetXmit10          sta LR_LevelNoXmit              // .hbu017.
                    jmp .InfoMsg                    // .hbu017.
                    
.ChkXmit01          lda LR_LevelNoXmit              // .hbu017.
                    cmp #LR_LevelDiskMin            // .hbu017.
                    bne .SetXmit01                  // .hbu017.
                    
                    lda #LR_LevelDiskMax            // .hbu017.
                    sta LR_LevelNoXmit              // .hbu017.
                    jmp .InfoMsg                    // .hbu017.
                    
.SetXmit01          dec LR_LevelNoXmit              // .hbu017.
                    
.InfoMsg            lda #$a0                        // .hbu017. - <blank>
                    sta Mod_InfoTxt1                // .hbu017.
                    lda #$d3                        // .hbu017. - "S"
                    sta Mod_InfoTxt2                // .hbu017.
                    lda #$c5                        // .hbu017. - "E"
                    sta Mod_InfoTxt3                // .hbu017.
DecXmitLevelNoX     jmp XmitInfo                    // .hbu017.
// ------------------------------------------------------------------------------------------------------------- //
IncXmitLevelNo      subroutine
.ChkMsg             lda LR_ScrnMCMsg - 1            // .hbu017. - status line msg color game
                    cmp LR_ScrnMCMsg                // .hbu017. - status line msg part colour
                    beq .InfoMsg                    // .hbu017. - info msg only at first call - no inc
                    
.Chk_Co             lda C64_KeyFlag                 // .hbu017. - $01=shift $02=commodore $04=ctrl
                    and #$02                        // .hbu017.
                    cmp #$02                        // .hbu017. - <commodore>
                    bne .ChkXmit01                  // .hbu017.
                    
.AddXmit10          lda LR_LevelNoXmit              // .hbu017. - 000-149 - <commodore>f=get next xmit level plus 10
                    clc                             // .hbu017.
                    adc #$0a                        // .hbu017.
                    cmp #LR_LevelDiskMax + 1        // .hbu017.
                    bcc .SetXmit10                  // .hbu017.
                    
                    sec                             // .hbu017.
                    sbc #LR_LevelDiskMax + 1        // .hbu017.
.SetXmit10          sta LR_LevelNoXmit              // .hbu017.
                    jmp .InfoMsg                    // .hbu017.
                    
.ChkXmit01          lda LR_LevelNoXmit              // .hbu017.
                    cmp #LR_LevelDiskMax            // .hbu017.
                    bne .SetXmit01                  // .hbu017.
                    
                    lda #LR_LevelDiskMin            // .hbu017.
                    sta LR_LevelNoXmit              // .hbu017.
                    jmp .InfoMsg                    // .hbu017.
                    
.SetXmit01          inc LR_LevelNoXmit              // .hbu017.
                    
.InfoMsg            lda #$a0                        // .hbu017. - <blank>
                    sta Mod_InfoTxt1                // .hbu017.
                    lda #$d3                        // .hbu017. - "S"
                    sta Mod_InfoTxt2                // .hbu017.
                    lda #$c5                        // .hbu017. - "E"
                    sta Mod_InfoTxt3                // .hbu017.
IncXmitLevelNoX     jmp XmitInfo                    // .hbu017.
// ------------------------------------------------------------------------------------------------------------- //
ToggleMirror        subroutine
                    lda LR_Mirror                   //  flip load mirrored level flag
                    eor #$ff
                    sta LR_Mirror
                    
.ResetKey           ldy #LR_KeyNewNone              //
                    sty LR_KeyNew                   // reset pressed key
                    
                    lsr LR_Alive                    // kill lr
                    inc LR_LvlReload                // <> LR_LevelNoDisk - force level reload from disk
                    
ToggleMirrorX       rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ChkJoyPort          subroutine
                    lda CIAPRA                      // CIA 1 - $DC00 = Data Port A
                    and #$10                        // Bit 4: Joystick 2 - Fire   0=pressed
                    bne .ChkMoves
                    
.CheckMode          lda $08
                    eor LR_ShootMode
                    bpl .FireLeft
                    
.FireRight          lda #LR_JoyFireRi
                    sta LR_JoyUpDo
                    sta LR_JoyLeRi
.FireRightX         rts
                    
.FireLeft           lda #LR_JoyFireLe
                    sta LR_JoyUpDo
                    sta LR_JoyLeRi
.FireLeftX          rts
                    
.ChkMoves           lda CIAPRA                      // CIA 1 - $DC00 = Data Port A
                    sta LRZ_Work                    // SavCIA
                    
.ChkUpDown          and #$02                        // Bit 1: Joystick 2 - Down   0=pressed
                    beq .SetDown
                    
                    lda LRZ_Work                    // SavCIA
                    and #$01                        // Bit 0: Joystick 2 - Up     0=pressed
                    beq .SetUp
                    
.NetNoneUpDown      ldx #LR_JoyMoveNone
                    stx LR_JoyUpDo
                    beq .ChkLeftRight               // always
                    
.SetUp              ldx #LR_JoyMoveUp
                    stx LR_JoyUpDo
                    bne .ChkLeftRight               // always
                    
.SetDown            ldx #LR_JoyMoveDo
                    stx LR_JoyUpDo
                    
.ChkLeftRight       lda LRZ_Work                    // SavCIA
                    and #$08                        // Bit 3: Joystick 2 - Right  0=pressed
                    beq .SetRight
                    
                    lda LRZ_Work
                    and #$04                        // Bit 2: Joystick 2 - Left   0=pressed
                    beq .SetLeft
                    
.SetNoneRiLeft      ldx #LR_JoyMoveNone
                    stx LR_JoyLeRi
.SetNoneRiLeftX     rts
                    
.SetRight           ldx #LR_JoyMoveRi
                    stx LR_JoyLeRi
.SetRightX          rts
                    
.SetLeft            ldx #LR_JoyMoveLe
                    stx LR_JoyLeRi
                    
ChkJoyPortX         rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetLRGfxOff         subroutine
                    ldx LRZ_LodeRunCol              // actual col lode runner
                    ldy LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
                    jsr GetXOff
                    
                    stx LRZ_ImageNo                 // image number
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    ldx LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    jsr GetYOff
                    
                    ldx LRZ_LodeRunSpriteNo         // lr sprite number
                    lda TabSpriteNoLodeR,x          // lr images tab
                    ldx LRZ_ImageNo                 // image number
                    
GetLRGfxOffX        rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovLRGold           subroutine
                    lda LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
                    cmp #$02                        // centered
                    bne MovLRGoldX                  // no
                    
                    lda LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    cmp #$02                        // centered
                    bne MovLRGoldX                  // no
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    cmp #NoTileGold
                    bne MovLRGoldX                  // no
                    
                    lsr LR_GetGold                  // get gold  $00=just gets it
                    ldx #$10
                    ldy #$20
                    lda #$04
                    jsr Randomizer
                    sta .Rnd01
                    
                    lda #$04
                    jsr Randomizer
                    sta .Rnd02
                    
                    lda #$04
                    jsr Randomizer
                    sta .Rnd03
                    
                    lda #$04
                    jsr Randomizer
                    sta .Rnd04
                    
                    jsr SetTune                     // data must follow directly
                    dc.b $04                        // tune time
.Rnd01              dc.b $00                        // tune data pointer voice 2
                    dc.b $ff                        // tune data pointer voice 3
                    dc.b $b0                        // tune s/r/volume  (not used)
                    
                    dc.b $04                        // tune time
.Rnd02              dc.b $00                        // tune data pointer voice 2
                    dc.b $ff                        // tune data pointer voice 3
                    dc.b $a0                        // tune s/r/volume  (not used)
                    
                    dc.b $04                        // tune time
.Rnd03              dc.b $00                        // tune data pointer voice 2
                    dc.b $ff                        // tune data pointer voice 3
                    dc.b $90                        // tune s/r/volume  (not used)
                    
                    dc.b $04                        // tune time
.Rnd04              dc.b $00                        // tune data pointer voice 2
                    dc.b $ff                        // tune data pointer voice 3
                    dc.b $a0                        // tune s/r/volume  (not used)
                    
                    dc.b $00                        // <EndOfTuneData>
                    
.DecGoldToGet       dec LR_Gold2Get
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    sty LRZ_ScreenRow               // screen row  (00-0f)
                    ldy LRZ_LodeRunCol              // actual col lode runner
                    sty LRZ_ScreenCol               // screen col  (00-1b)
                    lda #NoTileBlank
                    sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    jsr ImageOut2Prep               // direct output to preparation screen
                    
                    ldy LRZ_ScreenRow               // screen row  (00-0f)
                    ldx LRZ_ScreenCol               // screen col  (00-1b)
                    jsr GetColRowGfxOff             // offsets in xr=col yr=row
                    
                    lda #NoTileGold
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    
                    lda #<LR_ScoreGold              // ac=score  10s
                    ldy #>LR_ScoreGold              // yr=score 100s
                    jsr Score2BaseLine 
                    
MovLRGoldX          rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovLRSetImg         subroutine
                    inc LRZ_LodeRunSpriteNo         // lr sprite number = next
                    
                    cmp LRZ_LodeRunSpriteNo         // compare 07 with minimum
                    bcc .ChkMax                     // lower - check max
                    
.SetImg             sta LRZ_LodeRunSpriteNo
                    rts
                    
.ChkMax             cpx LRZ_LodeRunSpriteNo
                    bcc .SetImg
                    
MovLRSetImgX        rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovLRKill           subroutine
                    jsr GetLRGfxOff
                    jsr ImageOutXtra                // set images on game screen (sprites/shoots/hidden ladders)
                    lda $27                         // sprite collision  $01=lr caught
                    beq MovLRKillX
                    
                    lda LR_GetGold                  // get gold  $00=just gets it
                    beq MovLRKillX
                    
                    lsr LR_Alive                    // $00=lr killed
                    
MovLRKillX          rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovLRWaitPosX       subroutine
                    lda LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
                    cmp #$02                        // center
                    bcc .IncPos                     // lower
                    beq MovLRWaitPosXX
                    
                    dec LRZ_LodeRunOnImgPosLR       // greater so dec lr pos on image left/right
                    jmp MovLRGold                   // wait for center and handle the gold
                    
.IncPos             inc LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
                    jmp MovLRGold                   // wait for center and handle the gold
                    
MovLRWaitPosXX      rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovLRWaitPosY       subroutine
                    lda LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    cmp #$02                        // center
                    bcc .IncPos                     // lower
                    beq MovLRWaitPosYX
                    
                    dec LRZ_LodeRunOnImgPosUD       // greater so dec lr pos on image up/down
                    jmp MovLRGold                   // wait for center and handle the gold
                    
.IncPos             inc LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
                    jmp MovLRGold                   // wait for center and handle the gold
                    
MovLRWaitPosYX      rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovLRSetHole        subroutine
                    lda #$00
                    sta LR_Shoots                   // $00=no $01=right $ff=left
                    
                    ldy LRZ_LodeRunRow              // actual row lode runner
                    iny
                    stx LRZ_ScreenCol               // screen col  (00-1b)
                    sty LRZ_ScreenRow               // screen row  (00-0f)
                    
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi
                    
                    lda #NoTileBlank                // empty
                    ldy LRZ_ScreenCol               // screen col  (00-1b)
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    jsr ImageOut2Disp               // direct output to display screen
                    
                    lda #NoTileBlank                // emtpy
                    jsr ImageOut2Prep               // direct output to preparation screen
                    
                    dec LRZ_ScreenRow               // screen row  (00-0f)
                    lda #NoTileBlank                // empty
                    jsr ImageOut2Disp               // direct output to display screen
                    
                    inc LRZ_ScreenRow               // screen row  (00-0f)
                    ldx #$ff
.GetFreeSlot        inx
                    cpx #LR_TabHoleMax              // $1e - max 30 slots
                    beq MovLRSetHoleX
                    
                    lda LR_TabHoleOpenTime,x        // hole open time tab
                    bne .GetFreeSlot                // already used - check next slot
                    
                    lda LRZ_ScreenRow               // screen row  (00-0f)
                    sta LR_TabHoleRow,x             // hole row tab
                    lda LRZ_ScreenCol               // screen col  (00-1b)
                    sta LR_TabHoleCol,x             // hole column tab
                    
                    lda #LR_TabHoleOpenStart        // 
                    sta LR_TabHoleOpenTime,x        // hole open time tab
                    sec
                    
MovLRSetHoleX       rts
// ------------------------------------------------------------------------------------------------------------- //
// MoveEnemies       Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MoveEnemies         subroutine
                    ldx LR_EnmyNo                   // number of enemies
                    beq MoveEnemiesX                // no enemy to move
                    
.IncMoveCyclePtr    inc LRZ_EnmyPtrCyc              // pointer actual enemy cycles
                    
.ChkMoveCyclePtr    ldy LRZ_EnmyPtrCyc              // 
                    cpy #$03                        // 
                    bcc .GetMoveCycle               // lower $00-$02
                    
.IniMoveCyclePtr    ldy #$00                        // reset
                    sty LRZ_EnmyPtrCyc              // 
                    
.GetMoveCycle       lda LRZ_EnmyMovCyc1,y           // load move cycles
                    sta LRZ_EnmyMovCtrl             // enemy move control
                    
.MoveLoop           lsr LRZ_EnmyMovCtrl             // enemy move control
                    bcc .ChkCycle                   // 
                    
.GoMoveThisEnmy     jsr MovEnThisOne                // move THIS enemy
                    
.ChkHealthLR        lda LR_Alive                    // $00=lr killed
                    beq MoveEnemiesX                // exit if dead
                    
.ChkCycle           lda LRZ_EnmyMovCtrl             // enemy move control
                    bne .MoveLoop                   // 
                    
MoveEnemiesX        rts                             //
// ------------------------------------------------------------------------------------------------------------- //
TabEnmyCycles1      dc.b $00 // ........             // LR_CntSpeedLaps ($00-$09) + LR_EnmyNo
TabEnmyCycles2      dc.b $00 // ........
TabEnmyCycles3      dc.b $00 // ........
                    
                    dc.b $00 // ........
                    dc.b $01 // .......#
                    dc.b $01 // .......#
                    
                    dc.b $01 // .......#
                    dc.b $01 // .......#
                    dc.b $01 // .......#
                    
                    dc.b $01 // .......#
                    dc.b $03 // ......##
                    dc.b $01 // .......#
                    
                    dc.b $01 // .......#
                    dc.b $03 // ......##
                    dc.b $03 // ......##
                    
                    dc.b $03 // ......##
                    dc.b $03 // ......##
                    dc.b $03 // ......##
                    
                    dc.b $03 // ......##
                    dc.b $03 // ......##
                    dc.b $07 // .....###
                    
                    dc.b $03 // ......##
                    dc.b $07 // .....###
                    dc.b $07 // .....###
                    
                    dc.b $07 // .....###
                    dc.b $07 // .....###
                    dc.b $07 // .....###
                    
                    dc.b $07 // .....###
                    dc.b $07 // .....###
                    dc.b $0f // ....####
                    
                    dc.b $07 // .....###
                    dc.b $0f // ....####
                    dc.b $0f // ....####
                    
                    dc.b $0f // ....####
                    dc.b $0f // ....####
                    dc.b $0f // ....####
                    
                    dc.b $0f // ....####
                    dc.b $0f // ....####
                    dc.b $1f // ...#####
                    
                    dc.b $0f // ....####
                    dc.b $1f // ...#####
                    dc.b $1f // ...#####
                    
                    dc.b $1f // ...#####
                    dc.b $1f // ...#####
                    dc.b $1f // ...#####
                    
                    dc.b $1f // ...#####
                    dc.b $1f // ...#####
                    dc.b $3f // ..######
                    
                    dc.b $1f // ...#####
                    dc.b $3f // ..######
                    dc.b $3f // ..######
                    
                    dc.b $3f // ..######
                    dc.b $3f // ..######
                    dc.b $3f // ..######
                    
                    dc.b $3f // ..######
                    dc.b $3f // ..######
                    dc.b $7f // .#######
                    
                    dc.b $3f // ..######
                    dc.b $7f // .#######
                    dc.b $7f // .#######
                    
                    dc.b $7f // .#######
                    dc.b $7f // .#######
                    dc.b $7f // .#######
// ------------------------------------------------------------------------------------------------------------- //
TabSpriteNoEnemy    equ *
TabEN_RunLeMin      dc.b NoSprtMC_RuLe00 // $00 - run    left 01       - have enemy sprite numbers from $00-$0f
                    dc.b NoSprtMC_RuLe01 // $01 - run    left 02
TabEN_RunLeMax      dc.b NoSprtMC_RuLe02 // $02 - run    left 03
TabEN_PoleLeMin     dc.b NoSprtMC_PoLe00 // $03 - pole   left 01
                    dc.b NoSprtMC_PoLe01 // $04 - pole   left 02
TabEN_PoleLeMax     dc.b NoSprtMC_PoLe02 // $05 - pole   left 03
TabEN_FallLe        dc.b NoSprtMC_FallLe // $06 - fall   left
TabEN_RunRiMin      dc.b NoSprtMC_RuRi00 // $07 - run    right 01
                    dc.b NoSprtMC_RuRi01 // $08 - run    right 02
TabEN_RunRiMax      dc.b NoSprtMC_RuRi02 // $09 - run    right 03
TabEN_PoleRiMin     dc.b NoSprtMC_PoRi00 // $0a - pole   right 01
                    dc.b NoSprtMC_PoRi01 // $0b - pole   right 02
TabEN_PoleRiMax     dc.b NoSprtMC_PoRi02 // $0c - pole   right 03
TabEN_FallRi        dc.b NoSprtMC_FallRi // $0d - fall   right
TabEN_LadderMin     dc.b NoSprtMC_Ladr00 // $0e - ladder up/down 01
TabEN_LadderMax     dc.b NoSprtMC_Ladr01 // $0f - ladder up/down 02
// ------------------------------------------------------------------------------------------------------------- //
NoEN_RunLeMin       equ  TabEN_RunLeMin  - TabSpriteNoEnemy
NoEN_RunLeMax       equ  TabEN_RunLeMax  - TabSpriteNoEnemy
NoEN_PoleLeMin      equ  TabEN_PoleLeMin - TabSpriteNoEnemy
NoEN_PoleLeMax      equ  TabEN_PoleLeMax - TabSpriteNoEnemy
NoEN_RunRiMin       equ  TabEN_RunRiMin  - TabSpriteNoEnemy
NoEN_RunRiMax       equ  TabEN_RunRiMax  - TabSpriteNoEnemy
NoEN_PoleRiMin      equ  TabEN_PoleRiMin - TabSpriteNoEnemy
NoEN_PoleRiMax      equ  TabEN_PoleRiMax - TabSpriteNoEnemy
NoEN_LadderMin      equ  TabEN_LadderMin - TabSpriteNoEnemy
NoEN_LadderMax      equ  TabEN_LadderMax - TabSpriteNoEnemy
                    
NoEN_FallLe         equ  TabEN_FallLe    - TabSpriteNoEnemy
NoEN_FallRi         equ  TabEN_FallRi    - TabSpriteNoEnemy
// ------------------------------------------------------------------------------------------------------------- //
// MovEnThisOne      Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnThisOne        subroutine
.IncEnemyNo         inc LR_NoEnemy2Move             // select next enemy
                    
.ChkMaxNo           ldx LR_EnmyNo                   // number of enemies
                    cpx LR_NoEnemy2Move             // # of enemy to move
                    bcs .GetStatus                  // max not reached
                    
.SetMinNo           ldx #LR_NoEnemy2MvMin           // reset to first enemy
                    stx LR_NoEnemy2Move
                    
.GetStatus          jsr GetEnemyStatus              // restore saved status values
                     
.ChkHoleTime        lda LRZ_EnemyInHoleTime         // enemy time in hole count down
                    bmi MovEnHoleGetOut             // time is more than up
                    beq MovEnHoleGetOut             // time is up
                    
.DecHoleTime        dec LRZ_EnemyInHoleTime         // enemy time in hole count down
                    
.ChkShiverTime      ldy LRZ_EnemyInHoleTime         // enemy time in hole count down
                    cpy #LR_EnmyShivStart           // 
                    bcs .ChkRebirthTime             // greater/equal
                    
.GoShiverOut        jmp MovEnShiverOut              // lower - do the shiver and return
                    
.ChkRebirthTime     ldx LR_NoEnemy2Move             // # of enemy to move
                    lda LR_TabEnemyRebTime,x        // enemy rebirth step time
                    beq MovEnThisOneX               // 
                    
.SavThisStatus      jmp MovEnSaveStatus             // still in hole - save status values and finish
MovEnThisOneX       jmp MovEnDisplaySave            // enemy sprite out and exit move
// ------------------------------------------------------------------------------------------------------------- //
// MovEnHoleGetOut   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnHoleGetOut     subroutine
                    ldy LRZ_EnemyRow                // actual enemy row
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    
                    ldy LRZ_EnemyCol                // actual enemy col
.GetOrigin          lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileLadder               // 
                    beq MovEnHoleGetOutX            // go move enemy
                    
                    cmp #NoTilePole                 // 
                    bne .ChkCenterLower             // 
                    
.ChkCenter          lda LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    cmp #$02                        // centered
                    beq MovEnHoleGetOutX            // go move enemy
                    
.ChkCenterLower     lda LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    cmp #$02                        // center
                    bcc MovEnFallHole               // lower
                    
.ChkCenterHigher    ldy LRZ_EnemyRow                // actual enemy row
                    cpy #LR_ScrnMaxRows             // $0f - max 15 rows
                    beq MovEnHoleGetOutX            // go move enemy
                    
                    lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginBelow     sta LRZ_XLvlOriRowHi
                    lda TabExLvlModRowHi+1,y        // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModifyBelow     sta LRZ_XLvlModRowHi
                    
                    ldy LRZ_EnemyCol                // actual enemy col
.GetModifyBelow     lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes row + 1 (directly below enemy)
                    
                    cmp #NoTileBlank                // 
                    beq MovEnFallHole               // 
                    
                    cmp #NoTileLodeRunner           // 
                    beq MovEnFallHole               // 
                    
                    cmp #NoTileEnemy                // 
                    beq MovEnHoleGetOutX            // go move enemy
                    
.GetOriginBelow     lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes + 1
                    cmp #NoTileWallWeak             // 
                    beq MovEnHoleGetOutX            // go move enemy
                    
                    cmp #NoTileWallHard             // 
                    beq MovEnHoleGetOutX            // go move enemy
                    
                    cmp #NoTileLadder               // 
                    bne MovEnFallHole               // 
                    
MovEnHoleGetOutX    jmp MoveEnemy                   // go move enemy
// ------------------------------------------------------------------------------------------------------------- //
MovEnFallHole       subroutine
                    jsr MovEnGetXYNo                // ac=image no  xr=col offset  yr=row offset
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    jsr MovEnCenterLeRi             // 
                    
.GetFallLeft        lda #NoEN_FallLe                // 
                    
                    ldy LRZ_EnemyMovDirLR           // actual enemy dir right/left  $ff=left  $01=right
                    bmi .SetFallLeRi                // 
                    
.GetFallRight       lda #NoEN_FallRi                // 
                    
.SetFallLeRi        sta LRZ_EnemySpriteNo           // actual enemy sprite number
                    
                    inc LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    lda LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    cmp #$05                        // max
                    bcs MovEnFallDown               // greater/equal
                    
                    lda LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    cmp #$02                        // center
                    bne MovEnDisplaySave            // enemy sprite out and exit move
                    
.GoTakeGold         jsr MovEnTakeGold               // action only if in center of image
                    
                    ldy LRZ_EnemyRow                // actual enemy row
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    
                    ldy LRZ_EnemyCol                // actual enemy col
.GetOrigin          lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // 
                    bne MovEnDisplaySave            // enemy sprite out and exit move
                    
                    lda LRZ_EnemyInHoleTime         // enemy time in hole count down
                    bpl .SetHoleTime                // 
                    
.DecGold            dec LR_Gold2Get                 // 
                    
.SetHoleTime        lda LR_EnmyHoleTime             // enemy time in hole - values dynamically taken from TabEnmyHoleTime
                    sta LRZ_EnemyInHoleTime         // enemy time in hole count down
                    
.SetDigScore        lda #<LR_ScoreDigIn             // ac=score  10s
                    ldy #>LR_ScoreDigIn             // yr=score 100s
MovEnFallHoleX      jsr Score2BaseLine 
// ------------------------------------------------------------------------------------------------------------- //
MovEnDisplaySave    subroutine
                    jsr MovEnGetXYNo                // ac=image no  xr=col offset  yr=row offset
                    jsr ImageOutXtra                // set images on game screen (sprites/shoots/hidden ladders)
MovEnDisplaySaveX   jmp MovEnSaveStatus             // save status values and finish
// ------------------------------------------------------------------------------------------------------------- //
MovEnFallDown       subroutine
.IniImagePos        lda #$00                        // 
                    sta LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    
                    ldy LRZ_EnemyRow                // actual enemy row
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    
                    sta LRZ_XLvlModRowLo            // 
                    sta LRZ_XLvlOriRowLo            // 
                    
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi            // 
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyCol                // actual enemy col
.GetOrigin          lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
.ChkWallWeak        cmp #NoTileWallWeak             // 
                    bne .SetModify                  // 
                    
.GetEmpty           lda #NoTileBlank                // 
                    
.SetModify          sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
.IncPosRow          inc LRZ_EnemyRow                // actual enemy row
                    
                    ldy LRZ_EnemyRow                // actual enemy row + 1
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo            // 
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModifyBelow     sta LRZ_XLvlModRowHi            // 
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginBelow     sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyCol                // actual enemy col
.GetModifyBelow     lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
.ChkCatchLR         cmp #NoTileLodeRunner           // 
                    bne .GetOriginBelow             // 
                    
.KillLR             lsr LR_Alive                    // $00=lr killed
                    
.GetOriginBelow     lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // 
                    bne .SetModifyEnemy             // display enemy in hole
                    
                    lda LRZ_EnemyInHoleTime         // enemy time in hole count down
                    bpl .SetModifyEnemy             // display enemy in hole
                    
                    ldy LRZ_EnemyRow                // actual enemy row
                    dey                             // 
.SetScreenRow       sty LRZ_ScreenRow               // screen row  (00-0f)
                    
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo            // 
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModifyAbove     sta LRZ_XLvlModRowHi            // 
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginAbove     sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyCol                // actual enemy col
.SetScreenCol       sty LRZ_ScreenCol               // screen col  (00-1b)
                    
.GetOriginAbove     lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
.ChkEmpty           cmp #NoTileBlank                // 
                    beq .LeaveGold                  // 
                    
                    dec LR_Gold2Get                 // a piece of gold got lost
                    jmp .OutEnemyInHole             // 
                    
.LeaveGold          lda #NoTileGold                 // 
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
.DisplayGold        jsr ImageOut2Prep               // direct output to preparation screen
                    
                    ldy LRZ_ScreenRow               // screen row  (00-0f)
                    ldx LRZ_ScreenCol               // screen col  (00-1b)
                    jsr GetColRowGfxOff             // offsets in xr=col yr=row
                    
                    lda #NoTileGold                 // 
                    jsr ImageOutXtra                // set images on game screen (sprites/shoots/hidden ladders)
                    
.OutEnemyInHole     ldy LRZ_EnemyRow                // actual enemy row
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo            // 
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModifyEnemy     sta LRZ_XLvlModRowHi            // 
                    
                    lda #LR_EnmyHoleTiIni           // $00 - init
                    sta LRZ_EnemyInHoleTime         // enemy time in hole count down
                    
                    ldy LRZ_EnemyCol                // actual enemy col
.SetModifyEnemy     lda #NoTileEnemy                // 
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    jsr MovEnGetXYNo                // ac=image no  xr=col offset  yr=row offset
                    jsr ImageOutXtra                // set images on game screen (sprites/shoots/hidden ladders)
MovEnFallDownX      jmp MovEnSaveStatus             // save status values and finish
// ------------------------------------------------------------------------------------------------------------- //
MovEnShiverOut      subroutine
                    cpy #LR_EnmyShivStop            // move out if lower
                    bcc MoveEnemy                   // 
                    
.ClrOld             jsr MovEnGetXYNo                // ac=image no  xr=col offset  yr=row offset
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    
.GetShiver          ldy LRZ_EnemyInHoleTime         // enemy time in hole count down
                    lda TabEnemyShiver-7,y          // shiver the last hole seconds
                    sta LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
                    
.SetNew             jsr MovEnGetXYNo                // ac=image no  xr=col offset  yr=row offset
                    jsr ImageOutXtra                // set images on game screen (sprites/shoots/hidden ladders)
                    
MovEnShiverOutX     jmp MovEnSaveStatus             // save status values and finish
// ------------------------------------------------------------------------------------------------------------- //
TabEnemyShiver      dc.b $02                        // let enemy shiver from left ro right before leaving a hole
                    dc.b $01
                    dc.b $02
                    dc.b $03
                    dc.b $02
                    dc.b $01
// ------------------------------------------------------------------------------------------------------------- //
MoveEnemy           subroutine
                    ldx LRZ_EnemyCol                // actual enemy col
                    ldy LRZ_EnemyRow                // actual enemy row
                    jsr MovEnGetMoveDir             // 
                    
                    asl a                           // 
                    tay                             // 
                    lda TabMovEnDir+1,y             // 
                    pha                             // 
                    lda TabMovEnDir,y               // 
                    pha                             // 
                    
MoveEnemyX          rts                             // dispatch move
// ------------------------------------------------------------------------------------------------------------- //
TabMovEnDir         dc.w MovEnSaveStatus -1         // $00 - no move - save status values and finish
                    dc.w MovEnLeft       -1         // $01
                    dc.w MovEnRight      -1         // $02
                    dc.w MovEnUp         -1         // $03
                    dc.w MovEnDown       -1         // $04
// ------------------------------------------------------------------------------------------------------------- //
MovEnIncHoleTime    subroutine
                    lda LRZ_EnemyInHoleTime         // enemy time in hole count down
                    beq MovEnIncHoleTimeX           // 
                    bmi MovEnIncHoleTimeX           // 
                    
                    inc LRZ_EnemyInHoleTime         // enemy time in hole count down
                    
MovEnIncHoleTimeX   jmp MovEnSaveStatus             // save status values and finish
// ------------------------------------------------------------------------------------------------------------- //
MovEnUp             subroutine
                    ldy LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    cpy #$03                        // 
                    bcs MovEnUpStep                 // greater/equal
                    
.ChkTopRow          ldy LRZ_EnemyRow                // actual enemy row
                    beq MovEnIncHoleTime            // already already max up
                    
.SetRowAbove        dey                             // 
                    
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo            // 
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModifyAbove     sta LRZ_XLvlModRowHi            // 
                    
                    ldy LRZ_EnemyCol                // actual enemy col
.GetModifyAbove     lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // 
                    beq MovEnIncHoleTime            // blocked
                    
                    cmp #NoTileWallHard             // 
                    beq MovEnIncHoleTime            // blocked
                    
                    cmp #NoTileWallTrap             // 
                    beq MovEnIncHoleTime            // blocked
                    
                    cmp #NoTileEnemy                // 
MovEnUpX            beq MovEnIncHoleTime            // blocked
// ------------------------------------------------------------------------------------------------------------- //
MovEnUpStep         subroutine
                    jsr MovEnGetXYNo                // ac=image no  xr=col offset  yr=row offset
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    jsr MovEnCenterLeRi             // 
                    
.SetRowThis         ldy LRZ_EnemyRow                // actual enemy row
                    
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo            // 
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi            // 
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi            // 
                    
.StepUp             dec LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    bpl MovEnGoTakeGold             // 
                    
.GoDropGold         jsr MovEnDropGold               // 
                    
                    ldy LRZ_EnemyCol                // actual enemy col
.GetOrigin          lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // 
                    bne .SetModify                  // 
                    
                    lda #NoTileBlank                // clear
                    
.SetModify          sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
.SetRowAbove        dec LRZ_EnemyRow                // actual enemy row
                    
                    ldy LRZ_EnemyRow                // actual enemy row
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo            // 
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModifyAbove     sta LRZ_XLvlModRowHi            // 
                    
                    ldy LRZ_EnemyCol                // actual enemy col
.GetModifyAbove     lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
.ChkCatchLR         cmp #NoTileLodeRunner           // 
                    bne .GetEnTile                  // 
                    
.KillLR             lsr LR_Alive                    // $00=lr killed
                    
.GetEnTile          lda #NoTileEnemy                // 
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    lda #$04
                    sta LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    bne MovEnGetNextImgUD           // always
                    
MovEnGoTakeGold     jsr MovEnTakeGold               // 
                    
MovEnGetNextImgUD   lda #NoEN_LadderMin             // .hbu008.
                    ldx #NoEN_LadderMax             // .hbu008.
                    
.GetEnNextImgNo     jsr MovENSetImg                 // increase sprite number and check range
                    jsr MovEnGetXYNo                // ac=image no  xr=col offset  yr=row offset
                    jsr ImageOutXtra                // set images on game screen (sprites/shoots/hidden ladders)
                    
MovEnUpStepX        jmp MovEnSaveStatus             // save status values and finish
// ------------------------------------------------------------------------------------------------------------- //
MovEnDown           subroutine
                    ldy LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    cpy #$02
                    bcc MovEnDownStep
                    
.ChkBotRow          ldy LRZ_EnemyRow                // actual enemy row
                    cpy #LR_ScrnMaxRows             // 
                    bcs MovEnDownX                  // already max down
                    
.SetRowBelow        iny                             // 
                    
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModifyBelow     sta LRZ_XLvlModRowHi
                    
                    ldy LRZ_EnemyCol                // actual enemy col
.GetModifyAbove     lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    cmp #NoTileWallHard
                    beq MovEnDownX                  // blocked
                    
                    cmp #NoTileEnemy
                    beq MovEnDownX                  // blocked
                    
                    cmp #NoTileWallWeak             // blocked
                    bne MovEnDownStep
                    
MovEnDownX          jmp MovEnSaveStatus             // save status values and finish
// ------------------------------------------------------------------------------------------------------------- //
MovEnDownStep       subroutine
                    jsr MovEnGetXYNo                // ac=image no  xr=col offset  yr=row offset
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    jsr MovEnCenterLeRi             // 
                    
.SetRowThis         ldy LRZ_EnemyRow                // actual enemy row
                    
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    
.StepDown           inc LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    lda LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    cmp #$05                        // 
                    bcc MovEnDownStepX              // lower - go get gold
                    
.GoDropGold         jsr MovEnDropGold               // 
                    
                    ldy LRZ_EnemyCol                // actual enemy col
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    cmp #NoTileWallWeak             // 
                    bne .SetModify                  // 
                    
                    lda #NoTileBlank                // clear
                    
.SetModify          sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
.SetRowBelow        inc LRZ_EnemyRow                // actual enemy row
                    
                    ldy LRZ_EnemyRow                // actual enemy row
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModifyBelow     sta LRZ_XLvlModRowHi
                    
                    ldy LRZ_EnemyCol                // actual enemy col
.GetModifyBelow     lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
.ChkCatchLR         cmp #NoTileLodeRunner           // 
                    bne .GetEnTile                  // 
                    
.KillLR             lsr LR_Alive                    // $00=lr killed
                    
.GetEnTile          lda #NoTileEnemy
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    lda #$00
                    sta LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    jmp MovEnGetNextImgUD           // 
                    
MovEnDownStepX      jmp MovEnGoTakeGold             // 
// ------------------------------------------------------------------------------------------------------------- //
MovEnLeft           subroutine
.SetRowThis         ldy LRZ_EnemyRow                // actual enemy row
                    
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo            // 
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi            // 
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi            // 
                    
                    ldx LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
                    cpx #$03                        // 
                    bcs MovEnLeftStep               // greater/equal
                    
.ChkMaxLeft         ldy LRZ_EnemyCol                // actual enemy col
                    beq MovEnLeftX                  // already max left
                    
.SetColLeft         dey                             // 
                    
.GetModifyLeft      lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    cmp #NoTileEnemy                // 
                    beq MovEnLeftX                  // blocked
                    
                    cmp #NoTileWallHard             // 
                    beq MovEnLeftX                  // blocked
                    
                    cmp #NoTileWallWeak             // 
                    beq MovEnLeftX                  // blocked
                    
.GetOriginLeft      lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallTrap             // blocked
                    bne MovEnLeftStep               // 
                    
MovEnLeftX          jmp MovEnSaveStatus             // save status values and finish
// ------------------------------------------------------------------------------------------------------------- //
MovEnLeftStep       subroutine
                    jsr MovEnGetXYNo                // ac=image no  xr=col offset  yr=row offset
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    jsr MovEnCenterUpDo             // 
                    
                    lda #LRZ_EnemyMovLeft           // 
                    sta LRZ_EnemyMovDirLR           // actual enemy dir right/left  $ff=left  $01=right
                    
.StepLeft           dec LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
                    bpl .GoTakeGold
                    
.GoDropGold         jsr MovEnDropGold               // 
                    
                    ldy LRZ_EnemyCol                // actual enemy col
.GetModifyLeft1     lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // 
                    bne .SetModifyLeft              // 
                    
                    lda #NoTileBlank                // clear
                    
.SetModifyLeft      sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
.SetColLeft         dec LRZ_EnemyCol                // actual enemy col
                    dey                             //
                    
.GetColLeft         lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
.ChkCatchLR         cmp #NoTileLodeRunner           // 
                    bne .GetEnTile                  // 
                    
.KillLR             lsr LR_Alive                    // $00=lr killed
                    
.GetEnTile          lda #NoTileEnemy
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    lda #$04
                    sta LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
                    bne .GetModifyLeft2             // always
                    
.GoTakeGold         jsr MovEnTakeGold               // 
                    
.GetModifyLeft2     ldy LRZ_EnemyCol                // actual enemy col
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
.ChkPole            cmp #NoTilePole                 // 
                    beq .SetSpritePoleLe            // 
                    
.SetSpriteRunLe     lda #NoEN_RunLeMin              // .hbu008.
                    ldx #NoEN_RunLeMax              // .hbu008
                    bne .DisplaySprite              // always
                    
.SetSpritePoleLe    lda #NoEN_PoleLeMin             // .hbu008.
                    ldx #NoEN_PoleLeMax             // .hbu008.
                    
.DisplaySprite      jsr MovENSetImg                 // increase sprite number and check range
                    jsr MovEnGetXYNo                // ac=image no  xr=col offset  yr=row offset
                    jsr ImageOutXtra                // set images on game screen (sprites/shoots/hidden ladders)
                    
MovEnLeftStepX      jmp MovEnSaveStatus             // save status values and finish
// ------------------------------------------------------------------------------------------------------------- //
MovEnRight          subroutine
.SetRowThis         ldy LRZ_EnemyRow                // actual enemy row
                    
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    
                    ldx LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
                    cpx #$02
                    bcc StepEnemyRight
                    
.ChkMaxRight        ldy LRZ_EnemyCol                // actual enemy col
                    cpy #LR_ScrnMaxCols
                    beq MovEnRightX                 // already max right
                    
.SetColRight        iny
                    
.GetModifyRight     lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    cmp #NoTileEnemy
                    beq MovEnRightX                 // blocked
                    
                    cmp #NoTileWallHard
                    beq MovEnRightX                 // blocked
                    
                    cmp #NoTileWallWeak
                    beq MovEnRightX                 // blocked
                    
.GetOriginLeft      lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallTrap             // blocked
                    bne StepEnemyRight              // Ladder/Pole/XitLadder/Gold/LR
                    
MovEnRightX         jmp MovEnSaveStatus             // save status values and finish
// ------------------------------------------------------------------------------------------------------------- //
StepEnemyRight      subroutine
                    jsr MovEnGetXYNo                // ac=image no  xr=col offset  yr=row offset
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    jsr MovEnCenterUpDo             // 
                    
                    lda #LRZ_EnemyMovRight          // 
                    sta LRZ_EnemyMovDirLR           // actual enemy dir right/left  $ff=left  $01=right
                    
.StepRight          inc LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
                    lda LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
                    cmp #$05
                    bcc .GoTakeGold
                    
.GoDropGold         jsr MovEnDropGold               // 
                    
                    ldy LRZ_EnemyCol                // actual enemy col
.GetOriginRight1    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // 
                    bne .SetModifyRight             // 
                    
                    lda #NoTileBlank                // clear
                    
.SetModifyRight     sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
.SetColRight        inc LRZ_EnemyCol                // actual enemy col
                    iny                             // 
                    
                    lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
.ChkCatchLR         cmp #NoTileLodeRunner           // 
                    bne .GetEnTile                  // 
                    
.KillLR             lsr LR_Alive                    // $00=lr killed
                    
.GetEnTile          lda #NoTileEnemy                // 
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    lda #$00                        // 
                    sta LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
                    beq .GetOriginRight2            // 
                    
.GoTakeGold         jsr MovEnTakeGold               // 
                    
.GetOriginRight2    ldy LRZ_EnemyCol                // actual enemy col
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTilePole                 // 
                    beq .SetSpritePoleRi            // 
                    
.SetSpriteRunRi     lda #NoEN_RunRiMin              // .hbu008.
                    ldx #NoEN_RunRiMax              // .hbu008.
                    bne .DisplaySprite
                    
.SetSpritePoleRi    lda #NoEN_PoleRiMin             // .hbu008.
                    ldx #NoEN_PoleRiMax             // .hbu008.
                    
.DisplaySprite      jsr MovENSetImg                 // increase sprite number and check range
                    jsr MovEnGetXYNo                // ac=image no  xr=col offset  yr=row offset
                    jsr ImageOutXtra                // set images on game screen (sprites/shoots/hidden ladders)
                    
StepEnemyRightX     jmp MovEnSaveStatus             // save status values and finish
// ------------------------------------------------------------------------------------------------------------- //
//                   Function: 
//                   Parms   : xr=LRZ_EnemyCol yr=LRZ_EnemyRow
//                   Returns : ac=move dir
// ------------------------------------------------------------------------------------------------------------- //
MovEnGetMoveDir     subroutine
                    stx LRZ_EnemyColGetDir          // actual enemy work col
                    sty LRZ_EnemyRowGetDir          // actual enemy work row
                    
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyColGetDir          // actual enemy work col
.GetOrigin          lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
.ChkWallWeak        cmp #NoTileWallWeak             // a weak wall in original data must be a hole here
                    bne MovEnTstRowLR               // not in hole
                    
                    lda LRZ_EnemyInHoleTime         // enemy time in hole count down
                    beq MovEnTstRowLR               //   is up
                    bmi MovEnTstRowLR               //   is up
                    
.GetMoveUp          lda #LR_EnemyMoveUp             // move out of hole here
                    
MovEnGetMoveDirX    rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
MovEnTstRowLR       subroutine
                    ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    cpy LRZ_LodeRunRow              // actual row lode runner
                    beq MovEnOnSameRowLR            // lode runner and THIS enemy are on the same row
                    
MovEnTstRowLRX      jmp MovEnOnDiffRowLR            // lode runner and THIS enemy are on different rows
// ------------------------------------------------------------------------------------------------------------- //
MovEnOnSameRowLR    subroutine
                    ldy LRZ_EnemyColGetDir          // actual enemy work col
                    sty LRZ_EnemyColGetDirSav       // save actual enemy work col
                    
                    cpy LRZ_LodeRunCol              // actual col lode runner
                    bcs MovEnIsRightOfLR            // greater/equal
// ------------------------------------------------------------------------------------------------------------- //
MovEnIsLeftOfLR     subroutine
.SetNextColRight    inc LRZ_EnemyColGetDirSav       // save actual enemy work col
                    
                    ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyColGetDirSav       // save actual enemy work col
.GetOriginRight     lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileLadder               // ladder - do not check for empty/trap
                    beq .ChkLRReached               // 
                    
                    cmp #NoTilePole                 // pole - do not check for empty/trap
                    beq .ChkLRReached               // 
                    
.ChkMaxRow          ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    cpy #LR_ScrnMaxRows
                    beq .ChkLRReached               // bottom reached
                    
                    lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginBelow     sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyColGetDirSav       // save actual enemy work col
.GetOriginBelowRi   lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileBlank                // empty without pole/ladder above
                    beq MovEnOnDiffRowLR            // no move right
                    
                    cmp #NoTileWallTrap             // trap without pole/ladder above
                    beq MovEnOnDiffRowLR            // no move right
                    
.ChkLRReached       ldy LRZ_EnemyColGetDirSav       // save actual enemy work col
                    cpy LRZ_LodeRunCol              // actual col lode runner
                    bne .SetNextColRight            // lr pos not reached - set next right
                    
                    lda #LR_EnemyMoveRi             // move right if no empty/trap is found in space between LR and EN
                    
MovEnIsLeftOfLRX    rts                             // without a ladder/pole above
// ------------------------------------------------------------------------------------------------------------- //
MovEnIsRightOfLR    subroutine
.SetNextColLeft     dec LRZ_EnemyColGetDirSav       // save actual enemy work col
                    
                    ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyColGetDirSav       // save actual enemy work col
.GetOriginLeft      lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileLadder               // ladder - do not check for empty/trap
                    beq .ChkLRReached               // 
                    
                    cmp #NoTilePole                 // pole - do not check for empty/trap
                    beq .ChkLRReached               // 
                    
                    ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    cpy #$0f
                    beq .ChkLRReached
                    
                    lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginBelow     sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyColGetDirSav       // save actual enemy work col
.GetOriginBelowLe   lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileBlank                // empty without pole/ladder above
                    beq MovEnOnDiffRowLR            // no move left
                    
                    cmp #NoTileWallTrap             // trap without pole/ladder above
                    beq MovEnOnDiffRowLR            // no move ledt
                    
.ChkLRReached       ldy LRZ_EnemyColGetDirSav       // save actual enemy work col
                    cpy LRZ_LodeRunCol              // actual col lode runner
                    bne .SetNextColLeft             // lr pos not reached - set next left
                    
                    lda #LR_EnemyMoveLe             // move left if no empty/trap is found in space between LR and EN
                    
MovEnIsRightOfLRX   rts                             // without a ladder/pole above
// ------------------------------------------------------------------------------------------------------------- //
MovEnOnDiffRowLR    subroutine                      // 
                    lda #LR_EnemyMoveNone           // init
                    sta LRZ_EnemyMovDir             // actual enemy move direction
                    
                    lda #$ff                        // int to maximum
                    sta LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
                    
                    ldx LRZ_EnemyColGetDir          // actual enemy work col
                    ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    jsr MovEnGetMaxColLR            // get the maximum col possible for left/right moves
                    jsr MovEnGetMaxRowUD            // get the maximum row possible for up/down moves
                    jsr MovEnTst4MoveLeft           // check max left to actual col for a possible move left
                    jsr MovEnTst4MoveRight          // check max left to actual col for a possible move left
                    
                    lda LRZ_EnemyMovDir             // actual enemy move direction
                    
MovEnOnDiffRowLRX   rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
//                   Function: Check from max left col up to actual col for a possible move left
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnTst4MoveLeft   subroutine
.GetMaxColLeft      ldy LRZ_EnemyMaxColLe           // maximum move left - without walls ... in the way
.ChkSavColLeft      cpy LRZ_EnemyColGetDir          // actual enemy work col
                    beq MovEnTst4MoveLeftX          // check left ready if max=actual col
                    
                    ldy LRZ_EnemyRowGetDir          // actual enemy work row
.ChkMaxRow          cpy #LR_ScrnMaxRows             // 
                    beq .TryLadder4Up               // 
                    
                    lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginBelow     sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyMaxColLe           // maximum move left - without walls ... in the way
.GetOriginBelowML   lda (LRZ_XLvlOriPos),y          // below max left - original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // wall
                    beq .TryLadder4Up               // no move left poosible - check for ladder
                    
                    cmp #NoTileWallHard             // wall
                    beq .TryLadder4Up               // no move left poosible - check for ladder
                    
                    ldx LRZ_EnemyMaxColLe           // maximum move left - without walls ... in the way
                    ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    jsr MovEnGetMaxRowDo            // ac=target row
                    
                    ldx LRZ_EnemyMaxColLe           // maximum move left - without walls ... in the way
                    jsr MovEnGetDirMin              // 
                    
                    cmp LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
                    bcs .TryLadder4Up               // greater/equal
                    
.SetNewDirMinLe01   sta LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
                    
.SetDirLeft01       lda #LR_EnemyMoveLe             // 
                    sta LRZ_EnemyMovDir             // actual enemy move direction
                    
.TryLadder4Up       ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    beq .IncMaxColLeft              // max up reached already - no climbing possible
                    
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyMaxColLe           // maximum move left - without walls ... in the way
.GetOrigin          lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes  
                    
                    cmp #NoTileLadder               // ladder
                    bne .IncMaxColLeft              // 
                    
                    ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    ldx LRZ_EnemyMaxColLe           // maximum move left - without walls ... in the way
                    jsr MovEnFindMoveUp             // ac=target row
                    
                    ldx LRZ_EnemyMaxColLe           // maximum move left - without walls ... in the way
                    jsr MovEnGetDirMin              // 
                    
                    cmp LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
                    bcs .IncMaxColLeft              // greater/equal
                    
.SetNewDirMinLe02   sta LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
                    
.SetDirLeft02       lda #LR_EnemyMoveLe             // 
                    sta LRZ_EnemyMovDir             // actual enemy move direction
                    
.IncMaxColLeft      inc LRZ_EnemyMaxColLe           // maximum move left - without walls ... in the way
                    jmp .GetMaxColLeft              // try next col right
                    
MovEnTst4MoveLeftX  rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
//                   Function: Check from max right col down to actual col for a possible move right
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnTst4MoveRight  subroutine
.GetMaxColRight     ldy LRZ_EnemyMaxColRi           // maximum move right - without walls ... in the way
.ChkSavColLeft      cpy LRZ_EnemyColGetDir          // actual enemy work col
                    beq MovEnTst4MoveRightX         // check right ready if max=actual col
                    
                    ldy LRZ_EnemyRowGetDir          // actual enemy work row
.ChkMaxRow          cpy #LR_ScrnMaxRows             // 
                    beq .TryLadder4Up               // max down reached
                    
                    lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginBelow     sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyMaxColRi           // maximum move right - without walls ... in the way
.GetOriginBelowMR   lda (LRZ_XLvlOriPos),y          // below max right - original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // wall
                    beq .TryLadder4Up               // no move right poosible - check for ladder
                    
                    cmp #NoTileWallHard             // wall
                    beq .TryLadder4Up               // no move right poosible - check for ladder
                    
                    ldx LRZ_EnemyMaxColRi           // maximum move right - without walls ... in the way
                    ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    jsr MovEnGetMaxRowDo            // ac=target row
                    
                    ldx LRZ_EnemyMaxColRi           // maximum move right - without walls ... in the way
                    jsr MovEnGetDirMin              // 
                    
                    cmp LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
                    bcs .TryLadder4Up               // greater/equal
                    
.SetNewDirMinRi01   sta LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
                    
.SetDirRight01      lda #LR_EnemyMoveRi             // 
                    sta LRZ_EnemyMovDir             // actual enemy move direction
                    
.TryLadder4Up       ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    beq .DecMaxColRight             // max up reached already - no climbing possible
                    
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyMaxColRi           // maximum move right - without walls ... in the way
.GetOrigin          lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileLadder               // ladder
                    bne .DecMaxColRight             // 
                    
                    ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    ldx LRZ_EnemyMaxColRi           // maximum move right - without walls ... in the way
                    jsr MovEnFindMoveUp             // 
                    
                    ldx LRZ_EnemyMaxColRi           // maximum move right - without walls ... in the way
                    jsr MovEnGetDirMin              // 
                    
                    cmp LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
                    bcs .DecMaxColRight             // greater/equal
                    
.SetNewDirMinRi02   sta LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
                    
.SetDirRight02      lda #LR_EnemyMoveRi             // 
                    sta LRZ_EnemyMovDir             // actual enemy move direction
                    
.DecMaxColRight     dec LRZ_EnemyMaxColRi           // maximum move right - without walls ... in the way
                    jmp .GetMaxColRight             // 
                    
MovEnTst4MoveRightX rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
// MovEnGetMaxRowUD   Function:
//                    Parms   :
//                    Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnGetMaxRowUD    subroutine
                    ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    cpy #LR_ScrnMaxRows             // 
                    beq .ChkTopOfScreen             // already on bottom of screen
                    
                    lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginBelow     sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyColGetDir          // actual enemy work col
.GetOriginBelow     lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // wall
                    beq .ChkTopOfScreen             // no move up
                    
                    cmp #NoTileWallHard             // wall
                    beq .ChkTopOfScreen             // no move up
                    
                    ldx LRZ_EnemyColGetDir          // actual enemy work col
                    ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    jsr MovEnGetMaxRowDo            // ac=target row
                    
                    ldx LRZ_EnemyColGetDir          // actual enemy work col
                    jsr MovEnGetDirMin              // 
                    
                    cmp LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
                    bcs .ChkTopOfScreen             // 
                    
.SetNewDirMinDown   sta LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
                    
.SetDirDown         lda #LR_EnemyMoveDo             // move down to
                    sta LRZ_EnemyMovDir             // actual enemy move direction
                    
.ChkTopOfScreen     ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    beq MovEnGetMaxRowUDX           // 
                    
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    
                    ldy LRZ_EnemyColGetDir          // actual enemy work col
.GetOrigin          lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileLadder               // ladder
                    bne MovEnGetMaxRowUDX           // no - no move up
                    
                    ldx LRZ_EnemyColGetDir          // actual enemy work col
                    ldy LRZ_EnemyRowGetDir          // actual enemy work row
                    jsr MovEnFindMoveUp             // 
                    
                    ldx LRZ_EnemyColGetDir          // actual enemy work col
                    jsr MovEnGetDirMin              // 
                    
                    cmp LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
                    bcs MovEnGetMaxRowUDX           // 
                    
.SetNewDirMinUp     sta LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
                    
.SetDirUp           lda #LR_EnemyMoveUp             // move up to
                    sta LRZ_EnemyMovDir             // actual enemy move direction
                    
MovEnGetMaxRowUDX   rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   : ac=max row  xr=max col left/right
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnGetDirMin      subroutine
                    sta LRZ_Work                    // save max row
                    
.ChkRowLR           cmp LRZ_LodeRunRow              // actual row lode runner
                    bne .NotSameRowLR               // target row not same as LR row
                    
.ChkCol             cpx LRZ_EnemyCol                // same - actual enemy col
                    bcc .ColMaxLower                // lower
                    
.ColMaxHigher       txa                             // 
                    sec                             // 
                    sbc LRZ_EnemyCol                // actual enemy col
.ExitSameHi         rts                             // 
                    
.ColMaxLower        stx LRZ_Work                    // max col left/right
                    
                    lda LRZ_EnemyCol                // actual enemy col
                    sec                             // 
                    sbc LRZ_Work                    // save target row
.ExitSameLo         rts                             // 
                    
.NotSameRowLR       bcc .RowAboveLR                 // enemy on row above LR
                    
.RowBelowLR         sec                             // enemy on row below LR
                    sbc LRZ_LodeRunRow              // actual row lode runner
                    clc                             // 
                    adc #$64 * 2                    // $c8
.ExitBelow          rts                             // 
                    
.RowAboveLR         lda LRZ_LodeRunRow              // actual row lode runner
                    sec                             // 
                    sbc LRZ_Work                    // save target row
                    clc                             // 
                    adc #$64                        // 
                    
MovEnGetDirMinX     rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
MovEnFindUpSav      subroutine
                    lda LRZ_EnemyRowSavUD           // target row from work row
                    
MovEnFindUpSavX     rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   : xr=corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi yr=enemy row
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnFindMoveUp     subroutine
                    sty LRZ_EnemyRowSavUD           // actual enemy row
                    stx LRZ_EnemyColSavUD           // corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi
                    
.SetNextOrigin      lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin01        sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyColSavUD           // corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi
.GetOrigin01        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileLadder               // ladder
.XitWithOriginRow   bne MovEnFindUpSav              // no - exit and return saved row
                    
.DecSavRowUD        dec LRZ_EnemyRowSavUD           // yes - may move up so point to next row above enemy
                    
                    ldy LRZ_EnemyColSavUD           // corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi
.ChkMaxColLe        beq .ChkMaxColRi                // already max left
                    
                    dey                             // 
.GetOriginLeft      lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // wall
                    beq .SetSavRow2MaxRowLe         // 
                    
                    cmp #NoTileWallHard             // wall
                    beq .SetSavRow2MaxRowLe         // 
                    
                    cmp #NoTileLadder               // ladder
                    beq .SetSavRow2MaxRowLe         // 
                    
                    ldy LRZ_EnemyRowSavUD           // target row from work row
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginAbove01   sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyColSavUD           // corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi
                    dey                             // 
.GetOriginAboveLe   lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTilePole                 // pole
                    bne .ChkMaxColRi                // no
                    
.SetSavRow2MaxRowLe ldy LRZ_EnemyRowSavUD           // target row from work row
                    sty LRZ_EnemyRowMaxUD           // actual max row
                    
.XitWithBelowEquLe  cpy LRZ_LodeRunRow              // actual row lode runner
                    bcc MovEnFindRowMaxUp           // lower
                    beq MovEnFindRowMaxUp           // equal - move up only not above LR row
                    
.ChkMaxColRi        ldy LRZ_EnemyColSavUD           // corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi
                    cpy #LR_ScrnMaxCols             // 
                    beq .ChkTop                     // 
                    
                    ldy LRZ_EnemyRowSavUD           // target row from work row
                    lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin02        sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyColSavUD           // corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi
                    iny                             // 
.GetOriginRight     lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // wall
                    beq .SetSavRow2MaxRowRi         // 
                    
                    cmp #NoTileWallHard             // wall
                    beq .SetSavRow2MaxRowRi         // 
                    
                    cmp #NoTileLadder               // ladder
                    beq .SetSavRow2MaxRowRi         // 
                    
                    ldy LRZ_EnemyRowSavUD           // target row from work row
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginAbove02   sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyColSavUD           // corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi
                    iny
.PtrOriginAboveRi   lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTilePole                 // pole
                    bne .ChkTop                     // 
                    
.SetSavRow2MaxRowRi ldy LRZ_EnemyRowSavUD           // target row from work row
                    sty LRZ_EnemyRowMaxUD           // actual max row
                    
.XitWithBelowEquRi  cpy LRZ_LodeRunRow              // actual row lode runner
                    bcc MovEnFindRowMaxUp           // 
                    beq MovEnFindRowMaxUp           // 
                    
.ChkTop             ldy LRZ_EnemyRowSavUD           // target row from work row
                    cpy #LR_ScrnMinRows+1           // 
                    bcc .RetTargetRow               // lower 
                    
.GoCheckNext        jmp .SetNextOrigin              // 
                    
.RetTargetRow       tya                             // return LRZ_EnemyRowSavUD
                    
MovEnFindMoveUpX    rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
MovEnFindRowMaxUp   subroutine
                    lda LRZ_EnemyRowMaxUD           // actual max row
                    
MovEnFindRowMaxUpX  rts
// ------------------------------------------------------------------------------------------------------------- //
MovEnGetMaxRowSav   subroutine
                    lda LRZ_EnemyRowSavUD           // target row from work row
                    
MovEnGetMaxRowSavX  rts
// ------------------------------------------------------------------------------------------------------------- //
// MovEnGetMaxRowDo  Function: 
//                   Parms   :
//                   Returns : LRZ_EnemyMaxColLe
// ------------------------------------------------------------------------------------------------------------- //
MovEnGetMaxRowDo    subroutine
                    sty LRZ_EnemyRowSavUD           // target row from work row
                    stx LRZ_EnemyColSavUD           // target col from work col
                    
.ChkNextBelow       lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginBelow     sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyColSavUD           // target col from work col
.GetOriginBelow     lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // wall
                    beq MovEnGetMaxRowSav           // 
                    
                    cmp #NoTileWallHard             // wall
                    beq MovEnGetMaxRowSav           // 
                    
                    ldy LRZ_EnemyRowSavUD           // target row from work row
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyColSavUD           // target col from work col
.GetOrigin          lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileBlank                // empty
                    beq .IncRowSavUD                // 
                    
                    cpy #$00                        // max left
                    beq .ChkMaxColSavUD             // 
                    
                    dey                             // 
.GetOriginLe        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTilePole                 // pole
                    beq .SetSav2MaxRowLe            // 
                    
                    ldy LRZ_EnemyRowSavUD           // target row from work row
                    lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginBelowLe   sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyColSavUD           // target col from work col
                    dey                             // 
.GetOriginBelowLe   lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // wall
                    beq .SetSav2MaxRowLe            // 
                    
                    cmp #NoTileWallHard             // wall
                    beq .SetSav2MaxRowLe            // 
                    
                    cmp #NoTileLadder               // ladder
                    bne .ChkMaxColSavUD             // all others - empty/pole/trap/gold
                    
.SetSav2MaxRowLe    ldy LRZ_EnemyRowSavUD           // target row from work row
                    sty LRZ_EnemyRowMaxUD           // actual max row
                    
                    cpy LRZ_LodeRunRow              // actual row lode runner
                    bcs .RetRowMaxUD                // greater/equal row LR
                    
.ChkMaxColSavUD     ldy LRZ_EnemyColSavUD           // target col from work col
                    cpy #LR_ScrnMaxCols             // 
                    bcs .IncRowSavUD                // max right reached
                    
                    iny                             // 
.GetOriginRi        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTilePole                 // pole
                    beq .SetSav2MaxRowRi            // 
                    
                    ldy LRZ_EnemyRowSavUD           // target row from work row
                    lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginBelowRi   sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyColSavUD           // target col from work col
                    iny                             // 
.GetOriginBelowRi   lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // wall
                    beq .SetSav2MaxRowRi            // 
                    
                    cmp #NoTileLadder               // ladder
                    beq .SetSav2MaxRowRi            // 
                    
                    cmp #NoTileWallHard             // wall
                    bne .IncRowSavUD                // all others - empty/pole/trap/gold
                    
.SetSav2MaxRowRi    ldy LRZ_EnemyRowSavUD           // target row from work row
                    sty LRZ_EnemyRowMaxUD           // actual max row
                    
                    cpy LRZ_LodeRunRow              // actual row lode runner
                    bcs .RetRowMaxUD                // greater/equal row LR
                    
.IncRowSavUD        inc LRZ_EnemyRowSavUD           // target row from work row
                    
.ChkRowSavUD        ldy LRZ_EnemyRowSavUD           // target row from work row
                    cpy #LR_ScrnMaxRows+1           // 
                    bcs .RetRowMaxScren             // greater/equal
                    
.GoCheckNext        jmp .ChkNextBelow               // next round
                    
.RetRowMaxScren     lda #LR_ScrnMaxRows             // 
                    rts                             // 
                    
.RetRowMaxUD        lda LRZ_EnemyRowMaxUD           // actual max row
MovEnGetMaxRowDoX   rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
// MovEnGetMaxColLR   Function: Gets the max possible move column left/right
//                    Parms   :
//                    Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnGetMaxColLR    subroutine
                    stx LRZ_EnemyMaxColLe           // maximum move left - without walls ... in the way
                    stx LRZ_EnemyMaxColRi           // maximum move right - without walls ... in the way
                    sty LRZ_EnemyRowSav             // save actual enemy work row
                    
.GetNextColLeft     lda LRZ_EnemyMaxColLe           // maximum move left - without walls ... in the way
                    beq .GetNextColRight            // max col left already reached
                    
                    ldy LRZ_EnemyRowSav             // save actual enemy work row
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo            // 
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModifyLeft      sta LRZ_XLvlModRowHi            // 
                    
                    ldy LRZ_EnemyMaxColLe           // maximum move left - without walls ... in the way
                    dey                             // get tile one left from
.GetModifyLeft      lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // wall
                    beq .GetNextColRight            // no move left
                    
                    cmp #NoTileWallHard             // wall
                    beq .GetNextColRight            // no move left
                    
                    cmp #NoTileLadder               // ladder
                    beq .SetNextColLeft             // check next left
                    
                    cmp #NoTilePole                 // pole
                    beq .SetNextColLeft             // check next left
                    
.ChkMaxRowLeft      ldy LRZ_EnemyRowSav             // empty/trap/gold/en/lr left to check here
                    cpy #LR_ScrnMaxRows             // 
                    beq .SetNextColLeft             // enemy on bottom row already - check next left
                    
                    lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginBelowLe   sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyMaxColLe           // maximum move left - without walls ... in the way
                    dey                             // get tile one left/down from
.GetOriginBelowLe   lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // wall below an empty/trap on the actual left
                    beq .SetNextColLeft             // check next left
                    
                    cmp #NoTileWallHard             // wall below an empty/trap on the actual left
                    beq .SetNextColLeft             // check next left
                    
                    cmp #NoTileLadder               // ladder below an empty/trap on the actual left
                    bne .SetOneXtraLeft             // empty/pole/trap/gold - dec and check right
                    
.SetNextColLeft     dec LRZ_EnemyMaxColLe           // maximum move left - without walls ... in the way
                    bpl .GetNextColLeft
                    
.SetOneXtraLeft     dec LRZ_EnemyMaxColLe           // maximum move left - without walls ... in the way
                    
.GetNextColRight    lda LRZ_EnemyMaxColRi           // maximum move right - without walls ... in the way
                    cmp #LR_ScrnMaxCols             // $1b
                    beq MovEnGetMaxColLRX           // max col right already reached
                    
                    ldy LRZ_EnemyRowSav             // save actual enemy work row
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo            // 
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify4Ri       sta LRZ_XLvlModRowHi            // 
                    
                    ldy LRZ_EnemyMaxColRi           // maximum move right - without walls ... in the way
                    iny                             // try one tile right from
.GetModifyRight     lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // wall
                    beq MovEnGetMaxColLRX           // no move right
                    
                    cmp #NoTileWallHard             // wall
                    beq MovEnGetMaxColLRX           // no move right
                    
                    cmp #NoTileLadder               // ladder
                    beq .SetNextColRight            // check next right
                    
                    cmp #NoTilePole                 // pole
                    beq .SetNextColRight            // check next right
                    
.ChkMaxRowRight     ldy LRZ_EnemyRowSav             // save actual enemy work row
                    cpy #LR_ScrnMaxRows             // 
                    beq .SetNextColRight            // 
                    
                    lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo            // 
                    lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOriginBelowRi   sta LRZ_XLvlOriRowHi            // 
                    
                    ldy LRZ_EnemyMaxColRi           // maximum move right - without walls ... in the way
                    iny                             // try one tile right from
.GetOriginBelowRi   lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    cmp #NoTileWallWeak             // wall below an empty/trap on the actual right
                    beq .SetNextColRight            // check next right
                    
                    cmp #NoTileWallHard             // wall below an empty/trap on the actual right
                    beq .SetNextColRight            // check next right
                    
                    cmp #NoTileLadder               // ladder below an empty/trap on the actual right
                    bne .SetOneXtraRight            // empty/pole/trap/gold - inc and exit
                    
.SetNextColRight    inc LRZ_EnemyMaxColRi           // maximum move right - without walls ... in the way
                    bpl .GetNextColRight            // 
                    
.SetOneXtraRight    inc LRZ_EnemyMaxColRi           // maximum move right - without walls ... in the way
                    
MovEnGetMaxColLRX   rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
// MovEnGetXYNo      Function:
//                   Parms   :
//                   Returns : ac=image no  xr=col offset  yr=row offset
// ------------------------------------------------------------------------------------------------------------- //
MovEnGetXYNo        subroutine
                    ldx LRZ_EnemyCol                // actual enemy col
                    ldy LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
                    jsr GetXOff
                    
.SavRowOff          stx LRZ_ImageNo                 // image number
                    
                    ldy LRZ_EnemyRow                // actual enemy row
                    ldx LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    jsr GetYOff
                    
                    ldx LRZ_EnemySpriteNo           // actual enemy sprite number
                    lda TabSpriteNoEnemy,x          // enemy move images
                    
.GetRowOff          ldx LRZ_ImageNo                 // image number
                    
MovEnGetXYNoX       rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnTakeGold       subroutine
                    lda LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
                    cmp #$02
                    bne MovEnTakeGoldX
                    
                    lda LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    cmp #$02
                    bne MovEnTakeGoldX
                    
                    ldy LRZ_EnemyRow                // actual enemy row
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    
                    ldy LRZ_EnemyCol                // actual enemy col
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    cmp #NoTileGold
                    bne MovEnTakeGoldX              // no gold on level tile
                    
                    lda LRZ_EnemyInHoleTime         // enemy time in hole count down
                    bmi MovEnTakeGoldX
                    
                    lda #$ff
                    sec
                    sbc LR_EnmyBirthCol             // actual enemy rebirth column (increases with every main loop)
                    sta LRZ_EnemyInHoleTime         // enemy time in hole count down
                    
                    lda #NoTileBlank                // clear gold in
                    sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    
                    ldy LRZ_EnemyRow                // actual enemy row
                    sty LRZ_ScreenRow               // screen row  (00-0f)
                    ldy LRZ_EnemyCol                // actual enemy col
                    sty LRZ_ScreenCol               // screen col  (00-1b)
                    jsr ImageOut2Prep               // direct output to preparation screen
                    
                    ldy LRZ_ScreenRow               // screen row  (00-0f)
                    ldx LRZ_ScreenCol               // screen col  (00-1b)
                    jsr GetColRowGfxOff             // offsets in xr=col yr=row
                    
                    lda #NoTileGold
                    jmp ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    
MovEnTakeGoldX      rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnDropGold       subroutine
                    lda LRZ_EnemyInHoleTime         // enemy time in hole count down
                    bpl MovEnDropGoldX              // 
                    
                    inc LRZ_EnemyInHoleTime         // enemy time in hole count down
                    bne MovEnDropGoldX              // 
                    
                    ldy LRZ_EnemyRow                // actual enemy row
                    sty LRZ_ScreenRow               // screen row  (00-0f)
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    
                    ldy LRZ_EnemyCol                // actual enemy col
                    sty LRZ_ScreenCol               // screen col  (00-1b)
                    lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    cmp #NoTileBlank
                    bne .NotEmpty
                    
                    lda #NoTileGold
                    sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    jsr ImageOut2Prep               // direct output to preparation screen
                    
                    ldy LRZ_ScreenRow               // screen row  (00-0f)
                    ldx LRZ_ScreenCol               // screen col  (00-1b)
                    jsr GetColRowGfxOff             // offsets in xr=col yr=row
                    
                    lda #NoTileGold
                    jmp ImageOutXtra                // set images on game screen (sprites/shoots/hidden ladders)
                    
.NotEmpty           dec LRZ_EnemyInHoleTime         // enemy time in hole count down
                    
MovEnDropGoldX      rts                             //
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovENSetImg         subroutine
                    inc LRZ_EnemySpriteNo           // actual enemy sprite number
.ChkMin             cmp LRZ_EnemySpriteNo           // actual enemy sprite number
                    bcc .ChkMax
                    
.SetSpriteNo        sta LRZ_EnemySpriteNo           // actual enemy sprite number
                    rts
                    
.ChkMax             cpx LRZ_EnemySpriteNo           // actual enemy sprite number
                    bcc .SetSpriteNo
                    
MovENSetImgX        rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnCenterLeRi     subroutine
                    lda LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
                    cmp #$02                        // center
                    bcc .IncPos                     // lower
                    beq MovEnCenterLeRiX            // in center
                    
.DecPos             dec LRZ_EnemyOnImgPosLR         // back left a bit
                    jmp MovEnTakeGold
                    
.IncPos             inc LRZ_EnemyOnImgPosLR         // back right a bit
                    jmp MovEnTakeGold
                    
MovEnCenterLeRiX    rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnCenterUpDo     subroutine
                    lda LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    cmp #$02                        // center
                    bcc .IncPos                     // lower
                    beq MovEnCenterUpDoX            // in center
                    
.DecPos             dec LRZ_EnemyOnImgPosUD         // back up a bit
                    jmp MovEnTakeGold
                    
.IncPos             inc LRZ_EnemyOnImgPosUD         // back down a bit
                    jmp MovEnTakeGold
                    
MovEnCenterUpDoX    rts
// ------------------------------------------------------------------------------------------------------------- //
MovEnSaveStatus     subroutine
                    ldx LR_NoEnemy2Move             // # of enemy to move
                    
                    lda LRZ_EnemyCol                // actual enemy col
                    sta LR_TabEnemyCol,x            // adr column enemies
                    lda LRZ_EnemyRow                // actual enemy row
                    sta LR_TabEnemyRow,x            // adr row enemies
                    lda LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
                    sta LR_TabEnemyPosLR,x          // enemy pos on image left/right tab
                    lda LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    sta LR_TabEnemyPosUD,x          // enemy pos on image up/down tab
                    lda LRZ_EnemyInHoleTime         // enemy time in hole count down
                    sta LR_TabEnemyGold,x           // enemy has gold tab
                    lda LRZ_EnemyMovDirLR           // actual enemy dir right/left  $ff=left  $01=right
                    sta LR_TabEnemySpr__,x          //
                    lda LRZ_EnemySpriteNo           // actual enemy sprite number
                    sta LR_TabEnemySprNo,x          // actual enemy sprite number
                    
MovEnSaveStatusX    rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetEnemyStatus      subroutine
                    ldx LR_NoEnemy2Move             // # of enemy to move
                    
                    lda LR_TabEnemyCol,x            // adr column enemies
                    sta LRZ_EnemyCol                // enemy col
                    lda LR_TabEnemyRow,x            // adr row enemies
                    sta LRZ_EnemyRow                // actual enemy row
                    lda LR_TabEnemyPosLR,x          // enemy pos on image left/right tab
                    sta LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
                    lda LR_TabEnemyPosUD,x          // enemy pos on image up/down tab
                    sta LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
                    lda LR_TabEnemySprNo,x          // actual enemy sprite number
                    sta LRZ_EnemySpriteNo           // actual enemy sprite number
                    lda LR_TabEnemySpr__,x          //
                    sta LRZ_EnemyMovDirLR           // actual enemy dir right/left  $ff=left  $01=right
                    lda LR_TabEnemyGold,x           // enemy has gold tab
                    sta LRZ_EnemyInHoleTime         // enemy time in hole count down
                    
GetEnemyStatusX     rts
// ------------------------------------------------------------------------------------------------------------- //
// CloseHoles        Function: 
//                   Parms   : 
//                   Returns : 
// ------------------------------------------------------------------------------------------------------------- //
CloseHoles          subroutine                      // 
                    jsr EnemyRebirth                // 
                    
                    inc LR_EnmyBirthCol             // actual enemy rebirth column - increases here with every main loop
                    
.ChkBirthColMax     lda LR_EnmyBirthCol             // actual enemy rebirth column (increases with every main loop)
                    cmp #LR_ScrnMaxCols+1           // $1b - max 27 cols
                    bcc .ChkHoles                   // .hbu025. - lower
                    
.SetBirthColMin     lda #$00                        // restart
                    sta LR_EnmyBirthCol             // actual enemy rebirth column (increases with every main loop)
                    
.ChkHoles           ldx #LR_TabHoleMax              // start with the max of 30 open holes
.GetNextHoleTime    lda LR_TabHoleOpenTime,x        // hole open time tab
                    stx $52                         // open holes time pointer
                    bne .DecHoleTime                // 
                    
                    jmp .SetNextHoleTime            // set next hole time
                    
.DecHoleTime        dec LR_TabHoleOpenTime,x        // open holes counter
                    beq .HoleOpenTimeOut            // open time out - so close
                    
                    lda LR_TabHoleCol,x             // hole column tab
                    sta LRZ_ScreenCol               // screen col  (00-1b)
                    lda LR_TabHoleRow,x             // hole row tab
                    sta LRZ_ScreenRow               // screen row  (00-0f)
                    
                    lda LR_TabHoleOpenTime,x        // hole open time tab
.ChkClose1stStep    cmp #LR_TabHoleOpenStep1        // first step close
                    bne .ChkClose2ndStep            //  already passed
                    
                    lda #NoCloseHole00              // close hole 1st step
.CloseStepOut       jsr ImageOut2Prep               // direct output to preparation screen
                    
                    ldx LRZ_ScreenCol               // screen col  (00-1b)
                    ldy LRZ_ScreenRow               // screen row  (00-0f)
                    jsr GetColRowGfxOff             // offsets in xr=col yr=row
                    
                    lda #$00
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    
.GoSetNextHoleTime  jmp .SetNextHoleTime            // set next hole time
                    
.ChkClose2ndStep    cmp #LR_TabHoleOpenStep2        // second step close
                    bne .GoSetNextHoleTime          //  already passed
                    
                    lda #NoCloseHole01              // close hole 2nd step
                    bne .CloseStepOut               // always
                    
.HoleOpenTimeOut    ldx $52                         // open holes time pointer
                    ldy LR_TabHoleRow,x             // hole row tab
                    sty LRZ_ScreenRow               // screen row  (00-0f)
                    jsr SetCtrlDataPtr              // .hbu025. - set both expanded level data pointers

                    ldy LR_TabHoleCol,x             // hole column tab
                    sty LRZ_ScreenCol               // screen col  (00-1b)
                    
.ChkHoleContent     lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    cmp #$00
                    bne .ChkHoleLR                  // closed hole was not emty
                    
.HoleWasEmpty       jmp .CloseWithWall              // do a simple close
                    
.ChkHoleLR          cmp #NoTileLodeRunner
                    bne .ChkHoleEnemy
                    
                    lsr LR_Alive                    // $00=lr killed
                    
.ChkHoleEnemy       cmp #NoTileEnemy
                    beq .ReviveEnemy
                    
.ChkHoleGold        cmp #NoTileGold
                    bne .GoCloseWithWall
                    
                    dec LR_Gold2Get
                    
.GoCloseWithWall    jmp .CloseWithWall
                    
.ReviveEnemy        lda #NoTileWallWeak
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    jsr ImageOut2Disp               // direct output to display screen
                    
                    lda #NoTileWallWeak
                    jsr ImageOut2Prep               // direct output to preparation screen
                    
                    ldx LR_EnmyNo                   // number of enemies
.ChkEnemyCol        lda LR_TabEnemyCol,x            // adr column enemies
                    cmp LRZ_ScreenCol               // screen col  (00-1b)
                    beq .ChkEnemyRow
                    
                    jmp .SetNextEnemy
                    
.ChkEnemyRow        lda LR_TabEnemyRow,x            // adr row enemies
                    cmp LRZ_ScreenRow               // screen row  (00-0f)
                    bne .SetNextEnemy
                    
.SpritesOff         lda TabEnemyDisab,x             // disable enemy sprite tab
                    and SPENA                       // VIC 2 - $D015 = Sprite Enable
                    sta SPENA                       // VIC 2 - $D015 = Sprite Enable
                    
                    lda LR_TabEnemyGold,x           // enemy has gold tab
                    bpl .ClearGold                  // 
                    
                    dec LR_Gold2Get                 // enemy still had gold
                    
.ClearGold          lda #$7f                        // reset
                    sta LR_TabEnemyGold,x           // enemy has gold tab entry
                    
                    stx LR_NoEnemy2Move             // # of enemy to move
                    jsr GetEnemyStatus              // 
                    jsr MovEnGetXYNo                // ac=image no  xr=col offset  yr=row offset
                    jsr ImageOutClear               // clear on game screen (shootings/close holes/remove gold)
                    
                    ldx LR_NoEnemy2Move             // # of enemy to move
                    ldy #$01                        // start with row $01 - not with top row $00
                    sty LRZ_ScreenRow               // screen row  (00-0f)
                    
.FindRebirthPosI    ldy LRZ_ScreenRow               // screen row  (00-0f)
                    jsr SetCtrlDataPtr              // .hbu025. - set both expanded level data pointers
                    
                    ldy LR_EnmyBirthCol             // actual enemy rebirth column (increases with every main loop)
.FindRebirthPos     lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    cmp #NoTileBlank                // empty
                    bne .TryNextPos                 // .hbu025. - not found
                    
                    lda (LRZ_XLvlModPos),y          // .hbu025. - modified level data - with lr/en replacements/holes
                    cmp #NoTileBlank                // .hbu025. - no rebirth if already enemy occupied
                    beq .SetRebirthPos              // .hbu025. - found - both tables position free
                    
.TryNextPos         inc LR_EnmyBirthCol             // actual enemy rebirth column (increases with every main loop)
                    
.ChkMaxPos          ldy LR_EnmyBirthCol             // actual enemy rebirth column (increases with every main loop)
                    cpy #LR_ScrnMaxCols+1           // $1b - max 27 cols
                    bcc .FindRebirthPos
                    
.SetNextRow         inc LRZ_ScreenRow               // next screen row  (00-0f)
                    
.GetBirthCol        lda #LR_ScrnMinCols             // reset
                    sta LR_EnmyBirthCol             // actual enemy rebirth column (increases with every main loop)
                    beq .FindRebirthPosI            // rebirth on the leftmost possible free col after row $01
                    
.SetRebirthPos      tya
                    sta LR_TabEnemyCol,x            // adr column enemies
                    
                    lda LRZ_ScreenRow               // screen row  (00-0f)
                    sta LR_TabEnemyRow,x            // adr row enemies
                    
                    lda #LR_TabEnemyRebStart        // start value
                    sta LR_TabEnemyRebTime,x        // enemy rebirth step time
                    
                    lda #$02                        // mid
                    sta LR_TabEnemyPosUD,x          // enemy pos on image up/down tab
                    sta LR_TabEnemyPosLR,x          // enemy pos on image left/right tab
                    
                    lda #$00                        // 
                    sta LR_TabEnemySprNo,x          // actual enemy sprite number
                    
.ScoreRebirth       lda #<LR_ScoreRebirth           // ac=score  10s
                    ldy #>LR_ScoreRebirth           // yr=score 100s
                    jsr Score2BaseLine 
                    jmp .SetNextHoleTime            // set next hole time
                    
.SetNextEnemy       dex
                    beq .CloseWithWall
                    jmp .ChkEnemyCol
                    
.CloseWithWall      lda #NoTileWallWeak
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    jsr ImageOut2Disp               // direct output to display screen
                    
                    lda #NoTileWallWeak
                    jsr ImageOut2Prep               // direct output to preparation screen
                    
.SetNextHoleTime    ldx $52                         // open holes time pointer
                    dex
                    bmi CloseHolesX                 // all open holes processed
                    
                    jmp .GetNextHoleTime
                    
CloseHolesX         rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
EnemyRebirth        subroutine                      // do one rebirth step per mainloop round for each candidate
                    ldx LR_EnmyNo                   // number of enemies
                    beq EnemyRebirthX               // 
                    
.GetEnemyNumber     lda LR_NoEnemy2Move             // # of enemy to move
                    pha                             // save
                    
.GetNextStepTime    lda LR_TabEnemyRebTime,x        // enemy rebirth step time
                    beq SetNextEnemyTime            // not dead
                    
.SetEnemyNumber     stx LR_NoEnemy2Move             // # of enemy to move
                    jsr GetEnemyStatus              // xr not changed
                    
.ClearGold          lda #$7f                        // no gold
                    sta LR_TabEnemyGold,x           // enemy has gold tab
                    
                    lda LR_TabEnemyCol,x            // adr column enemies
                    sta LRZ_ScreenCol               // screen col  (00-1b)
                    lda LR_TabEnemyRow,x            // adr row enemies
                    sta LRZ_ScreenRow               // screen row  (00-0f)
                    
.ChkRebirthTime     lda LR_TabEnemyRebTime,x        // .hbu006. - enemy rebirth step time
                    cmp #LR_TabEnemyRebStart        // .hbu006. - startvalue
                    bcc .DecRebirthTime             // .hbu006. - color only once
                    
.SetRebirthColor    jsr SetRebirthColor             // .hbu006. - set rebirth background color to enemy color
                    
.DecRebirthTime     dec LR_TabEnemyRebTime,x        // enemy rebirth step time
                    beq EnemyReborn                 // rebirth completed
                    
.RebirthSteps       lda LR_TabEnemyRebTime,x        // enemy rebirth step time
                    tax                             // 
                    lda TabReviveEnemy,x            // rebirth step images
                    pha                             // save
                    jsr ImageOut2Prep               // direct output to preparation screen
                    jsr MovEnGetXYNo                // ac=image no  xr=col offset  yr=row offset
                    
                    pla                             // restore rebirth step image
                    jsr ImageOutXtra                // set images on game screen (sprites/shoots/hidden ladders)
                    
.GetNextEnemy       ldx LR_NoEnemy2Move             // # of enemy to move
SetNextEnemyTime    dex                             // point to next enemies birth step time
                    bne .GetNextStepTime            // 
                    
                    pla                             // restore
                    sta LR_NoEnemy2Move             // # of enemy to move
                    
EnemyRebirthX       rts
// ------------------------------------------------------------------------------------------------------------- //
EnemyReborn         Subroutine
                    ldy LRZ_ScreenRow               // screen row  (00-0f)
                    jsr SetCtrlDataPtr              // .hbu025. - set both expanded level data pointers

                    ldy LRZ_ScreenCol               // screen col  (00-1b)
                    lda #NoTileEnemy
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    
                    lda (LRZ_XLvlOriPos),y          // modified level data - with lr/en replacements/holes
                    beq .RefreshBlank               // .hbu025.
                    
.RefreshLadder      lda #NoTileLadder               // .hbu025. - became hidden ladder - clear remnants
                    jsr ImageOut2Prep               // direct output to preparation screen
                    
                    lda #NoTileLadder               // .hbu025. - became hidden ladder - clear remnants
                    jsr ImageOut2Disp               // .hbu025. - direct output to display screen
                    
                    jmp .SetEnemy                   // .hbu025.
                    
.RefreshBlank       lda #NoTileBlank                // wipe out the rebirth step remnants
                    jsr ImageOut2Prep               // direct output to preparation screen
                    
                    lda #NoTileBlank                // wipe out the rebirth step remnants
                    jsr ImageOut2Disp               // direct output to display screen
                    
.SetEnemy           lda #NoTileEnemy
                    jsr ImageOut2Disp               // direct output to display screen
                    
.InitEnemyVals      lda #$00
                    ldx LR_NoEnemy2Move             // # of enemy to move
                    sta LR_TabEnemyGold,x           // enemy has gold tab
                    sta LR_TabEnemyRebTime,x        // enemy rebirth step time
                    
.SpritesOn          ldx LR_NoEnemy2Move             // # of enemy to move
                    lda TabEnemyEnab,x              // enable enemy sprite tab
                    ora SPENA                       // VIC 2 - $D015 = Sprite Enable
                    sta SPENA                       // VIC 2 - $D015 = Sprite Enable
                    
EnemyRebornX        jmp SetNextEnemyTime            // check next enemy
// ------------------------------------------------------------------------------------------------------------- //
TabEnemyEnab        dc.b $00 // ........
                    dc.b $04 // .....#..
                    dc.b $08 // ....#...
                    dc.b $10 // ...#....
                    dc.b $40 // .#......
                    dc.b $80 // #.......
// ------------------------------------------------------------------------------------------------------------- //
TabEnemyDisab       dc.b $00 // ........
                    dc.b $fb // #####.##
                    dc.b $f7 // ####.###
                    dc.b $ef // ###.####
                    dc.b $bf // #.######
                    dc.b $7f // .#######
// ------------------------------------------------------------------------------------------------------------- //
TabReviveEnemy      equ *
                    dc.b $00                        // step $14 is end mark
                    dc.b NoReviveEnemy13            // 
                    dc.b NoReviveEnemy12            // 
                    dc.b NoReviveEnemy11            // 
                    dc.b NoReviveEnemy10            // 
                    dc.b NoReviveEnemy0f            // 
                    dc.b NoReviveEnemy0e            // 
                    dc.b NoReviveEnemy0d            // 
                    dc.b NoReviveEnemy0c            // 
                    dc.b NoReviveEnemy0b            // 
                    dc.b NoReviveEnemy0a            // 
                    dc.b NoReviveEnemy09            // 
                    dc.b NoReviveEnemy08            // 
                    dc.b NoReviveEnemy07            // 
                    dc.b NoReviveEnemy06            // 
                    dc.b NoReviveEnemy05            // 
                    dc.b NoReviveEnemy04            // 
                    dc.b NoReviveEnemy03            // 
                    dc.b NoReviveEnemy02            // 
                    dc.b NoReviveEnemy01            // 
// ------------------------------------------------------------------------------------------------------------- //
InitLodSavGame      subroutine
                    pha                             // save action key
                    
.SetScreen          lda #>LR_ScrnHiReDisp           //
                    sta LRZ_GfxScreenOut            // control gfx screen output - display=$20(00) hidden=$40(00)                  
                    
                    lda LR_LevelNoDisk              //
                    sta CR_SaveNoDisk               // save disk level no 000-049
                    
.SetListLevel       lda #LR_LevelDiskSave           // 152 - (t=$0c s=$0b) containes the saved game entry list
                    sta LR_LevelNoDisk              // 000-149
                    
                    lda #>LR_SaveList               //
                    sta Mod_GetDiskByte             // set read/write buffer pointers
                    sta Mod_PutDiskByte             //
                    
                    lda #LR_DiskRead                //
.GetListLevel       jsr ControlDiskOper             // read in save game list
                    
                    pla                             // restore action key
.ChkUserKeyLoad     cmp #$aa                        // "L"
.GoSave             bne SaveGame                    // "S"
                    
.GoLoad             jmp LoadGame
// ------------------------------------------------------------------------------------------------------------- //
ExitLodSavGame      subroutine
                    lda #>LR_LvlDataSavLod          //
.RstTargetBuffer    sta Mod_GetDiskByte             // reset read/write buffer pointers
                    sta Mod_PutDiskByte             // 
                    
.RstLevel           jsr ClearHiresDispH             // restore level
                    jsr ColorLevelDyn               // 
ExitLodSavGameX     jmp ColorStatus                 // 
// ------------------------------------------------------------------------------------------------------------- //
SaveGame            subroutine
                    jsr ShowSaveList                //
                    
.TitleLine          jsr LvlEdCurPosInit             // set cursor to top left screen pos
                    jsr TextOut                     // <s writes a game into list>
                    dc.b $a0 // <blank>
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $d7 // W
                    dc.b $d2 // R
                    dc.b $c9 // I
                    dc.b $d4 // T
                    dc.b $c5 // E
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $a0 // <blank>
                    dc.b $c7 // G
                    dc.b $c1 // A
                    dc.b $cd // M
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $c9 // I
                    dc.b $ce // N
                    dc.b $d4 // T
                    dc.b $cf // O
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $c9 // I
                    dc.b $d3 // S
                    dc.b $d4 // T
                    dc.b $8d // <newline>
                    dc.b $a0 // <blank>
                    dc.b $c4 // D                    // <d deletes a game from list>
                    dc.b $a0 // <blank>
                    dc.b $c4 // D
                    dc.b $c5 // E
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $d4 // T
                    dc.b $c5 // E
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $a0 // <blank>
                    dc.b $c7 // G
                    dc.b $c1 // A
                    dc.b $cd // M
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $c6 // F
                    dc.b $d2 // R
                    dc.b $cf // O
                    dc.b $cd // M
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $c9 // I
                    dc.b $d3 // S
                    dc.b $d4 // T
                    dc.b $8d // <newline>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $bc // <
                    dc.b $d2 // R
                    dc.b $af // /
                    dc.b $d3 // S
                    dc.b $be // >
                    dc.b $a0 // <blank>
                    dc.b $c3 // C
                    dc.b $cf // O
                    dc.b $ce // N
                    dc.b $d4 // T
                    dc.b $c9 // I
                    dc.b $ce // N
                    dc.b $d5 // U
                    dc.b $c5 // E
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $d4 // T
                    dc.b $c8 // H
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $c7 // G
                    dc.b $c1 // A
                    dc.b $cd // M
                    dc.b $c5 // E
                    dc.b $00 // EndOfText
                    
                    lda #LR_KeyNewNone              //
                    sta LR_KeyNew                   //
                     
.WaitUser           jsr ChkUserAction               //
                    bcc .WaitUser                   //
                    
                    ldx #LR_KeyNewNone              //
                    stx LR_KeyNew                   // discard key pressed
                    
.Chk_s              cmp #$0d                        // "s"
                    bne .Chk_d                      //
                    
                    jmp .SaveNew                    //
                    
.Chk_d              cmp #$12                        // "d"
                    beq .DeleteOld                  //
                    
                    cmp #$3f                        // <run/stop>
                    bne .BadKey                     //
                    
.Abort              jmp .RestoreLevel               // 
                    
.BadKey             jsr Beep                        // 
                    jmp .TitleLine                  // start over
                    
.DeleteOld          jsr LvlEdCurPosInit             // set cursor to top left screen pos
                    jsr TextOut                     // <deletes an entry>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $c4 // D
                    dc.b $c5 // E
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $d4 // T
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $ce // N
                    dc.b $a0 // <blank>
                    dc.b $c5 // E
                    dc.b $ce // N
                    dc.b $d4 // T
                    dc.b $d2 // R
                    dc.b $d9 // Y
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $8d // <newline>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $ce // N
                    dc.b $c1 // A
                    dc.b $cd // M
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $be // >
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $bc // <
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $8d // <newline>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $bc // <
                    dc.b $d2 // R
                    dc.b $af // /
                    dc.b $d3 // S
                    dc.b $be // >
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $d4 // T
                    dc.b $cf // O
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $c2 // B
                    dc.b $cf // O
                    dc.b $d2 // R
                    dc.b $d4 // T
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $00 // EndOfText
                    
.SetDelCursor       lda #LR_DelColName              //
                    sta LRZ_ScreenCol               // screen col ($00 - $1b)
                    dec LRZ_ScreenRow               // screen row ($00 - $0f)
                    
                    sec                             // clear buffer first
                    ldy #LR_SavListIdLen            //
.GetDelName         jsr InputControl                // get a name
                    bcs .GoTitleLine1               // <run/stop> abort
                    beq .GoTitleLine1               // no name
                    
.TryDelName         jsr DelSaveListLine             // 
                    bcs .SaveList                   // name line deleted - write list back
                    
                    jsr Beep                        // name not found
                    jsr Beep                        // 
.GoTitleLine1       jmp .TitleLine                  //
                    
.SaveList           lda #LR_DiskWrite               //
                    jsr ControlDiskOper             // ac: $01=load $02=store
                    
.ShowList           jmp SaveGame                    // redisplay list
                    
.SaveNew            jsr LvlEdCurPosInit             // set cursor to top left screen pos
                    jsr TextOut                     // <save game in progress>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $d3 // S
                    dc.b $c1 // A
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $a0 // <newline>
                    dc.b $c7 // G
                    dc.b $c1 // A
                    dc.b $cd // M
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $c9 // I
                    dc.b $ce // N
                    dc.b $a0 // <blank>
                    dc.b $d0 // P
                    dc.b $d2 // R
                    dc.b $cf // O
                    dc.b $c7 // G
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $d3 // S
                    dc.b $d3 // S
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $8d // <newline>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $ce // N
                    dc.b $c1 // A
                    dc.b $cd // M
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $be // >
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $bc // <
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $8d // <newline>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $bc // <
                    dc.b $d2 // R
                    dc.b $af // /
                    dc.b $d3 // S
                    dc.b $be // >
                    dc.b $a0 // <blank>
                    dc.b $d4 // T
                    dc.b $cf // O
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $c2 // B
                    dc.b $cf // O
                    dc.b $d2 // R
                    dc.b $d4 // T
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $00 // EndOfText
                    
.SetSavCursor       lda #LR_SavColName              //
                    sta LRZ_ScreenCol               // screen col ($00 - $1b)
                    dec LRZ_ScreenRow               // screen row ($00 - $0f)
                    
                    sec                             // clear buffer first
                    ldy #LR_SavListIdLen            //
.GetSavName         jsr InputControl                // get a name
                    bcs .GoTitleLine2               // <run/stop> abort
                    beq .GoTitleLine2               // empty name
                    
.TrySavName         jsr FindSameEntry               // carry_clear=name not in list  carry_set=name in list
                    bcs .FillEntry                  // name found in list - overwrite
                    
                    jsr FindFreeEntry               // carry_clear=list full  carry_set=free entry found  ac=position
                    bcs .FillEntry                  // found
                    
                    jsr Beep                        // save game list full
                    jsr Beep                        // 
.GoTitleLine2       jmp .TitleLine                  //
                    
.FillEntry          tay                             // 
                    ldx #$00                        //
.CpyName            lda CR_InputBuf,x               //
                    sta LR_SavList,y                //
                    iny                             //
                    inx                             //
                    cpx #$08                        //
                    bcc .CpyName                    //
                    
.ChkLevelRnd        lda LR_RNDMode                  // .hbu014.
                    bpl .CpyLevelGame               // .hbu014.
                    
.CpyLevelRnd        lda LR_RNDLevel                 // .hbu014.
                    jmp .SetLevel                   // .hbu014.
                    
.CpyLevelGame       lda LR_LevelNoGame              // 001-050
.SetLevel           sta LR_SavList,y                //
                    
.CpyLevelDisk       iny                             //
                    lda CR_SaveNoDisk               //
                    sta LR_SavList,y                //
                    
.CpyLives           iny                             //
                    lda LR_NumLives                 //
                    sta LR_SavList,y                //
                    
.CpyScore           iny                             //
                    lda LR_ScoreHi                  //
                    sta LR_SavList,y                //
                    iny                             //
                    lda LR_ScoreMidHi               //
                    sta LR_SavList,y                //
                    iny                             //
                    lda LR_ScoreMidLo               //
                    sta LR_SavList,y                //
                    iny                             //
                    lda LR_ScoreLo                  //
                    sta LR_SavList,y                //
.CpyRnd             iny                             // .hbu014.
                    lda LR_RNDMode                  // .hbu014.
                    sta LR_SavList,y                // .hbu014.
                    
.WriteSaveLst       lda #LR_DiskWrite               //
                    jsr ControlDiskOper             // ac: $01=load $02=store
                    
.SetRndLevel        inc LR_LevelNoDisk              // .hbu014. - 153 - random mode level block
                    
                    lda #>LR_RandomField            // .hbu014.
                    sta Mod_PutDiskByte             // .hbu014.
                    
.WriteRndLst        lda #LR_DiskWrite               // .hbu014.
                    jsr ControlDiskOper             // .hbu014. - ac: $01=load $02=store
                    
.ResListLevel       dec LR_LevelNoDisk              // .hbu014. - reset: 152 - save games block
                    
                    lda #>LR_SaveList               // .hbu014. - reset: save list pointer
                    sta Mod_PutDiskByte             // .hbu014.
                    
                    jsr ShowSaveList                //
                    
                    lda #$01                        // 
                    jsr WaitAWhile                  // 
                    
.RestoreLevel       lda CR_SaveNoDisk               // 
                    sta LR_LevelNoDisk              // restore disk level no 000-049
                    
SaveGameX           jmp ExitLodSavGame              // reset all
// ------------------------------------------------------------------------------------------------------------- //
LoadGame            subroutine
                    jsr ShowSaveList                // 
                    
.TitleLine          jsr LvlEdCurPosInit             // set cursor to top left screen pos
                    jsr TextOut                     // <load an play a game>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $cf // O
                    dc.b $c1 // A
                    dc.b $c4 // D
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $ce // N
                    dc.b $c4 // D
                    dc.b $a0 // <blank>
                    dc.b $d0 // P
                    dc.b $cc // L
                    dc.b $c1 // A
                    dc.b $d9 // Y
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $a0 // <blank>
                    dc.b $c7 // G
                    dc.b $c1 // A
                    dc.b $cd // M
                    dc.b $c5 // E
                    dc.b $8d // <newline>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $ce // N
                    dc.b $c1 // A
                    dc.b $cd // M
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $be // <
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $bc // >
                    dc.b $8d // <newline>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $bc // <
                    dc.b $d2 // R
                    dc.b $af // /
                    dc.b $d3 // S
                    dc.b $be // >
                    dc.b $a0 // <blank>
                    dc.b $d4 // T
                    dc.b $cf // O
                    dc.b $a0 // <blank>
                    dc.b $c1 // A
                    dc.b $c2 // B
                    dc.b $cf // O
                    dc.b $d2 // R
                    dc.b $d4 // T
                    dc.b $00 // <newline>
                    
                    dec LRZ_ScreenRow               // screen row ($00 - $0f)
                    lda #LR_LodColName              // 
                    sta LRZ_ScreenCol               // screen col ($00 - $1b)
                    
                    sec                             // clear buffer first
                    ldy #LR_SavListIdLen            //
                    jsr InputControl                //
                    bcs .RestoreLevel               // <run/stp> abort
                    beq .TitleLine                  // no name entered
                    
.TryLoad            jsr FindSameEntry               // carry_clear=name not in list  carry_set=name in list
                    bcs .SetEntry                   // name found in list
                    
                    jsr Beep                        // 
                    jsr Beep                        //
.GoLoadTitle        jmp .TitleLine                  // 
                    
.RestoreLevel       lda CR_SaveNoDisk               // 
                    sta LR_LevelNoDisk              // restore disk level no 000-149
.GoLoadExit         jmp LoadGameX                   //
                    
.SetEntry           clc                             // name length
                    adc #LR_SavListIdLen            // point behind entry name
                    
                    tay                             //
.GetLevel           lda LR_SavListLevelG - LR_SavListIdLen,y
                    sta LR_LevelNoGame              // 001-150
                    sta LR_RNDLevel                 // 001-150
                    
                    lda LR_SavListLevelD - LR_SavListIdLen,y
                    pha                             // save LR_SavListLevelD because of the later list write
                    
.GetLives           lda LR_SavListLives  - LR_SavListIdLen,y
                    sta LR_NumLives                 // 
                    
.DecLives           sec                             // discount a live whith any load
                    sbc #$01                        //
                    sta LR_SavListLives  - LR_SavListIdLen,y
                    
.GetScore           lda LR_SavListScHi   - LR_SavListIdLen,y
                    sta LR_ScoreHi                  // 
                    lda LR_SavListScMiHi - LR_SavListIdLen,y
                    sta LR_ScoreMidHi               // 
                    lda LR_SavListScMiLo - LR_SavListIdLen,y
                    sta LR_ScoreMidLo               // 
                    lda LR_SavListScLo   - LR_SavListIdLen,y
                    sta LR_ScoreLo                  // 
                    
.GetRnd             lda LR_SavListRnd    - LR_SavListIdLen,y
                    sta LR_RNDMode                  // random number mode
                    
.ChkLives           lda LR_NumLives                 // 
                    cmp #$01                        // last life
                    bne .ReinitGame                 // no - keep entry
                    
.WriteBack          jsr DelSaveListLine             // yes - delete entry from list
                    
.ReinitGame         lda #LR_DiskWrite               // save decremented life
                    jsr ControlDiskOper             // ac: $01=load $02=store
                    
.SetRndLevel        inc LR_LevelNoDisk              // .hbu014. - 153 - random mode level block
                    
                    lda #>LR_RandomField            // .hbu014.
                    sta Mod_GetDiskByte             // .hbu014.
                    
.ReadRndLst         lda #LR_DiskRead                // .hbu014. - read in random level list
                    jsr ControlDiskOper             // .hbu014. - ac: $01=load $02=store
                    
.ResListLevel       dec LR_LevelNoDisk              // .hbu014. - reset: 152 - save games block
                    
                    lda #>LR_SaveList               // .hbu014. - reset: save list pointer
                    sta Mod_GetDiskByte             // .hbu014.
                    
                    jsr ClearHiresDispH             // ClearDisplay20
                    jsr ClearHiresPrep              // ClearDisplay40
                    
                    pla                             // restore LR_SavListLevelD
                    sta LR_LevelNoDisk              // 000-149
                    
                    tay                             // .hbu014.
                    lda LR_RNDMode                  // .hbu014.
                    cmp #LR_RNDModeOn               // .hbu014.
                    bne .ForceReload                // .hbu014.
                    
                    iny                             // .hbu014.
                    sty LR_LevelNoGame              // .hbu014. - 001-150
                    
.ForceReload        ldy #$ff
                    sty LR_LvlReload                // <> LR_LevelNoDisk - force level reload from disk
                    
                    iny                             // $00
                    sty LR_CntSpeedLaps             //
                    sty LR_EnmyBirthCol             // reset birth col pointer
                    
                    tya                             // $00
                    jsr Score2BaseLine              // ac=0 yr=0 - output but no score to add
                    jsr Lives2BaseLine              //
                    jsr Level2BaseLine              //
                    jsr MelodyInit                  // InitVictoryTune
                    
                    lda #LR_CheatedNo               //
                    sta LR_Cheated                  // reset a possible cheat flag to reallow game saves
                    
LoadGameX           jmp ExitLodSavGame              //
// ------------------------------------------------------------------------------------------------------------- //
ShowSaveList        subroutine
                    lda #>LR_ScrnHiReDisp           // 
                    sta LRZ_GfxScreenOut            // control gfx screen output - display=$20(00) hidden=$40(00)
                    
                    jsr CheckSaveList               // check "HBU" id - clear data otherwise
                    jsr ClearHiresDispH             // clear all but the base line
                    
                    lda #HR_YellowCyan              //
                    tax                             //
                    ldy #WHITE                      //
                    jsr ColorLevelFix               //
                    
                    lda #$00                        //
                    sta LRZ_ScreenCol               // screen col ($00 - $1b)
                    lda #$04                        //
                    sta LRZ_ScreenRow               // screen row ($00 - $0f)
                    jsr TextOut                     // <name level men scores>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $ce // N
                    dc.b $c1 // A
                    dc.b $cd // M
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $cc // L
                    dc.b $a0 // <blank>
                    dc.b $cd // M
                    dc.b $c5 // E
                    dc.b $ce // N
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $d3 // S
                    dc.b $c3 // C
                    dc.b $cf // O
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $d3 // S
                    dc.b $8d // <newline>
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $a0 // <blank>
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $a0 // <blank>
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $ad // -
                    dc.b $8d // <newline>
                    dc.b $00 // EndOfText
                    
                    ldy #$00                        //
                    sty $1c                         // ptr save game data
                    
.SaveNameOutI       lda #LR_SavListIdLen            //
                    sta $1d                         // name length
                    
.SaveNameOut        ldy $1c                         // ptr save game data
                    lda LR_SavList,y                //
                    jsr ControlOutput               //
                    
                    inc $1c                         // ptr save game data
                    dec $1d                         // name length
                    bne .SaveNameOut                //
                    
.PosLevel           inc LRZ_ScreenCol               // screen col ($00 - $1b)
                    inc LRZ_ScreenCol               // screen col ($00 - $1b)
                    inc LRZ_ScreenCol               // screen col ($00 - $1b)
                    ldy $1c                         // get ptr save game data
                    inc $1c                         // set ptr save game data
                    inc $1c                         // 
                    
.GetLevel           lda LR_SavList,y                //
                    cmp #$a0                        // <blank>
                    bne .OutLevel                   //
                    
                    jmp .SetNextEntry               // leave out entries with a blank name
                    
.OutLevel           jsr SplitHexOut                 //
                    
.PosMen             inc LRZ_ScreenCol               // screen col ($00 - $1b)
                    inc LRZ_ScreenCol               // screen col ($00 - $1b)
                    ldy $1c                         // get ptr save game data
                    inc $1c                         // set ptr save game data
                    
.GetMen             lda LR_SavList,y                //
.OutMen             jsr SplitHexOut                 //
                    
.PosScore           inc LRZ_ScreenCol               // screen col ($00 - $1b)
                    ldy $1c                         // get ptr save game data
                    inc $1c                         // set ptr save game data
                    
.GetScore           lda LR_SavList,y                //
                    jsr SplitDecOut                 //
                    
                    ldy $1c                         // get ptr save game data
                    inc $1c                         // set ptr save game data
                    lda LR_SavList,y                //
                    jsr SplitDecOut                 //
                    
                    ldy $1c                         // get ptr save game data
                    inc $1c                         // set ptr save game data
                    lda LR_SavList,y                //
                    jsr SplitDecOut                 //
                    
                    ldy $1c                         // get ptr save game data
                    inc $1c                         // set ptr save game data
                    lda LR_SavList,y                //
                    jsr SplitDecOut                 //
                    
                    ldy $1c                         // .hbu014. - get ptr save game data
.ChkLevelRnd        lda LR_SavList,y                // .hbu014.
                    cmp #LR_RNDModeOn               // .hbu014.
                    bne .SetNewRow                  // .hbu014.
                    
.MarkLevelRnd       lda #LR_SavColRnd
                    sta LRZ_ScreenCol
                    lda #$be                        // .hbu014. - ">"
                    jsr ControlOutput               // .hbu014.
                    
.SetNewRow          lda #$8d                        // <newline>
                    jsr ControlOutput               //
                    
.SetNextEntry       lda $1c                         // get ptr save game data
                    and #$f0                        //
                    clc                             //
                    adc #$10                        //
                    sta $1c                         // set ptr save game data to next entry
                    
.ChkMax             cmp #LR_SavListMaxLen           // maxiumum reached - $09*10
                    beq ShowSaveListX               //
                    
.GoNextRow          jmp .SaveNameOutI               //
                    
ShowSaveListX       rts                             //
// ------------------------------------------------------------------------------------------------------------- //
CheckSaveList       subroutine
                    lda LR_SavListId1               //
                    cmp #$c8                        // "H"
                    bne ClrSaveList                 // wrong id - clear and write back
                    
                    lda LR_SavListId2               //
                    cmp #$c2                        // "B"
                    bne ClrSaveList                 // wrong id - clear and write back
                    
                    lda LR_SavListId3               //
                    cmp #$d5                        // "U"
                    bne ClrSaveList                 // wrong id - clear and write back
                    
CheckSaveListX      rts                             // good list
// ------------------------------------------------------------------------------------------------------------- //
ClrSaveList         subroutine
                    ldx #$00                        // <blank> - wrong id - clear and write back
                    lda #$a0                        //
.ClrListData        sta LR_SavList,x                //
                    inx                             //
                    bne .ClrListData                //
                    
.SetID              lda #$c8                        // "H"
                    sta LR_SavListId1                //
                    lda #$c2                        // "B"
                    sta LR_SavListId2               //
                    lda #$d5                        // "U"
                    sta LR_SavListId3               //
                    
.ClrLevelWrite      lda #LR_DiskWrite               //
                    jsr ControlDiskOper             // ac: $01=load $02=store
                    
ClrSaveListX        rts                             //
// ------------------------------------------------------------------------------------------------------------- //
DelSaveListLine     subroutine
                    jsr FindSameEntry               // carry_clear=name not in list  carry_set=name in list
                    bcc DelSaveListLineX            // entry not found
                    
                    tay                             // name position
.MoveUp             lda LR_SavList + LR_SavListRowLen,y
                    sta LR_SavList,y                // overwrite entry found - move the whole list ome pos up = delete
                    iny                             //
                    cpy #LR_SavListMaxLen           //
                    bcc .MoveUp                     //
                    
                    sec                             // entry found and overwritten
DelSaveListLineX    rts                             //
// ------------------------------------------------------------------------------------------------------------- //
FindSameEntry       subroutine
                    ldy #$00                        // carry_clear=name not in list  carry_set=name in list ac=position
.ChkEntryI          ldx #$00                        //
.ChkEntry           lda LR_SavList,y                //
                    cmp CR_InputBuf,x               //
                    bne .Differs                    //
                    
                    iny                             //
                    inx                             //
                    cpx #LR_SavListIdLen            //
                    bne .ChkEntry                   //
                    
.Same               tya                             // save name already existing
                    and #$f0                        //
                    sec                             // save name found and can be replaced
                    rts                             //
                    
.Differs            tya                             // actual save name differs from entered name so check next entry
                    and #$f0                        //
                    clc                             //
                    adc #LR_SavListRowLen           //
                    
                    tay                             //
                    cmp #LR_SavListMaxLen           //
.ChkNext            bne .ChkEntryI                  //
                    
                    clc                             // list full - no empty entry and no same save name found
FindSameEntryX      rts                             //
// ------------------------------------------------------------------------------------------------------------- //
FindFreeEntry       subroutine
                    ldy #$00                        // carry_clear=list full  carry_set=free entry found  ac=position
.ChkEntryI          ldx #LR_SavListIdLen            // 
                    lda #$a0                        // <blank>
.ChkEntry           cmp LR_SavList,y                //
                    bne .SetNextEntry               //
                    
                    iny                             //
                    dex                             //
                    bne .ChkEntry                   //
                    
.FreeEntry          tya                             //
                    and #$f0                        //
                    sec                             //
                    rts                             //
                    
.SetNextEntry       tya                             //
                    and #$f0                        //
                    clc                             //
                    adc #LR_SavListRowLen           //
                    tay                             //
                    cmp #LR_SavListMaxLen           // 
                    bne .ChkEntryI                  //
                    
.ListFull           clc                             //
FindFreeEntryX      rts                             //
// ------------------------------------------------------------------------------------------------------------- //
SplitDecOut         subroutine
                    jsr SplitScoreDigit             // 1308=10 1309=1
                    jmp Out_10                      //
                    
SplitHexOut         jsr ConvertHex2Dec              // 1307=100 1308=10 1309=1
                    
Out_100             lda LR_Digit100                 // 
                    jsr PrepareDigitOut
                    
Out_10              lda LR_Digit10                  // 
                    jsr PrepareDigitOut             // 
                    
Out_1               lda LR_Digit1                   // 
SplitHexOutX        jmp PrepareDigitOut             // 
// ------------------------------------------------------------------------------------------------------------- //
LoadScoreBlock      subroutine
                    lda #LR_GameGame                //
                    sta LR_GameCtrl                 // $00=start $01=demo $02=game $03=play_level $05=edit
                    
                    lda #LR_DiskRead                //
                    jsr GetPutHiScores              // ($1100-$11ff) ac: $01=load $02=store 81= 82=
                    
                    cmp #$00                        //
                    bne .LoadScoreBad               //
                    
.LoadScoreGood      sec                             //
                    rts                             //
                    
.LoadScoreBad       clc                             // 
LoadScoreBlockX     rts                             //
// ------------------------------------------------------------------------------------------------------------- //
// SetRebirthColor   Function: Set screen background color to enemy color on rebirth position (for a 2*2 grid)
//                   Parms   : ($LRZ_ScreenCol/LRZ_ScreenRow) point to enemy col/row
//                   Returns : ($42/$43) point to multi color screen output address
//                   ID      : .hbu006.
// ------------------------------------------------------------------------------------------------------------- //
SetRebirthColor     subroutine
                    txa                             // 
                    pha                             // 
                    
.GetRebirthRow      ldy LRZ_ScreenRow               // set color pointer - enemy row
                    lda TabColorScrRowAm,y          // get amount of rows to be colored
                    sta $46                         // 
.GetRebirthNo       lda TabColorScrRowNo,y          // get color row number for actual row
                    sta LR_ColorScrRowNo            // 
                    tay                             // 
.SetRebirthPtr      lda TabColorScrRowLo,y          // 
                    sta $42                         // 
                    lda TabColorScrRowHi,y          // 
                    sta $43                         // 
                    
.SetRebirthCol      ldy LRZ_ScreenCol               // get color offset for actual column
                    lda TabColorScrCol,y            // 
                    clc                             // 
                    adc $42                         // 
                    sta $42                         // 
                    bcc .SetBirthColorI             // 
                    inc $43                         // ($42/$43) point to multi color screen output address
                    
.SetBirthColorI     ldy #$01                        // color 2 columns
.SetBirthColor      lda ($42),y                     // get  old color byte
                    and #$0f                        // kill old color background
                    sta ($42),y                     // put  new color byte
                    
                    lda LR_NoEnemy2Move             // actual enemy number
                    tax                             // 
                    lda TabSpriteNum,x              // get enemy color position 
                    clc                             // 
                    adc LR_ColorSetEnemy            // actual color table row address from ColorSprites
                    tax                             // 
                    lda TabSpColorSets,x            // get this enemies color
                    asl a                           // shift to left nybble
                    asl a                           // 
                    asl a                           // 
                    asl a                           // 
                    ora ($42),y                     // set old  color background to enemy color
                    sta ($42),y                     // put  new color byte
                    
                    dey                             // 
                    bpl .SetBirthColor              // treat second position
                    
                    dec LR_ColorScrRowNo            // color next row above
                    ldy LR_ColorScrRowNo            // 
                    
.SetPrevRow         dec $46                         // 
                    bpl .SetRebirthPtr              // 
                    
                    pla                             // 
                    tax                             // 
                    
SetRebirthColorX    rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
TabColorScrCol      dc.b $02                        // .hbu006. 00 - multi color screen col offsets
                    dc.b $03                        // .hbu006. 01 
                    dc.b $05                        // .hbu006. 02 
                    dc.b $06                        // .hbu006. 03 
                    dc.b $07                        // .hbu006. 04 
                    dc.b $08                        // .hbu006. 05 
                    dc.b $0a                        // .hbu006. 06 
                    dc.b $0b                        // .hbu006. 07 
                    dc.b $0c                        // .hbu006. 08 
                    dc.b $0d                        // .hbu006. 09 
                    dc.b $0f                        // .hbu006. 0a 
                    dc.b $10                        // .hbu006. 0b 
                    dc.b $11                        // .hbu006. 0c 
                    dc.b $12                        // .hbu006. 0d 
                    dc.b $14                        // .hbu006. 0e 
                    dc.b $15                        // .hbu006. 0f 
                    dc.b $16                        // .hbu006. 10 
                    dc.b $17                        // .hbu006. 11 
                    dc.b $19                        // .hbu006. 12 
                    dc.b $1a                        // .hbu006. 13 
                    dc.b $1b                        // .hbu006. 14 
                    dc.b $1c                        // .hbu006. 15 
                    dc.b $1e                        // .hbu006. 16 
                    dc.b $1f                        // .hbu006. 17 
                    dc.b $20                        // .hbu006. 18 
                    dc.b $21                        // .hbu006. 19 
                    dc.b $23                        // .hbu006. 1a 
                    dc.b $24                        // .hbu006. 1b 
                    
TabColorScrRowNo    dc.b $01                        // .hbu006. 00 028 2 - never because scan starts with row $01
                    dc.b $02                        // .hbu006. 01 050 2
                    dc.b $04                        // .hbu006. 02 0a0 3
                    dc.b $05                        // .hbu006. 03 0c8 2
                    dc.b $06                        // .hbu006. 04 0f0 2
                    dc.b $08                        // .hbu006. 05 140 3
                    dc.b $09                        // .hbu006. 06 168 2
                    dc.b $0a                        // .hbu006. 07 190 2
                    dc.b $0c                        // .hbu006. 08 1e0 3
                    dc.b $0d                        // .hbu006. 09 208 2
                    dc.b $0f                        // .hbu006. 0a 258 3
                    dc.b $10                        // .hbu006. 0b 280 2
                    dc.b $11                        // .hbu006. 0c 2a8 2
                    dc.b $13                        // .hbu006. 0d 2f8 3
                    dc.b $14                        // .hbu006. 0e 320 2
                    dc.b $15                        // .hbu006. 0f 348 2 - never because at least one free place in row $14
                    
TabColorScrRowLo    dc.b $00                        // .hbu006. 00
                    dc.b $28                        // .hbu006. 01
                    dc.b $50                        // .hbu006. 02
                    dc.b $78                        // .hbu006. 03
                    dc.b $a0                        // .hbu006. 04
                    dc.b $c8                        // .hbu006. 05
                    dc.b $f0                        // .hbu006. 06
                    
                    dc.b $18                        // .hbu006. 07
                    dc.b $40                        // .hbu006. 08
                    dc.b $68                        // .hbu006. 09
                    dc.b $90                        // .hbu006. 0a
                    dc.b $b8                        // .hbu006. 0b
                    dc.b $e0                        // .hbu006. 0c
                    
                    dc.b $08                        // .hbu006. 0d
                    dc.b $30                        // .hbu006. 0e
                    dc.b $58                        // .hbu006. 0f
                    dc.b $80                        // .hbu006. 10
                    dc.b $a8                        // .hbu006. 11
                    dc.b $d0                        // .hbu006. 12
                    dc.b $f8                        // .hbu006. 13
                    
                    dc.b $20                        // .hbu006. 14
                    dc.b $48                        // .hbu006. 15
                    
TabColorScrRowHi    dc.b >LR_ScrnMultColor + $00    // .hbu006. - multi color screen row offsets high
                    dc.b >LR_ScrnMultColor + $00    // .hbu006.
                    dc.b >LR_ScrnMultColor + $00    // .hbu006.
                    dc.b >LR_ScrnMultColor + $00    // .hbu006.
                    dc.b >LR_ScrnMultColor + $00    // .hbu006.
                    dc.b >LR_ScrnMultColor + $00    // .hbu006.
                    dc.b >LR_ScrnMultColor + $00    // .hbu006.
                    
                    dc.b >LR_ScrnMultColor + $01    // .hbu006.
                    dc.b >LR_ScrnMultColor + $01    // .hbu006.
                    dc.b >LR_ScrnMultColor + $01    // .hbu006.
                    dc.b >LR_ScrnMultColor + $01    // .hbu006.
                    dc.b >LR_ScrnMultColor + $01    // .hbu006.
                    dc.b >LR_ScrnMultColor + $01    // .hbu006.
                    
                    dc.b >LR_ScrnMultColor + $02    // .hbu006.
                    dc.b >LR_ScrnMultColor + $02    // .hbu006.
                    dc.b >LR_ScrnMultColor + $02    // .hbu006.
                    dc.b >LR_ScrnMultColor + $02    // .hbu006.
                    dc.b >LR_ScrnMultColor + $02    // .hbu006.
                    dc.b >LR_ScrnMultColor + $02    // .hbu006.
                    dc.b >LR_ScrnMultColor + $02    // .hbu006.
                    
                    dc.b >LR_ScrnMultColor + $03    // .hbu006.
                    dc.b >LR_ScrnMultColor + $03    // .hbu006.

TabColorScrRowAm    dc.b $02                        // .hbu006. 00 amount of rows to be colored
                    dc.b $02                        // .hbu006. 01 
                    dc.b $03                        // .hbu006. 02 
                    dc.b $02                        // .hbu006. 03 
                    dc.b $02                        // .hbu006. 04 
                    dc.b $03                        // .hbu006. 05 
                    dc.b $02                        // .hbu006. 06 
                    dc.b $02                        // .hbu006. 07 
                    dc.b $03                        // .hbu006. 08 
                    dc.b $02                        // .hbu006. 09 
                    dc.b $03                        // .hbu006. 0a 
                    dc.b $02                        // .hbu006. 0b 
                    dc.b $02                        // .hbu006. 0c 
                    dc.b $03                        // .hbu006. 0d 
                    dc.b $02                        // .hbu006. 0e 
                    dc.b $02                        // .hbu006. 0f 
// ------------------------------------------------------------------------------------------------------------- //
// BaseLines         Function: Output a separation and a status line
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
BaseLinesColor      subroutine
                    jsr ColorLevelDyn               // .hbu001.
                    jsr ColorStatus                 // .hbu001.
                    
BaseLines           ldx #$22                        // length of separator line
                    
.SeparatorLine      lda LRZ_GfxScreenOut            // target output  $20=$2000 $40=$4000
                    cmp #$40                        // hires preparation screen
                    beq .HiResPrepare               // preparation screen
                    
.HiResDisplay       lda #$0a                        // grafic byte for
.HiResDispLeX       sta LR_StatsLinLeD01            // left end 0
                    sta LR_StatsLinLeD02            // left end 1
                    sta LR_StatsLinLeD03            // left end 2
                    sta LR_StatsLinLeD04            // left end 3
                    lda #$a0                        // grafic byte for
.HiResDispReX       sta LR_StatsLinRiD01            // right end 0
                    sta LR_StatsLinRiD02            // right end 1
                    sta LR_StatsLinRiD03            // right end 2
                    sta LR_StatsLinRiD04            // right end 3
.HiResDispMid       ldy #$03
                    lda #$aa                        // grafic byte for
.HiResDispMidPut    sta LR_StatsLinMiD,y            // middle part 0-3
..ModDispMidLo      equ *-2
..ModDispMidHi      equ *-1
                    dey
                    bpl .HiResDispMidPut            // store next middle part 0-3
                    
.HiResDispNext      lda ..ModDispMidLo
                    clc
                    adc #$08
                    sta ..ModDispMidLo
                    bcc .HiResDispDec
                    inc ..ModDispMidHi
                    
.HiResDispDec       dex
                    bne .HiResDispMid               // dec linie counter
                    
                    lda #>LR_StatsLinMiD            // restore old values
                    sta ..ModDispMidHi
                    lda #<LR_StatsLinMiD
                    sta ..ModDispMidLo
                    bne .InfoLine                   // always
                    
.HiResPrepare       lda #$0a                        // grafic byte for
.HiResPrepLeX       sta LR_StatsLinLeP01            // left end 0
                    sta LR_StatsLinLeP02            // left end 1
                    sta LR_StatsLinLeP03            // left end 2
                    sta LR_StatsLinLeP04            // left end 3
                    lda #$a0                        // grafic byte for
.HiResPrepRiX       sta LR_StatsLinRiP01            // right end 0
                    sta LR_StatsLinRiP02            // right end 1
                    sta LR_StatsLinRiP03            // right end 2
                    sta LR_StatsLinRiP04            // right end 3
.HiResPrepMid       ldy #$03
                    lda #$aa                        // grafic byte for middle part 0-3
.HiResPrepMidPut    sta LR_StatsLinMiP,y
..ModPrepMidLo      equ *-2
..ModPrepMidHi      equ *-1
                    dey
                    bpl .HiResPrepMidPut
                    
                    lda ..ModPrepMidLo
                    clc
                    adc #$08                        // next position
                    sta ..ModPrepMidLo
                    bcc .HiResPrepDec
                    inc ..ModPrepMidHi
                    
.HiResPrepDec       dex
                    bne .HiResPrepMid
                    
                    lda #>LR_StatsLinMiP            // restore old values
                    sta ..ModPrepMidHi
                    lda #<LR_StatsLinMiP
                    sta ..ModPrepMidLo
                    
.InfoLine           jsr LvlEdCurSetHero
                    
.ChkTestMode        lda LR_TestLevel                // .hbu023.
                    bmi .BaseLineEdit               // .hbu023.
                    
.ChkEditMode        lda LR_GameCtrl
                    cmp #LR_GameEdit
                    bne .BaseLineGame
                    
.BaseLineEdit       jsr TextOut                     // .hbu009. - <level msg>
.StatusEdit         dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $cc // L
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $cd // M
                    dc.b $d3 // S
                    dc.b $c7 // G
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $00 // EndOfText
                    
                    lda LR_LevelNoGame                // level number
                    ldx #LR_BasLinColScr              // now at score position in base row
.BaseLineEditX      jmp Value2BaseLine
                    
.BaseLineGame       jsr TextOut                     // <score>
                    dc.b $d3 // S
                    dc.b $c3 // C
                    dc.b $cf // O
                    dc.b $d2 // R
                    dc.b $c5 // E
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $00 // EndOfText
                    
BaseLineMenLvl      jsr TextOut                     // .hbu007. - <men level>
.MsgText            dc.b $cd // M
                    dc.b $c5 // E
                    dc.b $ce // N
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $cc // L
                    dc.b $c5 // E
                    dc.b $d6 // V
                    dc.b $c5 // E
                    dc.b $cc // L
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $a0 // <blank>
                    dc.b $00 // EndOfText
                    
.ChkClear           lda #HR_BlackBlack              // .hbu007. - clear color
                    cmp LR_ScrnMCMsg                // .hbu007. - status line msg part colour
                    bne .FillBaseLine               // .hbu007.
                    
.Recolor            jsr ColorMsg                    // .hbu007. - recolor after ClearMsg
                    
.FillBaseLine       jsr Lives2BaseLine              // .hbu007.
                    jsr Level2BaseLine              // .hbu007.
                    
                    lda #$00                        // no score to add
                    tay                             // 
BaseLinesX          jmp Score2BaseLine              // display score and return
// ------------------------------------------------------------------------------------------------------------- //
//                   Function: Reset victory message on death / lives update
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
RestoreFromMsg      subroutine
                    lda LR_ScrnMCMsg - 1            // .hbu007. - status line fix part colour
                    cmp LR_ScrnMCMsg                // .hbu007. - status line msg part colour
                    bne .ClearBaseMsgI              // .hbu007. - a message still displayed
                    
.Exit               jmp Lives2BaseLine              // .hbu007. - simply update no of lives
                    
.ClearBaseMsgI      sta Mod_ColorMsg                // .hbu007. - store fix base line color
.ClearBaseMsg       jsr ClearMsg                    // .hbu007.
                    
.InfoLine           jsr LvlEdCurSetMsg              // .hbu007. - $0f - max 15 rows -> info seperator is 16
                    
RestoreFromMsgX     jmp BaseLineMenLvl              // .hbu007.
// ------------------------------------------------------------------------------------------------------------- //
// Lives2BaseLine    Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
Lives2BaseLine      subroutine
                    ldx LR_TestLevel                // .hbu023.
                    bpl .ShowLives                  // .hbu023.
                    
.Exit               rts                             // .hbu023. - no lives in level test mode
                    
.ShowLives          lda LR_NumLives
                    ldx #LR_BasLinColLve            // output column
                    
Value2BaseLine      stx LRZ_ScreenCol               // screen col  (00-1b)
                    
                    ldx #LR_BasLinRowStat           // row 16
                    stx LRZ_ScreenRow               // screen row  (00-0f)
                    
Value2BaseLineX     jmp SplitHexOut
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
Level2BaseLine      subroutine
                    lda LR_RNDMode                  // .hbu014.
                    bpl .GetNormal                  // .hbu014.
                    
.GetRandom          lda LR_RNDLevel                 // .hbu014.
                    jmp .GetColLevel                // .hbu014.
                    
.GetNormal          lda LR_LevelNoGame              // 001-150
.GetColLevel        ldx #LR_BasLinColLvl            // output column
                    bne Value2BaseLine              // always
// ------------------------------------------------------------------------------------------------------------- //
// Score2BaseLine    Function: Add valuse in ac/yr to score and displays the result in the base info line
//                   Parms   : ac=10s yr=100s
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
Score2BaseLine      subroutine
                    ldx LR_TestLevel                // .hbu023.
                    bpl .ShowScores                 // .hbu023.
                    
.Exit               rts                             // .hbu023. - no scores in level test mode
                    
.ShowScores         clc
                    sed
                    adc LR_ScoreLo                  // .hbu000. - ac has 10th
                    sta LR_ScoreLo                  // .hbu000.
                    tya                             // yr has 100th
                    adc LR_ScoreMidLo
                    sta LR_ScoreMidLo
                    lda #$00                        // add carry
                    adc LR_ScoreMidHi
                    sta LR_ScoreMidHi
                    lda #$00                        // add carry
                    adc LR_ScoreHi                  // .hbu000.
                    sta LR_ScoreHi                  // .hbu000.
                    
                    cld
                    lda #LR_BasLinColScr            // output column
                    sta LRZ_ScreenCol               // screen col  (00-1b)
                    lda #LR_BasLinRowStat           // row 16
                    sta LRZ_ScreenRow               // screen row  (00-0f)
                    
                    lda LR_ScoreHi
                    jsr SplitScoreDigit
                    
                    lda LR_Digit1                   // use only right nybble discard left nybble
                    jsr PrepareDigitOut
                    
                    lda LR_ScoreMidHi
                    jsr SplitDecOut
                    
                    lda LR_ScoreMidLo
                    jsr SplitDecOut
                    
                    lda LR_ScoreLo
Score2BaseLineX     jmp SplitDecOut
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
SplitScoreDigit     subroutine
                    sta LR_Digit10                  // store score byte
                    and #$0f
                    sta LR_Digit1                   // isolate right nybble
                    
                    lda LR_Digit10                  // store   right nybble
                    lsr a                           // isolate left  nybble
                    lsr a
                    lsr a
                    lsr a
                    sta LR_Digit10                  // store   left  nybble
                    
SplitScoreDigitX    rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ConvertHex2Dec      subroutine
                    ldx #$00
                    stx LR_Digit10                  // digit 10 part
                    stx LR_Digit100                 // digit 100 part
                    
.Chk100             cmp #$64                        // 100
                    bcc .Chk10                      // lower
                    inc LR_Digit100                 // digit 100 part
                    sbc #$64                        // 100
                    bne .Chk100
                    
.Chk10              cmp #$0a                        // 10
                    bcc .Chk1                       // lower
                    inc LR_Digit10                  // digit 10 part
                    sbc #$0a                        // 10
                    bne .Chk10
                    
.Chk1               sta LR_Digit1                   // digit 1 part
                    
ConvertHex2DecX     rts
// ------------------------------------------------------------------------------------------------------------- //
// Dec2Hex           Function:
//                   Parms   :
//                   Returns : 
// ------------------------------------------------------------------------------------------------------------- //
Dec2Hex             subroutine
                    lda #$00                        // init result
                    ldx LR_Digit100                 // digit 100 part
                    beq .Chk10
                    
                    clc
.Add100             adc #$64                        // 100
                    bcs Dec2HexX
                    dex
                    bne .Add100
                    
.Chk10              ldx LR_Digit10                  // digit 10 part
                    beq .Add1
                    
                    clc
.Add10              adc #$0a                        // 10
                    bcs Dec2HexX
                    dex
                    bne .Add10
                    
.Add1               clc
                    adc LR_Digit1                   // digit 1 part
                    
Dec2HexX            rts
// ------------------------------------------------------------------------------------------------------------- //
// GetChrSubst       Function: Get chacacter image number
//                   Parms   :
//                   Returns : 
// ------------------------------------------------------------------------------------------------------------- //
GetChrSubst         subroutine
                    cmp #$c1                        // "A"
                    bcc .ChkSpecial                 // lower
                    
                    cmp #$db                        // "Z" + 1
                    bcc .SubstChr                   // lower
                    
.ChkSpecial         ldx #$7b // $e3 - NoImages       // .hbu008. - $7b - substitution - $00
                    cmp #$a0                        // SHIFT BLANK
                    beq .SetSpecial
                    
                    ldx #$db                        // $db - substitution - $61
                    cmp #$be                        // ">"
                    beq .SetSpecial
                    
                    inx                             // $dc - substitution - $62
                    cmp #$ae                        // "."
                    beq .SetSpecial
                    
                    inx                             // $dd - substitution - $63
                    cmp #$a8                        // "("
                    beq .SetSpecial
                    
                    inx                             // $de - substitution - $64
                    cmp #$a9                        // ")"
                    beq .SetSpecial
                    
                    inx                             // $df - substitution - $65
                    cmp #$af                        // "/"
                    beq .SetSpecial
                    
                    inx                             // $e0 - substitution - $66
                    cmp #$ad                        // "-"
                    beq .SetSpecial
                    
                    inx                             // $e1 - substitution - $67
                    cmp #$bc                        // "<"
                    beq .SetSpecial
                    
                    inx                             // .hbu013. - $e1 - substitution - $67
                    cmp #$ba                        // ":"
                    beq .SetSpecial
                    
.ChkChrNumbers      cmp #NoChrDigitsMin             // .hbu015. - character "0"
                    bcc .GetDefault                 // .hbu015. - lower
                    
                    cmp #NoChrDigitsMax+1           // .hbu015. - character "9" + 1
                    bcc GetChrSubstX                // .hbu015. - lower - avoid correction
                    
.GetDefault         lda #$10                        // all others
                    rts
                    
.SetSpecial         txa
.SubstChr           sec
                    sbc #$7b // $e3 - NoImages       // .hbu008 - map to chr image data numbers
                    
GetChrSubstX        rts
// ------------------------------------------------------------------------------------------------------------- //
// PrepareChrOut     Function: Get character image number and output to selected hires screen
//                   Parms   : LRZ_GfxScreenOut points to the target hires screen
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
PrepareChrOut       subroutine
                    cmp #$8d                        // <newline>
                    bne .ChrPrepare                 // .hbu000.
                    
.ChrNewLine         inc LRZ_ScreenRow               // .hbu000. - screen row  (00-0f)
                    lda #$00                        // .hbu000.
                    sta LRZ_ScreenCol               // .hbu000. - screen col  (00-1b)
                    rts                             // .hbu000.
                                      
.ChrPrepare         jsr GetChrSubst                 // image table substitution
                    
ChrOut2Screen       ldx LRZ_GfxScreenOut            // target output  $20=$2000 $40=$4000
                    cpx #>LR_ScrnHiRePrep           // $40
                    beq .OutToPrepare
                    
.OutToDisplay       jsr ImageOut2Disp               // direct output to display screen
                    inc LRZ_ScreenCol               // screen col  (00-1b)
                    rts
                    
.OutToPrepare       jsr ImageOut2Prep               // direct output to preparation screen
                    inc LRZ_ScreenCol               // screen col  (00-1b)
                    
PrepareChrOutX      rts
// ------------------------------------------------------------------------------------------------------------- //
// PrepareDigitOut   Function: 
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
PrepareDigitOut     subroutine
                    clc
                    adc #NoDigitsMin                // .hbu008.  map to digit image data numbers
                    
DigitOut2Screen     ldx LRZ_GfxScreenOut            // target output  $20=$2000 $40=$4000
                    cpx #>LR_ScrnHiRePrep           // $40
                    beq .Out2Prepare
                    
.Out2Display        jsr ImageOut2Disp               // direct output to display screen
                    inc LRZ_ScreenCol               // screen col  (00-1b)
                    rts
                    
.Out2Prepare        jsr ImageOut2Prep               // direct output to preparation screen
                    inc LRZ_ScreenCol               // screen col  (00-1b)
PrepareDigitOutX    rts
// ------------------------------------------------------------------------------------------------------------- //
// TextOut           Function: Output of Text Rows
//                             $00 terminated text must follow directly the call
//                             $00 terminator must be followed directly by a valid opcode
//                   Parms   :
//                   Returns : 
// ------------------------------------------------------------------------------------------------------------- //
TextOut             subroutine
                    pla                             // pull the text start address from the stack
                    sta $13
                    pla
                    sta $14
                    bne .SetNext                    // always
                    
.GetNext            ldy #$00
                    lda ($13),y                     // get text byte
                    beq .PrepXit                    // zero as text end
                    
.ImageOut           jsr ControlOutput               // .hbu010.
                    
.SetNext            inc $13
                    bne .GetNext
                    
                    inc $14
                    bne .GetNext
                    
.PrepXit            lda $14                         // push the text end address to the stack
                    pha
                    lda $13
                    pha
                    
TextOutX            rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
Beep                subroutine
                    jsr SetTune                     // data must follow directly
                    dc.b $03                        // tune time
                    dc.b $24                        // tune data pointer voice 2
                    dc.b $00                        // tune data pointer voice 3
                    dc.b $00                        // tune s/r/volume  (not used)
                    
                    dc.b $00                        // <EndOfTuneData>
                    
BeepX               rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
WaitKeyBlink        subroutine
                    sta LR_DisplayChr               // save byte under cursor
                    
.WaitBlank          lda #$00                        // init wait for action timer
                    sta LR_WaitTimeLo
                    lda #$0a
                    sta LR_WaitTimeHi
                    
                    lda #$00
                    ldx LR_DisplayChr               // saved byte under cursor
                    bne .Out
                    
.GetBlankImg        lda #NoCursorBlank              // image big reverse cursor
.Out                jsr ImageOut2Disp               // direct output to display screen
                    
.WaitUser1          jsr ChkUserAction
                    bcs .GotUserKey
                    
                    dec LR_WaitTimeLo
                    bne .WaitUser1
                    
                    dec LR_WaitTimeHi
                    bne .WaitUser1
                    
.GetSaveImg         lda LR_DisplayChr               // get byte under cursor
                    jsr ImageOut2Disp               // direct output to display screen
                    
                    lda #$00                        // init wait for action timer
                    sta LR_WaitTimeLo
                    lda #$0a
                    sta LR_WaitTimeHi
                    
.WaitUser2          jsr ChkUserAction
                    bcs .GotUserKey
                    
                    dec LR_WaitTimeLo
                    bne .WaitUser2
                    
                    dec LR_WaitTimeHi
                    bne .WaitUser2
                    
                    jmp .WaitBlank
                    
.GotUserKey         pha                             // save key
                    lda LR_DisplayChr               // redisplay chr under cursor in case of got in blank blink phase
                    jsr ImageOut2Disp               // direct output to display screen
                    
                    pla                             // restore key
WaitKeyBlinkX       rts
// ------------------------------------------------------------------------------------------------------------- //
// ChkUserAction     Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ChkUserAction       subroutine
                    lda #LR_TypeUIKey               // .hbu024. - default keyboard user interaction
                    sta LR_TypeUI                   // .hbu024.
                    
                    lda LR_KeyNew                   // actual key
                    bne .SetUserActionKey           // user key pressings
                    
                    lda CIAPRA                      // CIA 1 - $DC00 = Data Port A
                    and #$0f                        // isolate - port a:  bit4=fire  bit3=right  bit2=left  bit1=down  bit0=up
                    eor #$0f                        // reverse
                    bne .SetUserActionJoy           // .hbu024. - user joystick moves
                    
                    lda CIAPRA                      // CIA 1 - $DC00 = Data Port A
                    and #$10                        // isolate fire
                    eor #$10                        // .hbu024. - reverse
                    bne .SetUserActionJoy           // .hbu024. - user joystick fire
                    
.SetNoUserAction    clc                             // indicate no user action
                    rts
                    
.SetUserActionJoy   dec LR_TypeUI                   // .hbu024. - set jostick user interaction
.SetUserActionKey   sec                             // indicate user action
ChkUserActionX      rts
// ------------------------------------------------------------------------------------------------------------- //
// ImageOut2Disp     Function: Fill hires display screen
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ImageOut2Disp       subroutine
                    sta LRZ_ImageNo                 // image number
                    lda #>LR_ScrnHiReDisp           // $20
                    bne ImageOut                    // always
// ------------------------------------------------------------------------------------------------------------- //
// ImageOut2Disp     Function: Fill hires preparation screen
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ImageOut2Prep       subroutine
                    sta LRZ_ImageNo                 // image number
                    lda #>LR_ScrnHiRePrep           // $40
                    
ImageOut            subroutine
                    sta LRZ_ImgScreenOut            // target output  $20=$2000 $40=$4000
                    
                    ldy LRZ_ScreenRow               // screen row  (00-0f)
                    ldx LRZ_ScreenCol               // screen col  (00-1b)
                    jsr GetColRowGfxOff             // offsets in xr=col yr=row
                    sty LRZ_GfxRowOff               // row offset
                    
                    jsr SetSpritePos                // xr=VIC Sprite XPOS offset
                    jsr GetOutGfxPosAdd
                    stx LRZ_ImagePosNo              // image position number  (bits 0-1 of LRZ_ScreenCol substitution)
                    
                    lda TabInsImageLe,x             // insert image left tab  (4 different image positions)
                    sta $25                         // isolate right grafic part
                    lda TabInsImageRi,x             // insert image right tab (4 different image positions)
                    sta $26                         // isolate left grafic part
                    
.GetImage           jsr GetImageBytes               // stored from $5b-$7b
                    
.SetHeight          lda #$0b                        // 11 - hight of each image
                    sta LRZ_ImageHight              // image hight
                    
                    ldx #$00
                    
.ImageOut           ldy LRZ_GfxRowOff               // grafic row substitution
                    jsr GetOutGfxPtr
                    
                    ldy #$00
                    lda ($0f),y                     // get grafic screen image byte
                    and $25                         // clear the right grafic part
                    ora LRZ_ImageDataBuf,x          // insert new image byte
                    sta ($0f),y                     // write grafic screen image byte
                    
                    inx                             // point to next image byte
                    ldy #$08                        // insert right part of image into right part of screen image
                    lda ($0f),y                     // get grafic screen image byte
                    and $26                         // clear the left grafic part
                    ora LRZ_ImageDataBuf,x          // insert new image byte
                    sta ($0f),y                     // write grafic screen image byte
                    
                    inx
                    inx
                    
                    inc LRZ_GfxRowOff               // grafic row substitution
                    dec LRZ_ImageHight              // image hight
                    bne .ImageOut
                    
ImageOutX           rts
// ------------------------------------------------------------------------------------------------------------- //
TabInsImageLe       dc.b $00 // ........
                    dc.b $c0 // ##......
                    dc.b $f0 // ####....
                    dc.b $fc // ######..
// ------------------------------------------------------------------------------------------------------------- //
TabInsImageRi       dc.b $3f // ..######
                    dc.b $0f // ....####
                    dc.b $03 // ......##
                    dc.b $00 // ........
// ------------------------------------------------------------------------------------------------------------- //
// ImageOutClear     Function: Clear image on game screen (Shooting/Close Hole Steps/Remove Gold)
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ImageOutClear       subroutine
                    sty LRZ_GfxRowOff               // grafic row substitution
                    sta LRZ_ImageNo                 // image number
                    jsr GetOutGfxPosAdd
                    
                    sta $21                         // low byte grafic tab addition
                    stx LRZ_ImagePosNo              // image position number  (bits 0-1 of LRZ_ScreenCol substitution)
                    
.GetImage           jsr GetImageBytes               // stored from $5b-$7b
                    
                    ldx #$0b
                    stx LRZ_ImageHight              // image hight
                    
                    ldx #$00
                    
.UpdateOut          ldy LRZ_GfxRowOff               // grafic row substitution
                    jsr GetMoveGfxPtr
                    
                    ldy #$00                        // image left part
                    
.Get1st             lda LRZ_ImageDataBuf,x          // image byte
                    eor #$ff
                    and ($0f),y                     // screen grafic pointer byte
                    ora ($11),y                     // hidden grafic pointer byte
.Put1st             sta ($0f),y                     // screen grafic pointer byte
                    
                    inx                             // point to next image byte
                    
                    ldy #$08                        // image right part
                    
.Get2nd             lda LRZ_ImageDataBuf,x          // image byte
                    eor #$ff
                    and ($0f),y                     // screen grafic pointer byte
                    ora ($11),y                     // hidden grafic pointer byte
.Put2nd             sta ($0f),y                     // screen grafic pointer byte
                    
.Ign3rd             inx                             // 3rd imge byte always $00 - ignore
                    inx
                    
                    inc LRZ_GfxRowOff               // grafic row substitution
                    
                    dec LRZ_ImageHight              // image hight
                    bne .UpdateOut
                    
ImageOutClearX      rts
// ------------------------------------------------------------------------------------------------------------- //
// ImageOutXtra      Function: Set images on game screen (Sprites/Shootings/Hidden Ladders)
//                   Parms   :
//                   Returns : 
// ------------------------------------------------------------------------------------------------------------- //
ImageOutXtra        subroutine
                    sty LRZ_GfxRowOff               // grafic row substitution
                    sta LRZ_ImageNo                 // image number
                    jsr SetSpritePos                // xr=VIC Sprite XPOS offset
                    jsr GetOutGfxPosAdd
                    
                    sta $21                         // low byte grafic tab addition
                    stx LRZ_ImagePosNo              // image position number  (bits 0-1 of 4f substitution)
                    
.GetImage           jsr GetImageBytes               // stored from $5b-$7b
                    
                    lda #$0b
                    sta LRZ_ImageHight              // image hight
                    
                    ldx #$00
                    stx $27                         // clear sprite collision  $01=lr caught
                    
.SpriteOut          ldy LRZ_GfxRowOff               // grafic row substitution
                    jsr GetMoveGfxPtr
                    
                    ldy #$00                        // first image half
                    
.Get1st             lda LRZ_ImageDataBuf,x          // image byte
                    ora ($0f),y                     // screen grafic pointer byte
.Set1st             sta ($0f),y                     // screen grafic pointer byte
                    
                    inx                             // image byte pointer
                    
                    ldy #$08                        // second image half
                    
.Get2nd             lda LRZ_ImageDataBuf,x          // image byte
                    ora ($0f),y                     // screen grafic pointer byte
.Set2nd             sta ($0f),y                     // screen grafic pointer byte
                    
.Ign3rd             inx                             // 3rd imge byte always $00 - ignore
                    inx
                    
                    inc LRZ_GfxRowOff               // grafic row substitution
                    
                    dec LRZ_ImageHight              // image hight
                    bne .SpriteOut
                    
ImageOutXtraX       rts
// ------------------------------------------------------------------------------------------------------------- //
// GetImageBytes     Function: Contruct an 11*3 Byte Image at Zero Page $5b-$7b
//                   Parms   : xr - bit0/bit1 isolated from TabSubstCol of GetColRowGfxOff
//                   Returns : 
//                   ID      : .hbu008.
// ------------------------------------------------------------------------------------------------------------- //
GetImageBytes       subroutine
                    stx LR_ImageColType             // save image column type - 4 differerent positions
                    
.SetImageAdr        ldx LRZ_ImageNo                 // image number
                    lda LR_ImageAdrLo,x             // .hbu026.
                    sta LRZ_ImageAdrLo              // .hbu026.
                    lda LR_ImageAdrHi,x             // .hbu026.
                    sta LRZ_ImageAdrHi              // .hbu026.
                    
                    ldy #DatImageLen-1              // image data lenght machine form
.GetImageByte1      lda (LRZ_ImageAdr),y            // get an image row (3 bytes)
.PutImageByte1      sta LRZ_ImageDataBuf,y          // 
                    dey                             // 
                    
.GetImageByte2      lda (LRZ_ImageAdr),y            // 
.PutImageByte2      sta LRZ_ImageDataBuf,y          // 
                    dey                             // 
                    
.GetImageByte3      lda (LRZ_ImageAdr),y            // always zero so far - but neccessary
.PutImageByte3      sta LRZ_ImageDataBuf,y          // 
                    
                    tya                             // care for different addressing mode
                    tax                             // 
                    
.ChkImageType       lda LR_ImageColType             // test image column type
                    beq .SetImageNext               // no   shift for type $00
                    cmp #$01
                    beq .ShiftImageRow2             // 2bit shift for type $01
                    cmp #$02
                    beq .ShiftImageRow4             // 4bit shift for type $02
                    
.ShiftImageRow6     lsr LRZ_ImageDataBuf,x          // 6bit shift for type $03
                    inx
                    ror LRZ_ImageDataBuf,x
                    dex
                    lsr LRZ_ImageDataBuf,x
                    inx
                    ror LRZ_ImageDataBuf,x
                    dex
.ShiftImageRow4     lsr LRZ_ImageDataBuf,x
                    inx
                    ror LRZ_ImageDataBuf,x
                    dex
                    lsr LRZ_ImageDataBuf,x
                    inx
                    ror LRZ_ImageDataBuf,x
                    dex
.ShiftImageRow2     lsr LRZ_ImageDataBuf,x
                    inx
                    ror LRZ_ImageDataBuf,x
                    dex
                    lsr LRZ_ImageDataBuf,x
                    inx
                    ror LRZ_ImageDataBuf,x
                    
.SetImageNext       dey
                    bpl .GetImageByte1              // next image data row triplet
                    
GetImageBytesX      rts
// ------------------------------------------------------------------------------------------------------------- //
// SetSpritePos      Function: Move Sprite Left/Right
//                   Parms   : ac=Spirte ID
//                   Returns : xr=VIC Sprite XPOS offset
// ------------------------------------------------------------------------------------------------------------- //
SetSpritePos        subroutine
                    lda LR_SprtPosCtrl              // control sprite pos init  $00=init
                    bne SetSpritePosX
                    
                    lda LRZ_ImageNo                 // image number
.ChkSpriteMax       cmp #NoSprites+1                // .hbu008. - first half of images ($00-$39) only
                    bcs SetSpritePosX               // exit if digit or character
                    
                    tay
                    lda TabSpriteGame,y             // image substitution tab
                    bmi SetSpritePosX               // image not to be substituted
                    beq .SavOffset
                    
                    sta LRZ_ImageNo                 // substitute numbered MC image with game image
                    
.SavOffset          stx $21                         // grafic xr offset from GetColRowGfxOff
                    jsr CopySpriteData              // xr=sprite number * 2
                    
.SetSpriteXPos      lda $21                         // grafic xr offset from GetColRowGfxOff
                    clc
                    adc #$0c                        // 12
                    asl a                           // *2
                    and #$f8                        // clear bits 0-2
                    sta SP0X,x                      // VIC 2 - $D000 = Sprite 0 PosX
                    bcc .ClrSpriteXPosHi            // no x pos msb so ClearSpritesXMSB
                    
.SetSpriteXPosHi    lda TabSetSprtMSB,x             // sprite set x pos msb tab
                    ora MSIGX                       // VIC 2 - $D010 = MSBs Sprites 0-7 PosX
                    sta MSIGX                       // VIC 2 - $D010 = MSBs Sprites 0-7 PosX
                    jmp .SetSpriteYPos
                    
.ClrSpriteXPosHi    lda TabClrSprtMSB,x             // sprite clear x pos msb tab
                    and MSIGX                       // VIC 2 - $D010 = MSBs Sprites 0-7 PosX
                    sta MSIGX                       // VIC 2 - $D010 = MSBs Sprites 0-7 PosX
                    
.SetSpriteYPos      lda LRZ_GfxRowOff               // grafic row substitution
                    clc
                    adc #$32                        // 50
                    sta SP0Y,x                      // VIC 2 - $D001 = Sprite 0 PosY
                    
                    lda SPSPCL                      // VIC 2 - $D01E = Sprite/Sprite Collision
                    and #$01                        // isolate bit 0
                    sta $27                         // sprite collision  1=lr caught
                    
                    pla                             // discard return address
                    pla
                    
SetSpritePosX       rts
// ------------------------------------------------------------------------------------------------------------- //
TabSetSprtMSB       dc.b $01 // .......#  set   - sprite x pos msb tab
TabClrSprtMSB       dc.b $fe // #######.  clear - sprite x pos msb tab
                    
                    dc.b $02 // ......#.  set   - sprite x pos msb tab
                    dc.b $fd // ######.#  clear - sprite x pos msb tab
                    
                    dc.b $04 // .....#..  set   - sprite x pos msb tab
                    dc.b $fb // #####.##  clear - sprite x pos msb tab
                    
                    dc.b $08 // ....#...  set   - sprite x pos msb tab
                    dc.b $f7 // ####.###  clear - sprite x pos msb tab
                    
                    dc.b $10 // ...#....  set   - sprite x pos msb tab
                    dc.b $ef // ###.####  clear - sprite x pos msb tab
                    
                    dc.b $20 // ..#.....  set   - sprite x pos msb tab
                    dc.b $df // ##.#####  clear - sprite x pos msb tab
                    
                    dc.b $40 // .#......  set   - sprite x pos msb tab
                    dc.b $bf // #.######  clear - sprite x pos msb tab
                    
                    dc.b $80 // #.......  set   - sprite x pos msb tab
                    dc.b $7f // .#######  clear - sprite x pos msb tab
// ------------------------------------------------------------------------------------------------------------- //
// TabSpriteGame     Function: Game sprite substitution table
//                           : All entries correspond to their positions in DatImages
//                           : Sprite $00 entries will be positionally corrected
//                           : Sprite $ff entries will be ignored
//                           : Sprite $nn entries will replace their corresponding position number
//                   Parms   : ac=Sprite ID
//                   Returns : 
// ------------------------------------------------------------------------------------------------------------- //
TabSpriteGame       dc.b $ff                        // $00 (not_used)
                    dc.b $ff                        // $01 (not_used)
                    dc.b $ff                        // $02 (not_used)
                    dc.b $ff                        // $03 (not_used)
                    dc.b $ff                        // $04 (not_used)
                    dc.b $ff                        // $05 (not_used)
                    dc.b $ff                        // $06 (not_used)
                    dc.b $ff                        // $07 (not_used)
                    dc.b NoSprite_RuLe00            // $08 - enemy      - replace MC tile in game mode
                    dc.b $00                        // $09 - LodeRunner - if set to NoSprite_RuRi00 - lr is misplaced in many levels - why??
                    dc.b $ff                        // $0a (not_used)
                    dc.b $00                        // $0b --> sprite run    left  01
                    dc.b $00                        // $0c --> sprite run    left  02
                    dc.b $00                        // $0d --> sprite run    left  03
                    dc.b $00                        // $0e --> sprite ladder u/d   01
                    dc.b $00                        // $0f --> sprite fire   left    
                    dc.b $00                        // $10 --> sprite run    right 01 - .hbu008.
                    dc.b $00                        // $11 --> sprite run    right 02
                    dc.b $00                        // $12 --> sprite run    right 03
                    dc.b $00                        // $13 --> sprite ladder u/d   02
                    dc.b $00                        // $14 --> sprite fall   left    
                    dc.b $00                        // $15 --> sprite fall   right   
                    dc.b $00                        // $16 --> sprite pole   right 01
                    dc.b $00                        // $17 --> sprite pole   right 02
                    dc.b $00                        // $18 --> sprite pole   right 03
                    dc.b $00                        // $19 --> sprite pole   left  01
                    dc.b $00                        // $1a --> sprite pole   left  02
                    dc.b $00                        // $1b --> sprite pole   left  03
                    dc.b $ff                        // $1c (not_used)
                    dc.b $ff                        // $1d (not_used)
                    dc.b $ff                        // $1e (not_used)
                    dc.b $ff                        // $1f (not_used)
                    dc.b $ff                        // $20 (not_used)
                    dc.b $ff                        // $21 (not_used)
                    dc.b $ff                        // $22 (not_used)
                    dc.b $ff                        // $23 (not_used)
                    dc.b $ff                        // $24 (not_used)
                    dc.b $ff                        // $25 (not_used)
                    dc.b $00                        // $26 --> sprite fire   right
                    dc.b $ff                        // $27 (not_used)
                    dc.b $ff                        // $28 (not_used)
                    dc.b NoSprite_RuRi00            // $29 - 
                    dc.b NoSprite_RuRi01            // $2a - 
                    dc.b NoSprite_RuRi02            // $2b - 
                    dc.b NoSprite_RuLe01            // $2c - 
                    dc.b NoSprite_RuLe02            // $2d - 
                    dc.b NoSprite_PoRi00            // $2e - 
                    dc.b NoSprite_PoRi01            // $2f - 
                    dc.b NoSprite_PoRi02            // $30 - 
                    dc.b NoSprite_PoLe00            // $31 - 
                    dc.b NoSprite_PoLe01            // $32 - 
                    dc.b NoSprite_PoLe02            // $33 - 
                    dc.b NoSprite_Ladr00            // $34 - 
                    dc.b NoSprite_Ladr01            // $35 - 
                    dc.b NoSprite_FallRi            // $36 - 
                    dc.b NoSprite_FallLe            // $37 - 
                    dc.b $ff                        // $38 (not_used)
                    dc.b $ff                        // $39 (not_used)
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
CopySpriteData      subroutine
                    pha                             // save image id
                    
                    lda $21                         // grafic xr offset from GetColRowGfxOff
                    and #$03                        // isolate bit 0-1
                    tax
                    jsr GetImageBytes               // stored from $5b-$7b
                    
                    pla                             // restore image id
                    beq .CopyDataI                  // lode runner
                    
                    lda LR_NoEnemy2Move             // # of enemy to move
                    
.CopyDataI          tax
                    lda TabSprtDatPtrLo,x           // sprite data pos low tab
                    sta ..ModMovSprtDatL            // modify store address low
                    lda TabSprtDatPtrHi,x           // sprite data pos high tab
                    sta ..ModMovSprtDatH            // modify store address high
                    
                    lda TabSpriteNum,x              // sprite number tab
                    tax
                    
                    ldy #$20                        // 32
.CopyData           lda LRZ_ImageDataBuf,y          // image has 33 bytes
.MoveSprtDat        sta .MoveSprtDat,y              // store it to correct sprite data storage  ($0c00-$0dff)
..ModMovSprtDatL    equ *-2
..ModMovSprtDatH    equ *-1
                    dey
                    bpl .CopyData
                    
                    txa
                    asl a                           // *2 - gives VIC sprite XPOS offset
                    tax
                    
CopySpriteDataX     rts
// ------------------------------------------------------------------------------------------------------------- //
TabSprtDatPtrLo     dc.b <LR_SpriteData00           // sprite data pos low tab
                    dc.b <LR_SpriteData01
                    dc.b <LR_SpriteData02
                    dc.b <LR_SpriteData03
                    dc.b <LR_SpriteData04
                    dc.b <LR_SpriteData05
// ------------------------------------------------------------------------------------------------------------- //
TabSprtDatPtrHi     dc.b >LR_SpriteData00           // sprite data pos high tab
                    dc.b >LR_SpriteData01
                    dc.b >LR_SpriteData02
                    dc.b >LR_SpriteData03
                    dc.b >LR_SpriteData04
                    dc.b >LR_SpriteData05
// ------------------------------------------------------------------------------------------------------------- //
TabSpriteNum        dc.b $00 // ........             // filler  - LR_NoEnemy2Move counter from 1-5
                    dc.b $02 // ......#.             // enemy 1 - color table pos
                    dc.b $03 // ......##             // enemy 2 - color table pos
                    dc.b $04 // .....#..             // enemy 3 - color table pos
                    dc.b $06 // .....##.             // enemy 4 - color table pos
                    dc.b $07 // .....###             // enemy 5 - color table pos
// ------------------------------------------------------------------------------------------------------------- //
// GetColRowGfxOff   Function:
//                   Parms   :
//                   Returns : offsets in xr=col yr=row
// ------------------------------------------------------------------------------------------------------------- //
GetColRowGfxOff     subroutine
                    lda TabSubstRow,y               // substitute row tab
Mod__RowGfxL        equ *-2
Mod__RowGfxH        equ *-1
                    pha
                    lda TabSubstCol,x               // substitute column tab
                    tax                             // col
                    pla
                    tay                             // row
                    
GetColRowGfxOffX    rts
// ------------------------------------------------------------------------------------------------------------- //
TabSubstRowHighS    dc.b $00 // 00                   // new high score grouped row positions
                    dc.b $0a // 01
                    dc.b $15 // 02
                    dc.b $20 // 03
                    dc.b $2b // 04
                    dc.b $35 // 05
                    dc.b $41 // 06
                    dc.b $4d // 07
                    dc.b $5c // 08
                    dc.b $67 // 09
                    dc.b $72 // 0a
                    dc.b $81 // 0b
                    dc.b $8c // 0c
                    dc.b $97 // 0d
                    dc.b $a6 // 0e
                    dc.b $b1 // 0f
                    dc.b $bc // 10
// ------------------------------------------------------------------------------------------------------------- //
TabSubstRow         dc.b $00 // 00                   // game row positions
                    dc.b $0b // 01
                    dc.b $16 // 02
                    dc.b $21 // 03
                    dc.b $2c // 04
                    dc.b $37 // 05
                    dc.b $42 // 06
                    dc.b $4d // 07
                    dc.b $58 // 08
                    dc.b $63 // 09
                    dc.b $6e // 0a
                    dc.b $79 // 0b
                    dc.b $84 // 0c
                    dc.b $8f // 0d
                    dc.b $9a // 0e
                    dc.b $a5 // 0f
                    dc.b $b5 // 10
// ------------------------------------------------------------------------------------------------------------- //
TabSubstCol         dc.b $0a // 01: ....#.   #.   - rightmost two bits isolated for GetImageBytes - position type 0-3
                    dc.b $0f // 02: ....##   ##
                    dc.b $14 // 03: ...#.#   ..
                    dc.b $19 // 04: ...##.   .#
                    dc.b $1e // 05: ...###   #.
                    dc.b $23 // 06: ..#...   ##
                    dc.b $28 // 07: ..#.#.   ..
                    dc.b $2d // 08: ..#.##   .#
                    dc.b $32 // 09: ..##..   #.
                    dc.b $37 // 0a: ..##.#   ##
                    dc.b $3c // 0b: ..####   ..
                    dc.b $41 // 0c: .#....   .#
                    dc.b $46 // 0d: .#...#   #.
                    dc.b $4b // 0e: .#..#.   ##
                    dc.b $50 // 0f: .#.#..   ..
                    dc.b $55 // 10: .#.#.#   .#
                    dc.b $5a // 11: .#.##.   #.
                    dc.b $5f // 12: .#.###   ##
                    dc.b $64 // 13: .##..#   ..
                    dc.b $69 // 14: .##.#.   .#
                    dc.b $6e // 15: .##.##   #.
                    dc.b $73 // 16: .###..   ##
                    dc.b $78 // 17: .####.   ..
                    dc.b $7d // 18: .#####   .#
                    dc.b $82 // 19: #.....   #.
                    dc.b $87 // 1a: #....#   ##
                    dc.b $8c // 1b: #...##   ..
                    dc.b $91 // 1c: #..#..   .#
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetXOff             subroutine
                    tya
                    pha                             // save yr
                    jsr GetColRowGfxOff             // offsets in xr=col yr=row
                    
                    pla
                    tay                             // restore yr
                    txa
                    clc
                    adc TabOffsetsX,y               // offset tab
                    tax
                    
GetXOffX            rts
// ------------------------------------------------------------------------------------------------------------- //
TabOffsetsX         dc.b $fe // -2
                    dc.b $ff // -1
                    dc.b $00 //  0
                    dc.b $01 // +1
                    dc.b $02 // +2
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetYOff             subroutine
                    txa
                    pha                             // save xr
                    jsr GetColRowGfxOff             // offsets in xr=col yr=row
                    
                    pla
                    tax                             // restore
                    tya
                    clc
                    adc TabOffsetsY,x
                    tay
                    
GetYOffX            rts
// ------------------------------------------------------------------------------------------------------------- //
TabOffsetsY         dc.b $fb // -4
                    dc.b $fd // -2
                    dc.b $00 //  0
                    dc.b $02 // +2
                    dc.b $04 // +4
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetOutGfxPosAdd     subroutine
                    lda #$00
                    sta LR_GfxAddHi                 // init high grafic add
                    
                    txa
                    pha                             // save xr
                    and #$03                        // isolate bit 0-1
                    tax
                    pla                             // restore xr
                    
                    asl a                           // *2
                    rol LR_GfxAddHi                 // save carry in high grafic add
                    and #$f8                        // kill bits 0-2
                    sta LR_GfxAddLo                 //   of low grafic add
                    
GetOutGfxPosAddX    rts
// ------------------------------------------------------------------------------------------------------------- //
// SetCtrlDataPtr    Function: Set both expanded level data pointers
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
SetCtrlDataPtr      subroutine
                    lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
                    sta LRZ_XLvlModRowLo
                    sta LRZ_XLvlOriRowLo
                    lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
.PtrModify          sta LRZ_XLvlModRowHi
                    lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
.PtrOrigin          sta LRZ_XLvlOriRowHi
                    
SetCtrlDataPtrX     rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetOutGfxPtrClr     subroutine
                    lda #$00
                    sta LR_GfxAddLo
                    sta LR_GfxAddHi
GetOutGfxPtr        lda LR_TabOffHiresLo,y          // offset grafic output low
                    clc
                    adc LR_GfxAddLo                 // low grafic add
                    sta $0f                         // screen grafic low pointer
                    lda LR_TabOffHiresHi,y          // offset grafic output high
                    adc LR_GfxAddHi                 // high grafic add
                    ora LRZ_ImgScreenOut            // graphic output  (20=2000-2fff  40=4000-4fff)
                    sta $10                         // screen grafic high pointer
                    
GetOutGfxPtrX       rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetMoveGfxPtr       subroutine
                    lda LR_TabOffHiresLo,y          // offset grafic output low
                    clc
                    adc LR_GfxAddLo                 // low grafic add
                    sta $0f                         // screen grafic low pointer
                    sta $11                         // hidden grafic low pointer
                    
                    lda LR_TabOffHiresHi,y          // offset grafic output high
                    adc LR_GfxAddHi                 // high grafic add
                    ora #>LR_ScrnHiReDisp           // $20 - point to $2000-$3fff  (display screen)
                    sta $10                         // screen grafic high pointer
                    eor #>LR_ScrnHiReDisp + >LR_ScrnHiRePrep // $60 - point to $4000-$5fff  (hidden screen)
                    sta $12                         // hidden grafic high pointer
                    
GetMoveGfxPtrX      rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
ClearHiresDisp      subroutine
                    lda #>LR_ScrnHiReDisp           // $2000-$3fff - hires display screen
                    
                    ldx #$00                        // disable all sprites
                    stx SPENA                       // VIC 2 - $D015 = Sprite Enable
                    
                    ldx #>(LR_ScrnHiReDisp + $2000) // $40 - upper border
                    bne ClearScrn                   // always
                    
ClearHiresPrep      lda #>LR_ScrnHiRePrep           // $40=$4000-$5fff  copy of screen  (hidden setup/copy to $2000)
                    ldx #>(LR_ScrnHiRePrep + $2000) // $60 - upper border
                    
ClearScrn           sta $10                         // screen grafic high pointer
                    ldy #$00
                    sty $0f                         // screen grafic low pointer
                    tya
                    
.Clear              sta ($0f),y                     // screen grafic pointer byte
                    iny                             // next byte
                    bne .Clear
                    
                    inc $10                         // next block
                    cpx $10                         // upper border
                    bne .Clear                      // not reached
                    
ClearHiresX         rts
// ------------------------------------------------------------------------------------------------------------- //
ClearHiresDispH     subroutine
                    lda #>LR_ScrnHiReDisp           // $2000-$3fff - hires display screen
                    
                    ldx #$00                        // disable all sprites
                    stx SPENA                       // VIC 2 - $D015 = Sprite Enable
                    
                    ldx #>(LR_ScrnHiReDisp + $2000)-5 // $3b - upper border - do not clear baselines
                    bne ClearScrnH                  // always
                    
ClearHiresPrepH     lda #>LR_ScrnHiRePrep           // $40=$4000-$5fff  copy of screen  (hidden setup/copy to $2000)
                    ldx #>(LR_ScrnHiRePrep + $2000)-5 // $5b - upper border - do not clear baselines
                    
ClearScrnH          sta $10                         // screen grafic high pointer
                    ldy #$00
                    sty $0f                         // screen grafic low pointer
                    tya
                    
.Clear              sta ($0f),y                     // screen grafic pointer byte
                    iny                             // next byte
                    bne .Clear
                    
                    inc $10                         // next block
                    cpx $10                         // upper border
                    bne .Clear                      // not reached
                    
                    ldy #$80                        // clear the left over bit
.ClearRest          sta ($0f),y                     // screen grafic pointer byte
                    dey                             // next byte
                    bpl .ClearRest                  // 
                    
ClearHiresHX        rts
// ------------------------------------------------------------------------------------------------------------- //
TabExLvlDatRowLo    dc.b (LR_ScrnMaxCols + 1) * $00  // $00 - poiter to expanded level data rows - low values same for both types
                    dc.b (LR_ScrnMaxCols + 1) * $01  // $1c
                    dc.b (LR_ScrnMaxCols + 1) * $02  // $38
                    dc.b (LR_ScrnMaxCols + 1) * $03  // $54
                    dc.b (LR_ScrnMaxCols + 1) * $04  // $70
                    dc.b (LR_ScrnMaxCols + 1) * $05  // $8c
                    dc.b (LR_ScrnMaxCols + 1) * $06  // $a8
                    dc.b (LR_ScrnMaxCols + 1) * $07  // $c4
                    dc.b (LR_ScrnMaxCols + 1) * $08  // $e0
                    
                    dc.b (LR_ScrnMaxCols + 1) * $00  // $00
                    dc.b (LR_ScrnMaxCols + 1) * $01  // $1c
                    dc.b (LR_ScrnMaxCols + 1) * $02  // $38
                    dc.b (LR_ScrnMaxCols + 1) * $03  // $54
                    dc.b (LR_ScrnMaxCols + 1) * $04  // $70
                    dc.b (LR_ScrnMaxCols + 1) * $05  // $8c
                    dc.b (LR_ScrnMaxCols + 1) * $06  // $a8
// ------------------------------------------------------------------------------------------------------------- //
TabExLvlModRowHi    dc.b >(LR_LevelTileData + $0000) // $00 - pointer to expanded level data rows: modified - with    lr/en replacements/holes
                    dc.b >(LR_LevelTileData + $0000) // $1c
                    dc.b >(LR_LevelTileData + $0000) // $38
                    dc.b >(LR_LevelTileData + $0000) // $54
                    dc.b >(LR_LevelTileData + $0000) // $70
                    dc.b >(LR_LevelTileData + $0000) // $8c
                    dc.b >(LR_LevelTileData + $0000) // $a8
                    dc.b >(LR_LevelTileData + $0000) // $c4
                    dc.b >(LR_LevelTileData + $0000) // $e0
                                                          
                    dc.b >(LR_LevelTileData + $0100) // $00
                    dc.b >(LR_LevelTileData + $0100) // $1c
                    dc.b >(LR_LevelTileData + $0100) // $38
                    dc.b >(LR_LevelTileData + $0100) // $54
                    dc.b >(LR_LevelTileData + $0100) // $70
                    dc.b >(LR_LevelTileData + $0100) // $8c
                    dc.b >(LR_LevelTileData + $0100) // $a8
// ------------------------------------------------------------------------------------------------------------- //
TabExLvlOriRowHi    dc.b >(LR_LevelCtrlData + $0000) // $00 - pointer to expanded level data rows: original - without lr/en replacements/holes
                    dc.b >(LR_LevelCtrlData + $0000) // $1c
                    dc.b >(LR_LevelCtrlData + $0000) // $38
                    dc.b >(LR_LevelCtrlData + $0000) // $54
                    dc.b >(LR_LevelCtrlData + $0000) // $70
                    dc.b >(LR_LevelCtrlData + $0000) // $8c
                    dc.b >(LR_LevelCtrlData + $0000) // $a8
                    dc.b >(LR_LevelCtrlData + $0000) // $c4
                    dc.b >(LR_LevelCtrlData + $0000) // $e0
                                                          
                    dc.b >(LR_LevelCtrlData + $0100) // $00
                    dc.b >(LR_LevelCtrlData + $0100) // $1c
                    dc.b >(LR_LevelCtrlData + $0100) // $38
                    dc.b >(LR_LevelCtrlData + $0100) // $54
                    dc.b >(LR_LevelCtrlData + $0100) // $70
                    dc.b >(LR_LevelCtrlData + $0100) // $8c
                    dc.b >(LR_LevelCtrlData + $0100) // $a8
// ------------------------------------------------------------------------------------------------------------- //
// ShowExitLadders   Function: Show secret ladders if all gold is collected
//                   Parms   :
//                   Returns : 
//                   Label   : .hbu025. - shortened
// ------------------------------------------------------------------------------------------------------------- //
ShowExitLadders     subroutine
                    ldx LR_NumXitLadders            // # hidden ladders to display
                    bne .GetRow                     // 
                    beq .SetGoldUnderflow           // no secret ladder to show
                    
.GetNextLadderPos   ldx LR_NumXitLadders            // # hidden ladders to display
.GetRow             lda LR_TabXitLdrRow,x           // adr row hidden ladders tab
                    sta LRZ_ScreenRow               // screen row  (00-0f)
                    
                    tay                             // row number
                    jsr SetCtrlDataPtr              // .hbu025. - set both expanded level data pointers

.GetCol             lda LR_TabXitLdrCol,x           // adr column hidden ladder tab
                    sta LRZ_ScreenCol               // screen col  (00-1b)
                    
                    tay
.LadderOutCtrl      lda #NoTileLadder               // 
                    sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
                    sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
                    jsr ImageOut2Prep               // direct output to preparation screen
                    
                    ldx LRZ_ScreenCol               // screen col  (00-1b)
                    ldy LRZ_ScreenRow               // screen row  (00-0f)
                    jsr GetColRowGfxOff             // offsets in xr=col yr=row
                    
                    lda #NoTileLadder               // 
                    jsr ImageOutXtra                // set images on game screen (sprites/shoots/hidden ladders)
                    
.DecLadderCount     dec LR_NumXitLadders            // # hidden ladders to display
                    bne .GetNextLadderPos           // 
                    
.SetGoldUnderflow   dec LR_Gold2Get                 // avoid to be in MaiLoop.Victory more than once
                    
ShowExitLaddersX    rts                             // 
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetAKey             subroutine
                    lda LR_KeyNew
                    beq GetAKey
                    
                    ldx #LR_KeyNewNone
                    stx LR_KeyNew
                    
GetAKeyX            rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
FlipGmeOverSign     subroutine
                    lda #$01
                    sta LR_Work                     // init flip sign spin speed
                    lda #>LR_ScrnHiReDisp           // $20
                    sta LRZ_ImgScreenOut            // graphic output  ($20=$2000-$2fff  $40=$4000-$4fff)
                    
.FlipSign           jsr FlipSignPhase05
                    jsr FlipSignPhase04
                    jsr FlipSignPhase03
                    jsr FlipSignPhase02
                    jsr FlipSignPhase01
                    jsr FlipSignPhase00
                    jsr FlipSignPhase01
                    jsr FlipSignPhase02
                    jsr FlipSignPhase03
                    jsr FlipSignPhase04
                    jsr FlipSignPhase05
                    jsr FlipSignPhase0a
                    jsr FlipSignPhase09
                    jsr FlipSignPhase08
                    jsr FlipSignPhase07
                    jsr FlipSignPhase06
                    jsr FlipSignPhase07
                    jsr FlipSignPhase08
                    jsr FlipSignPhase09
                    jsr FlipSignPhase0a
                    
.ChkSpeed           lda LR_Work                     // flip sign spin speed
                    cmp #LR_FlipSpeedMin            // .hbu000. - speed up
                    bcc .FlipSign
                    
.StopSign           jsr FlipSignPhase05
                    jsr FlipSignPhase04
                    jsr FlipSignPhase03
                    jsr FlipSignPhase02
                    jsr FlipSignPhase01
                    jsr FlipSignPhase00
                    
                    clc
FlipGmeOverSignX    rts
// ------------------------------------------------------------------------------------------------------------- //
//                   Function:
//                   Parms   :
//                   Returns :
// ------------------------------------------------------------------------------------------------------------- //
FlipSignPhase00     subroutine
                    jsr FlipSignOut
                    dc.b NoSignLine00
                    dc.b NoSignLine01
                    dc.b NoSignLine02
                    dc.b NoSignLine03
                    dc.b NoSignLine04
                    dc.b NoSignLine05
                    dc.b NoSignLine06
                    dc.b NoSignLine07
                    dc.b NoSignLine08
                    dc.b NoSignLine09
                    dc.b NoSignLine0a
                    dc.b NoSignLine02
                    dc.b NoSignLine01
                    dc.b NoSignLine00
FlipSignPhase01     jsr FlipSignOut
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine01
                    dc.b NoSignLine02
                    dc.b NoSignLine03
                    dc.b NoSignLine04
                    dc.b NoSignLine05
                    dc.b NoSignLine07
                    dc.b NoSignLine09
                    dc.b NoSignLine0a
                    dc.b NoSignLine02
                    dc.b NoSignLine01
                    dc.b NoSignLine00
                    dc.b NoSignLine00
FlipSignPhase02     jsr FlipSignOut
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine01
                    dc.b NoSignLine02
                    dc.b NoSignLine03
                    dc.b NoSignLine04
                    dc.b NoSignLine09
                    dc.b NoSignLine0a
                    dc.b NoSignLine02
                    dc.b NoSignLine01
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
FlipSignPhase03     jsr FlipSignOut
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine01
                    dc.b NoSignLine02
                    dc.b NoSignLine03
                    dc.b NoSignLine0a
                    dc.b NoSignLine02
                    dc.b NoSignLine01
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
FlipSignPhase04     jsr FlipSignOut
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine01
                    dc.b NoSignLine03
                    dc.b NoSignLine0a
                    dc.b NoSignLine01
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
FlipSignPhase05     jsr FlipSignOut
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine01
                    dc.b NoSignLine01
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
FlipSignPhase06     jsr FlipSignOut
                    dc.b NoSignLine00
                    dc.b NoSignLine01
                    dc.b NoSignLine02
                    dc.b NoSignLine0a
                    dc.b NoSignLine09
                    dc.b NoSignLine08
                    dc.b NoSignLine07
                    dc.b NoSignLine06
                    dc.b NoSignLine05
                    dc.b NoSignLine04
                    dc.b NoSignLine03
                    dc.b NoSignLine02
                    dc.b NoSignLine01
                    dc.b NoSignLine00
FlipSignPhase07     jsr FlipSignOut
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine01
                    dc.b NoSignLine02
                    dc.b NoSignLine0a
                    dc.b NoSignLine09
                    dc.b NoSignLine07
                    dc.b NoSignLine05
                    dc.b NoSignLine04
                    dc.b NoSignLine03
                    dc.b NoSignLine02
                    dc.b NoSignLine01
                    dc.b NoSignLine00
                    dc.b NoSignLine00
FlipSignPhase08     jsr FlipSignOut
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine01
                    dc.b NoSignLine02
                    dc.b NoSignLine0a
                    dc.b NoSignLine09
                    dc.b NoSignLine04
                    dc.b NoSignLine03
                    dc.b NoSignLine02
                    dc.b NoSignLine01
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
FlipSignPhase09     jsr FlipSignOut
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine01
                    dc.b NoSignLine02
                    dc.b NoSignLine0a
                    dc.b NoSignLine03
                    dc.b NoSignLine02
                    dc.b NoSignLine01
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
FlipSignPhase0a     jsr FlipSignOut
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine01
                    dc.b NoSignLine0a
                    dc.b NoSignLine03
                    dc.b NoSignLine01
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
                    dc.b NoSignLine00
// ------------------------------------------------------------------------------------------------------------- //
//                 Function:
//                 Parms   :
//                 Returns :
// ------------------------------------------------------------------------------------------------------------- //
FlipSignOut       subroutine
FlipSignOut       pla                             // start adr of data array is the return adr
                  sta $0d
                  pla
                  sta $0e
                  
                  ldy #$50
                  sty $50                         // screen row  (00-0f)
                  bne .SetSignPtr                 // always
                  
.SetGfxPtr        jsr GetOutGfxPtrClr             // ($0f/$10) pointer
                  
                  ldy #$00
                  lda ($0d),y                     // get sign control byte
                  asl a                           // *2
                  tax
                  lda TabSignDataAdr,x            // flip data address tab
                  sta ._ModGetDataLo              // modify load cmd low
                  lda TabSignDataAdr+1,x          // flip data address tab + 1
                  sta ._ModGetDataHi              // modify load cmd high
                  
                  ldy #$70
                  sty $20                         // grafic row substitution
                  
                  ldy #TabSignDataLen+2           // $0e - sign data lenght
                  sty $1e
                  
.FlipSign         ldy $1e
                  inc $1e
.GetSignData      lda .GetSignData,y              // get sign data byte
._ModGetDataLo    equ  *-2
._ModGetDataHi    equ  *-1
                  lsr a                           // *2
                  ldy $20                         // grafic row substitution
                  sta ($0f),y                     // screen grafic pointer byte
                  tya
                  clc
                  adc #$08                        // point to next position
                  sta $20                         // grafic row substitution
                  
                  ldy $1e
                  cpy #$1a                        // max
                  bcc .FlipSign
                  
.SetSignPtr       jsr FlipSignIncPtr
                  
                  inc $50                         // screen row  (00-0f)
                  ldy $50                         // screen row  (00-0f)
                  cpy #$5f                        // max
                  bcc .SetGfxPtr
                  
                  ldx LR_Work                     // flip sign spin speed
                  ldy #$ff
.Wait             dey
                  bne .Wait
                  dex
                  bne .Wait
                  
                  inc LR_Work                     // flip sign spin speed so wait longer the next time
                  lda CIAPRA                      // CIA 1 - $DC00 = Data Port A
                  and #$10                        // isolate fire
                  beq FlipSignFinish              // pressed
                  
                  lda LR_KeyNew                   // actual key
                  bne FlipSignFinish              // pressed some
                  
FlipSignOutX      rts
// ------------------------------------------------------------------------------------------------------------- //
FlipSignFinish    subroutine
FlipSignFinish    pla                             // pull return address from stack
                  pla
                  
                  sec
FlipSignFinishX   rts
// ------------------------------------------------------------------------------------------------------------- //
FlipSignIncPtr    subroutine
FlipSignIncPtr    inc $0d
                  bne FlipSignIncPtrX
                  inc $0e
                  
FlipSignIncPtrX   rts
// ------------------------------------------------------------------------------------------------------------- //
Data              include  inc\LR_Data.asm        // Game Chr, Sprites// Levels, ...
// ------------------------------------------------------------------------------------------------------------- //
