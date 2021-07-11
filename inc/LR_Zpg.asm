.label LRZ_LodeRunCol        =   $03                     // actual col lode runner
.label LRZ_LodeRunRow        =  $04                     // actual row lode runner
.label LRZ_LodeRunOnImgPosLR =  $05                     // lr pos on image left/right - $02=center
.label LRZ_LodeRunOnImgPosUD =  $06                     // lr pos on image up/down    - $02=center
.label LRZ_LodeRunSpriteNo   =  $07                     // lr sprite number
.label LRZ_XLvlModPos        =  $09                     // ptr: expanded level data rows $0800-$09c3 - in game modified with lr/en/holes
.label LRZ_XLvlModRowLo      =  $09                     //      lo
.label LRZ_XLvlModRowHi      =  $0a                     //      hi
.label LRZ_XLvlOriPos        =  $0b                     // ptr: expanded level data rows $0a00-$0bc3 - original without lr/en/holes
.label LRZ_XLvlOriRowLo      =  $0b                     //      lo
.label LRZ_XLvlOriRowHi      =  $0c                     //      hi
.label LRZ_ImageAdr          =  $0d                     // ptr: image data
.label LRZ_ImageAdrLo        =  $0d                     //      lo
.label LRZ_ImageAdrHi        =  $0e                     //      hi
.label LRZ_0d                =  $0d                     // ptr: copy graphic data end   address
.label LRZ_0e                =  $0e                     // ptr: copy graphic data end   address
.label LRZ_0f                =  $0f                     // ptr: copy graphic data start address
.label LRZ_10                =  $10                     // ptr: copy graphic data start address
.label LRZ_11                =  $11                     // ptr: copy graphic data start address
.label LRZ_12                =  $12                     // ptr: copy graphic data start address
.label LRZ_EnemyCol          =  $15                     // actual enemy col
.label LRZ_EnemyRow          =  $16                     // actual enemy row
.label LRZ_EnemySpriteNo     =  $17                     // actual enemy sprite number
.label LRZ_EnemyMovDirLR     =  $18                     // actual enemy dir right/left  $ff=left  $01=right
.label LRZ_EnemyMovLeft        = $ff                     // 
.label LRZ_EnemyMovRight       = $01                     // 
.label LRZ_EnemyInHoleTime   =  $19                     // enemy time in hole
.label LRZ_EnemyOnImgPosLR   =  $1a                     // actual enemy pos on image left/right
.label LRZ_EnemyOnImgPosUD   =  $1b                     // actual enemy pos on image up/down
.label LRZ_Work              =  $1e                     // worker /counter copy graphic data/joy content $DC00
.label LRZ_1f                =  $1f                     // worker /data    copy graphic data/
.label LRZ_GfxRowOff         =  $20                     // row offset
.label LRZ_EnemyRowSav       =  $20                     // save actual row
.label LRZ_ImageHight        =  $22                     // image hight
.label LRZ_WrkHiScorLen      =  $22                     // image hight
.label LRZ_ImageNo           =  $23                     // image number $00-$39
.label LRZ_EditTile          =  $23                     // edit tile number $00-$09
.label LRZ_EditCmd           =  $23                     // edit command character
.label LRZ_WrkGetKey         =  $23                     // save actual key
.label LRZ_ImgScreenOut      =  $24                     // target output  $20=$2000 $40=$4000
.label LRZ_EnemyColGetDir    =  $28                     // work: actual rank/actual enemy column
.label LRZ_EnemyRowGetDir    =  $29                     // work: score board offset/actual enemy row
.label LRZ_EnemyColGetDirSav =  $2a                     // save work actual enemy column
.label LRZ_EnemyMovDir       =  $2b                     // actual enemy move direction
.label LRZ_EnemyMovDirMin    =  $2c                     // move direction indicator
.label LRZ_EnemyMaxColLe     =  $2d                     // maximum move left - without walls ... in the way
.label LRZ_EnemyMaxColRi     =  $2e                     // maximum move right - without walls ... in the way
.label LRZ_2f                =  $2f                     // score add tune
.label LRZ_EnemyRowMaxUD     =  $2f                     // 
.label LRZ_EnemyColSavUD     =  $30                     // target row from work col
.label LRZ_EnemyRowSavUD     =  $31                     // target row from work row
.label LRZ_EnmyMovCyc1       =  $32                     // enemy move cycles tab
.label LRZ_EnmyMovCyc2       =  $33                     // enemy move cycles tab + 1
.label LRZ_EnmyMovCyc3       =  $34                     // enemy move cycles tab + 2
.label LRZ_EnmyMovCtrl       =  $35                     // enemy move control
.label LRZ_EnmyPtrCyc        =  $36                     // enemy move pointer actual cycles ($32-$34)
.label LRZ_ImagePosNo        =  $41                     // image position number  (bits 0-1 of 4f substitution)
.label LRZ_42                =  $42                     // my pointer multi color screen
.label LRZ_43                =  $43                     // my pointer multi color screen
.label LRZ_44                =  $44                     // my pointer sprite data
.label LRZ_45                =  $45                     // my pointer sprite data
.label LRZ_46                =  $46                     // my work
.label LRZ_ScreenCol         =  $4f                     // screen col  (00-1b)
.label LRZ_ScreenRow         =  $50                     // screen row  (00-0f) / wait for demo counter
.label LRZ_GfxScreenOut      =  $51                     // target output  $20=$2000 $40=$4000
.label LRZ_DemoMoveDat       =  $55                     // ptr: DemoMoveData
.label LRZ_DemoMoveDatLo     =  $55                     //      lo
.label LRZ_DemoMoveDatHi     =  $56                     //      hi
.label LRZ_DemoMoveType      =  $57                     // type of demo move  (l/r/u/d/fire)
.label LRZ_DemoMoveTime      =  $58                     // duration demo move
.label LRZ_EditStatus        =  $5a                     // edit status  $00=modified
.label LRZ_ImageDataBuf      =  $5b                     // generated image bytes - $5b-$7b
.label LRZ_TuneVoc1          =  $7c                     // tune value voice 1
.label LRZ_MelodyData        =  $7d                     // ptr: MelodyData
.label LRZ_MelodyDataLo      =  $7d                     //      lo
.label LRZ_MelodyDataHi      =  $7e                     //      hi
.label LRZ_MatrixLastKey     =  $c5                     // 197 - c64 - key value
