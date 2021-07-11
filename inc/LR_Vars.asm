// ------------------------------------------------------------------------------------------------------------- //
// (Championship)Lode Runner Game Variables
// ------------------------------------------------------------------------------------------------------------- //
// C64 Machine
// ------------------------------------------------------------------------------------------------------------- //
#import "color.asm"

.label C64_KeyFlag           = $028d                     // 653 - $01=shift $02=commodore $04=ctrl
.label C64_PtrIRQ            = $0314                     // C64 IRQ Vector
.label C64_PtrNMI            = $0318                     // C64 NMI Vector
.label C64_IRQ               = $ea31                     // C64 System IRQ
.label C64_IRQExit           = $ea7e                     // C64 System IRQ exit - clear timer/restore regs/rti
// ------------------------------------------------------------------------------------------------------------- //
// Tables and Screens
// ------------------------------------------------------------------------------------------------------------- //
.label LR_ScrnMultColor      = $0400                     // multi colors - text  screen
.label LR_LevelTileData      = $0800                     // expanded level data - modified with    lr/en replacements/holes
.label LR_LevelCtrlData      = $0a00                     // expanded level data - original without lr/en replacements/holes
.label LR_SpriteStore01      = $0c00                     // sprite data store 1
.label LR_SpriteStore02      = $0d00                     // sprite data store 2
.label LR_TabOffHiresLo      = $0e00                     // ptr hires lo
.label LR_TabOffHiresHi      = $0f00                     // ptr hires hi
.label LR_LvlDataSavLod      = $1000                     // Level Data  Save/Load
.label LR_ScoreSavLod        = $1100                     // high scores save/load area
.label LR_DynValueTab        = $1200                     // game dynamic values
.label LR_InGameVars         = $1300                     // game variables
.label CR_StartGfx           = $13b0                     // start graphic chlr
.label LR_StartGfx           = $1400                     // start graphic
.label LR_ScrnHiReDisp       = $2000                     // display hires screen
.label LR_ScrnHiRePrep       = $4000                     // prepare hires screen for direct output
.label LR_TunePlayTime       = $c000                     // tune times
.label LR_TuneDataPtrV2      = $c100                     // tune data pointer voice 2
.label LR_TuneDataPtrV3      = $c200                     // tune data pointer voice 3
.label LR_TuneSuReVol        = $c300                     // tune s/r/volume  (not used)
.label LR_SaveList           = $c400                     // save games list
.label LR_RandomField        = $c500                     // field with non selected level numbers for random selection
.label LR_HiddenLdrs         = $c600                     // enlarged hidden ladders tab
.label LR_WorkBuffer         = $c800                     // temp store
.label LR_ImageAdrLo         = $c900                     // image address table low  byte
.label LR_ImageAdrHi         = $ca00                     // image address table high byte

.label LR_HiScoreOld         = $c800                     // high score working sets -> .hbu010. - removed
.label LR_HiScoreNew         = $c900                     // high score working sets -> .hbu010. - removed
// ------------------------------------------------------------------------------------------------------------- //
// Lode Runner Level Data Tiles
// ------------------------------------------------------------------------------------------------------------- //
.label LR_TileEmpty          = $00
.label LR_TileWallSoft       = $01
.label LR_TileWallHard       = $02
.label LR_TileLadder         = $03
.label LR_TilePole           = $04
.label LR_TileWallTrap       = $05
.label LR_TileLadderXit      = $06
.label LR_TileGold           = $07
.label LR_TileEnemy          = $08
.label LR_TileLR             = $09

.label LR_TileValid          = LR_TileLR + 1             // valid byte range is $00-$09
// ------------------------------------------------------------------------------------------------------------- //
// Hires Color Positions
// ------------------------------------------------------------------------------------------------------------- //
.label LR_ScrnMCPage0        = LR_ScrnMultColor + $0000  //
.label LR_ScrnMCPage1        = LR_ScrnMultColor + $0100  //
.label LR_ScrnMCPage2        = LR_ScrnMultColor + $0200  //
.label LR_ScrnMCPage3        = LR_ScrnMultColor + $026e  //
.label LR_ScrnMCStatus       = LR_ScrnMultColor + $0370  //
.label LR_ScrnMCTitle        = LR_ScrnMultColor + $0398  // title scores
.label LR_ScrnMCMsg          = LR_ScrnMultColor + $03aa  // message

.label LR_ColRamPage0        = COLORAM + $0000           //
.label LR_ColRamPage1        = COLORAM + $0100           //
.label LR_ColRamPage2        = COLORAM + $0200           //
.label LR_ColRamPage3        = COLORAM + $0300           //
.label LR_ColRamStatus       = COLORAM + $03b0           //
// ------------------------------------------------------------------------------------------------------------- //
// Misc
// ------------------------------------------------------------------------------------------------------------- //
.label LR_ScoreGold          = $0150                     // 2 byte bcd - score for picking up gold
.label LR_ScoreDigIn         = $0020                     // 2 byte bcd - score for gigging in enemies
.label LR_ScoreRebirth       = $0015                     // 2 byte bcd - score for enemy rebirth
.label LR_ScoreFinLevel      = $0750                     // 2 byte bcd - score for successfully finish a level
.label LR_ScoreFinGame       = $7500                     // 2 byte bcd - score for successfully finish the game

.label LR_SoreValStart       = $40                       // for score up tune
.label LR_SoreValSub         = $0e                       // for score up tune
.label CR_SoreValSub         = $13                       // for score up tune ChLR

.label LR_ScrnMinCols        = $00                       // screen position - max left
.label LR_ScrnMaxCols        = $1b                       // screen position - max right
.label LR_ScrnMinRows        = $00                       // screen position - max up
.label LR_ScrnMaxRows        = $0f                       // screen position - max down

.label LR_BEDLvlLenMax       = $02                       // max 3 digits level no input
.label LR_BEDCmdLinMax       = $09                       // max 9 cmd screen rows
.label LR_BEDLvlModYes       = $00                       // edited level data modified
.label LR_BEDLvlModNo        = $01                       // edited level data not modified

.label LR_DiskRead           = $01                       // read  flag
.label LR_DiskWrite          = $02                       // write flag
.label LR_DiskInit           = $04                       // init  flag

.label LR_BasLinRowStat      = $10                       // row offset for status output in base line
.label LR_BasLinColScr       = $05                       // column offset for score output in base line
.label LR_BasLinColMsg       = $0d                       // column offset for victory msg  in base line
.label LR_BasLinColLve       = $10                       // column offset for lives output in base line
.label LR_BasLinColLvl       = $19                       // column offset for level output in base line

.label LR_FlipSpeedMin       = $32                       // .hbu000. - min speed flip sign
.label CR_FlipSpeedMin       = $64                       // min speed flip sign

.label LR_LevelDataMax       = $53                       // pure level data without message and ids
.label CR_LevelDataMax       = $e1                       // pure level data without message and ids
.label CR_SerialNoLen        = $05                       // ChLr serial number length

.label LR_SavColRnd          = $0a                       // column offset for rnd marker
.label LR_SavColName         = $0b                       // column offset for save    entry name

.label LR_LodColName         = $0c                       // column offset for load    entry name
.label LR_DelColName         = $0d                       // column offset for delete  entry name
.label CR_DelSavColName      = $0d                       // column offset for delete  entry name

.label LR_IRQTitleTop        = $ea                       //
.label LR_IRQTitleBot        = $f8                       //

.label LR_ColorTopName       = HR_LtRedLtRed             // special colors
.label LR_ColorTopScore      = HR_YellowCyan
.label LR_ColorVicMsg        = HR_YellowCyan
// ------------------------------------------------------------------------------------------------------------- //
// Enemy Move Directions
// ------------------------------------------------------------------------------------------------------------- //
.label LR_EnemyMoveNone      = $00
.label LR_EnemyMoveLe        = $01
.label LR_EnemyMoveRi        = $02
.label LR_EnemyMoveUp        = $03
.label LR_EnemyMoveDo        = $04
// ------------------------------------------------------------------------------------------------------------- //
// Sprite Pointers
// ------------------------------------------------------------------------------------------------------------- //
.label LR_SpritePtr00        = LR_ScrnMultColor + $03f8  // sprite 0 data at $0c00
.label LR_SpritePtr02        = LR_ScrnMultColor + $03fa  // sprite 2 data at $0c40
.label LR_SpritePtr03        = LR_ScrnMultColor + $03fb  // sprite 3 data at $0c80
.label LR_SpritePtr04        = LR_ScrnMultColor + $03fc  // sprite 4 data at $0cc0
.label LR_SpritePtr06        = LR_ScrnMultColor + $03fe  // sprite 6 data at $0d00
.label LR_SpritePtr07        = LR_ScrnMultColor + $03ff  // sprite 7 data at $0d40
                                                  //
.label LR_SpriteData00       = LR_SpriteStore01 + $0000  // sprite data store 0
.label LR_SpriteData01       = LR_SpriteStore01 + $0040  // sprite data store 1
.label LR_SpriteData02       = LR_SpriteStore01 + $0080  // sprite data store 2
.label LR_SpriteData03       = LR_SpriteStore01 + $00c0  // sprite data store 3
.label LR_SpriteData04       = LR_SpriteStore01 + $0100  // sprite data store 4
.label LR_SpriteData05       = LR_SpriteStore01 + $0140  // sprite data store 5
.label LR_SpriteData06       = LR_SpriteStore01 + $0180  // sprite data store 6 - not used
.label LR_SpriteData07       = LR_SpriteStore01 + $01c0  // sprite data store 7 - not used
// ------------------------------------------------------------------------------------------------------------- //
// Level Success Message
// ------------------------------------------------------------------------------------------------------------- //
.label LR_LevelXtra          = LR_LvlDataSavLod + $e0    // non level data portion            .hbu007.
.label LR_LevelMsg           = LR_LvlDataSavLod + $e2    // victory message text              .hbu007.
.label LR_LevelMsgLen          = $0e                     // max 15 chrs                       .hbu007.
.label LR_LevelMsgLenCo        = $17                     // max 24 color positions            .hbu007.
.label LR_LevelMsgID         = LR_LvlDataSavLod + $f1    // 00 00 00 LODE RUNNEr              .hbu007.
.label LR_LevelMsgIDLen        = $0d                     //                                   .hbu007.
// ------------------------------------------------------------------------------------------------------------- //
// Save game list in LR_LevelDiskSave
// ------------------------------------------------------------------------------------------------------------- //
.label LR_SavList            = LR_SaveList               //
.label LR_SavListIdLen         = $08                     //
.label LR_SavListRowLen        = $10                     //
.label LR_SavListMaxLen        = $a0                     //
.label LR_SavListName        = LR_SavList                //
.label LR_SavListLevelG      = LR_SavList   + $08        // game level no
.label LR_SavListLevelD      = LR_SavList   + $09        // disk level no
.label LR_SavListLives       = LR_SavList   + $0a        //
.label LR_SavListScHi        = LR_SavList   + $0b        //
.label LR_SavListScMiHi      = LR_SavList   + $0c        //
.label LR_SavListScMiLo      = LR_SavList   + $0d        //
.label LR_SavListScLo        = LR_SavList   + $0e        //
.label LR_SavListRnd         = LR_SavList   + $0f        // random mode

.label LR_SavListId          = LR_SavList   + $f0        // if valid must be set to "HBU"
.label LR_SavListId1         = LR_SavListId              // "H"
.label LR_SavListId2         = LR_SavListId + $01        // "B"
.label LR_SavListId3         = LR_SavListId + $02        // "U"

.label CR_SavList            = LR_LvlDataSavLod          //
.label CR_SavListIdLen         = $08                     //
.label CR_SavListRowLen        = $10                     //
.label CR_SavListMaxLen        = $a0                     //
.label CR_SavListName        = CR_SavList                //
.label CR_SavListLevelG      = CR_SavList   + $08        // game level no
.label CR_SavListLevelD      = CR_SavList   + $09        // disk level no
.label CR_SavListLives       = CR_SavList   + $0a        //
.label CR_SavListScHi        = CR_SavList   + $0b        //
.label CR_SavListScMiHi      = CR_SavList   + $0c        //
.label CR_SavListScMiLo      = CR_SavList   + $0d        //
.label CR_SavListScLo        = CR_SavList   + $0e        //
.label CR_SavListRnd         = CR_SavList   + $0f        // random mode

.label CR_SavListId          = CR_SavList   + $f0        // if valid must be set to "DJB"
.label CR_SavListId1         = CR_SavListId              // "D"
.label CR_SavListId2         = CR_SavListId + $01        // "J"
.label CR_SavListId3         = CR_SavListId + $02        // "B"
// ------------------------------------------------------------------------------------------------------------- //
// High Scores Save/Load - $97 152 - (t=$0c s=$07)
// ------------------------------------------------------------------------------------------------------------- //
.label LR_HiScore            = LR_ScoreSavLod            // high score entry
.label LR_HiScoreNamLen        = $07                     // high scorers name length           .hbu010.
.label LR_HiScoreName        = LR_ScoreSavLod + $00      // high scorers name part 1 - chr 1-3 .hbu010.
.label LR_HiScoreNam1        = LR_ScoreSavLod + $00      // high scorers name part 1 - chr 1-3 .hbu010.
.label LR_HiScoreNam2        = LR_ScoreSavLod + $50      // high scorers name part 2 - chr 4-8 .hbu010.
.label LR_HiScoreMen         = LR_ScoreSavLod + $55      // high scorers men left              .hbu010.

.label LR_HiScoreLen           = $7f
.label LR_HiScoreMain        = LR_ScoreSavLod + $00      // Old high score part
.label LR_HiScoreXtra        = LR_ScoreSavLod + $50      // New high score part

.label CR_HiScoreNam         = LR_ScoreSavLod + $00      // 8 chr id name
.label CR_HiScoreNamLen        = $08
.label CR_HiScoreLevel       = LR_ScoreSavLod + $08      // level reached - sort crit 01
.label CR_HiScoreHi          = LR_ScoreSavLod + $09      // score reached - sort crit 02
.label CR_HiScoreMidHi       = LR_ScoreSavLod + $0a
.label CR_HiScoreMidLo       = LR_ScoreSavLod + $0b
.label CR_HiScoreLo          = LR_ScoreSavLod + $0c

.label LR_HiScoreAka         = LR_ScoreSavLod + $00      // 3 chr id name
.label LR_HiScoreAka1        = LR_ScoreSavLod + $00
.label LR_HiScoreAka2        = LR_ScoreSavLod + $01
.label LR_HiScoreAka3        = LR_ScoreSavLod + $02
.label LR_HiScoreLevel       = LR_ScoreSavLod + $03      // level reached - sort crit 01
.label LR_HiScoreHi          = LR_ScoreSavLod + $04      // score reached - sort crit 02
.label LR_HiScoreMidHi       = LR_ScoreSavLod + $05
.label LR_HiScoreMidLo       = LR_ScoreSavLod + $06
.label LR_HiScoreLo          = LR_ScoreSavLod + $07
.label LR_HiScoreLEntry        = $08
.label LR_HiScoreMaxIDs        = $0a                     // max 10 entries
.label LR_HiScoreMovUp       = LR_ScoreSavLod + $08      // move high score data one pos up to prepare insertion
.label CR_BestMsg            = LR_ScoreSavLod + $b0      // best scorers message
.label CR_BestMsgLen           = $13                     // best scorers message length
.label CR_BestLo             = LR_ScoreSavLod + $c4      // best scorers score
.label CR_BestMiLo           = LR_ScoreSavLod + $c5      //
.label CR_BestMiHi           = LR_ScoreSavLod + $c6      //
.label CR_BestHi             = LR_ScoreSavLod + $c7      //
.label CR_BestScrLen           = $04                     // best scorers score length
.label CR_HiScoreCount       = LR_ScoreSavLod + $ee      // counter serial no enters
.label CR_HiScoreUPID        = LR_ScoreSavLod + $ef      // unique play id
.label LR_HiScoreDiskId      = LR_ScoreSavLod + $f0      // DANE BIGHAM
.label LR_HiScoreIdLen         = $0a                     // machine length
.label LR_HiScoreDiskUM      = LR_ScoreSavLod + $fb      // user/master indicator  $00=user disk $01=master disk
.label LR_DiskNoData           = $00                     // no LR data disk
.label LR_DiskMaster           = $01                     // LR master disk
.label LR_DiskData             = $ff                     // LR data disk
// ------------------------------------------------------------------------------------------------------------- //
.label LR_HiScRowOff1St      = $04                       // row    offset first score entry (no of header rows)
.label LR_HiScColOffNam      = $03                       // column offset name     in high score list
.label LR_HiScColOffID       = $07                       // column offset score ID in high scor.label e list

.label LR_HiScIDMaxLen       = $03                       // maximum length of each high score ID
// ------------------------------------------------------------------------------------------------------------- //
// Dynamic Value Tables (exit ladders/enemies/open holes) - One Block
// ------------------------------------------------------------------------------------------------------------- //
.label LR_TabXitLdrLen         = $7f                               // .hbu016. - hidden ladders max entries
.label LR_TabXitLdrNone        = $00                               // .hbu024. - flag: no more ladder to show
.label LR_TabXitLdrShow        = $01                               // .hbu024. - flag: still some ladders to show
.label LR_TabXitLdrCol       = LR_HiddenLdrs                       // .hbu016. - hidden ladders col - count starts with $01 - $00 = flag
.label LR_TabXitLdrRow       = LR_TabXitLdrCol  + LR_TabXitLdrLen  // .hbu016. - hidden ladders row - count starts with $01

.label CR_TabXitLdrLen         = $30                               // hidden ladders max entries
.label CR_TabXitLdrCol       = LR_DynValueTab                      // $1200 - hidden ladders col
.label CR_TabXitLdrRow       = CR_TabXitLdrCol  + CR_TabXitLdrLen  // $1230 - hidden ladders row

.label LR_TabEnemyLen          = $08                               // enemies
.label LR_TabEnemyCol        = CR_TabXitLdrRow  + CR_TabXitLdrLen  // $1260 - actual col enemy positions
.label LR_TabEnemyRow        = LR_TabEnemyCol   + LR_TabEnemyLen   // $1268 - actual row enemy positions
.label LR_TabEnemyGold       = LR_TabEnemyRow   + LR_TabEnemyLen   // $1270 - indicator enemy carries gold
.label LR_TabEnemyPosLR      = LR_TabEnemyGold  + LR_TabEnemyLen   // $1278 - actual enemy position on image left/right
.label LR_TabEnemyPosUD      = LR_TabEnemyPosLR + LR_TabEnemyLen   // $1280 - actual enemy position on image up/down
.label LR_TabEnemySprNo      = LR_TabEnemyPosUD + LR_TabEnemyLen   // $1288 - actual enemy sprite number
.label LR_TabEnemySpr__      = LR_TabEnemySprNo + LR_TabEnemyLen   // $1290 ???
.label LR_TabEnemyRebTime    = LR_TabEnemySpr__ + LR_TabEnemyLen   // $1298 - actual enemy rebirth step time
.label LR_TabEnemyRebLen       = $05                               //         0 - 5 = max 6 entries
.label LR_TabEnemyRebStart     = $14                               //         1st mark to rebirth the enemy a bit
.label LR_TabEnemyRebStep1     = $13                               //         1st mark to rebirth the enemy a bit
.label LR_TabEnemyRebStep2     = $0a                               //         2nd mark to rebirth the enemy a bit

.label LR_TabHoleMax           = $1e                               // max entries
.label LR_TabHoleLen           = $20                               //     open holes max entries
.label LR_TabHoleCol         = LR_TabEnemyRebTime + LR_TabEnemyLen // col open holes
.label LR_TabHoleRow         = LR_TabHoleCol      + LR_TabHoleLen  // row open holes
.label LR_TabHoleOpenTime    = LR_TabHoleRow      + LR_TabHoleLen  // actual hole open time
.label LR_TabHoleOpenStart     = $b4                               // initial value
.label LR_TabHoleOpenStep1     = $14                               // 1st mark to close the hole a bit
.label LR_TabHoleOpenStep2     = $0a                               // 2nd mark to close the hole a bit
// ------------------------------------------------------------------------------------------------------------- //
// In Game Vaiables
// ------------------------------------------------------------------------------------------------------------- //
.label LR_LevelCtrl          = LR_InGameVars + $00       // level display control  $00=prepared copy already at $4000-$5fff
.label LR_LevelPrep            = $00
.label LR_LevelLoad            = $01                     // force level reload/reinit
.label LR_NumXitLadders      = LR_InGameVars + $01       //
.label LR_NumXitLdrsMax        = LR_TabXitLdrLen         // .hbu016. - 128
.label CR_NumXitLdrsMax        = CR_TabXitLdrLen - $03   // 45 - $2d
.label LR_FallBeep           = LR_InGameVars + $02       //
.label LR_FallBeepIni          = $53
.label LR_ColorSetEnemy      = LR_InGameVars + $03       // actual colorset no for enemy rebirth coloring
.label CR_NoFunction         = LR_InGameVars + $04
.label LR_ColorScrRowNo      = LR_InGameVars + $04       // row number in LR_ScrnMultColor
.label LR_CtrlCircle         = LR_InGameVars + $04       // not used anymore
.label LR_CircleOn             = $ff
.label LR_CircleOff            = $00
.label LR_LevelNoGame        = LR_InGameVars + $05       // 001-250
.label LR_LevelNoMin           = $01                     // do not use $00 - see LR_LevelDiskMin
.label CR_LevelNoMax           = $33                     // championship 051
.label LR_LevelNoMax           = $96                     // do not use a value greater 250 ($fa) - see LR_LevelDiskMax
.label CR_LevelNoMaxDmo        = $03                     // maximum no of demo levels .hbu005.
.label LR_LevelNoMaxDmo        = $04                     // maximum no of demo levels .hbu005.
.label LR_GameCtrl           = LR_InGameVars + $06       // $00=start $01=demo $02=game $03=play_level $05=edit
.label LR_GameStart            = $00
.label LR_GameDemo             = $01
.label LR_GameGame             = $02
.label LR_GamePlay             = $03
.label LR_GameEdit             = $05
.label LR_Digit100           = LR_InGameVars + $07       //
.label LR_Digit10            = LR_InGameVars + $08       //
.label LR_Digit1             = LR_InGameVars + $09       //
.label LR_ScoreLo            = LR_InGameVars + $0a       //
.label LR_ScoreMidLo         = LR_InGameVars + $0b       //
.label LR_ScoreMidHi         = LR_InGameVars + $0c       //
.label LR_ScoreHi            = LR_InGameVars + $0d       //
.label LR_Gold2Get           = LR_InGameVars + $0e       //
.label LR_ControllerTyp      = LR_InGameVars + $0f       //
.label LR_Joystick             = $ca
.label LR_Keyboard             = $cb
.label LR_LevelNoDisk        = LR_InGameVars + $10       //
.label LR_LevelDiskMin         = LR_LevelNoMin - $01     // 000
.label LR_LevelDiskMax         = LR_LevelNoMax - $01     // 149
.label LR_LevelDiskScor        = LR_LevelNoMax + $01     // 151 - highscores disk level - disk level 150 must be blank for restart
.label LR_LevelDiskSave        = LR_LevelNoMax + $02     // 152 - save games block
.label LR_LevelDiskRnd         = LR_LevelNoMax + $03     // 153 - random mode level block
.label CR_LevelDiskSave        = LR_LevelNoMax + $05     // 155 - save games block
.label LR_CntSpeedLaps       = LR_InGameVars + $11       //
.label LR_CntSpeedMax          = $09
.label LR_NumLives           = LR_InGameVars + $12       //
.label LR_NumLivesInit         = $05
.label LR_Volume             = LR_InGameVars + $13       //
.label LR_VolumeMax            = $ff
.label LR_Alive              = LR_InGameVars + $14       //
.label LR_Death                = $00
.label LR_Life                 = $01
.label LR_FallsDown          = LR_InGameVars + $15       // $00=fall $20=no fall $ff=init
.label LR_Falls                = $00
.label LR_FallsNo              = $20
.label LR_Shoots             = LR_InGameVars + $16       // $00=no $01=right $ff=left
.label LR_ShootsNo             = $00
.label LR_ShootsRi             = $01
.label LR_ShootsLe             = $ff
.label LR_ShootSound         = LR_InGameVars + $17       //
.label LR_ShootSoundIni        = $00
.label LR_ShootSoundSub        = $20
.label LR_Cheated            = LR_InGameVars + $18       // $01=no
.label LR_CheatedYes           = $00
.label LR_CheatedNo            = $01
.label LR_JoyUpDo            = LR_InGameVars + $19       // Joystick direction up/down
.label LR_JoyMoveNone          = $00
.label LR_JoyMoveUp            = $21
.label LR_JoyMoveDo            = $25
.label LR_JoyLeRi            = LR_InGameVars + $1a       // Joystick direction left/right
.label LR_JoyMoveLe            = $22
.label LR_JoyMoveRi            = $2a
.label LR_JoyFireLe            = $1e
.label LR_JoyFireRi            = $26
.label LR_GameSpeed          = LR_InGameVars + $1b       //
.label LR_SpeedMin             = $03
.label LR_SpeedNormal          = $05
.label LR_SpeedMax             = $08
.label LR_EnmyNo             = LR_InGameVars + $1c       //
.label LR_EnmyNoMax            = $05
.label LR_GetGold            = LR_InGameVars + $1d       // get gold  0=just gets it
.label LR_GetGoldGet           = $00
.label LR_GetGoldGot           = $01
.label LR_EnmyBirthCol       = LR_InGameVars + $1e       //
.label LR_EnmyBColMax          = $1c
.label LR_NoEnemy2Move       = LR_InGameVars + $1f       //
.label LR_NoEnemy2MvMin        = $01
.label LR_EnmyHoleTime       = LR_InGameVars + $20       // init values dynamically taken from in game:TabEnmyHoleTime
.label LR_EnmyHoleTiIni        = $00
.label LR_EnmyShivStart        = $0d                     // enemy in hole time - start to shiver if lower
.label LR_EnmyShivStop         = $07                     // enemy in hole time - stop  to shiver if lower
.label LR_StartCycle         = LR_InGameVars + $21       // $00=off $ff=on
.label LR_WaitTimeLo         = LR_InGameVars + $22       //
.label LR_WaitTimeHi         = LR_InGameVars + $23       //

.label CR_WaitTimeLo         = LR_InGameVars + $21       // moved one up in chlr - LR_StartCycle not needed anymore
.label CR_WaitTimeHi         = LR_InGameVars + $22       // moved one up in chlr - LR_StartCycle not needed anymore
.label CR_WaitImageNo        = LR_InGameVars + $23       // image number to blink - new in chlr

.label LR_DisplayChr         = LR_InGameVars + $24       //
.label LR_GfxAddLo           = LR_InGameVars + $25       //
.label LR_GfxAddHi           = LR_InGameVars + $26       //

.label CR_GfxAddLo           = LR_InGameVars + $24       // moved one up in chlr - LR_DisplayChr not needed anymore
.label CR_GfxAddHi           = LR_InGameVars + $25       // moved one up in chlr - LR_DisplayChr not needed anymore
.label CR_Work               = LR_InGameVars + $26       // new in chlr

.label LR_Counter            = LR_InGameVars + $27       //
.label LR_KeyNew             = LR_InGameVars + $28       //
.label LR_KeyNewNone           = $00
.label LR_KeyOld             = LR_InGameVars + $29       //
.label LR_DeathTune          = LR_InGameVars + $2a       //
.label LR_DeathTuneSub         = $04
.label LR_DeathTuneVal         = $38
.label LR_Work               = LR_InGameVars + $2b       //
.label LR_SprtPosCtrl        = LR_InGameVars + $2c       //
.label LR_CountIRQs          = LR_InGameVars + $2d       //
.label LR_IRQsDflt             = $03
.label LR_PtrTuneToPlay      = LR_InGameVars + $2e       //
.label LR_PtrNxtTunePos      = LR_InGameVars + $2f       // in buffers
.label LR_Mirror             = LR_InGameVars + $30       // $01=no
.label LR_MirrorNo             = $00
.label LR_MirrorYes            = $01
.label LR_RandomAc           = LR_InGameVars + $31
.label LR_MelodyNo           = LR_InGameVars + $32
.label LR_MelodyHeight       = LR_InGameVars + $33
.label LR_ScoreShown         = LR_InGameVars + $34       // avoid score redisplay in score
.label LR_Random             = LR_InGameVars + $35       //
.label LR_RasterBeamPos      = LR_InGameVars + $36       //
.label LR_WaveVoice2         = LR_InGameVars + $37       //
.label LR_WaveVoice3         = LR_InGameVars + $38       //
.label LR_ShootMode          = LR_InGameVars + $39       //
.label LR_DiskAction         = LR_InGameVars + $3a       // store read/write/init
.label LR_LvlReload          = LR_InGameVars + $3b       // level will be reloaded <> LR_LevelNoDisk

.label CR_InputBufPtr        = LR_InGameVars + $3c       //
.label CR_InputBuf           = LR_InGameVars + $3d       // for del/sav entries
.label CR_InputBufLen          = $13                     // length - max=$50
.label CR_SerialNo           = LR_InGameVars + $3d       // serial number
.label CR_SerialNoPos1       = LR_InGameVars + $3d       // serial no 01
.label CR_SerialNoPos2       = LR_InGameVars + $3e       // serial no 02
.label CR_SerialNoPos3       = LR_InGameVars + $3f       // serial no 03
.label CR_SerialNoPos4       = LR_InGameVars + $40       // serial no 04
.label CR_SerialNoPos5       = LR_InGameVars + $41       // serial no 05

.label CR_SaveNoDisk         = LR_InGameVars + $51       // save LR_LevelNoDisk
.label CR_DiskStatus         = LR_InGameVars + $52       //
.label CR_NoUse              = LR_InGameVars + $53       // not used but initialzed
.label CR_InputBufMax        = LR_InGameVars + $54       //
.label CR_UniquePID          = LR_InGameVars + $55       // unique playid
.label CR_StatusColor        = LR_InGameVars + $56       // lrNewLevelColor
.label CR_LevelColor         = LR_InGameVars + $57       // lrNewStatusColor
.label CR_ScoreOffset        = LR_InGameVars + $58       //
.label CR_InputControl       = LR_InGameVars + $59       //
.label CR_Cheat              = LR_InGameVars + $5a       // allow extra lives

.label LR_ExpertMode         = LR_InGameVars + $5a       // expert mode
.label LR_ExpertModeOff        = $00
.label LR_ExpertModeOn         = $ff
.label LR_LevelNoXmit        = LR_InGameVars + $5b       // number target level drive 9 for xmit

.label LR_RND                = LR_InGameVars + $5c       // random number
.label LR_RNDMax             = LR_InGameVars + $5d       // upper bound
.label LR_RNDLevel           = LR_InGameVars + $5e       // level counter
.label LR_RNDMode            = LR_InGameVars + $5f       // flag random level mode
.label LR_RNDModeOff           = $00
.label LR_RNDModeOn            = $ff

.label LR_ScoreOldLo         = LR_InGameVars + $60       // .hbu019.
.label LR_ScoreOldMidLo      = LR_InGameVars + $61       //
.label LR_ScoreOldMidHi      = LR_InGameVars + $62       //
.label LR_ScoreOldHi         = LR_InGameVars + $63       //

.label LR_DiscCmdDriveNo     = LR_InGameVars + $64       //
.label LR_DiscCmdLevel       = LR_InGameVars + $65       //

.label LR_WrkCurrentPos      = LR_InGameVars + $66       //
.label LR_WrkScreenCol       = LR_InGameVars + $67       //
.label LR_MoveLvlNoFrom      = LR_InGameVars + $68       //
.label LR_MoveLvlNoTo        = LR_InGameVars + $69       //

.label LR_TestLevel          = LR_InGameVars + $6a       // .hbu023. - level test mode
.label LR_TestLevelOff         = $00
.label LR_TestLevelOn          = $ff
.label LR_SavePosRow         = LR_InGameVars + $6b       // save actual screen pos
.label LR_SavePosCol         = LR_InGameVars + $6c       //
.label LR_JoyNew             = LR_InGameVars + $6d       //
.label LR_JoyOld             = LR_InGameVars + $6e       //
.label LR_JoyWait            = LR_InGameVars + $6e       //
.label LR_TypeUI             = LR_InGameVars + $70       // flag: type of user interaction
.label LR_TypeUIKey            = $00                     //
.label LR_TypeUIJoy            = $ff                     //
.label LR_ImageColType       = LR_InGameVars + $71       // image col type no $00-$03

.label CR_CheckSum           = LR_InGameVars + $af       // protect copy protection
// ------------------------------------------------------------------------------------------------------------- //
// Status Line in Hires Display Screen
// ------------------------------------------------------------------------------------------------------------- //
.label LR_StatsLinLeD01      = LR_ScrnHiReDisp  + $1b90

.label LR_StatsLinLeD02      = LR_StatsLinLeD01 + $0001
.label LR_StatsLinLeD03      = LR_StatsLinLeD01 + $0002
.label LR_StatsLinLeD04      = LR_StatsLinLeD01 + $0003
.label LR_StatsLinMiD        = LR_StatsLinLeD01 + $0008
.label LR_StatsLinRiD01      = LR_StatsLinLeD01 + $0118
.label LR_StatsLinRiD02      = LR_StatsLinLeD01 + $0119
.label LR_StatsLinRiD03      = LR_StatsLinLeD01 + $011a
.label LR_StatsLinRiD04      = LR_StatsLinLeD01 + $011b
// ------------------------------------------------------------------------------------------------------------- //
// Status Line in Hires Preparation Screen
// ------------------------------------------------------------------------------------------------------------- //
.label LR_StatsLinLeP01      = LR_ScrnHiRePrep  + $1b90
.label LR_StatsLinLeP02      = LR_StatsLinLeP01 + $0001
.label LR_StatsLinLeP03      = LR_StatsLinLeP01 + $0002
.label LR_StatsLinLeP04      = LR_StatsLinLeP01 + $0003
.label LR_StatsLinMiP        = LR_StatsLinLeP01 + $0008
.label LR_StatsLinRiP01      = LR_StatsLinLeP01 + $0118
.label LR_StatsLinRiP02      = LR_StatsLinLeP01 + $0119
.label LR_StatsLinRiP03      = LR_StatsLinLeP01 + $011a
.label LR_StatsLinRiP04      = LR_StatsLinLeP01 + $011b
// ------------------------------------------------------------------------------------------------------------- //
