//Loader routine for Loade Runner Disk Program
//Looka for and loads main program "IT" to $6000
//

#import  "inc\kernel.asm"         // Kernel Vectors

*=$0400

        //Load in main file "IT" to $6000
        jsr !+              //Load in main file
        lda #$44            //"D"
        sta $0431           //Set name for next file load
        lda #$42            //"B"
        sta $0432
        jsr !+              //Load in data file "DB" to $1400
        jmp $6000           //Star of main program

    !:    
        lda #$01            //Length of file
        ldx #$08            //Low byte pointer to file name
        ldy #$FF            //High byte pointer to file name
        jsr SETLFS         //FFBA  Set Logical File Nmae
        jsr OPEN           //$FFC0
        lda #$02
        ldx #$31
        ldy #$04
        jsr SETNAM         //$FFBD  Set filename to load
        lda #$00
        jsr LOAD            //Load file 0 = load
        jsr CLALL          //$FFE7 Close all channels
        rts

.byte $49   //"I"
.byte $54   //"T"


