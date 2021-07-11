// ------------------------------------------------------------------------------------------------------------- //
//   Line00: ................................................................................................
//   Line01: ....#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.......
//   Line02: ..#.......................................................................................#.....
//   Line03: ..#...#.#.#.#...#.#.#...#.#.#.#.#...#.#.#.#.......#.#.#.#...#.#...#...#.#.#.#...#.#.#.#...#.....
//   Line04: ..#...#.....#...#...#...#.#.#...#...#.#...........#...#.#...#.#...#...#.#.#.#...#.....#...#.....
//   Line05: ..#...#.........#...#...#...#...#...#.#...........#...#.#...#.#...#...#.#.......#.....#...#.....
//   Line06: ..#...#.........#...#...#...#...#...#.#.#.#.......#...#.#...#.#...#...#.#.#.....#.#.#.#...#.....
//   Line07: ..#...#...#.#...#.#.#...#...#...#...#.#.#.#.......#.....#...#.#...#...#.........#.#.#.....#.....
//   Line08: ..#...#.....#...#...#...#...#...#...#.............#.....#...#.#.#.#...#.........#.#.#.....#.....
//   Line09: ..#...#.....#...#...#...#...#...#...#.............#.....#.....#.#.....#.........#.#...#...#.....
//   Line0a: ..#...#.#.#.#...#...#...#...#...#...#.#.#.#.......#.#.#.#.....#.......#.#.#.#...#.....#...#.....
//   Line02: ..#.......................................................................................#.....
//   Line01: ....#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.......
// ------------------------------------------------------------------------------------------------------------- //
DataSignLine00:
                .byte $00 // ................................................................................................
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $00 //

DataSignLine01:
                .byte $0a // ....#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.......
                .byte $aa //
                .byte $aa //
                .byte $aa //
                .byte $aa //
                .byte $aa //
                .byte $aa //
                .byte $aa //
                .byte $aa //
                .byte $aa //
                .byte $aa //
                .byte $80 //

DataSignLine02:
                .byte $20 // ..#.......................................................................................#.....
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $00 //
                .byte $20 //

DataSignLine03:
                .byte $22 // ..#...#.#.#.#...#.#.#...#.#.#.#.#...#.#.#.#.......#.#.#.#...#.#...#...#.#.#.#...#.#.#.#...#.....
                .byte $a8 //
                .byte $a8 //
                .byte $aa //
                .byte $8a //
                .byte $a0 //
                .byte $2a //
                .byte $8a //
                .byte $22 //
                .byte $a8 //
                .byte $aa //
                .byte $20 //

DataSignLine04:
                .byte $22 // ..#...#.....#...#...#...#.#.#...#...#.#...........#...#.#...#.#...#...#.#.#.#...#.....#...#.....
                .byte $08 //
                .byte $88 //
                .byte $a8 //
                .byte $8a //
                .byte $00 //
                .byte $22 //
                .byte $8a //
                .byte $22 //
                .byte $a8 //
                .byte $82 //
                .byte $20 //

DataSignLine05:
                .byte $22 // ..#...#.........#...#...#...#...#...#.#...........#...#.#...#.#...#...#.#.......#.....#...#.....
                .byte $00 //
                .byte $88 //
                .byte $88 //
                .byte $8a //
                .byte $00 //
                .byte $22 //
                .byte $8a //
                .byte $22 //
                .byte $80 //
                .byte $82 //
                .byte $20 //

DataSignLine06:
                .byte $22 // ..#...#.........#...#...#...#...#...#.#.#.#.......#...#.#...#.#...#...#.#.#.....#.#.#.#...#.....
                .byte $00 //
                .byte $88 //
                .byte $88 //
                .byte $8a //
                .byte $a0 //
                .byte $22 //
                .byte $8a //
                .byte $22 //
                .byte $a0 //
                .byte $aa //
                .byte $20 //

DataSignLine07:
                .byte $22 // ..#...#...#.#...#.#.#...#...#...#...#.#.#.#.......#.....#...#.#...#...#.........#.#.#.....#.....
                .byte $28 //
                .byte $a8 //
                .byte $88 //
                .byte $8a //
                .byte $a0 //
                .byte $20 //
                .byte $8a //
                .byte $22 //
                .byte $00 //
                .byte $a8 //
                .byte $20 //

DataSignLine08:
                .byte $22 // ..#...#.....#...#...#...#...#...#...#.............#.....#...#.#.#.#...#.........#.#.#.....#.....
                .byte $08 //
                .byte $88 //
                .byte $88 //
                .byte $88 //
                .byte $00 //
                .byte $20 //
                .byte $8a //
                .byte $a2 //
                .byte $00 //
                .byte $a8 //
                .byte $20 //

DataSignLine09:
                .byte $22 // ..#...#.....#...#...#...#...#...#...#.............#.....#.....#.#.....#.........#.#...#...#.....
                .byte $08 //
                .byte $88 //
                .byte $88 //
                .byte $88 //
                .byte $00 //
                .byte $20 //
                .byte $82 //
                .byte $82 //
                .byte $00 //
                .byte $a2 //
                .byte $20 //

DataSignLine0a:
                .byte $22 // ..#...#.#.#.#...#...#...#...#...#...#.#.#.#.......#.#.#.#.....#.......#.#.#.#...#.....#...#.....
                .byte $a8 //
                .byte $88 //
                .byte $88 //
                .byte $8a //
                .byte $a0 //
                .byte $2a //
                .byte $82 //
                .byte $02 //
                .byte $a8 //
                .byte $a2 //
                .byte $20 //
// ------------------------------------------------------------------------------------------------------------- //
.label TabSignDataAdr    = *                            // flip data address tab
.label TabSignDataLen = [DataSignLine01-DataSignLine00] // line data length

ObjLine00:        .word [DataSignLine00 - TabSignDataLen] - $02
ObjLine01:        .word [DataSignLine01 - TabSignDataLen] - $02
ObjLine02:        .word [DataSignLine02 - TabSignDataLen] - $02
ObjLine03:        .word [DataSignLine03 - TabSignDataLen] - $02
ObjLine04:        .word [DataSignLine04 - TabSignDataLen] - $02
ObjLine05:        .word [DataSignLine05 - TabSignDataLen] - $02
ObjLine06:        .word [DataSignLine06 - TabSignDataLen] - $02
ObjLine07:        .word [DataSignLine07 - TabSignDataLen] - $02
ObjLine08:        .word [DataSignLine08 - TabSignDataLen] - $02
ObjLine09:        .word [DataSignLine09 - TabSignDataLen] - $02
ObjLine0a:        .word [DataSignLine0a - TabSignDataLen] - $02

.label NoSignLine00  =  (DataSignLine00 - DataSignLine00) / TabSignDataLen
.label NoSignLine01  =  (DataSignLine01 - DataSignLine00) / TabSignDataLen
.label NoSignLine02  =  (DataSignLine02 - DataSignLine00) / TabSignDataLen
.label NoSignLine03  =  (DataSignLine03 - DataSignLine00) / TabSignDataLen
.label NoSignLine04  =  (DataSignLine04 - DataSignLine00) / TabSignDataLen
.label NoSignLine05  =  (DataSignLine05 - DataSignLine00) / TabSignDataLen
.label NoSignLine06  =  (DataSignLine06 - DataSignLine00) / TabSignDataLen
.label NoSignLine07  =  (DataSignLine07 - DataSignLine00) / TabSignDataLen
.label NoSignLine08  =  (DataSignLine08 - DataSignLine00) / TabSignDataLen
.label NoSignLine09  =  (DataSignLine09 - DataSignLine00) / TabSignDataLen
.label NoSignLine0a  =  (DataSignLine0a - DataSignLine00) / TabSignDataLen
// ------------------------------------------------------------------------------------------------------------- //
MelodyMaxNo:       .byte $09
MelodyMinHight:    .byte $02
MelodyMaxHight:    .byte $0c

TabMelodyPtr:
                .word TabMelody00
                .word TabMelody01
                .word TabMelody02
                .word TabMelody03
                .word TabMelody04
                .word TabMelody05
                .word TabMelody06
                .word TabMelody07
                .word TabMelody08
                .word TabMelody09
                .word TabMelody0a                // $00 - not used
                .word TabMelody0a
                .word TabMelody0a
                .word TabMelody0a
                .word TabMelody0a
// ------------------------------------------------------------------------------------------------------------- //
TabVocsFreqDatLo:
                .byte $00
                .byte $e1
                .byte $68
                .byte $f7
                .byte $8f
                .byte $30
                .byte $da
                .byte $8f
                .byte $4e
                .byte $18
                .byte $ef
                .byte $d2
                .byte $c3
                .byte $c3
                .byte $d1
                .byte $ef
                .byte $1f
                .byte $60
                .byte $b5
                .byte $1e
                .byte $9c
                .byte $31
                .byte $df
                .byte $a5
                .byte $87
                .byte $86
                .byte $a2
                .byte $df
                .byte $3e
                .byte $c1
                .byte $6b
                .byte $3c
                .byte $39
                .byte $63
                .byte $be
                .byte $4b
                .byte $0f

TabVocsFreqDatHi:
                .byte $00
                .byte $08
                .byte $09
                .byte $09
                .byte $0a
                .byte $0b
                .byte $0b
                .byte $0c
                .byte $0d
                .byte $0e
                .byte $0e
                .byte $0f
                .byte $10
                .byte $11
                .byte $12
                .byte $13
                .byte $15
                .byte $16
                .byte $17
                .byte $19
                .byte $1a
                .byte $1c
                .byte $1d
                .byte $1f
                .byte $21
                .byte $23
                .byte $25
                .byte $27
                .byte $2a
                .byte $2c
                .byte $2f
                .byte $32
                .byte $35
                .byte $38
                .byte $3b
                .byte $3f
                .byte $43

TabMelody09:
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $08
                .byte $07
                .byte $ff
                .byte $a0
                .byte $08
                .byte $0c
                .byte $ff
                .byte $a0
                .byte $08
                .byte $10
                .byte $ff
                .byte $a0
                .byte $04
                .byte $13
                .byte $ff
                .byte $d0
                .byte $0c
                .byte $00
                .byte $00
                .byte $00
                .byte $08
                .byte $10
                .byte $ff
                .byte $a0
                .byte $06
                .byte $13
                .byte $ff
                .byte $d0
                .byte $06
                .byte $13
                .byte $ff
                .byte $a0
                .byte $06
                .byte $13
                .byte $ff
                .byte $70
                .byte $10
                .byte $13
                .byte $ff
                .byte $40
                .byte $10
                .byte $00
                .byte $00
                .byte $00
                .byte $00

TabMelody05:
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $13
                .byte $ff
                .byte $c0
                .byte $04
                .byte $12
                .byte $ff
                .byte $a0
                .byte $04
                .byte $11
                .byte $ff
                .byte $a0
                .byte $04
                .byte $10
                .byte $ff
                .byte $a0
                .byte $04
                .byte $0f
                .byte $ff
                .byte $a0
                .byte $04
                .byte $14
                .byte $ff
                .byte $a0
                .byte $04
                .byte $13
                .byte $ff
                .byte $a0
                .byte $04
                .byte $12
                .byte $ff
                .byte $a0
                .byte $04
                .byte $13
                .byte $ff
                .byte $d0
                .byte $04
                .byte $12
                .byte $ff
                .byte $a0
                .byte $04
                .byte $11
                .byte $ff
                .byte $a0
                .byte $04
                .byte $10
                .byte $ff
                .byte $a0
                .byte $04
                .byte $0f
                .byte $ff
                .byte $a0
                .byte $04
                .byte $10
                .byte $ff
                .byte $a0
                .byte $04
                .byte $11
                .byte $ff
                .byte $a0
                .byte $04
                .byte $12
                .byte $ff
                .byte $a0
                .byte $03
                .byte $13
                .byte $ff
                .byte $d0
                .byte $03
                .byte $13
                .byte $ff
                .byte $a0
                .byte $03
                .byte $13
                .byte $ff
                .byte $70
                .byte $04
                .byte $13
                .byte $ff
                .byte $40
                .byte $10
                .byte $00
                .byte $00
                .byte $00
                .byte $00

TabMelody02:
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $05
                .byte $02
                .byte $1c
                .byte $a0
                .byte $05
                .byte $04
                .byte $17
                .byte $a0
                .byte $05
                .byte $05
                .byte $15
                .byte $a0
                .byte $05
                .byte $07
                .byte $13
                .byte $a0
                .byte $05
                .byte $09
                .byte $11
                .byte $a0
                .byte $05
                .byte $0b
                .byte $10
                .byte $a0
                .byte $05
                .byte $0c
                .byte $0c
                .byte $a0
                .byte $05
                .byte $10
                .byte $0b
                .byte $a0
                .byte $05
                .byte $11
                .byte $09
                .byte $a0
                .byte $05
                .byte $13
                .byte $07
                .byte $a0
                .byte $05
                .byte $15
                .byte $05
                .byte $a0
                .byte $05
                .byte $17
                .byte $04
                .byte $a0
                .byte $05
                .byte $1c
                .byte $02
                .byte $a0
                .byte $10
                .byte $00
                .byte $00
                .byte $00
                .byte $00

TabMelody06:
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $0c
                .byte $ff
                .byte $c0
                .byte $08
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $07
                .byte $ff
                .byte $a0
                .byte $04
                .byte $06
                .byte $ff
                .byte $a0
                .byte $04
                .byte $07
                .byte $ff
                .byte $a0
                .byte $04
                .byte $08
                .byte $ff
                .byte $a0
                .byte $08
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $07
                .byte $ff
                .byte $a0
                .byte $08
                .byte $00
                .byte $00
                .byte $00
                .byte $0c
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $17
                .byte $11
                .byte $a0
                .byte $08
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $18
                .byte $10
                .byte $a0
                .byte $10
                .byte $00
                .byte $00
                .byte $00
                .byte $00

TabMelody08:
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $07
                .byte $ff
                .byte $a0
                .byte $01
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $07
                .byte $ff
                .byte $a0
                .byte $01
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $07
                .byte $ff
                .byte $a0
                .byte $05
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $07
                .byte $ff
                .byte $a0
                .byte $01
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $07
                .byte $ff
                .byte $a0
                .byte $01
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $07
                .byte $ff
                .byte $a0
                .byte $05
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $07
                .byte $ff
                .byte $a0
                .byte $01
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $07
                .byte $ff
                .byte $a0
                .byte $01
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $0c
                .byte $ff
                .byte $b0
                .byte $05
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $0e
                .byte $ff
                .byte $b0
                .byte $05
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $10
                .byte $ff
                .byte $b0
                .byte $05
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $07
                .byte $ff
                .byte $a0
                .byte $01
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $07
                .byte $ff
                .byte $a0
                .byte $01
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $07
                .byte $ff
                .byte $a0
                .byte $05
                .byte $00
                .byte $00
                .byte $a0
                .byte $03
                .byte $07
                .byte $ff
                .byte $a0
                .byte $01
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $07
                .byte $ff
                .byte $a0
                .byte $01
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $07
                .byte $ff
                .byte $a0
                .byte $05
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $0c
                .byte $ff
                .byte $a0
                .byte $01
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $10
                .byte $ff
                .byte $a0
                .byte $01
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $0e
                .byte $ff
                .byte $b0
                .byte $05
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $0b
                .byte $ff
                .byte $b0
                .byte $05
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $07
                .byte $ff
                .byte $b0
                .byte $10
                .byte $00
                .byte $00
                .byte $00
                .byte $00

TabMelody03:
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $07
                .byte $ff
                .byte $a0
                .byte $04
                .byte $0c
                .byte $ff
                .byte $a0
                .byte $04
                .byte $10
                .byte $ff
                .byte $a0
                .byte $04
                .byte $13
                .byte $ff
                .byte $d0
                .byte $08
                .byte $00
                .byte $00
                .byte $00
                .byte $02
                .byte $13
                .byte $ff
                .byte $a0
                .byte $02
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $13
                .byte $ff
                .byte $a0
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $10
                .byte $ff
                .byte $d0
                .byte $08
                .byte $00
                .byte $00
                .byte $00
                .byte $02
                .byte $10
                .byte $ff
                .byte $a0
                .byte $02
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $10
                .byte $ff
                .byte $a0
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $0c
                .byte $ff
                .byte $a0
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $10
                .byte $ff
                .byte $a0
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $0c
                .byte $ff
                .byte $a0
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $06
                .byte $07
                .byte $ff
                .byte $d0
                .byte $06
                .byte $07
                .byte $ff
                .byte $a0
                .byte $06
                .byte $07
                .byte $ff
                .byte $70
                .byte $06
                .byte $07
                .byte $ff
                .byte $50
                .byte $10
                .byte $00
                .byte $00
                .byte $00
                .byte $00

TabMelody00:
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $02
                .byte $13
                .byte $10
                .byte $d0
                .byte $06
                .byte $13
                .byte $10
                .byte $a0
                .byte $08
                .byte $11
                .byte $0e
                .byte $a0
                .byte $06
                .byte $10
                .byte $0c
                .byte $a0
                .byte $02
                .byte $10
                .byte $0c
                .byte $40
                .byte $08
                .byte $10
                .byte $0c
                .byte $a0
                .byte $08
                .byte $11
                .byte $0e
                .byte $a0
                .byte $06
                .byte $10
                .byte $0c
                .byte $a0
                .byte $02
                .byte $10
                .byte $0c
                .byte $40
                .byte $08
                .byte $0e
                .byte $07
                .byte $a0
                .byte $08
                .byte $10
                .byte $0c
                .byte $a0
                .byte $06
                .byte $0e
                .byte $07
                .byte $a0
                .byte $02
                .byte $0e
                .byte $07
                .byte $40
                .byte $04
                .byte $0e
                .byte $07
                .byte $d0
                .byte $04
                .byte $0e
                .byte $07
                .byte $b0
                .byte $04
                .byte $0e
                .byte $07
                .byte $a0
                .byte $04
                .byte $0e
                .byte $07
                .byte $90
                .byte $04
                .byte $0e
                .byte $07
                .byte $80
                .byte $04
                .byte $0e
                .byte $07
                .byte $70
                .byte $08
                .byte $0e
                .byte $07
                .byte $a0
                .byte $08
                .byte $10
                .byte $0c
                .byte $a0
                .byte $06
                .byte $0e
                .byte $07
                .byte $a0
                .byte $02
                .byte $0e
                .byte $07
                .byte $40
                .byte $04
                .byte $0e
                .byte $07
                .byte $d0
                .byte $04
                .byte $0e
                .byte $07
                .byte $b0
                .byte $04
                .byte $0e
                .byte $07
                .byte $a0
                .byte $04
                .byte $0e
                .byte $07
                .byte $90
                .byte $04
                .byte $0e
                .byte $07
                .byte $80
                .byte $04
                .byte $0e
                .byte $07
                .byte $70
                .byte $04
                .byte $0e
                .byte $07
                .byte $60
                .byte $04
                .byte $0e
                .byte $07
                .byte $50
                .byte $04
                .byte $0e
                .byte $07
                .byte $40
                .byte $04
                .byte $0e
                .byte $07
                .byte $30
                .byte $08
                .byte $0e
                .byte $07
                .byte $20
                .byte $10
                .byte $00
                .byte $00
                .byte $00
                .byte $00

TabMelody04:
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $10
                .byte $ff
                .byte $a0
                .byte $04
                .byte $13
                .byte $ff
                .byte $a0
                .byte $04
                .byte $18
                .byte $ff
                .byte $a0
                .byte $04
                .byte $15
                .byte $ff
                .byte $a0
                .byte $04
                .byte $11
                .byte $ff
                .byte $a0
                .byte $04
                .byte $0e
                .byte $ff
                .byte $a0
                .byte $04
                .byte $13
                .byte $ff
                .byte $a0
                .byte $04
                .byte $11
                .byte $ff
                .byte $a0
                .byte $04
                .byte $0e
                .byte $ff
                .byte $a0
                .byte $04
                .byte $0c
                .byte $ff
                .byte $a0
                .byte $0c
                .byte $00
                .byte $00
                .byte $00
                .byte $02
                .byte $18
                .byte $ff
                .byte $a0
                .byte $02
                .byte $13
                .byte $ff
                .byte $a0
                .byte $02
                .byte $10
                .byte $ff
                .byte $a0
                .byte $04
                .byte $0c
                .byte $ff
                .byte $a0
                .byte $10
                .byte $00
                .byte $00
                .byte $00
                .byte $00

TabMelody07:
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $18
                .byte $ff
                .byte $a0
                .byte $04
                .byte $17
                .byte $ff
                .byte $a0
                .byte $04
                .byte $16
                .byte $ff
                .byte $a0
                .byte $04
                .byte $15
                .byte $ff
                .byte $a0
                .byte $04
                .byte $14
                .byte $ff
                .byte $a0
                .byte $04
                .byte $13
                .byte $ff
                .byte $a0
                .byte $04
                .byte $12
                .byte $ff
                .byte $a0
                .byte $04
                .byte $11
                .byte $ff
                .byte $a0
                .byte $04
                .byte $10
                .byte $ff
                .byte $a0
                .byte $04
                .byte $0f
                .byte $ff
                .byte $a0
                .byte $04
                .byte $0e
                .byte $ff
                .byte $a0
                .byte $04
                .byte $0d
                .byte $ff
                .byte $a0
                .byte $04
                .byte $0c
                .byte $ff
                .byte $a0
                .byte $0c
                .byte $00
                .byte $00
                .byte $00
                .byte $02
                .byte $0c
                .byte $ff
                .byte $a0
                .byte $02
                .byte $10
                .byte $ff
                .byte $a0
                .byte $02
                .byte $13
                .byte $ff
                .byte $a0
                .byte $04
                .byte $18
                .byte $ff
                .byte $a0
                .byte $10
                .byte $00
                .byte $00
                .byte $00
                .byte $00

TabMelody01:
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $10
                .byte $ff
                .byte $a0
                .byte $04
                .byte $13
                .byte $ff
                .byte $a0
                .byte $04
                .byte $18
                .byte $ff
                .byte $a0
                .byte $04
                .byte $13
                .byte $ff
                .byte $a0
                .byte $04
                .byte $10
                .byte $ff
                .byte $a0
                .byte $04
                .byte $13
                .byte $ff
                .byte $a0
                .byte $04
                .byte $18
                .byte $ff
                .byte $a0
                .byte $04
                .byte $13
                .byte $ff
                .byte $a0
                .byte $04
                .byte $15
                .byte $ff
                .byte $d0
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $02
                .byte $11
                .byte $ff
                .byte $a0
                .byte $02
                .byte $11
                .byte $ff
                .byte $80
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $02
                .byte $11
                .byte $ff
                .byte $a0
                .byte $02
                .byte $11
                .byte $ff
                .byte $80
                .byte $0c
                .byte $00
                .byte $00
                .byte $00
                .byte $04
                .byte $12
                .byte $ff
                .byte $a0
                .byte $04
                .byte $15
                .byte $ff
                .byte $a0
                .byte $04
                .byte $1f
                .byte $0f
                .byte $a0
                .byte $04
                .byte $15
                .byte $ff
                .byte $a0
                .byte $04
                .byte $12
                .byte $ff
                .byte $a0
                .byte $04
                .byte $15
                .byte $ff
                .byte $a0
                .byte $04
                .byte $1f
                .byte $0f
                .byte $a0
                .byte $04
                .byte $15
                .byte $ff
                .byte $a0
                .byte $04
                .byte $17
                .byte $ff
                .byte $d0
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $02
                .byte $13
                .byte $ff
                .byte $a0
                .byte $02
                .byte $13
                .byte $ff
                .byte $80
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $02
                .byte $13
                .byte $ff
                .byte $a0
                .byte $02
                .byte $13
                .byte $ff
                .byte $80
                .byte $10
                .byte $00
                .byte $00
                .byte $00
                .byte $00

TabMelody0a:
                .byte $00
// ------------------------------------------------------------------------------------------------------------- //
.label TabDemoMoves  = *

TabDemoMoveLvl01:
                .byte $16 //
                .byte $4c //
                .byte $66 //
                .byte $02 //
                .byte $55 //
                .byte $01 //
                .byte $66 //
                .byte $02 //
                .byte $36 //
                .byte $18 //
                .byte $55 //
                .byte $01 //
                .byte $44 //
                .byte $01 //
                .byte $66 //
                .byte $14 //
                .byte $36 //
                .byte $0d //
                .byte $30 //
                .byte $17 //
                .byte $60 //
                .byte $08 //
                .byte $66 //
                .byte $03 //
                .byte $16 //
                .byte $16 //
                .byte $66 //
                .byte $04 //
                .byte $36 //
                .byte $23 //
                .byte $32 //
                .byte $01 //
                .byte $62 //
                .byte $01 //
                .byte $55 //
                .byte $01 //
                .byte $66 //
                .byte $20 //
                .byte $16 //
                .byte $07 //
                .byte $66 //
                .byte $02 //
                .byte $36 //
                .byte $25 //
                .byte $30 //
                .byte $14 //
                .byte $60 //
                .byte $0e //
                .byte $10 //
                .byte $11 //
                .byte $16 //
                .byte $25 //
                .byte $10 //
                .byte $08 //
                .byte $16 //
                .byte $23 //
                .byte $10 //
                .byte $06 //
                .byte $60 //
                .byte $02 //
                .byte $30 //
                .byte $0f //
                .byte $36 //
                .byte $17 //
                .byte $66 //
                .byte $02 //
                .byte $16 //
                .byte $07 //
                .byte $55 //
                .byte $01 //
                .byte $66 //
                .byte $1e //
                .byte $16 //
                .byte $38 //
                .byte $44 //
                .byte $01 //
                .byte $16 //
                .byte $05 //
                .byte $44 //
                .byte $01 //
                .byte $16 //
                .byte $07 //
                .byte $44 //
                .byte $01 //
                .byte $36 //
                .byte $07 //
                .byte $55 //
                .byte $01 //
                .byte $36 //
                .byte $04 //
                .byte $55 //
                .byte $01 //
                .byte $16 //
                .byte $03 //
                .byte $55 //
                .byte $01 //
                .byte $16 //
                .byte $03 //
                .byte $36 //
                .byte $0b //
                .byte $55 //
                .byte $01 //
                .byte $16 //
                .byte $03 //
                .byte $36 //
                .byte $0e //
                .byte $44 //
                .byte $01 //
                .byte $66 //
                .byte $01 //
                .byte $60 //
                .byte $0c //
                .byte $30 //
                .byte $29 //
                .byte $60 //
                .byte $02 //
                .byte $44 //
                .byte $01 //
                .byte $16 //
                .byte $2b //
                .byte $10 //
                .byte $04 //
                .byte $60 //
                .byte $05 //
                .byte $30 //
                .byte $01 //
                .byte $36 //
                .byte $67 //
                .byte $32 //
                .byte $01 //
                .byte $44 //
                .byte $01 //
                .byte $66 //
                .byte $2b //
                .byte $36 //
                .byte $0c //
                .byte $30 //
                .byte $15 //
                .byte $36 //
                .byte $12 //
                .byte $55 //
                .byte $01 //
                .byte $16 //
                .byte $03 //
                .byte $55 //
                .byte $01 //
                .byte $36 //
                .byte $05 //
                .byte $55 //
                .byte $01 //
                .byte $16 //
                .byte $03 //
                .byte $36 //
                .byte $08 //
                .byte $66 //
                .byte $02 //
                .byte $16 //
                .byte $4a //
                .byte $10 //
                .byte $04 //
                .byte $60 //
                .byte $07 //
                .byte $30 //
                .byte $09 //
                .byte $36 //
                .byte $15 //
                .byte $66 //
                .byte $0a //
                .byte $16 //
                .byte $0d //
                .byte $44 //
                .byte $01 //
                .byte $66 //
                .byte $02 //
                .byte $16 //
                .byte $04 //
                .byte $44 //
                .byte $01 //
                .byte $16 //
                .byte $02 //
                .byte $44 //
                .byte $06 //
                .byte $16 //
                .byte $04 //
                .byte $44 //
                .byte $01 //
                .byte $16 //
                .byte $02 //
                .byte $62 //
                .byte $15 //
                .byte $36 //
                .byte $31 //
                .byte $66 //
                .byte $01 //
                .byte $62 //
                .byte $04 //
                .byte $12 //
                .byte $06 //
                .byte $44 //
                .byte $01 //
                .byte $66 //
                .byte $37 //
                .byte $36 //
                .byte $01 //
                .byte $30 //
                .byte $1d //
                .byte $60 //
                .byte $33 //

TabDemoMoveLvl02:
                .byte $36 //
                .byte $32 //
                .byte $66 //
                .byte $03 //
                .byte $16 //
                .byte $01 //
                .byte $10 //
                .byte $1b //
                .byte $60 //
                .byte $05 //
                .byte $36 //
                .byte $28 //
                .byte $44 //
                .byte $01 //
                .byte $66 //
                .byte $1f //
                .byte $36 //
                .byte $14 //
                .byte $44 //
                .byte $01 //
                .byte $55 //
                .byte $01 //
                .byte $66 //
                .byte $2d //
                .byte $36 //
                .byte $01 //
                .byte $30 //
                .byte $12 //
                .byte $60 //
                .byte $25 //
                .byte $66 //
                .byte $01 //
                .byte $55 //
                .byte $01 //
                .byte $16 //
                .byte $0d //
                .byte $66 //
                .byte $02 //
                .byte $36 //
                .byte $09 //
                .byte $30 //
                .byte $0a //
                .byte $36 //
                .byte $04 //
                .byte $44 //
                .byte $01 //
                .byte $36 //
                .byte $03 //
                .byte $44 //
                .byte $01 //
                .byte $36 //
                .byte $03 //
                .byte $16 //
                .byte $22 //
                .byte $44 //
                .byte $01 //
                .byte $16 //
                .byte $07 //
                .byte $44 //
                .byte $04 //
                .byte $16 //
                .byte $03 //
                .byte $44 //
                .byte $01 //
                .byte $16 //
                .byte $27 //
                .byte $12 //
                .byte $0e //
                .byte $16 //
                .byte $1e //
                .byte $55 //
                .byte $01 //
                .byte $66 //
                .byte $19 //
                .byte $36 //
                .byte $01 //
                .byte $30 //
                .byte $03 //
                .byte $60 //
                .byte $07 //
                .byte $10 //
                .byte $1f //
                .byte $60 //
                .byte $07 //
                .byte $30 //
                .byte $09 //
                .byte $36 //
                .byte $33 //
                .byte $66 //
                .byte $04 //
                .byte $10 //
                .byte $09 //
                .byte $16 //
                .byte $08 //
                .byte $12 //
                .byte $01 //
                .byte $62 //
                .byte $0c //
                .byte $32 //
                .byte $01 //
                .byte $36 //
                .byte $32 //
                .byte $44 //
                .byte $01 //
                .byte $16 //
                .byte $0b //
                .byte $44 //
                .byte $01 //
                .byte $16 //
                .byte $09 //
                .byte $44 //
                .byte $01 //
                .byte $10 //
                .byte $2c //
                .byte $60 //
                .byte $04 //
                .byte $30 //
                .byte $03 //
                .byte $36 //
                .byte $0a //
                .byte $44 //
                .byte $01 //
                .byte $16 //
                .byte $05 //
                .byte $44 //
                .byte $01 //
                .byte $36 //
                .byte $03 //
                .byte $44 //
                .byte $01 //
                .byte $36 //
                .byte $03 //
                .byte $44 //
                .byte $01 //
                .byte $66 //
                .byte $03 //
                .byte $36 //
                .byte $03 //
                .byte $55 //
                .byte $01 //
                .byte $36 //
                .byte $08 //
                .byte $55 //
                .byte $01 //
                .byte $66 //
                .byte $4c //
                .byte $16 //
                .byte $09 //
                .byte $10 //
                .byte $15 //
                .byte $44 //
                .byte $01 //
                .byte $10 //
                .byte $2f //
                .byte $16 //
                .byte $09 //
                .byte $12 //
                .byte $03 //
                .byte $16 //
                .byte $12 //
                .byte $66 //
                .byte $02 //
                .byte $36 //
                .byte $06 //
                .byte $66 //
                .byte $2d //
                .byte $55 //
                .byte $01 //
                .byte $16 //
                .byte $03 //
                .byte $10 //
                .byte $1c //
                .byte $55 //
                .byte $01 //
                .byte $16 //
                .byte $03 //
                .byte $44 //
                .byte $01 //
                .byte $36 //
                .byte $03 //
                .byte $32 //
                .byte $15 //
                .byte $36 //
                .byte $0b //
                .byte $30 //
                .byte $0b //
                .byte $60 //
                .byte $0c //
                .byte $44 //
                .byte $01 //
                .byte $62 //
                .byte $0d //
                .byte $12 //
                .byte $02 //
                .byte $16 //
                .byte $0d //
                .byte $44 //
                .byte $01 //
                .byte $66 //
                .byte $20 //
                .byte $36 //
                .byte $04 //
                .byte $30 //
                .byte $17 //
                .byte $36 //
                .byte $1e //
                .byte $44 //
                .byte $01 //
                .byte $36 //
                .byte $2f //
                .byte $30 //
                .byte $08 //
                .byte $60 //
                .byte $03 //
                .byte $10 //
                .byte $22 //
                .byte $16 //
                .byte $1b //
                .byte $66 //
                .byte $26 //
                .byte $55 //
                .byte $07 //
                .byte $16 //
                .byte $03 //
                .byte $55 //
                .byte $01 //
                .byte $66 //
                .byte $1d //
                .byte $16 //
                .byte $02 //
                .byte $10 //
                .byte $85 //
                .byte $60 //
                .byte $02 //
                .byte $30 //
                .byte $03 //
                .byte $36 //
                .byte $03 //
                .byte $32 //
                .byte $0f //
                .byte $36 //
                .byte $03 //
                .byte $30 //
                .byte $0c //

TabDemoMoveLvl03:
                .byte $36 // right- ------
                .byte $20 //
                .byte $66 // ------ ------
                .byte $01 //
                .byte $16 // left-- ------
                .byte $0a //
                .byte $60 // ------ up----
                .byte $06 //
                .byte $66 // ------ ------
                .byte $02 //
                .byte $36 // right- ------
                .byte $08 //
                .byte $30 // right- up----
                .byte $05 //
                .byte $60 // ------ up----
                .byte $02 //
                .byte $66 // ------ ------
                .byte $02 //
                .byte $16 // left-- ------
                .byte $08 //
                .byte $10 // left-- up----
                .byte $01 //
                .byte $60 // ------ up----
                .byte $06 //
                .byte $66 // ------ ------
                .byte $01 //
                .byte $36 // right- ------
                .byte $08 //
                .byte $30 // right- up----
                .byte $04 //
                .byte $60 // ------ up----
                .byte $03 //
                .byte $66 // ------ ------
                .byte $01 //
                .byte $16 // left-- ------
                .byte $08 //
                .byte $10 // left-- up----
                .byte $02 //
                .byte $60 // ------ up----
                .byte $03 //
                .byte $30 // right- up----
                .byte $01 //
                .byte $36 // right- ------
                .byte $08 //
                .byte $30 // right- up----
                .byte $03 //
                .byte $60 // ------ up----
                .byte $03 //
                .byte $16 // left-- ------
                .byte $09 //
                .byte $10 // left-- up----
                .byte $02 //
                .byte $60 // ------ up----
                .byte $03 //
                .byte $30 // right- up----
                .byte $03 //
                .byte $36 // right- ------
                .byte $07 //
                .byte $30 // right- up----
                .byte $03 //
                .byte $60 // ------ up----
                .byte $02 //
                .byte $10 // left-- up----
                .byte $02 //
                .byte $16 // left-- ------
                .byte $08 //
                .byte $10 // left-- up----
                .byte $01 //
                .byte $60 // ------ up----
                .byte $02 //
                .byte $30 // right- up----
                .byte $02 //
                .byte $36 // right- ------
                .byte $0a //
                .byte $30 // right- up----
                .byte $02 //
                .byte $60 // ------ up----
                .byte $02 //
                .byte $10 // left-- up----
                .byte $03 //
                .byte $16 // left-- ------
                .byte $04 //
                .byte $10 // left-- up----
                .byte $03 //
                .byte $60 // ------ up----
                .byte $05 //
                .byte $30 // right- up----
                .byte $02 //
                .byte $36 // right- ------
                .byte $07 //
                .byte $66 // ------ ------
                .byte $16 //
                .byte $36 // right- ------
                .byte $02 //
                .byte $66 // ------ ------
                .byte $33 //
                .byte $55 // f-le-- f-le--
                .byte $01 //
                .byte $36 // right- ------
                .byte $05 //
                .byte $55 // f-le-- f-le--
                .byte $01 //
                .byte $36 // right- ------
                .byte $04 //
                .byte $55 // f-le-- f-le--
                .byte $01 //
                .byte $36 // right- ------
                .byte $03 //
                .byte $55 // f-le-- f-le--
                .byte $01 //
                .byte $36 // right- ------
                .byte $03 //
                .byte $55 // f-le-- f-le--
                .byte $01 //
                .byte $66 // ------ ------
                .byte $a9 //
                .byte $62 // ------ down--
                .byte $0c //

                .byte $66 // ------ ------        .hbu005. - new demo moves
                .byte $38 //
                .byte $10 // left-- up----
                .byte $10 //
                .byte $55 // f-le-- f-le--
                .byte $01 //
                .byte $36 // right- ------
                .byte $04 //
                .byte $55 // f-le-- f-le--
                .byte $01 //
                .byte $66 // ------ ------
                .byte $48 //
                .byte $16 // left-- ------
                .byte $26 //
                .byte $66 // ------ ------
                .byte $30 //
                .byte $16 // left-- ------
                .byte $15 //
                .byte $44 // f-ri-- f-ri--
                .byte $01 //
                .byte $60 // ------ up----
                .byte $0a //

TabDemoMoveLvl04:
                .byte $16 // left-- ------
                .byte $32 //
                .byte $36 // right- ------
                .byte $30 //
                .byte $55 // f-le-- f-le--
                .byte $01 //
                .byte $44 // f-ri-- f-ri--
                .byte $01 //
                .byte $66 // ------ ------
                .byte $33 //
                .byte $36 // right- ------
                .byte $0f //
                .byte $66 // ------ ------
                .byte $08 //
                .byte $16 // left-- ------
                .byte $01 //
                .byte $66 // ------ ------
                .byte $05 //
                .byte $55 // f-le-- f-le--
                .byte $01 //
                .byte $66 // ------ ------
                .byte $7f //
                .byte $00 //                      // - end of new demo moves

.label TabDemoLevels = *                          // demo level data

TabDemoDataLvl01:
                .byte $06                        // data demo  level 01
                .byte $00
                .byte $00
                .byte $07
                .byte $00
                .byte $00
                .byte $07
                .byte $00
                .byte $00
                .byte $06
                .byte $00
                .byte $00
                .byte $03
                .byte $06
                .byte $13
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $03
                .byte $00
                .byte $00
                .byte $03
                .byte $06
                .byte $03
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $07
                .byte $00
                .byte $43
                .byte $44
                .byte $44
                .byte $03
                .byte $76
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $31
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $01
                .byte $00
                .byte $00
                .byte $13
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $33
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $00
                .byte $11
                .byte $11
                .byte $11
                .byte $31
                .byte $43
                .byte $44
                .byte $44
                .byte $44
                .byte $03
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $00
                .byte $71
                .byte $70
                .byte $11
                .byte $33
                .byte $00
                .byte $00
                .byte $00
                .byte $08
                .byte $03
                .byte $70
                .byte $00
                .byte $08
                .byte $03
                .byte $70
                .byte $11
                .byte $11
                .byte $31
                .byte $03
                .byte $00
                .byte $00
                .byte $13
                .byte $11
                .byte $21
                .byte $22
                .byte $11
                .byte $11
                .byte $13
                .byte $11
                .byte $00
                .byte $00
                .byte $30
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $00
                .byte $00
                .byte $00
                .byte $30
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $00
                .byte $00
                .byte $00
                .byte $38
                .byte $00
                .byte $70
                .byte $00
                .byte $43
                .byte $44
                .byte $44
                .byte $44
                .byte $44
                .byte $44
                .byte $03
                .byte $70
                .byte $13
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $03
                .byte $70
                .byte $00
                .byte $00
                .byte $70
                .byte $00
                .byte $13
                .byte $11
                .byte $03
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $01
                .byte $03
                .byte $00
                .byte $03
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $03
                .byte $00
                .byte $03
                .byte $00
                .byte $00
                .byte $70
                .byte $00
                .byte $00
                .byte $03
                .byte $00
                .byte $90
                .byte $70
                .byte $00
                .byte $00
                .byte $03
                .byte $00
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $00
                .byte $00

TabDemoDataMsg01:
                .byte $c1 // A
                .byte $a0 // <blank>
                .byte $c7 // G
                .byte $cf // O
                .byte $cf // O
                .byte $c4 // D
                .byte $a0 // <blank>
                .byte $cf // O
                .byte $cc // L
                .byte $c4 // D
                .byte $a0 // <blank>
                .byte $cc // L
                .byte $c1 // A
                .byte $c4 // D
                .byte $d9 // Y

TabDemoDataMID01:
                .byte $00 //
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
                .byte $00

TabDemoDataLvl02:
                .byte $11                        // data demo level 02
                .byte $11
                .byte $61
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $01
                .byte $11
                .byte $11
                .byte $06
                .byte $00
                .byte $61
                .byte $01
                .byte $44
                .byte $44
                .byte $44
                .byte $04
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $10
                .byte $16
                .byte $61
                .byte $60
                .byte $01
                .byte $71
                .byte $00
                .byte $10
                .byte $13
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $80
                .byte $10
                .byte $06
                .byte $11
                .byte $11
                .byte $01
                .byte $11
                .byte $11
                .byte $11
                .byte $13
                .byte $11
                .byte $11
                .byte $07
                .byte $31
                .byte $11
                .byte $11
                .byte $61
                .byte $00
                .byte $00
                .byte $47
                .byte $44
                .byte $11
                .byte $11
                .byte $13
                .byte $11
                .byte $11
                .byte $11
                .byte $31
                .byte $01
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $01
                .byte $00
                .byte $01
                .byte $10
                .byte $13
                .byte $11
                .byte $10
                .byte $11
                .byte $31
                .byte $01
                .byte $11
                .byte $00
                .byte $00
                .byte $00
                .byte $80
                .byte $00
                .byte $00
                .byte $10
                .byte $13
                .byte $11
                .byte $10
                .byte $01
                .byte $31
                .byte $71
                .byte $10
                .byte $13
                .byte $11
                .byte $11
                .byte $11
                .byte $13
                .byte $73
                .byte $10
                .byte $13
                .byte $11
                .byte $10
                .byte $01
                .byte $31
                .byte $11
                .byte $11
                .byte $03
                .byte $00
                .byte $00
                .byte $00
                .byte $13
                .byte $11
                .byte $11
                .byte $13
                .byte $11
                .byte $07
                .byte $01
                .byte $31
                .byte $11
                .byte $10
                .byte $03
                .byte $00
                .byte $00
                .byte $00
                .byte $00
                .byte $11
                .byte $11
                .byte $13
                .byte $11
                .byte $11
                .byte $01
                .byte $31
                .byte $11
                .byte $17
                .byte $03
                .byte $00
                .byte $00
                .byte $00
                .byte $01
                .byte $00
                .byte $00
                .byte $03
                .byte $00
                .byte $00
                .byte $00
                .byte $30
                .byte $00
                .byte $10
                .byte $13
                .byte $11
                .byte $13
                .byte $11
                .byte $31
                .byte $21
                .byte $21
                .byte $21
                .byte $21
                .byte $21
                .byte $21
                .byte $31
                .byte $21
                .byte $21
                .byte $13
                .byte $11
                .byte $13
                .byte $11
                .byte $31
                .byte $11
                .byte $11
                .byte $11
                .byte $00
                .byte $11
                .byte $11
                .byte $31
                .byte $21
                .byte $21
                .byte $03
                .byte $00
                .byte $03
                .byte $00
                .byte $30
                .byte $11
                .byte $11
                .byte $11
                .byte $01
                .byte $10
                .byte $11
                .byte $31
                .byte $00
                .byte $00
                .byte $13
                .byte $11
                .byte $11
                .byte $11
                .byte $31
                .byte $11
                .byte $11
                .byte $11
                .byte $11
                .byte $07
                .byte $11
                .byte $11
                .byte $11
                .byte $31
                .byte $93
                .byte $00
                .byte $00
                .byte $00
                .byte $30
                .byte $70
                .byte $10
                .byte $11
                .byte $11
                .byte $01
                .byte $80
                .byte $00
                .byte $00
                .byte $30
                .byte $00
                .byte $00

TabDemoDataMsg02:
                .byte $c2 // B
                .byte $c5 // E
                .byte $c1 // A
                .byte $d5 // U
                .byte $d4 // T
                .byte $c9 // I
                .byte $c6 // F
                .byte $c9 // I
                .byte $c5 // E
                .byte $c4 // D
                .byte $a0 // <blank>
                .byte $d7 // W
                .byte $c9 // I
                .byte $d4 // T
                .byte $c8 // H
TabDemoDataMID02:
                .byte  $00 //
                .byte  $00 //
                .byte  $00 //
                .byte  $cc // L
                .byte  $cf // O
                .byte  $c4 // D
                .byte  $c5 // E
                .byte  $a0 // <blank>
                .byte  $d2 // R
                .byte  $d5 // U
                .byte  $ce // N
                .byte  $ce // N
                .byte  $c5 // E
                .byte  $52 // r
                .byte  $00
                
TabDemoDataLvl03:
                .byte  $00                        // data demo level 03
                .byte  $00
                .byte  $00
                .byte  $30
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $80
                .byte  $07
                .byte  $00
                .byte  $30
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $70
                .byte  $08
                .byte  $13
                .byte  $81
                .byte  $07
                .byte  $30
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $70
                .byte  $18
                .byte  $31
                .byte  $03
                .byte  $10
                .byte  $01
                .byte  $30
                .byte  $11
                .byte  $11
                .byte  $36
                .byte  $11
                .byte  $11
                .byte  $31
                .byte  $00
                .byte  $10
                .byte  $01
                .byte  $30
                .byte  $03
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $33
                .byte  $07
                .byte  $00
                .byte  $30
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $30
                .byte  $03
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $37
                .byte  $03
                .byte  $00
                .byte  $30
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $30
                .byte  $03
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $33
                .byte  $07
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $30
                .byte  $03
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $37
                .byte  $03
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $30
                .byte  $03
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $33
                .byte  $07
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $30
                .byte  $03
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $37
                .byte  $03
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $30
                .byte  $03
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $33
                .byte  $07
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $30
                .byte  $03
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $37
                .byte  $03
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $30
                .byte  $03
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $33
                .byte  $07
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $30
                .byte  $03
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $37
                .byte  $03
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $30
                .byte  $03
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $09
                .byte  $00
                .byte  $33
                .byte  $07
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $00
                .byte  $30
                .byte  $03
                .byte  $00
                .byte  $30
                .byte  $11
                .byte  $11
                .byte  $11
                .byte  $11
                .byte  $11
                .byte  $11
                .byte  $11
                .byte  $11
                .byte  $03
                .byte  $00
                .byte  $30
                .byte  $00
                .byte  $00
TabDemoDataMsg03:
                .byte  $c1 // A
                .byte  $a0 // <blank>
                .byte  $c6 // F
                .byte  $c5 // E
                .byte  $d7 // W
                .byte  $a0 // <blank>
                .byte  $ce // N
                .byte  $c5 // E
                .byte  $d7 // W
                .byte  $a0 // <blank>
                .byte  $c9 // I
                .byte  $c4 // D
                .byte  $c5 // E
                .byte  $c1 // A
                .byte  $d3 // S
TabDemoDataMID03:
                .byte  $00 //
                .byte  $00 //
                .byte  $00 //
                .byte  $cc // L
                .byte  $cf // O
                .byte  $c4 // D
                .byte  $c5 // E
                .byte  $a0 // <blank>
                .byte  $d2 // R
                .byte  $d5 // U
                .byte  $ce // N
                .byte  $ce // N
                .byte  $c5 // E
                .byte  $52 // r
                .byte  $00
// ------------------------------------------------------------------------------------------------------------- //
.label DatImages  =  *                                   // .hbu008. - start address for number calculations
// ------------------------------------------------------------------------------------------------------------- //
.label DatImage00 = *

DatTile0:
        .byte  %00000000, %00000000, %00000000 // ........................ free space
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................

.label DatImage01 = *

DatTile1:
        .byte  %10101000, %10000000, %00000000 // #.#.#...#............... MC shootable (weak) wall
        .byte  %10101000, %10000000, %00000000 // #.#.#...#...............
        .byte  %10101000, %10000000, %00000000 // #.#.#...#...............
        .byte  %10101000, %10000000, %00000000 // #.#.#...#...............
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %00000000, %00000000, %00000000 // ........................

.label DatImage02  = *

DatTile2:
        .byte  %10101010, %10000000, %00000000 // #.#.#.#.#............... MC non shootable (solid) wall
        .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
        .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
        .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
        .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
        .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
        .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
        .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
        .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
        .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
        .byte  %00000000, %00000000, %00000000 // ........................

.label DatImage03 = *

DatTile3:
        .byte  %11000011, %00000000, %00000000 // ##....##................ MC ladder
        .byte  %11000011, %00000000, %00000000 // ##....##................
        .byte  %11111111, %00000000, %00000000 // ########................
        .byte  %11000011, %00000000, %00000000 // ##....##................
        .byte  %11000011, %00000000, %00000000 // ##....##................
        .byte  %11000011, %00000000, %00000000 // ##....##................
        .byte  %11000011, %00000000, %00000000 // ##....##................
        .byte  %11111111, %00000000, %00000000 // ########................
        .byte  %11000011, %00000000, %00000000 // ##....##................
        .byte  %11000011, %00000000, %00000000 // ##....##................
        .byte  %11000011, %00000000, %00000000 // ##....##................

.label DatImage04 = *

DatTile4:
        .byte  %00000000, %00000000, %00000000 // ........................ MC pole
        .byte  %11111111, %11000000, %00000000 // ##########..............
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................

.label DatImage05 = *
DatTile5:
        .byte  %10101010, %10000000, %00000000 // #.#.#.#.#............... MC trap wall
        .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00111111, %00000000, %00000000 // ..######................
        .byte  %00001100, %00000000, %00000000 // ....##..................
        .byte  %00001100, %00000000, %00000000 // ....##..................
        .byte  %00001100, %00000000, %00000000 // ....##..................
        .byte  %00001100, %00000000, %00000000 // ....##..................
        .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
        .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
        .byte  %00000000, %00000000, %00000000 // ........................

.label DatImage06 = *
DatTile6:
        .byte  %11000000, %00000000, %00000000 // ##...................... MC hidden exit ladder
        .byte  %11000000, %00000000, %00000000 // ##......................
        .byte  %11111111, %00000000, %00000000 // ########................
        .byte  %11000011, %00000000, %00000000 // ##....##................
        .byte  %00000011, %00000000, %00000000 // ......##................
        .byte  %00000011, %00000000, %00000000 // ......##................
        .byte  %00000011, %00000000, %00000000 // ......##................
        .byte  %11000011, %00000000, %00000000 // ##....##................
        .byte  %11111111, %00000000, %00000000 // ########................
        .byte  %11000000, %00000000, %00000000 // ##......................
        .byte  %11000000, %00000000, %00000000 // ##......................

.label DatImage07 = *
DatTile7:
        .byte  %00000000, %00000000, %00000000 // ........................ MC gold
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %11111111, %00000000, %00000000 // ########................
        .byte  %11101011, %00000000, %00000000 // ###.#.##................
        .byte  %11101011, %00000000, %00000000 // ###.#.##................
        .byte  %11101011, %00000000, %00000000 // ###.#.##................
        .byte  %11111111, %00000000, %00000000 // ########................
        .byte  %00000000, %00000000, %00000000 // ........................

.label DatImage08 = *
.label DatSprtMC_RuLe00 = *

DatTile8:
        .byte  %00000100, %00000000, %00000000 // .....#.................. MC blue enemy
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00010101, %00000000, %00000000 // ...#.#.#................
        .byte  %01000100, %01000000, %00000000 // .#...#...#..............
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00010101, %00000000, %00000000 // ...#.#.#................
        .byte  %00010101, %01000000, %00000000 // ...#.#.#.#..............
        .byte  %00010000, %00000000, %00000000 // ...#....................
        .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage09 = *
DatTile9:
        .byte  %00001100, %00000000, %00000000 // ....##..................  .hbu008. - MC white lode runner 
        .byte  %00001111, %00000000, %00000000 // ....####................
        .byte  %00001111, %00000000, %00000000 // ....####................
        .byte  %00001100, %00000000, %00000000 // ....##..................
        .byte  %00111111, %00000000, %00000000 // ..######................
        .byte  %11001100, %11000000, %00000000 // ##..##..##..............
        .byte  %00001100, %00000000, %00000000 // ....##..................
        .byte  %00111111, %00000000, %00000000 // ..######................
        .byte  %11111111, %00000000, %00000000 // ########................
        .byte  %00000011, %00000000, %00000000 // ......##................
        .byte  %00000011, %00000000, %00000000 // ......##................
// ------------------------------------------------------------------------------------------------------------------------------- //
.label DatImage0a = *
DatCursorBlank:
        .byte  %11111111, %11000000, %00000000 // ##########.............. big reverse cursor
        .byte  %11111111, %11000000, %00000000 // ##########..............
        .byte  %11111111, %11000000, %00000000 // ##########..............
        .byte  %11111111, %11000000, %00000000 // ##########..............
        .byte  %11111111, %11000000, %00000000 // ##########..............
        .byte  %11111111, %11000000, %00000000 // ##########..............
        .byte  %11111111, %11000000, %00000000 // ##########..............
        .byte  %11111111, %11000000, %00000000 // ##########..............
        .byte  %11111111, %11000000, %00000000 // ##########..............
        .byte  %11111111, %11000000, %00000000 // ##########..............
        .byte  %11111111, %11000000, %00000000 // ##########..............
// ------------------------------------------------------------------------------------------------------------------------------- //
.label DatImage0b = *
DatSprite_RuLe00:
        .byte  %00010000, %00000000, %00000000 // ...#.................... run    left 01
        .byte  %00111000, %00000000, %00000000 // ..###................... set to $00 in TabSpriteGame
        .byte  %00111000, %00000000, %00000000 // ..###...................
        .byte  %00011100, %00000000, %00000000 // ...###..................
        .byte  %00111011, %00000000, %00000000 // ..###.##................
        .byte  %11001101, %10000000, %00000000 // ##..##.##...............
        .byte  %00001100, %00000000, %00000000 // ....##..................
        .byte  %00011100, %00000000, %00000000 // ...###..................
        .byte  %00110111, %10000000, %00000000 // ..##.####...............
        .byte  %00110000, %00000000, %00000000 // ..##....................
        .byte  %00110000, %00000000, %00000000 // ..##....................

.label DatImage0c = *
DatSprite_RuLe01:
        .byte  %00010000, %00000000, %00000000 // ...#.................... run    left 02
        .byte  %00111000, %00000000, %00000000 // ..###................... set to $00 in TabSpriteGame
        .byte  %00111000, %00000000, %00000000 // ..###...................
        .byte  %00011000, %00000000, %00000000 // ...##...................
        .byte  %00011100, %00000000, %00000000 // ...###..................
        .byte  %00111110, %00000000, %00000000 // ..#####.................
        .byte  %11011110, %00000000, %00000000 // ##.####.................
        .byte  %00111000, %00000000, %00000000 // ..###...................
        .byte  %00111100, %00000000, %00000000 // ..####..................
        .byte  %00001110, %00000000, %00000000 // ....###.................
        .byte  %00001100, %00000000, %00000000 // ....##..................

.label DatImage0d = *
DatSprite_RuLe02:
        .byte  %00010000, %00000000, %00000000 // ...#.................... run    left 03
        .byte  %00111000, %00000000, %00000000 // ..###................... set to $00 in TabSpriteGame
        .byte  %00111000, %00000000, %00000000 // ..###...................
        .byte  %00011000, %00000000, %00000000 // ...##...................
        .byte  %01011110, %00000000, %00000000 // .#.####.................
        .byte  %01111011, %00000000, %00000000 // .####.##................
        .byte  %00011000, %00000000, %00000000 // ...##...................
        .byte  %00111100, %00000000, %00000000 // ..####..................
        .byte  %01100110, %00000000, %00000000 // .##..##.................
        .byte  %01100011, %00000000, %00000000 // .##...##................
        .byte  %00000011, %00000000, %00000000 // ......##................

.label DatImage0e = *
DatSprite_Ladr00:
        .byte  %00001100, %00000000, %00000000 // ....##.................. ladder up/down 01
        .byte  %00001100, %01000000, %00000000 // ....##...#.............. set to $00 in TabSpriteGame
        .byte  %00001111, %11000000, %00000000 // ....######..............
        .byte  %01001110, %00000000, %00000000 // .#..###.................
        .byte  %01111110, %00000000, %00000000 // .######.................
        .byte  %00001110, %00000000, %00000000 // ....###.................
        .byte  %00001110, %00000000, %00000000 // ....###.................
        .byte  %00011011, %00000000, %00000000 // ...##.##................
        .byte  %00011011, %10000000, %00000000 // ...##.###...............
        .byte  %00011000, %00000000, %00000000 // ...##...................
        .byte  %00111000, %00000000, %00000000 // ..###...................

.label DatImage0f  = *
DatSprite_FireLe:
        .byte  %00000010, %00000000, %00000000 // ......#................. fire   left
        .byte  %00000111, %00000000, %00000000 // .....###................ set to $00 in TabSpriteGame
        .byte  %00000111, %00000000, %00000000 // .....###................
        .byte  %00000011, %00000000, %00000000 // ......##................
        .byte  %00001111, %11000000, %00000000 // ....######..............
        .byte  %01011011, %01000000, %00000000 // .#.##.##.#..............
        .byte  %01000011, %00000000, %00000000 // .#....##................
        .byte  %00000111, %00000000, %00000000 // .....###................
        .byte  %00001101, %10000000, %00000000 // ....##.##...............
        .byte  %00001101, %10000000, %00000000 // ....##.##...............
        .byte  %00001101, %10000000, %00000000 // ....##.##...............

.label DatImage10 = *
DatSprite_RuRi00:
        .byte  %00000010, %00000000, %00000000 // ......#................. .hbu008. - run    right 01
        .byte  %00000111, %00000000, %00000000 // .....###................ set to $00 in TabSpriteGame
        .byte  %00000111, %00000000, %00000000 // .....###................
        .byte  %00001110, %00000000, %00000000 // ....###.................
        .byte  %00110111, %00000000, %00000000 // ..##.###................
        .byte  %01101100, %11000000, %00000000 // .##.##..##..............
        .byte  %00001100, %00000000, %00000000 // ....##..................
        .byte  %00001110, %00000000, %00000000 // ....###.................
        .byte  %01111011, %00000000, %00000000 // .####.##................
        .byte  %00000011, %00000000, %00000000 // ......##................
        .byte  %00000011, %00000000, %00000000 // ......##................

.label DatImage11 = *
DatSprite_RuRi01:
        .byte  %00000010, %00000000, %00000000 // ......#................. run    right 02
        .byte  %00000111, %00000000, %00000000 // .....###................ set to $00 in TabSpriteGame
        .byte  %00000111, %00000000, %00000000 // .....###................
        .byte  %00000110, %00000000, %00000000 // .....##.................
        .byte  %00001110, %00000000, %00000000 // ....###.................
        .byte  %00011111, %00000000, %00000000 // ...#####................
        .byte  %00011110, %11000000, %00000000 // ...####.##..............
        .byte  %00000111, %00000000, %00000000 // .....###................
        .byte  %00001111, %00000000, %00000000 // ....####................
        .byte  %00011100, %00000000, %00000000 // ...###..................
        .byte  %00001100, %00000000, %00000000 // ....##..................

.label DatImage12 = *
DatSprite_RuRi02:
        .byte  %00000010, %00000000, %00000000 // ......#................. run    right 03
        .byte  %00000111, %00000000, %00000000 // .....###................ set to $00 in TabSpriteGame
        .byte  %00000111, %00000000, %00000000 // .....###................
        .byte  %00000110, %00000000, %00000000 // .....##.................
        .byte  %00011110, %10000000, %00000000 // ...####.#...............
        .byte  %00110111, %10000000, %00000000 // ..##.####...............
        .byte  %00000110, %00000000, %00000000 // .....##.................
        .byte  %00001111, %00000000, %00000000 // ....####................
        .byte  %00011001, %10000000, %00000000 // ...##..##...............
        .byte  %00110001, %10000000, %00000000 // ..##...##...............
        .byte  %00110000, %00000000, %00000000 // ..##....................

.label DatImage13 = *
DatSprite_Ladr01:
        .byte  %00001100, %00000000, %00000000 // ....##.................. ladder up/down 02
        .byte  %10001100, %00000000, %00000000 // #...##.................. set to $00 in TabSpriteGame
        .byte  %11111100, %00000000, %00000000 // ######..................
        .byte  %00011100, %10000000, %00000000 // ...###..#...............
        .byte  %00011111, %10000000, %00000000 // ...######...............
        .byte  %00011100, %00000000, %00000000 // ...###..................
        .byte  %00011100, %00000000, %00000000 // ...###..................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
        .byte  %01110110, %00000000, %00000000 // .###.##.................
        .byte  %00000110, %00000000, %00000000 // .....##.................
        .byte  %00000111, %00000000, %00000000 // .....###................

.label DatImage14 = *
DatSprite_FallLe:
        .byte  %01100100, %11000000, %00000000 // .##..#..##.............. fall   left
        .byte  %01101110, %11000000, %00000000 // .##.###.##.............. set to $00 in TabSpriteGame
        .byte  %01101110, %11000000, %00000000 // .##.###.##..............
        .byte  %00111111, %10000000, %00000000 // ..#######...............
        .byte  %00000110, %00000000, %00000000 // .....##.................
        .byte  %00000110, %00000000, %00000000 // .....##.................
        .byte  %00011110, %00000000, %00000000 // ...####.................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
        .byte  %00000110, %00000000, %00000000 // .....##.................

.label DatImage15 = *
DatSprite_FallRi:
        .byte  %11001001, %10000000, %00000000 // ##..#..##............... fall   right
        .byte  %11011101, %10000000, %00000000 // ##.###.##............... set to $00 in TabSpriteGame
        .byte  %11011101, %10000000, %00000000 // ##.###.##...............
        .byte  %01111111, %00000000, %00000000 // .#######................
        .byte  %00011000, %00000000, %00000000 // ...##...................
        .byte  %00011000, %00000000, %00000000 // ...##...................
        .byte  %00011110, %00000000, %00000000 // ...####.................
        .byte  %00011011, %00000000, %00000000 // ...##.##................
        .byte  %00011011, %00000000, %00000000 // ...##.##................
        .byte  %00011011, %00000000, %00000000 // ...##.##................
        .byte  %00011000, %00000000, %00000000 // ...##...................

.label DatImage16 = *
DatSprite_PoRi00:
        .byte  %01100001, %10000000, %00000000 // .##....##............... pole   right 01
        .byte  %01100001, %10000000, %00000000 // .##....##............... set to $00 in TabSpriteGame
        .byte  %01101101, %10000000, %00000000 // .##.##.##...............
        .byte  %01101111, %00000000, %00000000 // .##.####................
        .byte  %00111100, %00000000, %00000000 // ..####..................
        .byte  %00011000, %00000000, %00000000 // ...##...................
        .byte  %00011000, %00000000, %00000000 // ...##...................
        .byte  %01111000, %00000000, %00000000 // .####...................
        .byte  %11011000, %00000000, %00000000 // ##.##...................
        .byte  %11011000, %00000000, %00000000 // ##.##...................
        .byte  %10110000, %00000000, %00000000 // #.##....................

.label DatImage17 = *
DatSprite_PoRi01:
        .byte  %00000110, %00000000, %00000000 // .....##................. pole   right 02
        .byte  %00000110, %00000000, %00000000 // .....##................. set to $00 in TabSpriteGame
        .byte  %00011110, %00000000, %00000000 // ...####.................
        .byte  %00011100, %00000000, %00000000 // ...###..................
        .byte  %01111000, %00000000, %00000000 // .####...................
        .byte  %11011000, %00000000, %00000000 // ##.##...................
        .byte  %00011000, %00000000, %00000000 // ...##...................
        .byte  %00111000, %00000000, %00000000 // ..###...................
        .byte  %01101100, %00000000, %00000000 // .##.##..................
        .byte  %01101100, %00000000, %00000000 // .##.##..................
        .byte  %01101100, %00000000, %00000000 // .##.##..................

.label DatImage18 = *
DatSprite_PoRi02:
        .byte  %00011000, %00000000, %00000000 // ...##................... pole   right 03
        .byte  %00011000, %00000000, %00000000 // ...##................... set to $00 in TabSpriteGame
        .byte  %00011110, %00000000, %00000000 // ...####.................
        .byte  %00001110, %11000000, %00000000 // ....###.##..............
        .byte  %00000111, %10000000, %00000000 // .....####...............
        .byte  %00000110, %00000000, %00000000 // .....##.................
        .byte  %00000110, %00000000, %00000000 // .....##.................
        .byte  %00001110, %00000000, %00000000 // ....###.................
        .byte  %00011011, %00000000, %00000000 // ...##.##................
        .byte  %00011011, %00000000, %00000000 // ...##.##................
        .byte  %00011011, %00000000, %00000000 // ...##.##................

.label DatImage19 = *
DatSprite_PoLe00:
        .byte  %01100001, %10000000, %00000000 // .##....##............... pole   left 01
        .byte  %01100001, %10000000, %00000000 // .##....##............... set to $00 in TabSpriteGame
        .byte  %01101101, %10000000, %00000000 // .##.##.##...............
        .byte  %00111101, %10000000, %00000000 // ..####.##...............
        .byte  %00001111, %00000000, %00000000 // ....####................
        .byte  %00000110, %00000000, %00000000 // .....##.................
        .byte  %00000110, %00000000, %00000000 // .....##.................
        .byte  %00000111, %10000000, %00000000 // .....####...............
        .byte  %00000110, %11000000, %00000000 // .....##.##..............
        .byte  %00000110, %11000000, %00000000 // .....##.##..............
        .byte  %00000011, %01000000, %00000000 // ......##.#..............

.label DatImage1a = *
DatSprite_PoLe01:
        .byte  %00011000, %00000000, %00000000 // ...##................... pole   left 02
        .byte  %00011000, %00000000, %00000000 // ...##................... set to $00 in TabSpriteGame
        .byte  %00011110, %00000000, %00000000 // ...####.................
        .byte  %00001110, %00000000, %00000000 // ....###.................
        .byte  %00000111, %10000000, %00000000 // .....####...............
        .byte  %00000110, %11000000, %00000000 // .....##.##..............
        .byte  %00000110, %00000000, %00000000 // .....##.................
        .byte  %00000111, %00000000, %00000000 // .....###................
        .byte  %00001101, %10000000, %00000000 // ....##.##...............
        .byte  %00001101, %10000000, %00000000 // ....##.##...............
        .byte  %00001101, %10000000, %00000000 // ....##.##...............

.label DatImage1b = *
DatSprite_PoLe02:
        .byte  %00000110, %00000000, %00000000 // .....##................. pole   left 03
        .byte  %00000110, %00000000, %00000000 // .....##................. set to $00 in TabSpriteGame
        .byte  %00011110, %00000000, %00000000 // ...####.................
        .byte  %11011100, %00000000, %00000000 // ##.###..................
        .byte  %01111000, %00000000, %00000000 // .####...................
        .byte  %00011000, %00000000, %00000000 // ...##...................
        .byte  %00011000, %00000000, %00000000 // ...##...................
        .byte  %00011100, %00000000, %00000000 // ...###..................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
// ------------------------------------------------------------------------------------------------------------------------------- //

.label DatImage1c = *
DatShootSpark00:
        .byte  %00000000, %00000000, %00000000 // ........................ shooting spark 01
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00001000, %00000000, %00000000 // ....#...................
        .byte  %00000010, %01000000, %00000000 // ......#..#..............
        .byte  %00100000, %01000000, %00000000 // ..#......#..............
        .byte  %00001001, %00000000, %00000000 // ....#..#.................
        .byte  %00000001, %00000000, %00000000 // .......#................

.label DatImage1d = *
DatShootSpark01:
        .byte  %00000000, %00000000, %00000000 // ........................ shooting spark 02
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00001000, %00000000, %00000000 // ....#...................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %10000000, %00000000 // ........#...............
        .byte  %10000000, %00000000, %00000000 // #.......................
        .byte  %00100000, %00000000, %00000000 // ..#.....................
        .byte  %00001010, %01000000, %00000000 // ....#.#..#..............
        .byte  %00100001, %01000000, %00000000 // ..#....#.#..............
        .byte  %00001001, %00000000, %00000000 // ....#..#................

.label DatImage1e = *
DatShootSpark02:
        .byte  %00001000, %00000000, %00000000 // ....#................... shooting spark 03
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %10001000, %00000000, %00000000 // #...#...................
        .byte  %00000000, %10000000, %00000000 // ........#...............
        .byte  %10000000, %00000000, %00000000 // #.......................
        .byte  %00100000, %00000000, %00000000 // ..#.....................
        .byte  %00000010, %00000000, %00000000 // ......#.................

.label DatImage1f = *
DatShootSpark03:
        .byte  %00000000, %00000000, %00000000 // ........................ shooting spark 04
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00001000, %00000000, %00000000 // ....#...................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %10000000, %00000000, %00000000 // #.......................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %10000000, %00000000 // ........#...............
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
// ------------------------------------------------------------------------------------------------------------------------------- //
.label DatImage20 = *
DatShootMeltGr00:
        .byte  %10100100, %10000000, %00000000 // #.#..#..#.............. shoot melt ground 01
        .byte  %10101000, %10000000, %00000000 // #.#.#...#...............
        .byte  %10101000, %10000000, %00000000 // #.#.#...#...............
        .byte  %10101000, %10000000, %00000000 // #.#.#...#...............
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %00000000, %00000000, %00000000 // ........................

.label DatImage21 = *
DatShootMeltGr01:
        .byte  %00000100, %00000000, %00000000 // .....#.................. shoot melt ground 02
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %10000000, %10000000, %00000000 // #.......#...............
        .byte  %10101000, %10000000, %00000000 // #.#.#...#...............
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %00000000, %00000000, %00000000 // ........................

.label DatImage22 = *
DatShootMeltGr02:
        .byte  %00000000, %00000000, %00000000 // ........................ shoot melt ground 03
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %10010100, %10000000, %00000000 // #..#.#..#...............
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %00000000, %00000000, %00000000 // ........................

.label DatImage23 = *
DatShootMeltGr03:
        .byte  %00000000, %00000000, %00000000 // ........................ shoot melt ground 04
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %00010101, %00000000, %00000000 // ...#.#.#................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %00000000, %00000000, %00000000 // ........................

.label DatImage24 = *
DatShootMeltGr04:
        .byte  %00000000, %00000000, %00000000 // ........................ shoot melt ground 05
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00000101, %00000000, %00000000 // .....#.#................
        .byte  %10010101, %00000000, %00000000 // #..#.#.#................
        .byte  %10000000, %00000000, %00000000 // #.......................
        .byte  %10001010, %10000000, %00000000 // #...#.#.#...............
        .byte  %00000000, %00000000, %00000000 // ........................

.label DatImage25 = *
DatShootMeltGr05:
        .byte  %00000000, %00000000, %00000000 // ........................ shoot melt ground 06
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %00010101, %00000000, %00000000 // ...#.#.#................
        .byte  %00000000, %00000000, %00000000 // ........................
// ------------------------------------------------------------------------------------------------------------------------------- //
.label DatImage26  = *
DatSprite_FireRi:
        .byte  %00001000, %00000000, %00000000 // ....#................... fire   right
        .byte  %00011100, %00000000, %00000000 // ...###.................. set to $00 in TabSpriteGame
        .byte  %00011100, %00000000, %00000000 // ...###..................
        .byte  %00011000, %00000000, %00000000 // ...##...................
        .byte  %01111110, %00000000, %00000000 // .######.................
        .byte  %01011011, %01000000, %00000000 // .#.##.##.#..............
        .byte  %00011000, %01000000, %00000000 // ...##....#..............
        .byte  %00011100, %00000000, %00000000 // ...###..................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
// ------------------------------------------------------------------------------------------------------------------------------- //
.label DatImage27 = *
DatShootMelt00:
        .byte  %00000000, %00000000, %00000000 // ........................ shoot projectile starts melting 01
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00001000, %00000000, %00000000 // ....#...................
        .byte  %00100010, %00000000, %00000000 // ..#...#.................
        .byte  %01001000, %00000000, %00000000 // .#..#...................
        .byte  %01010000, %10000000, %00000000 // .#.#....#...............
        .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage28 = *
DatShootMelt01:
        .byte  %00000000, %00000000, %00000000 // ........................ shoot projectile starts melting 02
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00001000, %00000000, %00000000 // ....#...................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %10000000, %00000000 // ........#...............
        .byte  %10100000, %00000000, %00000000 // #.#.....................
        .byte  %01000000, %00000000, %00000000 // .#......................
        .byte  %01001010, %00000000, %00000000 // .#..#.#.................
        .byte  %00010001, %00000000, %00000000 // ...#...#................
        .byte  %00010001, %00000000, %00000000 // ...#...#................
// ------------------------------------------------------------------------------------------------------------------------------- //
.label DatImage29 = *
DatSprtMC_RuRi00:
        .byte  %00000010, %00000000, %00000000 // ......#................. run    right 01
        .byte  %00000101, %00000000, %00000000 // .....#.#................ set to it's no in TabSpriteGame - to be replaced
        .byte  %00000101, %00000000, %00000000 // .....#.#................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00010101, %00000000, %00000000 // ...#.#.#................
        .byte  %01000100, %01000000, %00000000 // .#...#...#..............
        .byte  %00001100, %00000000, %00000000 // ....##..................
        .byte  %00001110, %00000000, %00000000 // ....###.................
        .byte  %01111011, %00000000, %00000000 // .####.##................
        .byte  %00000011, %00000000, %00000000 // ......##................
        .byte  %00000011, %00000000, %00000000 // ......##................
.label DatImage2a = *
DatSprtMC_RuRi01:
        .byte  %00000010, %00000000, %00000000 // ......#................. run    right 02
        .byte  %00000101, %00000000, %00000000 // .....#.#................ set to it's no in TabSpriteGame - to be replaced
        .byte  %00000101, %00000000, %00000000 // .....#.#................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %00010101, %00000000, %00000000 // ...#.#.#................
        .byte  %00000110, %01000000, %00000000 // .....##..#..............
        .byte  %00000111, %00000000, %00000000 // .....###................
        .byte  %00001111, %00000000, %00000000 // ....####................
        .byte  %00011100, %00000000, %00000000 // ...###..................
        .byte  %00001100, %00000000, %00000000 // ....##..................

.label DatImage2b = *
DatSprtMC_RuRi02:
        .byte  %00000010, %00000000, %00000000 // ......#................. run    right 03
        .byte  %00000101, %00000000, %00000000 // .....#.#................ set to it's no in TabSpriteGame - to be replaced
        .byte  %00000101, %00000000, %00000000 // .....#.#................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00010101, %00000000, %00000000 // ...#.#.#................
        .byte  %01000101, %00000000, %00000000 // .#...#.#................
        .byte  %00000110, %00000000, %00000000 // .....##.................
        .byte  %00001111, %00000000, %00000000 // ....####................
        .byte  %00011001, %10000000, %00000000 // ...##..##...............
        .byte  %00110001, %10000000, %00000000 // ..##...##...............
        .byte  %00110000, %00000000, %00000000 // ..##....................

.label DatImage2c = *
DatSprtMC_RuLe01:
        .byte  %00001000, %00000000, %00000000 // ....#................... run    left 02
        .byte  %00010100, %00000000, %00000000 // ...#.#.................. set to it's no in TabSpriteGame - to be replaced
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00000101, %00000000, %00000000 // .....#.#................
        .byte  %00010101, %00000000, %00000000 // ...#.#.#................
        .byte  %01001100, %00000000, %00000000 // .#..##..................
        .byte  %00011100, %00000000, %00000000 // ...###..................
        .byte  %00011110, %00000000, %00000000 // ...####.................
        .byte  %00000111, %00000000, %00000000 // .....###................
        .byte  %00000110, %00000000, %00000000 // .....##.................

.label DatImage2d = *
DatSprtMC_RuLe02:
        .byte  %00001000, %00000000, %00000000 // ....#................... run    left 03
        .byte  %00010100, %00000000, %00000000 // ...#.#.................. set to it's no in TabSpriteGame - to be replaced
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00010101, %00000000, %00000000 // ...#.#.#................
        .byte  %00010100, %01000000, %00000000 // ..#.#...#...............
        .byte  %00001100, %00000000, %00000000 // ....##..................
        .byte  %00011110, %00000000, %00000000 // ...####.................
        .byte  %00110011, %00000000, %00000000 // ..##..##................
        .byte  %00110001, %10000000, %00000000 // ..##...##...............
        .byte  %00000001, %10000000, %00000000 // .......##...............

.label DatImage2e = *
DatSprtMC_PoRi00:
        .byte  %01000001, %00000000, %00000000 // .#.....#................ pole   right 01
        .byte  %01000001, %00000000, %00000000 // .#.....#................ set to it's no in TabSpriteGame - to be replaced
        .byte  %01000101, %00000000, %00000000 // .#...#.#................
        .byte  %01000101, %00000000, %00000000 // .#...#.#................
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %00011000, %00000000, %00000000 // ...##...................
        .byte  %00010000, %00000000, %00000000 // ...#....................
        .byte  %01111000, %00000000, %00000000 // .####...................
        .byte  %11011000, %00000000, %00000000 // ##.##...................
        .byte  %11011000, %00000000, %00000000 // ##.##...................
        .byte  %10110000, %00000000, %00000000 // #.##....................

.label DatImage2f = *
DatSprtMC_PoRi01:
        .byte  %00000100, %00000000, %00000000 // .....#.................. pole   right 02
        .byte  %00000100, %00000000, %00000000 // .....#.................. set to it's no in TabSpriteGame - to be replaced
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %01010000, %00000000, %00000000 // .#.#....................
        .byte  %01010000, %00000000, %00000000 // .#.#....................
        .byte  %00010000, %00000000, %00000000 // ...#....................
        .byte  %00111000, %00000000, %00000000 // ..###...................
        .byte  %01101100, %00000000, %00000000 // .##.##..................
        .byte  %01101100, %00000000, %00000000 // .##.##..................
        .byte  %01101100, %00000000, %00000000 // .##.##..................

.label DatImage30 = *
DatSprtMC_PoRi02:
        .byte  %00010000, %00000000, %00000000 // ...#.................... pole   right 03
        .byte  %00010000, %00000000, %00000000 // ...#.................... set to it's no in TabSpriteGame - to be replaced
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %00000100, %01000000, %00000000 // .....#...#..............
        .byte  %00000101, %00000000, %00000000 // .....#.#................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00001110, %00000000, %00000000 // ....###.................
        .byte  %00011011, %00000000, %00000000 // ...##.##................
        .byte  %00011011, %00000000, %00000000 // ...##.##................
        .byte  %00011011, %00000000, %00000000 // ...##.##................

.label DatImage31 = *
DatSprtMC_PoLe00:
        .byte  %01000001, %00000000, %00000000 // .#.....#................ pole   left 01
        .byte  %01000001, %00000000, %00000000 // .#.....#................ set to it's no in TabSpriteGame - to be replaced
        .byte  %01010001, %00000000, %00000000 // .#.#...#................
        .byte  %01010001, %00000000, %00000000 // .#.#...#................
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00001111, %00000000, %00000000 // ....####................
        .byte  %00001101, %10000000, %00000000 // ....##.##..............
        .byte  %00001101, %10000000, %00000000 // ....##.##..............
        .byte  %00000110, %10000000, %00000000 // .....##..#..............

.label DatImage32 = *
DatSprtMC_PoLe01:
        .byte  %00010000, %00000000, %00000000 // ...#.................... pole   left 02
        .byte  %00010000, %00000000, %00000000 // ...#.................... set to it's no in TabSpriteGame - to be replaced
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %00000101, %00000000, %00000000 // .....#.#................
        .byte  %00000101, %00000000, %00000000 // .....#.#................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00000111, %00000000, %00000000 // .....###................
        .byte  %00001101, %10000000, %00000000 // ....##.##...............
        .byte  %00001101, %10000000, %00000000 // ....##.##...............
        .byte  %00001101, %10000000, %00000000 // ....##.##...............

.label DatImage33 = *
DatSprtMC_PoLe02:
        .byte  %00000100, %00000000, %00000000 // .....#.................. pole   left 03
        .byte  %00000100, %00000000, %00000000 // .....#.................. set to it's no in TabSpriteGame - to be replaced
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %00010000, %00000000, %00000000 // ...#....................
        .byte  %01010000, %00000000, %00000000 // .#.#....................
        .byte  %00010000, %00000000, %00000000 // ...#....................
        .byte  %00010000, %00000000, %00000000 // ...#....................
        .byte  %00011100, %00000000, %00000000 // ...###..................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................

.label DatImage34 = *
DatSprtMC_Ladr00:
        .byte  %00000100, %00000000, %00000000 // .....#.................. ladder up/down 01
        .byte  %00000100, %01000000, %00000000 // .....#...#.............. set to it's no in TabSpriteGame - to be replaced
        .byte  %00000101, %01000000, %00000000 // .....#.#.#..............
        .byte  %01000100, %00000000, %00000000 // .#...#..................
        .byte  %01010100, %00000000, %00000000 // .#.#.#..................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00001110, %00000000, %00000000 // ....###.................
        .byte  %00011011, %00000000, %00000000 // ...##.##................
        .byte  %00011011, %10000000, %00000000 // ...##.###...............
        .byte  %00011000, %00000000, %00000000 // ...##...................
        .byte  %00111000, %00000000, %00000000 // ..###...................

.label DatImage35 = *
DatSprtMC_Ladr01:
        .byte  %00000100, %00000000, %00000000 // .....#.................. ladder up/down 02
        .byte  %10000100, %00000000, %00000000 // #....#.................. set to it's no in TabSpriteGame - to be replaced
        .byte  %11010100, %00000000, %00000000 // ##.#.#..................
        .byte  %00010100, %10000000, %00000000 // ...#.#..#...............
        .byte  %00010101, %10000000, %00000000 // ...#.#.##...............
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %00011100, %00000000, %00000000 // ...###..................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
        .byte  %01110110, %00000000, %00000000 // .###.##.................
        .byte  %00000110, %00000000, %00000000 // .....##.................
        .byte  %00000111, %00000000, %00000000 // .....###................

.label DatImage36 = *
DatSprtMC_FallRi:
        .byte  %01000100, %01000000, %00000000 // .#...#...#.............. fall   right
        .byte  %01000100, %01000000, %00000000 // .#...#...#.............. set to it's no in TabSpriteGame - to be replaced
        .byte  %01000100, %01000000, %00000000 // .#...#...#..............
        .byte  %00010101, %00000000, %00000000 // ...#.#.#...............
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00001111, %00000000, %00000000 // ...####.................
        .byte  %00001101, %10000000, %00000000 // ...##.##................
        .byte  %00001101, %10000000, %00000000 // ...##.##................
        .byte  %00001101, %10000000, %00000000 // ...##.##................
        .byte  %00001100, %00000000, %00000000 // ...##...................

.label DatImage37 = *
DatSprtMC_FallLe:
        .byte  %01000100, %10000000, %00000000 // .#...#...#.............. fall   left
        .byte  %01000100, %10000000, %00000000 // .#...#...#.............. set to it's no in TabSpriteGame - to be replaced
        .byte  %01000100, %10000000, %00000000 // .#...#...#..............
        .byte  %00010101, %00000000, %00000000 // ...#.#.#................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00000100, %00000000, %00000000 // .....#..................
        .byte  %00011110, %00000000, %00000000 // ...####.................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
        .byte  %00110110, %00000000, %00000000 // ..##.##.................
        .byte  %00000110, %00000000, %00000000 // .....##.................
// ------------------------------------------------------------------------------------------------------------------------------- //
// Separation number used in TabSpriteGame of SetSpritePos
// ------------------------------------------------------------------------------------------------------------------------------- //
.label DatSpritesX = *
// ------------------------------------------------------------------------------------------------------------------------------- //
.label DatImage38 = *
DatCloseHole00:
        .byte  %00000000, %00000000, %00000000 // ........................ MC close holes 1st step
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %10000000, %10000000, %00000000 // #.......#...............
        .byte  %10000000, %10000000, %00000000 // #.......#...............
        .byte  %00000000, %00000000, %00000000 // ........................

.label DatImage39 = *
DatCloseHole01:
        .byte  %00000000, %00000000, %00000000 // ........................ MC close holes 2nd step
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %10000000, %10000000, %00000000 // #.......#...............
        .byte  %10000000, %10000000, %00000000 // #.......#...............
        .byte  %10000000, %10000000, %00000000 // #.......#...............
        .byte  %10000000, %10000000, %00000000 // #.......#...............
        .byte  %00000000, %00000000, %00000000 // ........................
// ------------------------------------------------------------------------------------------------------------------------------- //
.label DatImage3a = *
DatReviveEnemyO0:
        .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth 1st step - old
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
        .byte  %00000000, %00000000, %00000000 // ........................

.label DatImage3b = *
DatReviveEnemyO1:
        .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth 2nd step - old
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00000000, %00000000, %00000000 // ........................
        .byte  %00010100, %00000000, %00000000 // ...#.#..................
        .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
        .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
        .byte  %00000000, %00000000, %00000000 // ........................
// ------------------------------------------------------------------------------------------------------------------------------- //
.label DatImage3c = *
DatDig0:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
                  .byte  %01000001, %00000000, %00000000 // .#.....#................
                  .byte  %01000001, %00000000, %00000000 // .#.....#................
                  .byte  %01000001, %00000000, %00000000 // .#.....#................
                  .byte  %01000101, %00000000, %00000000 // .#...#.#................
                  .byte  %01000101, %00000000, %00000000 // .#...#.#................
                  .byte  %01000101, %00000000, %00000000 // .#...#.#................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
.label DatImage3d = *
DatDig1:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00010100, %00000000, %00000000 // ...#.#..................
                  .byte  %00010100, %00000000, %00000000 // ...#.#..................
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
.label DatImage3e = *
DatDig2:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
                  .byte  %01000001, %00000000, %00000000 // .#.....#................
                  .byte  %00000001, %00000000, %00000000 // .......#................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
                  .byte  %01000000, %00000000, %00000000 // .#......................
                  .byte  %01000000, %00000000, %00000000 // .#......................
                  .byte  %01000101, %00000000, %00000000 // .#...#.#................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
.label DatImage3f = *
DatDig3:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
                  .byte  %01000001, %00000000, %00000000 // .#.....#................
                  .byte  %00000001, %00000000, %00000000 // .......#................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00000001, %00000000, %00000000 // .......#................
                  .byte  %00000001, %00000000, %00000000 // .......#................
                  .byte  %01000001, %00000000, %00000000 // .#.....#................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
.label DatImage40 = *
DatDig4:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %01010001, %00000000, %00000000 // .#.#...#................
                  .byte  %01010001, %00000000, %00000000 // .#.#...#................
                  .byte  %01010001, %00000000, %00000000 // .#.#...#................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
                  .byte  %00000001, %00000000, %00000000 // .......#................
                  .byte  %00000001, %00000000, %00000000 // .......#................
                  .byte  %00000001, %00000000, %00000000 // .......#................
                  .byte  %00000001, %00000000, %00000000 // .......#................
.label DatImage41 = *
DatDig5:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
                  .byte  %01000000, %00000000, %00000000 // .#......................
                  .byte  %01000000, %00000000, %00000000 // .#......................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
                  .byte  %00000101, %00000000, %00000000 // .....#.#................
                  .byte  %00000101, %00000000, %00000000 // .....#.#................
                  .byte  %00000101, %00000000, %00000000 // .....#.#................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
.label DatImage42 = *
DatDig6:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
                  .byte  %01000001, %00000000, %00000000 // .#.....#................
                  .byte  %01000000, %00000000, %00000000 // .#......................
                  .byte  %01000000, %00000000, %00000000 // .#......................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
                  .byte  %01000101, %00000000, %00000000 // .#...#.#................
                  .byte  %01000101, %00000000, %00000000 // .#...#.#................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
.label DatImage43 = *
DatDig7:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
                  .byte  %00000101, %00000000, %00000000 // .....#.#................
                  .byte  %00000101, %00000000, %00000000 // .....#.#................
                  .byte  %00000101, %00000000, %00000000 // .....#.#................
                  .byte  %00010100, %00000000, %00000000 // ...#.#..................
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................
.label DatImage44 = *
DatDig8:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00010001, %00000000, %00000000 // ...#...#................
                  .byte  %00010001, %00000000, %00000000 // ...#...#................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
                  .byte  %01000001, %00000000, %00000000 // .#.....#................
                  .byte  %01000001, %00000000, %00000000 // .#.....#................
                  .byte  %01000001, %00000000, %00000000 // .#.....#................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
.label DatImage45 = *
DatDig9:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
                  .byte  %01000001, %00000000, %00000000 // .#.....#................
                  .byte  %01000001, %00000000, %00000000 // .#.....#................
                  .byte  %01010101, %00000000, %00000000 // .#.#.#.#................
                  .byte  %00000101, %00000000, %00000000 // .....#.#................
                  .byte  %00000101, %00000000, %00000000 // .....#.#................
                  .byte  %00000101, %00000000, %00000000 // .....#.#................
                  .byte  %00000101, %00000000, %00000000 // .....#.#................
// ------------------------------------------------------------------------------------------------------------------------------- //
.label DatImage46 = *
DatChrA:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00101010, %00000000, %00000000 // ..#.#.#.................
                  .byte  %00100010, %00000000, %00000000 // ..#...#.................
                  .byte  %00100010, %00000000, %00000000 // ..#...#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
.label DatImage47 = *
DatChrB:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101000, %00000000, %00000000 // #.#.#...................
                  .byte  %10001000, %00000000, %00000000 // #...#...................
                  .byte  %10001000, %00000000, %00000000 // #...#...................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
.label DatImage48 = *
DatChrC:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
.label DatImage49 = *
DatChrD:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101000, %00000000, %00000000 // #.#.#...................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10101000, %00000000, %00000000 // #.#.#...................
.label DatImage4a = *
DatChrE:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10101000, %00000000, %00000000 // #.#.#...................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
.label DatImage4b = *
DatChrF:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10101000, %00000000, %00000000 // #.#.#...................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10000000, %00000000, %00000000 // #.......................
.label DatImage4c = *
DatChrG:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
.label DatImage4d = *
DatChrH:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
.label DatImage4e = *
DatChrI:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00100000, %00000000, %00000000 // ..#.....................
                  .byte  %00100000, %00000000, %00000000 // ..#.....................
                  .byte  %00100000, %00000000, %00000000 // ..#.....................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
.label DatImage4f = *
DatChrJ:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00001000, %00000000, %00000000 // ....#...................
                  .byte  %00001000, %00000000, %00000000 // ....#...................
                  .byte  %00001000, %00000000, %00000000 // ....#...................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
.label DatImage50 = *
DatChrK:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10001000, %00000000, %00000000 // #...#...................
                  .byte  %10101000, %00000000, %00000000 // #.#.#...................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
.label DatImage51 = *
DatChrL:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
.label DatImage52 = *
DatChrM:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
.label DatImage53 = *
DatChrN:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
.label DatImage54 = *
DatChrO:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
.label DatImage55 = *
DatChrP:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
.label DatImage56 = *
DatChrQ:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10001000, %00000000, %00000000 // #...#...................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
.label DatImage57 = *
DatChrR:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10101000, %00000000, %00000000 // #.#.#...................
                  .byte  %10101000, %00000000, %00000000 // #.#.#...................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
.label DatImage58 = *
DatChrS:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
.label DatImage59 = *
DatChrT:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %00100000, %00000000, %00000000 // ..#.....................
                  .byte  %00100000, %00000000, %00000000 // ..#.....................
                  .byte  %00100000, %00000000, %00000000 // ..#.....................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
.label DatImage5a = *
DatChrU:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
.label DatImage5b = *
DatChrV:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00100000, %00000000, %00000000 // ..#.....................
.label DatImage5c = *
DatChrW:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
.label DatImage5d = *
DatChrX:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
.label DatImage5e = *
DatChrY:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
.label DatImage5f = *
DatChrZ:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %00001000, %00000000, %00000000 // ....#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
// ------------------------------------------------------------------------------------------------------------------------------- //
.label DatImage60 = *
DatSpcBrRi:
                  .byte  %00000000, %00000000, %00000000 // ........................ right bracket
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10000000, %00000000, %00000000 // #.......................
.label DatImage61 = *
DatSpcDot:
                  .byte  %00000000, %00000000, %00000000 // ........................ period
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
.label DatImage62 = *
DatSpcPaLe:
                   .byte  %00000000, %00000000, %00000000 // ........................ left parenthesis
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
.label DatImage63 = *
DatSpcPaRi:
                  .byte  %00000000, %00000000, %00000000 // ........................ right parenthesis
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
.label DatImage64 = *
DatSpcSlash:
                  .byte  %00000000, %00000000, %00000000 // ........................ slash
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000010, %00000000, %00000000 // ......#.................
                  .byte  %00000010, %00000000, %00000000 // ......#.................
                  .byte  %00001000, %00000000, %00000000 // ....#...................
                  .byte  %00001000, %00000000, %00000000 // ....#...................
                  .byte  %00100000, %00000000, %00000000 // ..#.....................
                  .byte  %00100000, %00000000, %00000000 // ..#.....................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10000000, %00000000, %00000000 // #.......................
.label DatImage65 = *
DatSpcHyp:
                    .byte  %00000000, %00000000, %00000000 // ........................ hyphen
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
                  .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
                  .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
                  .byte  %10101010, %10000000, %00000000 // #.#.#.#.#...............
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
.label DatImage66 = *
DatSpcBrRLe:
                  .byte  %00000000, %00000000, %00000000 // ........................ left bracket
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000010, %00000000, %00000000 // ......#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %10100000, %00000000, %00000000 // #.#.....................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00000010, %00000000, %00000000 // ......#.................
.label DatImage67 = *
DatSpcColon:
                  .byte  %00000000, %00000000, %00000000 // ........................ .hbu013. - colon
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
// ------------------------------------------------------------------------------------------------------------------------------- //
.label DatImage68 = *
DatChr0:
                  .byte  %00000000, %00000000, %00000000 // ........................ .hbu015. - character digits
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
.label DatImage69 = *
DatChr1:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00001000, %00000000, %00000000 // ....#...................
                  .byte  %00001000, %00000000, %00000000 // ....#...................
                  .byte  %00001000, %00000000, %00000000 // ....#...................
                  .byte  %00001000, %00000000, %00000000 // ....#...................
                  .byte  %00101010, %00000000, %00000000 // ..#.#.#.................
                  .byte  %00101010, %00000000, %00000000 // ..#.#.#.................
.label DatImage6a = *
DatChr2:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %00000010, %00000000, %00000000 // ......#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
.label DatImage6b = *
DatChr3:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %00000010, %00000000, %00000000 // ......#.................
                  .byte  %00101010, %00000000, %00000000 // ..#.#.#.................
                  .byte  %00000010, %00000000, %00000000 // ......#.................
                  .byte  %00000010, %00000000, %00000000 // ......#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
.label DatImage6c = *
DatChr4:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10100010, %00000000, %00000000 // #.#...#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %00000010, %00000000, %00000000 // ......#.................
                  .byte  %00000010, %00000000, %00000000 // ......#.................
                  .byte  %00000010, %00000000, %00000000 // ......#.................
                  .byte  %00000010, %00000000, %00000000 // ......#.................
.label DatImage6d = *
DatChr5:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
.label DatImage6e = *
DatChr6:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10000000, %00000000, %00000000 // #.......................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10001010, %00000000, %00000000 // #...#.#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
.label DatImage6f = *
DatChr7:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00101000, %00000000, %00000000 // ..#.#...................
                  .byte  %00100000, %00000000, %00000000 // ..#.....................
                  .byte  %00100000, %00000000, %00000000 // ..#.....................
                  .byte  %00100000, %00000000, %00000000 // ..#.....................
.label DatImage70 = *
DatChr8:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00101010, %00000000, %00000000 // ..#.#.#.................
                  .byte  %00100010, %00000000, %00000000 // ..#...#.................
                  .byte  %00100010, %00000000, %00000000 // ..#...#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
.label DatImage71 = *
DatChr9:
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10000010, %00000000, %00000000 // #.....#.................
                  .byte  %10101010, %00000000, %00000000 // #.#.#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................
                  .byte  %00001010, %00000000, %00000000 // ....#.#.................

.label DatImage72 = *
DatReviveEnemy01:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 01
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage73 = *
DatReviveEnemy02:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 02
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage74 = *
DatReviveEnemy03:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 03
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage75 = *
DatReviveEnemy04:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 04
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00010100, %00000000, %00000000 // ...#.#..................
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage76 = *
DatReviveEnemy05:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 05
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage77 = *
DatReviveEnemy06:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 06
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00010101, %01000000, %00000000 // ...#.#.#.#..............
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................
.label DatImage78 = *
DatReviveEnemy07:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 07
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000001, %00000000, %00000000 // .......#................
                  .byte  %00010101, %01000000, %00000000 // ...#.#.#.#..............
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage79 = *
DatReviveEnemy08:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 08
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000101, %00000000, %00000000 // .....#.#................
                  .byte  %00010101, %01000000, %00000000 // ...#.#.#.#..............
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage7a = *
DatReviveEnemy09:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 09
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00010101, %01000000, %00000000 // ...#.#.#.#..............
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage7b = *
DatReviveEnemy0a:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 0a
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00010101, %01000000, %00000000 // ...#.#.#.#..............
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage7c = *
DatReviveEnemy0b:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 0b
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00010101, %01000000, %00000000 // ...#.#.#.#..............
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage7d = *
DatReviveEnemy0c:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 0c
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00010101, %01000000, %00000000 // ...#.#.#.#..............
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage7e = *
DatReviveEnemy0d:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 0d
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000100, %00000000, %00000000 // ........................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00000100, %01000000, %00000000 // .....#...#..............
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00010101, %01000000, %00000000 // ...#.#.#.#..............
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage7f = *
DatReviveEnemy0e:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 0e
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %01000100, %01000000, %00000000 // .#...#...#..............
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00010101, %01000000, %00000000 // ...#.#.#.#..............
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage80 = *
DatReviveEnemy0f:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 0f
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %01000100, %01000000, %00000000 // .#...#...#..............
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00010101, %01000000, %00000000 // ...#.#.#.#..............
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage81 = *
DatReviveEnemy10:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 10
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %01000100, %01000000, %00000000 // .#...#...#..............
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00010101, %01000000, %00000000 // ...#.#.#.#..............
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage82 = *
DatReviveEnemy11:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 11
                  .byte  %00000000, %00000000, %00000000 // ........................
                  .byte  %00010100, %00000000, %00000000 // ...#.#..................
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %01000100, %01000000, %00000000 // .#...#...#..............
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00010101, %01000000, %00000000 // ...#.#.#.#..............
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage83 = *
DatReviveEnemy12:
                  .byte  %00000000, %00000000, %00000000 // ........................ MC rebirth step 12
                  .byte  %00010100, %00000000, %00000000 // ...#.#..................
                  .byte  %00010100, %00000000, %00000000 // ...#.#..................
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %01000100, %01000000, %00000000 // .#...#...#..............
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00010101, %01000000, %00000000 // ...#.#.#.#..............
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................

.label DatImage84 = *
DatReviveEnemy13:
                  .byte  %00000100, %00000000, %00000000 // .....#.................. MC rebirth step 13
                  .byte  %00010100, %00000000, %00000000 // ...#.#..................
                  .byte  %00010100, %00000000, %00000000 // ...#.#..................
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %01000100, %01000000, %00000000 // .#...#...#..............
                  .byte  %00000100, %00000000, %00000000 // .....#..................
                  .byte  %00010101, %00000000, %00000000 // ...#.#.#................
                  .byte  %00010101, %01000000, %00000000 // ...#.#.#.#..............
                  .byte  %00010000, %00000000, %00000000 // ...#....................
                  .byte  %00010000, %00000000, %00000000 // ...#....................
// ------------------------------------------------------------------------------------------------------------- //
.label DatImagesX = *                               // .hbu008. - end address for number calculations
// ------------------------------------------------------------------------------------------------------------- //
.label DatImageLen  =  [DatTile1 - DatTile0]                             // length  image data
.label NoImages     =  [DatImagesX - DatImages] / DatImageLen     // overall image numbers for GetChrSubst
.label NoSprites    =  [DatSpritesX - DatImages] / DatImageLen + 1 // sprite  image numbers for SetSpritePos
// ------------------------------------------------------------------------------------------------------------- //
.label NoTileBlank       =  [DatTile0 - DatImages] / DatImageLen // level tiles
.label NoTileWallWeak    =  [DatTile1 - DatImages] / DatImageLen
.label NoTileWallHard    =  [DatTile2 - DatImages] / DatImageLen
.label NoTileLadder      =  [DatTile3 - DatImages] / DatImageLen
.label NoTilePole        =  [DatTile4 - DatImages] / DatImageLen
.label NoTileWallTrap    =  [DatTile5 - DatImages] / DatImageLen
.label NoTileLadderSec   =  [DatTile6 - DatImages] / DatImageLen
.label NoTileGold        =  [DatTile7 - DatImages] / DatImageLen
.label NoTileEnemy       =  [DatTile8 - DatImages] / DatImageLen
.label NoTileLodeRunner  =  [DatTile9 - DatImages] / DatImageLen
//
.label NoTileNumMin      =  NoTileBlank
.label NoTileNumMax      =  NoTileLodeRunner
// ------------------------------------------------------------------------------------------------------------- //
.label NoCursorBlank     =  [DatCursorBlank - DatImages] / DatImageLen // input blank cursor
// ------------------------------------------------------------------------------------------------------------- //
.label NoSprite_RuLe00   =  [DatSprite_RuLe00  - DatImages] / DatImageLen // sprite images
.label NoSprite_RuLe01   =  [DatSprite_RuLe01  - DatImages] / DatImageLen
.label NoSprite_RuLe02   =  [DatSprite_RuLe02  - DatImages] / DatImageLen
.label NoSprite_Ladr00   =  [DatSprite_Ladr00  - DatImages] / DatImageLen
.label NoSprite_FireLe   =  [DatSprite_FireLe  - DatImages] / DatImageLen
.label NoSprite_RuRi00   =  [DatSprite_RuRi00  - DatImages] / DatImageLen
.label NoSprite_RuRi01   =  [DatSprite_RuRi01  - DatImages] / DatImageLen
.label NoSprite_RuRi02   =  [DatSprite_RuRi02  - DatImages] / DatImageLen
.label NoSprite_Ladr01   =  [DatSprite_Ladr01  - DatImages] / DatImageLen
.label NoSprite_FallLe   =  [DatSprite_FallLe  - DatImages] / DatImageLen
.label NoSprite_FallRi   =  [DatSprite_FallRi  - DatImages] / DatImageLen
.label NoSprite_PoRi00   =  [DatSprite_PoRi00  - DatImages] / DatImageLen
.label NoSprite_PoRi01   =  [DatSprite_PoRi01  - DatImages] / DatImageLen
.label NoSprite_PoRi02   =  [DatSprite_PoRi02  - DatImages] / DatImageLen
.label NoSprite_PoLe00   =  [DatSprite_PoLe00  - DatImages] / DatImageLen
.label NoSprite_PoLe01   =  [DatSprite_PoLe01  - DatImages] / DatImageLen
.label NoSprite_PoLe02   =  [DatSprite_PoLe02  - DatImages] / DatImageLen
// ------------------------------------------------------------------------------------------------------------- //
.label NoShootSpark00    =  [DatShootSpark00   - DatImages] / DatImageLen // lode runner shootings
.label NoShootSpark01    =  [DatShootSpark01   - DatImages] / DatImageLen
.label NoShootSpark02    =  [DatShootSpark02   - DatImages] / DatImageLen
.label NoShootSpark03    =  [DatShootSpark03   - DatImages] / DatImageLen
.label NoShootMeltGr00   =  [DatShootMeltGr00  - DatImages] / DatImageLen
.label NoShootMeltGr01   =  [DatShootMeltGr01  - DatImages] / DatImageLen
.label NoShootMeltGr02   =  [DatShootMeltGr02  - DatImages] / DatImageLen
.label NoShootMeltGr03   =  [DatShootMeltGr03  - DatImages] / DatImageLen
.label NoShootMeltGr04   =  [DatShootMeltGr04  - DatImages] / DatImageLen
.label NoShootMeltGr05   =  [DatShootMeltGr05  - DatImages] / DatImageLen
.label NoSprite_FireRi   =  [DatSprite_FireRi  - DatImages] / DatImageLen
.label NoShootMelt00     =  [DatShootMelt00    - DatImages] / DatImageLen
.label NoShootMelt01     =  [DatShootMelt01    - DatImages] / DatImageLen
// ------------------------------------------------------------------------------------------------------------- //
.label NoSprtMC_RuRi00   =  [DatSprtMC_RuRi00  - DatImages] / DatImageLen // multi color sprite images
.label NoSprtMC_RuRi01   =  [DatSprtMC_RuRi01  - DatImages] / DatImageLen
.label NoSprtMC_RuRi02   =  [DatSprtMC_RuRi02  - DatImages] / DatImageLen
.label NoSprtMC_RuLe00   =  [DatSprtMC_RuLe00  - DatImages] / DatImageLen
.label NoSprtMC_RuLe01   =  [DatSprtMC_RuLe01  - DatImages] / DatImageLen
.label NoSprtMC_RuLe02   =  [DatSprtMC_RuLe02  - DatImages] / DatImageLen
.label NoSprtMC_PoRi00   =  [DatSprtMC_PoRi00  - DatImages] / DatImageLen
.label NoSprtMC_PoRi01   =  [DatSprtMC_PoRi01  - DatImages] / DatImageLen
.label NoSprtMC_PoRi02   =  [DatSprtMC_PoRi02  - DatImages] / DatImageLen
.label NoSprtMC_PoLe00   =  [DatSprtMC_PoLe00  - DatImages] / DatImageLen
.label NoSprtMC_PoLe01   =  [DatSprtMC_PoLe01  - DatImages] / DatImageLen
.label NoSprtMC_PoLe02   =  [DatSprtMC_PoLe02  - DatImages] / DatImageLen
.label NoSprtMC_Ladr00   =  [DatSprtMC_Ladr00  - DatImages] / DatImageLen
.label NoSprtMC_Ladr01   =  [DatSprtMC_Ladr01  - DatImages] / DatImageLen
.label NoSprtMC_FallRi   =  [DatSprtMC_FallRi  - DatImages] / DatImageLen
.label NoSprtMC_FallLe   =  [DatSprtMC_FallLe  - DatImages] / DatImageLen
// ------------------------------------------------------------------------------------------------------------- //
.label NoCloseHole00     =  [DatCloseHole00    - DatImages] / DatImageLen // wall closing steps
.label NoCloseHole01     =  [DatCloseHole01    - DatImages] / DatImageLen
// ------------------------------------------------------------------------------------------------------------- //
//.label NoReviveEnemyO0   =  [DatReviveEnemy00  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemyO1   =  [DatReviveEnemy01  - DatImages] / DatImageLen

.label NoReviveEnemy01   =  [DatReviveEnemy01  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy02   =  [DatReviveEnemy02  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy03   =  [DatReviveEnemy03  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy04   =  [DatReviveEnemy04  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy05   =  [DatReviveEnemy05  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy06   =  [DatReviveEnemy06  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy07   =  [DatReviveEnemy07  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy08   =  [DatReviveEnemy08  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy09   =  [DatReviveEnemy09  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy0a   =  [DatReviveEnemy0a  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy0b   =  [DatReviveEnemy0b  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy0c   =  [DatReviveEnemy0c  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy0d   =  [DatReviveEnemy0d  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy0e   =  [DatReviveEnemy0e  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy0f   =  [DatReviveEnemy0f  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy10   =  [DatReviveEnemy10  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy11   =  [DatReviveEnemy11  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy12   =  [DatReviveEnemy12  - DatImages] / DatImageLen // enemy revive steps
.label NoReviveEnemy13   =  [DatReviveEnemy13  - DatImages] / DatImageLen // enemy revive steps
// ------------------------------------------------------------------------------------------------------------- //
.label NoDig0            =  [DatDig0           - DatImages] / DatImageLen // digits
.label NoDig1            =  [DatDig1           - DatImages] / DatImageLen
.label NoDig2            =  [DatDig2           - DatImages] / DatImageLen
.label NoDig3            =  [DatDig3           - DatImages] / DatImageLen
.label NoDig4            =  [DatDig4           - DatImages] / DatImageLen
.label NoDig5            =  [DatDig5           - DatImages] / DatImageLen
.label NoDig6            =  [DatDig6           - DatImages] / DatImageLen
.label NoDig7            =  [DatDig7           - DatImages] / DatImageLen
.label NoDig8            =  [DatDig8           - DatImages] / DatImageLen
.label NoDig9            =  [DatDig9           - DatImages] / DatImageLen
//
.label NoDigitsMin       =  NoDig0
.label NoDigitsMax       =  NoDig9
// ------------------------------------------------------------------------------------------------------------- //
.label NoChrA            =  [DatChrA           - DatImages] / DatImageLen // characters
.label NoChrB            =  [DatChrB           - DatImages] / DatImageLen
.label NoChrC            =  [DatChrC           - DatImages] / DatImageLen
.label NoChrD            =  [DatChrD           - DatImages] / DatImageLen
.label NoChrE            =  [DatChrE           - DatImages] / DatImageLen
.label NoChrF            =  [DatChrF           - DatImages] / DatImageLen
.label NoChrG            =  [DatChrG           - DatImages] / DatImageLen
.label NoChrH            =  [DatChrH           - DatImages] / DatImageLen
.label NoChrI            =  [DatChrI           - DatImages] / DatImageLen
.label NoChrJ            =  [DatChrJ           - DatImages] / DatImageLen
.label NoChrK            =  [DatChrK           - DatImages] / DatImageLen
.label NoChrL            =  [DatChrL           - DatImages] / DatImageLen
.label NoChrM            =  [DatChrM           - DatImages] / DatImageLen
.label NoChrN            =  [DatChrN           - DatImages] / DatImageLen
.label NoChrO            =  [DatChrO           - DatImages] / DatImageLen
.label NoChrP            =  [DatChrP           - DatImages] / DatImageLen
.label NoChrQ            =  [DatChrQ           - DatImages] / DatImageLen
.label NoChrR            =  [DatChrR           - DatImages] / DatImageLen
.label NoChrS            =  [DatChrS           - DatImages] / DatImageLen
.label NoChrT            =  [DatChrT           - DatImages] / DatImageLen
.label NoChrU            =  [DatChrU           - DatImages] / DatImageLen
.label NoChrV            =  [DatChrV           - DatImages] / DatImageLen
.label NoChrW            =  [DatChrW           - DatImages] / DatImageLen
.label NoChrX            =  [DatChrX           - DatImages] / DatImageLen
.label NoChrY            =  [DatChrY           - DatImages] / DatImageLen
.label NoChrZ            =  [DatChrZ           - DatImages] / DatImageLen
// ------------------------------------------------------------------------------------------------------------- //
.label NoChr0            =  [DatChr0           - DatImages] / DatImageLen // .hbu015. - character digits
.label NoChr1            =  [DatChr1           - DatImages] / DatImageLen // .hbu015.
.label NoChr2            =  [DatChr2           - DatImages] / DatImageLen // .hbu015.
.label NoChr3            =  [DatChr3           - DatImages] / DatImageLen // .hbu015.
.label NoChr4            =  [DatChr4           - DatImages] / DatImageLen // .hbu015.
.label NoChr5            =  [DatChr5           - DatImages] / DatImageLen // .hbu015.
.label NoChr6            =  [DatChr6           - DatImages] / DatImageLen // .hbu015.
.label NoChr7            =  [DatChr7           - DatImages] / DatImageLen // .hbu015.
.label NoChr8            =  [DatChr8           - DatImages] / DatImageLen // .hbu015.
.label NoChr9            =  [DatChr9           - DatImages] / DatImageLen // .hbu015.
//
.label NoChrDigitsMin    =  NoChr0                                        // .hbu015.
.label NoChrDigitsMax    =  NoChr9                                        // .hbu015.
// ------------------------------------------------------------------------------------------------------------- //
.label NoSpcBrRi         =  [DatSpcBrRi  - DatImages] / DatImageLen // special characters
.label NoSpcDot          =  [DatSpcDot   - DatImages] / DatImageLen
.label NoSpcPaLe         =  [DatSpcPaLe  - DatImages] / DatImageLen
.label NoSpcPaRi         =  [DatSpcPaRi  - DatImages] / DatImageLen
.label NoSpcSlash        =  [DatSpcSlash - DatImages] / DatImageLen
.label NoSpcHyp          =  [DatSpcHyp   - DatImages] / DatImageLen
.label NoSpcBrRLe        =  [DatSpcBrRLe - DatImages] / DatImageLen
.label NoSpcColon        =  [DatSpcColon - DatImages] / DatImageLen // .hbu013.
// ------------------------------------------------------------------------------------------------------------- //
