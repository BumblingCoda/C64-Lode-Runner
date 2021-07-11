// ------------------------------------------------------------------------------------------------------------- //
// Lode Runner - IT!PRG - Modified with some stolen ideas
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
// $6000 - $!!!!:  Program Code
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
*= $6000  "Game Start"                 // Start address
// ------------------------------------------------------------------------------------------------------------- //
// compiler settings                                                                 //
// ------------------------------------------------------------------------------------------------------------- //
//Import Virtual Code
#import  "inc\cia1.asm"           // Complex Interface Adapter (CIA) #1 Registers  $DC00-$DC0F
#import  "inc\cia2.asm"           // Complex Interface Adapter (CIA) #2 Registers  $DD00-$DD0F
#import  "inc\sid.asm"            // Sound Interface Device (SID) Registers        $D400-$D41C
#import  "inc\vic.asm"            // Video Interface Chip (VIC-II) Registers       $D000-$D02E
#import  "inc\kernel.asm"         // Kernel Vectors
#import  "inc\color.asm"          // Colour RAM Address / Colours
#import  "inc\mem.asm"            // Memory Layout
//               
#import  "inc\LR_Vars.asm"        // Game Variables
#import  "inc\LR_Zpg.asm"         // Zero Page Variables
//Data                   "inc\LR_Data!asm"        // included at the very end
// ------------------------------------------------------------------------------------------------------------- //
Start:{
        lda #$00      
        tax           
    !ClrStack:
        sta STACK,x                 //$0100   
        inx           
        bne !ClrStack-
        dex                         // $ff
        txs                         // init stack pointer
        
        jsr GameInitOnce            // Initialise stuff just once 
        
        lda #LR_GameGame            // - force block load
        sta LR_GameCtrl             
        
        lda #LR_DiskRead            
        jsr GetPutHiScores          // Target: $1100-$11ff with ac: $01=load $02=store 81= 82=
        
    !ChkBadDisk:
        cmp #LR_DiskNoData          // was no load runner data disk
        bne ColdStart

SetGood:
        lda #LR_DiskWrite           // write back formatted high scores
        jsr GetPutHiScores          // Target: $1100-$11ff
}
// ------------------------------------------------------------------------------------------------------------- //
ColdStart:{
        lda #LR_VolumeMax
        sta LR_Volume
        sta LR_FallsDown                            // $00=fall $20=no fall $ff=init
        sta LR_DeathTune
        sta LR_ShootMode
        
        lda #$00
        sta LR_PtrNxtTunePos                        // pointer: next free tune buffer byte
        sta LR_PtrTuneToPlay
        sta LR_Shoots                               // $00=no $01=right $ff=left
        sta LR_DeathTune
        sta LR_KeyNew
        sta LR_KeyOld
        sta LR_JoyNew
        sta LR_JoyOld
        sta LR_SprtPosCtrl                          // $00 - set sprites
        sta LR_LevelNoXmit
        sta LR_ExpertMode 
        sta EXTCOL                                  // - VIC 2 - $D020 = Border Color
        lda #>LR_LvlDataSavLod                      // $10 - Target: $1000-$10ff
        sta ExecDiskCmdRead.Mod_GetDiskByte         // adapt ReadDiskData  command
        sta ExecDiskCmdWrite.Mod_PutDiskByte        // adapt WriteDiskData command              
        sta LR_Random                               // last valid RND beam pos
        lda LRZ_MatrixLastKey                       // c64 - key value
        sta LR_KeyOld
        lda #$40                                    // reset: $40=no key pressed
        sta LRZ_MatrixLastKey                       // c64 - key value
        lda #LR_SpeedNormal                         // wait 5 interupts before next move  (normal speed)
        sta LR_GameSpeed
        lda #LR_Joystick
        sta LR_ControllerTyp                        // controler type  $ca=joystick  $cb=keyboard
        lda #LR_GameStart 
        sta LR_GameCtrl                             // $00=start $01=demo $02=game $03=play_level $05=Edit

        jmp StartGraphicOut
}
// ------------------------------------------------------------------------------------------------------------- //
GameStartInit:{
        lda #LR_LevelDiskMin
        sta LR_LevelNoDisk                      // 000-149
        
        lda #LR_LevelNoMin
        sta LR_LevelNoGame                      // 001-150
        
        lda #LR_CheatedNo
        sta LR_Cheated                          // $01=no
        
        lda #LR_GameGame
        sta LR_GameCtrl                         // $00=start $01=demo $02=game $03=play_level $05=edit
        
        lda #LR_KeyNewNone
        sta LR_KeyNew                           // - avoid an immediate start
        sta LR_ScoreShown
}
// ------------------------------------------------------------------------------------------------------------- //
GameStart:
        lda #$00
        sta LRZ_DemoMoveTime                     // reset duration demo move for possible next demo rounds
        sta LR_ScoreLo              
        sta LR_ScoreMidLo               
        sta LR_ScoreMidHi               
        sta LR_ScoreHi              
        sta LR_CntSpeedLaps             
        sta LR_EnmyBirthCol                      // actual enemy rebirth column (increases with every main loop)
        sta LR_RNDMode                           // - random level mode
        sta LR_RNDLevel                          // - the real level counter
        sta LR_TestLevel                         // - switch off level test mode
        
        lda #LR_NumLivesInit                     // $05
        sta LR_LvlReload                         // <> LR_LevelNoDisk - force level load
        sta LR_NumLives             
        
        lda #>LR_ScrnHiReDisp                    // $20
        sta LRZ_GfxScreenOut                     // target output  $20=$2000 $40=$4000
        
        jsr MelodyInit

ClearAllScreens:
        jsr ClearHiresDisp
        jsr ClearHiresDisp.ClearHiresPrep

        jsr BaseLinesColor                      // - output the baseline first before level load
// ------------------------------------------------------------------------------------------------------------- //
LevelStart:
        ldx #LR_LevelLoad           // force level rebuild
        jsr InitLevel
        
        ldy LR_EnmyNo               // number of enemies - lr always set
        lda TabAllEnemyEnab,y
        sta SPENA                   // VIC 2 - $D015 = Sprite Enable
        
        lda #$00
        sta LR_JoyUpDo
        sta LR_JoyLeRi
        
        sta LR_PtrTuneToPlay
        sta LR_PtrNxtTunePos        // pointer: next free tune buffer byte
        
    !SaveScores:
        lda LR_ScoreLo              //loose collected level scores
        sta LR_ScoreOldLo           
        lda LR_ScoreMidLo           
        sta LR_ScoreOldMidLo        
        lda LR_ScoreMidHi           
        sta LR_ScoreOldMidHi        
        lda LR_ScoreHi              
        sta LR_ScoreOldHi           
        
        lda LR_GameCtrl                             // $00=start $01=demo $02=game $03=play_level $05=edit
        lsr
        beq MainLoopInit                            // demo must not wait
        
    !LevelStartWait:
        ldy #$07                                    // - wait color tab pointer - 7 for a complete cycle
    !WaitLrGetColor:
        lda TabWaitColor,y                          //Grab a colour 
        sta SP0COL                                  // - VIC 2 - $D027 = Color Sprite 0
        sty LR_Work                                 // - save color
        
        ldx #$00                                    // - waittime
        ldy #$06                                    // - waittime
    !WaitLoop:
        jsr ChkUserAction 
        bcs !SetLrWhite+                            // - user pressed key/fire
        dex                                         // - wait
        bne !WaitLoop-
        dey                                         // - wait
        bne !WaitLoop- 
        
        ldy LR_Work                                 // - dim player sprite
        dey                                         // - from black to white
        bpl !WaitLrGetColor-                        // - and vice versa
        bmi !LevelStartWait-                        // - restart color counter
        
    !SetLrWhite:
        lda #WHITE 
        sta SP0COL                                  // - VIC 2 - $D027 = Color Sprite 0
        
        lda LR_KeyNew                               // get pressed key
        cmp #$a4                                    // special key: "M" - mirror level
        bne MainLoopInit
        
        jsr ToggleMirror                            // toggle mirror flag - do NOT discount before start of play
        jmp LevelStart
//=====================================================================================================================//
MainLoopInit:{
        ldx #LR_ShootsNo
        stx LR_Shoots                               // $00=no $01=right $ff=left
        
        lda LR_CntSpeedLaps                         // lap counter for speed up
        clc
        adc LR_EnmyNo                               // number of enemies
        tay
        
        ldx TabOffEnmyCycles,y                      // offsets enemy move cycles tab
        lda TabEnmyCycles1,x                        // enemy move cycles tab
        sta LRZ_EnmyMovCyc1
        lda TabEnmyCycles2,x                        // enemy move cycles tab + 1
        sta LRZ_EnmyMovCyc2
        lda TabEnmyCycles3,x                        // enemy move cycles tab + 2
        sta LRZ_EnmyMovCyc3
        
        ldy LR_CntSpeedLaps                         // lap counter for speed up
        lda TabEnmyHoleTime,y                       // time in hole tab
        sta LR_EnmyHoleTime                         // enemy time in hole - values dynamically taken from TabEnmyHoleTime
        
        jsr GetTimerStart                           // get time start values
    }
// ------------------------------------------------------------------------------------------------------------- //
// Game Main Loop    
// ------------------------------------------------------------------------------------------------------------- //
MainLoop:{
        jsr MoveLodeRunner              // move the lode runner

    !ChkLRAccident:
        lda LR_Alive
        beq LrDeath                     // -> LR had an accident

    !ChkAllGold:
        lda LR_Gold2Get
        bne !ChkLrOnTop+                // some gold left

    !Victory:
        jsr VictoryTuneCopy             // prepare melody
        jsr VictoryMsg
        jsr ShowExitLadders             // display hidden ladders

    !ChkLrOnTop:
        lda LRZ_LodeRunRow              // actual row lode runner
        bne !GoCloseHoles+              // not on top of the screen

    !ChkLrOnMidImg:
        lda LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        cmp #$02                        // $02=center of screen image
        bne !GoCloseHoles+
        
    !ChkGold4Finish:
        lda LR_Gold2Get                 // - fully on top of the screen
        beq LevelComplete               // and got all the money in the level
        bmi LevelComplete               // set negative in ShowExitLadders to avoid !Victory more than once

    !GoCloseHoles:
        jsr CloseHoles

    !ChkLRTrapped:
        lda LR_Alive
        beq LrDeath                 // -> LR trapped in hole

    !GoMoveEnemies:
        jsr MoveEnemies             // move the enemies

    !ChkLRCaught:
        lda LR_Alive
        beq LrDeath                 // -> LR caught by enemies

    !ChkDemoDelay:
        lda LR_GameCtrl             // !hbu003!
        lsr
        beq MainLoop                // !hbu003! - demo max speed - next round

    !ChkDelay:
        lda LR_CountIRQs            // slow down game speed
        cmp LR_GameSpeed
        bcc !ChkDelay-

    !SetDelay:
        lda #LR_IRQsDflt            // reinit wait cycle time
        sta LR_CountIRQs

        jmp MainLoop                // next round
}
// ------------------------------------------------------------------------------------------------------------- //
//
// ------------------------------------------------------------------------------------------------------------- //
LrDeath:{
        ldx LR_TestLevel 
        bmi !ChkDemo+                //- do not discount lives in level test mode

    !DecLives:
        dec LR_NumLives              

    !ChkDemo:
        lda LR_GameCtrl             // $00=start $01=demo $02=game $03=play_level $05=edit
        lsr 
        beq !LrDeathX+              // demo

    !LrDeathGame:
        jmp LrDeathTune             // game

    !LrDeathX:
        jmp DemoDeath               
}
// ------------------------------------------------------------------------------------------------------------- //
//
// ------------------------------------------------------------------------------------------------------------- //
LevelComplete:
        ldx LR_TestLevel            
        bpl !Complete+               //- $00 - not in test mode

    !Return2Edit:
        jmp IGC_QuitLvl.IGC_QuitLvlPlay    //- no level completion handling necessary in test mode

    !Complete:
        jsr LevelTimeMsg

        lda LR_RNDMode              //  - U=play next level
        bpl !NextLevel+ 

    !RandomLevel:
        jsr RND                     //  - get a random number

        sta LR_LevelNoDisk          
        sta LR_LevelNoGame          
        inc LR_LevelNoGame          
        inc LR_RNDLevel             // - the real level counter
        jmp !FinishTunes+           
        
    !NextLevel:
        inc LR_LevelNoGame          // 001-150
        inc LR_LevelNoDisk          // 000-149

    !FinishTunes:
        lda LR_PtrNxtTunePos        // pointer: next free tune buffer byte
        cmp LR_PtrTuneToPlay
        bne !FinishTunes-
        
        jsr SetNextMelody
        
        inc LR_NumLives             // get one extra chance for each completed level
        bne !ScoreTuneI+
        dec LR_NumLives             // max $ff
        
    !ScoreTuneI:
        lda #LR_SoreValSub          // init score tune subtraction value
        sta $2f

        sei                         // not to be interrupted

    !ScoreTuneNext:
        lda #LR_SoreValStart
        sec
        sbc $2f
        sta FREHI1                  // SID - $D401 = Oscillator 1 Frequency Control (High Byte)
        
        ldy #$2c                    // wait time
    !ScoreTuneSet:
        ldx #$00                    // wait time
    !ScoreTuneWait:
        dex
        bne !ScoreTuneWait-
        dey
        bne !ScoreTuneSet-
        sty FREHI1                                      // SID - $D401 = Oscillator 1 Frequency Control (High Byte)
        lda #<LR_ScoreFinLevel                          // ac=score  10s
        ldy #>LR_ScoreFinLevel / [LR_SoreValSub + 1]    // yr=score 100s
        jsr Score2BaseLine                              // score increases whilst the
        dec $2f                                         // tune gets higher and higher
        bpl !ScoreTuneNext-
        cli                                             // reallow interrupts

    !ChkDemo:
        lda LR_GameCtrl                                 // $00=start $01=demo $02=game $03=play_level $05=edit
        lsr 
        bne !ChkGameComplete+                           // - game

    !WasDemo:
        lda #$01 
        jsr WaitAWhile                                  // - wait a bit before highscore output
        bcs !GoLvlInit+ 
        
    !DemoHighScore:
        jsr ShowHighScoreClr 

        lda #$03                                        // - high score list display time
        jsr WaitAWhile 
        bcc !GoLvlStartDemo+                            // - no user interrupt so start Demo mode

    !GoLvlInit:
        jmp GameStartInit 

    !GoLvlStartDemo:
        jsr ClearHiresDisp                              // - avoid flash on switch back to demo level
        jsr BaseLinesColor 
    !GoLvlStart:
        jmp LevelStart

    !ChkGameComplete:
        lda LR_LevelNoGame          //  - 001-150
        cmp #LR_LevelNoMax + 1          //  - 151
        bne !GoLvlStart-             //  - not reached so start next level
        
    !AddFinScore:
        lda #<LR_ScoreFinGame           //  - ac=score  10s
        ldy #>LR_ScoreFinGame           //  - yr=score 100s
        jsr Score2BaseLine 
        
        lda #$01 
        jsr WaitAWhile 
    !LevelCompleteX:
        jmp GameOver                //  - finish after last level
// ------------------------------------------------------------------------------------------------------------- //
//
//---------------------------------------------------------------------------------------------------------------//
LrDeathTune:{
        lda #LR_DeathTuneVal
        sta LR_DeathTune
        
    !WaitGameTuneX:
        lda LR_PtrNxtTunePos        // pointer: next free tune buffer byte
        cmp LR_PtrTuneToPlay
        bne !WaitGameTuneX-          // wait for all in game tunes to be finished

        lda #LR_ShootsNo
        sta LR_Shoots               // $00=no $01=right $ff=left

        lda #LR_FallsNo
        sta LR_FallsDown            // $00=fall $20=no fall $ff=init

        jsr RestoreFromMsg          //  - reset status line / display new no of lives
        
    !WaitDeathTuneX:
        lda LR_DeathTune
        bne !WaitDeathTuneX-

    !RestoreScores:
        lda LR_ScoreOldLo           // - loose collected level scores
        sta LR_ScoreLo              
        lda LR_ScoreOldMidLo        
        sta LR_ScoreMidLo           
        lda LR_ScoreOldMidHi        
        sta LR_ScoreMidHi           
        lda LR_ScoreOldHi           
        sta LR_ScoreHi              
        
        lda #$00                    // - ac=score  10s
        tay                         // - yr=score 100s
        jsr Score2BaseLine
        
    !ChkGameOver:
        lda LR_NumLives
        beq GameOver                

        jmp LevelStart              
}
// ------------------------------------------------------------------------------------------------------------- //
//
//---------------------------------------------------------------------------------------------------------------//
GameOver:{
        jsr ChkNewHighScore         // test new high score
        bcc !Flip+                   //  - none

    !ChkChamp:
        jsr ChkNewChampionXX.ChkNewChampion         // - test new scorer
        bne !WaitI+                                 // - disk write for new message - do not wait that long
        
        lda #$03                                    // - wait a bit longer to compensate disk write
        bne !Wait+                   
        
    !Flip:
        jsr FlipGmeOverSign        

    !WaitI:
        lda #$01                    // - to be able to read the sign
    !Wait:
        jsr WaitAWhile              // - before the start gfx starts
        bcs Wait4User               // - carry set - user interrupt - no start gfx

        jmp StartGraphicOut         // - wait time up - show start gfx

    !GameOverX:
        jmp GameStartInit
}
// ------------------------------------------------------------------------------------------------------------- //
// Wait4User         Function: Wait for key/fire and check for edit/score special keys
//                   : Start demo mode if wait time expires before user interaction
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
Wait4UserClr:
        lda #LR_KeyNewNone
        sta LR_KeyNew

Wait4User:
        lda #$03
        jsr WaitAWhile
        bcc !GoDemo+                 // wait time expired
        beq !GoGameStartInit+        // fire pressed
        
    !WasUserKey:
        jsr ResetIRQ                // switch back to game IRQ

    !GetUserKey:
        lda LR_KeyNew
    !ChkUserKeyEdit:
        cmp #$8e                    // special key: "E" - edit
        bne !ChkUserKeyEnter+

    !GoEdit:
        jmp BoardEditor

    !ChkUserKeyEnter:
        cmp #$01                    // special key: <enter>
        bne !GoGameStartInit+
        
        lda LR_ScoreShown           //  - avoid highscores redisplay
        bne !GoGameStartInit+
        
        dec LR_ScoreShown           //  - avoid highscores redisplay
        
    !GoHighScore:
        jmp HighScores

    !GoGameStartInit:
        jsr ResetIRQ                // switch back to game IRQ
        jmp GameStartInit

    !GoDemo:
        jsr ResetIRQ                // switch back to game IRQ
        
        ldx #LR_CheatedNo
        stx LR_Cheated   
        
        ldx #LR_GameDemo 
        stx LR_GameCtrl             // $00=start $01=demo $02=game $03=play_level $05=edit
        
        ldx #LR_LevelNoMin
        stx LR_LevelNoGame          // 001-150
        
        dex                         // $00
        stx LR_LevelNoDisk          // 000-149
        jmp GameStart
// ------------------------------------------------------------------------------------------------------------- //
// WaitAWhile        Function: Wait some time
//               Parms   : ac contains the positive number of wait cycles - Starts with 00
//               Returns : Carry set=user interrupt / Zero set=fire pressed - otherwise: ac=user-key-value
// ------------------------------------------------------------------------------------------------------------- //
WaitAWhile:{
        sta $50
    !WaitI:
        ldy #$00
        ldx #$00

    !ChkFire:
        lda CIAPRA                      // CIA 1 - $DC00 = Data Port A
        and #$10                        // !!!#oooo - bit4=fire  bit3=right  bit2=left  bit1=down  bit0=up
        beq !WaitUser+                  // fire button pressed - zero flag set

    !ChkKey:
        lda LR_KeyNew
        bne !WaitUser+                  // key pressed - zero flag not set

    !Wait1:
        dey
        bne !ChkFire-
    !Wait2:
        dex
        bne !ChkFire-
    !Wait3:
        dec $50
        bne !ChkFire-
        
    !WaitNoUser:
        clc                             // wait time expired - z always set
        rts

    !WaitUser:
        sec                             // user interrupt - z_set=fire pressed  z_not_set=key pressed
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// DemoDeath         Function: Full Sound/End all tunes/Play death tune in demo levels
//                     Some code removed at the end of Wait4User
//               Parms   :
//               Returns :
//               Label   : 
// ------------------------------------------------------------------------------------------------------------- //
DemoDeath:{
        lda LR_PtrNxtTunePos
        cmp LR_PtrTuneToPlay
        bne DemoDeath               //  - end all in game tunes

    !InitDeath:
        lda #LR_DeathTuneVal
        sta LR_DeathTune
    !WaitDeath:
        lda LR_DeathTune
        bne !WaitDeath-              // wait for end of death tune
        
        lda LR_NumLives
        bne !WaitLevel+              //  - demo user interrupt in ContinueDemo
        
        jmp GameStartInit           //  - demo lives are zero then

    !WaitLevel:
        lda #$02                //  - level display time
        jsr WaitAWhile
    !DemoDeathX:
        jmp StartGraphicOut         //  - demo normal end
}
// ------------------------------------------------------------------------------------------------------------- //
HighScores:{
        jsr ClearHiresDisp          //  - clear first to avoid flicker on switch back to MC

    !GoHighScores:
        jsr ShowHighScore

        lda #LR_GameGame
        sta LR_GameCtrl             // $00=start $01=demo $02=game $03=play_level $05=edit

        lda #$01
        sta LR_ScoreShown           // set flag: scores already displayed

        jmp Wait4UserClr            // avoid loop
}
// ------------------------------------------------------------------------------------------------------------- //
// GetTimerStart     Function: 
//               Parms   :
//               Returns :
//               ID      : 
// ------------------------------------------------------------------------------------------------------------- //
GetTimerStart:{
        sei

        lda #$00		                // init
        sta TO2HRS
        sta TO2MIN
        sta TO2SEC
        sta TO2TEN

        cli
GetTimerStartX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// GetTimerEnd       Function: 
//               Parms   :
//               Returns :
//               ID      : 
// ------------------------------------------------------------------------------------------------------------- //
GetTimerStop:{
        sei

    !GetElapsedHours:
        lda TO2HRS
        jsr SplitScoreDigit
        
        lda LR_Digit1
        clc
        adc #NoDigitsMin
        sta LevelTimeMsg.TabMsgStdHrs1
        
    !GetElapsedMins:
        lda TO2MIN
        jsr SplitScoreDigit
        
        lda LR_Digit10
        clc
        adc #NoDigitsMin
        sta LevelTimeMsg.TabMsgStdMin10
        lda LR_Digit1
        clc
        adc #NoDigitsMin
        sta LevelTimeMsg.TabMsgStdMin1
        
    !GetElapsedSecs:
        lda TO2SEC
        jsr SplitScoreDigit
        
        lda LR_Digit10
        clc
        adc #NoDigitsMin
        sta LevelTimeMsg.TabMsgStdSec10
        lda LR_Digit1
        clc
        adc #NoDigitsMin
        sta LevelTimeMsg.TabMsgStdSec1
        
    !GetElapsed10th:
        lda TO2TEN
        jsr SplitScoreDigit

        lda LR_Digit10
        clc
        adc #NoDigitsMin
        sta LevelTimeMsg.TabMsgStdTen10
        lda LR_Digit1
        clc
        adc #NoDigitsMin
        sta LevelTimeMsg.TabMsgStdTen1

        cli

    !GetTimerStopX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// VictoryMsg        Function: Print a yellow or white victory message
//               Parms   :
//               Returns :
//               ID      : 
// ------------------------------------------------------------------------------------------------------------- //
VictoryMsg:{
        jsr ColorLevelDyn           // set level/msg colors
        
        ldy #LR_LevelMsgIDLen           // message id length
    !ChkMsgId:
        lda LR_LevelMsgID,y         // compare with message identifier
        cmp TabMsgID,y
        bne !ChkEdit+                // no valid message identifier found

        dey
        bpl !ChkMsgId-
        bmi !CpyGameMsgI+            // valid message id found
        
    !ChkEdit:
        lda LR_GameCtrl             // clear msg area in edit mode only
        cmp #LR_GameEdit
        bne !Exit+      

    !ClrGameMsgI:
        ldy #LR_LevelMsgLen         // message length
    !ClrGameMsg:
        lda #$a0                // <blank>
        sta VictorBuffer,y        // clear message buffer
        sta CR_InputBuf,y           // clear input   buffer
        dey
        bpl !ClrGameMsg-  
        bmi !ClearBaseMsg+
        
    !Exit:
        rts                     // in game mode keep msg area unchanged if no msg exists

    !CpyGameMsgI:
        lda #$00
        sta LRZ_Work                // init blank msg indicator
        ldy #LR_LevelMsgLen         // message length
    !CpyGameMsg:
        lda LR_LevelMsg,y           // the message
        sta VictorBuffer,y        // copy msg characters
        sta CR_InputBuf,y           // prepare the input buffer for a possible edit
        eor #$a0                // <blank>
        ora LRZ_Work
        sta LRZ_Work                // save text bit pattern
        dey                
        bpl !CpyGameMsg-   
        
    !ChkBlankMsg:
        lda LRZ_Work       
        bne !ClearBaseMsg+ 

    !ChkBlankEdit:
        lda LR_GameCtrl             // display a blank message only in edit mode
        cmp #LR_GameEdit 
        bne !Exit-       

    !ClearBaseMsg:
        jsr ClearMsg                // message area to black
                
    !SetOutput:
        lda #>LR_ScrnHiReDisp           // $20
        sta LRZ_GfxScreenOut        // output to display screen only

    !CurPosSave:
        jsr LvlEdCurPosSave         // !hbu023! - save actual cursr pos

    !SetDisplay:
        jsr LvlEdCurSetMsg          // prepare display
        jsr TextOut                 // <victory message>
VictorBuffer:
        .byte $a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0
        .byte $a0,$a0,$a0,$a0,$a0,$a0,$a0,$00

    !ChkEditMode:
        lda LR_GameCtrl   
        cmp #LR_GameEdit  
        bne !VictoryMsgX+

    !CurPosLoad:
        jsr LvlEdCurPosLoad         // !hbu023! - restore old cursor position

    !ColorMessage:
        lda #HR_YellowYellow        // 
        sta ColorMsg.Mod_ColorMsg            // only yellow messages in edit mode 

    !VictoryMsgX:
        jmp ColorMsg                //
}
// ------------------------------------------------------------------------------------------------------------- //
LevelTimeMsg:{
        jsr GetTimerStop            //- get elapsed time as game standard message

    !ChkDemoMode:
        lda LR_GameCtrl
        lsr
        bne !ChkVictoryMsg+

    !Exit:
        rts                     // - no end times in demo mode

    !ChkVictoryMsg:
        lda LR_ScrnMCMsg - 1        // - status line fix part colour
        cmp LR_ScrnMCMsg            // - status line msg part colour
        bne !SetCursor+             // - a victory msg was already displayed
        
    !ClearBaseMsg:
        jsr ClearMsg
        jsr ColorLevelDyn           // set level/msg colors

    !SetCursor:
        jsr LvlEdCurSetMsg          // prepare display

        jsr TextOut                 // <time>

    TabMsgStd:
         .byte $d4 // T
         .byte $c9 // I
         .byte $cd // M
         .byte $c5 // E
         .byte $be // >

    TabMsgStdHrs1:
         .byte $a0 // h
         .byte $ba // :
    TabMsgStdMin10:
         .byte $a0 // m 
    TabMsgStdMin1:
         .byte $a0 // m
         .byte $ba // :
    TabMsgStdSec10:
         .byte $a0 // s
    TabMsgStdSec1:
         .byte $a0 // s
         .byte $ae // !
    TabMsgStdTen10:
         .byte $a0 // t
    TabMsgStdTen1:
         .byte $a0 // t
         .byte $00 // EndOfText
    !LevelTimeMsgX:
        jmp ColorMsg 
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
StartGraphicOut:{                   //Set background to display title screen
        jsr ClearHiresDisp

    Title:
        jsr SetIRQ                  // title IRQ

        ldy #$4f
    !ColourRegions:
        lda #HR_LtBlueBlack
        sta LR_ScrnMultColor + $0000, y    // "Broderbund Software"
        sta LR_ScrnMultColor + $0050, y
        sta LR_ScrnMultColor + $00a0, y
        sta LR_ScrnMultColor + $00c8, y    // "Presents"
        sta LR_ScrnMultColor + $02f8, y    // "Dough Smith, !!!"

        lda #HR_WhiteBlack
        sta LR_ScrnMultColor + $0118, y    // "Hansmanns"
        sta LR_ScrnMultColor + $0168, y
        sta LR_ScrnMultColor + $01b8, y    // "Lode Runner"
        sta LR_ScrnMultColor + $0208, y
        sta LR_ScrnMultColor + $0250, y

        lda #HR_OrangeBlack
        sta LR_ScrnMultColor + $02a8, y    // "By"

        lda #HR_LtGreyBlack
        sta LR_ScrnMultColor + $0348, y    // "(C) 1983, !!!"

        dey
        bpl !ColourRegions-

    !CopyDataI:
        lda #<LR_StartGfx
        sta $0f
        lda #>LR_StartGfx
        sta $10                 // ($0f/$10) -> graphic data start  address

        lda #<[LR_ScrnHiReDisp-1]
        sta $0d
        lda #>[LR_ScrnHiReDisp-1]
        sta $0e                 // ($0d/$0e) -> graphic data target address

    !GetData:
        ldy #$00
        lda ($0f),y
        sta LRZ_Work                // first  byte is counter
        iny
        lda ($0f),y
        sta $1f                 // second byte is data
        
        lda $0f
        clc
        adc #$02                // set pointer to next pair of data
        sta $0f
        bcc !SetCounter+              

        inc $10
        
    !SetCounter:
        lda LRZ_Work                // counter
        tay
        lda $1f                 // data
    !CopyData:
        sta ($0d),y
        dey
        bne !CopyData-

        lda $0d                 // set next target pos
        clc
        adc LRZ_Work                // counter
        sta $0d
        bcc !ChkEnd+
        inc $0e
        
    !ChkEnd:
        lda $0e
        cmp #$3f
        bcc !GetData-
        
    !ChkChamp:
        jsr OutNewChampion          // 
        bcs !GoExit+                 //  - victory message displayed

    !ChkScores:
        lda LR_HiScoreNam1 + 0          // !hbu018!
        bne !ColorNameI+             // !hbu018!

    !GoExit:
        jmp StartGraphicOutX        // !hbu018! - no high score data yet

    !ColorNameI:
        tax                     // !hbu018! - save first chr
        ldy #$27                // !hbu018! - amount
        lda #LR_ColorTopScore           // !hbu018! - color scores
    !ColorScores:
        sta LR_ScrnMCTitle,y        // !hbu018!
        dey                     // !hbu018!
        bpl !ColorScores-            // !hbu018!
        
        ldy #$0c                // !hbu018! - amount
        lda #LR_ColorTopName        // !hbu018! - color name
    !ColorName:
        sta LR_ScrnMCTitle,y        // !hbu018!
        dey                     // !hbu018!
        bpl !ColorName-              // !hbu018!
        txa                     // !hbu018! - restore first chr
    !Fill:
        sta InfoNam        + $00
        lda LR_HiScoreNam1 + $01
        sta InfoNam        + $01
        lda LR_HiScoreNam1 + $02
        sta InfoNam        + $02
        lda LR_HiScoreNam2 + $00
        sta InfoNam        + $03
        lda LR_HiScoreNam2 + $01
        sta InfoNam        + $04
        lda LR_HiScoreNam2 + $02
        sta InfoNam        + $05
        lda LR_HiScoreNam2 + $03
        sta InfoNam        + $06
        lda LR_HiScoreNam2 + $04
        sta InfoNam        + $07
        
    !Scores:
        lda LR_HiScoreHi                // - score byte
        jsr SplitScoreDigit 
        lda LR_Digit1                   // - use only right nybble discard left nybble
        clc 
        adc #NoDigitsMin                //  map to digit image data numbers
        sta InfoScore    + $00
        lda LR_HiScoreMidHi             // -  score byte
        jsr SplitScoreDigit
        lda LR_Digit10     
        clc 
        adc #NoDigitsMin                // - map to digit image data numbers
        sta InfoScore    + $01
        lda LR_Digit1         
        clc 
        adc #NoDigitsMin                // - map to digit image data numbers
        sta InfoScore    + $02 

        lda LR_HiScoreMidLo             //- score byte
        jsr SplitScoreDigit
        lda LR_Digit10     
        clc 
        adc #NoDigitsMin                // - map to digit image data numbers
        sta InfoScore    + $03  
        lda LR_Digit1   
        clc 
        adc #NoDigitsMin                // - map to digit image data numbers
        sta InfoScore    + $04  
        lda LR_HiScoreLo                // - score byte
        jsr SplitScoreDigit
        lda LR_Digit10     
        clc
        adc #NoDigitsMin                // - map to digit image data numbers
        sta InfoScore    + $05
        lda LR_Digit1
        clc
        adc #NoDigitsMin                // - map to digit image data numbers
        sta InfoScore    + $06
    !Level:
        lda LR_HiScoreLevel             //- level byte
        jsr ConvertHex2Dec
        lda LR_Digit100   
        clc
        adc #NoDigitsMin                // - map to digit image data numbers
        sta InfoLevel    + $00
        lda LR_Digit10
        clc
        adc #NoDigitsMin                // - map to digit image data numbers
        sta InfoLevel    + $01
        lda LR_Digit1
        clc
        adc #NoDigitsMin                //- map to digit image data numbers
        sta InfoLevel    + $02
        
    !InfoLine:
        jsr LvlEdCurSetHero
        jsr TextOut                     // <hero>

InfoNam:
        .byte $c8 // H       
        .byte $c1 // A       
        .byte $ce // N       
        .byte $d3 // S       
        .byte $cd // M       
        .byte $c1 // A       
        .byte $ce // N       
        .byte $ce // N       
        .byte $a0 // <blank> 
        .byte $d3 // S       
        .byte $c3 // C       
        .byte $cf // O       
        .byte $d2 // R       
        .byte $c5 // E       

InfoScore:
        .byte $3c // 0       
        .byte $3c // 0       
        .byte $3c // 0       
        .byte $3c // 0       
        .byte $3c // 0       
        .byte $3c // 0       
        .byte $3c // 0       
        .byte $a0 // <blank> 
        .byte $cc // L       
        .byte $d6 // V       
        .byte $cc // L       

InfoLevel:
        .byte $3c // 0       
        .byte $3c // 0       
        .byte $3d // 0       
        .byte $00 // EndOfText

StartGraphicOutX:
        jmp Wait4UserClr
}
// ------------------------------------------------------------------------------------------------------------- //
// SetIRQ        Function: Set title display IRQ to combine the 2 diiferent GFX modes
//               Parms   :
//               Returns :
//               ID      : !hbu018!
// ------------------------------------------------------------------------------------------------------------- //
SetIRQ:{
        lda #HR_BlackBlack
        tax               
        ldy #WHITE        
        jsr ColorLevelFix 

    !HiresOn:
        lda SCROLY                  // VIC 2 - $D011 = VIC Control Register 1
        and #$7f                    // clear bit7: no bit8 (high bit) of raster compare register at RASTER
        ora #$20
        sta SCROLY                  // VIC 2 - $D011 = VIC Control Register 1

    !MultiColorOff:
        lda SCROLX                  // VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)
        and #$ef 
        sta SCROLX                  // VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)

    !ChrGen:
        lda VMCSB                   // VIC 2 - $D018 = Chip Memory Control
        and #$f0                    // chr generator to video base + 2000-3fff
        ora #$08
        sta VMCSB                   // VIC 2 - $D018 = Chip Memory Control
    
    !SetRasterIRQ:
        sei 

    !TitleIRQ:
        lda #<IRQTitle              // set Title IRQ routine
        sta C64_PtrIRQ              // 
        lda #>IRQTitle              // 
        sta C64_PtrIRQ + $01        // 

        lda #LR_IRQTitleTop         // 1st raster line for interrupt
        sta RASTER                  // VIC 2 - $D012 = Write: Line to Compare for Raster IRQ 
        
    !SetIRQ:
        lda #$01                // allow raster IRQs
        sta IRQMASK                 // VIC 2 - $D01A = IRQ Mask Register

    !ResetPending:
        lda CIAICR                  // CIA 1 - $DC0D = Interrupt Control Register - cleared on read
        lda CI2ICR                  // CIA 2 - $DD0D = Interrupt Control Register - cleared on read

        lda VICIRQ                  // VIC 2 - $D019 = Interrupt Flag Register - Latched flags cleared if set to 1
        sta VICIRQ                  // VIC 2 - $D019 = Interrupt Flag Register - Latched flags cleared if set to 1

        cli                     // 

SetIRQX:
        rts                     //
}
// ------------------------------------------------------------------------------------------------------------- //
// ResetIRQ          Function: Switch back to game IRQ
//               Parms   :
//               Returns :
//               ID      : !hbu018!
// ------------------------------------------------------------------------------------------------------------- //
ResetIRQ:{
        lda #HR_BlackBlack
        tax               
        ldy #BLACK        
        jsr ColorLevelFix 

    !ResetRasterIRQ:
        sei

    !GameIRQ:
        lda #<IRQ                   // set Game IRQ
        sta C64_PtrIRQ
        lda #>IRQ
        sta C64_PtrIRQ + $01        // IRQ vector

    !ResetIRQ:
        lda #$00                    // disallow raster IRQs
        sta IRQMASK                 // VIC 2 - $D01A = IRQ Mask Register

    !ResetPending:
        lda CIAICR                  // CIA 1 - $DC0D = Interrupt Control Register - cleared on read
        lda CI2ICR                  // CIA 2 - $DD0D = Interrupt Control Register - cleared on read

        lda VICIRQ                  // VIC 2 - $D019 = Interrupt Flag Register - Latched flags cleared if set to 1
        sta VICIRQ                  // VIC 2 - $D019 = Interrupt Flag Register - Latched flags cleared if set to 1

    !MultiColorOn:
        lda SCROLX                  //- VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)
        ora #$10                    // set bit4: enable Multicolor Bitmap Mode
        sta SCROLX                  // - VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)

        cli

ResetIRQX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// NMI           Function: Cut off RESTORE key
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
NMI:
        rti
// ------------------------------------------------------------------------------------------------------------- //
// IRQ           Function: The 60 times a second action
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
IRQ:{
        inc LR_CountIRQs

        lda #$00
        sta LRZ_TuneVoc1            // tune value voice 1

        lda LR_Volume
        and #$0f
        sta SIGVOL                  // SID - $D418 = Volume and Filter Select
        lda LR_FallsDown            // $00=fall $20=no fall $ff=init
        bne !BeepInit+

        ldx LR_FallBeep
        stx LRZ_TuneVoc1            // tune value voice 1
        jmp !ChkShoot+

    !BeepInit:
        lda #LR_FallBeepIni         // fall beep start value
        sta LR_FallBeep

    !ChkShoot:
        lda LR_Shoots               // $00=no $01=right $ff=left
        beq !ShootInit+

        lda LR_ShootSound
        sec
        sbc #LR_ShootSoundSub
        sta LR_ShootSound
        sta LRZ_TuneVoc1            // tune value voice 1
        beq !ShootInit+

        jmp !ChkDeath+

    !ShootInit:
        lda #LR_ShootSoundIni
        sta LR_ShootSound
    
    !ChkDeath:
        lda LR_DeathTune
        beq !SetTune+

        sec
        sbc #LR_DeathTuneSub
        sta LRZ_TuneVoc1            // tune value voice 1
        sta LR_DeathTune

    !SetTune:
        lda LRZ_TuneVoc1            // tune value voice 1
        sta FREHI1                  // SID - $D401 = Oscillator 1 Frequency Control (High Byte)
        jsr IRQ_PlaySounds

    !Keyboard:
        jsr IRQ_GetKey              // handle keyboard

    !JoyStick:
        jsr IRQ_GetJoy              // !hbu024! - handle joystick

IRQ_X:
        jmp C64_IRQ                 // system
}
// ------------------------------------------------------------------------------------------------------------- //
// IRQ_GetKey        Function: Store a pressed key code
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
IRQ_GetKey:{
        lda LRZ_MatrixLastKey           // c64 - key value
        bne !ChkKey+

        lda #$07                        // DELETE substitution - CRSR_D

    !ChkKey:
        cmp #$40                        // no key pressed
        bne !ChkKeyFlag+

        lda #$00
        sta LR_KeyOld
    !Exit:
        rts

    !ChkKeyFlag:
        ldx C64_KeyFlag             // $01=shift $02=commodore $04=ctrl
        beq !ChkKeyOld+

    !SetShift:
        ora #$80                // treat all special keys as shift

    !ChkKeyOld:
        cmp LR_KeyOld
        beq !IRQ_GetKeyX+

        sta LR_KeyOld
        sta LR_KeyNew

    !IRQ_GetKeyX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// IRQ_GetJoy        Function: Store a joystick action
//               Parms   : 
//               Returns : 
//               ID      : !hbu023!
// ------------------------------------------------------------------------------------------------------------- //
IRQ_GetJoy:{
        dec LR_JoyWait

    !GetJoy:
        lda CIAPRA                      // CIA 1 - $DC00 = Data Port A
        and #$1f                        // isolate actions
        eor #$1f                        // flip bits
        bne !ChkJoyOld+                 // an action detected

        sta LR_JoyOld                   // reset 
    !Exit:
        rts              

    !ChkJoyOld:
        cmp LR_JoyOld    
        beq !IRQ_GetJoyX+

        sta LR_JoyOld    
        sta LR_JoyNew    

    !IRQ_GetJoyX:
        rts              
}
// ------------------------------------------------------------------------------------------------------------- //
// IRQTitle          Function: Display the top scorer on title screen in a different GFX mode
//               Parms   :
//               Returns :
//               ID      : !hbu018!
// ------------------------------------------------------------------------------------------------------------- //
IRQTitle:{
        lda VICIRQ                  // VIC 2 - $D019 = Interrupt Flag Register
        sta VICIRQ                  // clear interrupt flags 
        bmi !Raster+                // Bit 7: Flag: At least one VIC IRQ's has happened

        lda CIAICR                  // CIA 1 - $DC0D - Interrupt Control Register - cleared on read
        cli                         // still allow VIC IRQs
        jmp C64_IRQ                 // handle timer IRQs

    !Raster:
        lda RASTER                  // VIC 2 - $D012 = Read: Current Raster Scan Line (Bits 7�0, Bit 8 in SCROLY = $D011)
        cmp #LR_IRQTitleBot         // 2nd border
        bcs !MultiColorOff+         // higher/equal

    !MultiColorOn:
        lda SCROLX                  //  - VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)
        ora #$10                    // set bit4: enable Multicolor Bitmap Mode
        sta SCROLX                  //  - VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)

        lda #LR_IRQTitleBot         // set 2nd raster line for interrupt
        jmp !SetNext+ 

    !MultiColorOff:
        lda SCROLX                  // VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)
        and #$ef                    // clear bit4: disable Multicolor Bitmap Mode
        sta SCROLX                  // VIC 2 - $D016 = Control Register 2 (and Horizontal Fine Scrolling)

    !HiresOn:
        lda SCROLY                  // VIC 2 - $D011 = VIC Control Register 1
        ora #$20                    // set bit5: enable Hires Bitmap Mode
        sta SCROLY                  // VIC 2 - $D011 = VIC Control Register 1

        lda #LR_IRQTitleTop         // set 1st raster line for interrupt

    !SetNext:
        sta RASTER                  // VIC 2 - $D012 = Write: Write: Line to Compare for Raster IRQ

    !Keyboard:
        jsr IRQ_GetKey              // handle keyboard 

    !IRQTitleX:
        jmp C64_IRQExit 
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
IRQ_PlaySounds:{
        ldx LR_PtrTuneToPlay
        cpx LR_PtrNxtTunePos        // pointer: next free tune buffer byte
        beq IRQ_SoundsReset         // all tunes completed
        
        lda #$11                    // triangle wave/start ADS
        sta LR_WaveVoice2
        sta LR_WaveVoice3
        lda LR_TuneSuReVol,x        // tune s/r/volume  (not used)
        lda #$f0
        and LR_Volume
        sta SUREL2                  // SID - $D40D = Oscillator 2 Sustain/Release
        sta SUREL3                  // SID - $D414 = Oscillator 3 Sustain/Release
        lda LR_TuneDataPtrV2,x      // tab tune data pointer voice 2
        bne !Voice02+
        
        sta LR_WaveVoice2
    !Voice02:
        tay
        lda TabVocsFreqDatLo,y
        sta FRELO2                  // SID - $D407 = Oscillator 2 Frequency Control (Low Byte)
        lda TabVocsFreqDatHi,y
        sta FREHI2                  // SID - $D408 = Oscillator 2 Frequency Control (High Byte)
        lda LR_TuneDataPtrV3,x      // tab tune data pointer voice 3
        bpl !ChkVoice03+
        
        lda LR_TuneDataPtrV2,x      // tab tune data pointer voice 2
        tay
        sec
        lda TabVocsFreqDatLo,y
        sbc #$80
        sta FRELO3                  // SID - $D40E = Oscillator 3 Frequency Control (Low Byte)
        lda TabVocsFreqDatHi,y
        sbc #$00
        sta FREHI3                  // SID - $D40F = Oscillator 3 Frequency Control (High Byte)
        jmp !PlayTune+
        
    !ChkVoice03:
        bne !Voice03+

        sta LR_WaveVoice3
    !Voice03:
        tay
        lda TabVocsFreqDatLo,y
        sta FRELO3                  // SID - $D40E = Oscillator 3 Frequency Control (Low Byte)
        lda TabVocsFreqDatHi,y
        sta FREHI3                  // SID - $D40F = Oscillator 3 Frequency Control (High Byte)
    !PlayTune:
        lda LR_WaveVoice2
        sta VCREG2                  // SID - $D40B = Oscillator 2 Control
        lda LR_WaveVoice3
        sta VCREG3                  // SID - $D412 = Oscillator 3 Control
    !DecTime:
        dec LR_TunePlayTime,x      // tab tune times
        bne !IRQ_PlaySoundsX+      // not completed yet

        inc LR_PtrTuneToPlay       // next tune to play

    !IRQ_PlaySoundsX:
    rts
}
// ------------------------------------------------------------------------------------------------------------- //
IRQ_SoundsReset:{
        lda #$00
        sta VCREG2                  // SID - $D40B = Oscillator 2 Control
        sta VCREG3                  // SID - $D412 = Oscillator 3 Control
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// SetTune           Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
SetTune:{
        pla                             // played during IRQ
        sta LRZ_MelodyDataLo
        pla
        sta LRZ_MelodyDataHi            // ($7d/$7e) ptr melody data
        bne !SetNext+

    !CpyTune:
        sei

        ldy #$00
        lda (LRZ_MelodyData),y
        beq !PrepareXit+

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
        bne !CpyTune-

    !SetNext:
        inc LRZ_MelodyDataLo
        bne !CpyTune-
        inc LRZ_MelodyDataHi
        bne !CpyTune-

    !PrepareXit:
        lda LRZ_MelodyDataHi        // point behind melody data
        pha
        lda LRZ_MelodyDataLo
        pha

        cli

        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// RND           Function: Return a unique random disk level number
//               Parms   :
//               Returns :
//               ID      : 
// ------------------------------------------------------------------------------------------------------------- //
RNDInit:{
        lda #LR_LevelDiskMax+1
        sta LR_RNDMax

        ldy #$00
    !Fill:
        tya 
        sta LR_RandomField,y
        iny
        cpy LR_RNDMax
        bne !Fill-
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
RND:{
        lda TIMALO                  // CIA 1 - $DC04 = Timer A (low byte)
        eor TIMAHI                  // CIA 1 - $DC05 = Timer A (high byte)
        eor TI2ALO                  // CIA 2 - $DD04 = Timer A (low byte)
        adc TI2AHI                  // CIA 2 - $DD05 = Timer A (high byte)
        eor TI2BLO                  // CIA 2 - $DD06 = Timer B (low byte)
        eor TI2BHI                  // CIA 2 - $DD07 = Timer B (high byte)

        cmp LR_RNDMax               // upper limit
        bcs RND

    !SavRnd:
        tay
        lda LR_RandomField,y
        sta LR_RND                  // save random level no

    !Reduce:
        lda LR_RandomField+1,y      // Move the entire field one position up 
        sta LR_RandomField,y        // to the position found
        iny
        cpy LR_RNDMax
        bne !Reduce-

        dec LR_RNDMax               // reduce the max value
        bne !GetRnd+                 // is one more than max disk level - no underflow

        jsr RNDInit                 // refill field and max counter

    !GetRnd:
        lda LR_RND                  // restore random level no

        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// Randomizer        Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
Randomizer:{
        sta LR_RandomAc             // save accumulator
    !GetBeam:
        lda RASTER                  // VIC 2 - $D012 = Read: Raster Scan Line/ Write: Line for Raster IRQ
        sta LR_RasterBeamPos
        cpx LR_RasterBeamPos
        bcc !ChkBeam+
        beq !ChkBeam+
        jmp !GetBeam-
        
    !ChkBeam:
        cpy LR_RasterBeamPos
        bcc !GetBeam-

        sec
        sbc LR_Random
        bcs !ChkAc+

        eor #$ff
        adc #$01
    !ChkAc:
        cmp LR_RandomAc
        bcc !GetBeam-

        lda LR_RasterBeamPos
        sta LR_Random
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// MelodyInit        Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MelodyInit:{
        lda MelodyMaxNo
        sta LR_MelodyNo
        lda MelodyMinHight
        sta LR_MelodyHeight
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// SetNextMelody     Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
SetNextMelody:{
        dec LR_MelodyNo
        bpl SetNextMelodyX
        
        inc LR_MelodyHeight
        lda LR_MelodyHeight
        cmp MelodyMaxHight
        bcc !GetMax+
        
        lda MelodyMinHight
        sta LR_MelodyHeight
    !GetMax:
        lda MelodyMaxNo
        sta LR_MelodyNo
        
SetNextMelodyX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// VictoryTuneCopy   Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
VictoryTuneCopy:{
        lda LR_MelodyNo
        asl
        tax
        lda TabMelodyPtr,x
        sta LRZ_MelodyDataLo
        lda TabMelodyPtr+1,x
        sta LRZ_MelodyDataHi        // ($7d/$7e) -> melody data
        
    !CpyTune:
        sei

        ldy #$00
        lda (LRZ_MelodyData),y
        beq !PrepXit+

        ldx LR_PtrNxtTunePos        // pointer: next free tune buffer byte
        sta LR_TunePlayTime,x           // tab tune times
        iny
        lda (LRZ_MelodyData),y
        beq !Voice01+

        clc
        adc LR_MelodyHeight
    !Voice01:
        sta LR_TuneDataPtrV2,x          // tab tune data pointer voice 2
        iny
        lda (LRZ_MelodyData),y
        beq !Voice02+
        bmi !Voice02+

        clc
        adc LR_MelodyHeight
    !Voice02:
        sta LR_TuneDataPtrV3,x          // tab tune data pointer voice 3
        iny
        lda (LRZ_MelodyData),y
        sta LR_TuneSuReVol,x        // tune s/r/volume  (not used)
        inc LR_PtrNxtTunePos        // pointer: next free tune buffer byte
        lda LRZ_MelodyDataLo
        clc
        adc #$04
        sta LRZ_MelodyDataLo
        lda LRZ_MelodyDataHi
        adc #$00
        sta LRZ_MelodyDataHi
        bne !CpyTune-
        
    !PrepXit:
        cli
    !VictoryTuneCopyX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// GameInitOnce      Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
GameInitOnce:{
        lda $01
        and #$fe                // basic off
        sta $01

        lda #$00
        sta LRZ_Work
        sta $1f

    !CreateGfxPtrTab:
        ldy #$00
        lda #$19                // 25
        sta LR_Counter
    !GetAmount:
        ldx #$08
    !GetValue:
        lda $1f
        sta LR_TabOffHiresHi,y          // offset grafic output high
        lda LRZ_Work
        sta LR_TabOffHiresLo,y          // offset grafic output low
        inc LRZ_Work
        iny
        dex
        bne !GetValue-

        clc
        adc #$39
        sta LRZ_Work
        lda $1f
        adc #$01
        sta $1f

        dec LR_Counter
        bne !GetAmount-

    !CreateImageAdrTab:
        lda #<DatImages             // - set start address
        sta $1e        
        lda #>DatImages
        sta $1f        

        ldx #$00                // - counter
    !GetImageAdrLo:
        lda $1f
        sta LR_ImageAdrHi,x         //- image address table high byte
    !GetImageAdrHi:
        lda $1e
        sta LR_ImageAdrLo,x         //- image address table low  byte

        clc                     // !hbu026!
        adc #[$0b * $03]        //$21 image bytes
        sta $1e                
        bcc !SetNextTabPos+    
        inc $1f                

    !SetNextTabPos:
        inx                     // !hbu026!
        bne !GetImageAdrLo-         // !hbu026! - fill in $ff image addresses

    !SetNMI:
        lda #<NMI
        sta C64_PtrNMI
        lda #>NMI
        sta C64_PtrNMI + 1          // point NMI vector to rti

        jsr ClearHiresDisp

        lda #BLACK
        sta BGCOL0                  // VIC 2 - $D021 = BackGround Color 0
        sta EXTCOL                  // VIC 2 - $D020 = Border Color

        lda #$b0
        sta SUREL1                  // SID - $D406 = Oscillator 1 Sustain/Release
        lda #$11
        sta VCREG1                  // SID - $D404 = Oscillator 1 Control

        ldx #$30                    // $30*$40=$0c00
        stx LR_SpritePtr00          // sprite 0 data at $0c00
        inx
        stx LR_SpritePtr02          // sprite 2 data at $0c40
        inx
        stx LR_SpritePtr03          // sprite 3 data at $0c80
        inx
        stx LR_SpritePtr04          // sprite 4 data at $0cc0
        inx
        stx LR_SpritePtr06          // sprite 6 data at $0d00
        inx
        stx LR_SpritePtr07          // sprite 7 data at $0d40

        lda #$00
        sta SPBGPR                  // VIC 2 - $D01B = Sprite to Foreground Priority
        tay
    !Clear:
        sta $02,y                   // zero page
        sta LR_SpriteStore01,y      // sprite data store $0c00
        sta LR_SpriteStore02,y      // sprite data store
        iny
        bne !Clear-

        lda #$ff
        sta SPENA                   // VIC 2 - $D015 = Sprite Enable

    !SetIRQ:
        sei

        lda #<IRQ
        sta C64_PtrIRQ
        lda #>IRQ
        sta C64_PtrIRQ + 1          // IRQ vector

        cli

        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// ColorLevel!!!     Function: Select a new colour combination every 10th level
//                     Do not select the RED/RED one again
//               Parms   : ac=color level tiles  xr=color status lines
//               Returns :
//               Label   : !hbu001!
// ------------------------------------------------------------------------------------------------------------- //
ColorLevelFix:{
        sta ColorLevel._Mod_ColorLevelF             // - front
        sty ColorLevel._Mod_ColorLevelB             // - background
        stx ColorStatus._Mod_ColorStatusF           // - status lines
        sty ColorStatus._Mod_ColorStatusB           // - status lines

        jsr ColorLevel  
        jmp ColorStatus 
}
// ------------------------------------------------------------------------------------------------------------- //
ColorLevelDyn:{
        lda LR_GameCtrl             //- $00=start $01=demo $02=game $03=play_level $05=edit
        lsr
        bne !Game+

    !Demo:
        ldx #NoSpColorDemo 
        ldy #GREY                       //- get background
        bne !SetColor+                  //- always

    !Game:
        lda LR_LevelNoGame
        cmp #151                        //- 10*15 different color sets
        bcc !GetColorPtrI+              //- still first 150 levels
        
    !Adjust:
        sbc #140                        //- do not select red/red again

    !GetColorPtrI:
        ldx #$ff  
        sec       
    !GetColorPtr:
        inx                             //- calculate pointer for table of colors
        sbc #$0a
        bcs !GetColorPtr-
        
        ldy #WHITE                      // - get background

    !SetColor:
        sty ColorLevel._Mod_ColorLevelB         // - set background
        lda TabLevelColor,x 
        sta ColorLevel._Mod_ColorLevelF
        sta ColorStatus._Mod_ColorStatusB
        lda TabStatusColor,x
        sta ColorStatus._Mod_ColorStatusF
        lda TabMsgColor,x
        sta ColorMsg.Mod_ColorMsg            //- set msgcolor

        jsr ColorSprites

        rts
}
// ------------------------------------------------------------------------------------------------------------- //
ColorLevel:{
        ldy #$00            
    !ColorLevelLoop:
        lda #HR_OrangeBlue  
.label _Mod_ColorLevelF = *-1

        sta LR_ScrnMCPage0,y        //- Multi Color RAM
        sta LR_ScrnMCPage1,y 
        sta LR_ScrnMCPage2,y 
        sta LR_ScrnMCPage3,y 

        lda #WHITE
.label _Mod_ColorLevelB = *-1 

        sta LR_ColRamPage0,y        // - Color RAM
        sta LR_ColRamPage1,y 
        sta LR_ColRamPage2,y 
        sta LR_ColRamPage3,y 
        dey                  
        bne !ColorLevelLoop-

        rts
}
// ------------------------------------------------------------------------------------------------------------- //
ColorStatus:{
        ldy #$4f
    !ColorStat:
        lda #HR_OrangeBlue
.label _Mod_ColorStatusF = *-1

        sta LR_ScrnMCStatus,y
        
        lda #WHITE           
.label _Mod_ColorStatusB  = *-1          

        sta LR_ColRamStatus,y
        dey              
        bpl !ColorStat-     

        rts
}
// ------------------------------------------------------------------------------------------------------------- //
ColorMsg:{
        ldy #$13                // - quick recolor after ClearMsg
        lda #HR_OrangeBlue
.label Mod_ColorMsg = * -1

    !ColorLoop:
        sta LR_ScrnMCMsg,y          //  - recolor message part of status row
        dey 
        bpl !ColorLoop- 

        rts
}
// ------------------------------------------------------------------------------------------------------------- //
ClearMsg:{
        ldy #$13                    //  - quick clear by setting both colors to black
        lda #HR_BlackBlack
    !ColorLoop:
        sta LR_ScrnMCMsg,y          //  - recolor message part of status row
        dey
        bpl !ColorLoop- 

        rts 
}
// ------------------------------------------------------------------------------------------------------------- //
TabLevelColor:
        .byte HR_CyanRed            // 00 - start
        .byte HR_CyanPurple         // 01
        .byte HR_CyanLtGreen        // 02
        .byte HR_CyanBlue           // 03
        .byte HR_CyanOrange         // 04
        .byte HR_CyanYellow         // 05
        .byte HR_CyanLtRed          // 06
        .byte HR_CyanGreen          // 07
        .byte HR_CyanPurple         // 08
        .byte HR_CyanLtGreen        // 09
        .byte HR_CyanBlue           // 0a
        .byte HR_CyanOrange         // 0b
        .byte HR_CyanLtBlue         // 0c
        .byte HR_CyanLtRed          // 0d
        .byte HR_CyanGreen          // 0e
        .byte HR_CyanPurple         // 0f - level 150
        .byte HR_WhiteLtGrey        // 10 - demo 

TabStatusColor:
        .byte HR_CyanRed            // 00  - start
        .byte HR_CyanLtBlue         // 01 
        .byte HR_CyanLtRed          // 02 
        .byte HR_CyanPurple         // 03 
        .byte HR_CyanLtRed          // 04 
        .byte HR_CyanLtGreen        // 05 
        .byte HR_CyanPurple         // 06 
        .byte HR_CyanOrange         // 07 
        .byte HR_CyanLtBlue         // 08 
        .byte HR_CyanLtRed          // 09 
        .byte HR_CyanPurple         // 0a 
        .byte HR_CyanLtRed          // 0b 
        .byte HR_CyanLtGreen        // 0c 
        .byte HR_CyanPurple         // 0d 
        .byte HR_CyanYellow         // 0e 
        .byte HR_CyanLtBlue         // 0f  - level 150
        .byte HR_GreyDkGrey         // 10  - demo

TabMsgColor:
        .byte HR_YellowYellow       // 00  - start
        .byte HR_LtRedLtRed         // 01 
        .byte HR_LtBlueLtBlue       // 02 
        .byte HR_LtGreenLtGreen     // 03 
        .byte HR_YellowYellow       // 04 
        .byte HR_LtRedLtRed         // 05 
        .byte HR_LtGreenLtGreen     // 06 
        .byte HR_LtRedLtRed         // 07 
        .byte HR_YellowYellow       // 08 
        .byte HR_LtBlueLtBlue       // 09 
        .byte HR_LtGreenLtGreen     // 0a 
        .byte HR_LtBlueLtBlue       // 0b 
        .byte HR_LtRedLtRed         // 0c 
        .byte HR_YellowYellow       // 0d 
        .byte HR_LtBlueLtBlue       // 0e 
        .byte HR_LtGreenLtGreen     // 0f  - level 150
        .byte HR_WhiteWhite         // 10  - demo
// ------------------------------------------------------------------------------------------------------------- //
// ColorSprites      Function: Set/Reset sprite colors
//               Parms   : carry - set=old colors  clear=new colors
//               Returns :
//               Label   : !hbu004!
// ------------------------------------------------------------------------------------------------------------- //
ColorSprites:{
        txa                     //
        asl                     // - *2
        asl                     // - *4
        asl                     // - *8
        sta LR_ColorSetEnemy    // - save for enemy rebirth
        clc
        adc #$07                // - set to end of set - will be decremented
        tax 

        ldy #$07
    GetNewColors:
        lda TabSpColorSets,x
    SetNewColors:
        sta SP0COL,y            // - recolor all sprites
        dex                     // - set new color
        dey
        bpl GetNewColors

        rts
}
// ------------------------------------------------------------------------------------------------------------- //
.label TabSpColorSets   = *
// 01, 00, 03, 03, 03, 00
TabSpColorStart:
        .byte WHITE  ,BLACK  ,CYAN     ,CYAN     ,CYAN      ,BLACK  ,CYAN     ,CYAN    
TabSpColorSet010:
        .byte WHITE  ,BLACK  ,YELLOW   ,LT_GREEN ,LT_RED    ,BLACK  ,LT_GREY  ,CYAN    
TabSpColorSet020:
        .byte WHITE  ,BLACK  ,LT_RED   ,LT_BLUE  ,PURPLE    ,BLACK  ,YELLOW   ,LT_GREY 
TabSpColorSet030:
        .byte WHITE  ,BLACK  ,LT_GREEN ,LT_RED   ,YELLOW    ,BLACK  ,CYAN     ,LT_GREY 
TabSpColorSet040:
        .byte WHITE  ,BLACK  ,YELLOW   ,PURPLE   ,LT_BLUE   ,BLACK  ,LT_GREEN ,LT_GREY 
TabSpColorSet050:
        .byte WHITE  ,BLACK  ,LT_RED   ,LT_BLUE  ,PURPLE    ,BLACK  ,LT_GREY  ,CYAN    
TabSpColorSet060:
        .byte WHITE  ,BLACK  ,LT_BLUE  ,YELLOW   ,LT_GREEN  ,BLACK  ,CYAN     ,LT_GREY 
TabSpColorSet070:
        .byte WHITE  ,BLACK  ,YELLOW   ,LT_RED   ,LT_BLUE   ,BLACK  ,PURPLE   ,LT_GREY 
TabSpColorSet080:
        .byte WHITE  ,BLACK  ,CYAN     ,YELLOW   ,LT_GREEN  ,BLACK  ,LT_RED   ,LT_BLUE 
TabSpColorSet090:
        .byte WHITE  ,BLACK  ,LT_BLUE  ,PURPLE   ,YELLOW    ,BLACK  ,CYAN     ,LT_RED  
TabSpColorSet100:
        .byte WHITE  ,BLACK  ,YELLOW   ,LT_GREEN ,LT_RED    ,BLACK  ,LT_GREY  ,CYAN    
TabSpColorSet110:
        .byte WHITE  ,BLACK  ,LT_GREEN ,CYAN     ,LT_BLUE   ,BLACK  ,PURPLE   ,YELLOW  
TabSpColorSet120:
        .byte WHITE  ,BLACK  ,YELLOW   ,PURPLE   ,LT_RED    ,BLACK  ,LT_GREY  ,CYAN    
TabSpColorSet130:
        .byte WHITE  ,BLACK  ,LT_GREY  ,LT_BLUE  ,CYAN      ,BLACK  ,YELLOW   ,LT_GREEN
TabSpColorSet140:
        .byte WHITE  ,BLACK  ,PURPLE   ,LT_RED   ,LT_BLUE   ,BLACK  ,CYAN     ,LT_GREY 
TabSpColorSet150:
        .byte WHITE  ,BLACK  ,LT_GREEN ,LT_RED   ,CYAN      ,BLACK  ,YELLOW   ,LT_GREY 

TabSpColorDemo:
        .byte WHITE  ,BLACK  ,YELLOW   ,LT_GREEN ,LT_RED    ,BLACK  ,LT_BLUE  ,PURPLE  
// ------------------------------------------------------------------------------------------------------------- //
.label NoSpColorDemo  =  [TabSpColorDemo - TabSpColorSets] / [TabSpColorSet020 - TabSpColorSet010]
// ------------------------------------------------------------------------------------------------------------- //
// CommandTables     Function: In game command tables
//               Parms   : 
//               Returns : The routines start addresses will be put on the stack and called with RTS afterwards
// ------------------------------------------------------------------------------------------------------------- //
TabInGameCmdChr:
        .byte $9e // U                  - Try Next Level
        .byte $a9 // P                  - Try Previous Level
        .byte $be // Q - Quit           - Quit level test and return to editor
        .byte $95 // F                  - Inc Number of Lives
        .byte $3f // <run/stop>         - Pause game
        .byte $91 // R                  - Resign
        .byte $8a // A                  - Restart Level
        .byte $a2 // J                  - Set Joystick Control
        .byte $a5 // K                  - Set Keyboard Control
        .byte $a4 // M                  - Load Level Mirrored
        .byte $aa // L                  - Load Game
        .byte $8d // S                  - Save Game
        .byte $97 // X                  - Transmit level to a slot of drive 9
        .byte $9a // G                  - Set all Gold collected in expert mode
        .byte $8c // Z                  - Random (Zufall) level mode
        .byte $92 // D                  - Toggle Shoot Mode
        .byte $28 // +                  - Inc Game Speed
        .byte $a8 // + plus <commodore> - Inc Game Speed + <commodore> key
        .byte $2b // -                  - Dec Game Speed
        .byte $ab // - plus <commodore> - Dec Game Speed + <commodore> key
        .byte $00 // <end_of_tab>

TabInGameCmdSub:
        .word IGC_NextLvl     - 1 // U          - Try Next Level
        .word IGC_PrevLvl     - 1 // P          - Try Previous Level
        .word IGC_QuitLvl     - 1 // Q          - Quit level test and return to editor 
        .word IGC_IncNumLife  - 1 // F          - Inc Number of Lives
        .word IGC_Pause       - 1 // <run/stop> - Pause game
        .word IGC_Resign      - 1 // R          - Resign
        .word IGC_Suicide     - 1 // A          - Restart Level
        .word IGC_SetJoy      - 1 // J          - Set Joystick Control
        .word IGC_SetKey      - 1 // K          - Set Keyboard Control
        .word IGC_SetMirror   - 1 // M          - Load Level Mirrored
        .word IGC_SetLoad     - 1 // L          - Load Game
        .word IGC_SetSave     - 1 // S          - Save Game
        .word IGC_Xmit        - 1 // X          - Transmit level to a slot of drive 9
        .word IGC_Success     - 1 // G          - Set all Gold collected in expert mode
        .word IGC_Random      - 1 // Z          - Random (Zufall) level mode
        .word IGC_ShootMode   - 1 // D          - Toggle Shoot Mode
        .word IGC_IncSpeed    - 1 // +          - Inc Game Speed
        .word IGC_IncSpeed    - 1 // +          - Inc Game Speed + <commodore> key
        .word IGC_DecSpeed    - 1 // -          - Dec Game Speed
        .word IGC_DecSpeed    - 1 // -          - Dec Game Speed + <commodore> key
// ------------------------------------------------------------------------------------------------------------- //
TabBoardEdCmdChr:
        .byte $29 // p - Play  level
        .byte $14 // c - Clear level
        .byte $0e // e - Edit  level
        .byte $24 // m - Move  level
        .byte $17 // x - Swap  level
        .byte $21 // i - Initialize disk
        .byte $0d // s - Show  high scores
        .byte $8d // S - Clear high scores
        .byte $00 // EndOfCmds

TabBoardEdCmdSub:
        .word BED_PlayLevel   - 1
        .word BED_ClearLevel  - 1
        .word BED_Edit        - 1
        .word BED_MoveLevel   - 1
        .word BED_SwapLevels  - 1
        .word BED_InitDisk    - 1
        .word BED_ShowScore   - 1
        .word BED_ClearScore  - 1
// ------------------------------------------------------------------------------------------------------------- //
TabLevelEdCmdChr:
        .byte $21 // i - up
        .byte $24 // m - down
        .byte $22 // j - left
        .byte $25 // k - right

        .byte $87 // <cursor up>        
        .byte $07 // <cursor down>      
        .byte $82 // <cursor left>      
        .byte $02 // <cursor right>     

        .byte $8d // S - Save 
        .byte $96 // T - Test     level 
        .byte $8a // A - Reload   level 
        .byte $95 // F - Forward  level 
        .byte $9e // U - Forward  level 
        .byte $9c // B - Backward level 
        .byte $a9 // P - Backward level 
        .byte $97 // X - Transmit level 
        .byte $a4 // M - Mirror   level 
        .byte $16 // t - edit msg text  
        .byte $be // Q - Quit 
        .byte $00 // EndOfCmdTab

TabLevelEdCmdSub:
        .word LED_CurUp     - 1
        .word LED_CurDo     - 1
        .word LED_CurLe     - 1
        .word LED_CurRi     - 1
        .word LED_CurUp     - 1 
        .word LED_CurDo     - 1 
        .word LED_CurLe     - 1 
        .word LED_CurRi     - 1 
        .word LED_SaveLvl   - 1
        .word LED_TestLvl   - 1 
        .word LED_SameLvl   - 1 
        .word LED_NextLvl   - 1
        .word LED_NextLvl   - 1
        .word LED_PrevLvl   - 1
        .word LED_PrevLvl   - 1
        .word LED_XmitLvl   - 1 
        .word LED_MirrorLvl - 1 
        .word LED_MsgTxtLvl - 1 
        .word LED_Quit      - 1
// ------------------------------------------------------------------------------------------------------------- //
BoardEditor:{
        ldy #$00         
        sty LR_ScoreLo   
        sty LR_ScoreMidLo
        sty LR_ScoreMidHi
        sty LR_ScoreHi   

        dey
        sty LR_LvlReload            // <> LR_LevelNoDisk - force level load

        lda #LR_NumLivesInit 
        sta LR_NumLives 

        lda #LR_GameEdit 
        sta LR_GameCtrl             // $00=start $01=demo $02=game $03=play_level $05=edit
        sta LR_SprtPosCtrl          // <> $00 - no sprites

        lda LR_ControllerTyp        // controler type  $ca=joystick  $cb=keyboard
        sta BED_PlayLevel.Mod_CtrlerTyp 

        lda #LR_Keyboard 
        sta LR_ControllerTyp        // controler type  $ca=joystick  $cb=keyboard

        lda LR_LevelNoDisk          // 000-149
        cmp #LR_LevelDiskMax+1          // 150
        bcc ClearScrnDispA         // lower - clear hires display screen

    ResetDiskLevel:
        lda #LR_LevelDiskMin 
        sta LR_LevelNoDisk          // 000-149

    ClearScrnDispA:
        jsr ClearHiresDisp          //  - first clear before switch back to multicolor - avoid flicker
        jsr ClearHiresDisp.ClearHiresPrep          //  - avoid weird screen after an edit from StartGraphicOut
        jmp SetEdCmdWaitColr           // 

    GoClearScrnDisp:
        jsr ClearHiresDisp          // global return point - multi color is switched on already

    SetEdCmdWaitColr:
        lda #HR_YellowCyan 
        tax              
        ldy #WHITE       
        jsr ColorLevelFix
        
        lda #>LR_ScrnHiReDisp           // $20
        sta LRZ_GfxScreenOut        // target output  $20=$2000 $40=$4000
        
        lda #LR_KeyNewNone
        sta LR_KeyNew
        
        jsr LvlEdCurPosInit         // set cursor to top left screen pos
        jsr TextOut                 // <lode runner board editor>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $cf // O
        .byte $c4 // D
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $d2 // R
        .byte $d5 // U
        .byte $ce // N
        .byte $ce // N
        .byte $c5 // E
        .byte $d2 // R
        .byte $a0 // <blank>
        .byte $c2 // B
        .byte $cf // O
        .byte $c1 // A
        .byte $d2 // R
        .byte $c4 // D
        .byte $a0 // <blank>
        .byte $c5 // E
        .byte $c4 // D
        .byte $c9 // I
        .byte $d4 // T
        .byte $cf // O
        .byte $d2 // R
        .byte $8d // <new line>
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $d2 // R
        .byte $af // /
        .byte $d3 // S
        .byte $a0 // <blank>
        .byte $cb // K
        .byte $c5 // E
        .byte $d9 // Y
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $c2 // B
        .byte $cf // O
        .byte $d2 // R
        .byte $d4 // T
        .byte $d3 // S
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $ce // N
        .byte $d9 // Y
        .byte $a0 // <blank>
        .byte $c3 // C
        .byte $cf // O
        .byte $cd // M
        .byte $cd // M
        .byte $c1 // A
        .byte $ce // N
        .byte $c4 // D
        .byte $8d // <new line>
        .byte $00 // EndOfText
}
// ------------------------------------------------------------------------------------------------------------- //
BoEdWaitCmd:{
        lda LRZ_ScreenRow                       // screen row  (00-0f)
        cmp #LR_BEDCmdLinMax
        bcs BoardEditor.GoClearScrnDisp         // clear hires display screen

        jsr TextOut                             // <command>

        .byte $8d // <new line>
        .byte $c3 // C
        .byte $cf // O
        .byte $cd // M
        .byte $cd // M
        .byte $c1 // A
        .byte $ce // N
        .byte $c4 // D
        .byte $be // >
        .byte $00 // EndOfText
        
        jsr GetCheckKey                         // ac=value

    !FindEditCmd:
        ldy TabBoardEdCmdChr,x
        beq GoBeepWaitCmd
        
        cmp TabBoardEdCmdChr,x
        beq !CallEdCmdHandler+

        inx
        bne !FindEditCmd-
        
    GoBeepWaitCmd:
        jsr Beep
        jmp BoEdWaitCmd

    !CallEdCmdHandler:
        txa
        asl
        tax
        lda TabBoardEdCmdSub+1,x
        pha
        lda TabBoardEdCmdSub,x
        pha

        rts                     // call edit command routines
}
// ------------------------------------------------------------------------------------------------------------- //
BED_SwapLevels:{
        jsr TextOut                 // - <swap level>
        .byte $8d // <new line>
        .byte $be // >
        .byte $be // >
        .byte $d3 // S
        .byte $d7 // W
        .byte $c1 // A
        .byte $d0 // P
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $c5 // E
        .byte $d6 // V
        .byte $c5 // E
        .byte $cc // L
        .byte $00 // EndOfText
        
    !GetSourceNo:
        jsr DisplayGetLvlNo         // get level number
        bcs !Beep+                   // bad

    !SavSourceNo:
        sty LR_MoveLvlNoFrom        // save source level number

        jsr TextOut                 // <with level>
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $d7 // W
        .byte $c9 // I
        .byte $d4 // T
        .byte $c8 // H
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $c5 // E
        .byte $d6 // V
        .byte $c5 // E
        .byte $cc // L
        .byte $00 // EndOfText

    !GetTargetNo:
        jsr DisplayGetLvlNo         // get level number
        bcs !Beep+                  // bad

    !ChkBothNumbers:
        cpy LR_MoveLvlNoFrom        // saved source level number
        beq !Beep+                  // equal - error

    !SavTargetNo:
        sty LR_MoveLvlNoTo          // save target level number
        jmp !CheckDisk+

    !Beep:
        jmp BoEdWaitCmd.GoBeepWaitCmd

    !CheckDisk:
        jsr CheckLRDisk             // check disk

    !SetTargetRead:
        lda LR_MoveLvlNoTo          // saved target level number
        sta LR_LevelNoDisk          // to disk level number

        lda #>LR_WorkBuffer
    !SetTargetBuffer:
        sta ExecDiskCmdRead.Mod_GetDiskByte         // set buffer pointer to store target level data

        lda #LR_DiskRead
    !ReadTarget:
        jsr ControlDiskOper         // read target level data from disk

        lda #>LR_LvlDataSavLod
    !RstTargetBuffer:
        sta ExecDiskCmdRead.Mod_GetDiskByte         // reset buffer pointer

    !SetSourceRead:
        lda LR_MoveLvlNoFrom        // saved source level number
        sta LR_LevelNoDisk          // to disk level number

        lda #LR_DiskRead
    !ReadSource:
        jsr ControlDiskOper         // read source level data from disk

    !SetTargetWrite:
        lda LR_MoveLvlNoTo          // saved target level number
        sta LR_LevelNoDisk

        lda #LR_DiskWrite
    !WriteTarget:
        jsr ControlDiskOper         // disk write source level data to target level data

    !SetSourceWrite:
        ldy LR_MoveLvlNoFrom        // saved source level number
        sty LR_LevelNoDisk
        dey
        sty LR_LvlReload            // <> LR_LevelNoDisk forces a level reload

        lda #>LR_WorkBuffer
    !SetSourceBuffer:
        sta ExecDiskCmdWrite.Mod_PutDiskByte         // set buffer pointer to store target level data
        
        lda #LR_DiskWrite
    !WriteSource:
        jsr ControlDiskOper         // disk write target level data to source level data

        lda #>LR_LvlDataSavLod
    !RstSourceBuffer:
        sta ExecDiskCmdWrite.Mod_PutDiskByte         // reset buffer pointer

    !BED_SwapLevelsX:
       jmp BoEdWaitCmd             // wait for next command
}
// ------------------------------------------------------------------------------------------------------------- //
BED_ShowScore:{
        jsr ShowHighScoreClr 
        jsr TextOut                 // <hit a key to continue>
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $c8 // H
        .byte $c9 // I
        .byte $d4 // T
        .byte $a0 //  <blank> 
        .byte $c1 // A
        .byte $a0 // <blank>
        .byte $cb // K
        .byte $c5 // E
        .byte $d9 // Y
        .byte $a0 // <blank>
        .byte $d4 // T
        .byte $cf // O
        .byte $a0 // <blank>
        .byte $c3 // C
        .byte $cf // O
        .byte $ce // N
        .byte $d4 // T
        .byte $c9 // I
        .byte $ce // N
        .byte $d5 // U
        .byte $c5 // E
        .byte $00 // EndOfText

    WaitForKey:
        jsr ChkUserAction           // wait
        bcc WaitForKey              // and wait

BED_ShowScoreX:
        jmp BoardEditor
}
// ------------------------------------------------------------------------------------------------------------- //
BED_PlayLevel:{
        jsr TextOut                 // <play level>
        .byte $8d // <new line>
        .byte $be // >
        .byte $be // >
        .byte $d0 // P
        .byte $cc // L
        .byte $c1 // A
        .byte $d9 // Y
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $c5 // E
        .byte $d6 // V
        .byte $c5 // E
        .byte $cc // L
        .byte $00 // EndOfText

    !EdPlayLevel:
        jsr DisplayGetLvlNo
        bcs !BED_PlayLevelX+

        lda #$00
.label Mod_CtrlerTyp = *-1
        sta LR_ControllerTyp        // controler type  $ca=joystick  $cb=keyboard
        
        lda #LR_GamePlay
        sta LR_GameCtrl             // $00=start $01=demo $02=game $03=play_level $05=edit
        
        lda #LR_CheatedNo
        sta LR_Cheated              // $01=not cheated
        
        lda #$00
        sta LR_SprtPosCtrl          // $00 - set sprites
        
        lda LR_LevelNoDisk          // 000-149
        beq !GoGameStart+           // no cheating if level=$00
        
        lsr LR_Cheated              // $00=cheated
        
    !GoGameStart:
        jmp GameStart               // play selected level

    !BED_PlayLevelX:
        jmp BoEdWaitCmd.GoBeepWaitCmd
}
// ------------------------------------------------------------------------------------------------------------- //
BED_ClearLevel:{
        jsr TextOut                 // <clear level>
        .byte $8d // <new line>
        .byte $be // >
        .byte $be // >
        .byte $c3 // C
        .byte $cc // L
        .byte $c5 // E
        .byte $c1 // A
        .byte $d2 // R
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $c5 // E
        .byte $d6 // V
        .byte $c5 // E
        .byte $cc // L
        .byte $00 // EndOfText
        
    !EdClearLevel:
        jsr DisplayGetLvlNo
        bcs !BED_ClearLevelX+

        jsr CheckLRDisk

        ldy #$00
        tya
    !Clear:
        sta LR_LvlDataSavLod,y          // clear level store
        iny
        bne !Clear-

        lda #LR_DiskWrite
        jsr ControlDiskOper

        jmp BoEdWaitCmd
    !BED_ClearLevelX:
        jmp BoEdWaitCmd.GoBeepWaitCmd
}
// ------------------------------------------------------------------------------------------------------------- //
BED_Edit:{
        jsr TextOut                 // <edit level>
        .byte $8d // <new line>
        .byte $be // >
        .byte $be // >
        .byte $c5 // E
        .byte $c4 // D
        .byte $c9 // I
        .byte $d4 // T
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $c5 // E
        .byte $d6 // V
        .byte $c5 // E
        .byte $cc // L
        .byte $00 // EndOfText
        
    !EdLevel:
        jsr DisplayGetLvlNo
        bcs !BED_EditX+

    !GoEdit:
        jmp LevelEditor

    !BED_EditX:
        jmp BoEdWaitCmd.GoBeepWaitCmd
}
// ------------------------------------------------------------------------------------------------------------- //
BED_MoveLevel:{
        jsr TextOut                 // <move level>
        .byte $8d // <new line>
        .byte $be // >
        .byte $be // >
        .byte $cd // M
        .byte $cf // O
        .byte $d6 // V
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $c5 // E
        .byte $d6 // V
        .byte $c5 // E
        .byte $cc // L
        .byte $00 // EndOfText

    !EdMoveLevelFrom:
        jsr DisplayGetLvlNo
        bcs !BED_MoveLevelX+          // greater 150
        
        sty LR_MoveLvlNoFrom
        jsr TextOut                 // <to level>
        .byte $a0 // <blank>
        .byte $d4 // T
        .byte $cf // O
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $c5 // E
        .byte $d6 // V
        .byte $c5 // E
        .byte $cc // L
        .byte $00 // EndOfText

    !EdMoveLevelTo:
        jsr DisplayGetLvlNo
        bcs !BED_MoveLevelX+          // greater 150

        sty LR_MoveLvlNoTo
        jsr TextOut                 // <source diskette>
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $d3 // S
        .byte $cf // O
        .byte $d5 // U
        .byte $d2 // R
        .byte $c3 // C
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $c4 // D
        .byte $c9 // I
        .byte $d3 // S
        .byte $cb // K
        .byte $c5 // E
        .byte $d4 // T
        .byte $d4 // T
        .byte $c5 // E
        .byte $00 // EndOfText
        
    !EdMoveLevelR:
        jsr GetCheckKey             // read level
        jsr CheckLRDisk

        lda LR_MoveLvlNoFrom
        sta LR_LevelNoDisk          // 000-149

        lda #LR_DiskRead
        jsr ControlDiskOper

        jsr TextOut                 // <destination diskette>
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $c4 // D
        .byte $c5 // E
        .byte $d3 // S
        .byte $d4 // T
        .byte $c9 // I
        .byte $ce // N
        .byte $c1 // A
        .byte $d4 // T
        .byte $c9 // I
        .byte $cf // O
        .byte $ce // N
        .byte $a0 // <blank>
        .byte $c4 // D
        .byte $c9 // I
        .byte $d3 // S
        .byte $cb // K
        .byte $c5 // E
        .byte $d4 // T
        .byte $d4 // T
        .byte $c5 // E
        .byte $00 // EndOfText

    !EdMoveLevelW:
        jsr GetCheckKey             // write level
        jsr CheckLRDisk
        
        lda LR_MoveLvlNoTo
        sta LR_LevelNoDisk          // 000-149
        
        lda #LR_DiskWrite
        jsr ControlDiskOper

    !GoEDWaitCmd:
        jmp BoEdWaitCmd

    !BED_MoveLevelX:
        jmp BoEdWaitCmd.GoBeepWaitCmd
}
// ------------------------------------------------------------------------------------------------------------- //
BED_InitDisk:{
        jsr TextOut                 // <initialze>
        .byte $8d // <new line>
        .byte $be // >
        .byte $be // >
        .byte $c9 // I
        .byte $ce // N
        .byte $c9 // I
        .byte $d4 // T
        .byte $c9 // I
        .byte $c1 // A
        .byte $cc // L
        .byte $c9 // I
        .byte $da // Z
        .byte $c5 // E
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $d4 // T
        .byte $c8 // H
        .byte $c9 // I
        .byte $d3 // S
        .byte $a0 // <blank>
        .byte $d0 // P
        .byte $d2 // R
        .byte $c5 // E
        .byte $d0 // P
        .byte $c1 // A
        .byte $d2 // R
        .byte $c5 // E
        .byte $d3 // S
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $ce // N
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $cc // L
        .byte $d2 // R
        .byte $c5 // E
        .byte $c1 // A
        .byte $c4 // D
        .byte $d9 // Y
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $c6 // F
        .byte $cf // O
        .byte $d2 // R
        .byte $cd // M
        .byte $c1 // A
        .byte $d4 // T
        .byte $d4 // T
        .byte $c5 // E
        .byte $c4 // D
        .byte $a0 // <blank>
        .byte $c4 // D
        .byte $c9 // I
        .byte $d3 // S
        .byte $cb // K
        .byte $a0 // <blank>
        .byte $c6 // F
        .byte $cf // O
        .byte $d2 // R
        .byte $a0 // <blank>
        .byte $d5 // U
        .byte $d3 // S
        .byte $c5 // E
        .byte $d2 // R
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $c3 // C
        .byte $d2 // R
        .byte $c5 // E
        .byte $c1 // A
        .byte $d4 // T
        .byte $c5 // E
        .byte $c4 // D
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $c5 // E
        .byte $d6 // V
        .byte $c5 // E
        .byte $cc // L
        .byte $d3 // S
        .byte $ae // !
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a8 // (
        .byte $d7 // W
        .byte $c9 // I
        .byte $cc // L
        .byte $cc // L
        .byte $a0 // <blank>
        .byte $c4 // D
        .byte $c5 // E
        .byte $d3 // S
        .byte $d4 // T
        .byte $d2 // R
        .byte $cf // O
        .byte $d9 // Y
        .byte $a0 // <blank>
        .byte $cf // O
        .byte $cc // L
        .byte $c4 // D
        .byte $a0 // <blank>
        .byte $c4 // D
        .byte $c1 // A
        .byte $d4 // T
        .byte $c1 // A
        .byte $a9 // )
        .byte $ae // !
        .byte $8d // <new line>
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $d2 // R
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $d9 // Y
        .byte $cf // O
        .byte $d5 // U
        .byte $a0 // <blank>
        .byte $d3 // S
        .byte $d5 // U
        .byte $d2 // R
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $a8 // (
        .byte $d9 // Y
        .byte $af // /
        .byte $ce // N
        .byte $a9 // )
        .byte $a0 // <blank>
        .byte $00 // EndOfText

    !EdInitDisk:
        jsr GetCheckKey
        cmp #$19                // y(es)
        bne !BED_InitDiskX+

        lda #LR_DiskRead
        jsr GetPutHiScores          // Target: $1100-$11ff

        cmp #LR_DiskMaster          // lr master disk
        bne !GetDiskLvlNo+          // no

        jsr MsgMasterDisk
        jmp BoardEditor.GoClearScrnDisp         // clear hires display screen

    !GetDiskLvlNo:
        lda LR_LevelNoDisk          // 000-149
        pha
        lda #LR_DiskInit
        jsr ControlDiskOper

        pla
        sta LR_LevelNoDisk          // 000-149
    !BED_InitDiskX:
        jmp BoEdWaitCmd
}
// ------------------------------------------------------------------------------------------------------------- //
BED_ClearScore:{
        jsr TextOut                 // <clear score>
        .byte $8d // <new line>
        .byte $be // >
        .byte $be // >
        .byte $c3 // C
        .byte $cc // L
        .byte $c5 // E
        .byte $c1 // A
        .byte $d2 // R
        .byte $a0 // <blank>
        .byte $d3 // S
        .byte $c3 // C
        .byte $cf // O
        .byte $d2 // R
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $c6 // F
        .byte $c9 // I
        .byte $cc // L
        .byte $c5 // E
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $d4 // T
        .byte $c8 // H
        .byte $c9 // I
        .byte $d3 // S
        .byte $a0 // <blank>
        .byte $c3 // C
        .byte $cc // L
        .byte $c5 // E
        .byte $c1 // A
        .byte $d2 // R
        .byte $d3 // S
        .byte $a0 // <blank>
        .byte $d4 // T
        .byte $c8 // H
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $c8 // H
        .byte $c9 // I
        .byte $c7 // G
        .byte $c8 // H
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $d3 // S
        .byte $c3 // C
        .byte $cf // O
        .byte $d2 // R
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $c6 // F
        .byte $c9 // I
        .byte $cc // L
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $cf // O
        .byte $c6 // F
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $cc // L
        .byte $cc // L
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $c5 // E
        .byte $ce // N
        .byte $d4 // T
        .byte $d2 // R
        .byte $c9 // I
        .byte $c5 // E
        .byte $d3 // S
        .byte $ae // !
        .byte $8d // <new line>
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $d2 // R
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $d9 // Y
        .byte $cf // O
        .byte $d5 // U
        .byte $a0 // <blank>
        .byte $d3 // S
        .byte $d5 // U
        .byte $d2 // R
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $a8 // (
        .byte $d9 // Y
        .byte $af // /
        .byte $ce // N
        .byte $a9 // )
        .byte $a0 // <blank>
        .byte $00 // EndOfText
        
    !EdClearScore:
        jsr GetCheckKey
        cmp #$19                // y(es)
        bne !BED_ClearScoreX+
        
        lda #LR_DiskRead
        jsr GetPutHiScores          // Target: $1100-$11ff
        
        cmp #LR_DiskNoData          // no lode runner data disk
        beq !GoMsgNoLRDisk+
        
        lda #$00
        ldy #LR_HiScoreLen          // $7f=length high scores
    !ClearScores:
        sta LR_HiScore,y
        dey
        bpl !ClearScores-
        
        ldy #CR_BestMsgLen + CR_BestScrLen  // 
    !ClearMsg:
        sta CR_BestMsg,y
        dey             
        bpl !ClearMsg-    

        lda #LR_DiskWrite
        jsr GetPutHiScores          // Target: $1100-$11ff
    !EdClearScoreX:
        jmp BoEdWaitCmd

    !GoMsgNoLRDisk:
        jsr MsgNoLRDisk

    !BED_ClearScoreX:
        jmp BoEdWaitCmd
}
// ------------------------------------------------------------------------------------------------------------- //
// LevelEditor       Function: Edit level data (sic!)
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
LevelEditor:{
        ldx #LR_BEDLvlModNo         // - level data not modified
        stx LRZ_EditStatus          // - edit status - $00=modified

        jsr ClearHiresDisp
        jsr CheckLRDisk   
    !SetCurTopLeft:
        jsr LvlEdCurPosInit         // - set cursor to top left screen pos
}

LevelEditorTst:{
        lda #HR_LtBlueLtRed         // - entry from Edit-Test to preserve mofify flag in LRZ_EditStatus
        ldx #HR_CyanRed  
        ldy #WHITE       
        jsr ColorLevelFix

        lda #>LR_ScrnHiReDisp       // - $20
        sta LRZ_GfxScreenOut        // - target output  $20=$2000 $40=$40000
        jsr BaseLines               // - display baselines before level data              

        lda #>LR_ScrnHiRePrep       // - $40
        sta LRZ_GfxScreenOut        // target output  $20=$2000 $40=$40000
        jsr BaseLines

        ldx #LR_LevelPrep
        jsr InitLevel    
        bcc !GetOldCurPos+            // - good so care for level msg

    !BadLevel:
        jmp BoEdWaitCmd.GoBeepWaitCmd           // bad - beep - get next command

    !GetOldCurPos:
        jsr LvlEdCurPosLoad         // - restore old cursor position
    !InitMsg:
        jsr VictoryMsg              // - output the level msg text or a default msg text

LevelEdInputLoop:
        jsr SetEditDataPtr          // global return point - set edit level data pointer ($0800-$09c3)
    !GetInput:
        jsr WaitKeyBlink            // wait for input key and blink cursor

    !ChkDigit:
        jsr GetDigSubst             // check for a digit and substitute to $00-$09
        bcs !SetCommand+             // !hbu024! - no digit - check for command/joystick move

    !SetDigit:
        sta LRZ_EditTile            // level input tile $00-$09
        
        ldy LRZ_ScreenRow           // screen row  (00-0f)
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    !PtrModify:
        sta LRZ_XLvlModRowHi
        ldy LRZ_ScreenCol           // screen col  (00-1b)

    !ChkNewTile:
        lda LRZ_EditTile            // level input tile $00-$09
        eor (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        beq !GetTile+                // same as input data so do not set modify flag

    !SetMofified:
        lsr LRZ_EditStatus          // edit status  $00=modified

    !GetTile:
        lda LRZ_EditTile            // level input tile $00-$09
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        jsr ImageOut2Disp           // direct output to display screen

    !GetNextInput:
       jmp LevelEditorTst.LevelEdInputLoop        // 

    !SetCommand:
        sta LRZ_EditTile            // - keyboard/joystick value
        ldy LR_TypeUI               // - flag key or joystick interaction
        bne !WaitJoyI+       

    !ChkCommand:
        lda TabLevelEdCmdChr,y 
        beq !BeepBadInput+           // $00 - end of command table reached

        cmp LRZ_EditCmd                 // - check for a command
        beq !Dispatch+                  // - found one

        iny
        bne !ChkCommand-             // !hbu024! - test next command

    !WaitJoyI:
        ldy #$03                    // - set debounce delay
        sty LR_JoyWait              
    !WaitJoy:
        ldy LR_JoyWait              // - wait debounce time
        bne !WaitJoy-             

    !GetJoyMoves:
        lda LR_JoyNew             
    !ChkJoyMoves:
        ror                     // - up
        bcs !Dispatch+            

        iny                     // - LED_CurDo
        ror                     // - down
        bcs !Dispatch+            

        iny                     // - LED_CurLe
        ror                     // - left
        bcs !Dispatch+

        iny                     // - LED_CurRi
        ror                     // - right
        bcs !Dispatch+ 
        
    !BeepBadInput:
        jsr Beep                // - no valid input found - no beeps for joy checks

    !GoGetNextInput:
        jmp LevelEditorTst.LevelEdInputLoop        // - so get next input

    !Dispatch:
        tya
        asl                             // *2
        tay
        lda TabLevelEdCmdSub+1,y        // high byte command routine
        pha
        lda TabLevelEdCmdSub,y          // low  byte command routine
        pha

    !LevelEditorX:
        rts                             // dispatch command routine
}
// ------------------------------------------------------------------------------------------------------------- //
LED_TestLvl:{
        lsr LR_Cheated              // - $00=cheated
        
        lda #>LR_ScrnHiReDisp       // - $20
        sta LRZ_GfxScreenOut        // - target output  $20=$2000 $40=$4000
        
        lda #LR_GamePlay            
        sta LR_GameCtrl             // - $00=start $01=demo $02=game $03=play_level $05=edit
        
        lda BED_PlayLevel.Mod_CtrlerTyp           // - restore 
        sta LR_ControllerTyp        // - controler type  $ca=joystick  $cb=keyboard
        
        lda #LR_KeyNewNone 
        sta LR_KeyNew      
        sta LR_ScoreShown  
        sta LR_SprtPosCtrl          // - $00 - set sprites
        
        lda LR_LevelNoDisk  
        sta LR_LvlReload    
        
        lda #LR_TestLevelOn 
        sta LR_TestLevel            // - set test level mode
        
        jsr LvlEdCurPosSave         // - save actual cursor position
        jsr PackLevel
        
        lda #$00            
        sta LR_CntSpeedLaps 
        sta LR_EnmyBirthCol         // - reset birth col pointer
        
    !LED_TestLvlX:
        jmp LevelStart              // - play edited level
}
// ------------------------------------------------------------------------------------------------------------- //
LED_MirrorLvl:{
        jsr ToggleMirror

LED_MirrorLvlX:
        jmp LevelEditor 
}
// ------------------------------------------------------------------------------------------------------------- //
LED_CurUp:{
        lda LRZ_ScreenRow           // screen row  (00-0f) - i=cursor up
        cmp #LR_ScrnMinRows 
        bne !Up+            
        
        lda #LR_ScrnMaxRows         // - $00=max up reached
        sta LRZ_ScreenRow
        jmp LevelEditorTst.LevelEdInputLoop
        
    !Up:
        dec LRZ_ScreenRow           // screen row  (00-0f)
    !LED_CurUpX:
        jmp LevelEditorTst.LevelEdInputLoop
}
// ------------------------------------------------------------------------------------------------------------- //
LED_CurLe:{
        lda LRZ_ScreenCol           // screen col  (00-1b) - j=cursor left
        cmp #LR_ScrnMinCols 
        bne !Left+          
        
        lda #LR_ScrnMaxCols         //- $00=max left reached
        sta LRZ_ScreenCol
        jmp LevelEditorTst.LevelEdInputLoop
        
    !Left:
        dec LRZ_ScreenCol           // screen col  (00-1b)
    !LED_CurLeX:
        jmp LevelEditorTst.LevelEdInputLoop
}
// ------------------------------------------------------------------------------------------------------------- //
LED_CurRi:{
        lda LRZ_ScreenCol           // screen col  (00-1b) - k=cursor right
        cmp #LR_ScrnMaxCols
        bne !Right+        
        
        lda #LR_ScrnMinCols         //- $1b - max 27 cols reached
        sta LRZ_ScreenCol
        jmp LevelEditorTst.LevelEdInputLoop
        
    !Right:
        inc LRZ_ScreenCol           // screen col  (00-1b)
    !LED_CurRiX:
        jmp LevelEditorTst.LevelEdInputLoop
}
// ------------------------------------------------------------------------------------------------------------- //
LED_CurDo:{
        lda LRZ_ScreenRow           // screen row  (00-0f) - m=cursor down
        cmp #LR_ScrnMaxRows        
        bne !Down+                   
        
        lda #LR_ScrnMinRows         // - $0f - max 15 rows reached
        sta LRZ_ScreenRow
        jmp LevelEditorTst.LevelEdInputLoop
        
    !Down:
        inc LRZ_ScreenRow           // screen row  (00-0f)
    !LED_CurDoX:
        jmp LevelEditorTst.LevelEdInputLoop
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
LvlEdChkSave:{
        lda #LR_DiskRead
        jsr GetPutHiScores          // Target: $1100-$11ff
        
    !ChkData:
        cmp #LR_DiskNoData          // no lode runner data disk
        bne !ChkMaster+
        
        jsr MsgNoLRDisk
        jsr LvlEdCurPosInit         // set cursor to top left screen corner
        jmp LevelEditorTst.LevelEdInputLoop
        
    !ChkMaster:
        cmp #LR_DiskMaster          // master disk
        bne !GoPackLevel+
        
        jsr MsgMasterDisk
        jsr LvlEdCurPosInit         // set cursor to top left screen corner
        jmp LevelEditorTst.LevelEdInputLoop
        
    !GoPackLevel:
        jsr PackLevel
        
    !SaveLevel:
        lda #LR_DiskWrite
        jsr ControlDiskOper         // write and exit
        
    !CurPosLoad:
        jsr LvlEdCurPosLoad         // restore old cursor position
        
        lda #LR_BEDLvlModNo         // level data not modified
        sta LRZ_EditStatus          // edit status
        rts
        }
// ------------------------------------------------------------------------------------------------------------- //
LED_SaveLvl:{
        jsr LvlEdChAsk              // S=save level
        jsr VictoryMsg              // redisplay a possible level message or clear
        jmp LevelEditorTst.LevelEdInputLoop
}
// ------------------------------------------------------------------------------------------------------------- //
LED_SameLvl:{
        jsr LvlEdChkChFlag
        
        inc LR_LvlReload            //- force level reload if <> LR_LevelNoDisk
        jmp LevelEditor
}
// ------------------------------------------------------------------------------------------------------------- //
LED_NextLvl:{
        jsr LvlEdChkChFlag
    !GoIncLevelNo:
        jsr IncGameLevelNo          // increase level number
        jmp LevelEditor
}
// ------------------------------------------------------------------------------------------------------------- //
LED_PrevLvl:{
        jsr LvlEdChkChFlag
    !GoIncLevelNo:
        jsr DecGameLevelNo          // decrease level number
        jmp LevelEditor
}
// ------------------------------------------------------------------------------------------------------------- //
LED_XmitLvl:{                       // - transmit the active level a slot on drive 9
        lda LR_ExpertMode           // - expert mode set after <run/stop>, <f7>, <run/stop>
        bpl !Exit+                  // - off
        
        jsr LvlEdCurPosSave         // - save actual cursr pos
        jsr Xmit                    // 
        jsr LvlEdCurPosLoad         // - restore old cursor position

    !Exit:
        jmp LevelEditorTst.LevelEdInputLoop 
}
// ------------------------------------------------------------------------------------------------------------- //
LED_Quit:{
        jsr LvlEdChkChFlag          // - ask if level had changes
        bcc !Exit+                  // - ok so leave
        
    !AbortQuit:
        jsr VictoryMsg              // - abort so stay and redisplay a possible level message/clear
        jmp LevelEditorTst.LevelEdInputLoop        // - do not quit/keep change flag
    !Exit:
        jmp BoardEditor.GoClearScrnDisp         // clear hires display screen
}
// ------------------------------------------------------------------------------------------------------------- //
LED_MsgTxtLvl:{
        jsr LvlEdCurPosSave         // save actual cursr pos
        
    !SetCursor:
        jsr LvlEdCurSetMsg          // set cursor to input position
        
    !ColorMsg:
        lda #HR_YellowYellow 
        sta ColorMsg.Mod_ColorMsg   // - only yellow messages in edit mode 
        jsr ColorMsg               

    !StGfxScreen:
        lda #>LR_ScrnHiReDisp           // $20
        sta LRZ_GfxScreenOut        // target output  $20=$2000 $40=$4000
        
    !SetBufferLen:
        ldy #LR_LevelMsgLen+1       // message buffer max length
        clc                         // do not clear buffer - filled with LevelEditor/VictoryMsg
        jsr InputControl            // get a message text
        
    !CurPosLoad:
        jsr LvlEdCurPosLoad         // restore old cursor position
        
        ldy #LR_LevelMsgLen
    !GetMsg:
        lda CR_InputBuf,y           // copy the message text
        sta LR_LevelMsg,y           // to the level message store
        dey
        bpl !GetMsg-
        
        ldy #LR_LevelMsgIDLen
    !CopyID:
        lda TabMsgID,y              // copy the message id
        sta LR_LevelMsgID,y         // behind the message text
        dey
        bpl !CopyID-
        
    !LED_MsgTxtLvlX:
        jmp LevelEditorTst.LevelEdInputLoop
}
// ------------------------------------------------------------------------------------------------------------- //
LvlEdChkChFlag:{
        lda LRZ_EditStatus          // edit status  $00=modified
        beq LvlEdChAsk
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// LvlEdChAsk        Function: Ask to save level data
//               Parms   :
//               Returns :
//               ID      :
// ------------------------------------------------------------------------------------------------------------- //
LvlEdChAsk:{
        jsr ClearMsg 
        
    !InfoSetOutput:
        lda #>LR_ScrnHiReDisp
        sta LRZ_GfxScreenOut        // output to display screen only
        
    !CurPosSave:
        jsr LvlEdCurPosSave         // save actual cursr pos
        
    !InfoSetDisplay:
        jsr LvlEdCurSetMsg          // prepare display
        jsr TextOut                 // <save data>
        .byte $d3 // S        
        .byte $c1 // A        
        .byte $d6 // V        
        .byte $c5 // E        
        .byte $a0 // <blank>  
        .byte $c4 // D        
        .byte $c1 // A        
        .byte $d4 // T        
        .byte $c1 // A        
        .byte $a0 // <blank>  
        .byte $a0 // <blank>  
        .byte $a0 // <blank>  
        .byte $d9 // Y        
        .byte $af // /        
        .byte $ce // N        
        .byte $00 // EndOfText
        
    !InfoColorSet:
        lda #HR_LtGreenLtGreen          // attention message color
        sta ColorMsg.Mod_ColorMsg
        jsr ColorMsg             
        
        dec LRZ_ScreenCol
        
    !WaitBlink:
        jsr Beep
        
        lda #$ce                    // "N" for blink
        jsr GetChrSubst             // map to character image data numbers
        jsr WaitKeyBlink            // wait for input key and blink cursor
        
    !Clear:
        ldy #LR_KeyNewNone
        sty LR_KeyNew               // reset actual key value
        
    !ChkKey_RS:
        cmp #$3f                    // <run/stop>
        bne !ChkKey_N+
        
    !ExitRS:
        jsr LvlEdCurPosLoad         // restore old cursor position
        sec                         // flag: abort
        rts
        
    !ChkKey_N:
        cmp #$27                    // "n"
        beq !ExitYN+
        
    !ChkKey_Y:
        cmp #$19                   // "y"
        bne !WaitBlink- 
        
        jsr LvlEdChkSave            // check and save
        
    !ExitYN:
        jsr LvlEdCurPosLoad         // restore old cursor position
        clc                         // flag: normal exit
    !LvlEdChAskX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// Function:    CheckLRDisk
// Parms   :
// Returns :
// ------------------------------------------------------------------------------------------------------------- //
CheckLRDisk:{
        lda #LR_DiskRead
        jsr GetPutHiScores                  // Target: $1100-$11ff
        
    !ChkData:
        cmp #LR_DiskNoData
        bne !ChkMaster+
        
        jsr MsgNoLRDisk                     // no lode runner data disk
        jmp BoardEditor.GoClearScrnDisp     // clear hires display screen
        
    !ChkMaster:
        cmp #LR_DiskMaster
        bne !CheckLRDiskX+
        
        jsr MsgMasterDisk                   // master disk
        jmp BoardEditor.GoClearScrnDisp     // clear hires display screen
        
    !CheckLRDiskX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MsgMasterDisk:{
        jsr ClearHiresDisp
        
        lda ColorLevel._Mod_ColorLevelF         // save old colors
        pha
        
        lda #>LR_ScrnHiReDisp                   // $20
        sta LRZ_GfxScreenOut                    // target output  $20=$2000 $40=$4000
        
        lda #HR_YellowCyan
        tax                 
        ldy #WHITE          
        jsr ColorLevelFix   
        
        jsr LvlEdCurPosInit                     // set cursor to top left screen pos
        jsr TextOut                             // <user not allowed>
        .byte $d5 // U
        .byte $d3 // S
        .byte $c5 // E
        .byte $d2 // R
        .byte $a0 // <blank>
        .byte $ce // N
        .byte $cf // O
        .byte $d4 // T
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $cc // L
        .byte $cc // L
        .byte $cf // O
        .byte $d7 // W
        .byte $c5 // E
        .byte $c4 // D
        .byte $a0 // <blank>
        .byte $d4 // T
        .byte $cf // O
        .byte $8d // <new line>
        .byte $cd // M
        .byte $c1 // A
        .byte $ce // N
        .byte $c9 // I
        .byte $d0 // P
        .byte $d5 // U
        .byte $cc // L
        .byte $c1 // A
        .byte $d4 // T
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $cd // M
        .byte $c1 // A
        .byte $d3 // S
        .byte $d4 // T
        .byte $c5 // E
        .byte $d2 // R
        .byte $a0 // <blank>
        .byte $c4 // D
        .byte $c9 // I
        .byte $d3 // S
        .byte $cb // K
        .byte $c5 // E
        .byte $d4 // T
        .byte $d4 // T
        .byte $c5 // E
        .byte $ae // !
      .byte $00 // EndOfText
MsgMasterDiskX:
}
// ------------------------------------------------------------------------------------------------------------- //
MsgKey2Cont:{
        jsr TextOut                 // <hit a key to continue>
        .byte $8d // <new line>
        .byte $8d // <new line>
        .byte $c8 // H
        .byte $c9 // I
        .byte $d4 // T
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $a0 // <blank>
        .byte $cb // K
        .byte $c5 // E
        .byte $d9 // Y
        .byte $a0 // <blank>
        .byte $d4 // T
        .byte $cf // O
        .byte $a0 // <blank>
        .byte $c3 // C
        .byte $cf // O
        .byte $ce // N
        .byte $d4 // T
        .byte $c9 // I
        .byte $ce // N
        .byte $d5 // U
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $00 // EndOfText
        
        jsr Beep
        
        lda #$00                // blank chr under cursor
        jsr WaitKeyBlink            // wait for input key and blink cursor
        
        lda #LR_KeyNewNone
        sta LR_KeyNew               // reset actual key
        
        lda #>LR_ScrnHiRePrep           // $40
        sta LRZ_GfxScreenOut        // target output  $20=$2000 $40=$4000
        jsr BaseLines
        
        lda #LR_LevelPrep
        sta LR_LevelCtrl            // level display control  $00=prepared copy already at $4000-$5fff
        
        pla                     // restore old colors
        tax
        ldy #WHITE            
        
MsgKey2ContX:
        jmp ColorLevelFix
}
// ------------------------------------------------------------------------------------------------------------- //
// MsgNoLRDisk       Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MsgNoLRDisk:{
        jsr ClearHiresDisp
        lda ColorLevel._Mod_ColorLevelF         // save old colors
        pha
        
        lda #HR_YellowCyan
        tax              
        ldy #WHITE       
        jsr ColorLevelFix
        
        lda #>LR_ScrnHiReDisp           // $20
        sta LRZ_GfxScreenOut        // target output  $20=$2000 $40=$4000
        
        jsr LvlEdCurPosInit         // set cursor to top left screen pos
        jsr TextOut                 // <not a lode runner data disk>
        .byte $c4 // D
        .byte $c9 // I
        .byte $d3 // S
        .byte $cb // K
        .byte $c5 // E
        .byte $d4 // T
        .byte $d4 // T
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $c9 // I
        .byte $ce // N
        .byte $a0 // <blank>
        .byte $c4 // D
        .byte $d2 // R
        .byte $c9 // I
        .byte $d6 // V
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $c9 // I
        .byte $d3 // S
        .byte $a0 // <blank>
        .byte $ce // N
        .byte $cf // O
        .byte $d4 // T
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $8d // <new line>
        .byte $cc // L
        .byte $cf // O
        .byte $c4 // D
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $d2 // R
        .byte $d5 // U
        .byte $ce // N
        .byte $ce // N
        .byte $c5 // E
        .byte $d2 // R
        .byte $a0 // <blank>
        .byte $c4 // D
        .byte $c1 // A
        .byte $d4 // T
        .byte $c1 // A
        .byte $a0 // <blank>
        .byte $c4 // D
        .byte $c9 // I
        .byte $d3 // S
        .byte $cb // K
        .byte $ae // !
        .byte $00 // EndOfText
        
MsgNoLRDiskX:
        jmp MsgKey2Cont
}
// ------------------------------------------------------------------------------------------------------------- //
// SetEditDataPtr    Function: Set pointer ($09/$0a) to expanded level data $0800-$09c3
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
SetEditDataPtr:{
        ldy LRZ_ScreenRow               // screen row  (00-0f)
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    !PtrModify:
        sta LRZ_XLvlModRowHi
        ldy LRZ_ScreenCol               // screen col  (00-1b)
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//  Function:
//  Parms   :
//  Returns :
// ------------------------------------------------------------------------------------------------------------- //
DisplayGetLvlNo:{
        ldy LR_LevelNoDisk          // 000-149
        iny
        tya
        jsr ConvertHex2Dec          // 1307=100 1308=10 1309=1
        
        lda LRZ_ScreenCol           // screen col  (00-1b)
        sta LR_WrkScreenCol
        
        ldy #$00
    !GetGigits:
        lda LR_Digit100,y           // digit 100/10/1 parts
        sty LR_WrkCurrentPos        // current input screen pos
        jsr PrepareDigitOut
        
        ldy LR_WrkCurrentPos        // current input screen pos
        iny
        cpy #LR_BEDLvlLenMax+1          // max 3
        bcc !GetGigits-              // not reached
        
        lda LR_WrkScreenCol
        sta LRZ_ScreenCol           // screen col  (00-1b)
        
        ldy #$00
        sty LR_WrkCurrentPos        // current input screen pos
    !GetCurrentPos:
        ldx LR_WrkCurrentPos        // current input screen pos
        lda LR_Digit100,x
        clc
        adc #NoDigitsMin            // - prepare for grafic output
        jsr WaitKeyBlink            // wait for input key and blink cursor
        jsr GetDigSubst
        bcc !LvlNumNoDigits+
        
    !LvlNumNoDigits:
        cmp #$01                // RETURN
        beq !GetScreenCol+
        
        cmp #$07                // CURSOR DOWN
        beq !ChkCurDown+
        
        cmp #$82                // SHIFT CURSOR RIGHT
        bne !ChkCurRight+
        
    !ChkCurDown:
        ldx LR_WrkCurrentPos        // CURSOR DOWN
        beq !GoBeep+
        
        dec LR_WrkCurrentPos        // current input screen pos
        dec LRZ_ScreenCol           // screen col  (00-1b)
        jmp !GetCurrentPos-
        
    !ChkCurRight:
        cmp #$02                // CURSOR RIGHT
        bne !ChkKeyRS+
        
        ldx LR_WrkCurrentPos        // current input screen pos
        cpx #LR_BEDLvlLenMax
        beq !GoBeep+
        
        inc LRZ_ScreenCol           // screen col  (00-1b)
        inc LR_WrkCurrentPos        // current input screen pos
        jmp !GetCurrentPos-
        
    !ChkKeyRS:
        cmp #$3f                // <run/stop>
        bne !RSAbort+
        jmp BoEdWaitCmd
        
    !RSAbort:
        jsr GetDigSubst
        bcs !GoBeep+
        
    !LvlNumDigits:
        ldy LR_WrkCurrentPos        // current input screen pos
        sta LR_Digit100,y           // update digit under screen pos
        jsr PrepareDigitOut
        
        inc LR_WrkCurrentPos        // current input screen pos
        lda LR_WrkCurrentPos        // current input screen pos
        cmp #LR_BEDLvlLenMax+1          // max right
        bcc !GetCurrentPos-
        
        dec LR_WrkCurrentPos        // current input screen pos
        dec LRZ_ScreenCol           // screen col  (00-1b)
        jmp !GetCurrentPos-
        
    !GoBeep:
        jsr Beep
        jmp !GetCurrentPos-
        
    !GetScreenCol:
        lda LR_WrkScreenCol
        clc
        adc #LR_BEDLvlLenMax+1          // rightmost digit
        sta LRZ_ScreenCol           // screen col  (00-1b)
        
        jsr Dec2Hex
        bcs DisplayGetLvlNoX
        
        sta LR_LevelNoGame          // 001-150
        tay
        dey
        sty LR_LevelNoDisk          // 000-149
        
        cpy #LR_LevelNoMax          // set carry if too large
        
DisplayGetLvlNoX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// LvlEdCurPosInit   Function: Set cursor to top left screen corner
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
LvlEdCurPosInit:{
        lda #$00                // top left corner
        sta LRZ_ScreenCol           // screen col  (00-1b)
        sta LR_SavePosCol           // 
        sta LRZ_ScreenRow           // screen row  (00-0f)
        sta LR_SavePosRow           // 
        
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// LvlEdCurPosSave   Function: Save the actual cursor position
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
LvlEdCurPosSave:{
        lda LRZ_ScreenCol           // screen col  (00-1b)
        sta LR_SavePosCol           // 
        lda LRZ_ScreenRow           // screen row  (00-0f)
        sta LR_SavePosRow           // 
        
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// LvlEdCurPosLoad   Function: Restore the saved cursor position
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
LvlEdCurPosLoad:{
        lda LR_SavePosRow           // 
        sta LRZ_ScreenRow           // screen row  (00-0f)
        lda LR_SavePosCol             // 
        sta LRZ_ScreenCol           // screen col  (00-1b)
        
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// LvlEdCurSetMsg    Function: Set cursor to message position
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
LvlEdCurSetMsg:{
        lda #LR_BasLinRowStat           // 
        sta LRZ_ScreenRow           // screen row  (00-0f)
        lda #LR_BasLinColMsg        // 
        sta LRZ_ScreenCol           // screen col  (00-1b)
        
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// LvlEdCurSetHero   Function: Set cursor to top scorer position
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
LvlEdCurSetHero:{
        lda #LR_BasLinRowStat           // !hbu018!
        sta LRZ_ScreenRow           // !hbu018! - screen row  (00-0f)
        lda #$00                // !hbu018!
        sta LRZ_ScreenCol           // !hbu018! - screen col  (00-1b)
        
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetCheckKey:{
        lda #$00                    // blank chr under cursor
        jsr WaitKeyBlink            // wait for input key and blink cursor
        
        ldx #LR_KeyNewNone
        stx LR_KeyNew               // reset actual key
        
        cmp #$3f                    // <run/stop>
        bne !GetCheckKeyX+
        
        jmp BoEdWaitCmd
        
    !GetCheckKeyX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// GetDigSubst       Function: Map digit input keys to $00-$09
//               Parms   : ac=value to compare
//               Returns : ac=digit substitution + clear carry / set carry if no digit 
// ------------------------------------------------------------------------------------------------------------- //
GetDigSubst:{
        lda LR_KeyNew               // get actual key
        ldy #LR_KeyNewNone
        sty LR_KeyNew               // reset actual key
}
// ------------------------------------------------------------------------------------------------------------- //
GetDigSubstChk:{
        ldy #$09                // length digit key tab
    !Check:
        cmp TabKeyDigits,y
        beq !SetDigit+
        
        dey
        bpl !Check-
        
    !SetNoDigit:
        sec                     // was no digit
        rts
        
    !SetDigit:
        tya                     // set substitution
        clc                     // was a digit
    GetDigSubstX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
TabKeyDigits:
        .byte $23 // $00 - from KeyMatrix - translated into $00-$09
        .byte $38 // $01
        .byte $3b // $02
        .byte $08 // $03
        .byte $0b // $04
        .byte $10 // $05
        .byte $13 // $06
        .byte $18 // $07
        .byte $1b // $08
        .byte $20 // $09

// ------------------------------------------------------------------------------------------------------------- //
// ChkNewChampion    Function: Check for a new chamipon
//               Parms   :
//               Returns :
//               ID      : 
// ------------------------------------------------------------------------------------------------------------- //
ChkNewChampionXX:{
        clc                     // shortcut
        rts
        
ChkNewChampion:
        lda LR_LevelNoGame          // 001-150
        cmp #LR_LevelNoMax + 1          // 151
        bcc ChkNewChampionXX        // lower
        
        jsr ClearHiresDisp 
        
        lda #>LR_ScrnHiReDisp
        sta LRZ_GfxScreenOut        // control gfx screen output - display=$20(00) hidden=$40(00)
        
        lda #HR_YellowCyan 
        tax                
        ldy #WHITE         
        jsr ColorLevelFix  
        
        jsr LvlEdCurPosInit         // set cursor to top left screen pos
        jsr TextOut                 // <congratulations>
        .byte $8d // <newline>
        .byte $8d // <newline>
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $a0 // <blank>
        .byte $c3 // C
        .byte $cf // O
        .byte $ce // N
        .byte $c7 // G
        .byte $d2 // R
        .byte $c1 // A
        .byte $d4 // T
        .byte $d5 // U
        .byte $cc // L
        .byte $c1 // A
        .byte $d4 // T
        .byte $c9 // I
        .byte $cf // O
        .byte $ce // N
        .byte $d3 // S
        .byte $a0 // <blank>
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $8d // <newline>
        .byte $8d // <newline>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $d9 // Y
        .byte $cf // O
        .byte $d5 // U
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $d2 // R
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $8d // <newline>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $cf // O
        .byte $c4 // D
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $d2 // R
        .byte $d5 // U
        .byte $ce // N
        .byte $ce // N
        .byte $c5 // E
        .byte $d2 // R
        .byte $a0 // <blank>
        .byte $d3 // S
        .byte $cf // O
        .byte $d6 // V
        .byte $c5 // E
        .byte $d2 // R
        .byte $c5 // E
        .byte $c9 // I
        .byte $c7 // G
        .byte $ce // N
        .byte $8d // <newline>
        .byte $8d // <newline>
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $a0 // <blank>
        .byte $c3 // C
        .byte $cf // O
        .byte $ce // N
        .byte $c7 // G
        .byte $d2 // R
        .byte $c1 // A
        .byte $d4 // T
        .byte $d5 // U
        .byte $cc // L
        .byte $c1 // A
        .byte $d4 // T
        .byte $c9 // I
        .byte $cf // O
        .byte $ce // N
        .byte $d3 // S
        .byte $a0 // <blank>
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $00 // EndOfText
        
    !ChkOldSavHi:
        lda CR_BestHi               // saved old best score 
        cmp LR_ScoreHi            
        beq !ChkOldSavMidHi+        
        bcs !GoXitWithCarry+        
        
        jmp !SuperMsgColorI+        
        
    !ChkOldSavMidHi:
        lda CR_BestMiHi           
        cmp LR_ScoreMidHi         
        beq !ChkOldSavMidLo+        
        bcs !GoXitWithCarry+        
        
        jmp !SuperMsgColorI+        
        
    !ChkOldSavMidLo:
        lda CR_BestMiLo           
        cmp LR_ScoreMidLo         
        beq !ChkOldSavLo+           
        bcs !GoXitWithCarry+        
        
        jmp !SuperMsgColorI+        
    
    !ChkOldSavLo:
        lda CR_BestLo             
        cmp LR_ScoreLo            
        bcc !SuperMsgColorI+        
        
    !GoXitWithCarry:
        lda #$00                // zero flag set - won but set no new hero message
        jmp !ExitSetCarry+ 
        
    !SuperMsgColorI:
        lda #$20         
        lda #HR_GreenGreen
        ldx #$a0                // amount
    !SuperMsgColor:
        sta LR_ScrnMultColor + $00c8, x 
        dex                   
        bne !SuperMsgColor-     
        
        lda #$00              
        sta LRZ_ScreenCol           // screen col ($00 - $1b)
        lda #$09                //
        sta LRZ_ScreenRow           // screen row ($00 - $0f)
        jsr TextOut                 // <your score is the best ever>
        .byte $d9 // Y
        .byte $cf // O
        .byte $d5 // U
        .byte $d2 // R
        .byte $a0 // <blank>
        .byte $d3 // S
        .byte $c3 // C
        .byte $cf // O
        .byte $d2 // R
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $c9 // I
        .byte $d3 // S
        .byte $a0 // <blank>
        .byte $d4 // T
        .byte $c8 // H
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $c2 // B
        .byte $c5 // E
        .byte $d3 // S
        .byte $d4 // T
        .byte $a0 // <blank>
        .byte $c5 // E
        .byte $d6 // V
        .byte $c5 // E
        .byte $d2 // R
        .byte $8d // <newline>
        .byte $8d // <newline>
        .byte $a0 // <blank>
        .byte $c5 // E
        .byte $ce // N
        .byte $d4 // T
        .byte $c5 // E
        .byte $d2 // R
        .byte $a0 // <blank>
        .byte $d4 // T
        .byte $c8 // H
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $d6 // V
        .byte $c9 // I
        .byte $c3 // C
        .byte $d4 // T
        .byte $cf // O
        .byte $d2 // R
        .byte $d9 // Y
        .byte $a0 // <blank>
        .byte $cd // M
        .byte $c5 // E
        .byte $d3 // S
        .byte $d3 // S
        .byte $c1 // A
        .byte $c7 // G
        .byte $c5 // E
        .byte $8d // <newline>
        .byte $8d // <newline>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $be // >
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $bc // <
        .byte $00 // EndOfText
        
        lda #$04                //
        sta LRZ_ScreenCol           // screen col ($00 - $1b)
        
        sec                     // clear buffer first
        ldy #CR_BestMsgLen  
        jsr InputControl    
        beq !ExitSetCarry+    
        
        ldx #CR_BestMsgLen  
    !CpyMessage:
        lda CR_InputBuf,x           // copy msg to high score data
        sta CR_BestMsg,x 
        dex              
        bpl !CpyMessage-   
        
    !CpyScore:
        lda LR_ScoreLo              // copy score to high score data
        sta CR_BestLo    
        lda LR_ScoreMidLo
        sta CR_BestMiLo  
        lda LR_ScoreMidHi
        sta CR_BestMiHi  
        lda LR_ScoreHi   
        sta CR_BestHi    
        
    !SetScore:
        lda #LR_DiskWrite           // write back high scoreblock
        jsr GetPutHiScores          // ac: $01=load $02=store 81= 82=
        
        lda #$01                // zero flag clear - won and set new hero message
        
    !ExitSetCarry:
        sec 
    !ChkNewChampionX:
        rts
} 
// ------------------------------------------------------------------------------------------------------------- //
// OutNewChampion    Function: Put out the champions score and victory message
//               Parms   :
//               Returns :
//               ID      : 
// ------------------------------------------------------------------------------------------------------------- //
OutNewChampionXX:{
        clc                     // mark no message set
        rts
}
OutNewChampion:{
        lda CR_BestHi               // check champion scores
        ora CR_BestMiHi 
        ora CR_BestMiLo 
        ora CR_BestLo   
        beq OutNewChampionXX        // nobody passed the last level so far
        
        jsr LvlEdCurSetHero 
        
        ldx #$00
        stx LRZ_Work                // check for blank message text
        stx LR_Work
        
        lda #>LR_ScrnHiReDisp
        sta LRZ_GfxScreenOut        // control gfx screen output - display=$20(00) hidden=$40(00)
        
        ldy #$27                    // amount
        lda #LR_ColorVicMsg         // color scores
    HeroesMsgColor:
        sta LR_ScrnMCTitle,y  
        dey                   
        bpl HeroesMsgColor    
        
    HeroesMsgOut:
        lda CR_BestMsg,x      
        pha                   
        
        eor #$a0                // <blank>
        ora LRZ_Work                // check for blank message text
        sta LRZ_Work           
        
        pla                    
        jsr PrepareChrOut      
        
        inc LR_Work            
        ldx LR_Work            
        cpx #CR_BestMsgLen     
        bcc HeroesMsgOut           // lower
        
        lda LRZ_Work                // check for blank message text
        beq OutNewChampionXX        // was blank message text
        
        inc LRZ_ScreenCol           // screen col ($00 - $1b)
        
    !HeroesScoreOut:
        lda CR_BestHi   
        jsr SplitDecOut 
        
        lda CR_BestMiHi 
        jsr SplitDecOut 
        
        lda CR_BestMiLo 
        jsr SplitDecOut 
        
        lda CR_BestLo   
        jsr SplitDecOut 
        
    !ExitSetCarry:
           sec                     // mark message set
    !OutNewChampionX:
    rts
}
// ------------------------------------------------------------------------------------------------------------- //
// ChkNewHighScore   Function: Check for a new high score entry
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
ChkNewHighScore:{
        lda LR_Cheated
        beq !ExitClrCarry+           // no scores for cheating
        
        lda LR_ScoreLo
        ora LR_ScoreMidLo
        ora LR_ScoreMidHi
        ora LR_ScoreHi
        beq !ExitClrCarry+           // no game scores acquired yet
        
        lda #LR_DiskRead
        jsr GetPutHiScores          // Target: $1100-$11ff
        beq !ExitClrCarry+           // no lr data disk
        
    !SetEntryNo:
        ldy #$01                // start with entry 1
        
    !ChkEmpty:
        lda LR_HiScore
        cmp #$00                // no entry set so far
        beq SetNewHighScore         // no checks for an empty high score table
        
    !Checks:
        ldx TabHiScRowPtr,y         // high score rows offsets
    
    !ChkLevel:
        lda LR_LevelNoGame          // 001-150
        cmp LR_HiScoreLevel,x           // score board entry - level
        bcc !NextEntry+
        bne SetNewHighScore
        
    !ChkScoreHi:
        lda LR_ScoreHi
        cmp LR_HiScoreHi,x          // score board entry - score
        bcc !NextEntry+
        bne SetNewHighScore
        
    !ChkScoreMidHi:
        lda LR_ScoreMidHi
        cmp LR_HiScoreMidHi,x           // score board entry - score
        bcc !NextEntry+
        bne SetNewHighScore
        
    !ChkScoreMidLo:
        lda LR_ScoreMidLo
        cmp LR_HiScoreMidLo,x           // score board entry - score
        bcc !NextEntry+
        bne SetNewHighScore
        
    !ChkScoreLo:
        lda LR_ScoreLo
        cmp LR_HiScoreLo,x          // score board entry - score
        bcc !NextEntry+
        bne SetNewHighScore
        
    !ChkLives:
        lda LR_NumLives
        cmp LR_HiScoreMen,x         // score board entry - lives
        bcc !NextEntry+
        bne SetNewHighScore
        
    !NextEntry:
        iny
        cpy #LR_HiScoreMaxIDs + 1         // max 10 high score entries
        bcc !Checks-                 // lower
        
    !ExitClrCarry:
        clc                     //  - mark no new high scorer set
    !ChkNewHighScoreX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// SetNewHighScore   Function: Get new name in parts of 3/5 and write back
//               Parms   :
//               Returns :
//               ID      // !hbu010! - Rewritten and high score working sets removed
// ------------------------------------------------------------------------------------------------------------- //
SetNewHighScore:{
        sty $29                 // row offset of new entry
        
    !ChkMax:
        cpy #LR_HiScoreMaxIDs           // no insertion for last entry
        beq !Insert+                 // simply overwrite
        
    !ChkEmpty:
        ldy LR_HiScore
        cpy #$ff
        beq SetNewHighScore         // no insertion for last entry
        
        ldy #LR_HiScoreMaxIDs-1         // $0a - max entries to move
    !MoveDownI:
        ldx TabHiScRowPtr,y         // high score rows offsets
        lda #LR_HiScoreLEntry           // high score entry length
        sta LRZ_WrkHiScorLen
        
    !MoveDown:
        lda LR_HiScoreMain,x        // main part one row down
        sta LR_HiScoreMain + LR_HiScoreLEntry,x
        lda LR_HiScoreXtra,x        // extension one row down
        sta LR_HiScoreXtra + LR_HiScoreLEntry,x
        inx
        dec LRZ_WrkHiScorLen
        bne !MoveDown-
        
        cpy $29                 // row offset of new entry
        beq !Insert+
        
        dey                     // number of new entry not reached
        bne !MoveDownI-              // move next entry
        
    !Insert:
        sty $39                 // row number of new entry
        
        ldx TabHiScRowPtr,y         // high score rows offsets
        lda #$a0                // shift blank
    !ClrName:
        sta LR_HiScoreNam1,x            // - initial 1
        sta LR_HiScoreNam1+1,x          // - initial 2
        sta LR_HiScoreNam1+2,x          // - initial 3
        sta LR_HiScoreNam2,x            // - initial 3
        sta LR_HiScoreNam2+1,x          // - initial 3
        sta LR_HiScoreNam2+2,x          // - initial 3
        sta LR_HiScoreNam2+3,x          // - initial 3
        sta LR_HiScoreNam2+4,x          // - initial 3
        
    !SetLevel:
        lda LR_LevelNoGame          // 001-150
        sta LR_HiScoreLevel,x           // level
        
    !SetScore:
        lda LR_ScoreLo
        sta LR_HiScoreLo,x          // score
        lda LR_ScoreMidLo
        sta LR_HiScoreMidLo,x           // score
        lda LR_ScoreMidHi
        sta LR_HiScoreMidHi,x           // score
        lda LR_ScoreHi
        sta LR_HiScoreHi,x          // score
        
    !SetLives:
        lda LR_NumLives             // men left
        sta LR_HiScoreMen,x         // directly behind 2nd part of name
        
        jsr ShowHighScoreClr
        
    !GetScorerName:
        lda #LR_HiScColOffNam
        sta LRZ_ScreenCol
        lda #LR_HiScRowOff1St           // number first score line
        clc
        adc $39                 // add number of this heroes high score entry
        sta LRZ_ScreenRow           // is row offset
        
    !SetHighScorePtr:
        lda #<TabSubstRowHighS          //  set grouped high score pointer
        sta GetColRowGfxOff.Mod__RowGfxL
        lda #>TabSubstRowHighS
        sta GetColRowGfxOff.Mod__RowGfxH
        
        sec                     // clear buffer first
    !SetBufferLen:
        ldy #LR_HiScoreNamLen+1         // input buffer max length
        jsr InputControl            // fill input buffer
        
    !RstHighScorePtr:
        lda #<TabSubstRow           // restore pointer to game row offsets
        sta GetColRowGfxOff.Mod__RowGfxL
        lda #>TabSubstRow
        sta GetColRowGfxOff.Mod__RowGfxH
        
    !OutNew:
        ldy $39
        ldx TabHiScRowPtr,y         // high score rows offsets
        
    !SetName:
        lda CR_InputBuf
        sta LR_HiScoreNam1,x        // name 1!1
        lda CR_InputBuf+1
        sta LR_HiScoreNam1+1,x          // name 1!2
        lda CR_InputBuf+2
        sta LR_HiScoreNam1+2,x          // name 1!3
        
        lda CR_InputBuf+3
        sta LR_HiScoreNam2,x        // name 2!1
        lda CR_InputBuf+4
        sta LR_HiScoreNam2+1,x          // name 2!2
        lda CR_InputBuf+5
        sta LR_HiScoreNam2+2,x          // name 2!3
        lda CR_InputBuf+6
        sta LR_HiScoreNam2+3,x          // name 2!4
        lda CR_InputBuf+7
        sta LR_HiScoreNam2+4,x          // name 3!5
        
        lda #LR_DiskWrite
        jsr GetPutHiScores          // Target: $1100-$11ff
        
    !ExitSetCarry:
        sec                     //  - mark new high scorer set
    !SetNewHighScoreX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// ColorHighScores   Function: Select a new color for each high score group
//               Parms   :
//               Returns :
//               ID      : 
// ------------------------------------------------------------------------------------------------------------- //
ColorHighScores:{
        lda #<LR_ScrnMultColor          // set color screen pointer
        sta $44
        lda #>LR_ScrnMultColor
        sta $45 
        
        ldx #$00
    !SetRowCount:
        ldy #$27                // 28 color row positions
        lda TabScoreColors,x        // get a color
    !SetColor:
        sta ($44),y                 // put a color
        cpy #$06                // check for rank area
        bne !SetColPtr+
        
        lda #HR_WhiteWhite          // rank color
        
    !SetColPtr:
        dey                     // next color screen coloumn
        bpl !SetColor-
        
    !SetRowPtr:
        lda #$28                // set color screen to next row
        clc
        adc $44
        sta $44
        bcc !SetNextColorRow+
        inc $45
        
    !SetNextColorRow:
        inx
        cpx #TabScoreColorsX-TabScoreColors
        bne !SetRowCount-
        
    !ColorHighScoresX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
TabScoreColors:
        .byte HR_CyanCyan           // title line
        .byte HR_CyanCyan 
        .byte HR_CyanCyan 
        .byte HR_CyanCyan 
            
        .byte HR_WhiteWhite         // header line
        .byte HR_WhiteWhite 
        
        .byte HR_WhiteWhite         // separation line
        
        .byte HR_YellowYellow       // the 1st
        .byte HR_LtGreenLtGreen     // the 2nd
        .byte HR_LtGreenLtGreen      
        .byte HR_LtRedLtRed         // the 3rd
        
        .byte HR_PurpleLtBlue       // group 4-6
        .byte HR_PurpleLtBlue 
        .byte HR_PurpleLtBlue 
        .byte HR_PurpleLtBlue 
        .byte HR_PurpleLtBlue 
        
        .byte HR_GreyLtGrey         // group 7-9
        .byte HR_GreyLtGrey 
        .byte HR_GreyLtGrey 
        .byte HR_GreyLtGrey 
        .byte HR_GreyLtGrey 
        
        .byte HR_DkGreyDkGrey       // the last 
        .byte HR_DkGreyDkGrey 
        
        .byte HR_CyanCyan           // message area

TabScoreColorsX:
    
// ------------------------------------------------------------------------------------------------------------- //
// ShowHighScore     Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
ShowHighScoreClr:{

        jsr ClearHiresDisp
}
        
ShowHighScore:{
        lda #<TabSubstRowHighS              // - 2nd entry point for calls from StartGraphicOut
        sta GetColRowGfxOff.Mod__RowGfxL
        lda #>TabSubstRowHighS
        sta GetColRowGfxOff.Mod__RowGfxH
        jsr ColorHighScores
        
        jsr LvlEdCurPosInit                 // set cursor to top left screen pos
        jsr TextOut                         // <lode runner high scores>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $cf // O
        .byte $c4 // D
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $d2 // R
        .byte $d5 // U
        .byte $ce // N
        .byte $ce // N
        .byte $c5 // E
        .byte $d2 // R
        .byte $a0 // <blank>
        .byte $c8 // H
        .byte $c9 // I
        .byte $c7 // G
        .byte $c8 // H
        .byte $a0 // <blank>
        .byte $d3 // S
        .byte $c3 // C
        .byte $cf // O
        .byte $d2 // R
        .byte $c5 // E
        .byte $d3 // S
        .byte $8d // <new line>
        .byte $8d // <new line>
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>  - title line changed
        .byte $a0 // <blank>
        .byte $ce // N
        .byte $c1 // A
        .byte $cd // M
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $d6 // V
        .byte $cc // L
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $d3 // S
        .byte $c3 // C
        .byte $cf // O
        .byte $d2 // R
        .byte $c5 // E
        .byte $d3 // S
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $cd // M
        .byte $c5 // E
        .byte $ce // N
        .byte $8d // <new line>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $a0 // <blank>
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $a0 // <blank>
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $a0 // <blank>
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $8d // <new line>
        .byte $00 // EndOfText
        
        lda #$01
        sta $28                 // actual rank
        
    !ShowScores:
        cmp #$0a                // 10
        bne !Not10+
        
        lda #$01                // rank 10  - start with "1"
        jsr PrepareDigitOut
        
        lda #$00
        jsr PrepareDigitOut
        jmp !SepRankName+
        
    !Not10:
        lda #$a0                    // rank 1-9 - start with " "
        jsr PrepareChrOut
        
        lda $28                     // actual rank
        jsr PrepareDigitOut
        
    !SepRankName:
        jsr TextOut
         .byte $ae // <dot>         // - 4 <blank> removed
         .byte $00 // EndOfText
        
        ldx $28                     // actual rank
        ldy TabHiScRowPtr,x         // high score rows offsets
        sty $29                     // score board offset
        
        lda LR_HiScoreLevel,y       // get level no
        bne !ScoreInitialsP1+
        
        jmp !NextLine+
        
    !ScoreInitialsP1:
        ldy $29                     // get score board offset - put out first part of name
        lda LR_HiScoreNam1,y        //  - name chr 1
        jsr ControlOutput           // 
        
        ldy $29                     // score board offset
        lda LR_HiScoreNam1+1,y      // - name chr 2
        jsr ControlOutput           //
        
        ldy $29                     // score board offset
        lda LR_HiScoreNam1+2,y      //  - name chr 3
        jsr ControlOutput           // 
        
    !ScoreInitialsP2:
        ldy $29                     // get score board offset - put out first part of name
        lda LR_HiScoreNam2,y        // - name chr 4
        jsr ControlOutput           //
        
        ldy $29                     // score board offset
        lda LR_HiScoreNam2+1,y      // - name chr 5
        jsr ControlOutput
        
        ldy $29                     // score board offset
        lda LR_HiScoreNam2+2,y      // - name chr 6
        jsr ControlOutput
        
        ldy $29                     // score board offset
        lda LR_HiScoreNam2+3,y      // - name chr 7
        jsr ControlOutput 
        
        ldy $29                     // score board offset
        lda LR_HiScoreNam2+4,y      // - name chr 8
        jsr ControlOutput
        
        jsr TextOut
    !SepNameLevel:
        .byte $a0 // <blank>         // - 3 <blank> removed
        .byte $00 // EndOfText
        
        ldy $29                 // score board offset
        lda LR_HiScoreLevel,y           // level reached
        jsr SplitHexOut
        
        jsr TextOut
    !SepLevelScore:
        .byte $a0 // <blank>         // - 1 <blank> removed
        .byte $00 // EndOfText
        
        ldy $29                 // score board offset
        lda LR_HiScoreHi,y          // score hi byte
        jsr SplitDecOut
        
        ldy $29                 // score board offset
        lda LR_HiScoreMidHi,y
        jsr SplitDecOut
        
        ldy $29                 // score board offset
        lda LR_HiScoreMidLo,y
        jsr SplitDecOut
        
        ldy $29                 // score board offset
        lda LR_HiScoreLo,y
        jsr SplitDecOut
        
        jsr TextOut                 // - output the no of men left

    !SepScoreMen:
        .byte $a0
        .byte $00                   // - <end_of_text>
        
        ldy $29	                    // - score board offset
        lda LR_HiScoreMen,y         // - men left
        jsr SplitHexOut
        
    !NextLine:
        inc LRZ_ScreenRow           // - next  screen row  (00-0f)
        lda #$00                    //
        sta LRZ_ScreenCol           // - first screen col  (00-1b)
        
    !NextRank:
        inc $28                 // actual rank
        lda $28                 // actual rank
        cmp #LR_HiScoreMaxIDs+1         // max 10
        bcs !RstHighScorePtr+
        
    !NextRow:
        jmp ShowScores             // next row

    !RstHighScorePtr:
        lda #<TabSubstRow           // !hbu010! - restore pointer to game row offsets
        sta GetColRowGfxOff.Mod__RowGfxL            // !hbu010!
        lda #>TabSubstRow           // !hbu010!
        sta GetColRowGfxOff.Mod__RowGfxH            // !hbu010!
        
    !ShowHighScoresX:
        jmp OutNewChampion          //  - test for victiry message
}
// ------------------------------------------------------------------------------------------------------------- //
TabHiScRowPtr:{
        .byte $00
        .byte $00
        .byte $08
        .byte $10
        .byte $18
        .byte $20
        .byte $28
        .byte $30
        .byte $38
        .byte $40
        .byte $48
}
// ------------------------------------------------------------------------------------------------------------- //
// ControlOutput     Function: Control output of image/digits/prepared digits/characters
//               Parms   : ac=chr/digit
//               Returns : 
//               ID      : !hbu010!
// ------------------------------------------------------------------------------------------------------------- //
ControlOutput:{
        cmp #$0a
        bcc DigitOut               // pure digit
        
    ChkPrep:
        cmp #NoDigitsMin
        bcc GetBlank               // image - no output
        
    ChkChr:
        cmp #NoDigitsMax + 1
        bcc ControlOutputX          // digit
        bcs ChrOut                 // character
        
    GetBlank:
        lda #$a0                // " " 

    ChrOut:
        jmp PrepareChrOut           // Character
    DigitOut:
        jmp PrepareDigitOut         // digit
ControlOutputX:
        jmp DigitOut2Screen         // prepared digit
}
// ------------------------------------------------------------------------------------------------------------- //
// InputControl      Function: String input and control modifications 
//               Parms   : LRZ_ScreenCol/LRZ_ScreenRow=screen_pos  yr=length of input field + 1
//                   : Carry_Set  =Clear Buffer first 
//                   : Carry_Clear=Buffer already filled
//               Returns : 
//               ID      : !hbu009!
// ------------------------------------------------------------------------------------------------------------- //
InputControl:{
        sty CR_InputBufMax          // input field length
        bcc Init                   // do not clear input buffer
        
        lda #$a0                // <blank>
        ldx #CR_InputBufLen
    ClrInputBuffer:
        sta CR_InputBuf,x           //
        dex                     //
        bpl ClrInputBuffer         //
        
    Init:
        ldx #$00
        stx LR_WrkCurrentPos        // current input screen pos
        stx LR_KeyNew               // reset key pressed
        
    GetNewInput:
        ldx LR_WrkCurrentPos        // current input screen pos
        lda CR_InputBuf,x
        
    ChkDigit:
        cmp #NoDigitsMin            // no substitution for digits
        bcc SetChr                 // character
        
        cmp #NoDigitsMax+1
        bcc WaitKey                // digit
        
    SetChr:
        jsr GetChrSubst             // map to character image data numbers
        
    WaitKey:
        jsr WaitKeyBlink
        
        lda LR_KeyNew               // care only for keyboard interactions
        ldy #LR_KeyNewNone          // reset value
        sty LR_KeyNew               // do not handle this key more than once
        
    SetDigit:
        jsr GetDigSubstChk          // check digital keys and map to $00-$09
        bcc OutDigit               // was digit
        
    ChkRunStop:
        cmp #$3f                // <run/stop> - abort edit
        bne GetKeySubst            // 
        
    ExitAbort:
        sec                     // <run/stop> pressed
        ldx #$00
        rts
        
    GetKeySubst:
        jsr GetKeySubst             // map allowed keys
        
    ChkReturn:
        cmp #$8d                // <return> - end of edit
        beq ExitRet
        
    ChkCursorUD:
        cmp #$88                // <cursor up/down>
        bne ChkCursorLR
        
        ldx LR_WrkCurrentPos        // current input screen pos
        beq Beep
        
        dec LR_WrkCurrentPos        // current input screen pos
        dec LRZ_ScreenCol
        jmp GetNewInput
        
    ChkCursorLR:
        cmp #$95                // <cursor left/right>
        bne ChkChars
        
        ldx CR_InputBufMax
        dex
        cpx LR_WrkCurrentPos        // current input screen pos
        beq Beep
        
        inc LRZ_ScreenCol
        inc LR_WrkCurrentPos        // current input screen pos
        jmp GetNewInput
        
    ChkChars:
        cmp #$a0                // <blank>
        beq OutChr
        
        cmp #$ae                // "!"
        beq OutChr
        
        cmp #$c1                // "A"
        bcc Beep
        
        cmp #$db                // "Z" + 1
        bcs Beep
        
    OutChr:
        ldy LR_WrkCurrentPos        // current input screen pos

    StoreMsgChr:
        sta CR_InputBuf,y
        jsr PrepareChrOut
        
        jmp SetModified
        
    OutDigit:
        clc
        adc #NoChrDigitsMin         // !hbu015! - map to chr digit image data numbers - must not be $00-$09 because $00 ist EndOfText
        ldy LR_WrkCurrentPos        // current input screen pos

    StoreMsgDigit:
        sta CR_InputBuf,y
        jsr DigitOut2Screen
        
    SetModified:
        lsr LRZ_EditStatus          // flag: data was changed
        inc LR_WrkCurrentPos        // current input screen pos
        lda LR_WrkCurrentPos        // current input screen pos
        cmp CR_InputBufMax          // maximum right
        bcc GoGetNewInput
        
    SetNewPos:
        dec LR_WrkCurrentPos        // current input screen pos
        dec LRZ_ScreenCol
        
    GoGetNewInput:
        jmp GetNewInput
        
    Beep:
        jsr Beep
        jmp GoGetNewInput
        
    ExitRet:
        ldx CR_InputBufMax          // <enter> pressed

    ChkBlanks:
        lda CR_InputBuf,x           // 
        cmp #$a0                // <blank>
        bne ExitWithInput          // some text found
    
        dex                     //
        bpl ChkBlanks              // 

    ExitNoInput:
        clc                     // enter with no text
        ldx #$00
        rts
        
    ExitWithInput:
        clc                     // enter with text
        ldx #$01
InputControlX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// GetKeySubst       Function: Substitute a value for allowed keys
//               Parms   : ac=key value
//               Returns : ac=key substitution with bit7 set
// ------------------------------------------------------------------------------------------------------------- //
GetKeySubst:{
        cmp #$82                // replaced by $07
        bne !GetSubst+
        
        lda #$07
        
    !GetSubst:
        tay
        lda TabKeySubst,y
        ora #$80                // set bit7
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
.label TabKeySubst = *

KeyMatrixColBit0:
                .byte $00 // $00 - DELETE
                .byte $0d // $01 - RETURN
                .byte $15 // $02 - CRSR_R
                .byte $ff // $03 - F7
                .byte $ff // $04 - F1
                .byte $ff // $05 - F3
                .byte $ff // $06 - F5
                .byte $08 // $07 - CRSR_D
                
KeyMatrixColBit1:
                .byte $33 // $08 - 3
                .byte $57 // $09 - W
                .byte $41 // $0a - A
                .byte $34 // $0b - 4
                .byte $5a // $0c - Z
                .byte $53 // $0d - S
                .byte $45 // $0e - E
                .byte $ff // $0f - LSHIFT
                
KeyMatrixColBit2:
                .byte $35 // $10 - 5
                .byte $52 // $11 - R
                .byte $44 // $12 - D
                .byte $36 // $13 - 6
                .byte $43 // $14 - C
                .byte $46 // $15 - F
                .byte $54 // $16 - T
                .byte $58 // $17 - X
                
KeyMatrixColBit3:
                .byte $37 // $18 - 7
                .byte $59 // $19 - Y
                .byte $47 // $1a - G
                .byte $38 // $1b - 8
                .byte $42 // $1c - B
                .byte $48 // $1d - H
                .byte $55 // $1e - U
                .byte $56 // $1f - V
                
KeyMatrixColBit4:
                .byte $39 // $20 - 9
                .byte $49 // $21 - I
                .byte $4a // $22 - J
                .byte $30 // $23 - 0
                .byte $4d // $24 - M
                .byte $4b // $25 - K
                .byte $4f // $26 - O
                .byte $4e // $27 - N
                
KeyMatrixColBit5:
                .byte $2b // $28 - +
                .byte $50 // $29 - P
                .byte $4c // $2a - L
                .byte $2d // $2b - -
                .byte $2e // $2c - !
                .byte $3a // $2d - :
                .byte $ff // $2e - @
                .byte $2c // $2f - ,
                
KeyMatrixColBit6:
                .byte $5c // $30 - LIRA
                .byte $2a // $31 - *
                .byte $3b // $32 - //
                .byte $ff // $33 - HOME
                .byte $ff // $34 - RSHIFT
                .byte $3d // $35 - =
                .byte $ff // $36 - ^
                .byte $2f // $37 - /
                
KeyMatrixColBit7:
                .byte $31 // $38 - 1
                .byte $ff // $39 - <-
                .byte $ff // $3a - CTRL
                .byte $32 // $3b - 2
                .byte $20 // $3c - SPACE
                .byte $ff // $3d - C=
                .byte $51 // $3e - Q
                .byte $ff // $3f - STOP
// ------------------------------------------------------------------------------------------------------------- //
// InitLevel         Function:
//               Parms   : xr=$00 prepared level already existing at 4000-5fff
//                   : xr=$01 level needs to be prepared
//                   // xr=$ff InitLevel failure
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
InitLevel:{

        stx LR_LevelCtrl            // level display control  $00=prepared copy already at 4000-5fff
        ldx #$ff                // init to no lr found
        stx LRZ_LodeRunCol          // actual col lode runner
        inx                     // $00
        stx LR_NumXitLadders        // # hidden ladders
        stx LR_Gold2Get             // # gold
        stx LR_EnmyNo               // # enemies
        stx LR_NoEnemy2Move         // # enemies to move
        stx LRZ_Work                // left right nybble 00=right
        stx LRZ_ScreenRow           // screen row  (00-0f)
        stx $53                 // disk level data offset
        stx $54
        txa                     // $00
        ldx #LR_TabHoleMax          // max 30

    HoleTime:
        sta LR_TabHoleOpenTime,x        // hole open time tab
        dex
        bpl HoleTime
        
        ldx #LR_TabEnemyRebLen          // max 6
    ENReBirthStep:
        sta LR_TabEnemyRebTime,x        // enemy rebirth step time
        dex
        bpl ENReBirthStep
        
        lda #LR_Life
        sta LR_Alive
        lda LR_LevelNoDisk          // 000-149
        cmp LR_LvlReload
        beq SameLevel              // same - no load from disk
        
    NewLevel:
        lda #LR_DiskRead
        jsr ControlDiskOper
        
    SameLevel:
        lda LR_LevelNoDisk          // 000-149
        sta LR_LvlReload            // same - no load from disk
        ldy LRZ_ScreenRow           // screen row  (00-0f)

    ExpandDataI:
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        sta LRZ_XLvlOriRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    
    PtrModify:
        sta LRZ_XLvlModRowHi
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes

    PtrOrigin:
        sta LRZ_XLvlOriRowHi
        lda #$00
        sta LRZ_ScreenCol           // screen col  (00-1b)
        
    GetDataBytes:
        lda LRZ_Work                // control left/right nybble to process  00=right

    Carry4RightLeft:
        lsr                          // carry flag
        
        ldy $53                     // disk level data offset
    GetOneDataByte:
        lda LR_LvlDataSavLod,y          // get a packed level data byte
        bcs LeftNybble             // carry possibly set by !Carry4RightLeft
        
    RightNybble:
        and #$0f                // isolate right nybble
        bpl InitNybbleMark         // always
        
    LeftNybble:
        lsr                   // isolate left nybble
        lsr
        lsr
        lsr
        inc $53                 // both nybbles processed so point to next byte
        
    InitNybbleMark:
        inc LRZ_Work                // force carry set the next round by !Carry4RightLeft
        
        ldy LRZ_ScreenCol           // screen col  (00-1b)
        
    ChkValid:
        cmp #NoTileNumMax+1         // valid byte range is $00-$09
        bcc PutDataBytes              // lower
        
    SetEmpty:
        lda #NoTileBlank            // not valid so store a $00

    PutDataBytes:
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
    
    PutCtrlBytes:
        sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        inc LRZ_ScreenCol           // screen col  (00-1b)
        lda LRZ_ScreenCol           // screen col  (00-1b)
        cmp #LR_ScrnMaxCols + 1           // $1b - max 27 cols
        bcc GetDataBytes
        
        inc LRZ_ScreenRow           // screen row  (00-0f)
        ldy LRZ_ScreenRow           // screen row  (00-0f)
        cpy #LR_ScrnMaxRows + 1           // $0f - max 15 rows
        bcc ExpandDataI
        
    GoCheckLevel:
        jsr CheckLevel

    NoError:
        bcc InitLevelX              // good
        
    LevelError:
        lda LR_LevelNoDisk          // 000-149
        beq GoColdStart
        
        ldx #$00                // force ColdStart the next time
        stx LR_LevelNoDisk          // 000-149
        
    ChkGameSpeed:
        lda LR_CntSpeedLaps
        cmp #LR_CntSpeedMax+1           // max 9
        bcs SetFF
        
        inc LR_CntSpeedLaps         // increase game speed
        
    SetFF:
        dex
    Loop:
        jmp InitLevel               // restart

InitLevelX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
GoColdStart:         jmp ColdStart
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
PackLevel:{
        lda #$00
        sta $53                 // disk level data offset
        sta LRZ_Work                // left/right nybble 00=right
        sta LRZ_ScreenRow           // screen row  (00-0f)

    PackLevelI:
        ldy LRZ_ScreenRow           // screen row  (00-0f)
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes

    PtrModify:
        sta LRZ_XLvlModRowHi
        
        ldy #$00
        sty LRZ_ScreenCol           // screen col  (00-1b)

    GetDataBytes:
        lda LRZ_Work                // control left/right nybble to process  00=right
        lsr

    GetOneDataByte:
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        bcs LeftNybble             // set from lsr prev
        
    RightNybble:
        sta LRZ_ImageNo             // level input tile $00-$09 - store as right nybble
        bpl InitNybbleMark         // always
    
    LeftNybble:
        asl                // isolate left nybble
        asl
        asl
        asl
        ora LRZ_ImageNo             // level input tile $00-$09 - merge with right nybble
        
        ldy $53                 // disk level data offset
    PutOneDataByte:
        sta LR_LvlDataSavLod,y
        
        inc $53                 // disk level data offset
        
    InitNybbleMark:
        inc LRZ_Work                // will set carry the next round
        inc LRZ_ScreenCol           // screen col  (00-1b)
        ldy LRZ_ScreenCol           // screen col  (00-1b)
        cpy #LR_ScrnMaxCols+1           // $1b - max 27 cols
        bcc GetDataBytes
        
        inc LRZ_ScreenRow           // screen row  (00-0f)
        lda LRZ_ScreenRow           // screen row  (00-0f)
        cmp #LR_ScrnMaxRows+1           // $0f - max 15 rows
        bcc PackLevelI
        
PackLevelX:
        rts                     //
} 
// ------------------------------------------------------------------------------------------------------------- //
//               Function: Decide whether a level is to be loaded from disk or not (demo)
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
ControlDiskOper:{
        sta LR_DiskAction           //  - $01=read $02=write $04=init
        
    ChkGameCtrl:
        lda LR_GameCtrl             // $00=start $01=demo $02=game $03=play_level $05=edit
        lsr                        // 
        beq IsDemo                 // 
        
    IsGame:
        jmp DiskRW                  // only game levels have to be loaded
        
    IsDemo:
        lda LR_LevelNoDisk          // 000-149
        cmp #LR_LevelNoMaxDmo           // max built in demo levels
        bcc SetDemoLvlData
        
    RestartDemo:
        lda #$00                // restart at level 1
        sta LR_LevelNoDisk          // 000-149
        
    SetDemoLvlData:
        asl                    // !hbu005!
        tay                     // !hbu005!
        lda TabDemoLvlData,y        // !hbu005!
        sta _ModCpyDemoLvlL        // !hbu005!
        lda TabDemoLvlData+1,y          // !hbu005!
        sta _ModCpyDemoLvlH        // !hbu005!
        
    SetDemoLvlMoves:
        lda TabDemoLvlMoves,y           // !hbu005!
        sta LRZ_DemoMoveDatLo           // !hbu005!
        lda TabDemoLvlMoves+1,y         // !hbu005!
        sta LRZ_DemoMoveDatHi           // !hbu005! - ($55/$56) -> DemoMoveData
        
        ldy #$00
    CpyDemoLvlData:
        lda TabDemoLevels,y         // !hbu005! - get demo level data
    .label _ModCpyDemoLvlH   = *-1
    .label _ModCpyDemoLvlL   = *-2                 // !hbu005!
        sta LR_LvlDataSavLod,y
        iny
        bne CpyDemoLvlData
        
ControlDiskOperX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
TabDemoLvlData:
        .word TabDemoDataLvl01 
        .word TabDemoDataLvl02 
        .word TabDemoDataLvl03 
        .word TabDemoDataLvl01 
TabDemoLvlMoves:
        .word TabDemoMoveLvl01          // must be called one after the other
        .word TabDemoMoveLvl02          // otherwise enemy behaviour differs
        .word TabDemoMoveLvl03
        .word TabDemoMoveLvl04
// ------------------------------------------------------------------------------------------------------------- //
// GetPutHiScores    Function:
//               Parms   : ac=action $01=load $02=store
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetPutHiScores:{
        tax                     // save action $01=load $02=store
        
        lda LR_LevelNoDisk          // 000-149
        pha                     // save actual disk level no
        
    SavBufferPtr:
        lda ExecDiskCmdRead.Mod_GetDiskByte         // - save pointer
        pha
        
    SetScoreBuffer:
        lda #>LR_ScoreSavLod        // 
        sta ExecDiskCmdRead.Mod_GetDiskByte         //  - set to LR_ScoreSavLod
        sta ExecDiskCmdWrite.Mod_PutDiskByte         // 
        lda #LR_LevelDiskScor           // disk level 151 is the high score store
        sta LR_LevelNoDisk          // 000-149 151/152
        txa                     // restore action $01=load $02=store
        jsr ControlDiskOper
        
        pla                     // 
    ResScoreBuffer:
        sta ExecDiskCmdRead.Mod_GetDiskByte         //  - reset to old value
        sta ExecDiskCmdWrite.Mod_PutDiskByte
        
        pla                     // restore disk level no
        sta LR_LevelNoDisk          // 000-149
        
        ldy #LR_HiScoreIdLen        // length lr disk id
    ChkDiskID:
        lda LR_HiScoreDiskId,y          // lr disk id
        cmp TabLrDiskId,y           // 
        bne ClrScoresI             // 
        
        dey                     // 
        bpl ChkDiskID              // 
        
    ChkMasterDisk:
        lda #LR_DiskMaster          // $01 - disk in drive is a load runner master disk
        ldx LR_HiScoreDiskUM        // offset indicator store in high score block
        bne GetPutHiScoresX         // master disk
        
    SetUserDisk:
        lda #LR_DiskData            // mark disk in drive as a load runner user disk
        rts
        
    ClrScoresI:
        ldy #$00                // 
        tya                     // 

    ClrScores:
        sta LR_ScoreSavLod,y        //  - clear the score buffer
        dey                     // 
        bne ClrScores              // 
        
        ldy #LR_HiScoreIdLen        //  - "DANE BIGHAM"
    SetScoresID:
        lda TabLrDiskId,y           // 
        sta LR_HiScoreDiskId,y          // 
        dey                     // 
        bpl SetScoresID            // 
        
        iny
        sty LR_HiScoreDiskUM        //  - mark as user data disk
        
    SetBadDisk:
        lda #LR_DiskNoData          // return no load runner data disk this time
GetPutHiScoresX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// Xmit          Function: Transmit the active level to drive 9
//               Parms   :
//               Returns :
//               ID      : !hbu017!
// ------------------------------------------------------------------------------------------------------------- //
Xmit:{
        lda LR_LevelNoXmit          // target level no
        ldx #$09                // drive no
        jsr SetDiskCmd              // 
        bcs DiskError              // disk error
        
    DiskOk:
        jsr ExecDiskCmdWrite        // write block
        
        lda #$d8                // "X"
        sta Mod_InfoTxt1            // 
        lda #$cd                // "M"
        sta Mod_InfoTxt2            // 
        lda #$c9                // "I"
        sta Mod_InfoTxt3            // 
        jsr XmitInfo                // message
        
        inc LR_LevelNoXmit          // set next xmit level
    ExitOK:
        rts                     // 
                
    DiskError:
            jsr Beep                // double beep/reset and return
            jsr Beep                // 
XmitX:
        jmp ResetDisk               // 
}
// ------------------------------------------------------------------------------------------------------------- //
// XmitInfo          Function: Print an info message after successful xmit and wait for user key
//               Parms   :
//               Returns :
//               ID      : !hbu017!
// ------------------------------------------------------------------------------------------------------------- //
XmitInfo:{
        ldx LR_LevelNoXmit          // xmit target    000-149
        inx                     // display target 001-150
        txa
    Split:
        jsr ConvertHex2Dec          // 1307=100 1308=10 1309=1
        
    InfoGet100:
        lda LR_Digit100             // 
    Prepare100:
        clc                     // 
        adc #NoDigitsMin            // map to digit image data numbers              
    InfoSet100:
        sta InfoMsg100             // 
    InfoGet10:
        lda LR_Digit10              // 
    Prepare10:
        clc                     // 
        adc #NoDigitsMin            // map to digit image data numbers              
    InfoSet10:
        sta InfoMsg10              // 
    InfoGet1:
        lda LR_Digit1               // 
    Prepare1:
        clc                     // 
        adc #NoDigitsMin            // map to digit image data numbers              
    InfoSet1:
        sta InfoMsg1               // 

    InfoClearMsg:
        jsr ClearMsg                // 
    
    InfoSetOutput:
        lda #>LR_ScrnHiReDisp           // 
        sta LRZ_GfxScreenOut        // output to display screen only
        
    InfoSetDisplay:
        jsr LvlEdCurSetMsg          // prepare display
        jsr TextOut                 // <lvl xmit>
    InfoColorSet:
       lda #HR_YellowYellow        // game message color
        sta ColorMsg.Mod_ColorMsg
XmitInfoX:
        jmp ColorMsg                // 
}
InfoMsg:
                    .byte $cc // L                // 
                    .byte $d6 // V                // 
                    .byte $cc // L                // 
                    .byte $a0 // <blank>          // 
InfoMsg100:
                    .byte $a0 // <blank>          // 
InfoMsg10:
                    .byte $a0 // <blank>          // 
InfoMsg1:
                    .byte $a0 // <blank>          // 
                    .byte $a0 // <blank>          // 
Mod_InfoTxt1:       .byte $d8 // X                // 
Mod_InfoTxt2:       .byte $cd // M                // 
Mod_InfoTxt3:       .byte $c9 // I                // 
                    .byte $d4 // T                // 
                    .byte $a0 // <blank>          // 
                    .byte $cf // O                // 
                    .byte $cb // K                // 
                    .byte $00 // EndOfText        // 
        
// ------------------------------------------------------------------------------------------------------------- //
// DiskRW        Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
DiskRW:{
        lda #$00
        sta SPENA                   // VIC 2 - $D015 = Sprite Enable
        
    SetDiscCmd:
        lda LR_LevelNoDisk          // target level no
        ldx #$08                // drive no
        jsr SetDiskCmd
        bcc GetMode
        jmp DiskError               // disk error so DiskError
        
    GetMode:
        lda LR_DiskAction           // read/write/init
        lsr
    ReadBlock:
        bcs ExecDiskCmdRead

        lsr
    InitDisk:
        bcc ClearDataI

    WriteBlock:
        jmp ExecDiskCmdWrite
    
    ClearDataI:
        ldy #NoTileBlank
        tya
    ClearData:
        sta LR_HiScore,y            // clear high score storage
        sta LR_LvlDataSavLod,y          // clear level storage
        iny
        bne ClearData
        
        lda #LR_LevelDiskMax        // 149 blocks to write
        sta LR_LevelNoDisk          // 000-149
        jsr CLALL                   // KERNAL - $FFE7 = Close all Files
        
    PutClearedData:
        lda #LR_DiskWrite           // write 150 empty levels to disk
        jsr ControlDiskOper
        
        dec LR_LevelNoDisk          // 000-149
        lda LR_LevelNoDisk          // 000-149
        cmp #$ff
        bne PutClearedData
        
        ldy #LR_HiScoreIdLen        // length lr id
    SetDiskID:
        lda TabLrDiskId,y           // lr disk id=DANE BIGHAM
        sta LR_HiScoreDiskId,y          // store as lr disk id in high score data block
        dey
        bpl SetDiskID
        
        iny                     // $00 - LR_DiskNoData
        sty LR_HiScoreDiskUM        // offset indicator store in high score block
    PutClearedScore:
        lda #LR_DiskWrite
        jsr GetPutHiScores          // Target: $1100-$11ff
        
DiskRWX:
        rts
}

DiskError:{
        jmp StartGraphicOut
}
// ------------------------------------------------------------------------------------------------------------- //
TabLrDiskId:
        .byte $c4 // D
        .byte $c1 // A
        .byte $ce // N
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $c2 // B
        .byte $c9 // I
        .byte $c7 // G
        .byte $c8 // H
        .byte $c1 // A
        .byte $cd // M

// ExecDiskCmdRead   Function: Generate Command for Disk Block Read
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
ExecDiskCmdRead:{
        lda #$31                    //ASCII Char "1"
        sta BlkRWCmd                // u1=read
        jsr CLRCHN                  // KERNAL - $FFCC = Restore Default Devices
        
        ldx #$0f                // command channel
        jsr CHKOUT                  // KERNAL - $FFC9 = Define an Output Channel
        bcs DiskError
        
        ldy #$00
    CmdOut:
        lda BlkRWCmdString,y        // u1:02_0_tt_ss
        beq ChkDiskCC
        
        jsr CHROUT                  // KERNAL - $FFD2 = Output a Character
        iny
        jmp CmdOut

    ChkDiskCC:
        jsr CheckDiskCC
        jsr CLRCHN                  // KERNAL - $FFCC = Restore Default Devices
        ldx #$02                // data channel
        jsr CHKIN                   // KERNAL - $FFC6 = Define an Input Channel
        bcs DiskError

        jsr CHRIN                   // KERNAL - $FFCF = Input a Character

    ChkMirror:
        lda LR_Mirror               // !hbu012! - ceck mirror flag
    GetMirror:
        bmi MirrorLevel             // !hbu012! - read in the level mirrored
        
        ldy #$00
    ChrIn:
        jsr CHRIN                   // KERNAL - $FFCF = Input a Character
        sta LR_LvlDataSavLod,y          // get disk data byte
.label Mod_GetDiskByte = * -1
        iny
        bne ChrIn
        
ExecDiskCmdReadX:
        jmp ResetDisk
}
// ------------------------------------------------------------------------------------------------------------- //
// ExecDiskCmdWrite   Function: Generate Command for Disk Block Write
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
ExecDiskCmdWrite:{
        lda #$32                    //"2"
        sta BlkRWCmd                // u2=write
        jsr CLRCHN                  // KERNAL - $FFCC = Restore Default Devices
        
        ldx #$02                // data channel
        jsr CHKOUT                  // KERNAL - $FFC9 = Define an Output Channel
        bcs DiskError
        
        ldy #$00
    ChrOut:
        lda LR_LvlDataSavLod,y          // put data byte
.label Mod_PutDiskByte  = *-1
        jsr CHROUT                  // KERNAL - $FFD2 = Output a Character
        iny
        bne ChrOut
        jsr CLRCHN                  // KERNAL - $FFCC = Restore Default Devices
        
        ldx #$0f                // command channel
        jsr CHKOUT                  // KERNAL - $FFC9 = Define an Output Channel
        ldy #$00
    CmdOut:
        lda BlkRWCmdString,y        // u2:02_0_tt_ss
        beq ChkDiskCC
        
        jsr CHROUT                  // KERNAL - $FFD2 = Output a Character
        iny
        jmp CmdOut
        
    ChkDiskCC:
        jsr CheckDiskCC
        
CalcDiskCmdX:
        jmp ResetDisk
}
// ------------------------------------------------------------------------------------------------------------- //
// MirrorLevel       Function: Load mirrored level from disk
//               Parms   : 
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MirrorLevel:{
        ldx #LR_ScrnMaxRows + 1
    InitCol:
        ldy #LR_ScrnMaxCols / 2

    GetChr:
        jsr CHRIN                   // get a chr from disk
        sta LR_Work                 // save
        lsr LR_Work                 // shift right nybble to the left
        lsr LR_Work
        lsr LR_Work
        lsr LR_Work
        asl                     // shift left nybble to the right
        asl
        asl
        asl
        ora LR_Work                 // insert former right nybble to the left

    MirrorOut:
        sta LR_LvlDataSavLod,y          // store swapped level byte

.label _ModMirrorOut  = *-2
        dey
        bpl GetChr
        
    SetNextRow:
        lda _ModMirrorOut
        clc
        adc #$0e
        sta _ModMirrorOut

    SetNextCol:
        dex
        bne InitCol

    InitXtra:
        ldy #$00                // xtra level data must not be swapped
        ldx #$1f

    GetXtraData:
        jsr CHRIN
        sta LR_LevelXtra,y
        iny
        dex
        bne GetXtraData

    PtrReset:
       lda #<LR_LvlDataSavLod          // reset mirror out
        sta _ModMirrorOut

MirrorLevelX:
        jmp ResetDisk
}
// ------------------------------------------------------------------------------------------------------------- //
// SetDiskCmd        Function: Generate the block access command 
//               Parms   : ac=level_no xr=drive_no
//               Returns : carry clear=ok  carry set=disc error
// ------------------------------------------------------------------------------------------------------------- //
SetDiskCmd:{
        sta LR_DiscCmdLevel
        stx LR_DiscCmdDriveNo
        
        jsr CLALL                   // KERNAL - $FFE7 = Close all Files
        
        lda LR_DiscCmdLevel         // 000-149
        and #$0f                // isolate right nybble for sector calculation
        tax
        lda TabSecHi,x
    !PutSectorHi:
        sta BlkRWSecHi
        lda TabSecLo,x
    !PutSectorLo:
        sta BlkRWSecLo
        lda LR_DiscCmdLevel         // 000-149
        lsr                        // isolate left nybble for track calculation
        lsr 
        lsr 
        lsr 
        tax
        lda TabTrkHi,x
    !PutTrackHi:
        sta BlkRWTrkHi
        lda TabTrkLo,x
    !PutTrackLo:
        sta BlkRWTrkLo
        
    !CmdChannel:
        lda #$00
        jsr SETNAM                  // KERNAL - $FFBD = Set Filename Parameters
        
        lda #$0f
        ldx LR_DiscCmdDriveNo
        ldy #$0f
        jsr SETLFS                  // KERNAL - $FFBA = Set Logical File Parameters
        jsr OPEN                // KERNAL - $FFC0 = Open a Logical File
        bcs SetDiskCmdX             // disk error exit
        
    !DataChannel:
        lda #$01                // length data set name
        ldx #<FileNameString        // '#'
        ldy #>FileNameString
        jsr SETNAM                  // KERNAL - $FFBD = Set Filename Parameters
        
        lda #$02
        ldx LR_DiscCmdDriveNo
        ldy #$02
        jsr SETLFS                  // KERNAL - $FFBA = Set Logical File Parameters
        jsr OPEN                // KERNAL - $FFC0 = Open a Logical File
        
SetDiskCmdX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
FileNameString:     .byte $23 // #
DiskInitString:     .byte $55 // u
                    .byte $2b // +
                    .byte $0d // <enter>
                    .byte $00 // <end>

BlkRWCmdString:     .byte $55 // u
BlkRWCmd:           .byte $31 // 1
                    .byte $3a // :
                    .byte $30 // 0
                    .byte $32 // 2
                    .byte $20 // <blank>
                    .byte $30 // 0
                    .byte $20 // <blank>
BlkRWTrkHi:         .byte $30 // 0 - Track
BlkRWTrkLo:         .byte $33 // 3 - Track
                    .byte $20 // <blank>
BlkRWSecHi:         .byte $30 // 0 - Sector
BlkRWSecLo:         .byte $30 // 0 - Sector
                    .byte $0d // <enter>
                    .byte $00 // <end>
// ------------------------------------------------------------------------------------------------------------- //
TabTrkHi:            .byte $30, $30, $30, $30, $30, $30, $30, $31, $31, $31, $31, $31, $31, $31, $31, $31
TabTrkLo:            .byte $33, $34, $35, $36, $37, $38, $39, $30, $31, $32, $33, $34, $35, $36, $37, $39 // omit dir
                
TabSecHi:            .byte $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $31, $31, $31, $31, $31, $31
TabSecLo:            .byte $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $30, $31, $32, $33, $34, $35
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
CheckDiskCC:{
        jsr CLRCHN                  // KERNAL - $FFCC = Restore Default Devices
        
        ldx #$0f
        jsr CHKIN                   // KERNAL - $FFC6 = Define an Input Channel
        jsr CHRIN                   // KERNAL - $FFCF = Input a Character
        
        sta LRZ_Work
        jsr CHRIN                   // KERNAL - $FFCF = Input a Character
        
        ora LRZ_Work
        sta LRZ_Work
    ChrIn:
        jsr CHRIN                   // KERNAL - $FFCF = Input a Character
        cmp #$0d                // ENTER
        bne ChrIn
        
        lda LRZ_Work
        cmp #$30
        beq CheckDiskCCX
        
        jmp ColdStart
        
CheckDiskCCX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
ResetDisk:{
        jsr CLRCHN                  // KERNAL - $FFCC = Restore Default Devices
        
        ldx #$0f
        jsr CHKOUT                  // KERNAL - $FFC9 = Define an Output Channel
        
        ldy #$00
    CpyCmd:
        lda DiskInitString,y        // u+
        beq ResetDiskX
        
        jsr CHROUT                  // KERNAL - $FFD2 = Output a Character
        
        iny
        jmp CpyCmd
        
ResetDiskX:
        jmp CLALL                   // KERNAL - $FFE7 = Close all Files
}
// ------------------------------------------------------------------------------------------------------------- //
// CheckLevel        Function:
//               Parms   : $03 set to $ff - let the first compare always work
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
CheckLevel:{
        lda #$00                // off
        sta SPENA                   // VIC 2 - $D015 = Sprite Enable
        
        ldy #LR_ScrnMaxRows         // $0f - max 15 rows => start at bottom of screen
        sty LRZ_ScreenRow           // screen row  (00-0f)
        
    SetLevelPtr:
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        sta LRZ_XLvlOriRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes

    PtrModify:
        sta LRZ_XLvlModRowHi
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes

    PtrOrigin:
        sta LRZ_XLvlOriRowHi
        ldy #LR_ScrnMaxCols         // start at end of each line = $1b - max 27 cols
        sty LRZ_ScreenCol           // screen col  (00-1b)
        
    GetLevelByte:
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        ldx LR_LevelCtrl            // level display control  $00=prepared copy already at $4000-$5fff
        beq ToGoGfxOutPrep

    ChkXitLadder:
        cmp #NoTileLadderSec        // hidden ladder
        bne ChkGold
        
        ldx LR_NumXitLadders        // # hidden ladders
        cpx #LR_NumXitLdrsMax           // 
        bcs SetEmptyByte
        
    IncXitLadder:
        inc LR_NumXitLadders        // count  - inc no of hidden ladders
        
    PutXitLadderAdr:
        inx
        lda LRZ_ScreenRow           // screen row  (00-0f)
        sta LR_TabXitLdrRow,x           // adr row hidden ladders tab
        tya
        sta LR_TabXitLdrCol,x           // adr column hidden ladder tab
        
    SetEmptyByte:
        lda #NoTileBlank            // blank for hidden ladder/enemy
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes

    ToGoGfxOutPrep:
        beq GoGfxOutPrep           // always
        
    ChkGold:
        cmp #NoTileGold
        bne ChkEnemy
        
    IncGold:
        inc LR_Gold2Get             // count  - inc no of gold to get
        bne GoGfxOutPrep
        
    ChkEnemy:
        cmp #NoTileEnemy
        bne ChkLodeRunner

        ldx LR_EnmyNo               // number of enemies
    ChkEnemyMax:
        cpx #LR_EnmyNoMax           // max 5
        bcs SetEmptyByte           // geater/equal

    IncEnemy:
        inc LR_NoEnemy2Move         // count - inc no of enemies to move
        inc LR_EnmyNo               // count - inc no of enemies

    PutEnemyData:
        inx
        tya
    PutEnemyCol:
        sta LR_TabEnemyCol,x        // adr column enemies              
        lda LRZ_ScreenRow           // screen row  (00-0f)
    PutEnemyRow:
        sta LR_TabEnemyRow,x        // adr row enemies

        lda #$00
    PutEnemyGold:
        sta LR_TabEnemyGold,x           // enemy has gold tab

    PutEnemyNo:
        sta LR_TabEnemySprNo,x          // actual enemy sprite number
    
        lda #$02                // center to
    PutEnemyCenter:
        sta LR_TabEnemyPosLR,x          // enemy pos on image left/right tab
        sta LR_TabEnemyPosUD,x          // enemy pos on image up/down tab
    
    ClrEnemyGfx:
        lda #NoTileBlank
        sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        jsr ImageOut2Prep           // direct output to preparation screen

        lda #NoTileEnemy
    SetEnemyGfx:
        bne GoGfxOutPrep           // always
    
    GoSetLevelPtr:
        bpl SetLevelPtr
    GoGetLevelByte:
        bpl GetLevelByte
                
    ChkLodeRunner:
        cmp #NoTileLodeRunner
        bne ChkTrap
        
        ldx LRZ_LodeRunCol          // actual col lode runner
    ChkLodeRrExist:
        bpl SetEmptyByte           // one lr found already so blank out this one
    
    SetLodeRrCol:
        sty LRZ_LodeRunCol          // actual col lode runner
    
        ldx LRZ_ScreenRow           // screen row  (00-0f)
    SetLodeRrRow:
        stx LRZ_LodeRunRow          // actual row lode runner
    
    SetLodeRrCenter:
        ldx #$02                // center to
        stx LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
        stx LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        
    SetLodeRrSprtNo:
        ldx #NoLR_RunRiMin
        stx LRZ_LodeRunSpriteNo         // lr sprite number
        
        lda #NoTileBlank
        sta (LRZ_XLvlOriPos),y          // clear lr in original level data - without lr/en replacements/holes
    ClrLodeRrGfx:
        jsr ImageOut2Prep           // direct output to preparation screen
        lda #NoSprite_RuRi00        // !hbu008!
    SetLodeRrGfx:
        bne GoGfxOutPrep           // always
    
    ChkTrap:
        cmp #NoTileWallTrap
        bne GoGfxOutPrep
        
        lda #NoTileWallWeak

    GoGfxOutPrep:
        jsr ImageOut2Prep           // direct output to preparation screen

    SetPrevCol:
         dec LRZ_ScreenCol           // next screen col  (00-1b) bottom up
        ldy LRZ_ScreenCol           // screen col  (00-1b)
        bpl GoGetLevelByte

    SetPrevRow:
        dec LRZ_ScreenRow           // next screen row  (00-0f) bottom up
        ldy LRZ_ScreenRow           // screen row  (00-0f)
        bpl GoSetLevelPtr
        
        lda LR_LevelCtrl            // level display control  $00=prepared copy already at $4000-$5fff
        beq ScreenPrep2Disp         // copy prepared hires screen data to display screen
        
        lda LRZ_LodeRunCol          // actual col lode runner
        bpl ResetEnmyLodeR          // lode runner tile found
        
    SetError:
        sec                     // no lode runner tile found
CheckLevelX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// ScreenPrep2Disp   Function: Copy prepared HiRes Screen Data to HiRes Display Screen
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
ScreenPrep2Disp:{
        lda LR_GameCtrl             // !hbu001! - $00=start $01=demo $02=game $03=play_level $05=edit
        cmp #LR_GameEdit            // 
        beq ChkMsg                 // !hbu001! - edit colors already set
        
        jsr ColorLevelDyn           // !hbu001! - get new colors every 10th level
        jsr ColorLevel              // !hbu001! - set new colors
        
    ChkMsg:
        lda LR_ScrnMCMsg - 1        //  - status line msg color game
        cmp LR_ScrnMCMsg            //  - status line msg part colour
        bne Init
        
        jsr ClearMsg                // 
        
    Init:
        lda #>LR_ScrnHiReDisp           // to:   display hires screen
        sta $12
        lda #>LR_ScrnHiRePrep           // from: prepare hires screen for direct output
        sta $10
        
        lda #$00
        sta $11
        sta $0f
        
        tay
    Copy:
        lda ($0f),y
        sta ($11),y
        iny
        bne Copy
        
        inc $12
        inc $10
        
        ldx $10
        cpx #>[LR_ScrnHiRePrep + $2000] // end of screen data $5fff reached
        bcc Copy                   // no
        
        jsr ColorStatus             // !hbu001! - after copy to avoid a recolor when VictoryMsg is still set
        
    SetNoError:
        clc
        
ScreenPrep2DispX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// ResetEnmyLodeR    Function: Blank out Lode Runner and Enemies in preparation screen
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
ResetEnmyLodeR:{
        lda #>LR_ScrnHiRePrep           // $40
        sta LRZ_GfxScreenOut        // target output  $20=$2000 $40=$4000
        jsr BaseLines
        jsr ScreenPrep2Disp         // copy prepared hires screen data to display screen
        
        lda #>LR_ScrnHiReDisp           // $20
        sta LRZ_GfxScreenOut        // target output  $20=$2000 $40=$4000
        
    SetMaxRows:
        ldy #LR_ScrnMaxRows         // $0f - max 15 rows
        sty LRZ_ScreenRow           // screen row  (00-0f)
        
    SetLevelDataPtr:
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    PtrModify:
        sta LRZ_XLvlModRowHi
        
    SetMaxCols:
        ldy #LR_ScrnMaxCols         // $1b - max 27 cols
        sty LRZ_ScreenCol           // screen col  (00-1b)
        
    GetData:
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
    ChkLodeRunner:
        cmp #NoTileLodeRunner
        beq SetBlank
        
    ChkEnemy:
        cmp #NoTileEnemy
        bne NextOutCol
        
    SetBlank:
        lda #NoTileBlank            // blank substitution
        jsr ImageOut2Prep           // direct output to preparation screen
        
    NextOutCol:
        dec LRZ_ScreenCol           // screen col  (00-1b)
        ldy LRZ_ScreenCol           // screen col  (00-1b)
        bpl GetData
        
    NextOutRow:
        dec LRZ_ScreenRow           // screen row  (00-0f)
        ldy LRZ_ScreenRow           // screen row  (00-0f)
        bpl SetLevelDataPtr
        
        clc
ResetEnmyLodeRX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// MoveLodeRunner    Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MoveLodeRunner:{
        lda #LR_GetGoldGot
        sta LR_GetGold              // get gold  $00=just gets it
        
        lda LR_Shoots               // $00=no $01=right $ff=left
        beq !MoveLR+
        bpl !GoFireRightLR+
        
    !GoFireLeftLR:
        jmp LRFireLeft
    !GoFireRightLR:
        jmp LRFireRight
        
    !MoveLR:
        ldy LRZ_LodeRunRow          // actual row lode runner
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes  = data �under� lr
        cmp #NoTileLadder
        beq !GoChkFallDown+
        
        cmp #NoTilePole
        bne !GetPosUD+
        
        lda LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        cmp #$02                // in middle of screen image
        beq !GoChkFallDown+
        
    !GetPosUD:
        lda LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        cmp #$02                // in middle of screen image
        bcc !SetFallDown+
        
        ldy LRZ_LodeRunRow          // actual row lode runner
        cpy #LR_ScrnMaxRows         // $0f - max 15 rows
        beq !GoChkFallDown+          // bottom reached
        
        lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        sta LRZ_XLvlOriRowLo
        lda TabExLvlModRowHi+1,y        // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    !PtrModifyBelow:
        sta LRZ_XLvlModRowHi
        lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOriginBelow:
        sta LRZ_XLvlOriRowHi
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes + 1
        cmp #$00                // nothing
        beq !SetFallDown+
        
        cmp #NoTileEnemy
        beq !GoChkFallDown+
        
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        cmp #NoTileWallWeak
        beq !GoChkFallDown+
        
        cmp #NoTileWallHard
        beq !GoChkFallDown+
        
        cmp #NoTileLadder
        bne !SetFallDown+
        
    !GoChkFallDown:
        jmp !EndFallDown+
        
    !SetFallDown:
        lda #LR_Falls
        sta LR_FallsDown            // $00=fall $20=no fall $ff=init
        dec LR_FallBeep
        jsr GetLRGfxOff
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        
        lda #NoLR_FallLe
        ldx $08                 // control shooter mode
        bmi !SetSpriteNo+
        
        lda #NoLR_FallRi
        
    !SetSpriteNo:
        sta LRZ_LodeRunSpriteNo         // lr sprite number
        jsr MovLRWaitPosX
        
        inc LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        lda LRZ_LodeRunOnImgPosUD
        cmp #$05                        // max
        bcs !InitPosUD+
        
        jsr MovLRGold                   // wait for center and handle the gold
        jmp MovLRKill
        
    !InitPosUD:
        lda #$00
        sta LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        
        ldy LRZ_LodeRunRow              // actual row lode runner
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        sta LRZ_XLvlOriRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    !PtrModify01:
        sta LRZ_XLvlModRowHi
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin01:
        sta LRZ_XLvlOriRowHi
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        cmp #NoTileWallWeak
        bne !Store+
        
        lda #NoTileBlank            // empty substitution
        
    !Store:
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        inc LRZ_LodeRunRow              // actual row lode runner
        ldy LRZ_LodeRunRow              // actual row lode runner
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    
    !PtrModifyBelow01:
        sta LRZ_XLvlModRowHi
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda #NoTileLodeRunner
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        jmp MovLRKill
        
    !EndFallDown:
        lda LR_FallsDown            // $00=fall $20=no fall $ff=init
        bne !Always+
        
    !Always:
        lda #LR_FallsNo             // end
        sta LR_FallsDown            // $00=fall $20=no fall $ff=init
        
        jsr GetPlayCmd              // test in game commands
        
        lda LR_JoyUpDo
    !ChkMoveUp:
        cmp #LR_JoyMoveUp           // move up
        bne !ChkMoveDown+
        
    !MoveUp:
        jsr MovLRUp
        bcs !ChkMoveLeft+
        rts
        
    !ChkMoveDown:
        cmp #LR_JoyMoveDo           // move down
        bne !ChkFireLeft+
    !MoveDown:
        jsr LRMoveDown
        bcs !ChkMoveLeft+
        rts
        
    !ChkFireLeft:
        cmp #LR_JoyFireLe           // fire left
        bne !ChkFireRight+
    !FireLeft:
        jsr MovLRFireLeft
        bcs !ChkMoveLeft+
        rts
        
    !ChkFireRight:
        cmp #LR_JoyFireRi           // fire right
        bne !ChkMoveLeft+
    !FireRight:
        jsr MovLRFireRight
        bcs !ChkMoveLeft+
        rts
        
    !ChkMoveLeft:
        lda LR_JoyLeRi
        cmp #LR_JoyMoveLe           // move left
        bne !ChkMoveRight+
        
    !MoveLeft:
        jmp MovLRLeft
        
    !ChkMoveRight:
        cmp #LR_JoyMoveRi           // move right
        bne !MoveLodeRunnerX+
    !MoveRight:
        jmp LRMoveRight
        
    !MoveLodeRunnerX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
MovLRLeft:{
        ldy LRZ_LodeRunRow              // actual row lode runner
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        sta LRZ_XLvlOriRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    !PtrModify:
        sta LRZ_XLvlModRowHi
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi
        ldx LRZ_LodeRunOnImgPosLR
        cpx #$03
        bcs MovLRLeftABit               // not yet in center so MovLRLeftABit
        
        ldy LRZ_LodeRunCol              // actual col lode runner
        beq !MovLRLeftX+
        
        dey
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        cmp #NoTileWallHard
        beq !MovLRLeftX+
        
        cmp #NoTileWallWeak
        beq !MovLRLeftX+
        
        cmp #NoTileWallTrap
        bne MovLRLeftABit
        
    !MovLRLeftX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
MovLRLeftABit:{
        jsr GetLRGfxOff
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        
        lda #$ff
        sta $08                 // control shooter mode
        jsr MovLRWaitPosY
        
        dec LRZ_LodeRunOnImgPosLR       // lr pos on image left/right = one step left
        bpl Gold                   // move from actual to next left field not yet complete
        
    NewField:
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        cmp #NoTileWallWeak
        bne Store
        
        lda #NoTileBlank            // empty substitution
        
    Store:
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
        dec LRZ_LodeRunCol          // actual col lode runner
        dey
        lda #NoTileLodeRunner
    SetLR:
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        lda #$04                // max right to
        sta LRZ_LodeRunOnImgPosLR       //   lr pos on image left/right
        bne SetNextPos             // always
        
    Gold:
        jsr MovLRGold               // wait for center and handle the gold
        
    SetNextPos:
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        cmp #NoTilePole
        beq PoleImage
        
    RunImage:
        lda #NoLR_RunLeMin          // low image no
        ldx #NoLR_RunLeMax          // high image no
        bne OutImage
        
    PoleImage:
        lda #NoLR_PoleLeMin         // low image no
        ldx #NoLR_PoleLeMax         // high image no
    OutImage:
        jsr MovLRSetImg
        
MovLRLeftABitX:
        jmp MovLRKill
}
// ------------------------------------------------------------------------------------------------------------- //
LRMoveRight:{
        ldy LRZ_LodeRunRow          // actual row lode runner
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        sta LRZ_XLvlOriRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    PtrModify:
        sta LRZ_XLvlModRowHi
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    PtrOrigin:
        sta LRZ_XLvlOriRowHi
        
        ldx LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
        cpx #$02
        bcc MovLRRightABit          // not yet in center so MovLRRightABit
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        cpy #LR_ScrnMaxCols         // $1b - max 27 cols
        beq LRMoveRightX
        
        iny
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        cmp #NoTileWallHard
        beq LRMoveRightX
        
        cmp #NoTileWallWeak
        beq LRMoveRightX
        
        cmp #NoTileWallTrap
        bne MovLRRightABit
        
LRMoveRightX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
MovLRRightABit:{
        jsr GetLRGfxOff
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        
        lda #$01
        sta $08                 // control shooter mode
        jsr MovLRWaitPosY
        
        inc LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
        lda LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
        cmp #$05                // max
        bcc Gold
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        cmp #NoTileWallWeak
        bne Store
        
        lda #NoTileBlank            // empty substitution
    Store:
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
        inc LRZ_LodeRunCol          // actual col lode runner
        iny
        lda #NoTileLodeRunner
    SetLR:
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        lda #$00
        sta LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
        beq SetNextPos             // always
        
    Gold:
        jsr MovLRGold               // wait for center and handle the gold
        
    SetNextPos:
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        cmp #NoTilePole
        beq PoleImage
        
    RunImage:
        lda #NoLR_RunRiMin          // low image no
        ldx #NoLR_RunRiMax          // high image no
        bne OutImage
        
    PoleImage:
        lda #NoLR_PoleRiMin         // low image no
        ldx #NoLR_PoleRiMax         // high image no
    OutImage:
        jsr MovLRSetImg
        
MovLRRightABitX:
        jmp MovLRKill
}
// ------------------------------------------------------------------------------------------------------------- //
MovLRUp:{
        ldy LRZ_LodeRunRow          // actual row lode runner
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes

    PtrOrigin:
        sta LRZ_XLvlOriRowHi
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes = data �under� lr
        cmp #NoTileLadder
        beq MovLRUpABit
        
        ldy LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        cpy #$03                // in center
        bcc MovUpXitSetCarry        // no
        
        ldy LRZ_LodeRunRow          // actual row lode runner
        lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo
        lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
    
    PtrOriginBelow:
        sta LRZ_XLvlOriRowHi
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes + 1 = data below lr
        cmp #NoTileLadder
        beq MovLRUpABit.MovUpGetGfxOff
}
        
MovUpXitSetCarry:{
        sec
MovLRUpX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
MovLRUpABit:{
        ldy LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        cpy #$03                // in center
        bcs MovLRUpABit.MovUpGetGfxOff          // equal/higher
        
        ldy LRZ_LodeRunRow          // actual row lode runner
        beq MovUpXitSetCarry
        
        lda TabExLvlDatRowLo-1,y        // expanded level data row pointer lo
        sta LRZ_XLvlModRowLo
        lda TabExLvlModRowHi-1,y        // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    PtrModifyAbove:
        sta LRZ_XLvlModRowHi
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes - 1 = data above lr
        cmp #NoTileWallWeak
        beq MovUpXitSetCarry
        
        cmp #NoTileWallHard
        beq MovUpXitSetCarry
        
        cmp #NoTileWallTrap
        beq MovUpXitSetCarry
        
    MovUpGetGfxOff:
        jsr GetLRGfxOff
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        
        ldy LRZ_LodeRunRow          // actual row lode runner
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        sta LRZ_XLvlOriRowLo

        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    PtrModify:
        sta LRZ_XLvlModRowHi
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    PtrOrigin:
        sta LRZ_XLvlOriRowHi
        jsr MovLRWaitPosX
        
        dec LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        bpl MovUpDownGold
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        cmp #NoTileWallWeak
        bne Store
        
        lda #NoTileBlank            // empty substitution
        
    Store:
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        dec LRZ_LodeRunRow          // actual row lode runner
        ldy LRZ_LodeRunRow          // actual row lode runner
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes

    PtrModifyAbove01:
        sta LRZ_XLvlModRowHi
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda #NoTileLodeRunner
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        lda #$04
        sta LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        bne MovUpDown               // always
        
    MovUpDownGold:
       jsr MovLRGold               // wait for center and handle the gold
}
MovUpDown:{

        lda #NoLR_LadderMin         // low image no
        ldx #NoLR_LadderMax         // high image no
        jsr MovLRSetImg
        jsr MovLRKill
        clc
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
LRMoveDown:{
        ldy LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        cpy #$02                // in center of screen image
        bcc MovLRDownABit
        
        ldy LRZ_LodeRunRow          // actual row lode runner
        cpy #LR_ScrnMaxRows         // $0f - max 15 rows
        bcs XitSetCarry
        
        lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        lda TabExLvlModRowHi+1,y        // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    PtrModifyBelow:
        sta LRZ_XLvlModRowHi
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes + 1
        cmp #NoTileWallHard
        beq XitSetCarry
        
        cmp #NoTileWallWeak
        bne MovLRDownABit
        
    XitSetCarry:
        sec
LRMoveDownX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
MovLRDownABit:{
        jsr GetLRGfxOff
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        
        ldy LRZ_LodeRunRow          // actual row lode runner
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        sta LRZ_XLvlOriRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    PtrModify:
        sta LRZ_XLvlModRowHi
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    PtrOrigin:
        sta LRZ_XLvlOriRowHi
        
        jsr MovLRWaitPosX
        
        inc LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        lda LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        cmp #$05                // center screen image
        bcc GoMovUpDownGold
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        cmp #NoTileWallWeak
        bne Store
        
        lda #NoTileBlank            // empty substitution
        
    Store:
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
        inc LRZ_LodeRunRow          // actual row lode runner
        
        ldy LRZ_LodeRunRow          // actual row lode runner
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    PtrModifyBelow:
        sta LRZ_XLvlModRowHi
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda #NoTileLodeRunner
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
        lda #$00
        sta LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        jmp MovUpDown
        
    GoMovUpDownGold:
        jmp MovLRUpABit.MovUpDownGold
}

FireLeftNone:{
        jmp OutLRFireLeftNo
}
// ------------------------------------------------------------------------------------------------------------- //
MovLRFireLeft:{
        lda #LR_ShootsLe
        sta LR_Shoots               // $00=no $01=right $ff=left
        sta LR_JoyUpDo
        sta LR_JoyLeRi
        lda #$00
        sta $54                 // lr actual sprite number
}
        
LRFireLeft:{
        ldy LRZ_LodeRunRow          // actual row lode runner
        cpy #LR_ScrnMaxRows         // $0f - max 15 rows
        bcs FireLeftNone            // no walls left for shooting
        
        iny
        jsr SetCtrlDataPtr          // set both expanded level data pointers
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        beq FireLeftNone            // leftmost position
        
        dey
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        cmp #NoTileWallWeak
        bne FireLeftNone
        
        ldy LRZ_LodeRunRow          // actual row lode runner
        jsr SetCtrlDataPtr          // set both expanded level data pointers
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        dey
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        cmp #NoTileBlank            // empty
        bne OutLRFireLeft
        
        jsr GetLRGfxOff
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        
        jsr MovLRWaitPosX
        jsr MovLRWaitPosY
        
        ldx $54                 // lr actual sprite number
        lda #NoLR_RunLeMin
        
        cpx #NoLR_FireLe
        bcs StoreSpriteNo
        
        lda #NoLR_FireLe
        
    StoreSpriteNo:
        sta LRZ_LodeRunSpriteNo
        jsr MovLRKill
        
        ldx $54                 // lr actual sprite number
        cpx #$0c
        beq MovLRSetHoleLe
        
        cpx #$00
        beq GetShootImage2
        
    GetShootImage1:
        lda TabShootNoSpark-1,x
        pha
        
        ldx LRZ_LodeRunCol          // actual col lode runner
        dex
        ldy LRZ_LodeRunRow          // actual row lode runner
        jsr GetColRowGfxOff         // offsets in xr=col yr=row
        
        pla
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        
        ldx $54                 // lr actual sprite number
    GetShootImage2:
        lda TabShootNoSpark,x
        pha                     // save image number
        
        ldx LRZ_LodeRunCol          // actual col lode runner
        dex
        stx LRZ_ScreenCol           // screen col  (00-1b)
        
        ldy LRZ_LodeRunRow          // actual row lode runner
        sty LRZ_ScreenRow           // screen row  (00-0f)
        jsr GetColRowGfxOff         // offsets in xr=col yr=row
        
        pla                     // restore image number
        jsr ImageOutXtra            // set images on game screen (sprites/shoots/hidden ladders)
        
        ldx $54                 // lr actual sprite number
    GetMeltImage:
        lda TabShootMeltGrnd,x
        inc LRZ_ScreenRow           // screen row  (00-0f)
    PutMeltImage:
        jsr ImageOut2Disp           // direct output to display screen
        
        inc $54                 // lr actual sprite number
        
        clc
MovLRFireLeftX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
OutLRFireLeft:{
        ldy LRZ_LodeRunRow          // actual row lode runner
        iny                     // +1
        sty LRZ_ScreenRow           // screen row  (00-0f)
        ldy LRZ_LodeRunCol          // actual col lode runner
        dey
        sty LRZ_ScreenCol           // screen col  (00-1b)
        
        lda #NoTileWallWeak
        jsr ImageOut2Disp           // direct output to display screen
        
        ldx $54                 // lr actual sprite number
        beq OutLRFireLeftNo
        
        dex
    GetShootImage:
        lda TabShootNoSpark,x
        pha
        
        ldy LRZ_LodeRunRow          // actual row lode runner
        ldx LRZ_LodeRunCol          // actual col lode runner
        dex
        jsr GetColRowGfxOff         // offsets in xr=col yr=row
        
        pla
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
}

OutLRFireLeftNo:{
        lda #LR_ShootsNo
        sta LR_Shoots               // $00=no $01=right $ff=left
        sec
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
MovLRSetHoleLe:{
        ldx LRZ_LodeRunCol          // actual col lode runner
        dex
        
    jmp MovLRSetHole
}
// ------------------------------------------------------------------------------------------------------------- //
GoSetNoShoot:        jmp SetNoShoot
// ------------------------------------------------------------------------------------------------------------- //
MovLRFireRight:{
        lda #LR_ShootsRi
        sta LR_Shoots               // $00=no $01=right $ff=left
        sta LR_JoyUpDo
        sta LR_JoyLeRi
        lda #$0c
        sta $54                 // lr actual sprite number
}
LRFireRight:{
        ldy LRZ_LodeRunRow          // actual row lode runner
        cpy #LR_ScrnMaxRows         // $0f - max 15 rows
        bcs GoSetNoShoot
        
        iny
        jsr SetCtrlDataPtr          // set both expanded level data pointers
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        cpy #LR_ScrnMaxCols         // $1b - max 27 cols
        bcs GoSetNoShoot
        
        iny
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        cmp #NoTileWallWeak
        bne GoSetNoShoot
        
        ldy LRZ_LodeRunRow          // actual row lode runner
        jsr SetCtrlDataPtr          // set both expanded level data pointers
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        iny
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        cmp #NoTileBlank            // empty
        bne MovLRFireNoHole
        
        jsr GetLRGfxOff
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        jsr MovLRWaitPosX
        jsr MovLRWaitPosY
        
        ldx $54                 // lr actual sprite number
        lda #NoLR_RunRiMin
        
        cpx #$12
        bcs SetSprite
        
        lda #NoLR_FireRi
    SetSprite:
        sta LRZ_LodeRunSpriteNo         // lr sprite number
        jsr MovLRKill
        
        ldx $54                 // lr actual sprite number
        cpx #$18
        beq MovLRSetHoleRi
        
        cpx #$0c
        beq GetShootImage2
        
    GetShootImage1:
        lda TabShootNoSpark-1,x
        pha
        
        ldx LRZ_LodeRunCol          // actual col lode runner
        inx
        ldy LRZ_LodeRunRow          // actual row lode runner
        jsr GetColRowGfxOff         // offsets in xr=col yr=row
        
        pla
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        
        ldx $54                 // lr actual sprite number
    GetShootImage2:
        lda TabShootNoSpark,x
        pha
        
        ldx LRZ_LodeRunCol          // actual col lode runner
        inx
        stx LRZ_ScreenCol           // screen col  (00-1b)
        ldy LRZ_LodeRunRow          // actual row lode runner
        sty LRZ_ScreenRow           // screen row  (00-0f)
        jsr GetColRowGfxOff         // offsets in xr=col yr=row
        
        pla
        jsr ImageOutXtra            // set images on game screen (sprites/shoots/hidden ladders)
        
        inc LRZ_ScreenRow           // screen row  (00-0f)
        ldx $54
    GetMeltImage:
        lda TabShootMelt,x
    PutMeltImage:
        jsr ImageOut2Disp           // direct output to display screen
        
        inc $54
        clc
MovLRFireRightX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
MovLRFireNoHole:{
        ldy LRZ_LodeRunRow          // actual row lode runner
        iny
        sty LRZ_ScreenRow           // screen row  (00-0f)
        ldy LRZ_LodeRunCol          // actual col lode runner
        iny
        sty LRZ_ScreenCol           // screen col  (00-1b)
        lda #NoTileWallWeak
        jsr ImageOut2Disp           // direct output to display screen
        
        ldx $54                 // lr actual sprite number
        cpx #$0c
        beq SetNoShoot
        
        dex
    GetShootImage:
        lda TabShootNoSpark,x
        pha
        
        ldx LRZ_LodeRunCol          // actual col lode runner
        inx
        ldy LRZ_LodeRunRow          // actual row lode runner
        jsr GetColRowGfxOff         // offsets in xr=col yr=row
        
        pla
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
}

SetNoShoot:{
        lda #LR_ShootsNo
        sta LR_Shoots               // $00=no $01=right $ff=left
        sec
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
MovLRSetHoleRi:{
        ldx LRZ_LodeRunCol          // actual col lode runner
        inx
        jmp MovLRSetHole
}
// ------------------------------------------------------------------------------------------------------------- //
.label TabSpriteNoLodeR    = *
TabLR_RunLeMin:     .byte NoSprite_RuLe00 // $00 - run    left 01    - have lode runner sprite numbers from $01-$11
                    .byte NoSprite_RuLe01 // $01 - run    left 02
TabLR_RunLeMax:     .byte NoSprite_RuLe02 // $02 - run    left 03
TabLR_PoleLeMin:    .byte NoSprite_PoLe00 // $03 - pole   left 01
                    .byte NoSprite_PoLe01 // $04 - pole   left 02
TabLR_PoleLeMax:    .byte NoSprite_PoLe02 // $05 - pole   left 03
TabLR_FireLe:       .byte NoSprite_FireLe // $06 - fire   left
TabLR_FallLe:       .byte NoSprite_FallLe // $07 - fall   left
TabLR_RunRiMin:     .byte NoSprite_RuRi00 // $08 - run    right 01
                    .byte NoSprite_RuRi01 // $09 - run    right 02
TabLR_RunRiMax:     .byte NoSprite_RuRi02 // $0a - run    right 03
TabLR_PoleRiMin:    .byte NoSprite_PoRi00 // $0b - pole   right 01
                    .byte NoSprite_PoRi01 // $0c - pole   right 02
TabLR_PoleRiMax:    .byte NoSprite_PoRi02 // $0d - pole   right 03
TabLR_FireRi:       .byte NoSprite_FireRi // $0e - fire   right
TabLR_FallRi:       .byte NoSprite_FallRi // $0f - fall   right
TabLR_LadderMin:    .byte NoSprite_Ladr00 // $10 - ladder up/down 01
TabLR_LadderMax:    .byte NoSprite_Ladr01 // $11 - ladder up/down 02
// ------------------------------------------------------------------------------------------------------------- //
.label NoLR_RunLeMin     =  TabLR_RunLeMin  - TabSpriteNoLodeR
.label NoLR_RunLeMax     =  TabLR_RunLeMax  - TabSpriteNoLodeR
.label NoLR_PoleLeMin    =  TabLR_PoleLeMin - TabSpriteNoLodeR
.label NoLR_PoleLeMax    =  TabLR_PoleLeMax - TabSpriteNoLodeR
.label NoLR_RunRiMin     =  TabLR_RunRiMin  - TabSpriteNoLodeR
.label NoLR_RunRiMax     =  TabLR_RunRiMax  - TabSpriteNoLodeR
.label NoLR_PoleRiMin    =  TabLR_PoleRiMin - TabSpriteNoLodeR
.label NoLR_PoleRiMax    =  TabLR_PoleRiMax - TabSpriteNoLodeR
.label NoLR_LadderMin    =  TabLR_LadderMin - TabSpriteNoLodeR
.label NoLR_LadderMax    =  TabLR_LadderMax - TabSpriteNoLodeR
                
.label NoLR_FireLe       =  TabLR_FireLe    - TabSpriteNoLodeR
.label NoLR_FireRi       =  TabLR_FireRi    - TabSpriteNoLodeR
                
.label NoLR_FallLe       =  TabLR_FallLe    - TabSpriteNoLodeR
.label NoLR_FallRi       =  TabLR_FallRi    - TabSpriteNoLodeR
// ------------------------------------------------------------------------------------------------------------- //
TabShootNoSpark:
                .byte NoShootSpark00  // $00 - shoot spark 00
                .byte NoShootSpark00  // $01 - shoot spark 00
                .byte NoShootSpark01  // $02 - shoot spark 01
                .byte NoShootSpark01  // $03 - shoot spark 01
                .byte NoShootSpark02  // $04 - shoot spark 02
                .byte NoShootSpark02  // $05 - shoot spark 02
                .byte NoShootSpark03  // $06 - shoot spark 03
                .byte NoShootSpark03  // $07 - shoot spark 03
                .byte NoTileBlank     // $08 - tile empty
                .byte NoTileBlank     // $09 - tile empty
                .byte NoTileBlank     // $0a - tile empty
                .byte NoTileBlank     // $0b - tile empty
// ------------------------------------------------------------------------------------------------------------- //
TabShootMelt:
                .byte NoShootMelt00   // $00 - init melt above ground 01
                .byte NoShootMelt00   // $01 - init melt above ground 02
                .byte NoShootMelt01   // $02 - init melt above ground 01
                .byte NoShootMelt01   // $03 - init melt above ground 02
                .byte NoShootSpark02  // $04 - shoot spark 02
                .byte NoShootSpark02  // $05 - shoot spark 02
                .byte NoShootSpark03  // $06 - shoot spark 03
                .byte NoShootSpark03  // $07 - shoot spark 03
                .byte NoTileBlank     // $08 - tile empty
                .byte NoTileBlank     // $09 - tile empty
                .byte NoTileBlank     // $0a - tile empty
                .byte NoTileBlank     // $0b - tile empty
// ------------------------------------------------------------------------------------------------------------- //
TabShootMeltGrnd:
                .byte NoShootMeltGr00 // $00 - shoot melt ground 01
                .byte NoShootMeltGr00 // $01 - shoot melt ground 01
                .byte NoShootMeltGr01 // $02 - shoot melt ground 02
                .byte NoShootMeltGr01 // $03 - shoot melt ground 02
                .byte NoShootMeltGr02 // $04 - shoot melt ground 03
                .byte NoShootMeltGr02 // $05 - shoot melt ground 03
                .byte NoShootMeltGr03 // $06 - shoot melt ground 04
                .byte NoShootMeltGr03 // $07 - shoot melt ground 04
                .byte NoShootMeltGr04 // $08 - shoot melt ground 05
                .byte NoShootMeltGr04 // $09 - shoot melt ground 05
                .byte NoShootMeltGr05 // $0a - shoot melt ground 06
                .byte NoShootMeltGr05 // $0b - shoot melt ground 06
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
ContinueDemo:{
        lda LR_KeyNew
    !ChkKey:
        bne !Pressed+
        
        lda CIAPRA                  // CIA 1 - $DC00 = Data Port A
        and #$10                // isolate fire button
    !ChkFire:
        bne RunDemo
        
    !Pressed:
        lsr LR_Alive                // kill LR ends the level immediately
        lda #$01
        sta LR_NumLives             // last live used up ends the demo immediately
        
ContinueDemoX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
RunDemo:{
        lda LRZ_DemoMoveTime        // duration demo move
        bne DoMove                 // not ended yet
        
        ldy #$00
    GetMove:
        lda (LRZ_DemoMoveDat),y         // demo data pointer
        sta LRZ_DemoMoveType        // type of demo move  (l/r/u/d/fire)
        
    GetTime:
        iny
        lda (LRZ_DemoMoveDat),y         // demo data pointer
        sta LRZ_DemoMoveTime        // duration demo move
        
    IncMovePtr:
        lda LRZ_DemoMoveDatLo
        clc
        adc #$02
        sta LRZ_DemoMoveDatLo
        bcc DoMove
        inc LRZ_DemoMoveDatHi           // demo data pointer high
        
    DoMove:
        lda LRZ_DemoMoveType        // type demo move  (l/r/u/d/fire)
        and #$0f                // isolate right nybble for up/down moves
        tax
        lda TabDemoJoyActn,x        // demo joystick action tab
    SetUpDo:
        sta LR_JoyUpDo
        
        lda LRZ_DemoMoveType        // type demo move  (l/r/u/d/fire)
        lsr                        // isolate left nybble for left/right moves
        lsr 
        lsr 
        lsr 
        tax
        lda TabDemoJoyActn,x
    SetLeRi:
        sta LR_JoyLeRi

    DecTime:
        dec LRZ_DemoMoveTime        // duration demo move
        
RunDemoX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
TabDemoJoyActn:
                .byte LR_JoyMoveUp    // 0 - $21=up
                .byte LR_JoyMoveLe    // 1 - $22=left
                .byte LR_JoyMoveDo    // 2 - $25=down
                .byte LR_JoyMoveRi    // 3 - $2a=right
                .byte LR_JoyFireRi    // 4 - $26=fire-right
                .byte LR_JoyFireLe    // 5 - $1e=fire-left
                .byte LR_JoyMoveNone  // 6 - $00=no move
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetPlayCmd:{
        lda LR_GameCtrl             // $00=start $01=demo $02=game $03=play_level $05=edit
        cmp #LR_GameDemo
        bne GameMode
        
    DemoMode:
        jmp ContinueDemo

    GameMode:
        ldx LR_KeyNew
        bne ChkKeyI                // pressed
        
        lda LR_ControllerTyp        // controler type  $ca=joystick  $cb=keyboard
        cmp #LR_Keyboard
        beq GetPlayCmdX
        
    GoChkJoyPort:
        jmp ChkJoyPort
        
    ChkKeyI:
        lda #LR_KeyNewNone
        sta LR_KeyNew               // reset actual key
        
        stx LRZ_WrkGetKey           // save actual key
        
        ldy #$ff
    ChkKey:
        iny
        lda TabInGameCmdChr,y           // in game keys tab  (U F <run/stop> R A J K + - D)
        beq ChkCtrlType            // end of tab - no legal command key found
        
        cmp LRZ_WrkGetKey           // still actual key
        bne ChkKey
        
        tya
        asl                   // *2
        tay
    PrepareCmd:
        lda TabInGameCmdSub+1,y
        pha                     // set return address for rts
        lda TabInGameCmdSub,y
        pha                     // set return address for rts
        
    DispatchCmd:
        rts                     // dispatch command
        
    ChkCtrlType:
        lda LR_ControllerTyp        // controler type  $ca=joystick  $cb=keyboard
        cmp #LR_Joystick
        beq GoChkJoyPort
        
        ldx LRZ_WrkGetKey           // saved actual key
        stx LR_JoyUpDo
        stx LR_JoyLeRi
        
GetPlayCmdX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
IGC_Success:{
        lda LR_ExpertMode           // !hbu017! - expert mode set after <run/stop>, <f7>, <run/stop>
        bpl IGC_SuccessX            // !hbu017! - off
        
    Chk_Co:
        lda C64_KeyFlag             // $01=shift $02=commodore $04=ctrl
        and #$02                //
        cmp #$02                // <commodore>
        bne IGC_SuccessX            //
        
    SpritesOn:
        lda #$00                // !hbu017!
        sta LR_Gold2Get             // !hbu017! - no more gold to collect
        
IGC_SuccessX:
        jmp GetPlayCmd
}
// ------------------------------------------------------------------------------------------------------------- //
IGC_Xmit:{
        lda LR_ExpertMode           // !hbu017! - expert mode set after <run/stop>, <f7>, <run/stop>
        bpl IGC_XmitX               // !hbu017! - off
        
        lda SPENA                   // !hbu017! - VIC 2 - $D015 = Sprite Enable
        sta LR_Work                 // !hbu017! - save active sprites
        
    SpritesOff:
        lda #$00                // !hbu017! - Transmit the active level to drive 9
        sta SPENA                   // !hbu017! - VIC 2 - $D015 = Sprite Enable
        
        jsr Xmit                // !hbu017! - transmit the active level to drive 9

    SpritesOn:
        lda LR_Work                 // !hbu017! - restore active sprites
        sta SPENA                   // !hbu017! - VIC 2 - $D015 = Sprite Enable
        
IGC_XmitX:
        jmp GetPlayCmd
}
// ------------------------------------------------------------------------------------------------------------- //
IGC_Random:{
        lda LR_TestLevel            // !hbu023! - flag: level testmode on/off
        bmi IGC_RandomX             // !hbu023!
        
        lda #LR_NumLivesInit+1          // Z=random level mode
        sta LR_NumLives             // one more because of the following kill
        lsr LR_Alive                // $00=lr killed
        
        lda LR_RNDMode              //
        eor #LR_RNDModeOn           // toggle mode
        sta LR_RNDMode              // 
        beq Off                // was ON
        
    On:
        jsr RNDInit                 // setup
        jsr RND                 // get a random level no and rts
        sta LR_LevelNoDisk
        sta LR_LevelNoGame
        inc LR_LevelNoGame
        inc LR_RNDLevel             // the real level counter
        jmp IGC_RandomX             //
        
    Off:
        ldy #LR_LevelDiskMin        // 
        sty LR_LevelNoDisk          //
        iny                     //
        sty LR_LevelNoGame          //
        
IGC_RandomX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
IGC_NextLvl:{                                 //  U=play next level
        lda LR_TestLevel            // !hbu023! - flag: level testmode on/off
        bmi IGC_NextLvlX            // !hbu023!
        
        lda LR_RNDMode              // 
        bpl GoIncLevelNo           // !hbu021!
        
    RandomLevel:
        jsr RND                 //  - get a random number
        
        sta LR_LevelNoDisk          // 
        sta LR_LevelNoGame          // 
        inc LR_LevelNoGame          // 
        inc LR_RNDLevel             //  - the real level counter
        jmp Kill                   // 
        
    GoIncLevelNo:
        jsr IncGameLevelNo          // increase level number
        
    Kill:
        lsr LR_Alive                // $00=lr killed
        inc LR_NumLives             // compensate the previous kill
        
    ChkExpert:
        lda LR_ExpertMode           // !hbu017! - expert mode set after <run/stop>, <f7>, <run/stop>
    NoCheating:
        bmi IGC_NextLvlX            // !hbu017! - do not set cheat flag in expert mode
        
        lsr LR_Cheated              // set cheated
        
IGC_NextLvlX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
IGC_PrevLvl:{
        lda LR_TestLevel            // !hbu023! - flag: level testmode on/off
        bmi IGC_PrevLvlX            // !hbu023!
        
        lda LR_RNDMode              //  - U=play next level
        bpl GoDecLevelNo           // !hbu021!
        
    RandomLevel:
        jsr RND                 //  -get a random number
        
        sta LR_LevelNoDisk          // 
        sta LR_LevelNoGame          // 
        inc LR_LevelNoGame          // 
        inc LR_RNDLevel             //  - the real level counter
        jmp Kill                   // 
        
    GoDecLevelNo:
        jsr DecGameLevelNo          // deccrease level number

    Kill:
        lsr LR_Alive                // $00=lr killed
        inc LR_NumLives             // one more because of the previous kill
        
    ChkExpert:
        lda LR_ExpertMode           // !hbu017! - expert mode set after <run/stop>, <f7>, <run/stop>
    NoCheating:
        bmi IGC_PrevLvlX            // !hbu017! - do not set cheat flag in expert mode
        
        lsr LR_Cheated              // set cheated
        
IGC_PrevLvlX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
IGC_QuitLvl:{
        lda LR_TestLevel            // !hbu023! - flag: level testmode on/off
        bpl IGC_QuitLvlX            // !hbu023! - $ff=off
        
        pla                     // 
        pla                     // !hbu023! - remove WaitKeyBlink
        pla                     // 
        pla                     // !hbu023! - remove GetPlayCmd
        
    IGC_QuitLvlPlay:                  // !hbu023! - entry point after reaching LevelComplete
        lda #LR_TestLevelOff        // !hbu023! - switch test level mode off
        sta LR_TestLevel            // !hbu023!
        
        lda #LR_NumLivesInit        // !hbu023!
        sta LR_NumLives             // !hbu023!
        
        lda #LR_GameEdit            // !hbu023!
        sta LR_GameCtrl             // !hbu023! - $00=start $01=demo $02=game $03=play_level $05=edit
        sta LR_SprtPosCtrl          // !hbu023! - <> $00 - no sprites
        
        lda #$00                // disable all sprites
        sta SPENA                   // VIC 2 - $D015 = Sprite Enable
        jsr LvlEdCurPosLoad         // !hbu023! - restore old cursor position
        
    Back2Edit:
        jmp LevelEditorTst          // !hbu023!
        
IGC_QuitLvlX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
IGC_IncNumLife:{
        lda C64_KeyFlag             // !hbu021! - F=increase life counter
        and #$02                // !hbu021! - $01=shift $02=commodore $04=ctrl
        cmp #$02                // !hbu021! - <commodore>
        bne IncLives01             // !hbu021!
        
    IncLives10:
        lda LR_NumLives             // !hbu021! - 000-149 - <commodore> plus f=get next level plus 10
        clc                     // !hbu021!
        adc #$0a                // !hbu021!
        bcc SetLives               // !hbu021!
        bcs GetLivesMax            // !hbu021!
        
    IncLives01:
        inc LR_NumLives             // get next level plus 1
        bne OutLives               // 
        
    GetLivesMax:
        lda #$ff                // !hbu021! - max $ff
    SetLives:
        sta LR_NumLives
    OutLives:
        jsr RestoreFromMsg          //  - reset status line / display new no of lives
    
    ChkExpert:
        lda LR_ExpertMode           // !hbu017! - expert mode set after <run/stop>, <f7>, <run/stop>
    NoCheating:
        bmi IGC_IncNumLifeX         // !hbu017! - do not set cheat flag in expert mode
        
        lsr LR_Cheated              // $00=yes  $01=no
        
IGC_IncNumLifeX:
        jmp GetPlayCmd
}
// ------------------------------------------------------------------------------------------------------------- //
IGC_Pause:{
        jsr GetAKey                 //
        
    Chk_f7:
        cmp #$03                // !hbu017! - <f7>
        bne Chk_RunStop            // !hbu017!
        
    ToggleExpert:
        lda LR_ExpertMode           // !hbu017!
        eor #LR_ExpertModeOn        // !hbu017! - toggle expert mode
        sta LR_ExpertMode           // !hbu017!
        bpl MarkOff                // !hbu017!
        
    MarkOn:
        lda #DK_GREY                // !hbu017!
        bne SetMark                // !hbu017! - always
        
    MarkOff:
        lda #BLACK                  // !hbu017!
    SetMark:
        sta EXTCOL                  // !hbu017! - VIC 2 - $D020 = Border Color
        jsr Beep                // !hbu017! - announce
        
    Chk_RunStop:
        cmp #$3f                // <run/stop>
        bne IGC_Pause               //
        
IGC_PauseX:
        jmp GetPlayCmd
}
// ------------------------------------------------------------------------------------------------------------- //
IGC_Resign:{
        ldx LR_TestLevel            // !hbu023! - R=give up
        bpl IGC_ResignX             // !hbu023!
        
    GoQuit:
        jmp IGC_QuitLvl             // !hbu023! - only quits in test level mode
        
IGC_ResignX:
        jmp GameOver
} 
// ------------------------------------------------------------------------------------------------------------- //
IGC_Suicide:{
        lsr LR_Alive                // A=suicide - $00=lr killed
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
IGC_SetJoy:{
        lda #LR_Joystick
        sta LR_ControllerTyp        // controler type  $ca=joystick  $cb=keyboard
    
IGC_SetJoyX:
        jmp GetPlayCmd
}
// ------------------------------------------------------------------------------------------------------------- //
IGC_SetLoad:{                             // L=load saved game
        lda LR_TestLevel            // !hbu023! - flag: level testmode on/off
        bpl SetLoadCmd             // !hbu023!
        
    Exit:
        rts                     // no loads in test mode
        
    SetLoadCmd:
        lda #$aa                // "L"
        jsr InitLodSavGame          //
        
        pla                     // discard return address of mainloop
        pla                     //   avoids death tune
        
IGC_SetLoadX:
        jmp LevelStart
}
// ------------------------------------------------------------------------------------------------------------- //
IGC_SetSave:{                                 // S=save game
        lda LR_TestLevel            // !hbu023! - flag: level testmode on/off
        bpl ChkCheat               // !hbu023!
        
    Exit:
        rts                     // no saves in test mode
        
    ChkCheat:
        lda LR_Cheated              // 
        bne SetSaveCmd             //
        
        jmp GetPlayCmd              // no saves after cheating
        
    SetSaveCmd:
        lda #$8d                // "S"
        dec LR_NumLives             // discount a live here to avoid live savings
        jsr Lives2BaseLine          // and out
        jsr InitLodSavGame          //
        
        pla                     // discard return address of mainloop
        pla                     //  avoids death tune
        
IGC_SetSaveX:
        jmp LevelStart
}
// ------------------------------------------------------------------------------------------------------------- //
IGC_SetMirror:{
        jsr ToggleMirror            // M=discount a live here to avoid in game mirrors to save lives

        jmp GetPlayCmd
}
// ------------------------------------------------------------------------------------------------------------- //
IGC_SetKey:{
        lda #LR_Keyboard
        sta LR_ControllerTyp        // controler type  $ca=joystick  $cb=keyboard
        
        jmp GetPlayCmd
}
// ------------------------------------------------------------------------------------------------------------- //
IGC_DecSpeed:{                  // -=decrease game speed
        lda LR_ExpertMode           // !hbu017!
        bpl GameMode               // !hbu017!
        
        jsr DecXmitLevelNo          // !hbu017! - decrease Xmit level number
    Exit:
        jmp GetPlayCmd              // !hbu017!
        
    GameMode:
        lda LR_GameSpeed            // 
        cmp #LR_SpeedMax            // 
        beq !Exit+           // 
        
        inc LR_GameSpeed            // apply the brake a bit
        
    !Exit:
        jmp GetPlayCmd
} 
// ------------------------------------------------------------------------------------------------------------- //
IGC_IncSpeed:{                                // +=increase game speed
        lda LR_ExpertMode           // !hbu017! - expert mode - set xmit level
        bpl GameMode               // !hbu017! - game mode   - inc speed
        
        jsr IncXmitLevelNo          // !hbu017! - increase Xmit level number
    Exit:
        jmp GetPlayCmd              // !hbu017!
        
    GameMode:
        lda LR_GameSpeed            // 
        cmp #LR_SpeedMin            // 
        beq !Exit+           // 
        
        dec LR_GameSpeed            // release the brake a bit
        
    !Exit:
        jmp GetPlayCmd
} 
// ------------------------------------------------------------------------------------------------------------- //
IGC_ShootMode:{
        lda LR_ShootMode            // D=toggle shooter mode
        eor #$ff
        sta LR_ShootMode
        
        jmp GetPlayCmd
}
// ------------------------------------------------------------------------------------------------------------- //
DecGameLevelNo:{
    Chk_Co:
        lda C64_KeyFlag             // $01=shift $02=commodore $04=ctrl
        and #$02                
        cmp #$02                    //- <commodore>
        bne NextLevel
        
    NextLevel10:
        lda LR_LevelNoDisk          // !hbu021! - 000-149 - <commodore>f=get next level plus 10
        sec                     // !hbu021!
        sbc #$0A                // !hbu021!
        bcs StoreLevel10           // !hbu021!
        //
        //***** THIS IF BLOCK IS WRONG NEEDS CONVERTING TO CODE
        //.if (LR_LevelDiskMax > 10) {        // !hbu021! - only in code if more than 10 levels allowed
                lda #LR_LevelDiskMax - 9        // !hbu021! - was lower 10 - underflow
                clc                     // !hbu021!
                adc LR_LevelNoDisk          // !hbu021!

            StoreLevel10:
                sta LR_LevelNoDisk          // !hbu021!
                sta LR_LevelNoGame          // !hbu021!
                inc LR_LevelNoGame          // !hbu021!
            Exit10:
                rts                     // !hbu021!

            NextLevel:
                lda LR_LevelNoDisk          // !hbu009! - 000-149 - F=get next level
                cmp #LR_LevelDiskMin        // !hbu009!
                bne PrevDisk               // !hbu009!
        //}   //ENDIF
        
        ldy #LR_LevelDiskMax        // !hbu009!
        sty LR_LevelNoDisk          // !hbu009! - 000-149
        iny                     // !hbu009!
        sty LR_LevelNoGame          // !hbu009! - 001-150
    Exit1:
        rts                     // !hbu009!
        
    PrevDisk:
        dec LR_LevelNoDisk          // 000-149
    PrevGame:
        dec LR_LevelNoGame          // 001-150
        
DecGameLevelNoX:
        rts
} 
// ------------------------------------------------------------------------------------------------------------- //
IncGameLevelNo:{
    Chk_Co:
        lda C64_KeyFlag             // !hbu021! - $01=shift $02=commodore $04=ctrl
        and #$02                // !hbu021!
        cmp #$02                // !hbu021! - <commodore>
        bne NextLevel              // !hbu021!
        
    .if (LR_LevelDiskMax > 10){        // !hbu021! - only in code if more than 10 levels allowed
    NextLevel10:
        lda LR_LevelNoDisk          // !hbu021! - 000-149 - <commodore>f=get next level plus 10
        tay                     // !hbu021! - save LR_LevelNoDisk
        clc                     // !hbu021!
        adc #$0a                // !hbu021!
        bcc ChkMax                 // !hbu021! - no byte overflow
        
        tya                     // !hbu021! - restore LR_LevelNoDisk
        sbc #$00                // !hbu021!
        and #$0f                // !hbu021!
        jmp StoreLevel10           // !hbu021!
        
    ChkMax:
        cmp #LR_LevelDiskMax + 1        // !hbu021!
        bcc StoreLevel10           // !hbu021!
        
        sec                     // !hbu021!
        sbc #LR_LevelDiskMax + 1        // !hbu021! - too high so reduce with the max + 1
        
    StoreLevel10:
        sta LR_LevelNoDisk          // !hbu021!
        sta LR_LevelNoGame          // !hbu021!
        jmp NextGame               // !hbu021! - add 1 to disk level number
    }   //ENDIF
        
    NextLevel:
        lda LR_LevelNoDisk          // !hbu009! - 000-149 - F=get next level
        cmp #LR_LevelDiskMax        // !hbu009!
        bne NextDisk               // !hbu009!
        
        ldy #LR_LevelDiskMin        // !hbu009!
        sty LR_LevelNoDisk          // !hbu009! - 000-149
        iny                     // !hbu009!
        sty LR_LevelNoGame          // !hbu009! - 001-150
    Exit:
        rts                     // !hbu009!
        
    NextDisk:
        inc LR_LevelNoDisk          // 000-149
    NextGame:
        inc LR_LevelNoGame          // 001-150
        
IncGameLevelNoX:
        rts
} 
// ------------------------------------------------------------------------------------------------------------- //
DecXmitLevelNo:{
    ChkMsg:
        lda LR_ScrnMCMsg - 1        // !hbu017! - status line msg color game
        cmp LR_ScrnMCMsg            // !hbu017! - status line msg part colour
        beq InfoMsg                // !hbu017! - info msg only at first call - no dec
        
    Chk_Co:
         lda C64_KeyFlag             // !hbu017! - $01=shift $02=commodore $04=ctrl
        and #$02                // !hbu017!
        cmp #$02                // !hbu017! - <commodore>
        bne ChkXmit01              // !hbu017!
        
    //10:
        lda LR_LevelNoXmit          // !hbu017! - 000-149 - <commodore>f=get next level plus 10
        sec                     // !hbu017!
        sbc #$0a                // !hbu017!
        bcs SetXmit10              // !hbu017!
        
        lda #LR_LevelDiskMax - 9        // !hbu017! - was lower 10 - underflow
        clc                     // !hbu017!
        adc LR_LevelNoDisk          // !hbu017!
    SetXmit10:
        sta LR_LevelNoXmit          // !hbu017!
        jmp InfoMsg                // !hbu017!
        
    ChkXmit01:
        lda LR_LevelNoXmit          // !hbu017!
        cmp #LR_LevelDiskMin        // !hbu017!
        bne SetXmit01              // !hbu017!
        
        lda #LR_LevelDiskMax        // !hbu017!
        sta LR_LevelNoXmit          // !hbu017!
        jmp InfoMsg                // !hbu017!
        
    SetXmit01:
        dec LR_LevelNoXmit          // !hbu017!
        
    InfoMsg:
        lda #$a0                // !hbu017! - <blank>
        sta Mod_InfoTxt1            // !hbu017!
        lda #$d3                // !hbu017! - "S"
        sta Mod_InfoTxt2            // !hbu017!
        lda #$c5                // !hbu017! - "E"
        sta Mod_InfoTxt3            // !hbu017!
DecXmitLevelNoX:
        jmp XmitInfo
}
// ------------------------------------------------------------------------------------------------------------- //
IncXmitLevelNo:{
    ChkMsg:
        lda LR_ScrnMCMsg - 1        // !hbu017! - status line msg color game
        cmp LR_ScrnMCMsg            // !hbu017! - status line msg part colour
        beq InfoMsg                // !hbu017! - info msg only at first call - no inc
        
    Chk_Co:
        lda C64_KeyFlag             // !hbu017! - $01=shift $02=commodore $04=ctrl
        and #$02                // !hbu017!
        cmp #$02                // !hbu017! - <commodore>
        bne ChkXmit01              // !hbu017!
        
    AddXmit10:
        lda LR_LevelNoXmit          // !hbu017! - 000-149 - <commodore>f=get next xmit level plus 10
        clc                     // !hbu017!
        adc #$0a                // !hbu017!
        cmp #LR_LevelDiskMax + 1        // !hbu017!
        bcc SetXmit10              // !hbu017!
        
        sec                     // !hbu017!
        sbc #LR_LevelDiskMax + 1        // !hbu017!
    SetXmit10:
        sta LR_LevelNoXmit          // !hbu017!
        jmp InfoMsg                // !hbu017!
        
    ChkXmit01:
        lda LR_LevelNoXmit          // !hbu017!
        cmp #LR_LevelDiskMax        // !hbu017!
        bne SetXmit01              // !hbu017!
        
        lda #LR_LevelDiskMin        // !hbu017!
        sta LR_LevelNoXmit          // !hbu017!
        jmp InfoMsg                // !hbu017!
        
    SetXmit01:
        inc LR_LevelNoXmit          // !hbu017!
        
    InfoMsg:
        lda #$a0                // !hbu017! - <blank>
        sta Mod_InfoTxt1            // !hbu017!
        lda #$d3                // !hbu017! - "S"
        sta Mod_InfoTxt2            // !hbu017!
        lda #$c5                // !hbu017! - "E"
        sta Mod_InfoTxt3            // !hbu017!
IncXmitLevelNoX:
        jmp XmitInfo
}
// ------------------------------------------------------------------------------------------------------------- //
ToggleMirror:{
        lda LR_Mirror               //  flip load mirrored level flag
        eor #$ff
        sta LR_Mirror
        
    ResetKey:
        ldy #LR_KeyNewNone          //
        sty LR_KeyNew               // reset pressed key
        
        lsr LR_Alive                // kill lr
        inc LR_LvlReload            // <> LR_LevelNoDisk - force level reload from disk
        
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
ChkJoyPort:{
        lda CIAPRA                  // CIA 1 - $DC00 = Data Port A
        and #$10                // Bit 4: Joystick 2 - Fire   0=pressed
        bne ChkMoves
        
    CheckMode:
        lda $08
        eor LR_ShootMode
        bpl FireLeft
        
    FireRight:
        lda #LR_JoyFireRi
        sta LR_JoyUpDo
        sta LR_JoyLeRi
    FireRightX:
        rts
        
    FireLeft:
        lda #LR_JoyFireLe
        sta LR_JoyUpDo
        sta LR_JoyLeRi
    FireLeftX:
        rts
        
    ChkMoves:
        lda CIAPRA                  // CIA 1 - $DC00 = Data Port A
        sta LRZ_Work                // SavCIA
        
    ChkUpDown:
        and #$02                // Bit 1: Joystick 2 - Down   0=pressed
        beq SetDown
        
        lda LRZ_Work                // SavCIA
        and #$01                // Bit 0: Joystick 2 - Up     0=pressed
        beq SetUp
        
    NetNoneUpDown:
        ldx #LR_JoyMoveNone
        stx LR_JoyUpDo
        beq ChkLeftRight           // always
        
    SetUp:
        ldx #LR_JoyMoveUp
        stx LR_JoyUpDo
        bne ChkLeftRight           // always
        
    SetDown:
        ldx #LR_JoyMoveDo
        stx LR_JoyUpDo
        
    ChkLeftRight:
        lda LRZ_Work                // SavCIA
        and #$08                // Bit 3: Joystick 2 - Right  0=pressed
        beq SetRight
        
        lda LRZ_Work
        and #$04                // Bit 2: Joystick 2 - Left   0=pressed
        beq SetLeft
        
    SetNoneRiLeft:
        ldx #LR_JoyMoveNone
        stx LR_JoyLeRi
    SetNoneRiLeftX:
        rts
        
    SetRight:
        ldx #LR_JoyMoveRi
        stx LR_JoyLeRi
    SetRightX:
        rts
        
    SetLeft:
        ldx #LR_JoyMoveLe
        stx LR_JoyLeRi
        
ChkJoyPortX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetLRGfxOff:{
        ldx LRZ_LodeRunCol          // actual col lode runner
        ldy LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
        jsr GetXOff
        
        stx LRZ_ImageNo             // image number
        ldy LRZ_LodeRunRow          // actual row lode runner
        ldx LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        jsr GetYOff
        
        ldx LRZ_LodeRunSpriteNo         // lr sprite number
        lda TabSpriteNoLodeR,x          // lr images tab
        ldx LRZ_ImageNo             // image number
        
GetLRGfxOffX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovLRGold:{
        lda LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
        cmp #$02                // centered
        bne MovLRGoldX              // no
        
        lda LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        cmp #$02                // centered
        bne MovLRGoldX              // no
        
        ldy LRZ_LodeRunRow          // actual row lode runner
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    PtrOrigin:
        sta LRZ_XLvlOriRowHi
        
        ldy LRZ_LodeRunCol          // actual col lode runner
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        cmp #NoTileGold
        bne MovLRGoldX              // no
        
        lsr LR_GetGold              // get gold  $00=just gets it
        ldx #$10
        ldy #$20
        lda #$04
        jsr Randomizer
        sta Rnd01
        
        lda #$04
        jsr Randomizer
        sta Rnd02
        
        lda #$04
        jsr Randomizer
        sta Rnd03
        
        lda #$04
        jsr Randomizer
        sta Rnd04
        
        jsr SetTune                 // data must follow directly

        .byte $04                // tune time
    Rnd01:
        .byte $00                // tune data pointer voice 2
        .byte $ff                // tune data pointer voice 3
        .byte $b0                // tune s/r/volume  (not used)
        
        .byte $04                // tune time
    Rnd02:
        .byte $00                // tune data pointer voice 2
        .byte $ff                // tune data pointer voice 3
        .byte $a0                // tune s/r/volume  (not used)
        
        .byte $04                // tune time
    Rnd03:
        .byte $00                // tune data pointer voice 2
        .byte $ff                // tune data pointer voice 3
        .byte $90                // tune s/r/volume  (not used)
        
        .byte $04                // tune time
    Rnd04:
        .byte $00                // tune data pointer voice 2
        .byte $ff                // tune data pointer voice 3
        .byte $a0                // tune s/r/volume  (not used)
        
        .byte $00                // <EndOfTuneData>
        
    DecGoldToGet:
        dec LR_Gold2Get
        ldy LRZ_LodeRunRow          // actual row lode runner
        sty LRZ_ScreenRow           // screen row  (00-0f)
        ldy LRZ_LodeRunCol          // actual col lode runner
        sty LRZ_ScreenCol           // screen col  (00-1b)
        lda #NoTileBlank
        sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        jsr ImageOut2Prep           // direct output to preparation screen
        
        ldy LRZ_ScreenRow           // screen row  (00-0f)
        ldx LRZ_ScreenCol           // screen col  (00-1b)
        jsr GetColRowGfxOff         // offsets in xr=col yr=row
        
        lda #NoTileGold
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        
        lda #<LR_ScoreGold          // ac=score  10s
        ldy #>LR_ScoreGold          // yr=score 100s
        jsr Score2BaseLine 
        
MovLRGoldX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovLRSetImg:{
        inc LRZ_LodeRunSpriteNo         // lr sprite number = next
        
        cmp LRZ_LodeRunSpriteNo         // compare 07 with minimum
        bcc ChkMax                 // lower - check max
        
    SetImg:
        sta LRZ_LodeRunSpriteNo
        rts
        
    ChkMax:
        cpx LRZ_LodeRunSpriteNo
        bcc SetImg
        
MovLRSetImgX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovLRKill:{
        jsr GetLRGfxOff
        jsr ImageOutXtra            // set images on game screen (sprites/shoots/hidden ladders)
        lda $27                 // sprite collision  $01=lr caught
        beq MovLRKillX
        
        lda LR_GetGold              // get gold  $00=just gets it
        beq MovLRKillX
        
        lsr LR_Alive                // $00=lr killed
        
MovLRKillX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovLRWaitPosX:{
        lda LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
        cmp #$02                // center
        bcc IncPos                 // lower
        beq MovLRWaitPosXX
        
        dec LRZ_LodeRunOnImgPosLR       // greater so dec lr pos on image left/right
        jmp MovLRGold               // wait for center and handle the gold
        
    IncPos:
        inc LRZ_LodeRunOnImgPosLR       // lr pos on image left/right
        jmp MovLRGold               // wait for center and handle the gold
        
MovLRWaitPosXX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovLRWaitPosY:{
        lda LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        cmp #$02                // center
        bcc IncPos                 // lower
        beq MovLRWaitPosYX
        
        dec LRZ_LodeRunOnImgPosUD       // greater so dec lr pos on image up/down
        jmp MovLRGold               // wait for center and handle the gold
        
    IncPos:
        inc LRZ_LodeRunOnImgPosUD       // lr pos on image up/down
        jmp MovLRGold               // wait for center and handle the gold
        
MovLRWaitPosYX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovLRSetHole:{
        lda #$00
        sta LR_Shoots               // $00=no $01=right $ff=left
        
        ldy LRZ_LodeRunRow          // actual row lode runner
        iny
        stx LRZ_ScreenCol           // screen col  (00-1b)
        sty LRZ_ScreenRow           // screen row  (00-0f)
        
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    PtrModify:
        sta LRZ_XLvlModRowHi
        
        lda #NoTileBlank            // empty
        ldy LRZ_ScreenCol           // screen col  (00-1b)
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        jsr ImageOut2Disp           // direct output to display screen
        
        lda #NoTileBlank            // emtpy
        jsr ImageOut2Prep           // direct output to preparation screen
        
        dec LRZ_ScreenRow           // screen row  (00-0f)
        lda #NoTileBlank            // empty
        jsr ImageOut2Disp           // direct output to display screen
        
        inc LRZ_ScreenRow           // screen row  (00-0f)
        ldx #$ff
    GetFreeSlot:
        inx
        cpx #LR_TabHoleMax          // $1e - max 30 slots
        beq MovLRSetHoleX
        
        lda LR_TabHoleOpenTime,x        // hole open time tab
        bne GetFreeSlot            // already used - check next slot
        
        lda LRZ_ScreenRow           // screen row  (00-0f)
        sta LR_TabHoleRow,x         // hole row tab
        lda LRZ_ScreenCol           // screen col  (00-1b)
        sta LR_TabHoleCol,x         // hole column tab
        
        lda #LR_TabHoleOpenStart        // 
        sta LR_TabHoleOpenTime,x        // hole open time tab
        sec
        
MovLRSetHoleX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// MoveEnemies       Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MoveEnemies:{
        ldx LR_EnmyNo               // number of enemies
        beq MoveEnemiesX            // no enemy to move
        
    IncMoveCyclePtr:
        inc LRZ_EnmyPtrCyc          // pointer actual enemy cycles
        
    ChkMoveCyclePtr:
        ldy LRZ_EnmyPtrCyc          // 
        cpy #$03                // 
        bcc GetMoveCycle           // lower $00-$02
        
    IniMoveCyclePtr:
        ldy #$00                // reset
        sty LRZ_EnmyPtrCyc          // 
        
    GetMoveCycle:
        lda LRZ_EnmyMovCyc1,y           // load move cycles
        sta LRZ_EnmyMovCtrl         // enemy move control
        
    MoveLoop:
        lsr LRZ_EnmyMovCtrl         // enemy move control
        bcc ChkCycle               // 
        
    GoMoveThisEnmy:
        jsr MovEnThisOne            // move THIS enemy
        
    ChkHealthLR:
        lda LR_Alive                // $00=lr killed
        beq MoveEnemiesX            // exit if dead
        
    ChkCycle:
        lda LRZ_EnmyMovCtrl         // enemy move control
        bne MoveLoop               // 
        
MoveEnemiesX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
TabEnmyCycles1:      .byte $00 // !!!!!!!!         // LR_CntSpeedLaps ($00-$09) + LR_EnmyNo
TabEnmyCycles2:      .byte $00 // !!!!!!!!
TabEnmyCycles3:      .byte $00 // !!!!!!!!
                
                .byte $00 // !!!!!!!!
                .byte $01 // !!!!!!!#
                .byte $01 // !!!!!!!#
                
                .byte $01 // !!!!!!!#
                .byte $01 // !!!!!!!#
                .byte $01 // !!!!!!!#
                
                .byte $01 // !!!!!!!#
                .byte $03 // !!!!!!##
                .byte $01 // !!!!!!!#
                
                .byte $01 // !!!!!!!#
                .byte $03 // !!!!!!##
                .byte $03 // !!!!!!##
                
                .byte $03 // !!!!!!##
                .byte $03 // !!!!!!##
                .byte $03 // !!!!!!##
                
                .byte $03 // !!!!!!##
                .byte $03 // !!!!!!##
                .byte $07 // !!!!!###
                
                .byte $03 // !!!!!!##
                .byte $07 // !!!!!###
                .byte $07 // !!!!!###
                
                .byte $07 // !!!!!###
                .byte $07 // !!!!!###
                .byte $07 // !!!!!###
                
                .byte $07 // !!!!!###
                .byte $07 // !!!!!###
                .byte $0f // !!!!####
                
                .byte $07 // !!!!!###
                .byte $0f // !!!!####
                .byte $0f // !!!!####
                
                .byte $0f // !!!!####
                .byte $0f // !!!!####
                .byte $0f // !!!!####
                
                .byte $0f // !!!!####
                .byte $0f // !!!!####
                .byte $1f // !!!#####
                
                .byte $0f // !!!!####
                .byte $1f // !!!#####
                .byte $1f // !!!#####
                
                .byte $1f // !!!#####
                .byte $1f // !!!#####
                .byte $1f // !!!#####
                
                .byte $1f // !!!#####
                .byte $1f // !!!#####
                .byte $3f // !!######
                
                .byte $1f // !!!#####
                .byte $3f // !!######
                .byte $3f // !!######
                
                .byte $3f // !!######
                .byte $3f // !!######
                .byte $3f // !!######
                
                .byte $3f // !!######
                .byte $3f // !!######
                .byte $7f // !#######
                
                .byte $3f // !!######
                .byte $7f // !#######
                .byte $7f // !#######
                
                .byte $7f // !#######
                .byte $7f // !#######
                .byte $7f // !#######
// ------------------------------------------------------------------------------------------------------------- //
.label TabSpriteNoEnemy    = *
TabEN_RunLeMin:     .byte NoSprtMC_RuLe00 // $00 - run    left 01       - have enemy sprite numbers from $00-$0f
                    .byte NoSprtMC_RuLe01 // $01 - run    left 02
TabEN_RunLeMax:     .byte NoSprtMC_RuLe02 // $02 - run    left 03
TabEN_PoleLeMin:    .byte NoSprtMC_PoLe00 // $03 - pole   left 01
                    .byte NoSprtMC_PoLe01 // $04 - pole   left 02
TabEN_PoleLeMax:    .byte NoSprtMC_PoLe02 // $05 - pole   left 03
TabEN_FallLe:       .byte NoSprtMC_FallLe // $06 - fall   left
TabEN_RunRiMin:     .byte NoSprtMC_RuRi00 // $07 - run    right 01
                    .byte NoSprtMC_RuRi01 // $08 - run    right 02
TabEN_RunRiMax:     .byte NoSprtMC_RuRi02 // $09 - run    right 03
TabEN_PoleRiMin:    .byte NoSprtMC_PoRi00 // $0a - pole   right 01
                    .byte NoSprtMC_PoRi01 // $0b - pole   right 02
TabEN_PoleRiMax:    .byte NoSprtMC_PoRi02 // $0c - pole   right 03
TabEN_FallRi:       .byte NoSprtMC_FallRi // $0d - fall   right
TabEN_LadderMin:    .byte NoSprtMC_Ladr00 // $0e - ladder up/down 01
TabEN_LadderMax:    .byte NoSprtMC_Ladr01 // $0f - ladder up/down 02
// ------------------------------------------------------------------------------------------------------------- //
.label NoEN_RunLeMin    =  TabEN_RunLeMin  - TabSpriteNoEnemy
.label NoEN_RunLeMax    =  TabEN_RunLeMax  - TabSpriteNoEnemy
.label NoEN_PoleLeMin   =  TabEN_PoleLeMin - TabSpriteNoEnemy
.label NoEN_PoleLeMax   =  TabEN_PoleLeMax - TabSpriteNoEnemy
.label NoEN_RunRiMin    =  TabEN_RunRiMin  - TabSpriteNoEnemy
.label NoEN_RunRiMax    =  TabEN_RunRiMax  - TabSpriteNoEnemy
.label NoEN_PoleRiMin   =  TabEN_PoleRiMin - TabSpriteNoEnemy
.label NoEN_PoleRiMax   =  TabEN_PoleRiMax - TabSpriteNoEnemy
.label NoEN_LadderMin   =  TabEN_LadderMin - TabSpriteNoEnemy
.label NoEN_LadderMax   =  TabEN_LadderMax - TabSpriteNoEnemy
                
.label NoEN_FallLe      =  TabEN_FallLe    - TabSpriteNoEnemy
.label NoEN_FallRi      =  TabEN_FallRi    - TabSpriteNoEnemy
// ------------------------------------------------------------------------------------------------------------- //
// MovEnThisOne      Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnThisOne:{
    IncEnemyNo:
        inc LR_NoEnemy2Move         // select next enemy
        
    ChkMaxNo:
        ldx LR_EnmyNo               // number of enemies
        cpx LR_NoEnemy2Move         // # of enemy to move
        bcs GetStatus              // max not reached
        
    SetMinNo:
        ldx #LR_NoEnemy2MvMin           // reset to first enemy
        stx LR_NoEnemy2Move
        
    GetStatus:
            jsr GetEnemyStatus          // restore saved status values

    ChkHoleTime:
        lda LRZ_EnemyInHoleTime         // enemy time in hole count down
        bmi MovEnHoleGetOut         // time is more than up
        beq MovEnHoleGetOut         // time is up
        
    DecHoleTime:
        dec LRZ_EnemyInHoleTime         // enemy time in hole count down
        
    ChkShiverTime:
        ldy LRZ_EnemyInHoleTime         // enemy time in hole count down
        cpy #LR_EnmyShivStart           // 
        bcs ChkRebirthTime         // greater/equal
        
    GoShiverOut:
        jmp MovEnShiverOut          // lower - do the shiver and return
        
    ChkRebirthTime:
        ldx LR_NoEnemy2Move         // # of enemy to move
        lda LR_TabEnemyRebTime,x        // enemy rebirth step time
        beq MovEnThisOneX           // 
        
    SavThisStatus:
        jmp MovEnSaveStatus         // still in hole - save status values and finish
MovEnThisOneX:
       jmp MovEnDisplaySave        // enemy sprite out and exit move
}
// ------------------------------------------------------------------------------------------------------------- //
// MovEnHoleGetOut   Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnHoleGetOut:{
        ldy LRZ_EnemyRow            // actual enemy row
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    PtrOrigin:
        sta LRZ_XLvlOriRowHi
        
        ldy LRZ_EnemyCol            // actual enemy col
    GetOrigin:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileLadder           // 
        beq MovEnHoleGetOutX        // go move enemy
        
        cmp #NoTilePole             // 
        bne ChkCenterLower         // 
        
    ChkCenter:
        lda LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        cmp #$02                // centered
        beq MovEnHoleGetOutX        // go move enemy
        
    ChkCenterLower:
        lda LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        cmp #$02                // center
        bcc MovEnFallHole           // lower
        
    ChkCenterHigher:
        ldy LRZ_EnemyRow            // actual enemy row
        cpy #LR_ScrnMaxRows         // $0f - max 15 rows
        beq MovEnHoleGetOutX        // go move enemy
        
        lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        sta LRZ_XLvlOriRowLo
        lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
    PtrOriginBelow:
        sta LRZ_XLvlOriRowHi
        lda TabExLvlModRowHi+1,y        // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    PtrModifyBelow:
        sta LRZ_XLvlModRowHi
        
        ldy LRZ_EnemyCol            // actual enemy col
    GetModifyBelow:
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes row + 1 (directly below enemy)
        
        cmp #NoTileBlank            // 
        beq MovEnFallHole           // 
        
        cmp #NoTileLodeRunner           // 
        beq MovEnFallHole           // 
        
        cmp #NoTileEnemy            // 
        beq MovEnHoleGetOutX        // go move enemy
        
    GetOriginBelow:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes + 1
        cmp #NoTileWallWeak         // 
        beq MovEnHoleGetOutX        // go move enemy
        
        cmp #NoTileWallHard         // 
        beq MovEnHoleGetOutX        // go move enemy
        
        cmp #NoTileLadder           // 
        bne MovEnFallHole           // 
        
MovEnHoleGetOutX:
        jmp MoveEnemy               // go move enemy
}
// ------------------------------------------------------------------------------------------------------------- //
MovEnFallHole:{
        jsr MovEnGetXYNo            // ac=image no  xr=col offset  yr=row offset
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        jsr MovEnCenterLeRi         // 
        
    GetFallLeft:
        lda #NoEN_FallLe            // 
        
        ldy LRZ_EnemyMovDirLR           // actual enemy dir right/left  $ff=left  $01=right
        bmi SetFallLeRi            // 
        
    GetFallRight:
        lda #NoEN_FallRi            // 
        
    SetFallLeRi:
        sta LRZ_EnemySpriteNo           // actual enemy sprite number
        
        inc LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        lda LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        cmp #$05                // max
        bcs MovEnFallDown           // greater/equal
        
        lda LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        cmp #$02                // center
        bne MovEnDisplaySave        // enemy sprite out and exit move
        
    GoTakeGold:
        jsr MovEnTakeGold           // action only if in center of image
        
        ldy LRZ_EnemyRow            // actual enemy row
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    PtrOrigin:
        sta LRZ_XLvlOriRowHi
        
        ldy LRZ_EnemyCol            // actual enemy col
    GetOrigin:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileWallWeak         // 
        bne MovEnDisplaySave        // enemy sprite out and exit move
        
        lda LRZ_EnemyInHoleTime         // enemy time in hole count down
        bpl SetHoleTime            // 
        
    DecGold:
        dec LR_Gold2Get             // 
        
    SetHoleTime:
        lda LR_EnmyHoleTime         // enemy time in hole - values dynamically taken from TabEnmyHoleTime
        sta LRZ_EnemyInHoleTime         // enemy time in hole count down
        
    SetDigScore:
        lda #<LR_ScoreDigIn         // ac=score  10s
        ldy #>LR_ScoreDigIn         // yr=score 100s
MovEnFallHoleX:
        jsr Score2BaseLine
} 
// ------------------------------------------------------------------------------------------------------------- //
MovEnDisplaySave:{
        jsr MovEnGetXYNo            // ac=image no  xr=col offset  yr=row offset
        jsr ImageOutXtra            // set images on game screen (sprites/shoots/hidden ladders)
        jmp MovEnSaveStatus         // save status values and finish
}
// ------------------------------------------------------------------------------------------------------------- //
MovEnFallDown:{
    IniImagePos:
        lda #$00                // 
        sta LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        
        ldy LRZ_EnemyRow            // actual enemy row
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        
        sta LRZ_XLvlModRowLo        // 
        sta LRZ_XLvlOriRowLo        // 
        
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    PtrModify:
        sta LRZ_XLvlModRowHi        // 
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    PtrOrigin:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyCol            // actual enemy col
    GetOrigin:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
    ChkWallWeak:
        cmp #NoTileWallWeak         // 
        bne SetModify              // 
        
    GetEmpty:
        lda #NoTileBlank            // 
        
    SetModify:
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
    IncPosRow:
        inc LRZ_EnemyRow            // actual enemy row
        
        ldy LRZ_EnemyRow            // actual enemy row + 1
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo        // 
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    PtrModifyBelow:
        sta LRZ_XLvlModRowHi        // 
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    PtrOriginBelow:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyCol            // actual enemy col
    GetModifyBelow:
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
    ChkCatchLR:
        cmp #NoTileLodeRunner           // 
        bne GetOriginBelow         // 
        
    KillLR:
        lsr LR_Alive                // $00=lr killed
        
    GetOriginBelow:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileWallWeak         // 
        bne SetModifyEnemy         // display enemy in hole
        
        lda LRZ_EnemyInHoleTime         // enemy time in hole count down
        bpl SetModifyEnemy         // display enemy in hole
        
        ldy LRZ_EnemyRow            // actual enemy row
        dey                     // 
    SetScreenRow:
        sty LRZ_ScreenRow           // screen row  (00-0f)
        
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo        // 
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    PtrModifyAbove:
        sta LRZ_XLvlModRowHi        // 
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    PtrOriginAbove:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyCol            // actual enemy col
    SetScreenCol:
        sty LRZ_ScreenCol           // screen col  (00-1b)
        
    GetOriginAbove:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
    ChkEmpty:
        cmp #NoTileBlank            // 
        beq LeaveGold              // 
        
        dec LR_Gold2Get             // a piece of gold got lost
        jmp OutEnemyInHole         // 
        
    LeaveGold:
        lda #NoTileGold             // 
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
    DisplayGold:
        jsr ImageOut2Prep           // direct output to preparation screen
        
        ldy LRZ_ScreenRow           // screen row  (00-0f)
        ldx LRZ_ScreenCol           // screen col  (00-1b)
        jsr GetColRowGfxOff         // offsets in xr=col yr=row
        
        lda #NoTileGold             // 
        jsr ImageOutXtra            // set images on game screen (sprites/shoots/hidden ladders)
        
    OutEnemyInHole:
        ldy LRZ_EnemyRow            // actual enemy row
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo        // 
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    PtrModifyEnemy:
        sta LRZ_XLvlModRowHi        // 
        
        lda #LR_EnmyHoleTiIni           // $00 - init
        sta LRZ_EnemyInHoleTime         // enemy time in hole count down
        
        ldy LRZ_EnemyCol            // actual enemy col
    SetModifyEnemy:
        lda #NoTileEnemy            // 
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
        jsr MovEnGetXYNo            // ac=image no  xr=col offset  yr=row offset
        jsr ImageOutXtra            // set images on game screen (sprites/shoots/hidden ladders)
MovEnFallDownX:
        jmp MovEnSaveStatus         // save status values and finish
}
// ------------------------------------------------------------------------------------------------------------- //
MovEnShiverOut:{
        cpy #LR_EnmyShivStop        // move out if lower
        bcc MoveEnemy               // 
        
    !ClrOld:
        jsr MovEnGetXYNo            // ac=image no  xr=col offset  yr=row offset
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        
    GetShiver:
        ldy LRZ_EnemyInHoleTime         // enemy time in hole count down
        lda TabEnemyShiver-7,y          // shiver the last hole seconds
        sta LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
        
    SetNew:
        jsr MovEnGetXYNo            // ac=image no  xr=col offset  yr=row offset
        jsr ImageOutXtra            // set images on game screen (sprites/shoots/hidden ladders)
        
MovEnShiverOutX:
        jmp MovEnSaveStatus         // save status values and finish
}
// ------------------------------------------------------------------------------------------------------------- //
TabEnemyShiver:
        .byte $02                // let enemy shiver from left ro right before leaving a hole
        .byte $01
        .byte $02
        .byte $03
        .byte $02
        .byte $01
// ------------------------------------------------------------------------------------------------------------- //
MoveEnemy:{
        ldx LRZ_EnemyCol            // actual enemy col
        ldy LRZ_EnemyRow            // actual enemy row
        jsr MovEnGetMoveDir         // 
        
        asl                   // 
        tay                     // 
        lda TabMovEnDir+1,y         // 
        pha                     // 
        lda TabMovEnDir,y           // 
        pha                     // 
        
MoveEnemyX:
        rts                     // dispatch move
}
// ------------------------------------------------------------------------------------------------------------- //
TabMovEnDir:
        .word MovEnSaveStatus -1         // $00 - no move - save status values and finish
        .word MovEnLeft       -1         // $01
        .word MovEnRight      -1         // $02
        .word MovEnUp         -1         // $03
        .word MovEnDown       -1         // $04
// ------------------------------------------------------------------------------------------------------------- //
MovEnIncHoleTime:{
        lda LRZ_EnemyInHoleTime         // enemy time in hole count down
        beq MovEnIncHoleTimeX           // 
        bmi MovEnIncHoleTimeX           // 
        
        inc LRZ_EnemyInHoleTime         // enemy time in hole count down
        
MovEnIncHoleTimeX:
    jmp MovEnSaveStatus         // save status values and finish
}
// ------------------------------------------------------------------------------------------------------------- //
MovEnUp:{
        ldy LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        cpy #$03                // 
        bcs MovEnUpStep             // greater/equal
        
    ChkTopRow:
        ldy LRZ_EnemyRow            // actual enemy row
        beq MovEnIncHoleTime        // already already max up
        
    SetRowAbove:
        dey                     // 
        
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo        // 
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    PtrModifyAbove:
        sta LRZ_XLvlModRowHi        // 
        
        ldy LRZ_EnemyCol            // actual enemy col
    GetModifyAbove:
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
        cmp #NoTileWallWeak         // 
        beq MovEnIncHoleTime        // blocked
        
        cmp #NoTileWallHard         // 
        beq MovEnIncHoleTime        // blocked
        
        cmp #NoTileWallTrap         // 
        beq MovEnIncHoleTime        // blocked
        
        cmp #NoTileEnemy            // 
MovEnUpX:
        beq MovEnIncHoleTime        // blocked
}
// ------------------------------------------------------------------------------------------------------------- //
MovEnUpStep:{

        jsr MovEnGetXYNo            // ac=image no  xr=col offset  yr=row offset
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        jsr MovEnCenterLeRi         // 
        
    !SetRowThis:
        ldy LRZ_EnemyRow            // actual enemy row
        
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo        // 
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    !PtrModify:
        sta LRZ_XLvlModRowHi        // 
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi        // 
        
    !StepUp:
        dec LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        bpl MovEnGoTakeGold         // 
        
    GoDropGold:
        jsr MovEnDropGold           // 
        
        ldy LRZ_EnemyCol            // actual enemy col
    !GetOrigin:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileWallWeak         // 
        bne !SetModify+              // 
        
        lda #NoTileBlank            // clear
        
    !SetModify:
            sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
    !SetRowAbove:
        dec LRZ_EnemyRow            // actual enemy row
        
        ldy LRZ_EnemyRow            // actual enemy row
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo        // 
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    !PtrModifyAbove:
        sta LRZ_XLvlModRowHi        // 
        
        ldy LRZ_EnemyCol            // actual enemy col
    !GetModifyAbove:
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
    !ChkCatchLR:
        cmp #NoTileLodeRunner           // 
        bne !GetEnTile+              // 
        
    !KillLR:
        lsr LR_Alive                // $00=lr killed
        
    !GetEnTile:
        lda #NoTileEnemy            // 
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
        lda #$04
        sta LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        bne MovEnGetNextImgUD          // always
        
    MovEnGoTakeGold:
        jsr MovEnTakeGold           // 
        
    MovEnGetNextImgUD:
        lda #NoEN_LadderMin    
        ldx #NoEN_LadderMax    
        
    !GetEnNextImgNo:
        jsr MovENSetImg             // increase sprite number and check range
        jsr MovEnGetXYNo            // ac=image no  xr=col offset  yr=row offset
        jsr ImageOutXtra            // set images on game screen (sprites/shoots/hidden ladders)
        
    !MovEnUpStepX:
        jmp MovEnSaveStatus         // save status values and finish
}
// ------------------------------------------------------------------------------------------------------------- //
MovEnDown:{
        ldy LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        cpy #$02
        bcc MovEnDownStep
        
    !ChkBotRow:
        ldy LRZ_EnemyRow            // actual enemy row
        cpy #LR_ScrnMaxRows         // 
        bcs !MovEnDownX+              // already max down
        
    !SetRowBelow:
        iny                     // 
        
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    !PtrModifyBelow:
        sta LRZ_XLvlModRowHi
        
        ldy LRZ_EnemyCol            // actual enemy col
    !GetModifyAbove:
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
        cmp #NoTileWallHard
        beq !MovEnDownX+              // blocked
        
        cmp #NoTileEnemy
        beq !MovEnDownX+              // blocked
        
        cmp #NoTileWallWeak         // blocked
        bne MovEnDownStep
        
    !MovEnDownX:
        jmp MovEnSaveStatus         // save status values and finish
}
// ------------------------------------------------------------------------------------------------------------- //
MovEnDownStep:{
        jsr MovEnGetXYNo            // ac=image no  xr=col offset  yr=row offset
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        jsr MovEnCenterLeRi         // 
        
    !SetRowThis:
        ldy LRZ_EnemyRow            // actual enemy row
        
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        sta LRZ_XLvlOriRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    !PtrModify:
        sta LRZ_XLvlModRowHi
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi
        
    !StepDown:
        inc LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        lda LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        cmp #$05                // 
        bcc !MovEnDownStepX+          // lower - go get gold
        
    !GoDropGold:
        jsr MovEnDropGold           // 
        
        ldy LRZ_EnemyCol            // actual enemy col
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        cmp #NoTileWallWeak         // 
        bne !SetModify+              // 
        
        lda #NoTileBlank            // clear
        
    !SetModify:
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
    !SetRowBelow:
        inc LRZ_EnemyRow            // actual enemy row
        
        ldy LRZ_EnemyRow            // actual enemy row
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    !PtrModifyBelow:
        sta LRZ_XLvlModRowHi
        
        ldy LRZ_EnemyCol            // actual enemy col
    !GetModifyBelow:
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
    !ChkCatchLR:
        cmp #NoTileLodeRunner           // 
        bne !GetEnTile+              // 
        
    !KillLR:
        lsr LR_Alive                // $00=lr killed
        
    !GetEnTile:
        lda #NoTileEnemy
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
        lda #$00
        sta LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        jmp MovEnUpStep.MovEnGetNextImgUD           // 
        
    !MovEnDownStepX:
        jmp MovEnUpStep.MovEnGoTakeGold
} 
// ------------------------------------------------------------------------------------------------------------- //
MovEnLeft:{
    !SetRowThis:
        ldy LRZ_EnemyRow            // actual enemy row
        
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo        // 
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    !PtrModify:
        sta LRZ_XLvlModRowHi        // 
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi        // 
        
        ldx LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
        cpx #$03                // 
        bcs MovEnLeftStep           // greater/equal
        
    !ChkMaxLeft:
        ldy LRZ_EnemyCol            // actual enemy col
        beq !MovEnLeftX+              // already max left
        
    !SetColLeft:
        dey                     // 
        
    !GetModifyLeft:
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        cmp #NoTileEnemy            // 
        beq !MovEnLeftX+              // blocked
        
        cmp #NoTileWallHard         // 
        beq !MovEnLeftX+              // blocked
        
        cmp #NoTileWallWeak         // 
        beq !MovEnLeftX+              // blocked
        
    !GetOriginLeft:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileWallTrap         // blocked
        bne MovEnLeftStep           // 
        
    !MovEnLeftX:
        jmp MovEnSaveStatus         // save status values and finish
}
// ------------------------------------------------------------------------------------------------------------- //
MovEnLeftStep:{
        jsr MovEnGetXYNo            // ac=image no  xr=col offset  yr=row offset
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        jsr MovEnCenterUpDo         // 
        
        lda #LRZ_EnemyMovLeft           // 
        sta LRZ_EnemyMovDirLR           // actual enemy dir right/left  $ff=left  $01=right
        
    !StepLeft:
        dec LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
        bpl !GoTakeGold+
        
    !GoDropGold:
        jsr MovEnDropGold           // 
        
        ldy LRZ_EnemyCol            // actual enemy col
    !GetModifyLeft1:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileWallWeak         // 
        bne !SetModifyLeft+          // 
        
        lda #NoTileBlank            // clear
        
    !SetModifyLeft:
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
    !SetColLeft:
        dec LRZ_EnemyCol            // actual enemy col
        dey                     //
        
    !GetColLeft:
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
    !ChkCatchLR:
        cmp #NoTileLodeRunner           // 
        bne !GetEnTile+              // 
        
    !KillLR:
        lsr LR_Alive                // $00=lr killed
        
    !GetEnTile:
        lda #NoTileEnemy
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
        lda #$04
        sta LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
        bne !GetModifyLeft2+         // always
        
    !GoTakeGold:
        jsr MovEnTakeGold           // 
        
    !GetModifyLeft2:
        ldy LRZ_EnemyCol            // actual enemy col
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
    !ChkPole:
        cmp #NoTilePole             // 
        beq !SetSpritePoleLe+        // 
        
    !SetSpriteRunLe:
        lda #NoEN_RunLeMin          // !hbu008!
        ldx #NoEN_RunLeMax          // !hbu008
        bne !DisplaySprite+          // always
        
    !SetSpritePoleLe:
        lda #NoEN_PoleLeMin         // !hbu008!
        ldx #NoEN_PoleLeMax         // !hbu008!
        
    !DisplaySprite:
        jsr MovENSetImg             // increase sprite number and check range
        jsr MovEnGetXYNo            // ac=image no  xr=col offset  yr=row offset
        jsr ImageOutXtra            // set images on game screen (sprites/shoots/hidden ladders)
        
    !MovEnLeftStepX:
        jmp MovEnSaveStatus         // save status values and finish
}
// ------------------------------------------------------------------------------------------------------------- //
MovEnRight:{
    !SetRowThis:
        ldy LRZ_EnemyRow            // actual enemy row
        
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        sta LRZ_XLvlOriRowLo
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    !PtrModify:
        sta LRZ_XLvlModRowHi
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi
        
        ldx LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
        cpx #$02
        bcc StepEnemyRight
        
    !ChkMaxRight:
        ldy LRZ_EnemyCol            // actual enemy col
        cpy #LR_ScrnMaxCols
        beq !MovEnRightX+             // already max right
        
    !SetColRight:
        iny
        
    !GetModifyRight:
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
        cmp #NoTileEnemy
        beq !MovEnRightX+             // blocked
        
        cmp #NoTileWallHard
        beq !MovEnRightX+             // blocked
        
        cmp #NoTileWallWeak
        beq !MovEnRightX+             // blocked
        
    !GetOriginLeft:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileWallTrap         // blocked
        bne StepEnemyRight          // Ladder/Pole/XitLadder/Gold/LR
        
    !MovEnRightX:
        jmp MovEnSaveStatus         // save status values and finish
}
// ------------------------------------------------------------------------------------------------------------- //
StepEnemyRight:{
        jsr MovEnGetXYNo            // ac=image no  xr=col offset  yr=row offset
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        jsr MovEnCenterUpDo 
        
        lda #LRZ_EnemyMovRight 
        sta LRZ_EnemyMovDirLR           // actual enemy dir right/left  $ff=left  $01=right
        
    !StepRight:
        inc LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
        lda LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
        cmp #$05
        bcc !GoTakeGold+
        
    !GoDropGold:
        jsr MovEnDropGold 
        
        ldy LRZ_EnemyCol            // actual enemy col
    !GetOriginRight1:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileWallWeak  
        bne !SetModifyRight+ 
        
        lda #NoTileBlank            // clear
        
    !SetModifyRight:
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
    !SetColRight:
        inc LRZ_EnemyCol            // actual enemy col
        iny                     // 
        
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
    !ChkCatchLR:
        cmp #NoTileLodeRunner           // 
        bne !GetEnTile+              // 
        
    !KillLR:
        lsr LR_Alive                // $00=lr killed
        
    !GetEnTile:
        lda #NoTileEnemy            // 
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
    
        lda #$00                // 
        sta LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
        beq !GetOriginRight2+ 
    
    !GoTakeGold:
        jsr MovEnTakeGold  
        
    !GetOriginRight2:
        ldy LRZ_EnemyCol            // actual enemy col
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTilePole             // 
        beq !SetSpritePoleRi+        // 
        
    SetSpriteRunRi:
        lda #NoEN_RunRiMin  
        ldx #NoEN_RunRiMax  
        bne !DisplaySprite+
        
    !SetSpritePoleRi:
        lda #NoEN_PoleRiMin 
        ldx #NoEN_PoleRiMax 
        
    !DisplaySprite:
        jsr MovENSetImg             // increase sprite number and check range
        jsr MovEnGetXYNo            // ac=image no  xr=col offset  yr=row offset
        jsr ImageOutXtra            // set images on game screen (sprites/shoots/hidden ladders)
        
    !StepEnemyRightX:
        jmp MovEnSaveStatus         // save status values and finish
}
// ------------------------------------------------------------------------------------------------------------- //
//  Function: 
//  Parms   : xr=LRZ_EnemyCol yr=LRZ_EnemyRow
//  Returns : ac=move dir
// ------------------------------------------------------------------------------------------------------------- //
MovEnGetMoveDir:{
        stx LRZ_EnemyColGetDir          // actual enemy work col
        sty LRZ_EnemyRowGetDir          // actual enemy work row
        
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyColGetDir          // actual enemy work col
    !GetOrigin:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes

    !ChkWallWeak:
        cmp #NoTileWallWeak         // a weak wall in original data must be a hole here
        bne MovEnTstRowLR           // not in hole
        
        lda LRZ_EnemyInHoleTime         // enemy time in hole count down
        beq MovEnTstRowLR           //   is up
        bmi MovEnTstRowLR           //   is up
        
    !GetMoveUp:
        lda #LR_EnemyMoveUp         // move out of hole here
        
    !MovEnGetMoveDirX:
        rts
} 
// ------------------------------------------------------------------------------------------------------------- //
MovEnTstRowLR:{

        ldy LRZ_EnemyRowGetDir          // actual enemy work row
        cpy LRZ_LodeRunRow          // actual row lode runner
        beq MovEnOnSameRowLR        // lode runner and THIS enemy are on the same row
        jmp MovEnOnDiffRowLR        // lode runner and THIS enemy are on different rows
}
// ------------------------------------------------------------------------------------------------------------- //
MovEnOnSameRowLR:{

        ldy LRZ_EnemyColGetDir          // actual enemy work col
        sty LRZ_EnemyColGetDirSav       // save actual enemy work col
        cpy LRZ_LodeRunCol          // actual col lode runner
        bcs MovEnIsRightOfLR        // greater/equal
}
// ------------------------------------------------------------------------------------------------------------- //
MovEnIsLeftOfLR:{

    !SetNextColRight:
        inc LRZ_EnemyColGetDirSav       // save actual enemy work col
        
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyColGetDirSav       // save actual enemy work col
    !GetOriginRight:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileLadder           // ladder - do not check for empty/trap
        beq !ChkLRReached+           // 
        
        cmp #NoTilePole             // pole - do not check for empty/trap
        beq !ChkLRReached+           // 
        
    !ChkMaxRow:
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
        cpy #LR_ScrnMaxRows
        beq !ChkLRReached+           // bottom reached
        
        lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOriginBelow:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyColGetDirSav       // save actual enemy work col
    !GetOriginBelowRi:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileBlank            // empty without pole/ladder above
        beq MovEnOnDiffRowLR        // no move right
        
        cmp #NoTileWallTrap         // trap without pole/ladder above
        beq MovEnOnDiffRowLR        // no move right
        
    !ChkLRReached:
        ldy LRZ_EnemyColGetDirSav       // save actual enemy work col
        cpy LRZ_LodeRunCol          // actual col lode runner
        bne !SetNextColRight-        // lr pos not reached - set next right
        
        lda #LR_EnemyMoveRi         // move right if no empty/trap is found in space between LR and EN
        
    !MovEnIsLeftOfLRX:
        rts                     // without a ladder/pole above
}
// ------------------------------------------------------------------------------------------------------------- //
MovEnIsRightOfLR:{

    !SetNextColLeft:
        dec LRZ_EnemyColGetDirSav       // save actual enemy work col
        
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyColGetDirSav       // save actual enemy work col
    !GetOriginLeft:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileLadder           // ladder - do not check for empty/trap
        beq !ChkLRReached+           // 
        
        cmp #NoTilePole             // pole - do not check for empty/trap
        beq !ChkLRReached+           // 
        
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
        cpy #$0f
        beq !ChkLRReached+
        
        lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOriginBelow:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyColGetDirSav       // save actual enemy work col
    !GetOriginBelowLe:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileBlank            // empty without pole/ladder above
        beq MovEnOnDiffRowLR        // no move left
        
        cmp #NoTileWallTrap         // trap without pole/ladder above
        beq MovEnOnDiffRowLR        // no move ledt
        
    !ChkLRReached:
        ldy LRZ_EnemyColGetDirSav       // save actual enemy work col
        cpy LRZ_LodeRunCol          // actual col lode runner
        bne !SetNextColLeft-         // lr pos not reached - set next left
        
        lda #LR_EnemyMoveLe         // move left if no empty/trap is found in space between LR and EN
        
    !MovEnIsRightOfLRX:
        rts                     // without a ladder/pole above
}
// ------------------------------------------------------------------------------------------------------------- //
MovEnOnDiffRowLR:{ 
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
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function: Check from max left col up to actual col for a possible move left
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnTst4MoveLeft:{

    !GetMaxColLeft:
        ldy LRZ_EnemyMaxColLe           // maximum move left - without walls !!! in the way
    !ChkSavColLeft:
        cpy LRZ_EnemyColGetDir          // actual enemy work col
        beq !MovEnTst4MoveLeftX+          // check left ready if max=actual col
        
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
    !ChkMaxRow:
        cpy #LR_ScrnMaxRows         // 
        beq !TryLadder4Up+           // 
        
        lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOriginBelow:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyMaxColLe           // maximum move left - without walls !!! in the way
    !GetOriginBelowML:
        lda (LRZ_XLvlOriPos),y          // below max left - original level data - without lr/en replacements/holes
        
        cmp #NoTileWallWeak         // wall
        beq !TryLadder4Up+           // no move left poosible - check for ladder
        
        cmp #NoTileWallHard         // wall
        beq !TryLadder4Up+           // no move left poosible - check for ladder
        
        ldx LRZ_EnemyMaxColLe           // maximum move left - without walls !!! in the way
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
        jsr MovEnGetMaxRowDo        // ac=target row
        
        ldx LRZ_EnemyMaxColLe           // maximum move left - without walls !!! in the way
        jsr MovEnGetDirMin          // 
        
        cmp LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
        bcs !TryLadder4Up+           // greater/equal
        
    !SetNewDirMinLe01:
        sta LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
    
    !SetDirLeft01:
        lda #LR_EnemyMoveLe         // 
        sta LRZ_EnemyMovDir         // actual enemy move direction
        
    !TryLadder4Up:
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
        beq !IncMaxColLeft+          // max up reached already - no climbing possible
        
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyMaxColLe           // maximum move left - without walls !!! in the way
    !GetOrigin:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes  
        
        cmp #NoTileLadder           // ladder
        bne !IncMaxColLeft+          // 
        
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
        ldx LRZ_EnemyMaxColLe           // maximum move left - without walls !!! in the way
        jsr MovEnFindMoveUp         // ac=target row
        
        ldx LRZ_EnemyMaxColLe           // maximum move left - without walls !!! in the way
        jsr MovEnGetDirMin          // 
        
        cmp LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
        bcs !IncMaxColLeft+          // greater/equal
        
    !SetNewDirMinLe02:
        sta LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
        
    !SetDirLeft02:
        lda #LR_EnemyMoveLe         // 
        sta LRZ_EnemyMovDir         // actual enemy move direction
        
    !IncMaxColLeft:
        inc LRZ_EnemyMaxColLe           // maximum move left - without walls !!! in the way
        jmp !GetMaxColLeft-          // try next col right
        
    !MovEnTst4MoveLeftX:
        rts
} 
// ------------------------------------------------------------------------------------------------------------- //
//               Function: Check from max right col down to actual col for a possible move right
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnTst4MoveRight:{
    !GetMaxColRight:
        ldy LRZ_EnemyMaxColRi           // maximum move right - without walls !!! in the way
    !ChkSavColLeft:
        cpy LRZ_EnemyColGetDir          // actual enemy work col
        beq !MovEnTst4MoveRightX+         // check right ready if max=actual col
        
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
    !ChkMaxRow:
        cpy #LR_ScrnMaxRows         // 
        beq !TryLadder4Up+           // max down reached
        
        lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOriginBelow:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyMaxColRi           // maximum move right - without walls !!! in the way
    !GetOriginBelowMR:
        lda (LRZ_XLvlOriPos),y          // below max right - original level data - without lr/en replacements/holes
        
        cmp #NoTileWallWeak         // wall
        beq !TryLadder4Up+           // no move right poosible - check for ladder
        
        cmp #NoTileWallHard         // wall
        beq !TryLadder4Up+           // no move right poosible - check for ladder
        
        ldx LRZ_EnemyMaxColRi           // maximum move right - without walls !!! in the way
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
        jsr MovEnGetMaxRowDo        // ac=target row
        
        ldx LRZ_EnemyMaxColRi           // maximum move right - without walls !!! in the way
        jsr MovEnGetDirMin          // 
        
        cmp LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
        bcs !TryLadder4Up+           // greater/equal
        
    !SetNewDirMinRi01:
        sta LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
        
    !SetDirRight01:
        lda #LR_EnemyMoveRi         // 
        sta LRZ_EnemyMovDir         // actual enemy move direction
    
    !TryLadder4Up:
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
        beq !DecMaxColRight+         // max up reached already - no climbing possible
        
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyMaxColRi           // maximum move right - without walls !!! in the way
    !GetOrigin:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileLadder           // ladder
        bne !DecMaxColRight+         // 
        
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
        ldx LRZ_EnemyMaxColRi           // maximum move right - without walls !!! in the way
        jsr MovEnFindMoveUp         // 
        
        ldx LRZ_EnemyMaxColRi           // maximum move right - without walls !!! in the way
        jsr MovEnGetDirMin          // 
        
        cmp LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
        bcs !DecMaxColRight+         // greater/equal
        
    !SetNewDirMinRi02:
        sta LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
        
    !SetDirRight02:
        lda #LR_EnemyMoveRi         // 
        sta LRZ_EnemyMovDir         // actual enemy move direction
        
    !DecMaxColRight:
        dec LRZ_EnemyMaxColRi           // maximum move right - without walls !!! in the way
        jmp !GetMaxColRight-         // 
    
    !MovEnTst4MoveRightX:
        rts
} 
// ------------------------------------------------------------------------------------------------------------- //
// MovEnGetMaxRowUD   Function:
//                Parms   :
//                Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnGetMaxRowUD:{
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
        cpy #LR_ScrnMaxRows         // 
        beq !ChkTopOfScreen+         // already on bottom of screen
        
        lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOriginBelow:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyColGetDir          // actual enemy work col
    !GetOriginBelow:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileWallWeak         // wall
        beq !ChkTopOfScreen+         // no move up
        
        cmp #NoTileWallHard         // wall
        beq !ChkTopOfScreen+         // no move up
        
        ldx LRZ_EnemyColGetDir          // actual enemy work col
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
        jsr MovEnGetMaxRowDo        // ac=target row
        
        ldx LRZ_EnemyColGetDir          // actual enemy work col
        jsr MovEnGetDirMin          // 
        
        cmp LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
        bcs !ChkTopOfScreen+         // 
        
    !SetNewDirMinDown:
        sta LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
        
    !SetDirDown:
        lda #LR_EnemyMoveDo         // move down to
        sta LRZ_EnemyMovDir         // actual enemy move direction
        
    !ChkTopOfScreen:
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
        beq !MovEnGetMaxRowUDX+           // 
        
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi
        
        ldy LRZ_EnemyColGetDir          // actual enemy work col
    !GetOrigin:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileLadder           // ladder
        bne !MovEnGetMaxRowUDX+           // no - no move up
        
        ldx LRZ_EnemyColGetDir          // actual enemy work col
        ldy LRZ_EnemyRowGetDir          // actual enemy work row
        jsr MovEnFindMoveUp         // 
        
        ldx LRZ_EnemyColGetDir          // actual enemy work col
        jsr MovEnGetDirMin          // 
        
        cmp LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
        bcs !MovEnGetMaxRowUDX+           // 
        
    !SetNewDirMinUp:
        sta LRZ_EnemyMovDirMin          // value for for move dir select compare - lowest wins
        
    !SetDirUp:
        lda #LR_EnemyMoveUp         // move up to
        sta LRZ_EnemyMovDir         // actual enemy move direction
        
    !MovEnGetMaxRowUDX:
        rts
} 
// ------------------------------------------------------------------------------------------------------------- //
// Function:
// Parms   : ac=max row  xr=max col left/right
// Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnGetDirMin:{
        sta LRZ_Work                // save max row
        
    !ChkRowLR:
        cmp LRZ_LodeRunRow          // actual row lode runner
        bne !NotSameRowLR+           // target row not same as LR row
        
    !ChkCol:
        cpx LRZ_EnemyCol            // same - actual enemy col
        bcc !ColMaxLower+            // lower
        
    !ColMaxHigher:
        txa 
        sec 
        sbc LRZ_EnemyCol            // actual enemy col
    !ExitSameHi:
        rts
        
    !ColMaxLower:
        stx LRZ_Work                // max col left/right
        
        lda LRZ_EnemyCol            // actual enemy col
        sec
        sbc LRZ_Work                // save target row
    !ExitSameLo:
        rts
        
    !NotSameRowLR:
        bcc !RowAboveLR+             // enemy on row above LR
        
    !RowBelowLR:
        sec                     // enemy on row below LR
        sbc LRZ_LodeRunRow          // actual row lode runner
        clc 
        adc #$64 * 2                // $c8
    !ExitBelow:
        rts 
        
    !RowAboveLR:
        lda LRZ_LodeRunRow          // actual row lode runner
        sec  
        sbc LRZ_Work                // save target row
        clc
        adc #$64
        
    !MovEnGetDirMinX:
        rts
} 
// ------------------------------------------------------------------------------------------------------------- //
MovEnFindUpSav:{
        lda LRZ_EnemyRowSavUD           // target row from work row
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//  Function:
//  Parms   : xr=corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi yr=enemy row
//  Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnFindMoveUp:{
        sty LRZ_EnemyRowSavUD           // actual enemy row
        stx LRZ_EnemyColSavUD           // corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi
        
    !SetNextOrigin:
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin01:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyColSavUD           // corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi
    !GetOrigin01:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileLadder           // ladder
    !XitWithOriginRow:
        bne MovEnFindUpSav          // no - exit and return saved row
        
    !DecSavRowUD:
        dec LRZ_EnemyRowSavUD           // yes - may move up so point to next row above enemy
        
        ldy LRZ_EnemyColSavUD           // corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi
    ChkMaxColLe:
        beq !ChkMaxColRi+            // already max left
        
        dey 
    GetOriginLeft:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileWallWeak         // wall
        beq !SetSavRow2MaxRowLe+         // 
        
        cmp #NoTileWallHard         // wall
        beq !SetSavRow2MaxRowLe+         // 
        
        cmp #NoTileLadder           // ladder
        beq !SetSavRow2MaxRowLe+         // 
        
        ldy LRZ_EnemyRowSavUD           // target row from work row
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOriginAbove01:
        sta LRZ_XLvlOriRowHi
        
        ldy LRZ_EnemyColSavUD           // corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi
        dey
    !GetOriginAboveLe:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTilePole             // pole
        bne !ChkMaxColRi+            // no
        
    !SetSavRow2MaxRowLe:
        ldy LRZ_EnemyRowSavUD           // target row from work row
        sty LRZ_EnemyRowMaxUD           // actual max row
        
    !XitWithBelowEquLe:
        cpy LRZ_LodeRunRow          // actual row lode runner
        bcc MovEnFindRowMaxUp           // lower
        beq MovEnFindRowMaxUp           // equal - move up only not above LR row
        
    !ChkMaxColRi:
        ldy LRZ_EnemyColSavUD           // corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi
        cpy #LR_ScrnMaxCols         // 
        beq !ChkTop+                 // 
        
        ldy LRZ_EnemyRowSavUD           // target row from work row
        lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin02:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyColSavUD           // corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi
        iny                     // 
    GetOriginRight:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileWallWeak         // wall
        beq !SetSavRow2MaxRowRi+         // 
        
        cmp #NoTileWallHard         // wall
        beq !SetSavRow2MaxRowRi+         // 
        
        cmp #NoTileLadder           // ladder
        beq !SetSavRow2MaxRowRi+         // 
        
        ldy LRZ_EnemyRowSavUD           // target row from work row
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOriginAbove02:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyColSavUD           // corrected LRZ_EnemyMaxColLe/LRZ_EnemyMaxColRi
        iny
    !PtrOriginAboveRi:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTilePole             // pole
        bne !ChkTop+                 // 
        
    !SetSavRow2MaxRowRi:
        ldy LRZ_EnemyRowSavUD           // target row from work row
        sty LRZ_EnemyRowMaxUD           // actual max row
        
    !XitWithBelowEquRi:
        cpy LRZ_LodeRunRow          // actual row lode runner
        bcc MovEnFindRowMaxUp           // 
        beq MovEnFindRowMaxUp           // 
        
    !ChkTop:
        ldy LRZ_EnemyRowSavUD           // target row from work row
        cpy #LR_ScrnMinRows + 1           // 
        bcc !RetTargetRow+           // lower 
        
    !GoCheckNext:
        jmp !SetNextOrigin-          // 

    !RetTargetRow:
        tya                     // return LRZ_EnemyRowSavUD
        
    !MovEnFindMoveUpX:
        rts
} 
// ------------------------------------------------------------------------------------------------------------- //
MovEnFindRowMaxUp:{

        lda LRZ_EnemyRowMaxUD           // actual max row
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
MovEnGetMaxRowSav:{
        lda LRZ_EnemyRowSavUD           // target row from work row
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// MovEnGetMaxRowDo  Function: 
//               Parms   :
//               Returns : LRZ_EnemyMaxColLe
// ------------------------------------------------------------------------------------------------------------- //
MovEnGetMaxRowDo:{
        sty LRZ_EnemyRowSavUD           // target row from work row
        stx LRZ_EnemyColSavUD           // target col from work col
        
    !ChkNextBelow:
        lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOriginBelow:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyColSavUD           // target col from work col
    !GetOriginBelow:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileWallWeak         // wall
        beq MovEnGetMaxRowSav           // 
        
        cmp #NoTileWallHard         // wall
        beq MovEnGetMaxRowSav           // 
        
        ldy LRZ_EnemyRowSavUD           // target row from work row
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyColSavUD           // target col from work col
    !GetOrigin:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileBlank            // empty
        beq !IncRowSavUD+            // 
        
        cpy #$00                // max left
        beq !ChkMaxColSavUD+         // 
        
        dey                     // 
    !GetOriginLe:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTilePole             // pole
        beq !SetSav2MaxRowLe+        // 
        
        ldy LRZ_EnemyRowSavUD           // target row from work row
        lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOriginBelowLe:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyColSavUD           // target col from work col
        dey                     // 
    !GetOriginBelowLe:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileWallWeak         // wall
        beq !SetSav2MaxRowLe+        // 
        
        cmp #NoTileWallHard         // wall
        beq !SetSav2MaxRowLe+        // 
        
        cmp #NoTileLadder           // ladder
        bne !ChkMaxColSavUD+         // all others - empty/pole/trap/gold
        
    !SetSav2MaxRowLe:
        ldy LRZ_EnemyRowSavUD           // target row from work row
        sty LRZ_EnemyRowMaxUD           // actual max row
        
        cpy LRZ_LodeRunRow          // actual row lode runner
        bcs !RetRowMaxUD+            // greater/equal row LR
        
    !ChkMaxColSavUD:
        ldy LRZ_EnemyColSavUD           // target col from work col
        cpy #LR_ScrnMaxCols         // 
        bcs !IncRowSavUD+            // max right reached
        
        iny                     // 
    !GetOriginRi:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTilePole             // pole
        beq !SetSav2MaxRowRi+        // 
        
        ldy LRZ_EnemyRowSavUD           // target row from work row
        lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOriginBelowRi:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyColSavUD           // target col from work col
        iny                     // 
    !GetOriginBelowRi:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileWallWeak         // wall
        beq !SetSav2MaxRowRi+        // 
        
        cmp #NoTileLadder           // ladder
        beq !SetSav2MaxRowRi+        // 
        
        cmp #NoTileWallHard         // wall
        bne !IncRowSavUD+            // all others - empty/pole/trap/gold
        
    !SetSav2MaxRowRi:
        ldy LRZ_EnemyRowSavUD           // target row from work row
        sty LRZ_EnemyRowMaxUD           // actual max row
        
        cpy LRZ_LodeRunRow          // actual row lode runner
        bcs !RetRowMaxUD+            // greater/equal row LR
        
    !IncRowSavUD:
        inc LRZ_EnemyRowSavUD           // target row from work row
        
    !ChkRowSavUD:
        ldy LRZ_EnemyRowSavUD           // target row from work row
        cpy #LR_ScrnMaxRows+1           // 
        bcs !RetRowMaxScren+         // greater/equal
        
    !GoCheckNext:
        jmp !ChkNextBelow-           // next round
        
    !RetRowMaxScren:
        lda #LR_ScrnMaxRows         // 
        rts                     // 
        
    !RetRowMaxUD:
        lda LRZ_EnemyRowMaxUD           // actual max row
    !MovEnGetMaxRowDoX:
        rts
} 
// ------------------------------------------------------------------------------------------------------------- //
// MovEnGetMaxColLR   Function: Gets the max possible move column left/right
//                Parms   :
//                Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnGetMaxColLR:{
        stx LRZ_EnemyMaxColLe           // maximum move left - without walls !!! in the way
        stx LRZ_EnemyMaxColRi           // maximum move right - without walls !!! in the way
        sty LRZ_EnemyRowSav         // save actual enemy work row
        
    !GetNextColLeft:
        lda LRZ_EnemyMaxColLe           // maximum move left - without walls !!! in the way
        beq !GetNextColRight+        // max col left already reached
        
        ldy LRZ_EnemyRowSav         // save actual enemy work row
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo        // 
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    !PtrModifyLeft:
        sta LRZ_XLvlModRowHi        // 
        
        ldy LRZ_EnemyMaxColLe           // maximum move left - without walls !!! in the way
        dey                     // get tile one left from
    !GetModifyLeft:
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
        cmp #NoTileWallWeak         // wall
        beq !GetNextColRight+        // no move left
        
        cmp #NoTileWallHard         // wall
        beq !GetNextColRight+        // no move left
        
        cmp #NoTileLadder           // ladder
        beq !SetNextColLeft+         // check next left
        
        cmp #NoTilePole             // pole
        beq !SetNextColLeft+         // check next left
        
    !ChkMaxRowLeft:
        ldy LRZ_EnemyRowSav         // empty/trap/gold/en/lr left to check here
        cpy #LR_ScrnMaxRows         // 
        beq !SetNextColLeft+         // enemy on bottom row already - check next left
        
        lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOriginBelowLe:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyMaxColLe           // maximum move left - without walls !!! in the way
        dey                     // get tile one left/down from
    !GetOriginBelowLe:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileWallWeak         // wall below an empty/trap on the actual left
        beq !SetNextColLeft+         // check next left
        
        cmp #NoTileWallHard         // wall below an empty/trap on the actual left
        beq !SetNextColLeft+         // check next left
        
        cmp #NoTileLadder           // ladder below an empty/trap on the actual left
        bne !SetOneXtraLeft+         // empty/pole/trap/gold - dec and check right
        
    !SetNextColLeft:
        dec LRZ_EnemyMaxColLe           // maximum move left - without walls !!! in the way
        bpl !GetNextColLeft-
        
    !SetOneXtraLeft:
        dec LRZ_EnemyMaxColLe           // maximum move left - without walls !!! in the way
        
    !GetNextColRight:
        lda LRZ_EnemyMaxColRi           // maximum move right - without walls !!! in the way
        cmp #LR_ScrnMaxCols         // $1b
        beq !MovEnGetMaxColLRX+           // max col right already reached
        
        ldy LRZ_EnemyRowSav         // save actual enemy work row
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo        // 
        lda TabExLvlModRowHi,y          // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    !PtrModify4Ri:
        sta LRZ_XLvlModRowHi        // 
        
        ldy LRZ_EnemyMaxColRi           // maximum move right - without walls !!! in the way
        iny                     // try one tile right from
    !GetModifyRight:
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
        cmp #NoTileWallWeak         // wall
        beq !MovEnGetMaxColLRX+           // no move right
        
        cmp #NoTileWallHard         // wall
        beq !MovEnGetMaxColLRX+           // no move right
        
        cmp #NoTileLadder           // ladder
        beq !SetNextColRight+        // check next right
        
        cmp #NoTilePole             // pole
        beq !SetNextColRight+        // check next right
        
    !ChkMaxRowRight:
        ldy LRZ_EnemyRowSav         // save actual enemy work row
        cpy #LR_ScrnMaxRows         // 
        beq !SetNextColRight+        // 
        
        lda TabExLvlDatRowLo+1,y        // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo        // 
        lda TabExLvlOriRowHi+1,y        // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOriginBelowRi:
        sta LRZ_XLvlOriRowHi        // 
        
        ldy LRZ_EnemyMaxColRi           // maximum move right - without walls !!! in the way
        iny                     // try one tile right from
    !GetOriginBelowRi:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        cmp #NoTileWallWeak         // wall below an empty/trap on the actual right
        beq !SetNextColRight+        // check next right
        
        cmp #NoTileWallHard         // wall below an empty/trap on the actual right
        beq !SetNextColRight+        // check next right
        
        cmp #NoTileLadder           // ladder below an empty/trap on the actual right
        bne !SetOneXtraRight+        // empty/pole/trap/gold - inc and exit
        
    !SetNextColRight:
        inc LRZ_EnemyMaxColRi           // maximum move right - without walls !!! in the way
        bpl !GetNextColRight-        // 
        
    !SetOneXtraRight:
        inc LRZ_EnemyMaxColRi           // maximum move right - without walls !!! in the way
        
    !MovEnGetMaxColLRX:
        rts
} 
// ------------------------------------------------------------------------------------------------------------- //
// MovEnGetXYNo      Function:
//               Parms   :
//               Returns : ac=image no  xr=col offset  yr=row offset
// ------------------------------------------------------------------------------------------------------------- //
MovEnGetXYNo:{
        ldx LRZ_EnemyCol            // actual enemy col
        ldy LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
        jsr GetXOff
        
    !SavRowOff:
        stx LRZ_ImageNo             // image number
        
        ldy LRZ_EnemyRow            // actual enemy row
        ldx LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        jsr GetYOff
        
        ldx LRZ_EnemySpriteNo           // actual enemy sprite number
        lda TabSpriteNoEnemy,x          // enemy move images
        
    !GetRowOff:
        ldx LRZ_ImageNo             // image number
        rts
} 
// ------------------------------------------------------------------------------------------------------------- //
//  Function:
//  Parms   :
//  Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnTakeGold:{
        lda LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
        cmp #$02
        bne !MovEnTakeGoldX+
        
        lda LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        cmp #$02
        bne !MovEnTakeGoldX+
        
        ldy LRZ_EnemyRow            // actual enemy row
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi
        
        ldy LRZ_EnemyCol            // actual enemy col
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        cmp #NoTileGold
        bne !MovEnTakeGoldX+          // no gold on level tile
        
        lda LRZ_EnemyInHoleTime         // enemy time in hole count down
        bmi !MovEnTakeGoldX+
        
        lda #$ff
        sec
        sbc LR_EnmyBirthCol         // actual enemy rebirth column (increases with every main loop)
        sta LRZ_EnemyInHoleTime         // enemy time in hole count down
        
        lda #NoTileBlank            // clear gold in
        sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        
        ldy LRZ_EnemyRow            // actual enemy row
        sty LRZ_ScreenRow           // screen row  (00-0f)
        ldy LRZ_EnemyCol            // actual enemy col
        sty LRZ_ScreenCol           // screen col  (00-1b)
        jsr ImageOut2Prep           // direct output to preparation screen
        
        ldy LRZ_ScreenRow           // screen row  (00-0f)
        ldx LRZ_ScreenCol           // screen col  (00-1b)
        jsr GetColRowGfxOff         // offsets in xr=col yr=row
        
        lda #NoTileGold
        jmp ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        
    !MovEnTakeGoldX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnDropGold:{
        lda LRZ_EnemyInHoleTime         // enemy time in hole count down
        bpl !MovEnDropGoldX+          // 
        
        inc LRZ_EnemyInHoleTime         // enemy time in hole count down
        bne !MovEnDropGoldX+          // 
        
        ldy LRZ_EnemyRow            // actual enemy row
        sty LRZ_ScreenRow           // screen row  (00-0f)
        lda TabExLvlDatRowLo,y          // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlOriRowLo
        lda TabExLvlOriRowHi,y          // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi
        
        ldy LRZ_EnemyCol            // actual enemy col
        sty LRZ_ScreenCol           // screen col  (00-1b)
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        cmp #NoTileBlank
        bne !NotEmpty+
        
        lda #NoTileGold
        sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        jsr ImageOut2Prep           // direct output to preparation screen
        
        ldy LRZ_ScreenRow           // screen row  (00-0f)
        ldx LRZ_ScreenCol           // screen col  (00-1b)
        jsr GetColRowGfxOff         // offsets in xr=col yr=row
        
        lda #NoTileGold
        jmp ImageOutXtra            // set images on game screen (sprites/shoots/hidden ladders)
        
    !NotEmpty:
        dec LRZ_EnemyInHoleTime         // enemy time in hole count down
        
    !MovEnDropGoldX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovENSetImg:{
        inc LRZ_EnemySpriteNo           // actual enemy sprite number
    !ChkMin:
        cmp LRZ_EnemySpriteNo           // actual enemy sprite number
        bcc !ChkMax+
        
    !SetSpriteNo:
        sta LRZ_EnemySpriteNo           // actual enemy sprite number
        rts

    !ChkMax:
        cpx LRZ_EnemySpriteNo           // actual enemy sprite number
        bcc !SetSpriteNo-
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//  Function:
//  Parms   :
//  Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnCenterLeRi:{
        lda LRZ_EnemyOnImgPosLR         // actual enemy pos on image left/right
        cmp #$02                        // center
        bcc !IncPos+                    // lower
        beq !Exit+                      // in center
        
    !DecPos:
        dec LRZ_EnemyOnImgPosLR         // back left a bit
        jmp MovEnTakeGold
        
    !IncPos:
        inc LRZ_EnemyOnImgPosLR         // back right a bit
        jmp MovEnTakeGold
        
    !Exit:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
MovEnCenterUpDo:{
        lda LRZ_EnemyOnImgPosUD         // actual enemy pos on image up/down
        cmp #$02                        // center
        bcc !IncPos+                    // lower
        beq !Exit+                      // in center
        
    !DecPos:
        dec LRZ_EnemyOnImgPosUD         // back up a bit
        jmp MovEnTakeGold
        
    !IncPos:
        inc LRZ_EnemyOnImgPosUD         // back down a bit
        jmp MovEnTakeGold
        
    !Exit:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
MovEnSaveStatus:{
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
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetEnemyStatus:{
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
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// CloseHoles        Function: 
//               Parms   : 
//               Returns : 
// ------------------------------------------------------------------------------------------------------------- //
CloseHoles:{                  // 
        jsr EnemyRebirth            // 
        
        inc LR_EnmyBirthCol         // actual enemy rebirth column - increases here with every main loop
        
    !ChkBirthColMax:
        lda LR_EnmyBirthCol         // actual enemy rebirth column (increases with every main loop)
        cmp #LR_ScrnMaxCols+1           // $1b - max 27 cols
        bcc !ChkHoles+               // !hbu025! - lower
        
    !SetBirthColMin:
        lda #$00                // restart
        sta LR_EnmyBirthCol         // actual enemy rebirth column (increases with every main loop)
        
    !ChkHoles:
            ldx #LR_TabHoleMax          // start with the max of 30 open holes
    !GetNextHoleTime:
        lda LR_TabHoleOpenTime,x        // hole open time tab
        stx $52                 // open holes time pointer
        bne !DecHoleTime+            // 
        
        jmp !SetNextHoleTime+        // set next hole time
        
    !DecHoleTime:
        dec LR_TabHoleOpenTime,x        // open holes counter
        beq !HoleOpenTimeOut+        // open time out - so close
        
        lda LR_TabHoleCol,x         // hole column tab
        sta LRZ_ScreenCol           // screen col  (00-1b)
        lda LR_TabHoleRow,x         // hole row tab
        sta LRZ_ScreenRow           // screen row  (00-0f)
        
        lda LR_TabHoleOpenTime,x        // hole open time tab
    !ChkClose1stStep:
        cmp #LR_TabHoleOpenStep1        // first step close
        bne !ChkClose2ndStep+        //  already passed
        
        lda #NoCloseHole00          // close hole 1st step
    !CloseStepOut:
        jsr ImageOut2Prep           // direct output to preparation screen
        
        ldx LRZ_ScreenCol           // screen col  (00-1b)
        ldy LRZ_ScreenRow           // screen row  (00-0f)
        jsr GetColRowGfxOff         // offsets in xr=col yr=row
        
        lda #$00
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        
    !GoSetNextHoleTime:
        jmp !SetNextHoleTime+        // set next hole time
        
    !ChkClose2ndStep:
        cmp #LR_TabHoleOpenStep2        // second step close
        bne !GoSetNextHoleTime-          //  already passed
        
        lda #NoCloseHole01          // close hole 2nd step
        bne !CloseStepOut-           // always
        
    !HoleOpenTimeOut:
        ldx $52                 // open holes time pointer
        ldy LR_TabHoleRow,x         // hole row tab
        sty LRZ_ScreenRow           // screen row  (00-0f)
        jsr SetCtrlDataPtr          // !hbu025! - set both expanded level data pointers
        ldy LR_TabHoleCol,x         // hole column tab
        sty LRZ_ScreenCol           // screen col  (00-1b)
        
    !ChkHoleContent:
        lda (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        cmp #$00
        bne !ChkHoleLR+              // closed hole was not emty
        
    !HoleWasEmpty:
        jmp !CloseWithWall+          // do a simple close
        
    !ChkHoleLR:
        cmp #NoTileLodeRunner
        bne !ChkHoleEnemy+
        
        lsr LR_Alive                // $00=lr killed
        
    !ChkHoleEnemy:
        cmp #NoTileEnemy
        beq !ReviveEnemy+
        
    !ChkHoleGold:
        cmp #NoTileGold
        bne !GoCloseWithWall+
        
        dec LR_Gold2Get
        
    !GoCloseWithWall:
        jmp !CloseWithWall+
        
    !ReviveEnemy:
        lda #NoTileWallWeak
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        sta (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        jsr ImageOut2Disp           // direct output to display screen
        
        lda #NoTileWallWeak
        jsr ImageOut2Prep           // direct output to preparation screen
        
        ldx LR_EnmyNo               // number of enemies
    !ChkEnemyCol:
        lda LR_TabEnemyCol,x        // adr column enemies
        cmp LRZ_ScreenCol           // screen col  (00-1b)
        beq !ChkEnemyRow+
        
        jmp !SetNextEnemy+
        
    !ChkEnemyRow:
        lda LR_TabEnemyRow,x        // adr row enemies
        cmp LRZ_ScreenRow           // screen row  (00-0f)
        bne !SetNextEnemy+
        
    !SpritesOff:
        lda TabEnemyDisab,x         // disable enemy sprite tab
        and SPENA                   // VIC 2 - $D015 = Sprite Enable
        sta SPENA                   // VIC 2 - $D015 = Sprite Enable
        
        lda LR_TabEnemyGold,x           // enemy has gold tab
        bpl !ClearGold+              // 
        
        dec LR_Gold2Get             // enemy still had gold
        
    !ClearGold:
        lda #$7f                // reset
        sta LR_TabEnemyGold,x           // enemy has gold tab entry
        
        stx LR_NoEnemy2Move         // # of enemy to move
        jsr GetEnemyStatus          // 
        jsr MovEnGetXYNo            // ac=image no  xr=col offset  yr=row offset
        jsr ImageOutClear           // clear on game screen (shootings/close holes/remove gold)
        
        ldx LR_NoEnemy2Move         // # of enemy to move
        ldy #$01                // start with row $01 - not with top row $00
        sty LRZ_ScreenRow           // screen row  (00-0f)
        
    !FindRebirthPosI:
        ldy LRZ_ScreenRow           // screen row  (00-0f)
        jsr SetCtrlDataPtr          // !hbu025! - set both expanded level data pointers
        
        ldy LR_EnmyBirthCol         // actual enemy rebirth column (increases with every main loop)
    !FindRebirthPos:
        lda (LRZ_XLvlOriPos),y          // original level data - without lr/en replacements/holes
        cmp #NoTileBlank            // empty
        bne !TryNextPos+             // !hbu025! - not found
        
        lda (LRZ_XLvlModPos),y          // !hbu025! - modified level data - with lr/en replacements/holes
        cmp #NoTileBlank            // !hbu025! - no rebirth if already enemy occupied
        beq !SetRebirthPos+          // !hbu025! - found - both tables position free
        
    !TryNextPos:
        inc LR_EnmyBirthCol         // actual enemy rebirth column (increases with every main loop)
        
    !ChkMaxPos:
        ldy LR_EnmyBirthCol         // actual enemy rebirth column (increases with every main loop)
        cpy #LR_ScrnMaxCols+1           // $1b - max 27 cols
        bcc !FindRebirthPos-
        
    !SetNextRow:
        inc LRZ_ScreenRow           // next screen row  (00-0f)
        
    !GetBirthCol:
        lda #LR_ScrnMinCols         // reset
        sta LR_EnmyBirthCol         // actual enemy rebirth column (increases with every main loop)
        beq !FindRebirthPosI-        // rebirth on the leftmost possible free col after row $01
        
    !SetRebirthPos:
        tya
        sta LR_TabEnemyCol,x        // adr column enemies
        
        lda LRZ_ScreenRow           // screen row  (00-0f)
        sta LR_TabEnemyRow,x        // adr row enemies
        
        lda #LR_TabEnemyRebStart        // start value
        sta LR_TabEnemyRebTime,x        // enemy rebirth step time
        
        lda #$02                // mid
        sta LR_TabEnemyPosUD,x          // enemy pos on image up/down tab
        sta LR_TabEnemyPosLR,x          // enemy pos on image left/right tab
        
        lda #$00                // 
        sta LR_TabEnemySprNo,x          // actual enemy sprite number
        
    !ScoreRebirth:
        lda #<LR_ScoreRebirth           // ac=score  10s
        ldy #>LR_ScoreRebirth           // yr=score 100s
        jsr Score2BaseLine 
        jmp !SetNextHoleTime+        // set next hole time
        
    !SetNextEnemy:
        dex
        beq !CloseWithWall+
        jmp !ChkEnemyCol-
        
    !CloseWithWall:
        lda #NoTileWallWeak
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        jsr ImageOut2Disp           // direct output to display screen
        
        lda #NoTileWallWeak
        jsr ImageOut2Prep           // direct output to preparation screen
        
    !SetNextHoleTime:
        ldx $52                 // open holes time pointer
        dex
        bmi !CloseHolesX+             // all open holes processed
        
        jmp !GetNextHoleTime-
        
    !CloseHolesX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// Function:    EnemyRebirth
// Parms   :
// Returns :
// ------------------------------------------------------------------------------------------------------------- //
EnemyRebirth:{                  // do one rebirth step per mainloop round for each candidate
        ldx LR_EnmyNo               // number of enemies
        beq !EnemyRebirthX+           // 
    
    !GetEnemyNumber:
        lda LR_NoEnemy2Move         // # of enemy to move
        pha                     // save
        
    GetNextStepTime:
        lda LR_TabEnemyRebTime,x        // enemy rebirth step time
        beq SetNextEnemyTime            // not dead
        
    !SetEnemyNumber:
        stx LR_NoEnemy2Move         // # of enemy to move
        jsr GetEnemyStatus          // xr not changed
        
    !ClearGold:
        lda #$7f                // no gold
        sta LR_TabEnemyGold,x           // enemy has gold tab
        
        lda LR_TabEnemyCol,x        // adr column enemies
        sta LRZ_ScreenCol           // screen col  (00-1b)
        lda LR_TabEnemyRow,x        // adr row enemies
        sta LRZ_ScreenRow           // screen row  (00-0f)
        
    !ChkRebirthTime:
        lda LR_TabEnemyRebTime,x        // - enemy rebirth step time
        cmp #LR_TabEnemyRebStart        // - startvalue
        bcc !DecRebirthTime+            // - color only once
        
    !SetRebirthColor:
        jsr SetRebirthColor         // !hbu006! - set rebirth background color to enemy color
        
    !DecRebirthTime:
        dec LR_TabEnemyRebTime,x        // enemy rebirth step time
        beq EnemyReborn             // rebirth completed
        
    !RebirthSteps:
        lda LR_TabEnemyRebTime,x        // enemy rebirth step time
        tax                     // 
        lda TabReviveEnemy,x        // rebirth step images
        pha                     // save
        jsr ImageOut2Prep           // direct output to preparation screen
        jsr MovEnGetXYNo            // ac=image no  xr=col offset  yr=row offset
        
        pla                     // restore rebirth step image
        jsr ImageOutXtra            // set images on game screen (sprites/shoots/hidden ladders)
        
    !GetNextEnemy:
        ldx LR_NoEnemy2Move         // # of enemy to move

    SetNextEnemyTime:
        dex                     // point to next enemies birth step time
        bne GetNextStepTime        // 
        
        pla                     // restore
        sta LR_NoEnemy2Move         // # of enemy to move
        
    !EnemyRebirthX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
EnemyReborn:{
        ldy LRZ_ScreenRow           // screen row  (00-0f)
        jsr SetCtrlDataPtr          // !hbu025! - set both expanded level data pointers
        ldy LRZ_ScreenCol           // screen col  (00-1b)
        lda #NoTileEnemy
        sta (LRZ_XLvlModPos),y          // modified level data - with lr/en replacements/holes
        
        lda (LRZ_XLvlOriPos),y          // modified level data - with lr/en replacements/holes
        beq !RefreshBlank+
        
    !RefreshLadder:
        lda #NoTileLadder           // - became hidden ladder - clear remnants
        jsr ImageOut2Prep           // direct output to preparation screen
        
        lda #NoTileLadder           // - became hidden ladder - clear remnants
        jsr ImageOut2Disp           // - direct output to display screen
        
        jmp !SetEnemy+
        
    !RefreshBlank:
        lda #NoTileBlank            // wipe out the rebirth step remnants
        jsr ImageOut2Prep           // direct output to preparation screen
        
        lda #NoTileBlank            // wipe out the rebirth step remnants
        jsr ImageOut2Disp           // direct output to display screen
        
    !SetEnemy:
        lda #NoTileEnemy
        jsr ImageOut2Disp           // direct output to display screen
        
    !InitEnemyVals:
        lda #$00
        ldx LR_NoEnemy2Move         // # of enemy to move
        sta LR_TabEnemyGold,x           // enemy has gold tab
        sta LR_TabEnemyRebTime,x        // enemy rebirth step time
        
    !SpritesOn:
        ldx LR_NoEnemy2Move         // # of enemy to move
        lda TabEnemyEnab,x          // enable enemy sprite tab
        ora SPENA                   // VIC 2 - $D015 = Sprite Enable
        sta SPENA                   // VIC 2 - $D015 = Sprite Enable
        
    !EnemyRebornX:
        jmp EnemyRebirth.SetNextEnemyTime        // check next enemy
}
// ------------------------------------------------------------------------------------------------------------- //
TabEnemyEnab:
        .byte $00 // !!!!!!!!
        .byte $04 // !!!!!#!!
        .byte $08 // !!!!#!!!
        .byte $10 // !!!#!!!!
        .byte $40 // !#!!!!!!
        .byte $80 // #!!!!!!!
// ------------------------------------------------------------------------------------------------------------- //
TabEnemyDisab:
        .byte $00 // !!!!!!!!
        .byte $fb // #####!##
        .byte $f7 // ####!###
        .byte $ef // ###!####
        .byte $bf // #!######
        .byte $7f // !#######
// ------------------------------------------------------------------------------------------------------------- //
.label TabReviveEnemy  = *
        .byte $00                // step $14 is end mark
        .byte NoReviveEnemy13        // 
        .byte NoReviveEnemy12        // 
        .byte NoReviveEnemy11        // 
        .byte NoReviveEnemy10        // 
        .byte NoReviveEnemy0f        // 
        .byte NoReviveEnemy0e        // 
        .byte NoReviveEnemy0d        // 
        .byte NoReviveEnemy0c        // 
        .byte NoReviveEnemy0b        // 
        .byte NoReviveEnemy0a        // 
        .byte NoReviveEnemy09        // 
        .byte NoReviveEnemy08        // 
        .byte NoReviveEnemy07        // 
        .byte NoReviveEnemy06        // 
        .byte NoReviveEnemy05        // 
        .byte NoReviveEnemy04        // 
        .byte NoReviveEnemy03        // 
        .byte NoReviveEnemy02        // 
        .byte NoReviveEnemy01        // 
// ------------------------------------------------------------------------------------------------------------- //
InitLodSavGame:{
        pha                     // save action key

    !SetScreen:
        lda #>LR_ScrnHiReDisp           //
        sta LRZ_GfxScreenOut        // control gfx screen output - display=$20(00) hidden=$40(00)              
        
        lda LR_LevelNoDisk          //
        sta CR_SaveNoDisk           // save disk level no 000-049
        
    !SetListLevel:
        lda #LR_LevelDiskSave           // 152 - (t=$0c s=$0b) containes the saved game entry list
        sta LR_LevelNoDisk          // 000-149
        
        lda #>LR_SaveList           //
        sta ExecDiskCmdRead.Mod_GetDiskByte         // set read/write buffer pointers
        sta ExecDiskCmdWrite.Mod_PutDiskByte 
        
        lda #LR_DiskRead 
    !GetListLevel:
        jsr ControlDiskOper         // read in save game list
        
        pla                     // restore action key
    !ChkUserKeyLoad:
        cmp #$aa                // "L"
    !GoSave:
        bne SaveGame                // "S"
    
    !GoLoad:
        jmp LoadGame
}
// ------------------------------------------------------------------------------------------------------------- //
ExitLodSavGame:{

        lda #>LR_LvlDataSavLod
    !RstTargetBuffer:
        sta ExecDiskCmdRead.Mod_GetDiskByte         // reset read/write buffer pointers
        sta ExecDiskCmdWrite.Mod_PutDiskByte 
        
    !RstLevel:
        jsr ClearHiresDispH         // restore level
        jsr ColorLevelDyn 
    jmp ColorStatus
} 
// ------------------------------------------------------------------------------------------------------------- //
SaveGame:{
        jsr ShowSaveList            //
        
TitleLine:
        jsr LvlEdCurPosInit         // set cursor to top left screen pos
        jsr TextOut                 // <s writes a game into list>
        .byte $a0 // <blank>
        .byte $d3 // S
        .byte $a0 // <blank>
        .byte $d7 // W
        .byte $d2 // R
        .byte $c9 // I
        .byte $d4 // T
        .byte $c5 // E
        .byte $d3 // S
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $a0 // <blank>
        .byte $c7 // G
        .byte $c1 // A
        .byte $cd // M
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $c9 // I
        .byte $ce // N
        .byte $d4 // T
        .byte $cf // O
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $c9 // I
        .byte $d3 // S
        .byte $d4 // T
        .byte $8d // <newline>
        .byte $a0 // <blank>
        .byte $c4 // D                // <d deletes a game from list>
        .byte $a0 // <blank>
        .byte $c4 // D
        .byte $c5 // E
        .byte $cc // L
        .byte $c5 // E
        .byte $d4 // T
        .byte $c5 // E
        .byte $d3 // S
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $a0 // <blank>
        .byte $c7 // G
        .byte $c1 // A
        .byte $cd // M
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $c6 // F
        .byte $d2 // R
        .byte $cf // O
        .byte $cd // M
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $c9 // I
        .byte $d3 // S
        .byte $d4 // T
        .byte $8d // <newline>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $bc // <
        .byte $d2 // R
        .byte $af // /
        .byte $d3 // S
        .byte $be // >
        .byte $a0 // <blank>
        .byte $c3 // C
        .byte $cf // O
        .byte $ce // N
        .byte $d4 // T
        .byte $c9 // I
        .byte $ce // N
        .byte $d5 // U
        .byte $c5 // E
        .byte $d3 // S
        .byte $a0 // <blank>
        .byte $d4 // T
        .byte $c8 // H
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $c7 // G
        .byte $c1 // A
        .byte $cd // M
        .byte $c5 // E
        .byte $00 // EndOfText
        
        lda #LR_KeyNewNone          //
        sta LR_KeyNew               //
        
    !WaitUser:
        jsr ChkUserAction           //
        bcc !WaitUser-               //
        
        ldx #LR_KeyNewNone          //
        stx LR_KeyNew               // discard key pressed
        
    !Chk_s:
        cmp #$0d                // "s"
        bne !Chk_d+                  //
        
        jmp !SaveNew+
        
    !Chk_d:
        cmp #$12                // "d"
        beq !DeleteOld+              //
        
        cmp #$3f                // <run/stop>
        bne !BadKey+                 //
        
    !Abort:
        jmp !RestoreLevel+ 
    
    !BadKey:
        jsr Beep 
        jmp TitleLine              // start over
        
    !DeleteOld:
        jsr LvlEdCurPosInit         // set cursor to top left screen pos
        jsr TextOut                 // <deletes an entry>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $c4 // D
        .byte $c5 // E
        .byte $cc // L
        .byte $c5 // E
        .byte $d4 // T
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $ce // N
        .byte $a0 // <blank>
        .byte $c5 // E
        .byte $ce // N
        .byte $d4 // T
        .byte $d2 // R
        .byte $d9 // Y
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $8d // <newline>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $ce // N
        .byte $c1 // A
        .byte $cd // M
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $be // >
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $bc // <
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $8d // <newline>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $bc // <
        .byte $d2 // R
        .byte $af // /
        .byte $d3 // S
        .byte $be // >
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $d4 // T
        .byte $cf // O
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $c2 // B
        .byte $cf // O
        .byte $d2 // R
        .byte $d4 // T
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $00 // EndOfText
        
    !SetDelCursor:
        lda #LR_DelColName          //
        sta LRZ_ScreenCol           // screen col ($00 - $1b)
        dec LRZ_ScreenRow           // screen row ($00 - $0f)
        
        sec                     // clear buffer first
        ldy #LR_SavListIdLen        //
    !GetDelName:
        jsr InputControl            // get a name
        bcs !GoTitleLine1+           // <run/stop> abort
        beq !GoTitleLine1+           // no name
        
    !TryDelName:
        jsr DelSaveListLine         // 
        bcs !SaveList+               // name line deleted - write list back
        
        jsr Beep                // name not found
        jsr Beep                // 
    !GoTitleLine1:
        jmp TitleLine              //
        
    !SaveList:
        lda #LR_DiskWrite           //
        jsr ControlDiskOper         // ac: $01=load $02=store
        
    !ShowList:
        jmp SaveGame                // redisplay list
        
    !SaveNew:
        jsr LvlEdCurPosInit         // set cursor to top left screen pos
        jsr TextOut                 // <save game in progress>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $d3 // S
       .byte $c1 // A
       .byte $d6 // V
       .byte $c5 // E
       .byte $a0 // <newline>
       .byte $c7 // G
       .byte $c1 // A
       .byte $cd // M
       .byte $c5 // E
       .byte $a0 // <blank>
       .byte $c9 // I
       .byte $ce // N
       .byte $a0 // <blank>
       .byte $d0 // P
       .byte $d2 // R
       .byte $cf // O
       .byte $c7 // G
       .byte $d2 // R
       .byte $c5 // E
       .byte $d3 // S
       .byte $d3 // S
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $8d // <newline>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $ce // N
       .byte $c1 // A
       .byte $cd // M
       .byte $c5 // E
       .byte $a0 // <blank>
       .byte $be // >
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $bc // <
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $8d // <newline>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $bc // <
       .byte $d2 // R
       .byte $af // /
       .byte $d3 // S
       .byte $be // >
       .byte $a0 // <blank>
       .byte $d4 // T
       .byte $cf // O
       .byte $a0 // <blank>
       .byte $c1 // A
       .byte $c2 // B
       .byte $cf // O
       .byte $d2 // R
       .byte $d4 // T
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $a0 // <blank>
       .byte $00 // EndOfText

    !SetSavCursor:
        lda #LR_SavColName          //
        sta LRZ_ScreenCol           // screen col ($00 - $1b)
        dec LRZ_ScreenRow           // screen row ($00 - $0f)
        
        sec                     // clear buffer first
        ldy #LR_SavListIdLen        //
    GetSavName:
        jsr InputControl            // get a name
        bcs !GoTitleLine2+           // <run/stop> abort
        beq !GoTitleLine2+           // empty name
        
    !TrySavName:
        jsr FindSameEntry           // carry_clear=name not in list  carry_set=name in list
        bcs !FillEntry+              // name found in list - overwrite
        
        jsr FindFreeEntry           // carry_clear=list full  carry_set=free entry found  ac=position
        bcs !FillEntry+              // found
        
        jsr Beep                // save game list full
        jsr Beep          
    !GoTitleLine2:
        jmp TitleLine     
        
    !FillEntry:
        tay               
        ldx #$00          
    !CpyName:
        lda CR_InputBuf,x 
        sta LR_SavList,y  
        iny               
        inx               
        cpx #$08          
        bcc !CpyName-       
        
    !ChkLevelRnd:
        lda LR_RNDMode     
        bpl !CpyLevelGame+ 
        
    !CpyLevelRnd:
        lda LR_RNDLevel 
        jmp !SetLevel+  
        
    !CpyLevelGame:
        lda LR_LevelNoGame          // 001-050
    !SetLevel:
        sta LR_SavList,y
        
    !CpyLevelDisk:
        iny              
        lda CR_SaveNoDisk
        sta LR_SavList,y 
        
    !CpyLives:
        iny              
        lda LR_NumLives  
        sta LR_SavList,y 
        
    !CpyScore:
        iny              
        lda LR_ScoreHi   
        sta LR_SavList,y 
        iny              
        lda LR_ScoreMidHi
        sta LR_SavList,y 
        iny              
        lda LR_ScoreMidLo
        sta LR_SavList,y 
        iny              
        lda LR_ScoreLo   
        sta LR_SavList,y 
    !CpyRnd:
        iny              
        lda LR_RNDMode   
        sta LR_SavList,y 
        
    !WriteSaveLst:
        lda #LR_DiskWrite           //
        jsr ControlDiskOper         // ac: $01=load $02=store
        
    SetRndLevel:
        inc LR_LevelNoDisk          //  - 153 - random mode level block
        
        lda #>LR_RandomField        // 
        sta ExecDiskCmdWrite.Mod_PutDiskByte         // 
        
    !WriteRndLst:
        lda #LR_DiskWrite           // 
        jsr ControlDiskOper         //  - ac: $01=load $02=store
        
    !ResListLevel:
        dec LR_LevelNoDisk          //  - reset: 152 - save games block
        
        lda #>LR_SaveList           //  - reset: save list pointer
        sta ExecDiskCmdWrite.Mod_PutDiskByte         // 
        
        jsr ShowSaveList    
        
        lda #$01            
        jsr WaitAWhile      
        
    !RestoreLevel:
        lda CR_SaveNoDisk   
        sta LR_LevelNoDisk          // restore disk level no 000-049
        
    !SaveGameX:
        jmp ExitLodSavGame          // reset all
}
// ------------------------------------------------------------------------------------------------------------- //
LoadGame:{
        jsr ShowSaveList 
        
TitleLine:
        jsr LvlEdCurPosInit         // set cursor to top left screen pos
        jsr TextOut                 // <load an play a game>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $cf // O
        .byte $c1 // A
        .byte $c4 // D
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $ce // N
        .byte $c4 // D
        .byte $a0 // <blank>
        .byte $d0 // P
        .byte $cc // L
        .byte $c1 // A
        .byte $d9 // Y
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $a0 // <blank>
        .byte $c7 // G
        .byte $c1 // A
        .byte $cd // M
        .byte $c5 // E
        .byte $8d // <newline>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $ce // N
        .byte $c1 // A
        .byte $cd // M
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $be // <
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $bc // >
        .byte $8d // <newline>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $bc // <
        .byte $d2 // R
        .byte $af // /
        .byte $d3 // S
        .byte $be // >
        .byte $a0 // <blank>
        .byte $d4 // T
        .byte $cf // O
        .byte $a0 // <blank>
        .byte $c1 // A
        .byte $c2 // B
        .byte $cf // O
        .byte $d2 // R
        .byte $d4 // T
        .byte $00 // <newline>
        
        dec LRZ_ScreenRow           // screen row ($00 - $0f)
        lda #LR_LodColName          // 
        sta LRZ_ScreenCol           // screen col ($00 - $1b)
        
        sec                     // clear buffer first
        ldy #LR_SavListIdLen        //
        jsr InputControl            //
        bcs !RestoreLevel+           // <run/stp> abort
        beq TitleLine              // no name entered
        
    !TryLoad:
        jsr FindSameEntry           // carry_clear=name not in list  carry_set=name in list
        bcs !SetEntry+               // name found in list
        
        jsr Beep          
        jsr Beep          
    !GoLoadTitle:
        jmp TitleLine     
        
    !RestoreLevel:
        lda CR_SaveNoDisk 
        sta LR_LevelNoDisk          // restore disk level no 000-149
    !GoLoadExit:
        jmp !LoadGameX+               // Exit 
        
    !SetEntry:
        clc                         // name length
        adc #LR_SavListIdLen        // point behind entry name
        
        tay
    !GetLevel:
        lda [LR_SavListLevelG - LR_SavListIdLen],y
        sta LR_LevelNoGame          // 001-150
        sta LR_RNDLevel             // 001-150
        
        lda [LR_SavListLevelD - LR_SavListIdLen],y
        pha                     // save LR_SavListLevelD because of the later list write
        
    GetLives:
        lda [LR_SavListLives  - LR_SavListIdLen],y
        sta LR_NumLives             // 
        
    DecLives:
        sec                     // discount a live whith any load
        sbc #$01                //
        sta [LR_SavListLives  - LR_SavListIdLen],y
        
    GetScore:
        lda [LR_SavListScHi   - LR_SavListIdLen],y
        sta LR_ScoreHi              // 
        lda [LR_SavListScMiHi - LR_SavListIdLen],y
        sta LR_ScoreMidHi           // 
        lda [LR_SavListScMiLo - LR_SavListIdLen],y
        sta LR_ScoreMidLo           // 
        lda [LR_SavListScLo   - LR_SavListIdLen],y
        sta LR_ScoreLo              // 
        
    !GetRnd:
        lda LR_SavListRnd    - LR_SavListIdLen,y
        sta LR_RNDMode              // random number mode
        
    !ChkLives:
        lda LR_NumLives             // 
        cmp #$01                // last life
        bne !ReinitGame+             // no - keep entry
        
    !WriteBack:
        jsr DelSaveListLine         // yes - delete entry from list
        
    !ReinitGame:
        lda #LR_DiskWrite           // save decremented life
        jsr ControlDiskOper         // ac: $01=load $02=store
        
    !SetRndLevel:
        inc LR_LevelNoDisk          //  - 153 - random mode level block
        
        lda #>LR_RandomField        // 
        sta ExecDiskCmdRead.Mod_GetDiskByte         // 
        
    !ReadRndLst:
        lda #LR_DiskRead            //  - read in random level list
        jsr ControlDiskOper         //  - ac: $01=load $02=store
        
    !ResListLevel:
        dec LR_LevelNoDisk          //  - reset: 152 - save games block
        
        lda #>LR_SaveList           //  - reset: save list pointer
        sta ExecDiskCmdRead.Mod_GetDiskByte         // 
        
        jsr ClearHiresDispH         // ClearDisplay20
        jsr ClearHiresDisp.ClearHiresPrep          // ClearDisplay40
        
        pla                     // restore LR_SavListLevelD
        sta LR_LevelNoDisk          // 000-149
        
        tay                
        lda LR_RNDMode     
        cmp #LR_RNDModeOn  
        bne !ForceReload+  
        
        iny                
        sty LR_LevelNoGame          // - 001-150
        
    !ForceReload:
        ldy #$ff
        sty LR_LvlReload            // <> LR_LevelNoDisk - force level reload from disk
        
        iny                     // $00
        sty LR_CntSpeedLaps         //
        sty LR_EnmyBirthCol         // reset birth col pointer
        
        tya                     // $00
        jsr Score2BaseLine          // ac=0 yr=0 - output but no score to add
        jsr Lives2BaseLine          //
        jsr Level2BaseLine          //
        jsr MelodyInit              // InitVictoryTune
        
        lda #LR_CheatedNo           //
        sta LR_Cheated              // reset a possible cheat flag to reallow game saves
        
    !LoadGameX:
        jmp ExitLodSavGame
}
// ------------------------------------------------------------------------------------------------------------- //
ShowSaveList:{

        lda #>LR_ScrnHiReDisp           // 
        sta LRZ_GfxScreenOut            // control gfx screen output - display=$20(00) hidden=$40(00)
        
        jsr CheckSaveList               // check "HBU" id - clear data otherwise
        jsr ClearHiresDispH             // clear all but the base line
        
        lda #HR_YellowCyan  
        tax                 
        ldy #WHITE          
        jsr ColorLevelFix   
        
        lda #$00            
        sta LRZ_ScreenCol               // screen col ($00 - $1b)
        lda #$04
        sta LRZ_ScreenRow               // screen row ($00 - $0f)
        jsr TextOut                     // <name level men scores>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $ce // N
        .byte $c1 // A
        .byte $cd // M
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $c5 // E
        .byte $d6 // V
        .byte $c5 // E
        .byte $cc // L
        .byte $a0 // <blank>
        .byte $cd // M
        .byte $c5 // E
        .byte $ce // N
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $d3 // S
        .byte $c3 // C
        .byte $cf // O
        .byte $d2 // R
        .byte $c5 // E
        .byte $d3 // S
        .byte $8d // <newline>
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $a0 // <blank>
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $a0 // <blank>
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $ad // -
        .byte $8d // <newline>
        .byte $00 // EndOfText
        
        ldy #$00                //
        sty $1c                 // ptr save game data
        
    !SaveNameOutI:
        lda #LR_SavListIdLen        //
        sta $1d                 // name length
        
    !SaveNameOut:
        ldy $1c                 // ptr save game data
        lda LR_SavList,y            //
        jsr ControlOutput           //
        
        inc $1c                 // ptr save game data
        dec $1d                 // name length
        bne !SaveNameOut-            //
        
    !PosLevel:
        inc LRZ_ScreenCol           // screen col ($00 - $1b)
        inc LRZ_ScreenCol           // screen col ($00 - $1b)
        inc LRZ_ScreenCol           // screen col ($00 - $1b)
        ldy $1c                 // get ptr save game data
        inc $1c                 // set ptr save game data
        inc $1c 
        
    !GetLevel:
        lda LR_SavList,y            //
        cmp #$a0                // <blank>
        bne !OutLevel+               //
        
        jmp !SetNextEntry+           // leave out entries with a blank name
        
    !OutLevel:
        jsr SplitHexOut
    
    !PosMen:
        inc LRZ_ScreenCol           // screen col ($00 - $1b)
        inc LRZ_ScreenCol           // screen col ($00 - $1b)
        ldy $1c                 // get ptr save game data
        inc $1c                 // set ptr save game data
        
    !GetMen:
        lda LR_SavList,y      
    !OutMen:
        jsr SplitHexOut       
        
    !PosScore:
        inc LRZ_ScreenCol           // screen col ($00 - $1b)
        ldy $1c                 // get ptr save game data
        inc $1c                 // set ptr save game data
        
    !GetScore:
        lda LR_SavList,y 
        jsr SplitDecOut  
        
        ldy $1c                 // get ptr save game data
        inc $1c                 // set ptr save game data
        lda LR_SavList,y 
        jsr SplitDecOut  
        
        ldy $1c                 // get ptr save game data
        inc $1c                 // set ptr save game data
        lda LR_SavList,y
        jsr SplitDecOut 
        
        ldy $1c                 // get ptr save game data
        inc $1c                 // set ptr save game data
        lda LR_SavList,y 
        jsr SplitDecOut  
        
        ldy $1c                 // - get ptr save game data
    !ChkLevelRnd:
        lda LR_SavList,y   
        cmp #LR_RNDModeOn  
        bne !SetNewRow+    
        
    !MarkLevelRnd:
        lda #LR_SavColRnd
        sta LRZ_ScreenCol
        lda #$be                        // - ">"
        jsr ControlOutput
        
    !SetNewRow:
        lda #$8d                        // <newline>
        jsr ControlOutput
        
    !SetNextEntry:
        lda $1c                         // get ptr save game data
        and #$f0 
        clc      
        adc #$10 
        sta $1c                         // set ptr save game data to next entry
        
    !ChkMax:
        cmp #LR_SavListMaxLen           // maxiumum reached - $09*10
        beq !ShowSaveListX+
    
    !GoNextRow:
        jmp !SaveNameOutI-
    
    !ShowSaveListX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
CheckSaveList:{
        lda LR_SavListId1
        cmp #$c8                    // "H"
        bne ClrSaveList             // wrong id - clear and write back
        
        lda LR_SavListId2
        cmp #$c2                    // "B"
        bne ClrSaveList             // wrong id - clear and write back
        
        lda LR_SavListId3
        cmp #$d5                    // "U"
        bne ClrSaveList             // wrong id - clear and write back
        rts                         // good list
}
// ------------------------------------------------------------------------------------------------------------- //
ClrSaveList:{
        ldx #$00                // <blank> - wrong id - clear and write back
        lda #$a0                //
    !ClrListData:
        sta LR_SavList,x            //
        inx                     //
        bne !ClrListData-            //
        
    !SetID:
        lda #$c8                // "H"
        sta LR_SavListId1            //
        lda #$c2                // "B"
        sta LR_SavListId2           //
        lda #$d5                // "U"
        sta LR_SavListId3           //
        
    !ClrLevelWrite:
        lda #LR_DiskWrite           //
        jsr ControlDiskOper         // ac: $01=load $02=store
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
DelSaveListLine:{
        jsr FindSameEntry           // carry_clear=name not in list  carry_set=name in list
        bcc !DelSaveListLineX+        // entry not found
        
        tay                     // name position
    !MoveUp:
        lda LR_SavList + LR_SavListRowLen,y
        sta LR_SavList,y            // overwrite entry found - move the whole list ome pos up = delete
        iny                     //
        cpy #LR_SavListMaxLen           //
        bcc !MoveUp-                 //
    
        sec                     // entry found and overwritten
    !DelSaveListLineX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
FindSameEntry:{
        ldy #$00                // carry_clear=name not in list  carry_set=name in list ac=position
    !ChkEntryI:
        ldx #$00              
    !ChkEntry:
        lda LR_SavList,y      
        cmp CR_InputBuf,x     
        bne !Differs+         
        
        iny                   
        inx                   
        cpx #LR_SavListIdLen  
        bne !ChkEntry-        
        
    !Same:
        tya                     // save name already existing
        and #$f0                //
        sec                     // save name found and can be replaced
        rts                     //

    !Differs:
        tya                     // actual save name differs from entered name so check next entry
        and #$f0                //
        clc                     //
        adc #LR_SavListRowLen           //
        
        tay                     //
        cmp #LR_SavListMaxLen           //
    !ChkNext:
        bne !ChkEntryI-              //
        
        clc                     // list full - no empty entry and no same save name found
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
FindFreeEntry:{
        ldy #$00                // carry_clear=list full  carry_set=free entry found  ac=position
    !ChkEntryI:
        ldx #LR_SavListIdLen 
        lda #$a0                // <blank>
    !ChkEntry:
        cmp LR_SavList,y
        bne !SetNextEntry+
        
        iny             
        dex             
        bne !ChkEntry-    
        
    !FreeEntry:
        tya             
        and #$f0        
        sec             
        rts             
        
    !SetNextEntry:
        tya             
        and #$f0        
        clc             
        adc #LR_SavListRowLen 
        tay                   
        cmp #LR_SavListMaxLen 
        bne !ChkEntryI-         
        
    !ListFull:
        clc                   
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
SplitDecOut:{
        jsr SplitScoreDigit         // 1308=10 1309=1
        jmp SplitHexOut.Out_10                  //
}

SplitHexOut:{
        jsr ConvertHex2Dec          // 1307=100 1308=10 1309=1
        
    !Out_100:
        lda LR_Digit100             // 
        jsr PrepareDigitOut
        
    Out_10:
        lda LR_Digit10              // 
        jsr PrepareDigitOut         // 
        
    !Out_1:
        lda LR_Digit1               // 
        jmp PrepareDigitOut
}
// ------------------------------------------------------------------------------------------------------------- //
LoadScoreBlock:{
        lda #LR_GameGame            //
        sta LR_GameCtrl             // $00=start $01=demo $02=game $03=play_level $05=edit
        
        lda #LR_DiskRead            //
        jsr GetPutHiScores          // ($1100-$11ff) ac: $01=load $02=store 81= 82=
        
        cmp #$00         
        bne !LoadScoreBad+ 
        
    !LoadScoreGood:
        sec              
        rts              

    !LoadScoreBad:
        clc              
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// SetRebirthColor   Function: Set screen background color to enemy color on rebirth position (for a 2*2 grid)
//               Parms   : ($LRZ_ScreenCol/LRZ_ScreenRow) point to enemy col/row
//               Returns : ($42/$43) point to multi color screen output address
//               ID      : 
// ------------------------------------------------------------------------------------------------------------- //
SetRebirthColor:{
        txa 
        pha 
        
    !GetRebirthRow:
        ldy LRZ_ScreenRow           // set color pointer - enemy row
        lda TabColorScrRowAm,y          // get amount of rows to be colored
        sta $46                 // 
    
    !GetRebirthNo:
        lda TabColorScrRowNo,y          // get color row number for actual row
        sta LR_ColorScrRowNo        // 
        tay                     // 
    
    !SetRebirthPtr:
        lda TabColorScrRowLo,y          // 
        sta $42                 // 
        lda TabColorScrRowHi,y          // 
        sta $43                 // 
        
    !SetRebirthCol:
        ldy LRZ_ScreenCol           // get color offset for actual column
        lda TabColorScrCol,y        // 
        clc                     // 
        adc $42                 // 
        sta $42                 // 
        bcc !SetBirthColorI+         // 
        inc $43                 // ($42/$43) point to multi color screen output address
        
    !SetBirthColorI:
        ldy #$01                // color 2 columns
    !SetBirthColor:
        lda ($42),y                 // get  old color byte
        and #$0f                // kill old color background
        sta ($42),y                 // put  new color byte
        
        lda LR_NoEnemy2Move         // actual enemy number
        tax                     // 
        lda TabSpriteNum,x          // get enemy color position 
        clc                     // 
        adc LR_ColorSetEnemy        // actual color table row address from ColorSprites
        tax                     // 
        lda TabSpColorSets,x        // get this enemies color
        asl                       // shift to left nybble
        asl                    // 
        asl                    // 
        asl                    // 
        ora ($42),y                 // set old  color background to enemy color
        sta ($42),y                 // put  new color byte
        
        dey
        bpl !SetBirthColor-          // treat second position
        
        dec LR_ColorScrRowNo        // color next row above
        ldy LR_ColorScrRowNo
        
    !SetPrevRow:
        dec $46
        bpl !SetRebirthPtr- 
        
        pla
        tax
        
    !SetRebirthColorX:
        rts:
}
// ------------------------------------------------------------------------------------------------------------- //
TabColorScrCol:
                .byte $02                // 00 - multi color screen col offsets
                .byte $03                // 01 
                .byte $05                // 02 
                .byte $06                // 03 
                .byte $07                // 04 
                .byte $08                // 05 
                .byte $0a                // 06 
                .byte $0b                // 07 
                .byte $0c                // 08 
                .byte $0d                // 09 
                .byte $0f                // 0a 
                .byte $10                // 0b 
                .byte $11                // 0c 
                .byte $12                // 0d 
                .byte $14                // 0e 
                .byte $15                // 0f 
                .byte $16                // 10 
                .byte $17                // 11 
                .byte $19                // 12 
                .byte $1a                // 13 
                .byte $1b                // 14 
                .byte $1c                // 15 
                .byte $1e                // 16 
                .byte $1f                // 17 
                .byte $20                // 18 
                .byte $21                // 19 
                .byte $23                // 1a 
                .byte $24                // 1b 
                
TabColorScrRowNo:
                .byte $01                // 00 028 2 - never because scan starts with row $01
                .byte $02                // 01 050 2
                .byte $04                // 02 0a0 3
                .byte $05                // 03 0c8 2
                .byte $06                // 04 0f0 2
                .byte $08                // 05 140 3
                .byte $09                // 06 168 2
                .byte $0a                // 07 190 2
                .byte $0c                // 08 1e0 3
                .byte $0d                // 09 208 2
                .byte $0f                // 0a 258 3
                .byte $10                // 0b 280 2
                .byte $11                // 0c 2a8 2
                .byte $13                // 0d 2f8 3
                .byte $14                // 0e 320 2
                .byte $15                // 0f 348 2 - never because at least one free place in row $14
                
TabColorScrRowLo:
                .byte $00                // 00
                .byte $28                // 01
                .byte $50                // 02
                .byte $78                // 03
                .byte $a0                // 04
                .byte $c8                // 05
                .byte $f0                // 06
                
                .byte $18                // 07
                .byte $40                // 08
                .byte $68                // 09
                .byte $90                // 0a
                .byte $b8                // 0b
                .byte $e0                // 0c
                
                .byte $08                // 0d
                .byte $30                // 0e
                .byte $58                // 0f
                .byte $80                // 10
                .byte $a8                // 11
                .byte $d0                // 12
                .byte $f8                // 13
                
                .byte $20                // 14
                .byte $48                // 15
                
TabColorScrRowHi:
                .byte >LR_ScrnMultColor + $00    // multi color screen row offsets high
                .byte >LR_ScrnMultColor + $00 
                .byte >LR_ScrnMultColor + $00 
                .byte >LR_ScrnMultColor + $00 
                .byte >LR_ScrnMultColor + $00 
                .byte >LR_ScrnMultColor + $00 
                .byte >LR_ScrnMultColor + $00 
                
                .byte >LR_ScrnMultColor + $01 
                .byte >LR_ScrnMultColor + $01 
                .byte >LR_ScrnMultColor + $01 
                .byte >LR_ScrnMultColor + $01 
                .byte >LR_ScrnMultColor + $01 
                .byte >LR_ScrnMultColor + $01 
                
                .byte >LR_ScrnMultColor + $02 
                .byte >LR_ScrnMultColor + $02 
                .byte >LR_ScrnMultColor + $02 
                .byte >LR_ScrnMultColor + $02 
                .byte >LR_ScrnMultColor + $02 
                .byte >LR_ScrnMultColor + $02 
                .byte >LR_ScrnMultColor + $02 
                
                .byte >LR_ScrnMultColor + $03 
                .byte >LR_ScrnMultColor + $03 

TabColorScrRowAm:
                .byte $02                // 00 amount of rows to be colored
                .byte $02                // 01 
                .byte $03                // 02 
                .byte $02                // 03 
                .byte $02                // 04 
                .byte $03                // 05 
                .byte $02                // 06 
                .byte $02                // 07 
                .byte $03                // 08 
                .byte $02                // 09 
                .byte $03                // 0a 
                .byte $02                // 0b 
                .byte $02                // 0c 
                .byte $03                // 0d 
                .byte $02                // 0e 
                .byte $02                // 0f 
// ------------------------------------------------------------------------------------------------------------- //
// BaseLines         Function: Output a separation and a status line
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
BaseLinesColor:{
        jsr ColorLevelDyn           // !hbu001!
        jsr ColorStatus             // !hbu001!
}
    
BaseLines:{
           ldx #$22                     // length of separator line
        
    !SeparatorLine:
        lda LRZ_GfxScreenOut            // target output  $20=$2000 $40=$4000
        cmp #$40                        // hires preparation screen
        beq !HiResPrepare+              // preparation screen
        
    !HiResDisplay:
        lda #$0a                        // grafic byte for
    !HiResDispLeX:
        sta LR_StatsLinLeD01            // left end 0
        sta LR_StatsLinLeD02            // left end 1
        sta LR_StatsLinLeD03            // left end 2
        sta LR_StatsLinLeD04            // left end 3
        lda #$a0                        // grafic byte for
    !HiResDispReX:
        sta LR_StatsLinRiD01            // right end 0
        sta LR_StatsLinRiD02            // right end 1
        sta LR_StatsLinRiD03            // right end 2
        sta LR_StatsLinRiD04            // right end 3
    !HiResDispMid:
        ldy #$03
        lda #$aa                        // grafic byte for

    !HiResDispMidPut:
        sta LR_StatsLinMiD,y            // middle part 0-3
.label _ModDispMidLo  = *-2
.label _ModDispMidHi  = *-1

        dey
        bpl !HiResDispMidPut-           // store next middle part 0-3
        
    !HiResDispNext:
        lda _ModDispMidLo
        clc
        adc #$08
        sta _ModDispMidLo
        bcc !HiResDispDec+
        inc _ModDispMidHi
        
    !HiResDispDec:
        dex
        bne !HiResDispMid-                // dec linie counter
        
        lda #>LR_StatsLinMiD             // restore old values
        sta _ModDispMidHi
        lda #<LR_StatsLinMiD
        sta _ModDispMidLo
        bne !InfoLine+                       // always

    !HiResPrepare:      
        lda #$0a                            // grafic byte for
    !HiResPrepLeX:      
        sta LR_StatsLinLeP01                // left end 0
        sta LR_StatsLinLeP02                // left end 1
        sta LR_StatsLinLeP03                // left end 2
        sta LR_StatsLinLeP04                // left end 3
        lda #$a0                            // grafic byte for
    !HiResPrepRiX:      
        sta LR_StatsLinRiP01                // right end 0
        sta LR_StatsLinRiP02                // right end 1
        sta LR_StatsLinRiP03                // right end 2
        sta LR_StatsLinRiP04                // right end 3
    !HiResPrepMid:      
        ldy #$03        
        lda #$aa                            // grafic byte for middle part 0-3
    !HiResPrepMidPut:
        sta LR_StatsLinMiP,y
.label _ModPrepMidLo  = *-2
.label _ModPrepMidHi  = *-1
        dey
        bpl !HiResPrepMidPut-
        
        lda _ModPrepMidLo
        clc
        adc #$08                            // next position
        sta _ModPrepMidLo
        bcc !HiResPrepDec+
        inc _ModPrepMidHi
        
    !HiResPrepDec:
        dex
        bne !HiResPrepMid-
        
        lda #>LR_StatsLinMiP                // restore old values
        sta _ModPrepMidHi
        lda #<LR_StatsLinMiP
        sta _ModPrepMidLo
        
    !InfoLine:
        jsr LvlEdCurSetHero
        
    !ChkTestMode:
        lda LR_TestLevel
        bmi !BaseLineEdit+
        
    !ChkEditMode:
        lda LR_GameCtrl
        cmp #LR_GameEdit
        bne !BaseLineGame+
}

    !BaseLineEdit:
        jsr TextOut                 // - <level msg>
    StatusEdit:
        .byte $cc // L
        .byte $c5 // E
        .byte $d6 // V
        .byte $c5 // E
        .byte $cc // L
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $cd // M
        .byte $d3 // S
        .byte $c7 // G
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $00 // EndOfText
        
        lda LR_LevelNoGame            // level number
        ldx #LR_BasLinColScr          // now at score position in base row

    !BaseLineEditX:
        jmp Value2BaseLine

    !BaseLineGame:
        jsr TextOut                 // <score>
        .byte $d3 // S
        .byte $c3 // C
        .byte $cf // O
        .byte $d2 // R
        .byte $c5 // E
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $00 // EndOfText
        
    BaseLineMenLvl:
        jsr TextOut                 // - <men level>
    !MsgText:
        .byte $cd // M
        .byte $c5 // E
        .byte $ce // N
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $cc // L
        .byte $c5 // E
        .byte $d6 // V
        .byte $c5 // E
        .byte $cc // L
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $a0 // <blank>
        .byte $00 // EndOfText
        
    !ChkClear:
        lda #HR_BlackBlack          // - clear color
        cmp LR_ScrnMCMsg            // - status line msg part colour
        bne !FillBaseLine+
        
    !Recolor:
        jsr ColorMsg                // - recolor after ClearMsg
        
    !FillBaseLine:
        jsr Lives2BaseLine
        jsr Level2BaseLine
        
        lda #$00                // no score to add
        tay
    !BaseLinesX:
        jmp Score2BaseLine          // display score and return

// ------------------------------------------------------------------------------------------------------------- //
//  Function: Reset victory message on death / lives update
//  Parms   :
//  Returns :
// ------------------------------------------------------------------------------------------------------------- //
RestoreFromMsg:{
        lda LR_ScrnMCMsg - 1        //- status line fix part colour
        cmp LR_ScrnMCMsg            //- status line msg part colour
        bne !ClearBaseMsgI+          // - a message still displayed
        
    !Exit:
        jmp Lives2BaseLine          // - simply update no of lives

    !ClearBaseMsgI:
        sta ColorMsg.Mod_ColorMsg            // - store fix base line color
    !ClearBaseMsg:
        jsr ClearMsg
        
    !InfoLine:
        jsr LvlEdCurSetMsg              //- $0f - max 15 rows -> info seperator is 16
        jmp BaseLineMenLvl
}
// ------------------------------------------------------------------------------------------------------------- //
// Lives2BaseLine    Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
Lives2BaseLine:{
        ldx LR_TestLevel 
        bpl !ShowLives+    
        
    !Exit:
        rts                     // - no lives in level test mode

    !ShowLives:
        lda LR_NumLives
        ldx #LR_BasLinColLve        // output column
}

Value2BaseLine:{
        stx LRZ_ScreenCol           // screen col  (00-1b)
        ldx #LR_BasLinRowStat           // row 16
        stx LRZ_ScreenRow           // screen row  (00-0f)
        jmp SplitHexOut
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
Level2BaseLine:{
        lda LR_RNDMode 
        bpl !GetNormal+
        
    !GetRandom:
        lda LR_RNDLevel   
        jmp !GetColLevel+ 
        
    !GetNormal:
            lda LR_LevelNoGame          // 001-150
    !GetColLevel:
        ldx #LR_BasLinColLvl            // output column
        bne Value2BaseLine              // always
}
// ------------------------------------------------------------------------------------------------------------- //
// Score2BaseLine    Function: Add valuse in ac/yr to score and displays the result in the base info line
// Parms   : ac=10s yr=100s
// Returns :
// ------------------------------------------------------------------------------------------------------------- //
Score2BaseLine:{
        ldx LR_TestLevel 
        bpl ShowScores   
        
    !Exit:
        rts                             //- no scores in level test mode
}

ShowScores:{
        clc
        sed
        adc LR_ScoreLo                  // - ac has 10th
        sta LR_ScoreLo
        tya                             // yr has 100th
        adc LR_ScoreMidLo
        sta LR_ScoreMidLo
        lda #$00                        // add carry
        adc LR_ScoreMidHi
        sta LR_ScoreMidHi
        lda #$00                        // add carry
        adc LR_ScoreHi 
        sta LR_ScoreHi 
        
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
    !Score2BaseLineX:
        jmp SplitDecOut
}
// ------------------------------------------------------------------------------------------------------------- //
// Function:    SplitScoreDigit
// Parms   :
// Returns :
// ------------------------------------------------------------------------------------------------------------- //
SplitScoreDigit:{
        sta LR_Digit10              // store score byte
        and #$0f
        sta LR_Digit1               // isolate right nybble
        
        lda LR_Digit10              // store   right nybble
        lsr                         // isolate left  nybble
        lsr 
        lsr 
        lsr 
        sta LR_Digit10              // store   left  nybble
        
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// Function:    ConvertHex2Dec
// Parms   :
// Returns :
// ------------------------------------------------------------------------------------------------------------- //
ConvertHex2Dec:{
        ldx #$00
        stx LR_Digit10              // digit 10 part
        stx LR_Digit100             // digit 100 part
        
    !Chk100:
        cmp #$64                    // 100
        bcc !Chk10+                  // lower
        inc LR_Digit100             // digit 100 part
        sbc #$64                    // 100
        bne !Chk100-
        
    !Chk10:
        cmp #$0a                    // 10
        bcc !Chk1+                  // lower
        inc LR_Digit10              // digit 10 part
        sbc #$0a                    // 10
        bne !Chk10-
        
    !Chk1:
        sta LR_Digit1               // digit 1 part
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// Dec2Hex       Function:
//               Parms   :
//               Returns : 
// ------------------------------------------------------------------------------------------------------------- //
Dec2Hex:{
        lda #$00                // init result
        ldx LR_Digit100             // digit 100 part
        beq !Chk10+
        
        clc
    !Add100:
        adc #$64                // 100
        bcs !Dec2HexX+
        dex
        bne !Add100-
        
    !Chk10:
        ldx LR_Digit10              // digit 10 part
        beq !Add1+
        
        clc
    !Add10:
        adc #$0a                // 10
        bcs !Dec2HexX+
        dex
        bne !Add10-
        
    !Add1:
        clc
        adc LR_Digit1               // digit 1 part
        
    !Dec2HexX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// GetChrSubst       Function: Get chacacter image number
//               Parms   :
//               Returns : 
// ------------------------------------------------------------------------------------------------------------- //
GetChrSubst:{
        cmp #$c1                // "A"
        bcc !ChkSpecial+             // lower
        
        cmp #$db                // "Z" + 1
        bcc !SubstChr+               // lower
        
    !ChkSpecial:
        ldx #$7b                // $e3 - NoImages - $7b - substitution - $00
        cmp #$a0                // SHIFT BLANK
        beq !SetSpecial+
        
        ldx #$db                // $db - substitution - $61
        cmp #$be                // ">"
        beq !SetSpecial+
        
        inx                     // $dc - substitution - $62
        cmp #$ae                // "!"
        beq !SetSpecial+
        
        inx                     // $dd - substitution - $63
        cmp #$a8                // "("
        beq !SetSpecial+
        
        inx                     // $de - substitution - $64
        cmp #$a9                // ")"
        beq !SetSpecial+
        
        inx                     // $df - substitution - $65
        cmp #$af                // "/"
        beq !SetSpecial+
        
        inx                     // $e0 - substitution - $66
        cmp #$ad                // "-"
        beq !SetSpecial+
        
        inx                     // $e1 - substitution - $67
        cmp #$bc                // "<"
        beq !SetSpecial+
        
        inx                     //  - $e1 - substitution - $67
        cmp #$ba                // ":"
        beq !SetSpecial+
        
    !ChkChrNumbers:
        cmp #NoChrDigitsMin         // !hbu015! - character "0"
        bcc !GetDefault+             // !hbu015! - lower
        
        cmp #NoChrDigitsMax+1           // !hbu015! - character "9" + 1
        bcc !GetChrSubstX+            // !hbu015! - lower - avoid correction
        
    !GetDefault:
        lda #$10                // all others
        rts

    !SetSpecial:
        txa
    !SubstChr:
        sec
        sbc #$7b // $e3 - NoImages       // !hbu008 - map to chr image data numbers
    
    !GetChrSubstX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// PrepareChrOut     Function: Get character image number and output to selected hires screen
//               Parms   : LRZ_GfxScreenOut points to the target hires screen
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
PrepareChrOut:{
        cmp #$8d                    // <newline>
        bne !ChrPrepare+
        
    !ChrNewLine:
        inc LRZ_ScreenRow           // - screen row  (00-0f)
        lda #$00
        sta LRZ_ScreenCol           // - screen col  (00-1b)
        rts

    !ChrPrepare:
        jsr GetChrSubst             // image table substitution
        
    !ChrOut2Screen:
        ldx LRZ_GfxScreenOut        // target output  $20=$2000 $40=$4000
        cpx #>LR_ScrnHiRePrep           // $40
        beq !OutToPrepare+
        
    !OutToDisplay:
        jsr ImageOut2Disp           // direct output to display screen
        inc LRZ_ScreenCol           // screen col  (00-1b)
        rts

    !OutToPrepare:
        jsr ImageOut2Prep           // direct output to preparation screen
        inc LRZ_ScreenCol           // screen col  (00-1b)
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// PrepareDigitOut   Function: 
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
PrepareDigitOut:{
        clc
        adc #NoDigitsMin                // map to digit image data numbers
}   

DigitOut2Screen:{   
        ldx LRZ_GfxScreenOut            // target output  $20=$2000 $40=$4000
        cpx #>LR_ScrnHiRePrep               // $40
        beq !Out2Prepare+   

    !Out2Display:   
        jsr ImageOut2Disp               // direct output to display screen
        inc LRZ_ScreenCol               // screen col  (00-1b)
        rts 

    !Out2Prepare:   
        jsr ImageOut2Prep               // direct output to preparation screen
        inc LRZ_ScreenCol               // screen col  (00-1b)
        rts 
}
// ------------------------------------------------------------------------------------------------------------- //
// TextOut           Function: Output of Text Rows
//                     $00 terminated text must follow directly the call
//                     $00 terminator must be followed directly by a valid opcode
//               Parms   :
//               Returns : 
// ------------------------------------------------------------------------------------------------------------- //
TextOut:{
        pla                             // pull the text start address from the stack
        sta $13
        pla
        sta $14
        bne !SetNext+                   // always
        
    !GetNext:
        ldy #$00
        lda ($13),y                     // get text byte
        beq !PrepXit+                   // zero as text end
        
    !ImageOut:
        jsr ControlOutput
        
    !SetNext:
        inc $13
        bne !GetNext-
        
        inc $14
        bne !GetNext-
        
    !PrepXit:
        lda $14                         // push the text end address to the stack
        pha
        lda $13
        pha
        
    !TextOutX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
Beep:{
        jsr SetTune                 // data must follow directly
        .byte $03                // tune time
        .byte $24                // tune data pointer voice 2
        .byte $00                // tune data pointer voice 3
        .byte $00                // tune s/r/volume  (not used)
        
        .byte $00                // <EndOfTuneData>
        
    rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
WaitKeyBlink:{

        sta LR_DisplayChr               // save byte under cursor
        
    !WaitBlank:
        lda #$00                        // init wait for action timer
        sta LR_WaitTimeLo
        lda #$0a
        sta LR_WaitTimeHi
        
        lda #$00
        ldx LR_DisplayChr               // saved byte under cursor
        bne !Out+
        
    !GetBlankImg:
        lda #NoCursorBlank              // image big reverse cursor
    !Out:
        jsr ImageOut2Disp               // direct output to display screen
        
    !WaitUser1:
        jsr ChkUserAction
        bcs !GotUserKey+
        
        dec LR_WaitTimeLo
        bne !WaitUser1-
        
        dec LR_WaitTimeHi
        bne !WaitUser1-
        
    !GetSaveImg:
        lda LR_DisplayChr               // get byte under cursor
        jsr ImageOut2Disp               // direct output to display screen
        
        lda #$00                        // init wait for action timer
        sta LR_WaitTimeLo
        lda #$0a
        sta LR_WaitTimeHi
        
    !WaitUser2:
        jsr ChkUserAction
        bcs !GotUserKey+
        
        dec LR_WaitTimeLo
        bne !WaitUser2-
        
        dec LR_WaitTimeHi
        bne !WaitUser2-
        
        jmp !WaitBlank-
        
    !GotUserKey:
        pha                             // save key
        lda LR_DisplayChr               // redisplay chr under cursor in case of got in blank blink phase
        jsr ImageOut2Disp               // direct output to display screen
        
        pla                             // restore key
    !WaitKeyBlinkX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// ChkUserAction     Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
ChkUserAction:{

        lda #LR_TypeUIKey               // - default keyboard user interaction
        sta LR_TypeUI
        
        lda LR_KeyNew                   // actual key
        bne !SetUserActionKey+          // user key pressings
        
        lda CIAPRA                      // CIA 1 - $DC00 = Data Port A
        and #$0f                        // isolate - port a:  bit4=fire  bit3=right  bit2=left  bit1=down  bit0=up
        eor #$0f                        // reverse
        bne !SetUserActionJoy+          // - user joystick moves
        
        lda CIAPRA                      // CIA 1 - $DC00 = Data Port A
        and #$10                        // isolate fire
        eor #$10                        // - reverse
        bne !SetUserActionJoy+          // - user joystick fire
        
    !SetNoUserAction:
        clc                             // indicate no user action
        rts

    !SetUserActionJoy:
        dec LR_TypeUI                   // - set jostick user interaction
    !SetUserActionKey:
        sec                             // indicate user action
    !ChkUserActionX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// ImageOut2Disp     Function: Fill hires display screen
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
ImageOut2Disp:{
        sta LRZ_ImageNo                 // image number
        lda #>LR_ScrnHiReDisp           // $20
        bne ImageOut                    // always
}
// ------------------------------------------------------------------------------------------------------------- //
// ImageOut2Disp     Function: Fill hires preparation screen
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
ImageOut2Prep:{

       sta LRZ_ImageNo                   // image number
       lda #>LR_ScrnHiRePrep             // $40
}       
            
ImageOut:{      
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
        
    !GetImage:
        jsr GetImageBytes               // stored from $5b-$7b

    !SetHeight:
        lda #$0b                        // 11 - hight of each image
        sta LRZ_ImageHight              // image hight
        
        ldx #$00
    !ImageOut:
        ldy LRZ_GfxRowOff               // grafic row substitution
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
        bne !ImageOut-
        
ImageOutX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
TabInsImageLe:
        .byte $00 // !!!!!!!!
        .byte $c0 // ##!!!!!!
        .byte $f0 // ####!!!!
        .byte $fc // ######!!
// ------------------------------------------------------------------------------------------------------------- //
TabInsImageRi:
       .byte $3f // !!######
       .byte $0f // !!!!####
       .byte $03 // !!!!!!##
       .byte $00 // !!!!!!!!

// ------------------------------------------------------------------------------------------------------------- //
// ImageOutClear     Function: Clear image on game screen (Shooting/Close Hole Steps/Remove Gold)
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
ImageOutClear:{

        sty LRZ_GfxRowOff           // grafic row substitution
        sta LRZ_ImageNo             // image number
        jsr GetOutGfxPosAdd
        
        sta $21                     // low byte grafic tab addition
        stx LRZ_ImagePosNo          // image position number  (bits 0-1 of LRZ_ScreenCol substitution)
        
    !GetImage:
        jsr GetImageBytes           // stored from $5b-$7b
        
        ldx #$0b
        stx LRZ_ImageHight          // image hight
        ldx #$00
        
    !UpdateOut:
        ldy LRZ_GfxRowOff           // grafic row substitution
        jsr GetMoveGfxPtr
        
        ldy #$00                    // image left part
    !Get1st:
        lda LRZ_ImageDataBuf,x          // image byte
        eor #$ff
        and ($0f),y                 // screen grafic pointer byte
        ora ($11),y                 // hidden grafic pointer byte
    !Put1st:
        sta ($0f),y                 // screen grafic pointer byte
        inx                         // point to next image byte
        ldy #$08                    // image right part
    !Get2nd:
        lda LRZ_ImageDataBuf,x          // image byte
        eor #$ff
        and ($0f),y                 // screen grafic pointer byte
        ora ($11),y                 // hidden grafic pointer byte
    !Put2nd:
        sta ($0f),y                 // screen grafic pointer byte
        
    !Ign3rd:
        inx                     // 3rd imge byte always $00 - ignore
        inx
        inc LRZ_GfxRowOff           // grafic row substitution
        dec LRZ_ImageHight          // image hight
        bne !UpdateOut-
        
ImageOutClearX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// ImageOutXtra      Function: Set images on game screen (Sprites/Shootings/Hidden Ladders)
//               Parms   :
//               Returns : 
// ------------------------------------------------------------------------------------------------------------- //
ImageOutXtra:{

        sty LRZ_GfxRowOff           // grafic row substitution
        sta LRZ_ImageNo             // image number
        jsr SetSpritePos            // xr=VIC Sprite XPOS offset
        jsr GetOutGfxPosAdd
        
        sta $21                     // low byte grafic tab addition
        stx LRZ_ImagePosNo          // image position number  (bits 0-1 of 4f substitution)
    !GetImage:
        jsr GetImageBytes           // stored from $5b-$7b
        
        lda #$0b
        sta LRZ_ImageHight          // image hight
        ldx #$00
        stx $27                     // clear sprite collision  $01=lr caught
        
    !SpriteOut:
        ldy LRZ_GfxRowOff           // grafic row substitution
        jsr GetMoveGfxPtr
        
        ldy #$00                    // first image half
    !Get1st:
        lda LRZ_ImageDataBuf,x          // image byte
        ora ($0f),y                     // screen grafic pointer byte
    !Set1st:
        sta ($0f),y                     // screen grafic pointer byte
        inx                             // image byte pointer
        ldy #$08                        // second image half
        
    !Get2nd:
         lda LRZ_ImageDataBuf,x          // image byte
        ora ($0f),y                 // screen grafic pointer byte
    !Set2nd:
        sta ($0f),y                 // screen grafic pointer byte
        
    !Ign3rd:
        inx                     // 3rd imge byte always $00 - ignore
        inx
        inc LRZ_GfxRowOff           // grafic row substitution
        dec LRZ_ImageHight          // image hight
        bne !SpriteOut-
        
ImageOutXtraX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// GetImageBytes     Function: Contruct an 11*3 Byte Image at Zero Page $5b-$7b
//               Parms   : xr - bit0/bit1 isolated from TabSubstCol of GetColRowGfxOff
//               Returns : 
//               ID      : !hbu008!
// ------------------------------------------------------------------------------------------------------------- //
GetImageBytes:{
        stx LR_ImageColType         // save image column type - 4 differerent positions
        
    !SetImageAdr:
        ldx LRZ_ImageNo             // image number
        lda LR_ImageAdrLo,x  
        sta LRZ_ImageAdrLo   
        lda LR_ImageAdrHi,x  
        sta LRZ_ImageAdrHi   
        
        ldy #DatImageLen-1          // image data lenght machine form
    !GetImageByte1:
        lda (LRZ_ImageAdr),y        // get an image row (3 bytes)
    !PutImageByte1:
        sta LRZ_ImageDataBuf,y  
        dey                     
        
    !GetImageByte2:
        lda (LRZ_ImageAdr),y    
    !PutImageByte2:
        sta LRZ_ImageDataBuf,y  
        dey                     
        
    !GetImageByte3:
        lda (LRZ_ImageAdr),y                        // always zero so far - but neccessary
    !PutImageByte3:
        sta LRZ_ImageDataBuf,y 
        
        tya                                         // care for different addressing mode
        tax 
        
    !ChkImageType:
        lda LR_ImageColType                         // test image column type
        beq !SetImageNext+                            // no   shift for type $00
        cmp #$01
        beq !ShiftImageRow2+                          // 2bit shift for type $01
        cmp #$02
        beq !ShiftImageRow4+                          // 4bit shift for type $02
        
    !ShiftImageRow6:
        lsr LRZ_ImageDataBuf,x                      // 6bit shift for type $03
        inx
        ror LRZ_ImageDataBuf,x
        dex
        lsr LRZ_ImageDataBuf,x
        inx
        ror LRZ_ImageDataBuf,x
        dex
    !ShiftImageRow4:
        lsr LRZ_ImageDataBuf,x
        inx
        ror LRZ_ImageDataBuf,x
        dex
        lsr LRZ_ImageDataBuf,x
        inx
        ror LRZ_ImageDataBuf,x
        dex
    !ShiftImageRow2:
        lsr LRZ_ImageDataBuf,x
        inx
        ror LRZ_ImageDataBuf,x
        dex
        lsr LRZ_ImageDataBuf,x
        inx
        ror LRZ_ImageDataBuf,x
        
    !SetImageNext:
        dey
        bpl !GetImageByte1-                       // next image data row triplet
        
GetImageBytesX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// SetSpritePos      Function: Move Sprite Left/Right
//               Parms   : ac=Spirte ID
//               Returns : xr=VIC Sprite XPOS offset
// ------------------------------------------------------------------------------------------------------------- //
SetSpritePos:{
        lda LR_SprtPosCtrl               // control sprite pos init  $00=init
        bne !SetSpritePosX+     

        lda LRZ_ImageNo                  // image number
    !ChkSpriteMax:      
        cmp #NoSprites+1                 // - first half of images ($00-$39) only
        bcs !SetSpritePosX+              // exit if digit or character

        tay     
        lda TabSpriteGame,y              // image substitution tab
        bmi !SetSpritePosX+              // image not to be substituted
        beq !SavOffset+     

        sta LRZ_ImageNo                  // substitute numbered MC image with game image

    !SavOffset:     
        stx $21                          // grafic xr offset from GetColRowGfxOff
        jsr CopySpriteData               // xr=sprite number * 2

    !SetSpriteXPos:     
        lda $21                          // grafic xr offset from GetColRowGfxOff
        clc     
        adc #$0c                         // 12
        asl                              // *2
        and #$f8                         // clear bits 0-2
        sta SP0X,x                       // VIC 2 - $D000 = Sprite 0 PosX
        bcc !ClrSpriteXPosHi+            // no x pos msb so ClearSpritesXMSB

    !SetSpriteXPosHi:       
        lda TabSetSprtMSB,x              // sprite set x pos msb tab
        ora MSIGX                        // VIC 2 - $D010 = MSBs Sprites 0-7 PosX
        sta MSIGX                        // VIC 2 - $D010 = MSBs Sprites 0-7 PosX
        jmp !SetSpriteYPos+     

    !ClrSpriteXPosHi:       
        lda TabClrSprtMSB,x              // sprite clear x pos msb tab
        and MSIGX                        // VIC 2 - $D010 = MSBs Sprites 0-7 PosX
        sta MSIGX                        // VIC 2 - $D010 = MSBs Sprites 0-7 PosX

    !SetSpriteYPos:
        lda LRZ_GfxRowOff               // grafic row substitution
        clc
        adc #$32                        // 50
        sta SP0Y,x                      // VIC 2 - $D001 = Sprite 0 PosY
        
        lda SPSPCL                      // VIC 2 - $D01E = Sprite/Sprite Collision
        and #$01                        // isolate bit 0
        sta $27                         // sprite collision  1=lr caught
        
        pla                             // discard return address
        pla
        
    !SetSpritePosX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
TabSetSprtMSB:
                .byte $01 // !!!!!!!#  set   - sprite x pos msb tab
TabClrSprtMSB:
                .byte $fe // #######!  clear - sprite x pos msb tab
                
                .byte $02 // !!!!!!#!  set   - sprite x pos msb tab
                .byte $fd // ######!#  clear - sprite x pos msb tab
                
                .byte $04 // !!!!!#!!  set   - sprite x pos msb tab
                .byte $fb // #####!##  clear - sprite x pos msb tab
                
                .byte $08 // !!!!#!!!  set   - sprite x pos msb tab
                .byte $f7 // ####!###  clear - sprite x pos msb tab
                
                .byte $10 // !!!#!!!!  set   - sprite x pos msb tab
                .byte $ef // ###!####  clear - sprite x pos msb tab
                
                .byte $20 // !!#!!!!!  set   - sprite x pos msb tab
                .byte $df // ##!#####  clear - sprite x pos msb tab
                
                .byte $40 // !#!!!!!!  set   - sprite x pos msb tab
                .byte $bf // #!######  clear - sprite x pos msb tab
                
                .byte $80 // #!!!!!!!  set   - sprite x pos msb tab
                .byte $7f // !#######  clear - sprite x pos msb tab
// ------------------------------------------------------------------------------------------------------------- //
// TabSpriteGame     Function: Game sprite substitution table
//                   : All entries correspond to their positions in DatImages
//                   : Sprite $00 entries will be positionally corrected
//                   : Sprite $ff entries will be ignored
//                   : Sprite $nn entries will replace their corresponding position number
//               Parms   : ac=Sprite ID
//               Returns : 
// ------------------------------------------------------------------------------------------------------------- //
TabSpriteGame:
                .byte $ff                // $00 (not_used)
                .byte $ff                // $01 (not_used)
                .byte $ff                // $02 (not_used)
                .byte $ff                // $03 (not_used)
                .byte $ff                // $04 (not_used)
                .byte $ff                // $05 (not_used)
                .byte $ff                // $06 (not_used)
                .byte $ff                // $07 (not_used)
                .byte NoSprite_RuLe00    // $08 - enemy      - replace MC tile in game mode
                .byte $00                // $09 - LodeRunner - if set to NoSprite_RuRi00 - lr is misplaced in many levels - why??
                .byte $ff                // $0a (not_used)
                .byte $00                // $0b --> sprite run    left  01
                .byte $00                // $0c --> sprite run    left  02
                .byte $00                // $0d --> sprite run    left  03
                .byte $00                // $0e --> sprite ladder u/d   01
                .byte $00                // $0f --> sprite fire   left    
                .byte $00                // $10 --> sprite run    right 01
                .byte $00                // $11 --> sprite run    right 02
                .byte $00                // $12 --> sprite run    right 03
                .byte $00                // $13 --> sprite ladder u/d   02
                .byte $00                // $14 --> sprite fall   left    
                .byte $00                // $15 --> sprite fall   right   
                .byte $00                // $16 --> sprite pole   right 01
                .byte $00                // $17 --> sprite pole   right 02
                .byte $00                // $18 --> sprite pole   right 03
                .byte $00                // $19 --> sprite pole   left  01
                .byte $00                // $1a --> sprite pole   left  02
                .byte $00                // $1b --> sprite pole   left  03
                .byte $ff                // $1c (not_used)
                .byte $ff                // $1d (not_used)
                .byte $ff                // $1e (not_used)
                .byte $ff                // $1f (not_used)
                .byte $ff                // $20 (not_used)
                .byte $ff                // $21 (not_used)
                .byte $ff                // $22 (not_used)
                .byte $ff                // $23 (not_used)
                .byte $ff                // $24 (not_used)
                .byte $ff                // $25 (not_used)
                .byte $00                // $26 --> sprite fire   right
                .byte $ff                // $27 (not_used)
                .byte $ff                // $28 (not_used)
                .byte NoSprite_RuRi00        // $29 - 
                .byte NoSprite_RuRi01        // $2a - 
                .byte NoSprite_RuRi02        // $2b - 
                .byte NoSprite_RuLe01        // $2c - 
                .byte NoSprite_RuLe02        // $2d - 
                .byte NoSprite_PoRi00        // $2e - 
                .byte NoSprite_PoRi01        // $2f - 
                .byte NoSprite_PoRi02        // $30 - 
                .byte NoSprite_PoLe00        // $31 - 
                .byte NoSprite_PoLe01        // $32 - 
                .byte NoSprite_PoLe02        // $33 - 
                .byte NoSprite_Ladr00        // $34 - 
                .byte NoSprite_Ladr01        // $35 - 
                .byte NoSprite_FallRi        // $36 - 
                .byte NoSprite_FallLe        // $37 - 
                .byte $ff                // $38 (not_used)
                .byte $ff                // $39 (not_used)
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
CopySpriteData:{
        pha                                 // save image id
        
        lda $21                             // grafic xr offset from GetColRowGfxOff
        and #$03                            // isolate bit 0-1
        tax
        jsr GetImageBytes                   // stored from $5b-$7b
        
        pla                                 // restore image id
        beq !CopyDataI+                       // lode runner
        
        lda LR_NoEnemy2Move                 // # of enemy to move
        
    !CopyDataI:
        tax
        lda TabSprtDatPtrLo,x               // sprite data pos low tab
        sta _ModMovSprtDatL                 // modify store address low
        lda TabSprtDatPtrHi,x               // sprite data pos high tab
        sta _ModMovSprtDatH                 // modify store address high
        
        lda TabSpriteNum,x                  // sprite number tab
        tax
        
        ldy #$20                            // 32
    !CopyData:
        lda LRZ_ImageDataBuf,y              // image has 33 bytes
.label _MoveSprtDat = *
        sta _MoveSprtDat,y                  // store it to correct sprite data storage  ($0c00-$0dff)
.label _ModMovSprtDatL    = *-2
.label _ModMovSprtDatH    = *-1
        dey
        bpl !CopyData-
        txa
        asl                        // *2 - gives VIC sprite XPOS offset
        tax
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
TabSprtDatPtrLo:
                .byte <LR_SpriteData00           // sprite data pos low tab
                .byte <LR_SpriteData01
                .byte <LR_SpriteData02
                .byte <LR_SpriteData03
                .byte <LR_SpriteData04
                .byte <LR_SpriteData05
// ------------------------------------------------------------------------------------------------------------- //
TabSprtDatPtrHi:
                .byte >LR_SpriteData00           // sprite data pos high tab
                .byte >LR_SpriteData01
                .byte >LR_SpriteData02
                .byte >LR_SpriteData03
                .byte >LR_SpriteData04
                .byte >LR_SpriteData05
// ------------------------------------------------------------------------------------------------------------- //
TabSpriteNum:
                .byte $00 // !!!!!!!!         // filler  - LR_NoEnemy2Move counter from 1-5
                .byte $02 // !!!!!!#!         // enemy 1 - color table pos
                .byte $03 // !!!!!!##         // enemy 2 - color table pos
                .byte $04 // !!!!!#!!         // enemy 3 - color table pos
                .byte $06 // !!!!!##!         // enemy 4 - color table pos
                .byte $07 // !!!!!###         // enemy 5 - color table pos
// ------------------------------------------------------------------------------------------------------------- //
// GetColRowGfxOff   Function:
//               Parms   :
//               Returns : offsets in xr=col yr=row
// ------------------------------------------------------------------------------------------------------------- //
GetColRowGfxOff:{

        lda TabSubstRow,y           // substitute row tab
.label Mod__RowGfxL   = *-2
.label Mod__RowGfxH   = *-1
        pha
        lda TabSubstCol,x           // substitute column tab
        tax                     // col
        pla
        tay                     // row
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
TabSubstRowHighS:
                .byte $00 // 00               // new high score grouped row positions
                .byte $0a // 01
                .byte $15 // 02
                .byte $20 // 03
                .byte $2b // 04
                .byte $35 // 05
                .byte $41 // 06
                .byte $4d // 07
                .byte $5c // 08
                .byte $67 // 09
                .byte $72 // 0a
                .byte $81 // 0b
                .byte $8c // 0c
                .byte $97 // 0d
                .byte $a6 // 0e
                .byte $b1 // 0f
                .byte $bc // 10
// ------------------------------------------------------------------------------------------------------------- //
TabSubstRow:
                .byte $00 // 00               // game row positions
                .byte $0b // 01
                .byte $16 // 02
                .byte $21 // 03
                .byte $2c // 04
                .byte $37 // 05
                .byte $42 // 06
                .byte $4d // 07
                .byte $58 // 08
                .byte $63 // 09
                .byte $6e // 0a
                .byte $79 // 0b
                .byte $84 // 0c
                .byte $8f // 0d
                .byte $9a // 0e
                .byte $a5 // 0f
                .byte $b5 // 10
// ------------------------------------------------------------------------------------------------------------- //
TabSubstCol:
                .byte $0a // 01: !!!!#!   #!   - rightmost two bits isolated for GetImageBytes - position type 0-3
                .byte $0f // 02: !!!!##   ##
                .byte $14 // 03: !!!#!#   !!
                .byte $19 // 04: !!!##!   !#
                .byte $1e // 05: !!!###   #!
                .byte $23 // 06: !!#!!!   ##
                .byte $28 // 07: !!#!#!   !!
                .byte $2d // 08: !!#!##   !#
                .byte $32 // 09: !!##!!   #!
                .byte $37 // 0a: !!##!#   ##
                .byte $3c // 0b: !!####   !!
                .byte $41 // 0c: !#!!!!   !#
                .byte $46 // 0d: !#!!!#   #!
                .byte $4b // 0e: !#!!#!   ##
                .byte $50 // 0f: !#!#!!   !!
                .byte $55 // 10: !#!#!#   !#
                .byte $5a // 11: !#!##!   #!
                .byte $5f // 12: !#!###   ##
                .byte $64 // 13: !##!!#   !!
                .byte $69 // 14: !##!#!   !#
                .byte $6e // 15: !##!##   #!
                .byte $73 // 16: !###!!   ##
                .byte $78 // 17: !####!   !!
                .byte $7d // 18: !#####   !#
                .byte $82 // 19: #!!!!!   #!
                .byte $87 // 1a: #!!!!#   ##
                .byte $8c // 1b: #!!!##   !!
                .byte $91 // 1c: #!!#!!   !#
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetXOff:{
        tya
        pha                     // save yr
        jsr GetColRowGfxOff         // offsets in xr=col yr=row
        
        pla
        tay                     // restore yr
        txa
        clc
        adc TabOffsetsX,y           // offset tab
        tax
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
TabOffsetsX:
                .byte $fe // -2
                .byte $ff // -1
                .byte $00 //  0
                .byte $01 // +1
                .byte $02 // +2
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetYOff:{
        txa
        pha                     // save xr
        jsr GetColRowGfxOff         // offsets in xr=col yr=row
        
        pla
        tax                     // restore
        tya
        clc
        adc TabOffsetsY,x
        tay
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
TabOffsetsY:
        .byte $fb // -4
        .byte $fd // -2
        .byte $00 //  0
        .byte $02 // +2
        .byte $04 // +4
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetOutGfxPosAdd:{

        lda #$00
        sta LR_GfxAddHi                     // init high grafic add
        
        txa
        pha                                 // save xr
        and #$03                            // isolate bit 0-1
        tax
        pla                                 // restore xr
        
        asl                                 // *2
        rol LR_GfxAddHi                     // save carry in high grafic add
        and #$f8                            // kill bits 0-2
        sta LR_GfxAddLo                     //   of low grafic add
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
// SetCtrlDataPtr    Function: Set both expanded level data pointers
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
SetCtrlDataPtr:{

        lda TabExLvlDatRowLo,y              // pointer to expanded level data rows: low same for both ori/mod
        sta LRZ_XLvlModRowLo
        sta LRZ_XLvlOriRowLo
        lda TabExLvlModRowHi,y              // pointer to expanded level data rows: modified - with    lr/en replacements/holes
    !PtrModify:
        sta LRZ_XLvlModRowHi
        lda TabExLvlOriRowHi,y              // pointer to expanded level data rows: original - without lr/en replacements/holes
    !PtrOrigin:
        sta LRZ_XLvlOriRowHi
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetOutGfxPtrClr:{
    
        lda #$00
        sta LR_GfxAddLo
        sta LR_GfxAddHi
}

GetOutGfxPtr:{
        lda LR_TabOffHiresLo,y              // offset grafic output low
        clc
        adc LR_GfxAddLo                     // low grafic add
        sta $0f                             // screen grafic low pointer
        lda LR_TabOffHiresHi,y              // offset grafic output high
        adc LR_GfxAddHi                     // high grafic add
        ora LRZ_ImgScreenOut                // graphic output  (20=2000-2fff  40=4000-4fff)
        sta $10                             // screen grafic high pointer
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetMoveGfxPtr:{

        lda LR_TabOffHiresLo,y              // offset grafic output low
        clc
        adc LR_GfxAddLo                     // low grafic add
        sta $0f                             // screen grafic low pointer
        sta $11                             // hidden grafic low pointer
        
        lda LR_TabOffHiresHi,y              // offset grafic output high
        adc LR_GfxAddHi                     // high grafic add
        ora #>LR_ScrnHiReDisp               // $20 - point to $2000-$3fff  (display screen)
        sta $10                             // screen grafic high pointer
        eor #>[LR_ScrnHiReDisp + >LR_ScrnHiRePrep]  // $60 - point to $4000-$5fff  (hidden screen)
        sta $12                             // hidden grafic high pointer
        
GetMoveGfxPtrX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
ClearHiresDisp:{
        lda #>LR_ScrnHiReDisp           // $2000-$3fff - hires display screen
        
        ldx #$00                        // disable all sprites
        stx SPENA                       // VIC 2 - $D015 = Sprite Enable
        
        ldx #>[LR_ScrnHiReDisp + $2000] // $40 - upper border
        bne !ClearScrn+                 // always
        
    ClearHiresPrep:
        lda #>LR_ScrnHiRePrep           // $40=$4000-$5fff  copy of screen  (hidden setup/copy to $2000)
        ldx #>[LR_ScrnHiRePrep + $2000] // $60 - upper border
        
    !ClearScrn:
        sta $10                         // screen grafic high pointer
        ldy #$00
        sty $0f                         // screen grafic low pointer
        tya
        
    !Clear:
        sta ($0f),y                     // screen grafic pointer byte
        iny                             // next byte
        bne !Clear-
        
        inc $10                         // next block
        cpx $10                         // upper border
        bne !Clear-                     // not reached
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
ClearHiresDispH:{
        lda #>LR_ScrnHiReDisp               // $2000-$3fff - hires display screen
        
        ldx #$00                            // disable all sprites
        stx SPENA                           // VIC 2 - $D015 = Sprite Enable
        
        ldx #>(LR_ScrnHiReDisp + $2000)-5   // $3b - upper border - do not clear baselines
        bne !ClearScrnH+                    // always
        
    !ClearHiresPrepH:
        lda #>LR_ScrnHiRePrep               // $40=$4000-$5fff  copy of screen  (hidden setup/copy to $2000)
        ldx #>[LR_ScrnHiRePrep + $2000]-5   // $5b - upper border - do not clear baselines
        
    !ClearScrnH:
        sta $10                             // screen grafic high pointer
        ldy #$00
        sty $0f                             // screen grafic low pointer
        tya
        
    !Clear:
        sta ($0f),y                         // screen grafic pointer byte
        iny                                 // next byte
        bne !Clear-
        
        inc $10                             // next block
        cpx $10                             // upper border
        bne !Clear-                         // not reached
        
        ldy #$80                            // clear the left over bit
    !ClearRest:
        sta ($0f),y                         // screen grafic pointer byte
        dey                                 // next byte
        bpl !ClearRest- 
        
ClearHiresHX:
        rts
        }
// ------------------------------------------------------------------------------------------------------------- //
TabExLvlDatRowLo:
                .byte [LR_ScrnMaxCols + 1] * $00  // $00 - pointer to expanded level data rows - low values same for both types
                .byte [LR_ScrnMaxCols + 1] * $01  // $1c
                .byte [LR_ScrnMaxCols + 1] * $02  // $38
                .byte [LR_ScrnMaxCols + 1] * $03  // $54
                .byte [LR_ScrnMaxCols + 1] * $04  // $70
                .byte [LR_ScrnMaxCols + 1] * $05  // $8c
                .byte [LR_ScrnMaxCols + 1] * $06  // $a8
                .byte [LR_ScrnMaxCols + 1] * $07  // $c4
                .byte [LR_ScrnMaxCols + 1] * $08  // $e0
                
                .byte [LR_ScrnMaxCols + 1] * $00  // $00
                .byte [LR_ScrnMaxCols + 1] * $01  // $1c
                .byte [LR_ScrnMaxCols + 1] * $02  // $38
                .byte [LR_ScrnMaxCols + 1] * $03  // $54
                .byte [LR_ScrnMaxCols + 1] * $04  // $70
                .byte [LR_ScrnMaxCols + 1] * $05  // $8c
                .byte [LR_ScrnMaxCols + 1] * $06  // $a8
// ------------------------------------------------------------------------------------------------------------- //
TabExLvlModRowHi:
                .byte >[LR_LevelTileData + $0000] // $00 - pointer to expanded level data rows: modified - with    lr/en replacements/holes
                .byte >[LR_LevelTileData + $0000] // $1c
                .byte >[LR_LevelTileData + $0000] // $38
                .byte >[LR_LevelTileData + $0000] // $54
                .byte >[LR_LevelTileData + $0000] // $70
                .byte >[LR_LevelTileData + $0000] // $8c
                .byte >[LR_LevelTileData + $0000] // $a8
                .byte >[LR_LevelTileData + $0000] // $c4
                .byte >[LR_LevelTileData + $0000] // $e0

                .byte >[LR_LevelTileData + $0100] // $00
                .byte >[LR_LevelTileData + $0100] // $1c
                .byte >[LR_LevelTileData + $0100] // $38
                .byte >[LR_LevelTileData + $0100] // $54
                .byte >[LR_LevelTileData + $0100] // $70
                .byte >[LR_LevelTileData + $0100] // $8c
                .byte >[LR_LevelTileData + $0100] // $a8
// ------------------------------------------------------------------------------------------------------------- //
TabExLvlOriRowHi:
                .byte >[LR_LevelCtrlData + $0000] // $00 - pointer to expanded level data rows: original - without lr/en replacements/holes
                .byte >[LR_LevelCtrlData + $0000] // $1c
                .byte >[LR_LevelCtrlData + $0000] // $38
                .byte >[LR_LevelCtrlData + $0000] // $54
                .byte >[LR_LevelCtrlData + $0000] // $70
                .byte >[LR_LevelCtrlData + $0000] // $8c
                .byte >[LR_LevelCtrlData + $0000] // $a8
                .byte >[LR_LevelCtrlData + $0000] // $c4
                .byte >[LR_LevelCtrlData + $0000] // $e0

                .byte >[LR_LevelCtrlData + $0100] // $00
                .byte >[LR_LevelCtrlData + $0100] // $1c
                .byte >[LR_LevelCtrlData + $0100] // $38
                .byte >[LR_LevelCtrlData + $0100] // $54
                .byte >[LR_LevelCtrlData + $0100] // $70
                .byte >[LR_LevelCtrlData + $0100] // $8c
                .byte >[LR_LevelCtrlData + $0100] // $a8
// ------------------------------------------------------------------------------------------------------------- //
// ShowExitLadders   Function: Show secret ladders if all gold is collected
//               Parms   :
//               Returns : 
//               Label   : !hbu025! - shortened
// ------------------------------------------------------------------------------------------------------------- //
ShowExitLadders:{
        ldx LR_NumXitLadders                // # hidden ladders to display
        bne !GetRow+ 
        beq !SetGoldUnderflow+              // no secret ladder to show
        
    !GetNextLadderPos:
        ldx LR_NumXitLadders                // # hidden ladders to display
    !GetRow:
        lda LR_TabXitLdrRow,x               // adr row hidden ladders tab
        sta LRZ_ScreenRow                   // screen row  (00-0f)
        tay                                 // row number
        jsr SetCtrlDataPtr                  // - set both expanded level data pointers

    !GetCol:
        lda LR_TabXitLdrCol,x               // adr column hidden ladder tab
        sta LRZ_ScreenCol                   // screen col  (00-1b)
        tay
    !LadderOutCtrl:
        lda #NoTileLadder
        sta (LRZ_XLvlOriPos),y              // original level data - without lr/en replacements/holes
        sta (LRZ_XLvlModPos),y              // modified level data - with lr/en replacements/holes
        jsr ImageOut2Prep                   // direct output to preparation screen
        
        ldx LRZ_ScreenCol                   // screen col  (00-1b)
        ldy LRZ_ScreenRow                   // screen row  (00-0f)
        jsr GetColRowGfxOff                 // offsets in xr=col yr=row
        
        lda #NoTileLadder
        jsr ImageOutXtra                    // set images on game screen (sprites/shoots/hidden ladders)
        
    !DecLadderCount:
        dec LR_NumXitLadders               // # hidden ladders to display
        bne !GetNextLadderPos-             // 
        
    !SetGoldUnderflow:
        dec LR_Gold2Get                    // avoid to be in MaiLoop!Victory more than once
        rts
} 
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
GetAKey:{
        lda LR_KeyNew
        beq GetAKey
        
        ldx #LR_KeyNewNone
        stx LR_KeyNew
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
FlipGmeOverSign:{
        lda #$01
        sta LR_Work                         // init flip sign spin speed
        lda #>LR_ScrnHiReDisp               // $20
        sta LRZ_ImgScreenOut                // graphic output  ($20=$2000-$2fff  $40=$4000-$4fff)
        
FlipSign:
        jsr FlipSignPhase05
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
        
    ChkSpeed:
        lda LR_Work                         // flip sign spin speed
        cmp #LR_FlipSpeedMin                // - speed up
        bcc FlipSign
        
    StopSign:
        jsr FlipSignPhase05
        jsr FlipSignPhase04
        jsr FlipSignPhase03
        jsr FlipSignPhase02
        jsr FlipSignPhase01
        jsr FlipSignPhase00
        
        clc
FlipGmeOverSignX:
        rts
}
// ------------------------------------------------------------------------------------------------------------- //
//               Function:
//               Parms   :
//               Returns :
// ------------------------------------------------------------------------------------------------------------- //
FlipSignPhase00:
                jsr FlipSignOut
                .byte NoSignLine00
                .byte NoSignLine01
                .byte NoSignLine02
                .byte NoSignLine03
                .byte NoSignLine04
                .byte NoSignLine05
                .byte NoSignLine06
                .byte NoSignLine07
                .byte NoSignLine08
                .byte NoSignLine09
                .byte NoSignLine0a
                .byte NoSignLine02
                .byte NoSignLine01
                .byte NoSignLine00
FlipSignPhase01:
                jsr FlipSignOut
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine01
                .byte NoSignLine02
                .byte NoSignLine03
                .byte NoSignLine04
                .byte NoSignLine05
                .byte NoSignLine07
                .byte NoSignLine09
                .byte NoSignLine0a
                .byte NoSignLine02
                .byte NoSignLine01
                .byte NoSignLine00
                .byte NoSignLine00
FlipSignPhase02:
                jsr FlipSignOut
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine01
                .byte NoSignLine02
                .byte NoSignLine03
                .byte NoSignLine04
                .byte NoSignLine09
                .byte NoSignLine0a
                .byte NoSignLine02
                .byte NoSignLine01
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
FlipSignPhase03:
                jsr FlipSignOut
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine01
                .byte NoSignLine02
                .byte NoSignLine03
                .byte NoSignLine0a
                .byte NoSignLine02
                .byte NoSignLine01
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
FlipSignPhase04:
                jsr FlipSignOut
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine01
                .byte NoSignLine03
                .byte NoSignLine0a
                .byte NoSignLine01
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
FlipSignPhase05:
                jsr FlipSignOut
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine01
                .byte NoSignLine01
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
FlipSignPhase06:
                jsr FlipSignOut
                .byte NoSignLine00
                .byte NoSignLine01
                .byte NoSignLine02
                .byte NoSignLine0a
                .byte NoSignLine09
                .byte NoSignLine08
                .byte NoSignLine07
                .byte NoSignLine06
                .byte NoSignLine05
                .byte NoSignLine04
                .byte NoSignLine03
                .byte NoSignLine02
                .byte NoSignLine01
                .byte NoSignLine00
FlipSignPhase07:
                jsr FlipSignOut
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine01
                .byte NoSignLine02
                .byte NoSignLine0a
                .byte NoSignLine09
                .byte NoSignLine07
                .byte NoSignLine05
                .byte NoSignLine04
                .byte NoSignLine03
                .byte NoSignLine02
                .byte NoSignLine01
                .byte NoSignLine00
                .byte NoSignLine00
FlipSignPhase08:
                jsr FlipSignOut
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine01
                .byte NoSignLine02
                .byte NoSignLine0a
                .byte NoSignLine09
                .byte NoSignLine04
                .byte NoSignLine03
                .byte NoSignLine02
                .byte NoSignLine01
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
FlipSignPhase09:
                jsr FlipSignOut
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine01
                .byte NoSignLine02
                .byte NoSignLine0a
                .byte NoSignLine03
                .byte NoSignLine02
                .byte NoSignLine01
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
FlipSignPhase0a:
                jsr FlipSignOut
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine01
                .byte NoSignLine0a
                .byte NoSignLine03
                .byte NoSignLine01
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00
                .byte NoSignLine00

// ------------------------------------------------------------------------------------------------------------- //
//             Function:
//             Parms   :
//             Returns :
// ------------------------------------------------------------------------------------------------------------- //
FlipSignOut:

        pla                     // start adr of data array is the return adr
        sta $0d
        pla
        sta $0e

        ldy #$50
        sty $50                     // screen row  (00-0f)
        bne !SetSignPtr+             // always

    !SetGfxPtr:
        jsr GetOutGfxPtrClr         // ($0f/$10) pointer

        ldy #$00
        lda ($0d),y                 // get sign control byte
        asl                         // *2
        tax
        lda TabSignDataAdr,x        // flip data address tab
        sta _ModGetDataLo           // modify load cmd low
        lda TabSignDataAdr+1,x      // flip data address tab + 1
        sta _ModGetDataHi           // modify load cmd high

        ldy #$70
        sty $20                     // grafic row substitution

        ldy #TabSignDataLen+2       // $0e - sign data lenght
        sty $1e

    !FlipSign:
        ldy $1e
        inc $1e
.label _GetSignData    =  *
        lda _GetSignData,y          // get sign data byte

.label _ModGetDataLo   =  * -2
.label _ModGetDataHi   =  * -1

        lsr                        // *2
        ldy $20                 // grafic row substitution
        sta ($0f),y                 // screen grafic pointer byte
        tya
        clc
        adc #$08                // point to next position
        sta $20                 // grafic row substitution
        
        ldy $1e
        cpy #$1a                // max
        bcc !FlipSign-
        
    !SetSignPtr:
        jsr FlipSignIncPtr
    
        inc $50                 // screen row  (00-0f)
        ldy $50                 // screen row  (00-0f)
        cpy #$5f                // max
        bcc !SetGfxPtr-

        ldx LR_Work                 // flip sign spin speed
        ldy #$ff
    !Wait:
        dey
        bne !Wait-
        dex
        bne !Wait-
    
      inc LR_Work                 // flip sign spin speed so wait longer the next time
      lda CIAPRA                  // CIA 1 - $DC00 = Data Port A
      and #$10                // isolate fire
      beq !FlipSignFinish+          // pressed
    
      lda LR_KeyNew               // actual key
      bne !FlipSignFinish+          // pressed some

FlipSignOutX:
        rts
        
// ------------------------------------------------------------------------------------------------------------- //
    !FlipSignFinish:
        pla                     // pull return address from stack
        pla
        sec
        rts

// ------------------------------------------------------------------------------------------------------------- //

FlipSignIncPtr:
        inc $0d
        bne FlipSignIncPtrX
        inc $0e
        
FlipSignIncPtrX:
    rts

// ------------------------------------------------------------------------------------------------------------- //
// ------------------------------------------------------------------------------------------------------------- //
TabAllEnemyEnab:
                .byte $01 // !!!!!!!#         // enable the selected amount of enemies
                .byte $05 // !!!!!#!#
                .byte $0d // !!!!##!#
                .byte $1d // !!!###!#
                .byte $5d // !#!###!#
                .byte $dd // ##!###!#
// ------------------------------------------------------------------------------------------------------------- //
TabWaitColor:
                .byte WHITE
                .byte LT_GREY
                .byte GREY
                .byte DK_GREY
                .byte BLACK
                .byte DK_GREY
                .byte GREY
                .byte LT_GREY
// ------------------------------------------------------------------------------------------------------------- //
// ------------------------------------------------------------------------------------------------------------- //
TabOffEnmyCycles:
        .byte $00,$03,$06,$09,$0c,$0f,$12,$15,$18,$1b,$1e
// ------------------------------------------------------------------------------------------------------------- //
TabEnmyHoleTime:
        .byte $26,$26,$2e,$44,$47,$49,$4a,$4b
        .byte $4c,$4d,$4e,$4f,$50,$51,$52,$53
        .byte $54,$55,$56,$57,$58

// ------------------------------------------------------------------------------------------------------------- //
TabMsgID:
         .byte $00 //                  // Champ LR message id
         .byte $00 //
         .byte $00 //
         .byte $cc // L
         .byte $cf // O
         .byte $c4 // D
         .byte $c5 // E
         .byte $a0 // <blank>
         .byte $d2 // R
         .byte $d5 // U
         .byte $ce // N
         .byte $ce // N
         .byte $c5 // E
         .byte $52 // r
// ------------------------------------------------------------------------------------------------------------- //
DATA:
*=* "DATA"
#import  "inc\LR_Data.asm"        // Game Chr, Sprites// Levels, !!!
// ------------------------------------------------------------------------------------------------------------- //
 