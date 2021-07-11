#importonce

// ------------------------------------------------------------------------------------------------------------- //
// C64 Colour RAM - Only the low nybble of each Color RAM location is connected
//                  Writing to the high nybble has no effect
//                  Read    of the high nybble usually returns random values
//                          should be masked out with AND #$0f
// ------------------------------------------------------------------------------------------------------------- //
.label COLORAM              = $D800                         // $D800-$DBFF
.label COLORAM_MCM_On       = %00001000                   // set bit3 for MCM colors - colors reduced to $00-$07
.label COLORAM_MCM_Off      = %11110111                   // 
// ------------------------------------------------------------------------------------------------------------- //
// Simple colors
// ------------------------------------------------------------------------------------------------------------- //
.label BLACK                = $00
.label WHITE                = $01
.label RED                  = $02
.label CYAN                 = $03
.label PURPLE               = $04
.label GREEN                = $05
.label BLUE                 = $06
.label YELLOW               = $07
.label ORANGE               = $08
.label BROWN                = $09
.label LT_RED               = $0a
.label DK_GREY              = $0b
.label GREY                 = $0c
.label LT_GREEN             = $0d
.label LT_BLUE              = $0e
.label LT_GREY              = $0f
// ------------------------------------------------------------------------------------------------------------- //
// HiRes color combinations
// ------------------------------------------------------------------------------------------------------------- //
.label HR_BlackBlack       = $00
.label HR_BlackWhite       = $01
.label HR_BlackRed         = $02
.label HR_BlackCyan        = $03
.label HR_BlackPurple      = $04
.label HR_BlackGreen       = $05
.label HR_BlackBlue        = $06
.label HR_BlackYellow      = $07
.label HR_BlackOrange      = $08
.label HR_BlackBrown       = $09
.label HR_BlackLtRed       = $0a
.label HR_BlackDkGrey      = $0b
.label HR_BlackGrey        = $0c
.label HR_BlackLtGreen     = $0d
.label HR_BlackLtBlue      = $0e
.label HR_BlackLtGrey      = $0f
// ------------------------------------------------------------------------------------------------------------- //
.label HR_WhiteBlack       = $10
.label HR_WhiteWhite       = $11
.label HR_WhiteRed         = $12
.label HR_WhiteCyan        = $13
.label HR_WhitePurple      = $14
.label HR_WhiteGreen       = $15
.label HR_WhiteBlue        = $16
.label HR_WhiteYellow      = $17
.label HR_WhiteOrange      = $18
.label HR_WhiteBrown       = $19
.label HR_WhiteLtRed       = $1a
.label HR_WhiteDkGrey      = $1b
.label HR_WhiteGrey        = $1c
.label HR_WhiteLtGreen     = $1d
.label HR_WhiteLtBlue      = $1e
.label HR_WhiteLtGrey      = $1f
// ------------------------------------------------------------------------------------------------------------- //
.label HR_RedBlack         = $20
.label HR_RedWhite         = $21
.label HR_RedRed           = $22
.label HR_RedCyan          = $23
.label HR_RedPurple        = $24
.label HR_RedGreen         = $25
.label HR_RedBlue          = $26
.label HR_RedYellow        = $27
.label HR_RedOrange        = $28
.label HR_RedBrown         = $29
.label HR_RedLtRed         = $2a
.label HR_RedDkGrey        = $2b
.label HR_RedGrey          = $2c
.label HR_RedLtGreen       = $2d
.label HR_RedLtBlue        = $2e
.label HR_RedLtGrey        = $2f
// ------------------------------------------------------------------------------------------------------------- //
.label HR_CyanBlack        = $30
.label HR_CyanWhite        = $31
.label HR_CyanRed          = $32
.label HR_CyanCyan         = $33
.label HR_CyanPurple       = $34
.label HR_CyanGreen        = $35
.label HR_CyanBlue         = $36
.label HR_CyanYellow       = $37
.label HR_CyanOrange       = $38
.label HR_CyanBrown        = $39
.label HR_CyanLtRed        = $3a
.label HR_CyanDkGrey       = $3b
.label HR_CyanGrey         = $3c
.label HR_CyanLtGreen      = $3d
.label HR_CyanLtBlue       = $3e
.label HR_CyanLtGrey       = $3f
// ------------------------------------------------------------------------------------------------------------- //
.label HR_PurpleBlack      = $40
.label HR_PurpleWhite      = $41
.label HR_PurpleRed        = $42
.label HR_PurpleCyan       = $43
.label HR_PurplePurple     = $44
.label HR_PurpleGreen      = $45
.label HR_PurpleBlue       = $46
.label HR_PurpleYellow     = $47
.label HR_PurpleOrange     = $48
.label HR_PurpleBrown      = $49
.label HR_PurpleLtRed      = $4a
.label HR_PurpleDkGrey     = $4b
.label HR_PurpleGrey       = $4c
.label HR_PurpleLtGreen    = $4d
.label HR_PurpleLtBlue     = $4e
.label HR_PurpleLtGrey     = $4f
// ------------------------------------------------------------------------------------------------------------- //
.label HR_GreenBlack       = $50
.label HR_GreenWhite       = $51
.label HR_GreenRed         = $52
.label HR_GreenCyan        = $53
.label HR_GreenPurple      = $54
.label HR_GreenGreen       = $55
.label HR_GreenBlue        = $56
.label HR_GreenYellow      = $57
.label HR_GreenOrange      = $58
.label HR_GreenBrown       = $59
.label HR_GreenLtRed       = $5a
.label HR_GreenDkGrey      = $5b
.label HR_GreenGrey        = $5c
.label HR_GreenLtGreen     = $5d
.label HR_GreenLtBlue      = $5e
.label HR_GreenLtGrey      = $5f
// ------------------------------------------------------------------------------------------------------------- //
.label HR_BlueBlack        = $60
.label HR_BlueWhite        = $61
.label HR_BlueRed          = $62
.label HR_BlueCyan         = $63
.label HR_BluePurple       = $64
.label HR_BlueGreen        = $65
.label HR_BlueBlue         = $66
.label HR_BlueYellow       = $67
.label HR_BlueOrange       = $68
.label HR_BlueBrown        = $69
.label HR_BlueLtRed        = $6a
.label HR_BlueDkGrey       = $6b
.label HR_BlueGrey         = $6c
.label HR_BlueLtGreen      = $6d
.label HR_BlueLtBlue       = $6e
.label HR_BlueLtGrey       = $6f
// ------------------------------------------------------------------------------------------------------------- //
.label HR_YellowBlack      = $70
.label HR_YellowWhite      = $71
.label HR_YellowRed        = $72
.label HR_YellowCyan       = $73
.label HR_YellowPurple     = $74
.label HR_YellowGreen      = $75
.label HR_YellowBlue       = $76
.label HR_YellowYellow     = $77
.label HR_YellowOrange     = $78
.label HR_YellowBrown      = $79
.label HR_YellowLtRed      = $7a
.label HR_YellowDkGrey     = $7b
.label HR_YellowGrey       = $7c
.label HR_YellowLtGreen    = $7d
.label HR_YellowLtBlue     = $7e
.label HR_YellowLtGrey     = $7f
// ------------------------------------------------------------------------------------------------------------- //
.label HR_OrangeBlack      = $80
.label HR_OrangeWhite      = $81
.label HR_OrangeRed        = $82
.label HR_OrangeCyan       = $83
.label HR_OrangePurple     = $84
.label HR_OrangeGreen      = $85
.label HR_OrangeBlue       = $86
.label HR_OrangeYellow     = $87
.label HR_OrangeOrange     = $88
.label HR_OrangeBrown      = $89
.label HR_OrangeLtRed      = $8a
.label HR_OrangeDkGrey     = $8b
.label HR_OrangeGrey       = $8c
.label HR_OrangeLtGreen    = $8d
.label HR_OrangeLtBlue     = $8e
.label HR_OrangeLtGrey     = $8f
// ------------------------------------------------------------------------------------------------------------- //
.label HR_BrownBlack       = $90
.label HR_BrownWhite       = $91
.label HR_BrownRed         = $92
.label HR_BrownCyan        = $93
.label HR_BrownPurple      = $94
.label HR_BrownGreen       = $95
.label HR_BrownBlue        = $96
.label HR_BrownYellow      = $97
.label HR_BrownOrange      = $98
.label HR_BrownBrown       = $99
.label HR_BrownLtRed       = $9a
.label HR_BrownDkGrey      = $9b
.label HR_BrownGrey        = $9c
.label HR_BrownLtGreen     = $9d
.label HR_BrownLtBlue      = $9e
.label HR_BrownLtGrey      = $9f
// ------------------------------------------------------------------------------------------------------------- //
.label HR_LtRedBlack       = $a0
.label HR_LtRedWhite       = $a1
.label HR_LtRedRed         = $a2
.label HR_LtRedCyan        = $a3
.label HR_LtRedPurple      = $a4
.label HR_LtRedGreen       = $a5
.label HR_LtRedBlue        = $a6
.label HR_LtRedYellow      = $a7
.label HR_LtRedOrange      = $a8
.label HR_LtRedBrown       = $a9
.label HR_LtRedLtRed       = $aa
.label HR_LtRedDkGrey      = $ab
.label HR_LtRedGrey        = $ac
.label HR_LtRedLtGreen     = $ad
.label HR_LtRedLtBlue      = $ae
.label HR_LtRedLtGrey      = $af
// ------------------------------------------------------------------------------------------------------------- //
.label HR_DkGreyBlack      = $b0
.label HR_DkGreyWhite      = $b1
.label HR_DkGreyRed        = $b2
.label HR_DkGreyCyan       = $b3
.label HR_DkGreyPurple     = $b4
.label HR_DkGreyGreen      = $b5
.label HR_DkGreyBlue       = $b6
.label HR_DkGreyYellow     = $b7
.label HR_DkGreyOrange     = $b8
.label HR_DkGreyBrown      = $b9
.label HR_DkGreyLtRed      = $ba
.label HR_DkGreyDkGrey     = $bb
.label HR_DkGreyGrey       = $bc
.label HR_DkGreyLtGreen    = $bd
.label HR_DkGreyLtBlue     = $be
.label HR_DkGreyLtGrey     = $bf
// ------------------------------------------------------------------------------------------------------------- //
.label HR_GreyBlack        = $c0
.label HR_GreyWhite        = $c1
.label HR_GreyRed          = $c2
.label HR_GreyCyan         = $c3
.label HR_GreyPurple       = $c4
.label HR_GreyGreen        = $c5
.label HR_GreyBlue         = $c6
.label HR_GreyYellow       = $c7
.label HR_GreyOrange       = $c8
.label HR_GreyBrown        = $c9
.label HR_GreyLtRed        = $ca
.label HR_GreyDkGrey       = $cb
.label HR_GreyGrey         = $cc
.label HR_GreyLtGreen      = $cd
.label HR_GreyLtBlue       = $ce
.label HR_GreyLtGrey       = $cf
// ------------------------------------------------------------------------------------------------------------- //
.label HR_LtGreenBlack     = $d0
.label HR_LtGreenWhite     = $d1
.label HR_LtGreenRed       = $d2
.label HR_LtGreenCyan      = $d3
.label HR_LtGreenPurple    = $d4
.label HR_LtGreenGreen     = $d5
.label HR_LtGreenBlue      = $d6
.label HR_LtGreenYellow    = $d7
.label HR_LtGreenOrange    = $d8
.label HR_LtGreenBrown     = $d9
.label HR_LtGreenLtRed     = $da
.label HR_LtGreenDkGrey    = $db
.label HR_LtGreenGrey      = $dc
.label HR_LtGreenLtGreen   = $dd
.label HR_LtGreenLtBlue    = $de
.label HR_LtGreenLtGrey    = $df
// ------------------------------------------------------------------------------------------------------------- //
.label HR_LtBlueBlack      = $e0
.label HR_LtBlueWhite      = $e1
.label HR_LtBlueRed        = $e2
.label HR_LtBlueCyan       = $e3
.label HR_LtBluePurple     = $e4
.label HR_LtBlueGreen      = $e5
.label HR_LtBlueBlue       = $e6
.label HR_LtBlueYellow     = $e7
.label HR_LtBlueOrange     = $e8
.label HR_LtBlueBrown      = $e9
.label HR_LtBlueLtRed      = $ea
.label HR_LtBlueDkGrey     = $eb
.label HR_LtBlueGrey       = $ec
.label HR_LtBlueLtGreen    = $ed
.label HR_LtBlueLtBlue     = $ee
.label HR_LtBlueLtGrey     = $ef
// ------------------------------------------------------------------------------------------------------------- //
.label HR_LtGreyBlack      = $f0
.label HR_LtGreyWhite      = $f1
.label HR_LtGreyRed        = $f2
.label HR_LtGreyCyan       = $f3
.label HR_LtGreyPurple     = $f4
.label HR_LtGreyGreen      = $f5
.label HR_LtGreyBlue       = $f6
.label HR_LtGreyYellow     = $f7
.label HR_LtGreyOrange     = $f8
.label HR_LtGreyBrown      = $f9
.label HR_LtGreyLtRed      = $fa
.label HR_LtGreyDkGrey     = $fb
.label HR_LtGreyGrey       = $fc
.label HR_LtGreyLtGreen    = $fd
.label HR_LtGreyLtBlue     = $fe
.label HR_LtGreyLtGrey     = $ff
// ------------------------------------------------------------------------------------------------------------- //
