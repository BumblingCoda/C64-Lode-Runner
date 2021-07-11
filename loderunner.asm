*=$6000

	lda #$00
	tax 
//------------------------------
L_BRS_6003_6007_OK:
//------------------------------
	sta $0100,X 
	inx 
	bne L_BRS_6003_6007_OK
	dex 
	txs 
	jsr L_JSR_68E7_600B_OK
	lda #$02
	sta $1306 
	lda #$01
	jsr L_JSR_78D2_6015_OK
	cmp #$00
	bne L_BRS_6021_601A_OK
	lda #$02
	jsr L_JSR_78D2_601E_OK
//------------------------------
L_BRS_6021_601A_OK:
L_JMP_6021_7850_OK:
L_JMP_6021_7B29_OK:
//------------------------------
	lda #$FF
	sta $1313 
	sta $1315 
	sta $132A 
	sta $1339 
	lda #$00
	sta $132F 
	sta $132E 
	sta $1316 
	sta $132A 
	sta $1328 
	sta $1329 
	sta $136D 
	sta $136E 
	sta $132C 
	sta $135B 
	sta $135A 
	sta $D020 
	lda #$10
	sta $7A2C 
	sta $7A46 
	sta $1335 
	lda $C5 
	sta $1329 
	lda #$40
	sta $C5 
	lda #$05
	sta $131B 
	lda #$CA
	sta $130F 
	lda #$00
	sta $1306 
	jmp L_JMP_647D_6078_OK
//------------------------------
L_JMP_607B_6240_OK:
L_JMP_607B_62C2_OK:
L_JMP_607B_62F2_OK:
L_JMP_607B_6345_OK:
//------------------------------
	lda #$00
	sta $1310 
	lda #$01
	sta $1305 
	lda #$01
	sta $1318 
	lda #$02
	sta $1306 
	lda #$00
	sta $1328 
	sta $1334 
//------------------------------
L_JMP_6097_630B_OK:
L_JMP_6097_6C0B_OK:
//------------------------------
	lda #$00
	sta $58 
	sta $130A 
	sta $130B 
	sta $130C 
	sta $130D 
	sta $1311 
	sta $131E 
	sta $135F 
	sta $135E 
	sta $136A 
	lda #$05
	sta $133B 
	sta $1312 
	lda #$20
	sta $51 
	jsr L_JSR_6797_60C2_OK
	jsr L_JSR_9C0F_60C5_OK
	jsr L_JSR_9C1A_60C8_OK
	jsr L_JSR_96F2_60CB_OK
//------------------------------
L_JMP_60CE_6139_OK:
L_JMP_60CE_6249_OK:
L_JMP_60CE_62A4_OK:
L_JMP_60CE_6EFE_OK:
L_JMP_60CE_834F_OK:
L_JMP_60CE_836D_OK:
//------------------------------
	ldx #$01
	jsr L_JSR_77A4_60D0_OK
	ldy $131C 
	lda $A0BA,Y 
	sta $D015 
	lda #$00
	sta $1319 
	sta $131A 
	sta $132E 
	sta $132F 
	lda $130A 
	sta $1360 
	lda $130B 
	sta $1361 
	lda $130C 
	sta $1362 
	lda $130D 
	sta $1363 
	lda $1306 
	lsr 
	beq L_BRS_613C_6106_OK
//------------------------------
L_BRS_6108_6128_OK:
//------------------------------
	ldy #$07
//------------------------------
L_BRS_610A_6126_OK:
//------------------------------
	lda $9EB9,Y 
	sta $D027 
	sty $132B 
	ldx #$00
	ldy #$06
//------------------------------
L_BRS_6117_611D_OK:
L_BRS_6117_6120_OK:
//------------------------------
	jsr L_JSR_99CD_6117_OK
	bcs L_BRS_612A_611A_OK
	dex 
	bne L_BRS_6117_611D_OK
	dey 
	bne L_BRS_6117_6120_OK
	ldy $132B 
	dey 
	bpl L_BRS_610A_6126_OK
	bmi L_BRS_6108_6128_OK
//------------------------------
L_BRS_612A_611A_OK:
//------------------------------
	lda #$01
	sta $D027 
	lda $1328 
	cmp #$A4
	bne L_BRS_613C_6134_OK
	jsr L_JSR_84C5_6136_OK
	jmp L_JMP_60CE_6139_OK
//------------------------------
L_BRS_613C_6106_OK:
L_BRS_613C_6134_OK:
//------------------------------
	ldx #$00
	stx $1316 
	lda $1311 
	clc 
	adc $131C 
	tay 
	ldx $A0CC,Y 
	lda $868A,X 
	sta $32 
	lda $868B,X 
	sta $33 
	lda $868C,X 
	sta $34 
	ldy $1311 
	lda $A0D7,Y 
	sta $1320 
	jsr L_JSR_6363_6164_OK
//------------------------------
L_BRS_6167_61A2_OK:
L_JMP_6167_61B1_OK:
//------------------------------
	jsr L_JSR_7C8B_6167_OK
	lda $1314 
	beq L_BRS_61B4_616D_OK
	lda $130E 
	bne L_BRS_617D_6172_OK
	jsr L_JSR_67C1_6174_OK
	jsr L_JSR_63CE_6177_OK
	jsr L_JSR_9C5A_617A_OK
//------------------------------
L_BRS_617D_6172_OK:
//------------------------------
	lda $04 
	bne L_BRS_618E_617F_OK
	lda $06 
	cmp #$02
	bne L_BRS_618E_6185_OK
	lda $130E 
	beq L_BRS_61C8_618A_OK
	bmi L_BRS_61C8_618C_OK
//------------------------------
L_BRS_618E_617F_OK:
L_BRS_618E_6185_OK:
//------------------------------
	jsr L_JSR_8FF8_618E_OK
	lda $1314 
	beq L_BRS_61B4_6194_OK
	jsr L_JSR_8663_6196_OK
	lda $1314 
	beq L_BRS_61B4_619C_OK
	lda $1306 
	lsr  
	beq L_BRS_6167_61A2_OK
//------------------------------
L_BRS_61A4_61AA_OK:
//------------------------------
	lda $132D 
	cmp $131B 
	bcc L_BRS_61A4_61AA_OK
	lda #$03
	sta $132D 
	jmp L_JMP_6167_61B1_OK
//------------------------------
L_BRS_61B4_616D_OK:
L_BRS_61B4_6194_OK:
L_BRS_61B4_619C_OK:
//------------------------------
	ldx $136A 
	bmi L_BRS_61BC_61B7_OK
	dec $1312 
//------------------------------
L_BRS_61BC_61B7_OK:
//------------------------------
	lda $1306 
	lsr 
	beq L_BRS_61C5_61C0_OK
	jmp L_JMP_6262_61C2_OK
//------------------------------
L_BRS_61C5_61C0_OK:
//------------------------------
	jmp L_JMP_632E_61C5_OK
//------------------------------
L_BRS_61C8_618A_OK:
L_BRS_61C8_618C_OK:
//------------------------------
	ldx $136A 
	bpl L_BRS_61D0_61CB_OK
	jmp L_JMP_82BE_61CD_OK
//------------------------------
L_BRS_61D0_61CB_OK:
//------------------------------
	jsr L_JSR_644C_61D0_OK
	lda $135F 
	bpl L_BRS_61EA_61D6_OK
	jsr L_JSR_6733_61D8_OK
	sta $1310 
	sta $1305 
	inc $1305 
	inc $135E 
	jmp L_JMP_61F0_61E7_OK
//------------------------------
L_BRS_61EA_61D6_OK:
//------------------------------
	inc $1305 
	inc $1310 
//------------------------------
L_JMP_61F0_61E7_OK:
L_BRS_61F0_61F6_OK:
//------------------------------
	lda $132F 
	cmp $132E 
	bne L_BRS_61F0_61F6_OK
	jsr L_JSR_67A4_61F8_OK
	inc $1312 
	bne L_BRS_6203_61FE_OK
	dec $1312 
//------------------------------
L_BRS_6203_61FE_OK:
//------------------------------
	lda #$0E
	sta $2F 
	sei 
//------------------------------
L_BRS_6208_6226_OK:
//------------------------------
	lda #$40
	sec 
	sbc $2F 
	sta $D401 
	ldy #$2C
//------------------------------
L_BRS_6212_6218_OK:
//------------------------------
	ldx #$00
//------------------------------
L_BRS_6214_6215_OK:
//------------------------------
	dex 
	bne L_BRS_6214_6215_OK
	dey 
	bne L_BRS_6212_6218_OK
	sty $D401 
	lda #$50
	ldy #$00
	jsr L_JSR_9833_6221_OK
	dec $2F 
	bpl L_BRS_6208_6226_OK
	cli 
	lda $1306 
	lsr 
	bne L_BRS_624C_622D_OK
	lda #$01
	jsr L_JSR_630E_6231_OK
	bcs L_BRS_6240_6234_OK
	jsr L_JSR_7579_6236_OK
	lda #$03
	jsr L_JSR_630E_623B_OK
	bcc L_BRS_6243_623E_OK
//------------------------------
L_BRS_6240_6234_OK:
//------------------------------
	jmp L_JMP_607B_6240_OK
//------------------------------
L_BRS_6243_623E_OK:
//------------------------------
	jsr L_JSR_9C0F_6243_OK
	jsr L_JSR_96F2_6246_OK
//------------------------------
L_BRS_6249_6251_OK:
//------------------------------
	jmp L_JMP_60CE_6249_OK
//------------------------------
L_BRS_624C_622D_OK:
//------------------------------
	lda $1305 
	cmp #$97
	bne L_BRS_6249_6251_OK
	lda #$00
	ldy #$75
	jsr L_JSR_9833_6257_OK
	lda #$01
	jsr L_JSR_630E_625C_OK
	jmp L_JMP_62A7_625F_OK
//------------------------------
L_JMP_6262_61C2_OK:
//------------------------------
	lda #$38
	sta $132A 
//------------------------------
L_BRS_6267_626D_OK:
//------------------------------
	lda $132F 
	cmp $132E 
	bne L_BRS_6267_626D_OK
	lda #$00
	sta $1316 
	lda #$20
	sta $1315 
	jsr L_JSR_97F6_6279_OK
//------------------------------
L_BRS_627C_627F_OK:
//------------------------------
	lda $132A 
	bne L_BRS_627C_627F_OK
	lda $1360 
	sta $130A 
	lda $1361 
	sta $130B 
	lda $1362 
	sta $130C 
	lda $1363 
	sta $130D 
	lda #$00
	tay 
	jsr L_JSR_9833_629C_OK
	lda $1312 
	beq L_BRS_62A7_62A2_OK
	jmp L_JMP_60CE_62A4_OK
//------------------------------
L_JMP_62A7_625F_OK:
L_BRS_62A7_62A2_OK:
L_JMP_62A7_8333_OK:
//------------------------------
	jsr L_JSR_7410_62A7_OK
	bcc L_BRS_62B5_62AA_OK
	jsr L_JSR_7257_62AC_OK
	bne L_BRS_62B8_62AF_OK
	lda #$03
	bne L_BRS_62BA_62B3_OK
//------------------------------
L_BRS_62B5_62AA_OK:
//------------------------------
	jsr L_JSR_9C9C_62B5_OK
//------------------------------
L_BRS_62B8_62AF_OK:
//------------------------------
	lda #$01
//------------------------------
L_BRS_62BA_62B3_OK:
//------------------------------
	jsr L_JSR_630E_62BA_OK
	bcs L_BRS_62CA_62BD_OK
	jmp L_JMP_647D_62BF_OK
	jmp L_JMP_607B_62C2_OK
//------------------------------
L_JMP_62C5_6360_OK:
//------------------------------
	lda #$00
	sta $1328 
//------------------------------
L_BRS_62CA_62BD_OK:
//------------------------------
	lda #$03
	jsr L_JSR_630E_62CC_OK
	bcc L_BRS_62F5_62CF_OK
	beq L_BRS_62EF_62D1_OK
	jsr L_JSR_662A_62D3_OK
	lda $1328 
	cmp #$8E
	bne L_BRS_62E0_62DB_OK
	jmp L_JMP_6A46_62DD_OK
//------------------------------
L_BRS_62E0_62DB_OK:
//------------------------------
	cmp #$01
	bne L_BRS_62EF_62E2_OK
	lda $1334 
	bne L_BRS_62EF_62E7_OK
	dec $1334 
	jmp L_JMP_6350_62EC_OK
//------------------------------
L_BRS_62EF_62D1_OK:
L_BRS_62EF_62E2_OK:
L_BRS_62EF_62E7_OK:
//------------------------------
	jsr L_JSR_662A_62EF_OK
	jmp L_JMP_607B_62F2_OK
//------------------------------
L_BRS_62F5_62CF_OK:
//------------------------------
	jsr L_JSR_662A_62F5_OK
	ldx #$01
	stx $1318 
	ldx #$01
	stx $1306 
	ldx #$01
	stx $1305 
	dex 
	stx $1310 
	jmp L_JMP_6097_630B_OK
//------------------------------
L_JSR_630E_6231_OK:
L_JSR_630E_623B_OK:
L_JSR_630E_625C_OK:
L_JSR_630E_62BA_OK:
L_JSR_630E_62CC_OK:
L_JSR_630E_634A_OK:
L_JSR_630E_93E5_OK:
//------------------------------
	sta $50 
	ldy #$00
	ldx #$00
//------------------------------
L_BRS_6314_6321_OK:
L_BRS_6314_6324_OK:
L_BRS_6314_6328_OK:
//------------------------------
	lda $DC00 
	and #$10
	beq L_BRS_632C_6319_OK
	lda $1328 
	bne L_BRS_632C_631E_OK
	dey 
	bne L_BRS_6314_6321_OK
	dex 
	bne L_BRS_6314_6324_OK
	dec $50 
	bne L_BRS_6314_6328_OK
	clc 
	rts 
//------------------------------
L_BRS_632C_6319_OK:
L_BRS_632C_631E_OK:
//------------------------------
	sec 
	rts 
//------------------------------
L_JMP_632E_61C5_OK:
L_BRS_632E_6334_OK:
//------------------------------
	lda $132F 
	cmp $132E 
	bne L_BRS_632E_6334_OK
	lda #$38
	sta $132A 
//------------------------------
L_BRS_633B_633E_OK:
//------------------------------
	lda $132A 
	bne L_BRS_633B_633E_OK
	lda $1312 
	bne L_BRS_6348_6343_OK
	jmp L_JMP_607B_6345_OK
//------------------------------
L_BRS_6348_6343_OK:
//------------------------------
	lda #$02
	jsr L_JSR_630E_634A_OK
	jmp L_JMP_647D_634D_OK
//------------------------------
L_JMP_6350_62EC_OK:
//------------------------------
	jsr L_JSR_9C0F_6350_OK
	jsr L_JSR_757C_6353_OK
	lda #$02
	sta $1306 
	lda #$01
	sta $1334 
	jmp L_JMP_62C5_6360_OK
//------------------------------
L_JSR_6363_6164_OK:
//------------------------------
	sei 
	lda #$00
	sta $DD0B 
	sta $DD0A 
	sta $DD09 
	sta $DD08 
	cli 
	rts 
//------------------------------
L_JSR_6374_644C_OK:
//------------------------------
	sei 
	lda $DD0B 
	jsr L_JSR_987F_6378_OK
	lda $1309 
	clc 
	adc #$3C
	sta $646F 
	lda $DD0A 
	jsr L_JSR_987F_6387_OK
	lda $1308 
	clc 
	adc #$3C
	sta $6471 
	lda $1309 
	clc 
	adc #$3C
	sta $6472 
	lda $DD09 
	jsr L_JSR_987F_639F_OK
	lda $1308 
	clc 
	adc #$3C
	sta $6474 
	lda $1309 
	clc 
	adc #$3C
	sta $6475 
	lda $DD08 
	jsr L_JSR_987F_63B7_OK
	lda $1308 
	clc 
	adc #$3C
	sta $6477 
	lda $1309 
	clc 
	adc #$3C
	sta $6478 
	cli 
	rts 
//------------------------------
L_JSR_63CE_6177_OK:
L_JSR_63CE_6E57_OK:
L_JSR_63CE_6F81_OK:
L_JSR_63CE_6FB8_OK:
//------------------------------
	jsr L_JSR_69AA_63CE_OK
	ldy #$0D
//------------------------------
L_BRS_63D3_63DC_OK:
//------------------------------
	lda $10F1,Y 
	cmp $A098,Y 
	bne L_BRS_63E0_63D9_OK
	dey 
	bpl L_BRS_63D3_63DC_OK
	bmi L_BRS_63F7_63DE_OK
//------------------------------
L_BRS_63E0_63D9_OK:
//------------------------------
	lda $1306 
	cmp #$05
	bne L_BRS_63F6_63E5_OK
	ldy #$0E
//------------------------------
L_BRS_63E9_63F2_OK:
//------------------------------
	lda #$A0
	sta $642A,Y 
	sta $133D,Y 
	dey 
	bpl L_BRS_63E9_63F2_OK
	bmi L_BRS_641A_63F4_OK
//------------------------------
L_BRS_63F6_63E5_OK:
L_BRS_63F6_6418_OK:
//------------------------------
	rts 
//------------------------------
L_BRS_63F7_63DE_OK:
//------------------------------
	lda #$00
	sta $1E 
	ldy #$0E
//------------------------------
L_BRS_63FD_640D_OK:
//------------------------------
	lda $10E2,Y 
	sta $642A,Y 
	sta $133D,Y 
	eor #$A0
	ora $1E
	sta $1E 
	dey 
	bpl L_BRS_63FD_640D_OK
	lda $1E 
	bne L_BRS_641A_6411_OK
	lda $1306 
	cmp #$05
	bne L_BRS_63F6_6418_OK
//------------------------------
L_BRS_641A_63F4_OK:
L_BRS_641A_6411_OK:
//------------------------------
	jsr L_JSR_6A22_641A_OK
	lda #$20
	sta $51 
	jsr L_JSR_7204_6421_OK
	jsr L_JSR_721A_6424_OK
	jsr L_JSR_9951_6427_OK
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$00
	lda $1306 
	cmp #$05
	bne L_BRS_6449_643F_OK
	jsr L_JSR_720F_6441_OK
	lda #$77
	sta $6A1A 
//------------------------------
L_BRS_6449_643F_OK:
//------------------------------
	jmp L_JMP_6A17_6449_OK
//------------------------------
L_JSR_644C_61D0_OK:
//------------------------------
	jsr L_JSR_6374_644C_OK
	lda $1306 
	lsr 
	bne L_BRS_6456_6453_OK
	rts 
//------------------------------
L_BRS_6456_6453_OK:
//------------------------------
	lda $07A9 
	cmp $07AA 
	bne L_BRS_6464_645C_OK
	jsr L_JSR_6A22_645E_OK
	jsr L_JSR_69AA_6461_OK
//------------------------------
L_BRS_6464_645C_OK:
//------------------------------
	jsr L_JSR_721A_6464_OK
	jsr L_JSR_9951_6467_OK
	.byte $D4
	cmp #$CD
	cmp $BE 
	ldy #$BA
	ldy #$A0
	tsx 
	ldy #$A0
	ldx $A0A0 
	.byte $00
	jmp L_JMP_6A17_647A_OK
//------------------------------
L_JMP_647D_6078_OK:
L_JMP_647D_62BF_OK:
L_JMP_647D_634D_OK:
L_JMP_647D_79F0_OK:
//------------------------------
	jsr L_JSR_9C0F_647D_OK
	jsr L_JSR_65E3_6480_OK
	ldy #$4F
//------------------------------
L_BRS_6485_64B2_OK:
//------------------------------
	lda #$E0
	sta $0400,Y 
	sta $0450,Y 
	sta $04A0,Y 
	sta $04C8,Y 
	sta $06F8,Y 
	lda #$10
	sta $0518,Y 
	sta $0568,Y 
	sta $05B8,Y 
	sta $0608,Y 
	sta $0650,Y 
	lda #$80
	sta $06A8,Y 
	lda #$F0
	sta $0748,Y 
	dey 
	bpl L_BRS_6485_64B2_OK
	lda #$00
	sta $0F 
	lda #$14
	sta $10 
	lda #$FF
	sta $0D 
	lda #$1F
	sta $0E 
//------------------------------
L_BRS_64C4_64F3_OK:
//------------------------------
	ldy #$00
	lda ($0F),Y 
	sta $1E 
	iny 
	lda ($0F),Y 
	sta $1F 
	lda $0F 
	clc 
	adc #$02
	sta $0F 
	bcc L_BRS_64DA_64D6_OK
	inc $10 
//------------------------------
L_BRS_64DA_64D6_OK:
//------------------------------
	lda $1E 
	tay 
	lda $1F 
//------------------------------
L_BRS_64DF_64E2_OK:
//------------------------------
	sta ($0D),Y 
	dey 
	bne L_BRS_64DF_64E2_OK
	lda $0D 
	clc 
	adc $1E 
	sta $0D 
	bcc L_BRS_64EF_64EB_OK
	inc $0E 
//------------------------------
L_BRS_64EF_64EB_OK:
//------------------------------
	lda $0E 
	cmp #$3F
	bcc L_BRS_64C4_64F3_OK
	jsr L_JSR_73B2_64F5_OK
	bcs L_BRS_64FF_64F8_OK
	lda $1100 
	bne L_BRS_6502_64FD_OK
//------------------------------
L_BRS_64FF_64F8_OK:
//------------------------------
	jmp L_JMP_65E0_64FF_BAD
//------------------------------
L_BRS_6502_64FD_OK:
//------------------------------
	tax 
	ldy #$27
	lda #$73
//------------------------------
L_BRS_6507_650B_OK:
//------------------------------
	sta $0798,Y 
	dey 
	bpl L_BRS_6507_650B_OK
	ldy #$0C
	lda #$AA
//------------------------------
L_BRS_6511_6515_OK:
//------------------------------
	sta $0798,Y 
	dey 
	bpl L_BRS_6511_6515_OK
	txa 
	sta $65C3 
	lda $1101 
	sta $65C4 
	lda $1102 
	sta $65C5 
	lda $1150 
	sta $65C6 
	lda $1151 
	sta $65C7 
	lda $1152 
	sta $65C8 
	lda $1153 
	sta $65C9 
	lda $1154 
	sta $65CA 
	lda $1104 
	jsr L_JSR_987F_6548_OK
	lda $1309 
	clc 
	adc #$3C
	sta $65D1 
	lda $1105 
	jsr L_JSR_987F_6557_OK
	lda $1308 
	clc 
	adc #$3C
	sta $65D2 
	lda $1309 
	clc 
	adc #$3C
	sta $65D3 
	lda $1106 
	jsr L_JSR_987F_656F_OK
	lda $1308 
	clc 
	adc #$3C
	sta $65D4 
	lda $1309 
	clc 
	adc #$3C
	sta $65D5 
	lda $1107 
	jsr L_JSR_987F_6587_OK
	lda $1308 
	clc 
	adc #$3C
	sta $65D6 
	lda $1309 
	clc 
	adc #$3C
	sta $65D7 
	lda $1103 
	jsr L_JSR_9892_659F_OK
	lda $1307 
	clc 
	adc #$3C
	sta $65DC 
	lda $1308 
	clc 
	adc #$3C
	sta $65DD 
	lda $1309 
	clc 
	adc #$3C
	sta $65DE 
	jsr L_JSR_7223_65BD_OK
	jsr L_JSR_9951_65C0_OK
	iny 
	cmp ($CE,X) 
	.byte $D3
	cmp $CEC1 
	dec $D3A0 
	.byte $C3,$CF,$D2
	cmp $3C 
	.byte $3C,$3C,$3C,$3C,$3C,$3C
	ldy #$CC
	dec $CC,X 
	.byte $3C,$3C
//------------------------------
L_JMP_65E0_64FF_BAD:
//------------------------------
	and $4C00,X 
	cmp $62 
//------------------------------
L_JSR_65E3_6480_OK:
//------------------------------
	lda #$00
	tax 
	ldy #$01
	jsr L_JSR_6998_65E8_OK
	lda $D011 
	and #$7F
	ora #$20
	sta $D011 
	lda $D016 
	and #$EF
	sta $D016 
	lda $D018 
	and #$F0
	ora #$08
	sta $D018 
	sei 
	lda #$A9
	sta $0314 
	lda #$68
	sta $0315 
	lda #$EA
	sta $D012 
	lda #$01
	sta $D01A 
	lda $DC0D 
	lda $DD0D 
	lda $D019 
	sta $D019 
	cli 
	rts 
//------------------------------
L_JSR_662A_62D3_OK:
L_JSR_662A_62EF_OK:
L_JSR_662A_62F5_OK:
//------------------------------
	lda #$00
	tax 
	ldy #$00
	jsr L_JSR_6998_662F_OK
	sei 
	lda #$11
	sta $0314 
	lda #$68
	sta $0315 
	lda #$00
	sta $D01A 
	lda $DC0D 
	lda $DD0D 
	lda $D019 
	sta $D019 
	lda $D016 
	ora #$10
	sta $D016 
	cli 
	rts 
//------------------------------
L_JSR_6658_685E_OK:
//------------------------------
	ldx $132E 
	cpx $132F 
	beq L_BRS_66CF_665E_OK
	lda #$11
	sta $1337 
	sta $1338 
	lda $C300,X 
	lda #$F0
	and $1313 
	sta $D40D 
	sta $D414 
	lda $C100,X 
	bne L_BRS_667E_6679_OK
	sta $1337 
//------------------------------
L_BRS_667E_6679_OK:
//------------------------------
	tay 
	lda $A29B,Y 
	sta $D407 
	lda $A2C0,Y 
	sta $D408 
	lda $C200,X 
	bpl L_BRS_66A8_668E_OK
	lda $C100,X 
	tay 
	sec 
	lda $A29B,Y 
	sbc #$80
	sta $D40E 
	lda $A2C0,Y 
	sbc #$00
	sta $D40F 
	jmp L_JMP_66BA_66A5_OK
//------------------------------
L_BRS_66A8_668E_OK:
//------------------------------
	bne L_BRS_66AD_66A8_OK
	sta $1338 
//------------------------------
L_BRS_66AD_66A8_OK:
//------------------------------
	tay 
	lda $A29B,Y 
	sta $D40E 
	lda $A2C0,Y 
	sta $D40F 
//------------------------------
L_JMP_66BA_66A5_OK:
//------------------------------
	lda $1337 
	sta $D40B 
	lda $1338 
	sta $D412 
	dec $C000,X 
	bne L_BRS_66CE_66C9_OK
	inc $132E 
//------------------------------
L_BRS_66CE_66C9_OK:
//------------------------------
	rts 
//------------------------------
L_BRS_66CF_665E_OK:
//------------------------------
	lda #$00
	sta $D40B 
	sta $D412 
	rts 
//------------------------------
L_JSR_66D8_8598_OK:
L_JSR_66D8_9971_OK:
//------------------------------
	pla 
	sta $7D 
	pla 
	sta $7E 
	bne L_BRS_6711_66DE_OK
//------------------------------
L_BRS_66E0_670F_OK:
L_BRS_66E0_6713_OK:
L_BRS_66E0_6717_OK:
//------------------------------
	sei 
	ldy #$00
	lda ($7D),Y 
	beq L_BRS_6719_66E5_OK
	ldx $132F 
	sta $C000,X 
	iny 
	lda ($7D),Y 
	sta $C100,X 
	iny 
	lda ($7D),Y 
	sta $C200,X 
	iny 
	lda ($7D),Y 
	sta $C300,X 
	inc $132F 
	lda $7D 
	clc 
	adc #$04
	sta $7D 
	lda $7E 
	adc #$00
	sta $7E 
	bne L_BRS_66E0_670F_OK
//------------------------------
L_BRS_6711_66DE_OK:
//------------------------------
	inc $7D 
	bne L_BRS_66E0_6713_OK
	inc $7E 
	bne L_BRS_66E0_6717_OK
//------------------------------
L_BRS_6719_66E5_OK:
//------------------------------
	lda $7E 
	pha 
	lda $7D 
	pha 
	cli 
	rts 
//------------------------------
L_JSR_6721_6762_OK:
L_JSR_6721_823A_OK:
//------------------------------
	lda #$96
	sta $135D 
	ldy #$00
//------------------------------
L_BRS_6728_6730_OK:
//------------------------------
	tya 
	sta $C500,Y 
	iny 
	cpy $135D 
	bne L_BRS_6728_6730_OK
	rts 
//------------------------------
L_JSR_6733_61D8_OK:
L_BRS_6733_6748_OK:
L_JSR_6733_823D_OK:
L_JSR_6733_8263_OK:
L_JSR_6733_8291_OK:
//------------------------------
	lda $DC04 
	eor $DC05 
	eor $DD04 
	adc $DD05 
	eor $DD06 
	eor $DD07 
	cmp $135D 
	bcs L_BRS_6733_6748_OK
	tay 
	lda $C500,Y 
	sta $135C 
//------------------------------
L_BRS_6751_675B_OK:
//------------------------------
	lda $C501,Y 
	sta $C500,Y 
	iny 
	cpy $135D 
	bne L_BRS_6751_675B_OK
	dec $135D 
	bne L_BRS_6765_6760_OK
	jsr L_JSR_6721_6762_OK
//------------------------------
L_BRS_6765_6760_OK:
//------------------------------
	lda $135C 
	rts 
//------------------------------
L_JSR_6769_857A_OK:
L_JSR_6769_8582_OK:
L_JSR_6769_858A_OK:
L_JSR_6769_8592_OK:
//------------------------------
	sta $1331 
//------------------------------
L_JMP_676C_6779_OK:
L_BRS_676C_677F_OK:
L_BRS_676C_678E_OK:
//------------------------------
	lda $D012 
	sta $1336 
	cpx $1336 
	bcc L_BRS_677C_6775_OK
	beq L_BRS_677C_6777_OK
	jmp L_JMP_676C_6779_OK
//------------------------------
L_BRS_677C_6775_OK:
L_BRS_677C_6777_OK:
//------------------------------
	cpy $1336 
	bcc L_BRS_676C_677F_OK
	sec 
	sbc $1335 
	bcs L_BRS_678B_6785_OK
	eor #$FF
	adc #$01
//------------------------------
L_BRS_678B_6785_OK:
//------------------------------
	cmp $1331 
	bcc L_BRS_676C_678E_OK
	lda $1336 
	sta $1335 
	rts 
//------------------------------
L_JSR_6797_60C2_OK:
L_JSR_6797_94F0_OK:
//------------------------------
	lda $A27A 
	sta $1332 
	lda $A27B 
	sta $1333 
	rts 
//------------------------------
L_JSR_67A4_61F8_OK:
//------------------------------
	dec $1332 
	bpl L_BRS_67C0_67A7_OK
	inc $1333 
	lda $1333 
	cmp $A27C 
	bcc L_BRS_67BA_67B2_OK
	lda $A27B 
	sta $1333 
//------------------------------
L_BRS_67BA_67B2_OK:
//------------------------------
	lda $A27A 
	sta $1332 
//------------------------------
L_BRS_67C0_67A7_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_67C1_6174_OK:
//------------------------------
	lda $1332 
	asl A 
	tax 
	lda $A27D,X 
	sta $7D 
	lda $A27E,X 
	sta $7E 
//------------------------------
L_BRS_67D0_680D_OK:
//------------------------------
	sei 
	ldy #$00
	lda ($7D),Y 
	beq L_BRS_680F_67D5_OK
	ldx $132F 
	sta $C000,X 
	iny 
	lda ($7D),Y 
	beq L_BRS_67E6_67E0_OK
	clc 
	adc $1333 
//------------------------------
L_BRS_67E6_67E0_OK:
//------------------------------
	sta $C100,X 
	iny 
	lda ($7D),Y 
	beq L_BRS_67F4_67EC_OK
	bmi L_BRS_67F4_67EE_OK
	clc 
	adc $1333 
//------------------------------
L_BRS_67F4_67EC_OK:
L_BRS_67F4_67EE_OK:
//------------------------------
	sta $C200,X 
	iny 
	lda ($7D),Y 
	sta $C300,X 
	inc $132F 
	lda $7D 
	clc 
	adc #$04
	sta $7D 
	lda $7E 
	adc #$00
	sta $7E 
	bne L_BRS_67D0_680D_OK
//------------------------------
L_BRS_680F_67D5_OK:
//------------------------------
	cli 
	rts 
//------------------------------
	inc $132D 
	lda #$00
	sta $7C 
	lda $1313 
	and #$0F
	sta $D418 
	lda $1315 
	bne L_BRS_682D_6823_OK
	ldx $1302 
	stx $7C 
	jmp L_JMP_6832_682A_OK
//------------------------------
L_BRS_682D_6823_OK:
//------------------------------
	lda #$53
	sta $1302 
//------------------------------
L_JMP_6832_682A_OK:
//------------------------------
	lda $1316 
	beq L_BRS_6847_6835_OK
	lda $1317 
	sec 
	sbc #$20
	sta $1317 
	sta $7C 
	beq L_BRS_6847_6842_OK
	jmp L_JMP_684C_6844_OK
//------------------------------
L_BRS_6847_6835_OK:
L_BRS_6847_6842_OK:
//------------------------------
	lda #$00
	sta $1317 
//------------------------------
L_JMP_684C_6844_OK:
//------------------------------
	lda $132A 
	beq L_BRS_6859_684F_OK
	sec 
	sbc #$04
	sta $7C 
	sta $132A 
//------------------------------
L_BRS_6859_684F_OK:
//------------------------------
	lda $7C 
	sta $D401 
	jsr L_JSR_6658_685E_OK
	jsr L_JSR_686A_6861_OK
	jsr L_JSR_688D_6864_OK
	jmp EA31
//------------------------------
L_JSR_686A_6861_OK:
L_JSR_686A_68E1_OK:
//------------------------------
	lda $C5 
	bne L_BRS_6870_686C_OK
	lda #$07
//------------------------------
L_BRS_6870_686C_OK:
//------------------------------
	cmp #$40
	bne L_BRS_687A_6872_OK
	lda #$00
	sta $1329 
	rts 
//------------------------------
L_BRS_687A_6872_OK:
//------------------------------
	ldx $028D 
	beq L_BRS_6881_687D_OK
	ora #$80
//------------------------------
L_BRS_6881_687D_OK:
//------------------------------
	cmp $1329 
	beq L_BRS_688C_6884_OK
	sta $1329 
	sta $1328 
//------------------------------
L_BRS_688C_6884_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_688D_6864_OK:
//------------------------------
	dec $136E 
	lda $DC00 
	and #$1F
	eor #$1F
	bne L_BRS_689D_6897_OK
	sta $136E 
	rts 
//------------------------------
L_BRS_689D_6897_OK:
//------------------------------
	cmp $136E 
	beq L_BRS_68A8_68A0_OK
	sta $136E 
	sta $136D 
//------------------------------
L_BRS_68A8_68A0_OK:
//------------------------------
	rts 
//------------------------------
	lda $D019 
	sta $D019 
	bmi L_BRS_68B8_68AF_OK
	lda $DC0D 
	cli 
	jmp EA31
//------------------------------
L_BRS_68B8_68AF_OK:
//------------------------------
	lda $D012 
	cmp #$F8
	bcs L_BRS_68CC_68BD_OK
	lda $D016 
	ora #$10
	sta $D016 
	lda #$F8
	jmp L_JMP_68DE_68C9_OK
//------------------------------
L_BRS_68CC_68BD_OK:
//------------------------------
	lda $D016 
	and #$EF
	sta $D016 
	lda $D011 
	ora #$20
	sta $D011 
	lda #$EA
//------------------------------
L_JMP_68DE_68C9_OK:
//------------------------------
	sta $D012 
	jsr L_JSR_686A_68E1_OK
	jmp EA7E
//------------------------------
L_JSR_68E7_600B_OK:
//------------------------------
	lda $01 
	and #$FE
	sta $01 
	lda #$00
	sta $1E 
	sta $1F 
	ldy #$00
	lda #$19
	sta $1327 
//------------------------------
L_BRS_68FA_691A_OK:
//------------------------------
	ldx #$08
//------------------------------
L_BRS_68FC_690A_OK:
//------------------------------
	lda $1F 
	sta $0F00,Y 
	lda $1E 
	sta $0E00,Y 
	inc $1E 
	iny 
	dex 
	bne L_BRS_68FC_690A_OK
	clc 
	adc #$39
	sta $1E 
	lda $1F 
	adc #$01
	sta $1F 
	dec $1327 
	bne L_BRS_68FA_691A_OK
	lda #$36
	sta $1E 
	lda #$AC
	sta $1F 
	ldx #$00
//------------------------------
L_BRS_6926_693A_OK:
//------------------------------
	lda $1F 
	sta $CA00,X 
	lda $1E 
	sta $C900,X 
	clc 
	adc #$21
	sta $1E 
	bcc L_BRS_6939_6935_OK
	inc $1F 
//------------------------------
L_BRS_6939_6935_OK:
//------------------------------
	inx 
	bne L_BRS_6926_693A_OK
	lda #$45
	sta $0318 
	lda #$6A
	sta $0319 
	jsr L_JSR_9C0F_6946_OK
	lda #$00
	sta $D021 
	sta $D020 
	lda #$B0
	sta $D406 
	lda #$11
	sta $D404 
	ldx #$30
	stx $07F8 
	inx 
	stx $07FA 
	inx 
	stx $07FB 
	inx 
	stx $07FC 
	inx 
	stx $07FE 
	inx 
	stx $07FF 
	lda #$00
	sta $D01B 
	tay 
//------------------------------
L_BRS_697A_6984_OK:
//------------------------------
	sta $0002,Y 
	sta $0C00,Y 
	sta $0D00,Y 
	iny 
	bne L_BRS_697A_6984_OK
	lda #$FF
	sta $D015 
	sei 
	lda #$11
	sta $0314 
	lda #$68
	sta $0315 
	cli 
	rts 
//------------------------------
L_JSR_6998_65E8_OK:
L_JSR_6998_662F_OK:
L_JSR_6998_6A8D_OK:
L_JSR_6998_6E39_OK:
L_JSR_6998_7077_OK:
L_JMP_6998_70E9_OK:
L_JSR_6998_70F8_OK:
L_JSR_6998_726A_OK:
L_JSR_6998_950A_OK:
//------------------------------
	sta $69E8 
	sty $69F6 
	stx $6A0A 
	sty $6A0F 
	jsr L_JSR_69E5_69A4_OK
	jmp L_JMP_6A07_69A7_OK
//------------------------------
L_JSR_69AA_63CE_OK:
L_JSR_69AA_6461_OK:
L_JSR_69AA_7C18_OK:
L_JSR_69AA_91EB_OK:
L_JSR_69AA_96F2_OK:
//------------------------------
	lda $1306 
	lsr 
	bne L_BRS_69B6_69AE_OK
	ldx #$10
	ldy #$0C
	bne L_BRS_69C9_69B4_OK
//------------------------------
L_BRS_69B6_69AE_OK:
//------------------------------
	lda $1305 
	cmp #$97
	bcc L_BRS_69BF_69BB_OK
	sbc #$8C
//------------------------------
L_BRS_69BF_69BB_OK:
//------------------------------
	ldx #$FF
	sec 
//------------------------------
L_BRS_69C2_69C5_OK:
//------------------------------
	inx 
	sbc #$0A
	bcs L_BRS_69C2_69C5_OK
	ldy #$01
//------------------------------
L_BRS_69C9_69B4_OK:
//------------------------------
	sty $69F6 
	lda $9FED,X 
	sta $69E8 
	sta $6A0F 
	lda $9FFE,X 
	sta $6A0A 
	lda $A00F,X 
	sta $6A1A 
	jsr L_JSR_6A2D_69E1_OK
	rts 
//------------------------------
L_JSR_69E5_69A4_OK:
L_JSR_69E5_7C1B_OK:
//------------------------------
	ldy #$00
//------------------------------
L_BRS_69E7_6A04_OK:
//------------------------------
	lda #$86
	sta $0400,Y 
	sta $0500,Y 
	sta $0600,Y 
	sta $066E,Y 
	lda #$01
	sta $D800,Y 
	sta $D900,Y 
	sta $DA00,Y 
	sta $DB00,Y 
	dey 
	bne L_BRS_69E7_6A04_OK
	rts 
//------------------------------
L_JMP_6A07_69A7_OK:
L_JSR_6A07_7C49_OK:
L_JMP_6A07_91EE_OK:
L_JSR_6A07_96F5_OK:
//------------------------------
	ldy #$4F
//------------------------------
L_BRS_6A09_6A14_OK:
//------------------------------
	lda #$86
	sta $0770,Y 
	lda #$01
	sta $DBB0,Y 
	dey 
	bpl L_BRS_6A09_6A14_OK
	rts 
//------------------------------
L_JMP_6A17_6449_OK:
L_JMP_6A17_647A_OK:
L_JSR_6A17_6FCC_OK:
L_JSR_6A17_701F_OK:
L_JMP_6A17_799A_OK:
L_JSR_6A17_97E7_OK:
//------------------------------
	ldy #$13
	lda #$86
//------------------------------
L_BRS_6A1B_6A1F_OK:
//------------------------------
	sta $07AA,Y 
	dey 
	bpl L_BRS_6A1B_6A1F_OK
	rts 
//------------------------------
L_JSR_6A22_641A_OK:
L_JSR_6A22_645E_OK:
L_JSR_6A22_6FFA_OK:
L_JSR_6A22_7978_OK:
L_JSR_6A22_7C26_OK:
L_JSR_6A22_9804_OK:
//------------------------------
	ldy #$13
	lda #$00
//------------------------------
L_BRS_6A26_6A2A_OK:
//------------------------------
	sta $07AA,Y 
	dey 
	bpl L_BRS_6A26_6A2A_OK
	rts 
//------------------------------
L_JSR_6A2D_69E1_OK:
//------------------------------
	txa 
	asl A 
	asl A 
	asl A 
	sta $1303 
	clc 
	adc #$07
	tax 
	ldy #$07
//------------------------------
L_BRS_6A3A_6A42_OK:
//------------------------------
	lda $9F65,X 
	sta $D027,Y 
	dex 
	dey 
	bpl L_BRS_6A3A_6A42_OK
	rts 
//------------------------------
	rti 
//------------------------------
L_JMP_6A46_62DD_OK:
L_JMP_6A46_6BD6_OK:
//------------------------------
	ldy #$00
	sty $130A 
	sty $130B 
	sty $130C 
	sty $130D 
	dey 
	sty $133B 
	lda #$05
	sta $1312 
	lda #$05
	sta $1306 
	sta $132C 
	lda $130F 
	sta $6BF0 
	lda #$CB
	sta $130F 
	lda $1310 
	cmp #$96
	bcc L_BRS_6A7C_6A75_OK
	lda #$00
	sta $1310 
//------------------------------
L_BRS_6A7C_6A75_OK:
//------------------------------
	jsr L_JSR_9C0F_6A7C_OK
	jsr L_JSR_9C1A_6A7F_OK
	jmp L_JMP_6A88_6A82_OK
//------------------------------
L_BRS_6A85_6AF8_OK:
L_JMP_6A85_6D7F_OK:
L_JMP_6A85_6FBE_OK:
L_JMP_6A85_7059_OK:
L_JMP_6A85_7063_OK:
//------------------------------
	jsr L_JSR_9C0F_6A85_OK
//------------------------------
L_JMP_6A88_6A82_OK:
//------------------------------
	lda #$73
	tax 
	ldy #$01
	jsr L_JSR_6998_6A8D_OK
	lda #$20
	sta $51 
	lda #$00
	sta $1328 
	jsr L_JSR_71F7_6A99_OK
	jsr L_JSR_9951_6A9C_OK
	ldy #$A0
	cpy $C4CF 
	cmp $A0 
	.byte $D2
	cmp $CE,X 
	dec $D2C5 
	ldy #$C2
	.byte $CF
	cmp ($D2,X) 
	cpy $A0 
	cmp $C4 
	cmp #$D4
	.byte $CF,$D2
	sta $ADAD 
	lda $ADAD 
	lda $ADAD 
	lda $ADAD 
	lda $ADAD 
	lda $ADAD 
	lda $ADAD 
	lda $ADAD 
	lda $ADAD 
	lda $8DAD 
	ldy #$D2
	.byte $AF,$D3
	ldy #$CB
	cmp $D9 
	ldy #$C1
	.byte $C2,$CF,$D2,$D4,$D3
	ldy #$C1
	dec $A0D9 
	.byte $C3,$CF
	cmp $C1CD 
	dec $8DC4 
	.byte $00
//------------------------------
L_JMP_6AF4_6B1A_OK:
L_JMP_6AF4_6BAD_OK:
L_JMP_6AF4_6C39_OK:
L_JMP_6AF4_6CDC_OK:
L_JMP_6AF4_6D8F_OK:
L_JMP_6AF4_6E1D_OK:
L_JMP_6AF4_6E23_OK:
L_JMP_6AF4_71B6_OK:
L_JMP_6AF4_723A_OK:
//------------------------------
	lda $50 
	cmp #$09
	bcs L_BRS_6A85_6AF8_OK
	jsr L_JSR_9951_6AFA_OK
	sta $CFC3 
	cmp $C1CD 
	dec $BEC4 
	.byte $00
	jsr L_JSR_722C_6B07_OK
//------------------------------
L_BRS_6B0A_6B15_OK:
//------------------------------
	ldy $9E66,X 
	beq L_BRS_6B17_6B0D_OK
	cmp $9E66,X 
	beq L_BRS_6B1D_6B12_OK
	inx 
	bne L_BRS_6B0A_6B15_OK
//------------------------------
L_BRS_6B17_6B0D_OK:
L_JMP_6B17_6B63_OK:
L_JMP_6B17_6C0E_OK:
L_JMP_6B17_6C3C_OK:
L_JMP_6B17_6C58_OK:
L_JMP_6B17_6CDF_OK:
L_JMP_6B17_6E51_OK:
//------------------------------
	jsr L_JSR_9971_6B17_OK
	jmp L_JMP_6AF4_6B1A_OK
//------------------------------
L_BRS_6B1D_6B12_OK:
//------------------------------
	txa 
	asl A 
	tax 
	lda $9E70,X 
	pha 
	lda $9E6F,X 
	pha 
	rts 
//------------------------------
	jsr L_JSR_9951_6B29_OK
	sta $BEBE 
	.byte $D3,$D7
	cmp ($D0,X) 
	ldy #$CC
	cmp $D6 
	cmp $CC 
	.byte $00
	jsr L_JSR_714B_6B3A_OK
	bcs L_BRS_6B63_6B3D_OK
	sty $1368 
	jsr L_JSR_9951_6B42_OK
	sta $A0A0 
	.byte $D7
	cmp #$D4
	iny 
	ldy #$CC
	cmp $D6 
	cmp $CC 
	.byte $00
	jsr L_JSR_714B_6B53_OK
	bcs L_BRS_6B63_6B56_OK
	cpy $1368 
	beq L_BRS_6B63_6B5B_OK
	sty $1369 
	jmp L_JMP_6B66_6B60_OK
//------------------------------
L_BRS_6B63_6B3D_OK:
L_BRS_6B63_6B56_OK:
L_BRS_6B63_6B5B_OK:
//------------------------------
	jmp L_JMP_6B17_6B63_OK
//------------------------------
L_JMP_6B66_6B60_OK:
//------------------------------
	jsr L_JSR_704D_6B66_OK
	lda $1369 
	sta $1310 
	lda #$C8
	sta $7A2C 
	lda #$01
	jsr L_JSR_7896_6B76_OK
	lda #$10
	sta $7A2C 
	lda $1368 
	sta $1310 
	lda #$01
	jsr L_JSR_7896_6B86_OK
	lda $1369 
	sta $1310 
	lda #$02
	jsr L_JSR_7896_6B91_OK
	ldy $1368 
	sty $1310 
	dey 
	sty $133B 
	lda #$C8
	sta $7A46 
	lda #$02
	jsr L_JSR_7896_6BA5_OK
	lda #$10
	sta $7A46 
//------------------------------
L_BRS_6BAD_6BDF_OK:
//------------------------------
	jmp L_JMP_6AF4_6BAD_OK
	jsr L_JSR_7579_6BB0_OK
	jsr L_JSR_9951_6BB3_OK
	sta $A0A0 
	ldy #$A0
	iny 
	cmp #$D4
	ldy #$C1
	ldy #$CB
	cmp $D9 
	ldy #$D4
	.byte $CF
	ldy #$C3
	.byte $CF
	dec $C9D4 
	dec $C5D5 
	.byte $00
//------------------------------
L_BRS_6BD1_6BD4_OK:
//------------------------------
	jsr L_JSR_99CD_6BD1_OK
	bcc L_BRS_6BD1_6BD4_OK
	jmp L_JMP_6A46_6BD6_OK
	jsr L_JSR_9951_6BD9_OK
	sta $BEBE 
	bne L_BRS_6BAD_6BDF_OK
	cmp ($D9,X) 
	ldy #$CC
	cmp $D6 
	cmp $CC 
	.byte $00
	jsr L_JSR_714B_6BEA_OK
	bcs L_BRS_6C0E_6BED_OK
	lda #$00
	sta $130F 
	lda #$03
	sta $1306 
	lda #$01
	sta $1318 
	lda #$00
	sta $132C 
	lda $1310 
	beq L_BRS_6C0B_6C06_OK
	lsr $1318 
//------------------------------
L_BRS_6C0B_6C06_OK:
//------------------------------
	jmp L_JMP_6097_6C0B_OK
//------------------------------
L_BRS_6C0E_6BED_OK:
//------------------------------
	jmp L_JMP_6B17_6C0E_OK
	jsr L_JSR_9951_6C11_OK
	sta $BEBE 
	.byte $C3
	cpy $C1C5 
	.byte $D2
	ldy #$CC
	cmp $D6 
	cmp $CC 
	.byte $00
	jsr L_JSR_714B_6C23_OK
	bcs L_BRS_6C3C_6C26_OK
	jsr L_JSR_704D_6C28_OK
	ldy #$00
	tya 
//------------------------------
L_BRS_6C2E_6C32_OK:
//------------------------------
	sta $1000,Y 
	iny 
	bne L_BRS_6C2E_6C32_OK
	lda #$02
	jsr L_JSR_7896_6C36_OK
	jmp L_JMP_6AF4_6C39_OK
//------------------------------
L_BRS_6C3C_6C26_OK:
//------------------------------
	jmp L_JMP_6B17_6C3C_OK
	jsr L_JSR_9951_6C3F_OK
	sta $BEBE 
	cmp $C4 
	cmp #$D4
	ldy #$CC
	cmp $D6 
	cmp $CC 
	.byte $00
	jsr L_JSR_714B_6C50_OK
	bcs L_BRS_6C58_6C53_OK
	jmp L_JMP_6E26_6C55_OK
//------------------------------
L_BRS_6C58_6C53_OK:
//------------------------------
	jmp L_JMP_6B17_6C58_OK
	jsr L_JSR_9951_6C5B_OK
	sta $BEBE 
	cmp $D6CF 
	cmp $A0 
	cpy $D6C5 
	cmp $CC 
	.byte $00
	jsr L_JSR_714B_6C6C_OK
	bcs L_BRS_6CDF_6C6F_OK
	sty $1368 
	jsr L_JSR_9951_6C74_OK
	ldy #$D4
	.byte $CF
	ldy #$CC
	cmp $D6 
	cmp $CC 
	.byte $00
	jsr L_JSR_714B_6C81_OK
	bcs L_BRS_6CDF_6C84_OK
	sty $1369 
	jsr L_JSR_9951_6C89_OK
	sta $A0A0 
	.byte $D3,$CF
	cmp $D2,X 
	.byte $C3
	cmp $A0 
	cpy $C9 
	.byte $D3,$CB
	cmp $D4 
	.byte $D4
	cmp $00 
	jsr L_JSR_722C_6C9F_OK
	jsr L_JSR_704D_6CA2_OK
	lda $1368 
	sta $1310 
	lda #$01
	jsr L_JSR_7896_6CAD_OK
	jsr L_JSR_9951_6CB0_OK
	sta $A0A0 
	cpy $C5 
	.byte $D3,$D4
	cmp #$CE
	cmp ($D4,X) 
	cmp #$CF
	dec $C4A0 
	cmp #$D3
	.byte $CB
	cmp $D4 
	.byte $D4
	cmp $00 
	jsr L_JSR_722C_6CCB_OK
	jsr L_JSR_704D_6CCE_OK
	lda $1369 
	sta $1310 
	lda #$02
	jsr L_JSR_7896_6CD9_OK
	jmp L_JMP_6AF4_6CDC_OK
//------------------------------
L_BRS_6CDF_6C6F_OK:
L_BRS_6CDF_6C84_OK:
//------------------------------
	jmp L_JMP_6B17_6CDF_OK
	jsr L_JSR_9951_6CE2_OK
	sta $BEBE 
	cmp #$CE
	cmp #$D4
	cmp #$C1
	cpy $DAC9 
	cmp $8D 
	ldy #$A0
	.byte $D4
	iny 
	cmp #$D3
	ldy #$D0
	.byte $D2
	cmp $D0 
	cmp ($D2,X) 
	cmp $D3 
	ldy #$C1
	dec $C1A0 
	cpy $C5D2 
	cmp ($C4,X) 
	cmp $A08D,Y 
	ldy #$C6
	.byte $CF,$D2
	cmp $D4C1 
	.byte $D4
	cmp $C4 
	ldy #$C4
	cmp #$D3
	.byte $CB
	ldy #$C6
	.byte $CF,$D2
	ldy #$D5
	.byte $D3
	cmp $D2 
	sta $A0A0 
	.byte $C3,$D2
	cmp $C1 
	.byte $D4
	cmp $C4 
	ldy #$CC
	cmp $D6 
	cmp $CC 
	.byte $D3
	ldx $A08D 
	ldy #$A8
	.byte $D7
	cmp #$CC
	cpy $C4A0 
	cmp $D3 
	.byte $D4,$D2,$CF
	cmp $CFA0,Y 
	cpy $A0C4 
	cpy $C1 
	.byte $D4
	cmp ($A9,X) 
	ldx $8D8D 
	ldy #$A0
	cmp ($D2,X) 
	cmp $A0 
	cmp $D5CF,Y 
	ldy #$D3
	cmp $D2,X 
	cmp $A0 
	tay 
	cmp $CEAF,Y 
	lda #$A0
	.byte $00
	jsr L_JSR_722C_6D6C_OK
	cmp #$19
	bne L_BRS_6D8F_6D71_OK
	lda #$01
	jsr L_JSR_78D2_6D75_OK
	cmp #$01
	bne L_BRS_6D82_6D7A_OK
	jsr L_JSR_7067_6D7C_OK
	jmp L_JMP_6A85_6D7F_OK
//------------------------------
L_BRS_6D82_6D7A_OK:
//------------------------------
	lda $1310 
	pha 
	lda #$04
	jsr L_JSR_7896_6D88_OK
	pla 
	sta $1310 
//------------------------------
L_BRS_6D8F_6D71_OK:
//------------------------------
	jmp L_JMP_6AF4_6D8F_OK
	jsr L_JSR_9951_6D92_OK
	sta $BEBE 
	.byte $C3
	cpy $C1C5 
	.byte $D2
	ldy #$D3
	.byte $C3,$CF,$D2
	cmp $A0 
	dec $C9 
	cpy $8DC5 
	ldy #$A0
	.byte $D4
	iny 
	cmp #$D3
	ldy #$C3
	cpy $C1C5 
	.byte $D2,$D3
	ldy #$D4
	iny 
	cmp $A0 
	iny 
	cmp #$C7
	iny 
	sta $A0A0 
	.byte $D3,$C3,$CF,$D2
	cmp $A0 
	dec $C9 
	cpy $A0C5 
	.byte $CF
	dec $A0 
	cmp ($CC,X) 
	cpy $A08D 
	ldy #$C5
	dec $D2D4 
	cmp #$C5
	.byte $D3
	ldx $8D8D 
	ldy #$A0
	cmp ($D2,X) 
	cmp $A0 
	cmp $D5CF,Y 
	ldy #$D3
	cmp $D2,X 
	cmp $A0 
	tay 
	cmp $CEAF,Y 
	lda #$A0
	.byte $00
	jsr L_JSR_722C_6DF6_OK
	cmp #$19
	bne L_BRS_6E23_6DFB_OK
	lda #$01
	jsr L_JSR_78D2_6DFF_OK
	cmp #$00
	beq L_BRS_6E20_6E04_OK
	lda #$00
	ldy #$7F
//------------------------------
L_BRS_6E0A_6E0E_OK:
//------------------------------
	sta $1100,Y 
	dey 
	bpl L_BRS_6E0A_6E0E_OK
	ldy #$17
//------------------------------
L_BRS_6E12_6E16_OK:
//------------------------------
	sta $11B0,Y 
	dey 
	bpl L_BRS_6E12_6E16_OK
	lda #$02
	jsr L_JSR_78D2_6E1A_OK
	jmp L_JMP_6AF4_6E1D_OK
//------------------------------
L_BRS_6E20_6E04_OK:
//------------------------------
	jsr L_JSR_70EC_6E20_OK
//------------------------------
L_BRS_6E23_6DFB_OK:
//------------------------------
	jmp L_JMP_6AF4_6E23_OK
//------------------------------
L_JMP_6E26_6C55_OK:
L_JMP_6E26_6F04_OK:
L_JMP_6E26_6F8D_OK:
L_JMP_6E26_6F96_OK:
L_JMP_6E26_6F9F_OK:
//------------------------------
	ldx #$01
	stx $5A 
	jsr L_JSR_9C0F_6E2A_OK
	jsr L_JSR_704D_6E2D_OK
	jsr L_JSR_71F7_6E30_OK
//------------------------------
L_JMP_6E33_82D8_OK:
//------------------------------
	lda #$EA
	ldx #$32
	ldy #$01
	jsr L_JSR_6998_6E39_OK
	lda #$20
	sta $51 
	jsr L_JSR_96F8_6E40_OK
	lda #$40
	sta $51 
	jsr L_JSR_96F8_6E47_OK
	ldx #$00
	jsr L_JSR_77A4_6E4C_OK
	bcc L_BRS_6E54_6E4F_OK
	jmp L_JMP_6B17_6E51_OK
//------------------------------
L_BRS_6E54_6E4F_OK:
//------------------------------
	jsr L_JSR_720F_6E54_OK
	jsr L_JSR_63CE_6E57_OK
//------------------------------
L_JMP_6E5A_6E84_OK:
L_JMP_6E5A_6EB9_OK:
L_JMP_6E5A_6F11_OK:
L_JMP_6E5A_6F16_OK:
L_JMP_6E5A_6F23_OK:
L_JMP_6E5A_6F28_OK:
L_JMP_6E5A_6F35_OK:
L_JMP_6E5A_6F3A_OK:
L_JMP_6E5A_6F47_OK:
L_JMP_6E5A_6F4C_OK:
L_JMP_6E5A_6F5E_OK:
L_JMP_6E5A_6F6B_OK:
L_JMP_6E5A_6F84_OK:
L_JMP_6E5A_6FB0_OK:
L_JMP_6E5A_6FBB_OK:
L_JMP_6E5A_6FF2_OK:
//------------------------------
	jsr L_JSR_713A_6E5A_OK
	jsr L_JSR_997A_6E5D_OK
	jsr L_JSR_723E_6E60_OK
	bcs L_BRS_6E87_6E63_OK
	sta $23 
	ldy $50 
	lda $A1B0,Y 
	sta $09 
	lda $A1C0,Y 
	sta $0A 
	ldy $4F 
	lda $23 
	eor ($09),Y 
	beq L_BRS_6E7D_6E79_OK
	lsr $5A 
//------------------------------
L_BRS_6E7D_6E79_OK:
//------------------------------
	lda $23 
	sta ($09),Y 
	jsr L_JSR_99F0_6E81_OK
	jmp L_JMP_6E5A_6E84_OK
//------------------------------
L_BRS_6E87_6E63_OK:
//------------------------------
	sta $23 
	ldy $1370 
	bne L_BRS_6E9A_6E8C_OK
//------------------------------
L_BRS_6E8E_6E98_OK:
//------------------------------
	lda $9E7F,Y 
	beq L_BRS_6EB6_6E91_OK
	cmp $23 
	beq L_BRS_6EBC_6E95_OK
	iny 
	bne L_BRS_6E8E_6E98_OK
//------------------------------
L_BRS_6E9A_6E8C_OK:
//------------------------------
	ldy #$03
	sty $136E 
//------------------------------
L_BRS_6E9F_6EA2_OK:
//------------------------------
	ldy $136E 
	bne L_BRS_6E9F_6EA2_OK
	lda $136D 
	ror A 
	bcs L_BRS_6EBC_6EA8_OK
	iny 
	ror A 
	bcs L_BRS_6EBC_6EAC_OK
	iny 
	ror A 
	bcs L_BRS_6EBC_6EB0_OK
	iny 
	ror A 
	bcs L_BRS_6EBC_6EB4_OK
//------------------------------
L_BRS_6EB6_6E91_OK:
//------------------------------
	jsr L_JSR_9971_6EB6_OK
	jmp L_JMP_6E5A_6EB9_OK
//------------------------------
L_BRS_6EBC_6E95_OK:
L_BRS_6EBC_6EA8_OK:
L_BRS_6EBC_6EAC_OK:
L_BRS_6EBC_6EB0_OK:
L_BRS_6EBC_6EB4_OK:
//------------------------------
	tya 
	asl A 
	tay 
	lda $9E94,Y 
	pha 
	lda $9E93,Y 
	pha 
	rts 
//------------------------------
	lsr $1318 
	lda #$20
	sta $51 
	lda #$03
	sta $1306 
	lda $6BF0 
	sta $130F 
	lda #$00
	sta $1328 
	sta $1334 
	sta $132C 
	lda $1310 
	sta $133B 
	lda #$FF
	sta $136A 
	jsr L_JSR_7204_6EF0_OK
	jsr L_JSR_7853_6EF3_OK
	lda #$00
	sta $1311 
	sta $131E 
	jmp L_JMP_60CE_6EFE_OK
	jsr L_JSR_84C5_6F01_OK
	jmp L_JMP_6E26_6F04_OK
	lda $50 
	cmp #$00
	bne L_BRS_6F14_6F0B_OK
	lda #$0F
	sta $50 
	jmp L_JMP_6E5A_6F11_OK
//------------------------------
L_BRS_6F14_6F0B_OK:
//------------------------------
	dec $50 
	jmp L_JMP_6E5A_6F16_OK
	lda $4F 
	cmp #$00
	bne L_BRS_6F26_6F1D_OK
	lda #$1B
	sta $4F 
	jmp L_JMP_6E5A_6F23_OK
//------------------------------
L_BRS_6F26_6F1D_OK:
//------------------------------
	dec $4F 
	jmp L_JMP_6E5A_6F28_OK
	lda $4F 
	cmp #$1B
	bne L_BRS_6F38_6F2F_OK
	lda #$00
	sta $4F 
	jmp L_JMP_6E5A_6F35_OK
//------------------------------
L_BRS_6F38_6F2F_OK:
//------------------------------
	inc $4F 
	jmp L_JMP_6E5A_6F3A_OK
	lda $50 
	cmp #$0F
	bne L_BRS_6F4A_6F41_OK
	lda #$00
	sta $50 
	jmp L_JMP_6E5A_6F47_OK
//------------------------------
L_BRS_6F4A_6F41_OK:
//------------------------------
	inc $50 
	jmp L_JMP_6E5A_6F4C_OK
//------------------------------
L_JSR_6F4F_7045_OK:
//------------------------------
	lda #$01
	jsr L_JSR_78D2_6F51_OK
	cmp #$00
	bne L_BRS_6F61_6F56_OK
	jsr L_JSR_70EC_6F58_OK
	jsr L_JSR_71F7_6F5B_OK
	jmp L_JMP_6E5A_6F5E_OK
//------------------------------
L_BRS_6F61_6F56_OK:
//------------------------------
	cmp #$01
	bne L_BRS_6F6E_6F63_OK
	jsr L_JSR_7067_6F65_OK
	jsr L_JSR_71F7_6F68_OK
	jmp L_JMP_6E5A_6F6B_OK
//------------------------------
L_BRS_6F6E_6F63_OK:
//------------------------------
	jsr L_JSR_7853_6F6E_OK
	lda #$02
	jsr L_JSR_7896_6F73_OK
	jsr L_JSR_720F_6F76_OK
	lda #$01
	sta $5A 
	rts 
//------------------------------
	jsr L_JSR_6FFA_6F7E_OK
	jsr L_JSR_63CE_6F81_OK
	jmp L_JMP_6E5A_6F84_OK
	jsr L_JSR_6FF5_6F87_OK
	inc $133B 
	jmp L_JMP_6E26_6F8D_OK
	jsr L_JSR_6FF5_6F90_OK
	jsr L_JSR_83F2_6F93_OK
	jmp L_JMP_6E26_6F96_OK
	jsr L_JSR_6FF5_6F99_OK
	jsr L_JSR_83B9_6F9C_OK
	jmp L_JMP_6E26_6F9F_OK
	lda $135A 
	bpl L_BRS_6FB0_6FA5_OK
	jsr L_JSR_7204_6FA7_OK
	jsr L_JSR_7929_6FAA_OK
	jsr L_JSR_720F_6FAD_OK
//------------------------------
L_BRS_6FB0_6FA5_OK:
//------------------------------
	jmp L_JMP_6E5A_6FB0_OK
	jsr L_JSR_6FF5_6FB3_OK
	bcc L_BRS_6FBE_6FB6_OK
	jsr L_JSR_63CE_6FB8_OK
	jmp L_JMP_6E5A_6FBB_OK
//------------------------------
L_BRS_6FBE_6FB6_OK:
//------------------------------
	jmp L_JMP_6A85_6FBE_OK
	jsr L_JSR_7204_6FC1_OK
	jsr L_JSR_721A_6FC4_OK
	lda #$77
	sta $6A1A 
	jsr L_JSR_6A17_6FCC_OK
	lda #$20
	sta $51 
	ldy #$0F
	clc 
	jsr L_JSR_76D2_6FD6_OK
	jsr L_JSR_720F_6FD9_OK
	ldy #$0E
//------------------------------
L_BRS_6FDE_6FE5_OK:
//------------------------------
	lda $133D,Y 
	sta $10E2,Y 
	dey 
	bpl L_BRS_6FDE_6FE5_OK
	ldy #$0D
//------------------------------
L_BRS_6FE9_6FF0_OK:
//------------------------------
	lda $A098,Y 
	sta $10F1,Y 
	dey 
	bpl L_BRS_6FE9_6FF0_OK
	jmp L_JMP_6E5A_6FF2_OK
//------------------------------
L_JSR_6FF5_6F87_OK:
L_JSR_6FF5_6F90_OK:
L_JSR_6FF5_6F99_OK:
L_JSR_6FF5_6FB3_OK:
//------------------------------
	lda $5A 
	beq L_BRS_6FFA_6FF7_OK
	rts 
//------------------------------
L_JSR_6FFA_6F7E_OK:
L_BRS_6FFA_6FF7_OK:
//------------------------------
	jsr L_JSR_6A22_6FFA_OK
	lda #$20
	sta $51 
	jsr L_JSR_7204_7001_OK
	jsr L_JSR_721A_7004_OK
	jsr L_JSR_9951_7007_OK
	.byte $D3
	cmp ($D6,X) 
	cmp $A0 
	cpy $C1 
	.byte $D4
	cmp ($A0,X) 
	ldy #$A0
	cmp $CEAF,Y 
	.byte $00
	lda #$DD
	sta $6A1A 
	jsr L_JSR_6A17_701F_OK
	dec $4F 
//------------------------------
L_BRS_7024_7043_OK:
//------------------------------
	jsr L_JSR_9971_7024_OK
	lda #$CE
	jsr L_JSR_98D5_7029_OK
	jsr L_JSR_997A_702C_OK
	ldy #$00
	sty $1328 
	cmp #$3F
	bne L_BRS_703D_7036_OK
	jsr L_JSR_720F_7038_OK
	sec 
	rts 
//------------------------------
L_BRS_703D_7036_OK:
//------------------------------
	cmp #$27
	beq L_BRS_7048_703F_OK
	cmp #$19
	bne L_BRS_7024_7043_OK
	jsr L_JSR_6F4F_7045_OK
//------------------------------
L_BRS_7048_703F_OK:
//------------------------------
	jsr L_JSR_720F_7048_OK
	clc 
	rts 
//------------------------------
L_JSR_704D_6B66_OK:
L_JSR_704D_6C28_OK:
L_JSR_704D_6CA2_OK:
L_JSR_704D_6CCE_OK:
L_JSR_704D_6E2D_OK:
//------------------------------
	lda #$01
	jsr L_JSR_78D2_704F_OK
	cmp #$00
	bne L_BRS_705C_7054_OK
	jsr L_JSR_70EC_7056_OK
	jmp L_JMP_6A85_7059_OK
//------------------------------
L_BRS_705C_7054_OK:
//------------------------------
	cmp #$01
	bne L_BRS_7066_705E_OK
	jsr L_JSR_7067_7060_OK
	jmp L_JMP_6A85_7063_OK
//------------------------------
L_BRS_7066_705E_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_7067_6D7C_OK:
L_JSR_7067_6F65_OK:
L_JSR_7067_7060_OK:
//------------------------------
	jsr L_JSR_9C0F_7067_OK
	lda $69E8 
	pha 
	lda #$20
	sta $51 
	lda #$73
	tax 
	ldy #$01
	jsr L_JSR_6998_7077_OK
	jsr L_JSR_71F7_707A_OK
	jsr L_JSR_9951_707D_OK
	cmp $D3,X 
	cmp $D2 
	ldy #$CE
	.byte $CF,$D4
	ldy #$C1
	cpy $CFCC 
	.byte $D7
	cmp $C4 
	ldy #$D4
	.byte $CF
	sta $C1CD 
	dec $D0C9 
	cmp $CC,X 
	cmp ($D4,X) 
	cmp $A0 
	cmp $D3C1 
	.byte $D4
	cmp $D2 
	ldy #$C4
	cmp #$D3
	.byte $CB
	cmp $D4 
	.byte $D4
	cmp $AE 
	.byte $00
	jsr L_JSR_9951_70B0_OK
	sta $C88D 
	cmp #$D4
	ldy #$C1
	ldy #$CB
	cmp $D9 
	ldy #$D4
	.byte $CF
	ldy #$C3
	.byte $CF
	dec $C9D4 
	dec $C5D5 
	ldy #$00
	jsr L_JSR_9971_70CC_OK
	lda #$00
	jsr L_JSR_997A_70D1_OK
	lda #$00
	sta $1328 
	lda #$40
	sta $51 
	jsr L_JSR_96F8_70DD_OK
	lda #$00
	sta $1300 
	pla 
	tax 
	ldy #$01
	jmp L_JMP_6998_70E9_OK
//------------------------------
L_JSR_70EC_6E20_OK:
L_JSR_70EC_6F58_OK:
L_JSR_70EC_7056_OK:
//------------------------------
	jsr L_JSR_9C0F_70EC_OK
	lda $69E8 
	pha 
	lda #$73
	tax 
	ldy #$01
	jsr L_JSR_6998_70F8_OK
	lda #$20
	sta $51 
	jsr L_JSR_71F7_70FF_OK
	jsr L_JSR_9951_7102_OK
	cpy $C9 
	.byte $D3,$CB
	cmp $D4 
	.byte $D4
	cmp $A0 
	cmp #$CE
	ldy #$C4
	.byte $D2
	cmp #$D6
	cmp $A0 
	cmp #$D3
	ldy #$CE
	.byte $CF,$D4
	ldy #$C1
	sta $CFCC 
	cpy $C5 
	ldy #$D2
	cmp $CE,X 
	dec $D2C5 
	ldy #$C4
	cmp ($D4,X) 
	cmp ($A0,X) 
	cpy $C9 
	.byte $D3,$CB
	ldx $4C00 
	bcs L_BRS_71AA_7138_OK
//------------------------------
L_JSR_713A_6E5A_OK:
//------------------------------
	ldy $50 
	lda $A1B0,Y 
	sta $09 
	lda $A1C0,Y 
	sta $0A 
	ldy $4F 
	lda ($09),Y 
	rts 
//------------------------------
L_JSR_714B_6B3A_OK:
L_JSR_714B_6B53_OK:
L_JSR_714B_6BEA_OK:
L_JSR_714B_6C23_OK:
L_JSR_714B_6C50_OK:
L_JSR_714B_6C6C_OK:
L_JSR_714B_6C81_OK:
//------------------------------
	ldy $1310 
	iny 
	tya 
	jsr L_JSR_9892_7150_OK
	lda $4F 
	sta $1367 
	ldy #$00
//------------------------------
L_BRS_715A_7169_OK:
//------------------------------
	lda $1307,Y 
	sty $1366 
	jsr L_JSR_993C_7160_OK
	ldy $1366 
	iny 
	cpy #$03
	bcc L_BRS_715A_7169_OK
	lda $1367 
	sta $4F 
	ldy #$00
	sty $1366 
//------------------------------
L_JMP_7175_719C_OK:
L_JMP_7175_71AF_OK:
L_BRS_7175_71CF_OK:
L_JMP_7175_71D6_OK:
L_JMP_7175_71DC_OK:
//------------------------------
	ldx $1366 
	lda $1307,X 
	clc 
	adc #$3C
	jsr L_JSR_997A_717E_OK
	jsr L_JSR_723E_7181_OK
	bcc L_BRS_71BE_7184_OK
	cmp #$01
	beq L_BRS_71DF_7188_OK
	cmp #$07
	beq L_BRS_7192_718C_OK
	cmp #$82
	bne L_BRS_719F_7190_OK
//------------------------------
L_BRS_7192_718C_OK:
//------------------------------
	ldx $1366 
	beq L_BRS_71D9_7195_OK
	dec $1366 
	dec $4F 
	jmp L_JMP_7175_719C_OK
//------------------------------
L_BRS_719F_7190_OK:
//------------------------------
	cmp #$02
	bne L_BRS_71B2_71A1_OK
	ldx $1366 
	cpx #$02
	beq L_BRS_71D9_71A8_OK
//------------------------------
L_BRS_71AA_7138_OK:
//------------------------------
	inc $4F 
	inc $1366 
	jmp L_JMP_7175_71AF_OK
//------------------------------
L_BRS_71B2_71A1_OK:
//------------------------------
	cmp #$3F
	bne L_BRS_71B9_71B4_OK
	jmp L_JMP_6AF4_71B6_OK
//------------------------------
L_BRS_71B9_71B4_OK:
//------------------------------
	jsr L_JSR_723E_71B9_OK
	bcs L_BRS_71D9_71BC_OK
//------------------------------
L_BRS_71BE_7184_OK:
//------------------------------
	ldy $1366 
	sta $1307,Y 
	jsr L_JSR_993C_71C4_OK
	inc $1366 
	lda $1366 
	cmp #$03
	bcc L_BRS_7175_71CF_OK
	dec $1366 
	dec $4F 
	jmp L_JMP_7175_71D6_OK
//------------------------------
L_BRS_71D9_7195_OK:
L_BRS_71D9_71A8_OK:
L_BRS_71D9_71BC_OK:
//------------------------------
	jsr L_JSR_9971_71D9_OK
	jmp L_JMP_7175_71DC_OK
//------------------------------
L_BRS_71DF_7188_OK:
//------------------------------
	lda $1367 
	clc 
	adc #$03
	sta $4F 
	jsr L_JSR_98B4_71E7_OK
	bcs L_BRS_71F6_71EA_OK
	sta $1305 
	tay 
	dey 
	sty $1310 
	cpy #$96
//------------------------------
L_BRS_71F6_71EA_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_71F7_6A99_OK:
L_JSR_71F7_6E30_OK:
L_JSR_71F7_6F5B_OK:
L_JSR_71F7_6F68_OK:
L_JSR_71F7_707A_OK:
L_JSR_71F7_70FF_OK:
L_JSR_71F7_726D_OK:
L_JSR_71F7_7589_OK:
L_JSR_71F7_91F4_OK:
L_JSR_71F7_9274_OK:
L_JSR_71F7_92F7_OK:
L_JSR_71F7_93F4_OK:
//------------------------------
	lda #$00
	sta $4F 
	sta $136C 
	sta $50 
	sta $136B 
	rts 
//------------------------------
L_JSR_7204_6421_OK:
L_JSR_7204_6EF0_OK:
L_JSR_7204_6FA7_OK:
L_JSR_7204_6FC1_OK:
L_JSR_7204_7001_OK:
//------------------------------
	lda $4F 
	sta $136C 
	lda $50 
	sta $136B 
	rts 
//------------------------------
L_JSR_720F_6441_OK:
L_JSR_720F_6E54_OK:
L_JSR_720F_6F76_OK:
L_JSR_720F_6FAD_OK:
L_JSR_720F_6FD9_OK:
L_JSR_720F_7038_OK:
L_JSR_720F_7048_OK:
L_JSR_720F_82D5_OK:
//------------------------------
	lda $136B 
	sta $50 
	lda $136C 
	sta $4F 
	rts 
//------------------------------
L_JSR_721A_6424_OK:
L_JSR_721A_6464_OK:
L_JSR_721A_6FC4_OK:
L_JSR_721A_7004_OK:
L_JSR_721A_797F_OK:
L_JSR_721A_9807_OK:
//------------------------------
	lda #$10
	sta $50 
	lda #$0D
	sta $4F 
	rts 
//------------------------------
L_JSR_7223_65BD_OK:
L_JSR_7223_73C0_OK:
L_JSR_7223_9784_OK:
//------------------------------
	lda #$10
	sta $50 
	lda #$00
	sta $4F 
	rts 
//------------------------------
L_JSR_722C_6B07_OK:
L_JSR_722C_6C9F_OK:
L_JSR_722C_6CCB_OK:
L_JSR_722C_6D6C_OK:
L_JSR_722C_6DF6_OK:
//------------------------------
	lda #$00
	jsr L_JSR_997A_722E_OK
	ldx #$00
	stx $1328 
	cmp #$3F
	bne L_BRS_723D_7238_OK
	jmp L_JMP_6AF4_723A_OK
//------------------------------
L_BRS_723D_7238_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_723E_6E60_OK:
L_JSR_723E_7181_OK:
L_JSR_723E_71B9_OK:
//------------------------------
	lda $1328 
	ldy #$00
	sty $1328 
//------------------------------
L_JSR_7246_7705_OK:
//------------------------------
	ldy #$09
//------------------------------
L_BRS_7248_724E_OK:
//------------------------------
	cmp $A043,Y 
	beq L_BRS_7252_724B_OK
	dey 
	bpl L_BRS_7248_724E_OK
	sec 
	rts 
//------------------------------
L_BRS_7252_724B_OK:
//------------------------------
	tya 
	clc 
	rts 
//------------------------------
L_BRS_7255_725C_OK:
//------------------------------
	clc 
	rts 
//------------------------------
L_JSR_7257_62AC_OK:
//------------------------------
	lda $1305 
	cmp #$97
	bcc L_BRS_7255_725C_OK
	jsr L_JSR_9C0F_725E_OK
	lda #$20
	sta $51 
	lda #$73
	tax 
	ldy #$01
	jsr L_JSR_6998_726A_OK
	jsr L_JSR_71F7_726D_OK
	jsr L_JSR_9951_7270_OK
	sta $AD8D 
	lda $ADAD 
	lda $C3A0 
	.byte $CF
	dec $D2C7 
	cmp ($D4,X) 
	cmp $CC,X 
	cmp ($D4,X) 
	cmp #$CF
	dec $A0D3 
	lda $ADAD 
	lda $8DAD 
	sta $A0A0 
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$D9
	.byte $CF
	cmp $A0,X 
	cmp ($D2,X) 
	cmp $A0 
	cmp ($8D,X) 
	ldy #$A0
	ldy #$CC
	.byte $CF
	cpy $C5 
	ldy #$D2
	cmp $CE,X 
	dec $D2C5 
	ldy #$D3
	.byte $CF
	dec $C5,X 
	.byte $D2
	cmp $C9 
	.byte $C7
	dec $8D8D 
	lda $ADAD 
	lda $A0AD 
	.byte $C3,$CF
	dec $D2C7 
	cmp ($D4,X) 
	cmp $CC,X 
	cmp ($D4,X) 
	cmp #$CF
	dec $A0D3 
	lda $ADAD 
	lda $00AD 
	lda $11C7 
	cmp $130D 
	beq L_BRS_72E8_72E1_OK
	bcs L_BRS_730A_72E3_OK
	jmp L_JMP_730F_72E5_OK
//------------------------------
L_BRS_72E8_72E1_OK:
//------------------------------
	lda $11C6 
	cmp $130C 
	beq L_BRS_72F5_72EE_OK
	bcs L_BRS_730A_72F0_OK
	jmp L_JMP_730F_72F2_OK
//------------------------------
L_BRS_72F5_72EE_OK:
//------------------------------
	lda $11C5 
	cmp $130B 
	beq L_BRS_7302_72FB_OK
	bcs L_BRS_730A_72FD_OK
	jmp L_JMP_730F_72FF_OK
//------------------------------
L_BRS_7302_72FB_OK:
//------------------------------
	lda $11C4 
	cmp $130A 
	bcc L_BRS_730F_7308_OK
//------------------------------
L_BRS_730A_72E3_OK:
L_BRS_730A_72F0_OK:
L_BRS_730A_72FD_OK:
//------------------------------
	lda #$00
	jmp L_JMP_73AE_730C_OK
//------------------------------
L_JMP_730F_72E5_OK:
L_JMP_730F_72F2_OK:
L_JMP_730F_72FF_OK:
L_BRS_730F_7308_OK:
//------------------------------
	lda #$20
	lda #$55
	ldx #$A0
//------------------------------
L_BRS_7315_7319_OK:
//------------------------------
	sta $04C8,X 
	dex 
	bne L_BRS_7315_7319_OK
	lda #$00
	sta $4F 
	lda #$09
	sta $50 
	jsr L_JSR_9951_7323_OK
	cmp $D5CF,Y 
	.byte $D2
	ldy #$D3
	.byte $C3,$CF,$D2
	cmp $A0 
	cmp #$D3
	ldy #$D4
	iny 
	cmp $A0 
	.byte $C2
	cmp $D3 
	.byte $D4
	ldy #$C5
	dec $C5,X 
	.byte $D2
	sta $A08D 
	cmp $CE 
	.byte $D4
	cmp $D2 
	ldy #$D4
	iny 
	cmp $A0 
	dec $C9,X 
	.byte $C3,$D4,$CF,$D2
	cmp $CDA0,Y 
	cmp $D3 
	.byte $D3
	cmp ($C7,X) 
	cmp $8D 
	sta $A0A0 
	ldy #$BE
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$BC
	.byte $00
	lda #$04
	sta $4F 
	sec 
	ldy #$13
	jsr L_JSR_76D2_737F_OK
	beq L_BRS_73AE_7382_OK
	ldx #$13
//------------------------------
L_BRS_7386_738D_OK:
//------------------------------
	lda $133D,X 
	sta $11B0,X 
	dex 
	bpl L_BRS_7386_738D_OK
	lda $130A 
	sta $11C4 
	lda $130B 
	sta $11C5 
	lda $130C 
	sta $11C6 
	lda $130D 
	sta $11C7 
	lda #$02
	jsr L_JSR_78D2_73A9_OK
	lda #$01
//------------------------------
L_JMP_73AE_730C_OK:
L_BRS_73AE_7382_OK:
//------------------------------
	sec 
	rts 
//------------------------------
L_BRS_73B0_73BE_OK:
L_BRS_73B0_73F2_OK:
//------------------------------
	clc 
	rts 
//------------------------------
L_JSR_73B2_64F5_OK:
L_JMP_73B2_76B6_OK:
//------------------------------
	lda $11C7 
	ora $11C6
	ora $11C5
	ora $11C4
	beq L_BRS_73B0_73BE_OK
	jsr L_JSR_7223_73C0_OK
	ldx #$00
	stx $1E 
	stx $132B 
	lda #$20
	sta $51 
	ldy #$27
	lda #$73
//------------------------------
L_BRS_73D2_73D6_OK:
//------------------------------
	sta $0798,Y 
	dey 
	bpl L_BRS_73D2_73D6_OK
//------------------------------
L_BRS_73D8_73EE_OK:
//------------------------------
	lda $11B0,X 
	pha 
	eor #$A0
	ora $1E
	sta $1E 
	pla 
	jsr L_JSR_991C_73E3_OK
	inc $132B 
	ldx $132B 
	cpx #$13
	bcc L_BRS_73D8_73EE_OK
	lda $1E 
	beq L_BRS_73B0_73F2_OK
	inc $4F 
	lda $11C7 
	jsr L_JSR_966E_73F9_OK
	lda $11C6 
	jsr L_JSR_966E_73FF_OK
	lda $11C5 
	jsr L_JSR_966E_7405_OK
	lda $11C4 
	jsr L_JSR_966E_740B_OK
	sec 
	rts 
//------------------------------
L_JSR_7410_62A7_OK:
//------------------------------
	lda $1318 
	beq L_BRS_7477_7413_OK
	lda $130A 
	ora $130B
	ora $130C
	ora $130D
	beq L_BRS_7477_7421_OK
	lda #$01
	jsr L_JSR_78D2_7425_OK
	beq L_BRS_7477_7428_OK
	ldy #$01
	lda $1100 
	cmp #$00
	beq L_BRS_7479_7431_OK
//------------------------------
L_BRS_7433_7475_OK:
//------------------------------
	ldx $A038,Y 
	lda $1305 
	cmp $1103,X 
	bcc L_BRS_7472_743C_OK
	bne L_BRS_7479_743E_OK
	lda $130D 
	cmp $1104,X 
	bcc L_BRS_7472_7446_OK
	bne L_BRS_7479_7448_OK
	lda $130C 
	cmp $1105,X 
	bcc L_BRS_7472_7450_OK
	bne L_BRS_7479_7452_OK
	lda $130B 
	cmp $1106,X 
	bcc L_BRS_7472_745A_OK
	bne L_BRS_7479_745C_OK
	lda $130A 
	cmp $1107,X 
	bcc L_BRS_7472_7464_OK
	bne L_BRS_7479_7466_OK
	lda $1312 
	cmp $1155,X 
	bcc L_BRS_7472_746E_OK
	bne L_BRS_7479_7470_OK
//------------------------------
L_BRS_7472_743C_OK:
L_BRS_7472_7446_OK:
L_BRS_7472_7450_OK:
L_BRS_7472_745A_OK:
L_BRS_7472_7464_OK:
L_BRS_7472_746E_OK:
//------------------------------
	iny 
	cpy #$0B
	bcc L_BRS_7433_7475_OK
//------------------------------
L_BRS_7477_7413_OK:
L_BRS_7477_7421_OK:
L_BRS_7477_7428_OK:
//------------------------------
	clc 
	rts 
//------------------------------
L_BRS_7479_7431_OK:
L_BRS_7479_743E_OK:
L_BRS_7479_7448_OK:
L_BRS_7479_7452_OK:
L_BRS_7479_745C_OK:
L_BRS_7479_7466_OK:
L_BRS_7479_7470_OK:
L_BRS_7479_7484_OK:
//------------------------------
	sty $29 
	cpy #$0A
	beq L_BRS_74A7_747D_OK
	ldy $1100 
	cpy #$FF
	beq L_BRS_7479_7484_OK
	ldy #$09
//------------------------------
L_BRS_7488_74A5_OK:
//------------------------------
	ldx $A038,Y 
	lda #$08
	sta $22 
//------------------------------
L_BRS_748F_749E_OK:
//------------------------------
	lda $1100,X 
	sta $1108,X 
	lda $1150,X 
	sta $1158,X 
	inx 
	dec $22 
	bne L_BRS_748F_749E_OK
	cpy $29 
	beq L_BRS_74A7_74A2_OK
	dey 
	bne L_BRS_7488_74A5_OK
//------------------------------
L_BRS_74A7_747D_OK:
L_BRS_74A7_74A2_OK:
//------------------------------
	sty $39 
	ldx $A038,Y 
	lda #$A0
	sta $1100,X 
	sta $1101,X 
	sta $1102,X 
	sta $1150,X 
	sta $1151,X 
	sta $1152,X 
	sta $1153,X 
	sta $1154,X 
	lda $1305 
	sta $1103,X 
	lda $130A 
	sta $1107,X 
	lda $130B 
	sta $1106,X 
	lda $130C 
	sta $1105,X 
	lda $130D 
	sta $1104,X 
	lda $1312 
	sta $1155,X 
	jsr L_JSR_7579_74EA_OK
	lda #$03
	sta $4F 
	lda #$04
	clc 
	adc $39 
	sta $50 
	lda #$1D
	sta $9B8C 
	lda #$9F
	sta $9B8D 
	sec 
	ldy #$08
	jsr L_JSR_76D2_7505_OK
	lda #$2E
	sta $9B8C 
	lda #$9F
	sta $9B8D 
	ldy $39 
	ldx $A038,Y 
	lda $133D 
	sta $1100,X 
	lda $133E 
	sta $1101,X 
	lda $133F 
	sta $1102,X 
	lda $1340 
	sta $1150,X 
	lda $1341 
	sta $1151,X 
	lda $1342 
	sta $1152,X 
	lda $1343 
	sta $1153,X 
	lda $1344 
	sta $1154,X 
	lda #$02
	jsr L_JSR_78D2_7549_OK
	sec 
	rts 
//------------------------------
L_JSR_754E_7586_OK:
//------------------------------
	lda #$00
	sta $44 
	lda #$04
	sta $45 
	ldx #$00
//------------------------------
L_BRS_7558_7576_OK:
//------------------------------
	ldy #$27
	lda $A020,X 
//------------------------------
L_BRS_755D_7566_OK:
//------------------------------
	sta ($44),Y 
	cpy #$06
	bne L_BRS_7565_7561_OK
	lda #$11
//------------------------------
L_BRS_7565_7561_OK:
//------------------------------
	dey 
	bpl L_BRS_755D_7566_OK
	lda #$28
	clc 
	adc $44 
	sta $44 
	bcc L_BRS_7573_756F_OK
	inc $45 
//------------------------------
L_BRS_7573_756F_OK:
//------------------------------
	inx 
	cpx #$17
	bne L_BRS_7558_7576_OK
	rts 
//------------------------------
L_JSR_7579_6236_OK:
L_JSR_7579_6BB0_OK:
L_JSR_7579_74EA_OK:
//------------------------------
	jsr L_JSR_9C0F_7579_OK
//------------------------------
L_JSR_757C_6353_OK:
//------------------------------
	lda #$1D
	sta $9B8C 
	lda #$9F
	sta $9B8D 
	jsr L_JSR_754E_7586_OK
	jsr L_JSR_71F7_7589_OK
	jsr L_JSR_9951_758C_OK
	ldy #$A0
	ldy #$A0
	ldy #$CC
	.byte $CF
	cpy $C5 
	ldy #$D2
	cmp $CE,X 
	dec $D2C5 
	ldy #$C8
	cmp #$C7
	iny 
	ldy #$D3
	.byte $C3,$CF,$D2
	cmp $D3 
	sta $8D8D 
	ldy #$A0
	ldy #$A0
	ldy #$CE
	cmp ($CD,X) 
	cmp $A0 
	ldy #$A0
	cpy $CCD6 
	ldy #$A0
	.byte $D3,$C3,$CF,$D2
	cmp $D3 
	ldy #$A0
	cmp $CEC5 
	sta $A0A0 
	ldy #$AD
	lda $ADAD 
	lda $ADAD 
	lda $ADA0 
	lda $A0AD 
	lda $ADAD 
	lda $ADAD 
	lda $A0AD 
	lda $ADAD 
	sta $A900 
	ora ($85,X)
	plp 
//------------------------------
L_JMP_75ED_76A9_OK:
//------------------------------
	cmp #$0A
	bne L_BRS_75FE_75EF_OK
	lda #$01
	jsr L_JSR_993C_75F3_OK
	lda #$00
	jsr L_JSR_993C_75F8_OK
	jmp L_JMP_7608_75FB_OK
//------------------------------
L_BRS_75FE_75EF_OK:
//------------------------------
	lda #$A0
	jsr L_JSR_991C_7600_OK
	lda $28 
	jsr L_JSR_993C_7605_OK
//------------------------------
L_JMP_7608_75FB_OK:
//------------------------------
	jsr L_JSR_9951_7608_OK
	ldx $A600 
	plp 
	ldy $A038,X 
	sty $29 
	lda $1103,Y 
	bne L_BRS_761C_7617_OK
	jmp L_JMP_769B_7619_OK
//------------------------------
L_BRS_761C_7617_OK:
//------------------------------
	ldy $29 
	lda $1100,Y 
	jsr L_JSR_76B9_7621_OK
	ldy $29 
	lda $1101,Y 
	jsr L_JSR_76B9_7629_OK
	ldy $29 
	lda $1102,Y 
	jsr L_JSR_76B9_7631_OK
	ldy $29 
	lda $1150,Y 
	jsr L_JSR_76B9_7639_OK
	ldy $29 
	lda $1151,Y 
	jsr L_JSR_76B9_7641_OK
	ldy $29 
	lda $1152,Y 
	jsr L_JSR_76B9_7649_OK
	ldy $29 
	lda $1153,Y 
	jsr L_JSR_76B9_7651_OK
	ldy $29 
	lda $1154,Y 
	jsr L_JSR_76B9_7659_OK
	jsr L_JSR_9951_765C_OK
	ldy #$00
	ldy $29 
	lda $1103,Y 
	jsr L_JSR_9674_7666_OK
	jsr L_JSR_9951_7669_OK
	ldy #$00
	ldy $29 
	lda $1104,Y 
	jsr L_JSR_966E_7673_OK
	ldy $29 
	lda $1105,Y 
	jsr L_JSR_966E_767B_OK
	ldy $29 
	lda $1106,Y 
	jsr L_JSR_966E_7683_OK
	ldy $29 
	lda $1107,Y 
	jsr L_JSR_966E_768B_OK
	jsr L_JSR_9951_768E_OK
	ldy #$00
	ldy $29 
	lda $1155,Y 
	jsr L_JSR_9674_7698_OK
//------------------------------
L_JMP_769B_7619_OK:
//------------------------------
	inc $50 
	lda #$00
	sta $4F 
	inc $28 
	lda $28 
	cmp #$0B
	bcs L_BRS_76AC_76A7_OK
	jmp L_JMP_75ED_76A9_OK
//------------------------------
L_BRS_76AC_76A7_OK:
//------------------------------
	lda #$2E
	sta $9B8C 
	lda #$9F
	sta $9B8D 
	jmp L_JMP_73B2_76B6_OK
//------------------------------
L_JSR_76B9_7621_OK:
L_JSR_76B9_7629_OK:
L_JSR_76B9_7631_OK:
L_JSR_76B9_7639_OK:
L_JSR_76B9_7641_OK:
L_JSR_76B9_7649_OK:
L_JSR_76B9_7651_OK:
L_JSR_76B9_7659_OK:
L_JSR_76B9_955F_OK:
L_JSR_76B9_95C8_OK:
L_JSR_76B9_95CD_OK:
L_JSR_76B9_995F_OK:
//------------------------------
	cmp #$0A
	bcc L_BRS_76CC_76BB_OK
	cmp #$3C
	bcc L_BRS_76C7_76BF_OK
	cmp #$46
	bcc L_BRS_76CF_76C3_OK
	bcs L_BRS_76C9_76C5_OK
//------------------------------
L_BRS_76C7_76BF_OK:
//------------------------------
	lda #$A0
//------------------------------
L_BRS_76C9_76C5_OK:
//------------------------------
	jmp L_JMP_991C_76C9_OK
//------------------------------
L_BRS_76CC_76BB_OK:
//------------------------------
	jmp L_JMP_993C_76CC_OK
//------------------------------
L_BRS_76CF_76C3_OK:
//------------------------------
	jmp L_JMP_993F_76CF_OK
//------------------------------
L_JSR_76D2_6FD6_OK:
L_JSR_76D2_737F_OK:
L_JSR_76D2_7505_OK:
L_JSR_76D2_92DA_OK:
L_JSR_76D2_935B_OK:
L_JSR_76D2_9447_OK:
//------------------------------
	sty $1354 
	bcc L_BRS_76E1_76D5_OK
	lda #$A0
	ldx #$13
//------------------------------
L_BRS_76DB_76DF_OK:
//------------------------------
	sta $133D,X 
	dex 
	bpl L_BRS_76DB_76DF_OK
//------------------------------
L_BRS_76E1_76D5_OK:
//------------------------------
	ldx #$00
	stx $1366 
	stx $1328 
//------------------------------
L_JMP_76E9_7727_OK:
L_JMP_76E9_773C_OK:
L_JMP_76E9_7779_OK:
L_JMP_76E9_777F_OK:
//------------------------------
	ldx $1366 
	lda $133D,X 
	cmp #$3C
	bcc L_BRS_76F7_76F1_OK
	cmp #$46
	bcc L_BRS_76FA_76F5_OK
//------------------------------
L_BRS_76F7_76F1_OK:
//------------------------------
	jsr L_JSR_98D5_76F7_OK
//------------------------------
L_BRS_76FA_76F5_OK:
//------------------------------
	jsr L_JSR_997A_76FA_OK
	lda $1328 
	ldy #$00
	sty $1328 
	jsr L_JSR_7246_7705_OK
	bcc L_BRS_775B_7708_OK
	cmp #$3F
	bne L_BRS_7712_770C_OK
	sec 
	ldx #$00
	rts 
//------------------------------
L_BRS_7712_770C_OK:
//------------------------------
	jsr L_JSR_7797_7712_OK
	cmp #$8D
	beq L_BRS_7782_7717_OK
	cmp #$88
	bne L_BRS_772A_771B_OK
	ldx $1366 
	beq L_BRS_777C_7720_OK
	dec $1366 
	dec $4F 
	jmp L_JMP_76E9_7727_OK
//------------------------------
L_BRS_772A_771B_OK:
//------------------------------
	cmp #$95
	bne L_BRS_773F_772C_OK
	ldx $1354 
	dex 
	cpx $1366 
	beq L_BRS_777C_7735_OK
	inc $4F 
	inc $1366 
	jmp L_JMP_76E9_773C_OK
//------------------------------
L_BRS_773F_772C_OK:
//------------------------------
	cmp #$A0
	beq L_BRS_774F_7741_OK
	cmp #$AE
	beq L_BRS_774F_7745_OK
	cmp #$C1
	bcc L_BRS_777C_7749_OK
	cmp #$DB
	bcs L_BRS_777C_774D_OK
//------------------------------
L_BRS_774F_7741_OK:
L_BRS_774F_7745_OK:
//------------------------------
	ldy $1366 
	sta $133D,Y 
	jsr L_JSR_991C_7755_OK
	jmp L_JMP_7767_7758_OK
//------------------------------
L_BRS_775B_7708_OK:
//------------------------------
	clc 
	adc #$68
	ldy $1366 
	sta $133D,Y 
	jsr L_JSR_993F_7764_OK
//------------------------------
L_JMP_7767_7758_OK:
//------------------------------
	lsr $5A 
	inc $1366 
	lda $1366 
	cmp $1354 
	bcc L_BRS_7779_7772_OK
	dec $1366 
	dec $4F 
//------------------------------
L_BRS_7779_7772_OK:
//------------------------------
	jmp L_JMP_76E9_7779_OK
//------------------------------
L_BRS_777C_7720_OK:
L_BRS_777C_7735_OK:
L_BRS_777C_7749_OK:
L_BRS_777C_774D_OK:
//------------------------------
	jsr L_JSR_9971_777C_OK
	jmp L_JMP_76E9_777F_OK
//------------------------------
L_BRS_7782_7717_OK:
//------------------------------
	ldx $1354 
//------------------------------
L_BRS_7785_778D_OK:
//------------------------------
	lda $133D,X 
	cmp #$A0
	bne L_BRS_7793_778A_OK
	dex 
	bpl L_BRS_7785_778D_OK
	clc 
	ldx #$00
	rts 
//------------------------------
L_BRS_7793_778A_OK:
//------------------------------
	clc 
	ldx #$01
	rts 
//------------------------------
L_JSR_7797_7712_OK:
//------------------------------
	cmp #$82
	bne L_BRS_779D_7799_OK
	lda #$07
//------------------------------
L_BRS_779D_7799_OK:
//------------------------------
	tay 
	lda $A04D,Y 
	ora #$80
	rts 
//------------------------------
L_JSR_77A4_60D0_OK:
L_JSR_77A4_6E4C_OK:
L_JMP_77A4_784C_OK:
//------------------------------
	stx $1300 
	ldx #$FF
	stx $03 
	inx 
	stx $1301 
	stx $130E 
	stx $131C 
	stx $131F 
	stx $1E 
	stx $50 
	stx $53 
	stx $54 
	txa 
	ldx #$1E
//------------------------------
L_BRS_77C3_77C7_OK:
//------------------------------
	sta $12E0,X 
	dex 
	bpl L_BRS_77C3_77C7_OK
	ldx #$05
//------------------------------
L_BRS_77CB_77CF_OK:
//------------------------------
	sta $1298,X 
	dex 
	bpl L_BRS_77CB_77CF_OK
	lda #$01
	sta $1314 
	lda $1310 
	cmp $133B 
	beq L_BRS_77E3_77DC_OK
	lda #$01
	jsr L_JSR_7896_77E0_OK
//------------------------------
L_BRS_77E3_77DC_OK:
//------------------------------
	lda $1310 
	sta $133B 
	ldy $50 
//------------------------------
L_BRS_77EB_7830_OK:
//------------------------------
	lda $A1B0,Y 
	sta $09 
	sta $0B 
	lda $A1C0,Y 
	sta $0A 
	lda $A1D0,Y 
	sta $0C 
	lda #$00
	sta $4F 
//------------------------------
L_BRS_7800_7828_OK:
//------------------------------
	lda $1E 
	lsr 
	ldy $53 
	lda $1000,Y 
	bcs L_BRS_780E_7808_OK
	and #$0F
	bpl L_BRS_7814_780C_OK
//------------------------------
L_BRS_780E_7808_OK:
//------------------------------
	lsr 
	lsr 
	lsr 
	lsr 
	inc $53 
//------------------------------
L_BRS_7814_780C_OK:
//------------------------------
	inc $1E 
	ldy $4F 
	cmp #$0A
	bcc L_BRS_781E_781A_OK
	lda #$00
//------------------------------
L_BRS_781E_781A_OK:
//------------------------------
	sta ($09),Y 
	sta ($0B),Y 
	inc $4F 
	lda $4F 
	cmp #$1C
	bcc L_BRS_7800_7828_OK
	inc $50 
	ldy $50 
	cpy #$10
	bcc L_BRS_77EB_7830_OK
	jsr L_JSR_7B46_7832_OK
	bcc L_BRS_784F_7835_OK
	lda $1310 
	beq L_BRS_7850_783A_OK
	ldx #$00
	stx $1310 
	lda $1311 
	cmp #$0A
	bcs L_BRS_784B_7846_OK
	inc $1311 
//------------------------------
L_BRS_784B_7846_OK:
//------------------------------
	dex 
	jmp L_JMP_77A4_784C_OK
//------------------------------
L_BRS_784F_7835_OK:
//------------------------------
	rts 
//------------------------------
L_BRS_7850_783A_OK:
//------------------------------
	jmp L_JMP_6021_7850_OK
//------------------------------
L_JSR_7853_6EF3_OK:
L_JSR_7853_6F6E_OK:
//------------------------------
	lda #$00
	sta $53 
	sta $1E 
	sta $50 
//------------------------------
L_BRS_785B_7893_OK:
//------------------------------
	ldy $50 
	lda $A1B0,Y 
	sta $09 
	lda $A1C0,Y 
	sta $0A 
	ldy #$00
	sty $4F 
//------------------------------
L_BRS_786B_788B_OK:
//------------------------------
	lda $1E 
	lsr 
	lda ($09),Y 
	bcs L_BRS_7876_7870_OK
	sta $23 
	bpl L_BRS_7883_7874_OK
//------------------------------
L_BRS_7876_7870_OK:
//------------------------------
	asl A 
	asl A 
	asl A 
	asl A 
	ora $23
	ldy $53 
	sta $1000,Y 
	inc $53 
//------------------------------
L_BRS_7883_7874_OK:
//------------------------------
	inc $1E 
	inc $4F 
	ldy $4F 
	cpy #$1C
	bcc L_BRS_786B_788B_OK
	inc $50 
	lda $50 
	cmp #$10
	bcc L_BRS_785B_7893_OK
	rts 
//------------------------------
L_JSR_7896_6B76_OK:
L_JSR_7896_6B86_OK:
L_JSR_7896_6B91_OK:
L_JSR_7896_6BA5_OK:
L_JSR_7896_6C36_OK:
L_JSR_7896_6CAD_OK:
L_JSR_7896_6CD9_OK:
L_JSR_7896_6D88_OK:
L_JSR_7896_6F73_OK:
L_JSR_7896_77E0_OK:
L_JSR_7896_78E9_OK:
L_JSR_7896_79CE_OK:
L_JSR_7896_91D5_OK:
L_JSR_7896_92F1_OK:
L_JSR_7896_93C8_OK:
L_JSR_7896_93D5_OK:
L_JSR_7896_94AC_OK:
L_JSR_7896_94B9_OK:
L_JSR_7896_9612_OK:
//------------------------------
	sta $133A 
	lda $1306 
	lsr 
	beq L_BRS_78A2_789D_OK
	jmp L_JMP_799D_789F_OK
//------------------------------
L_BRS_78A2_789D_OK:
//------------------------------
	lda $1310 
	cmp #$04
	bcc L_BRS_78AE_78A7_OK
	lda #$00
	sta $1310 
//------------------------------
L_BRS_78AE_78A7_OK:
//------------------------------
	asl A 
	tay 
	lda $A6BF,Y 
	sta $78C9 
	lda $A6C0,Y 
	sta $78CA 
	lda $A6C7,Y 
	sta $55 
	lda $A6C8,Y 
	sta $56 
	ldy #$00
//------------------------------
L_BRS_78C8_78CF_OK:
//------------------------------
	lda $A936,Y 
	sta $1000,Y 
	iny 
	bne L_BRS_78C8_78CF_OK
	rts 
//------------------------------
L_JSR_78D2_6015_OK:
L_JSR_78D2_601E_OK:
L_JSR_78D2_6D75_OK:
L_JSR_78D2_6DFF_OK:
L_JSR_78D2_6E1A_OK:
L_JSR_78D2_6F51_OK:
L_JSR_78D2_704F_OK:
L_JSR_78D2_73A9_OK:
L_JSR_78D2_7425_OK:
L_JSR_78D2_7549_OK:
L_JSR_78D2_79EC_OK:
L_JSR_78D2_9690_OK:
//------------------------------
	tax 
	lda $1310 
	pha 
	lda $7A2C 
	pha 
	lda #$11
	sta $7A2C 
	sta $7A46 
	lda #$97
	sta $1310 
	txa 
	jsr L_JSR_7896_78E9_OK
	pla 
	sta $7A2C 
	sta $7A46 
	pla 
	sta $1310 
	ldy #$0A
//------------------------------
L_BRS_78F9_7902_OK:
//------------------------------
	lda $11F0,Y 
	cmp $A08D,Y 
	bne L_BRS_790E_78FF_OK
	dey 
	bpl L_BRS_78F9_7902_OK
	lda #$01
	ldx $11FB 
	bne L_BRS_7928_7909_OK
	lda #$FF
	rts 
//------------------------------
L_BRS_790E_78FF_OK:
//------------------------------
	ldy #$00
	tya 
//------------------------------
L_BRS_7911_7915_OK:
//------------------------------
	sta $1100,Y 
	dey 
	bne L_BRS_7911_7915_OK
	ldy #$0A
//------------------------------
L_BRS_7919_7920_OK:
//------------------------------
	lda $A08D,Y 
	sta $11F0,Y 
	dey 
	bpl L_BRS_7919_7920_OK
	iny 
	sty $11FB 
	lda #$00
//------------------------------
L_BRS_7928_7909_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_7929_6FAA_OK:
L_JSR_7929_8217_OK:
//------------------------------
	lda $135B 
	ldx #$09
	jsr L_JSR_7AAE_792E_OK
	bcs L_BRS_794C_7931_OK
	jsr L_JSR_7A33_7933_OK
	lda #$D8
	sta $798D 
	lda #$CD
	sta $798E 
	lda #$C9
	sta $798F 
	jsr L_JSR_7955_7945_OK
	inc $135B 
	rts 
//------------------------------
L_BRS_794C_7931_OK:
//------------------------------
	jsr L_JSR_9971_794C_OK
	jsr L_JSR_9971_794F_OK
	jmp L_JMP_7B2D_7952_OK
//------------------------------
L_JSR_7955_7945_OK:
L_JMP_7955_847A_OK:
L_JMP_7955_84C2_OK:
//------------------------------
	ldx $135B 
	inx 
	txa 
	jsr L_JSR_9892_795A_OK
	lda $1307 
	clc 
	adc #$3C
	sta $7989 
	lda $1308 
	clc 
	adc #$3C
	sta $798A 
	lda $1309 
	clc 
	adc #$3C
	sta $798B 
	jsr L_JSR_6A22_7978_OK
	lda #$20
	sta $51 
	jsr L_JSR_721A_797F_OK
	jsr L_JSR_9951_7982_OK
	cpy $CCD6 
	ldy #$A0
	ldy #$A0
	ldy #$D8
	cmp $D4C9 
	ldy #$CF
	.byte $CB,$00
	lda #$77
	sta $6A1A 
	jmp L_JMP_6A17_799A_OK
//------------------------------
L_JMP_799D_789F_OK:
//------------------------------
	lda #$00
	sta $D015 
	lda $1310 
	ldx #$08
	jsr L_JSR_7AAE_79A7_OK
	bcs L_BRS_79F0_79AA_OK
	lda $133A 
	lsr 
	bcs L_BRS_79F3_79B0_OK
	lsr 
	bcc L_BRS_79B8_79B3_OK
	jmp L_JMP_7A33_79B5_OK
//------------------------------
L_BRS_79B8_79B3_OK:
//------------------------------
	ldy #$00
	tya 
//------------------------------
L_BRS_79BB_79C2_OK:
//------------------------------
	sta $1100,Y 
	sta $1000,Y 
	iny 
	bne L_BRS_79BB_79C2_OK
	lda #$95
	sta $1310 
	jsr FFE7
//------------------------------
L_BRS_79CC_79D9_OK:
//------------------------------
	lda #$02
	jsr L_JSR_7896_79CE_OK
	dec $1310 
	lda $1310 
	cmp #$FF
	bne L_BRS_79CC_79D9_OK
	ldy #$0A
//------------------------------
L_BRS_79DD_79E4_OK:
//------------------------------
	lda $A08D,Y 
	sta $11F0,Y 
	dey 
	bpl L_BRS_79DD_79E4_OK
	iny 
	sty $11FB 
	lda #$02
	jsr L_JSR_78D2_79EC_OK
	rts 
//------------------------------
L_BRS_79F0_79AA_OK:
L_BRS_79F0_7A00_OK:
L_BRS_79F0_7A1B_OK:
L_BRS_79F0_7A40_OK:
//------------------------------
	jmp L_JMP_647D_79F0_OK
//------------------------------
L_BRS_79F3_79B0_OK:
//------------------------------
	lda #$31
	sta $A162 
	jsr FFCC
	ldx #$0F
	jsr FFC9
	bcs L_BRS_79F0_7A00_OK
	ldy #$00
//------------------------------
L_JMP_7A04_7A0D_OK:
//------------------------------
	lda $A161,Y 
	beq L_BRS_7A10_7A07_OK
	jsr FFD2
	iny 
	jmp L_JMP_7A04_7A0D_OK
//------------------------------
L_BRS_7A10_7A07_OK:
//------------------------------
	jsr L_JSR_7B08_7A10_OK
	jsr FFCC
	ldx #$02
	jsr FFC6
	bcs L_BRS_79F0_7A1B_OK
	jsr FFCF
	lda $1330 
	bmi L_BRS_7A69_7A23_OK
	ldy #$00
//------------------------------
L_BRS_7A27_7A2E_OK:
//------------------------------
	jsr FFCF
	sta $1000,Y 
	iny 
	bne L_BRS_7A27_7A2E_OK
	jmp L_JMP_7B2D_7A30_OK
//------------------------------
L_JSR_7A33_7933_OK:
L_JMP_7A33_79B5_OK:
//------------------------------
	lda #$32
	sta $A162 
	jsr FFCC
	ldx #$02
	jsr FFC9
	bcs L_BRS_79F0_7A40_OK
	ldy #$00
//------------------------------
L_BRS_7A44_7A4B_OK:
//------------------------------
	lda $1000,Y 
	jsr FFD2
	iny 
	bne L_BRS_7A44_7A4B_OK
	jsr FFCC
	ldx #$0F
	jsr FFC9
	ldy #$00
//------------------------------
L_JMP_7A57_7A60_OK:
//------------------------------
	lda $A161,Y 
	beq L_BRS_7A63_7A5A_OK
	jsr FFD2
	iny 
	jmp L_JMP_7A57_7A60_OK
//------------------------------
L_BRS_7A63_7A5A_OK:
//------------------------------
	jsr L_JSR_7B08_7A63_OK
	jmp L_JMP_7B2D_7A66_OK
//------------------------------
L_BRS_7A69_7A23_OK:
//------------------------------
	ldx #$10
//------------------------------
L_BRS_7A6B_7A96_OK:
//------------------------------
	ldy #$0D
//------------------------------
L_BRS_7A6D_7A8A_OK:
//------------------------------
	jsr FFCF
	sta $132B 
	lsr $132B 
	lsr $132B 
	lsr $132B 
	lsr $132B 
	asl A 
	asl A 
	asl A 
	asl A 
	ora $132B
	sta $1000,Y 
	dey 
	bpl L_BRS_7A6D_7A8A_OK
	lda $7A87 
	clc 
	adc #$0E
	sta $7A87 
	dex 
	bne L_BRS_7A6B_7A96_OK
	ldy #$00
	ldx #$1F
//------------------------------
L_BRS_7A9C_7AA4_OK:
//------------------------------
	jsr FFCF
	sta $10E0,Y 
	iny 
	dex 
	bne L_BRS_7A9C_7AA4_OK
	lda #$00
	sta $7A87 
	jmp L_JMP_7B2D_7AAB_OK
//------------------------------
L_JSR_7AAE_792E_OK:
L_JSR_7AAE_79A7_OK:
//------------------------------
	sta $1365 
	stx $1364 
	jsr FFE7
	lda $1365 
	and #$0F
	tax 
	lda $A190,X 
	sta $A16C 
	lda $A1A0,X 
	sta $A16D 
	lda $1365 
	lsr 
	lsr 
	lsr 
	lsr 
	tax 
	lda $A170,X 
	sta $A169 
	lda $A180,X 
	sta $A16A 
	lda #$00
	jsr FFBD
	lda #$0F
	ldx $1364 
	ldy #$0F
	jsr FFBA
	jsr FFC0
	bcs L_BRS_7B07_7AEF_OK
	lda #$01
	ldx #$5C
	ldy #$A1
	jsr FFBD
	lda #$02
	ldx $1364 
	ldy #$02
	jsr FFBA
	jsr FFC0
//------------------------------
L_BRS_7B07_7AEF_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_7B08_7A10_OK:
L_JSR_7B08_7A63_OK:
//------------------------------
	jsr FFCC
	ldx #$0F
	jsr FFC6
	jsr FFCF
	sta $1E 
	jsr FFCF
	ora $1E
	sta $1E 
//------------------------------
L_BRS_7B1C_7B21_OK:
//------------------------------
	jsr FFCF
	cmp #$0D
	bne L_BRS_7B1C_7B21_OK
	lda $1E 
	cmp #$30
	beq L_BRS_7B2C_7B27_OK
	jmp L_JMP_6021_7B29_OK
//------------------------------
L_BRS_7B2C_7B27_OK:
//------------------------------
	rts 
//------------------------------
L_JMP_7B2D_7952_OK:
L_JMP_7B2D_7A30_OK:
L_JMP_7B2D_7A66_OK:
L_JMP_7B2D_7AAB_OK:
//------------------------------
	jsr FFCC
	ldx #$0F
	jsr FFC9
	ldy #$00
//------------------------------
L_JMP_7B37_7B40_OK:
//------------------------------
	lda $A15D,Y 
	beq L_BRS_7B43_7B3A_OK
	jsr FFD2
	iny 
	jmp L_JMP_7B37_7B40_OK
//------------------------------
L_BRS_7B43_7B3A_OK:
//------------------------------
	jmp FFE7
//------------------------------
L_JSR_7B46_7832_OK:
//------------------------------
	lda #$00
	sta $D015 
	ldy #$0F
	sty $50 
//------------------------------
L_BRS_7B4F_7BCA_OK:
//------------------------------
	lda $A1B0,Y 
	sta $09 
	sta $0B 
	lda $A1C0,Y 
	sta $0A 
	lda $A1D0,Y 
	sta $0C 
	ldy #$1B
	sty $4F 
//------------------------------
L_BRS_7B64_7BCC_OK:
//------------------------------
	lda ($09),Y 
	ldx $1300 
	beq L_BRS_7B89_7B69_OK
	cmp #$06
	bne L_BRS_7B8B_7B6D_OK
	ldx $1301 
	cpx #$7F
	bcs L_BRS_7B83_7B74_OK
	inc $1301 
	inx 
	lda $50 
	sta $C67F,X 
	tya 
	sta $C600,X 
//------------------------------
L_BRS_7B83_7B74_OK:
L_BRS_7B83_7B9D_OK:
L_BRS_7B83_7BD4_OK:
//------------------------------
	lda #$00
	sta ($09),Y 
	sta ($0B),Y 
//------------------------------
L_BRS_7B89_7B69_OK:
//------------------------------
	beq L_BRS_7BF7_7B89_OK
//------------------------------
L_BRS_7B8B_7B6D_OK:
//------------------------------
	cmp #$07
	bne L_BRS_7B94_7B8D_OK
	inc $130E 
	bne L_BRS_7BF7_7B92_OK
//------------------------------
L_BRS_7B94_7B8D_OK:
//------------------------------
	cmp #$08
	bne L_BRS_7BCE_7B96_OK
	ldx $131C 
	cpx #$05
	bcs L_BRS_7B83_7B9D_OK
	inc $131F 
	inc $131C 
	inx 
	tya 
	sta $1260,X 
	lda $50 
	sta $1268,X 
	lda #$00
	sta $1270,X 
	sta $1288,X 
	lda #$02
	sta $1278,X 
	sta $1280,X 
	lda #$00
	sta ($0B),Y 
	jsr L_JSR_99F6_7BC3_OK
	lda #$08
	bne L_BRS_7BF7_7BC8_OK
//------------------------------
L_BRS_7BCA_7C04_OK:
//------------------------------
	bpl L_BRS_7B4F_7BCA_OK
//------------------------------
L_BRS_7BCC_7BFE_OK:
//------------------------------
	bpl L_BRS_7B64_7BCC_OK
//------------------------------
L_BRS_7BCE_7B96_OK:
//------------------------------
	cmp #$09
	bne L_BRS_7BF1_7BD0_OK
	ldx $03 
	bpl L_BRS_7B83_7BD4_OK
	sty $03 
	ldx $50 
	stx $04 
	ldx #$02
	stx $05 
	stx $06 
	ldx #$08
	stx $07 
	lda #$00
	sta ($0B),Y 
	jsr L_JSR_99F6_7BEA_OK
	lda #$10
	bne L_BRS_7BF7_7BEF_OK
//------------------------------
L_BRS_7BF1_7BD0_OK:
//------------------------------
	cmp #$05
	bne L_BRS_7BF7_7BF3_OK
	lda #$01
//------------------------------
L_BRS_7BF7_7B89_OK:
L_BRS_7BF7_7B92_OK:
L_BRS_7BF7_7BC8_OK:
L_BRS_7BF7_7BEF_OK:
L_BRS_7BF7_7BF3_OK:
//------------------------------
	jsr L_JSR_99F6_7BF7_OK
	dec $4F 
	ldy $4F 
	bpl L_BRS_7BCC_7BFE_OK
	dec $50 
	ldy $50 
	bpl L_BRS_7BCA_7C04_OK
	lda $1300 
	beq L_BRS_7C11_7C09_OK
	lda $03 
	bpl L_BRS_7C4E_7C0D_OK
	sec 
	rts 
//------------------------------
L_BRS_7C11_7C09_OK:
L_JSR_7C11_7C55_OK:
//------------------------------
	lda $1306 
	cmp #$05
	beq L_BRS_7C1E_7C16_OK
	jsr L_JSR_69AA_7C18_OK
	jsr L_JSR_69E5_7C1B_OK
//------------------------------
L_BRS_7C1E_7C16_OK:
//------------------------------
	lda $07A9 
	cmp $07AA 
	bne L_BRS_7C29_7C24_OK
	jsr L_JSR_6A22_7C26_OK
//------------------------------
L_BRS_7C29_7C24_OK:
//------------------------------
	lda #$20
	sta $12 
	lda #$40
	sta $10 
	lda #$00
	sta $11 
	sta $0F 
	tay 
//------------------------------
L_BRS_7C38_7C3D_OK:
L_BRS_7C38_7C47_OK:
//------------------------------
	lda ($0F),Y 
	sta ($11),Y 
	iny 
	bne L_BRS_7C38_7C3D_OK
	inc $12 
	inc $10 
	ldx $10 
	cpx #$60
	bcc L_BRS_7C38_7C47_OK
	jsr L_JSR_6A07_7C49_OK
	clc 
	rts 
//------------------------------
L_BRS_7C4E_7C0D_OK:
//------------------------------
	lda #$40
	sta $51 
	jsr L_JSR_96F8_7C52_OK
	jsr L_JSR_7C11_7C55_OK
	lda #$20
	sta $51 
	ldy #$0F
	sty $50 
//------------------------------
L_BRS_7C60_7C87_OK:
//------------------------------
	lda $A1B0,Y 
	sta $09 
	lda $A1C0,Y 
	sta $0A 
	ldy #$1B
	sty $4F 
//------------------------------
L_BRS_7C6E_7C81_OK:
//------------------------------
	lda ($09),Y 
	cmp #$09
	beq L_BRS_7C78_7C72_OK
	cmp #$08
	bne L_BRS_7C7D_7C76_OK
//------------------------------
L_BRS_7C78_7C72_OK:
//------------------------------
	lda #$00
	jsr L_JSR_99F6_7C7A_OK
//------------------------------
L_BRS_7C7D_7C76_OK:
//------------------------------
	dec $4F 
	ldy $4F 
	bpl L_BRS_7C6E_7C81_OK
	dec $50 
	ldy $50 
	bpl L_BRS_7C60_7C87_OK
	clc 
	rts 
//------------------------------
L_JSR_7C8B_6167_OK:
//------------------------------
	lda #$01
	sta $131D 
	lda $1316 
	beq L_BRS_7C9D_7C93_OK
	bpl L_BRS_7C9A_7C95_OK
	jmp L_JMP_7FB9_7C97_OK
//------------------------------
L_BRS_7C9A_7C95_OK:
//------------------------------
	jmp L_JMP_8078_7C9A_OK
//------------------------------
L_BRS_7C9D_7C93_OK:
//------------------------------
	ldy $04 
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $03 
	lda ($0B),Y 
	cmp #$03
	beq L_BRS_7CF2_7CAF_OK
	cmp #$04
	bne L_BRS_7CBB_7CB3_OK
	lda $06 
	cmp #$02
	beq L_BRS_7CF2_7CB9_OK
//------------------------------
L_BRS_7CBB_7CB3_OK:
//------------------------------
	lda $06 
	cmp #$02
	bcc L_BRS_7CF5_7CBF_OK
	ldy $04 
	cpy #$0F
	beq L_BRS_7CF2_7CC5_OK
	lda $A1B1,Y 
	sta $09 
	sta $0B 
	lda $A1C1,Y 
	sta $0A 
	lda $A1D1,Y 
	sta $0C 
	ldy $03 
	lda ($09),Y 
	cmp #$00
	beq L_BRS_7CF5_7CDE_OK
	cmp #$08
	beq L_BRS_7CF2_7CE2_OK
	lda ($0B),Y 
	cmp #$01
	beq L_BRS_7CF2_7CE8_OK
	cmp #$02
	beq L_BRS_7CF2_7CEC_OK
	cmp #$03
	bne L_BRS_7CF5_7CF0_OK
//------------------------------
L_BRS_7CF2_7CAF_OK:
L_BRS_7CF2_7CB9_OK:
L_BRS_7CF2_7CC5_OK:
L_BRS_7CF2_7CE2_OK:
L_BRS_7CF2_7CE8_OK:
L_BRS_7CF2_7CEC_OK:
//------------------------------
	jmp L_JMP_7D58_7CF2_OK
//------------------------------
L_BRS_7CF5_7CBF_OK:
L_BRS_7CF5_7CDE_OK:
L_BRS_7CF5_7CF0_OK:
//------------------------------
	lda #$00
	sta $1315 
	dec $1302 
	jsr L_JSR_8539_7CFD_OK
	jsr L_JSR_9A43_7D00_OK
	lda #$07
	ldx $08 
	bmi L_BRS_7D0B_7D07_OK
	lda #$0F
//------------------------------
L_BRS_7D0B_7D07_OK:
//------------------------------
	sta $07 
	jsr L_JSR_85F3_7D0D_OK
	inc $06 
	lda $06 
	cmp #$05
	bcs L_BRS_7D1E_7D16_OK
	jsr L_JSR_8551_7D18_OK
	jmp L_JMP_85E0_7D1B_OK
//------------------------------
L_BRS_7D1E_7D16_OK:
//------------------------------
	lda #$00
	sta $06 
	ldy $04 
	lda $A1B0,Y 
	sta $09 
	sta $0B 
	lda $A1C0,Y 
	sta $0A 
	lda $A1D0,Y 
	sta $0C 
	ldy $03 
	lda ($0B),Y 
	cmp #$01
	bne L_BRS_7D3F_7D3B_OK
	lda #$00
//------------------------------
L_BRS_7D3F_7D3B_OK:
//------------------------------
	sta ($09),Y 
	inc $04 
	ldy $04 
	lda $A1B0,Y 
	sta $09 
	lda $A1C0,Y 
	sta $0A 
	ldy $03 
	lda #$09
	sta ($09),Y 
	jmp L_JMP_85E0_7D55_OK
//------------------------------
L_JMP_7D58_7CF2_OK:
//------------------------------
	lda $1315 
	bne L_BRS_7D5D_7D5B_OK
//------------------------------
L_BRS_7D5D_7D5B_OK:
//------------------------------
	lda #$20
	sta $1315 
	jsr L_JSR_81A9_7D62_OK
	lda $1319 
	cmp #$21
	bne L_BRS_7D72_7D6A_OK
	jsr L_JSR_7E8C_7D6C_OK
	bcs L_BRS_7D90_7D6F_OK
	rts 
//------------------------------
L_BRS_7D72_7D6A_OK:
//------------------------------
	cmp #$25
	bne L_BRS_7D7C_7D74_OK
	jsr L_JSR_7F35_7D76_OK
	bcs L_BRS_7D90_7D79_OK
	rts 
//------------------------------
L_BRS_7D7C_7D74_OK:
//------------------------------
	cmp #$1E
	bne L_BRS_7D86_7D7E_OK
	jsr L_JSR_7FAA_7D80_OK
	bcs L_BRS_7D90_7D83_OK
	rts 
//------------------------------
L_BRS_7D86_7D7E_OK:
//------------------------------
	cmp #$26
	bne L_BRS_7D90_7D88_OK
	jsr L_JSR_8069_7D8A_OK
	bcs L_BRS_7D90_7D8D_OK
	rts 
//------------------------------
L_BRS_7D90_7D6F_OK:
L_BRS_7D90_7D79_OK:
L_BRS_7D90_7D83_OK:
L_BRS_7D90_7D88_OK:
L_BRS_7D90_7D8D_OK:
//------------------------------
	lda $131A 
	cmp #$22
	bne L_BRS_7D9A_7D95_OK
	jmp L_JMP_7DA2_7D97_OK
//------------------------------
L_BRS_7D9A_7D95_OK:
//------------------------------
	cmp #$2A
	bne L_BRS_7DA1_7D9C_OK
	jmp L_JMP_7E14_7D9E_OK
//------------------------------
L_BRS_7DA1_7D9C_OK:
//------------------------------
	rts 
//------------------------------
L_JMP_7DA2_7D97_OK:
//------------------------------
	ldy $04 
	lda $A1B0,Y 
	sta $09 
	sta $0B 
	lda $A1C0,Y 
	sta $0A 
	lda $A1D0,Y 
	sta $0C 
	ldx $05 
	cpx #$03
	bcs L_BRS_7DCF_7DB9_OK
	ldy $03 
	beq L_BRS_7DCE_7DBD_OK
	dey 
	lda ($09),Y 
	cmp #$02
	beq L_BRS_7DCE_7DC4_OK
	cmp #$01
	beq L_BRS_7DCE_7DC8_OK
	cmp #$05
	bne L_BRS_7DCF_7DCC_OK
//------------------------------
L_BRS_7DCE_7DBD_OK:
L_BRS_7DCE_7DC4_OK:
L_BRS_7DCE_7DC8_OK:
//------------------------------
	rts 
//------------------------------
L_BRS_7DCF_7DB9_OK:
L_BRS_7DCF_7DCC_OK:
//------------------------------
	jsr L_JSR_8539_7DCF_OK
	jsr L_JSR_9A43_7DD2_OK
	lda #$FF
	sta $08 
	jsr L_JSR_8606_7DD9_OK
	dec $05 
	bpl L_BRS_7DF9_7DDE_OK
	ldy $03 
	lda ($0B),Y 
	cmp #$01
	bne L_BRS_7DEA_7DE6_OK
	lda #$00
//------------------------------
L_BRS_7DEA_7DE6_OK:
//------------------------------
	sta ($09),Y 
	dec $03 
	dey 
	lda #$09
	sta ($09),Y 
	lda #$04
	sta $05 
	bne L_BRS_7DFC_7DF7_OK
//------------------------------
L_BRS_7DF9_7DDE_OK:
//------------------------------
	jsr L_JSR_8551_7DF9_OK
//------------------------------
L_BRS_7DFC_7DF7_OK:
//------------------------------
	ldy $03 
	lda ($0B),Y 
	cmp #$04
	beq L_BRS_7E0A_7E02_OK
	lda #$00
	ldx #$02
	bne L_BRS_7E0E_7E08_OK
//------------------------------
L_BRS_7E0A_7E02_OK:
//------------------------------
	lda #$03
	ldx #$05
//------------------------------
L_BRS_7E0E_7E08_OK:
//------------------------------
	jsr L_JSR_85D2_7E0E_OK
	jmp L_JMP_85E0_7E11_OK
//------------------------------
L_JMP_7E14_7D9E_OK:
//------------------------------
	ldy $04 
	lda $A1B0,Y 
	sta $09 
	sta $0B 
	lda $A1C0,Y 
	sta $0A 
	lda $A1D0,Y 
	sta $0C 
	ldx $05 
	cpx #$02
	bcc L_BRS_7E43_7E2B_OK
	ldy $03 
	cpy #$1B
	beq L_BRS_7E42_7E31_OK
	iny 
	lda ($09),Y 
	cmp #$02
	beq L_BRS_7E42_7E38_OK
	cmp #$01
	beq L_BRS_7E42_7E3C_OK
	cmp #$05
	bne L_BRS_7E43_7E40_OK
//------------------------------
L_BRS_7E42_7E31_OK:
L_BRS_7E42_7E38_OK:
L_BRS_7E42_7E3C_OK:
//------------------------------
	rts 
//------------------------------
L_BRS_7E43_7E2B_OK:
L_BRS_7E43_7E40_OK:
//------------------------------
	jsr L_JSR_8539_7E43_OK
	jsr L_JSR_9A43_7E46_OK
	lda #$01
	sta $08 
	jsr L_JSR_8606_7E4D_OK
	inc $05 
	lda $05 
	cmp #$05
	bcc L_BRS_7E71_7E56_OK
	ldy $03 
	lda ($0B),Y 
	cmp #$01
	bne L_BRS_7E62_7E5E_OK
	lda #$00
//------------------------------
L_BRS_7E62_7E5E_OK:
//------------------------------
	sta ($09),Y 
	inc $03 
	iny 
	lda #$09
	sta ($09),Y 
	lda #$00
	sta $05 
	beq L_BRS_7E74_7E6F_OK
//------------------------------
L_BRS_7E71_7E56_OK:
//------------------------------
	jsr L_JSR_8551_7E71_OK
//------------------------------
L_BRS_7E74_7E6F_OK:
//------------------------------
	ldy $03 
	lda ($0B),Y 
	cmp #$04
	beq L_BRS_7E82_7E7A_OK
	lda #$08
	ldx #$0A
	bne L_BRS_7E86_7E80_OK
//------------------------------
L_BRS_7E82_7E7A_OK:
//------------------------------
	lda #$0B
	ldx #$0D
//------------------------------
L_BRS_7E86_7E80_OK:
//------------------------------
	jsr L_JSR_85D2_7E86_OK
	jmp L_JMP_85E0_7E89_OK
//------------------------------
L_JSR_7E8C_7D6C_OK:
//------------------------------
	ldy $04 
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $03 
	lda ($0B),Y 
	cmp #$03
	beq L_BRS_7EBC_7E9E_OK
	ldy $06 
	cpy #$03
	bcc L_BRS_7EBA_7EA4_OK
	ldy $04 
	lda $A1B1,Y 
	sta $0B 
	lda $A1D1,Y 
	sta $0C 
	ldy $03 
	lda ($0B),Y 
	cmp #$03
	beq L_BRS_7EE0_7EB8_OK
//------------------------------
L_BRS_7EBA_7EA4_OK:
L_BRS_7EBA_7EC4_OK:
L_BRS_7EBA_7ED6_OK:
L_BRS_7EBA_7EDA_OK:
L_BRS_7EBA_7EDE_OK:
//------------------------------
	sec 
	rts 
//------------------------------
L_BRS_7EBC_7E9E_OK:
//------------------------------
	ldy $06 
	cpy #$03
	bcs L_BRS_7EE0_7EC0_OK
	ldy $04 
	beq L_BRS_7EBA_7EC4_OK
	lda $A1AF,Y 
	sta $09 
	lda $A1BF,Y 
	sta $0A 
	ldy $03 
	lda ($09),Y 
	cmp #$01
	beq L_BRS_7EBA_7ED6_OK
	cmp #$02
	beq L_BRS_7EBA_7EDA_OK
	cmp #$05
	beq L_BRS_7EBA_7EDE_OK
//------------------------------
L_BRS_7EE0_7EB8_OK:
L_BRS_7EE0_7EC0_OK:
//------------------------------
	jsr L_JSR_8539_7EE0_OK
	jsr L_JSR_9A43_7EE3_OK
	ldy $04 
	lda $A1B0,Y 
	sta $09 
	sta $0B 
	lda $A1C0,Y 
	sta $0A 
	lda $A1D0,Y 
	sta $0C 
	jsr L_JSR_85F3_7EF9_OK
	dec $06 
	bpl L_BRS_7F26_7EFE_OK
	ldy $03 
	lda ($0B),Y 
	cmp #$01
	bne L_BRS_7F0A_7F06_OK
	lda #$00
//------------------------------
L_BRS_7F0A_7F06_OK:
//------------------------------
	sta ($09),Y 
	dec $04 
	ldy $04 
	lda $A1B0,Y 
	sta $09 
	lda $A1C0,Y 
	sta $0A 
	ldy $03 
	lda #$09
	sta ($09),Y 
	lda #$04
	sta $06 
	bne L_BRS_7F29_7F24_OK
//------------------------------
L_BRS_7F26_7EFE_OK:
L_JMP_7F26_7FA4_OK:
//------------------------------
	jsr L_JSR_8551_7F26_OK
//------------------------------
L_BRS_7F29_7F24_OK:
L_JMP_7F29_7FA1_OK:
//------------------------------
	lda #$10
	ldx #$11
	jsr L_JSR_85D2_7F2D_OK
	jsr L_JSR_85E0_7F30_OK
	clc 
	rts 
//------------------------------
L_JSR_7F35_7D76_OK:
//------------------------------
	ldy $06 
	cpy #$02
	bcc L_BRS_7F59_7F39_OK
	ldy $04 
	cpy #$0F
	bcs L_BRS_7F57_7F3F_OK
	lda $A1B1,Y 
	sta $09 
	lda $A1C1,Y 
	sta $0A 
	ldy $03 
	lda ($09),Y 
	cmp #$02
	beq L_BRS_7F57_7F51_OK
	cmp #$01
	bne L_BRS_7F59_7F55_OK
//------------------------------
L_BRS_7F57_7F3F_OK:
L_BRS_7F57_7F51_OK:
//------------------------------
	sec 
	rts 
//------------------------------
L_BRS_7F59_7F39_OK:
L_BRS_7F59_7F55_OK:
//------------------------------
	jsr L_JSR_8539_7F59_OK
	jsr L_JSR_9A43_7F5C_OK
	ldy $04 
	lda $A1B0,Y 
	sta $09 
	sta $0B 
	lda $A1C0,Y 
	sta $0A 
	lda $A1D0,Y 
	sta $0C 
	jsr L_JSR_85F3_7F72_OK
	inc $06 
	lda $06 
	cmp #$05
	bcc L_BRS_7FA4_7F7B_OK
	ldy $03 
	lda ($0B),Y 
	cmp #$01
	bne L_BRS_7F87_7F83_OK
	lda #$00
//------------------------------
L_BRS_7F87_7F83_OK:
//------------------------------
	sta ($09),Y 
	inc $04 
	ldy $04 
	lda $A1B0,Y 
	sta $09 
	lda $A1C0,Y 
	sta $0A 
	ldy $03 
	lda #$09
	sta ($09),Y 
	lda #$00
	sta $06 
	jmp L_JMP_7F29_7FA1_OK
//------------------------------
L_BRS_7FA4_7F7B_OK:
//------------------------------
	jmp L_JMP_7F26_7FA4_OK
//------------------------------
L_BRS_7FA7_7FBD_OK:
L_BRS_7FA7_7FC5_OK:
L_BRS_7FA7_7FCC_OK:
//------------------------------
	jmp L_JMP_8059_7FA7_OK
//------------------------------
L_JSR_7FAA_7D80_OK:
//------------------------------
	lda #$FF
	sta $1316 
	sta $1319 
	sta $131A 
	lda #$00
	sta $54 
//------------------------------
L_JMP_7FB9_7C97_OK:
//------------------------------
	ldy $04 
	cpy #$0F
	bcs L_BRS_7FA7_7FBD_OK
	iny 
	jsr L_JSR_9BC7_7FC0_OK
	ldy $03 
	beq L_BRS_7FA7_7FC5_OK
	dey 
	lda ($09),Y 
	cmp #$01
	bne L_BRS_7FA7_7FCC_OK
	ldy $04 
	jsr L_JSR_9BC7_7FD0_OK
	ldy $03 
	dey 
	lda ($09),Y 
	cmp #$00
	bne L_BRS_8035_7FDA_OK
	jsr L_JSR_8539_7FDC_OK
	jsr L_JSR_9A43_7FDF_OK
	jsr L_JSR_85F3_7FE2_OK
	jsr L_JSR_8606_7FE5_OK
	ldx $54 
	lda #$00
	cpx #$06
	bcs L_BRS_7FF2_7FEE_OK
	lda #$06
//------------------------------
L_BRS_7FF2_7FEE_OK:
//------------------------------
	sta $07 
	jsr L_JSR_85E0_7FF4_OK
	ldx $54 
	cpx #$0C
	beq L_BRS_8060_7FFB_OK
	cpx #$00
	beq L_BRS_8013_7FFF_OK
	lda $813A,X 
	pha 
	ldx $03 
	dex 
	ldy $04 
	jsr L_JSR_9B8B_800A_OK
	pla 
	jsr L_JSR_9A43_800E_OK
	ldx $54 
//------------------------------
L_BRS_8013_7FFF_OK:
//------------------------------
	lda $813B,X 
	pha 
	ldx $03 
	dex 
	stx $4F 
	ldy $04 
	sty $50 
	jsr L_JSR_9B8B_8020_OK
	pla 
	jsr L_JSR_9A7E_8024_OK
	ldx $54 
	lda $8153,X 
	inc $50 
	jsr L_JSR_99F0_802E_OK
	inc $54 
	clc 
	rts 
//------------------------------
L_BRS_8035_7FDA_OK:
//------------------------------
	ldy $04 
	iny 
	sty $50 
	ldy $03 
	dey 
	sty $4F 
	lda #$01
	jsr L_JSR_99F0_8041_OK
	ldx $54 
	beq L_BRS_8059_8046_OK
	dex 
	lda $813B,X 
	pha 
	ldy $04 
	ldx $03 
	dex 
	jsr L_JSR_9B8B_8052_OK
	pla 
	jsr L_JSR_9A43_8056_OK
//------------------------------
L_JMP_8059_7FA7_OK:
L_BRS_8059_8046_OK:
//------------------------------
	lda #$00
	sta $1316 
	sec 
	rts 
//------------------------------
L_BRS_8060_7FFB_OK:
//------------------------------
	ldx $03 
	dex 
	jmp L_JMP_8619_8063_OK
//------------------------------
L_BRS_8066_807C_OK:
L_BRS_8066_8086_OK:
L_BRS_8066_808D_OK:
//------------------------------
	jmp L_JMP_811C_8066_OK
//------------------------------
L_JSR_8069_7D8A_OK:
//------------------------------
	lda #$01
	sta $1316 
	sta $1319 
	sta $131A 
	lda #$0C
	sta $54 
//------------------------------
L_JMP_8078_7C9A_OK:
//------------------------------
	ldy $04 
	cpy #$0F
	bcs L_BRS_8066_807C_OK
	iny 
	jsr L_JSR_9BC7_807F_OK
	ldy $03 
	cpy #$1B
	bcs L_BRS_8066_8086_OK
	iny 
	lda ($09),Y 
	cmp #$01
	bne L_BRS_8066_808D_OK
	ldy $04 
	jsr L_JSR_9BC7_8091_OK
	ldy $03 
	iny 
	lda ($09),Y 
	cmp #$00
	bne L_BRS_80F6_809B_OK
	jsr L_JSR_8539_809D_OK
	jsr L_JSR_9A43_80A0_OK
	jsr L_JSR_85F3_80A3_OK
	jsr L_JSR_8606_80A6_OK
	ldx $54 
	lda #$08
	cpx #$12
	bcs L_BRS_80B3_80AF_OK
	lda #$0E
//------------------------------
L_BRS_80B3_80AF_OK:
//------------------------------
	sta $07 
	jsr L_JSR_85E0_80B5_OK
	ldx $54 
	cpx #$18
	beq L_BRS_8123_80BC_OK
	cpx #$0C
	beq L_BRS_80D4_80C0_OK
	lda $813A,X 
	pha 
	ldx $03 
	inx 
	ldy $04 
	jsr L_JSR_9B8B_80CB_OK
	pla 
	jsr L_JSR_9A43_80CF_OK
	ldx $54 
//------------------------------
L_BRS_80D4_80C0_OK:
//------------------------------
	lda $813B,X 
	pha 
	ldx $03 
	inx 
	stx $4F 
	ldy $04 
	sty $50 
	jsr L_JSR_9B8B_80E1_OK
	pla 
	jsr L_JSR_9A7E_80E5_OK
	inc $50 
	ldx $54 
	lda $8147,X 
	jsr L_JSR_99F0_80EF_OK
	inc $54 
	clc 
	rts 
//------------------------------
L_BRS_80F6_809B_OK:
//------------------------------
	ldy $04 
	iny 
	sty $50 
	ldy $03 
	iny 
	sty $4F 
	lda #$01
	jsr L_JSR_99F0_8102_OK
	ldx $54 
	cpx #$0C
	beq L_BRS_811C_8109_OK
	dex 
	lda $813B,X 
	pha 
	ldx $03 
	inx 
	ldy $04 
	jsr L_JSR_9B8B_8115_OK
	pla 
	jsr L_JSR_9A43_8119_OK
//------------------------------
L_JMP_811C_8066_OK:
L_BRS_811C_8109_OK:
//------------------------------
	lda #$00
	sta $1316 
	sec 
	rts 
//------------------------------
L_BRS_8123_80BC_OK:
//------------------------------
	ldx $03 
	inx 
	jmp L_JMP_8619_8126_OK
	.byte $0B,$0C
	ora $1A19
	.byte $1B,$0F,$14
	bpl L_BRS_8144_8131_JAM
	.byte $12
	asl $17,X 
	clc 
	rol $15 
	asl $1C13 
	.byte $1C
	ora $1E1D,X
	asl $1F1F,X 
//------------------------------
L_BRS_8144_8131_JAM:
//------------------------------
	.byte $00,$00,$00,$00,$27,$27
	plp 
	plp 
	asl $1F1E,X 
	.byte $1F,$00,$00,$00,$00
	jsr 2120
	and ($22,X) 
	.byte $22,$23,$23
	bit $24 
	and $25
//------------------------------
L_JMP_815F_81B0_OK:
//------------------------------
	lda $1328 
	bne L_BRS_816B_8162_OK
	lda $DC00 
	and #$10
	bne L_BRS_8174_8169_OK
//------------------------------
L_BRS_816B_8162_OK:
//------------------------------
	lsr $1314 
	lda #$01
	sta $1312 
	rts 
//------------------------------
L_BRS_8174_8169_OK:
//------------------------------
	lda $58 
	bne L_BRS_818E_8176_OK
	ldy #$00
	lda ($55),Y 
	sta $57 
	iny 
	lda ($55),Y 
	sta $58 
	lda $55 
	clc 
	adc #$02
	sta $55 
	bcc L_BRS_818E_818A_OK
	inc $56 
//------------------------------
L_BRS_818E_8176_OK:
L_BRS_818E_818A_OK:
//------------------------------
	lda $57 
	and #$0F
	tax 
	lda $A6B8,X 
	sta $1319 
	lda $57 
	lsr 
	lsr 
	lsr 
	lsr 
	tax 
	lda $A6B8,X 
	sta $131A 
	dec $58 
	rts 
//------------------------------
L_JSR_81A9_7D62_OK:
L_JMP_81A9_8204_OK:
L_JMP_81A9_8220_OK:
L_JMP_81A9_8304_OK:
L_JMP_81A9_8328_OK:
L_JMP_81A9_833F_OK:
L_JMP_81A9_835D_OK:
L_JMP_81A9_8373_OK:
L_JMP_81A9_837B_OK:
L_JMP_81A9_8386_OK:
L_JMP_81A9_8393_OK:
L_JMP_81A9_839E_OK:
L_JMP_81A9_83AB_OK:
L_JMP_81A9_83B6_OK:
//------------------------------
	lda $1306 
	cmp #$01
	bne L_BRS_81B3_81AE_OK
	jmp L_JMP_815F_81B0_OK
//------------------------------
L_BRS_81B3_81AE_OK:
//------------------------------
	ldx $1328 
	bne L_BRS_81C2_81B6_OK
	lda $130F 
	cmp #$CB
	beq L_BRS_81F0_81BD_OK
//------------------------------
L_BRS_81BF_81E6_OK:
//------------------------------
	jmp L_JMP_84D9_81BF_OK
//------------------------------
L_BRS_81C2_81B6_OK:
//------------------------------
	lda #$00
	sta $1328 
	stx $23 
	ldy #$FF
//------------------------------
L_BRS_81CB_81D3_OK:
//------------------------------
	iny 
	lda $9E29,Y 
	beq L_BRS_81E1_81CF_OK
	cmp $23 
	bne L_BRS_81CB_81D3_OK
	tya 
	asl A 
	tay 
	lda $9E3F,Y 
	pha 
	lda $9E3E,Y 
	pha 
	rts 
//------------------------------
L_BRS_81E1_81CF_OK:
//------------------------------
	lda $130F 
	cmp #$CA
	beq L_BRS_81BF_81E6_OK
	ldx $23 
	stx $1319 
	stx $131A 
//------------------------------
L_BRS_81F0_81BD_OK:
//------------------------------
	rts 
//------------------------------
	lda $135A 
	bpl L_BRS_8204_81F4_OK
	lda $028D 
	and #$02
	cmp #$02
	bne L_BRS_8204_81FD_OK
	lda #$00
	sta $130E 
//------------------------------
L_BRS_8204_81F4_OK:
L_BRS_8204_81FD_OK:
//------------------------------
	jmp L_JMP_81A9_8204_OK
	lda $135A 
	bpl L_BRS_8220_820A_OK
	lda $D015 
	sta $132B 
	lda #$00
	sta $D015 
	jsr L_JSR_7929_8217_OK
	lda $132B 
	sta $D015 
//------------------------------
L_BRS_8220_820A_OK:
//------------------------------
	jmp L_JMP_81A9_8220_OK
	lda $136A 
	bmi L_BRS_8258_8226_OK
	lda #$06
	sta $1312 
	lsr $1314 
	lda $135F 
	eor #$FF
	sta $135F 
	beq L_BRS_824F_8238_OK
	jsr L_JSR_6721_823A_OK
	jsr L_JSR_6733_823D_OK
	sta $1310 
	sta $1305 
	inc $1305 
	inc $135E 
	jmp L_JMP_8258_824C_OK
//------------------------------
L_BRS_824F_8238_OK:
//------------------------------
	ldy #$00
	sty $1310 
	iny 
	sty $1305 
//------------------------------
L_BRS_8258_8226_OK:
L_JMP_8258_824C_OK:
//------------------------------
	rts 
//------------------------------
	lda $136A 
	bmi L_BRS_8286_825C_OK
	lda $135F 
	bpl L_BRS_8275_8261_OK
	jsr L_JSR_6733_8263_OK
	sta $1310 
	sta $1305 
	inc $1305 
	inc $135E 
	jmp L_JMP_8278_8272_OK
//------------------------------
L_BRS_8275_8261_OK:
//------------------------------
	jsr L_JSR_83F2_8275_OK
//------------------------------
L_JMP_8278_8272_OK:
//------------------------------
	lsr $1314 
	inc $1312 
	lda $135A 
	bmi L_BRS_8286_8281_OK
	lsr $1318 
//------------------------------
L_BRS_8286_825C_OK:
L_BRS_8286_8281_OK:
//------------------------------
	rts 
//------------------------------
	lda $136A 
	bmi L_BRS_82B4_828A_OK
	lda $135F 
	bpl L_BRS_82A3_828F_OK
	jsr L_JSR_6733_8291_OK
	sta $1310 
	sta $1305 
	inc $1305 
	inc $135E 
	jmp L_JMP_82A6_82A0_OK
//------------------------------
L_BRS_82A3_828F_OK:
//------------------------------
	jsr L_JSR_83B9_82A3_OK
//------------------------------
L_JMP_82A6_82A0_OK:
//------------------------------
	lsr $1314 
	inc $1312 
	lda $135A 
	bmi L_BRS_82B4_82AF_OK
	lsr $1318 
//------------------------------
L_BRS_82B4_828A_OK:
L_BRS_82B4_82AF_OK:
//------------------------------
	rts 
//------------------------------
L_JMP_82B5_8330_OK:
//------------------------------
	lda $136A 
	bpl L_BRS_82DB_82B8_OK
	pla 
	pla 
	pla 
	pla 
//------------------------------
L_JMP_82BE_61CD_OK:
//------------------------------
	lda #$00
	sta $136A 
	lda #$05
	sta $1312 
	lda #$05
	sta $1306 
	sta $132C 
	lda #$00
	sta $D015 
	jsr L_JSR_720F_82D5_OK
	jmp L_JMP_6E33_82D8_OK
//------------------------------
L_BRS_82DB_82B8_OK:
//------------------------------
	rts 
//------------------------------
	lda $028D 
	and #$02
	cmp #$02
	bne L_BRS_82EF_82E3_OK
	lda $1312 
	clc 
	adc #$0A
	bcc L_BRS_82F6_82EB_OK
	bcs L_BRS_82F4_82ED_OK
//------------------------------
L_BRS_82EF_82E3_OK:
//------------------------------
	inc $1312 
	bne L_BRS_82F9_82F2_OK
//------------------------------
L_BRS_82F4_82ED_OK:
//------------------------------
	lda #$FF
//------------------------------
L_BRS_82F6_82EB_OK:
//------------------------------
	sta $1312 
//------------------------------
L_BRS_82F9_82F2_OK:
//------------------------------
	jsr L_JSR_97F6_82F9_OK
	lda $135A 
	bmi L_BRS_8304_82FF_OK
	lsr $1318 
//------------------------------
L_BRS_8304_82FF_OK:
//------------------------------
	jmp L_JMP_81A9_8304_OK
//------------------------------
L_BRS_8307_8326_OK:
//------------------------------
	jsr L_JSR_9C91_8307_OK
	cmp #$03
	bne L_BRS_8324_830C_OK
	lda $135A 
	eor #$FF
	sta $135A 
	bpl L_BRS_831C_8316_OK
	lda #$0B
	bne L_BRS_831E_831A_OK
//------------------------------
L_BRS_831C_8316_OK:
//------------------------------
	lda #$00
//------------------------------
L_BRS_831E_831A_OK:
//------------------------------
	sta $D020 
	jsr L_JSR_9971_8321_OK
//------------------------------
L_BRS_8324_830C_OK:
//------------------------------
	cmp #$3F
	bne L_BRS_8307_8326_OK
	jmp L_JMP_81A9_8328_OK
	ldx $136A 
	bpl L_BRS_8333_832E_OK
	jmp L_JMP_82B5_8330_OK
//------------------------------
L_BRS_8333_832E_OK:
//------------------------------
	jmp L_JMP_62A7_8333_OK
	lsr $1314 
	rts 
//------------------------------
	lda #$CA
	sta $130F 
	jmp L_JMP_81A9_833F_OK
	lda $136A 
	bpl L_BRS_8348_8345_OK
	rts 
//------------------------------
L_BRS_8348_8345_OK:
//------------------------------
	lda #$AA
	jsr L_JSR_91BB_834A_OK
	pla 
	pla 
	jmp L_JMP_60CE_834F_OK
	lda $136A 
	bpl L_BRS_8358_8355_OK
	rts 
//------------------------------
L_BRS_8358_8355_OK:
//------------------------------
	lda $1318 
	bne L_BRS_8360_835B_OK
	jmp L_JMP_81A9_835D_OK
//------------------------------
L_BRS_8360_835B_OK:
//------------------------------
	lda #$8D
	dec $1312 
	jsr L_JSR_980D_8365_OK
	jsr L_JSR_91BB_8368_OK
	pla 
	pla 
	jmp L_JMP_60CE_836D_OK
	jsr L_JSR_84C5_8370_OK
	jmp L_JMP_81A9_8373_OK
	lda #$CB
	sta $130F 
	jmp L_JMP_81A9_837B_OK
	lda $135A 
	bpl L_BRS_8389_8381_OK
	jsr L_JSR_8434_8383_OK
	jmp L_JMP_81A9_8386_OK
//------------------------------
L_BRS_8389_8381_OK:
//------------------------------
	lda $131B 
	cmp #$08
	beq L_BRS_8393_838E_OK
	inc $131B 
//------------------------------
L_BRS_8393_838E_OK:
L_BRS_8393_83A6_OK:
//------------------------------
	jmp L_JMP_81A9_8393_OK
	lda $135A 
	bpl L_BRS_83A1_8399_OK
	jsr L_JSR_847D_839B_OK
	jmp L_JMP_81A9_839E_OK
//------------------------------
L_BRS_83A1_8399_OK:
//------------------------------
	lda $131B 
	cmp #$03
	beq L_BRS_8393_83A6_OK
	dec $131B 
	jmp L_JMP_81A9_83AB_OK
	lda $1339 
	eor #$FF
	sta $1339 
	jmp L_JMP_81A9_83B6_OK
//------------------------------
L_JSR_83B9_6F9C_OK:
L_JSR_83B9_82A3_OK:
//------------------------------
	lda $028D 
	and #$02
	cmp #$02
	bne L_BRS_83DA_83C0_OK
	lda $1310 
	sec 
	sbc #$0A
	bcs L_BRS_83D0_83C8_OK
	lda #$8C
	clc 
	adc $1310 
//------------------------------
L_BRS_83D0_83C8_OK:
//------------------------------
	sta $1310 
	sta $1305 
	inc $1305 
	rts 
//------------------------------
L_BRS_83DA_83C0_OK:
//------------------------------
	lda $1310 
	cmp #$00
	bne L_BRS_83EB_83DF_OK
	ldy #$95
	sty $1310 
	iny 
	sty $1305 
	rts 
//------------------------------
L_BRS_83EB_83DF_OK:
//------------------------------
	dec $1310 
	dec $1305 
	rts 
//------------------------------
L_JSR_83F2_6F93_OK:
L_JSR_83F2_8275_OK:
//------------------------------
	lda $028D 
	and #$02
	cmp #$02
	bne L_BRS_841C_83F9_OK
	lda $1310 
	tay 
	clc 
	adc #$0A
	bcc L_BRS_840C_8402_OK
	tya 
	sbc #$00
	and #$0F
	jmp L_JMP_8413_8409_OK
//------------------------------
L_BRS_840C_8402_OK:
//------------------------------
	cmp #$96
	bcc L_BRS_8413_840E_OK
	sec 
	sbc #$96
//------------------------------
L_JMP_8413_8409_OK:
L_BRS_8413_840E_OK:
//------------------------------
	sta $1310 
	sta $1305 
	jmp L_JMP_8430_8419_OK
//------------------------------
L_BRS_841C_83F9_OK:
//------------------------------
	lda $1310 
	cmp #$95
	bne L_BRS_842D_8421_OK
	ldy #$00
	sty $1310 
	iny 
	sty $1305 
	rts 
//------------------------------
L_BRS_842D_8421_OK:
//------------------------------
	inc $1310 
//------------------------------
L_JMP_8430_8419_OK:
//------------------------------
	inc $1305 
	rts 
//------------------------------
L_JSR_8434_8383_OK:
//------------------------------
	lda $07A9 
	cmp $07AA 
	beq L_BRS_846B_843A_OK
	lda $028D 
	and #$02
	cmp #$02
	bne L_BRS_8459_8443_OK
	lda $135B 
	sec 
	sbc #$0A
	bcs L_BRS_8453_844B_OK
	lda #$8C
	clc 
	adc $1310 
//------------------------------
L_BRS_8453_844B_OK:
//------------------------------
	sta $135B 
	jmp L_JMP_846B_8456_OK
//------------------------------
L_BRS_8459_8443_OK:
//------------------------------
	lda $135B 
	cmp #$00
	bne L_BRS_8468_845E_OK
	lda #$95
	sta $135B 
	jmp L_JMP_846B_8465_OK
//------------------------------
L_BRS_8468_845E_OK:
//------------------------------
	dec $135B 
//------------------------------
L_BRS_846B_843A_OK:
L_JMP_846B_8456_OK:
L_JMP_846B_8465_OK:
//------------------------------
	lda #$A0
	sta $798D 
	lda #$D3
	sta $798E 
	lda #$C5
	sta $798F 
	jmp L_JMP_7955_847A_OK
//------------------------------
L_JSR_847D_839B_OK:
//------------------------------
	lda $07A9 
	cmp $07AA 
	beq L_BRS_84B3_8483_OK
	lda $028D 
	and #$02
	cmp #$02
	bne L_BRS_84A1_848C_OK
	lda $135B 
	clc 
	adc #$0A
	cmp #$96
	bcc L_BRS_849B_8496_OK
	sec 
	sbc #$96
//------------------------------
L_BRS_849B_8496_OK:
//------------------------------
	sta $135B 
	jmp L_JMP_84B3_849E_OK
//------------------------------
L_BRS_84A1_848C_OK:
//------------------------------
	lda $135B 
	cmp #$95
	bne L_BRS_84B0_84A6_OK
	lda #$00
	sta $135B 
	jmp L_JMP_84B3_84AD_OK
//------------------------------
L_BRS_84B0_84A6_OK:
//------------------------------
	inc $135B 
//------------------------------
L_BRS_84B3_8483_OK:
L_JMP_84B3_849E_OK:
L_JMP_84B3_84AD_OK:
//------------------------------
	lda #$A0
	sta $798D 
	lda #$D3
	sta $798E 
	lda #$C5
	sta $798F 
	jmp L_JMP_7955_84C2_OK
//------------------------------
L_JSR_84C5_6136_OK:
L_JSR_84C5_6F01_OK:
L_JSR_84C5_8370_OK:
//------------------------------
	lda $1330 
	eor #$FF
	sta $1330 
	ldy #$00
	sty $1328 
	lsr $1314 
	inc $133B 
	rts 
//------------------------------
L_JMP_84D9_81BF_OK:
//------------------------------
	lda $DC00 
	and #$10
	bne L_BRS_84F9_84DE_OK
	lda $08 
	eor $1339 
	bpl L_BRS_84F0_84E5_OK
	lda #$26
	sta $1319 
	sta $131A 
	rts 
//------------------------------
L_BRS_84F0_84E5_OK:
//------------------------------
	lda #$1E
	sta $1319 
	sta $131A 
	rts 
//------------------------------
L_BRS_84F9_84DE_OK:
//------------------------------
	lda $DC00 
	sta $1E 
	and #$02
	beq L_BRS_8516_8500_OK
	lda $1E 
	and #$01
	beq L_BRS_850F_8506_OK
	ldx #$00
	stx $1319 
	beq L_BRS_851B_850D_OK
//------------------------------
L_BRS_850F_8506_OK:
//------------------------------
	ldx #$21
	stx $1319 
	bne L_BRS_851B_8514_OK
//------------------------------
L_BRS_8516_8500_OK:
//------------------------------
	ldx #$25
	stx $1319 
//------------------------------
L_BRS_851B_850D_OK:
L_BRS_851B_8514_OK:
//------------------------------
	lda $1E 
	and #$08
	beq L_BRS_852D_851F_OK
	lda $1E 
	and #$04
	beq L_BRS_8533_8525_OK
	ldx #$00
	stx $131A 
	rts 
//------------------------------
L_BRS_852D_851F_OK:
//------------------------------
	ldx #$2A
	stx $131A 
	rts 
//------------------------------
L_BRS_8533_8525_OK:
//------------------------------
	ldx #$22
	stx $131A 
	rts 
//------------------------------
L_JSR_8539_7CFD_OK:
L_JSR_8539_7DCF_OK:
L_JSR_8539_7E43_OK:
L_JSR_8539_7EE0_OK:
L_JSR_8539_7F59_OK:
L_JSR_8539_7FDC_OK:
L_JSR_8539_809D_OK:
L_JSR_8539_85E0_OK:
//------------------------------
	ldx $03 
	ldy $05 
	jsr L_JSR_9B96_853D_OK
	stx $23 
	ldy $04 
	ldx $06 
	jsr L_JSR_9BA4_8546_OK
	ldx $07 
	lda $8129,X 
	ldx $23 
	rts 
//------------------------------
L_JSR_8551_7D18_OK:
L_JSR_8551_7DF9_OK:
L_JSR_8551_7E71_OK:
L_JSR_8551_7F26_OK:
L_JMP_8551_85FD_OK:
L_JMP_8551_8602_OK:
L_JMP_8551_8610_OK:
L_JMP_8551_8615_OK:
//------------------------------
	lda $05 
	cmp #$02
	bne L_BRS_85D1_8555_OK
	lda $06 
	cmp #$02
	bne L_BRS_85D1_855B_OK
	ldy $04 
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $03 
	lda ($0B),Y 
	cmp #$07
	bne L_BRS_85D1_856F_OK
	lsr $131D 
	ldx #$10
	ldy #$20
	lda #$04
	jsr L_JSR_6769_857A_OK
	sta $859C 
	lda #$04
	jsr L_JSR_6769_8582_OK
	sta $85A0 
	lda #$04
	jsr L_JSR_6769_858A_OK
	sta $85A4 
	lda #$04
	jsr L_JSR_6769_8592_OK
	sta $85A8 
	jsr L_JSR_66D8_8598_OK
	.byte $04,$00,$FF
	bcs L_BRS_85A4_859E_JAM
	.byte $00,$FF
	ldy #$04
//------------------------------
L_BRS_85A4_859E_JAM:
//------------------------------
	.byte $00,$FF
	bcc L_BRS_85AC_85A6_OK
	.byte $00,$FF
	ldy #$00
//------------------------------
L_BRS_85AC_85A6_OK:
//------------------------------
	dec $130E 
	ldy $04 
	sty $50 
	ldy $03 
	sty $4F 
	lda #$00
	sta ($0B),Y 
	jsr L_JSR_99F6_85BB_OK
	ldy $50 
	ldx $4F 
	jsr L_JSR_9B8B_85C2_OK
	lda #$07
	jsr L_JSR_9A43_85C7_OK
	lda #$50
	ldy #$01
	jsr L_JSR_9833_85CE_OK
//------------------------------
L_BRS_85D1_8555_OK:
L_BRS_85D1_855B_OK:
L_BRS_85D1_856F_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_85D2_7E0E_OK:
L_JSR_85D2_7E86_OK:
L_JSR_85D2_7F2D_OK:
//------------------------------
	inc $07 
	cmp $07 
	bcc L_BRS_85DB_85D6_OK
//------------------------------
L_BRS_85D8_85DD_OK:
//------------------------------
	sta $07 
	rts 
//------------------------------
L_BRS_85DB_85D6_OK:
//------------------------------
	cpx $07 
	bcc L_BRS_85D8_85DD_OK
	rts 
//------------------------------
L_JMP_85E0_7D1B_OK:
L_JMP_85E0_7D55_OK:
L_JMP_85E0_7E11_OK:
L_JMP_85E0_7E89_OK:
L_JSR_85E0_7F30_OK:
L_JSR_85E0_7FF4_OK:
L_JSR_85E0_80B5_OK:
//------------------------------
	jsr L_JSR_8539_85E0_OK
	jsr L_JSR_9A7E_85E3_OK
	lda $27 
	beq L_BRS_85F2_85E8_OK
	lda $131D 
	beq L_BRS_85F2_85ED_OK
	lsr $1314 
//------------------------------
L_BRS_85F2_85E8_OK:
L_BRS_85F2_85ED_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_85F3_7D0D_OK:
L_JSR_85F3_7EF9_OK:
L_JSR_85F3_7F72_OK:
L_JSR_85F3_7FE2_OK:
L_JSR_85F3_80A3_OK:
//------------------------------
	lda $05 
	cmp #$02
	bcc L_BRS_8600_85F7_OK
	beq L_BRS_8605_85F9_OK
	dec $05 
	jmp L_JMP_8551_85FD_OK
//------------------------------
L_BRS_8600_85F7_OK:
//------------------------------
	inc $05 
	jmp L_JMP_8551_8602_OK
//------------------------------
L_BRS_8605_85F9_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_8606_7DD9_OK:
L_JSR_8606_7E4D_OK:
L_JSR_8606_7FE5_OK:
L_JSR_8606_80A6_OK:
//------------------------------
	lda $06 
	cmp #$02
	bcc L_BRS_8613_860A_OK
	beq L_BRS_8618_860C_OK
	dec $06 
	jmp L_JMP_8551_8610_OK
//------------------------------
L_BRS_8613_860A_OK:
//------------------------------
	inc $06 
	jmp L_JMP_8551_8615_OK
//------------------------------
L_BRS_8618_860C_OK:
//------------------------------
	rts 
//------------------------------
L_JMP_8619_8063_OK:
L_JMP_8619_8126_OK:
//------------------------------
	lda #$00
	sta $1316 
	ldy $04 
	iny 
	stx $4F 
	sty $50 
	lda $A1B0,Y 
	sta $09 
	lda $A1C0,Y 
	sta $0A 
	lda #$00
	ldy $4F 
	sta ($09),Y 
	jsr L_JSR_99F0_8635_OK
	lda #$00
	jsr L_JSR_99F6_863A_OK
	dec $50 
	lda #$00
	jsr L_JSR_99F0_8641_OK
	inc $50 
	ldx #$FF
//------------------------------
L_BRS_8648_8650_OK:
//------------------------------
	inx 
	cpx #$1E
	beq L_BRS_8662_864B_OK
	lda $12E0,X 
	bne L_BRS_8648_8650_OK
	lda $50 
	sta $12C0,X 
	lda $4F 
	sta $12A0,X 
	lda #$B4
	sta $12E0,X 
	sec 
//------------------------------
L_BRS_8662_864B_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_8663_6196_OK:
//------------------------------
	ldx $131C 
	beq L_BRS_8689_8666_OK
	inc $36 
	ldy $36 
	cpy #$03
	bcc L_BRS_8674_866E_OK
	ldy #$00
	sty $36 
//------------------------------
L_BRS_8674_866E_OK:
//------------------------------
	lda $0032,Y 
	sta $35 
//------------------------------
L_BRS_8679_8687_OK:
//------------------------------
	lsr $35 
	bcc L_BRS_8685_867B_OK
	jsr L_JSR_86D9_867D_BAD
	lda $1314 
	beq L_BRS_8689_8683_OK
//------------------------------
L_BRS_8685_867B_OK:
//------------------------------
	lda $35 
	bne L_BRS_8679_8687_OK
//------------------------------
L_BRS_8689_8666_OK:
L_BRS_8689_8683_OK:
//------------------------------
	rts 
//------------------------------
	.byte $00,$00,$00,$00
	ora ($01,X)
	ora ($01,X)
	ora ($01,X)
	.byte $03
	ora ($01,X)
	.byte $03,$03,$03,$03,$03,$03,$03,$07
	.byte $03,$07,$07,$07,$07,$07,$07,$07
	.byte $0F,$07,$0F,$0F,$0F,$0F,$0F,$0F
	.byte $0F,$1F,$0F,$1F,$1F,$1F,$1F,$1F
	.byte $1F,$1F,$3F,$1F,$3F,$3F,$3F,$3F
	.byte $3F,$3F,$3F,$7F,$3F,$7F,$7F,$7F
	.byte $7F,$7F
	php 
	bit $312D 
	.byte $32,$33,$37
	and #$2A
	.byte $2B
	rol $302F 
	rol $34,X 
//------------------------------
L_JSR_86D9_867D_BAD:
//------------------------------
	and $EE,X 
	.byte $1F,$13
	ldx $131C 
	cpx $131F 
	bcs L_BRS_86E9_86E2_OK
	ldx #$01
	stx $131F 
//------------------------------
L_BRS_86E9_86E2_OK:
//------------------------------
	jsr L_JSR_8FD1_86E9_OK
	lda $19 
	bmi L_BRS_870B_86EE_OK
	beq L_BRS_870B_86F0_OK
	dec $19 
	ldy $19 
	cpy #$0D
	bcs L_BRS_86FD_86F8_OK
	jmp L_JMP_8862_86FA_OK
//------------------------------
L_BRS_86FD_86F8_OK:
//------------------------------
	ldx $131F 
	lda $1298,X 
	beq L_BRS_8708_8703_OK
	jmp L_JMP_8FAA_8705_OK
//------------------------------
L_BRS_8708_8703_OK:
//------------------------------
	jmp L_JMP_87B2_8708_OK
//------------------------------
L_BRS_870B_86EE_OK:
L_BRS_870B_86F0_OK:
//------------------------------
	ldy $16 
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $15 
	lda ($0B),Y 
	cmp #$03
	beq L_BRS_8764_871D_OK
	cmp #$04
	bne L_BRS_8729_8721_OK
	lda $1B 
	cmp #$02
	beq L_BRS_8764_8727_OK
//------------------------------
L_BRS_8729_8721_OK:
//------------------------------
	lda $1B 
	cmp #$02
	bcc L_BRS_8767_872D_OK
	ldy $16 
	cpy #$0F
	beq L_BRS_8764_8733_OK
	lda $A1B1,Y 
	sta $09 
	sta $0B 
	lda $A1D1,Y 
	sta $0C 
	lda $A1C1,Y 
	sta $0A 
	ldy $15 
	lda ($09),Y 
	cmp #$00
	beq L_BRS_8767_874C_OK
	cmp #$09
	beq L_BRS_8767_8750_OK
	cmp #$08
	beq L_BRS_8764_8754_OK
	lda ($0B),Y 
	cmp #$01
	beq L_BRS_8764_875A_OK
	cmp #$02
	beq L_BRS_8764_875E_OK
	cmp #$03
	bne L_BRS_8767_8762_OK
//------------------------------
L_BRS_8764_871D_OK:
L_BRS_8764_8727_OK:
L_BRS_8764_8733_OK:
L_BRS_8764_8754_OK:
L_BRS_8764_875A_OK:
L_BRS_8764_875E_OK:
//------------------------------
	jmp L_JMP_8882_8764_BAD
//------------------------------
L_BRS_8767_872D_OK:
L_BRS_8767_874C_OK:
L_BRS_8767_8750_OK:
L_BRS_8767_8762_OK:
//------------------------------
	jsr L_JSR_8EE0_8767_OK
	jsr L_JSR_9A43_876A_OK
	jsr L_JSR_8F84_876D_OK
	lda #$06
	ldy $18 
	bmi L_BRS_8778_8774_OK
	lda #$0D
//------------------------------
L_BRS_8778_8774_OK:
//------------------------------
	sta $17 
	inc $1B 
	lda $1B 
	cmp #$05
	bcs L_BRS_87BB_8780_OK
	lda $1B 
	cmp #$02
	bne L_BRS_87B2_8786_OK
	jsr L_JSR_8EF8_8788_OK
	ldy $16 
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $15 
	lda ($0B),Y 
	cmp #$01
	bne L_BRS_87B2_879D_OK
	lda $19 
	bpl L_BRS_87A6_87A1_OK
	dec $130E 
//------------------------------
L_BRS_87A6_87A1_OK:
//------------------------------
	lda $1320 
	sta $19 
	lda #$20
	ldy #$00
	jsr L_JSR_9833_87AF_OK
//------------------------------
L_JMP_87B2_8708_OK:
L_BRS_87B2_8786_OK:
L_BRS_87B2_879D_OK:
//------------------------------
	jsr L_JSR_8EE0_87B2_OK
	jsr L_JSR_9A7E_87B5_OK
	jmp L_JMP_8FAA_87B8_OK
//------------------------------
L_BRS_87BB_8780_OK:
//------------------------------
	lda #$00
	sta $1B 
	ldy $16 
	lda $A1B0,Y 
	sta $09 
	sta $0B 
	lda $A1C0,Y 
	sta $0A 
	lda $A1D0,Y 
	sta $0C 
	ldy $15 
	lda ($0B),Y 
	cmp #$01
	bne L_BRS_87DC_87D8_OK
	lda #$00
//------------------------------
L_BRS_87DC_87D8_OK:
//------------------------------
	sta ($09),Y 
	inc $16 
	ldy $16 
	lda $A1B0,Y 
	sta $09 
	sta $0B 
	lda $A1C0,Y 
	sta $0A 
	lda $A1D0,Y 
	sta $0C 
	ldy $15 
	lda ($09),Y 
	cmp #$09
	bne L_BRS_87FE_87F9_OK
	lsr $1314 
//------------------------------
L_BRS_87FE_87F9_OK:
//------------------------------
	lda ($0B),Y 
	cmp #$01
	bne L_BRS_8855_8802_OK
	lda $19 
	bpl L_BRS_8855_8806_OK
	ldy $16 
	dey 
	sty $50 
	lda $A1B0,Y 
	sta $09 
	sta $0B 
	lda $A1C0,Y 
	sta $0A 
	lda $A1D0,Y 
	sta $0C 
	ldy $15 
	sty $4F 
	lda ($0B),Y 
	cmp #$00
	beq L_BRS_882E_8826_OK
	dec $130E 
	jmp L_JMP_8843_882B_OK
//------------------------------
L_BRS_882E_8826_OK:
//------------------------------
	lda #$07
	sta ($09),Y 
	sta ($0B),Y 
	jsr L_JSR_99F6_8834_OK
	ldy $50 
	ldx $4F 
	jsr L_JSR_9B8B_883B_OK
	lda #$07
	jsr L_JSR_9A7E_8840_OK
//------------------------------
L_JMP_8843_882B_OK:
//------------------------------
	ldy $16 
	lda $A1B0,Y 
	sta $09 
	lda $A1C0,Y 
	sta $0A 
	lda #$00
	sta $19 
	ldy $15 
//------------------------------
L_BRS_8855_8802_OK:
L_BRS_8855_8806_OK:
//------------------------------
	lda #$08
	sta ($09),Y 
	jsr L_JSR_8EE0_8859_OK
	jsr L_JSR_9A7E_885C_OK
	jmp L_JMP_8FAA_885F_OK
//------------------------------
L_JMP_8862_86FA_OK:
//------------------------------
	cpy #$07
	bcc L_BRS_8882_8864_BAD
	jsr L_JSR_8EE0_8866_OK
	jsr L_JSR_9A43_8869_OK
	ldy $19 
	lda $8875,Y 
	sta $1A 
	jsr L_JSR_8EE0_8873_OK
	jsr L_JSR_9A7E_8876_OK
	jmp L_JMP_8FAA_8879_OK
	.byte $02
	ora ($02,X)
	.byte $03,$02
//------------------------------
L_JMP_8882_8764_BAD:
L_BRS_8882_8864_BAD:
//------------------------------
	ora ($A6,X)
	ora $A4,X
	asl $20,X 
	cmp $0A8A,Y 
	tay 
	lda $8895,Y 
	pha 
	lda $8894,Y 
	pha 
	rts 
//------------------------------
	lda #$8F
	tsx 
	.byte $89
	lsr $8A 
	tay 
	dey 
	rol $89,X 
//------------------------------
L_BRS_889E_88B1_OK:
L_BRS_889E_88C4_OK:
L_BRS_889E_88C8_OK:
L_BRS_889E_88CC_OK:
L_BRS_889E_88D0_OK:
//------------------------------
	lda $19 
	beq L_BRS_88A6_88A0_OK
	bmi L_BRS_88A6_88A2_OK
	inc $19 
//------------------------------
L_BRS_88A6_88A0_OK:
L_BRS_88A6_88A2_OK:
//------------------------------
	jmp L_JMP_8FAA_88A6_OK
	ldy $1B 
	cpy #$03
	bcs L_BRS_88D2_88AD_OK
	ldy $16 
	beq L_BRS_889E_88B1_OK
	dey 
	lda $A1B0,Y 
	sta $09 
	lda $A1C0,Y 
	sta $0A 
	ldy $15 
	lda ($09),Y 
	cmp #$01
	beq L_BRS_889E_88C4_OK
	cmp #$02
	beq L_BRS_889E_88C8_OK
	cmp #$05
	beq L_BRS_889E_88CC_OK
	cmp #$08
	beq L_BRS_889E_88D0_OK
//------------------------------
L_BRS_88D2_88AD_OK:
//------------------------------
	jsr L_JSR_8EE0_88D2_OK
	jsr L_JSR_9A43_88D5_OK
	jsr L_JSR_8F84_88D8_OK
	ldy $16 
	lda $A1B0,Y 
	sta $09 
	sta $0B 
	lda $A1C0,Y 
	sta $0A 
	lda $A1D0,Y 
	sta $0C 
	dec $1B 
	bpl L_BRS_8924_88F0_OK
	jsr L_JSR_8F40_88F2_OK
	ldy $15 
	lda ($0B),Y 
	cmp #$01
	bne L_BRS_88FF_88FB_OK
	lda #$00
//------------------------------
L_BRS_88FF_88FB_OK:
//------------------------------
	sta ($09),Y 
	dec $16 
	ldy $16 
	lda $A1B0,Y 
	sta $09 
	lda $A1C0,Y 
	sta $0A 
	ldy $15 
	lda ($09),Y 
	cmp #$09
	bne L_BRS_891A_8915_OK
	lsr $1314 
//------------------------------
L_BRS_891A_8915_OK:
//------------------------------
	lda #$08
	sta ($09),Y 
	lda #$04
	sta $1B 
	bne L_BRS_8927_8922_OK
//------------------------------
L_BRS_8924_88F0_OK:
L_JMP_8924_89B8_OK:
//------------------------------
	jsr L_JSR_8EF8_8924_OK
//------------------------------
L_BRS_8927_8922_OK:
L_JMP_8927_89B5_OK:
//------------------------------
	lda #$0E
	ldx #$0F
	jsr L_JSR_8F76_892B_OK
	jsr L_JSR_8EE0_892E_OK
	jsr L_JSR_9A7E_8931_OK
	jmp L_JMP_8FAA_8934_OK
	ldy $1B 
	cpy #$02
	bcc L_BRS_8961_893B_OK
	ldy $16 
	cpy #$0F
	bcs L_BRS_895E_8941_OK
	iny 
	lda $A1B0,Y 
	sta $09 
	lda $A1C0,Y 
	sta $0A 
	ldy $15 
	lda ($09),Y 
	cmp #$02
	beq L_BRS_895E_8954_OK
	cmp #$08
	beq L_BRS_895E_8958_OK
	cmp #$01
	bne L_BRS_8961_895C_OK
//------------------------------
L_BRS_895E_8941_OK:
L_BRS_895E_8954_OK:
L_BRS_895E_8958_OK:
//------------------------------
	jmp L_JMP_8FAA_895E_OK
//------------------------------
L_BRS_8961_893B_OK:
L_BRS_8961_895C_OK:
//------------------------------
	jsr L_JSR_8EE0_8961_OK
	jsr L_JSR_9A43_8964_OK
	jsr L_JSR_8F84_8967_OK
	ldy $16 
	lda $A1B0,Y 
	sta $09 
	sta $0B 
	lda $A1C0,Y 
	sta $0A 
	lda $A1D0,Y 
	sta $0C 
	inc $1B 
	lda $1B 
	cmp #$05
	bcc L_BRS_89B8_8983_OK
	jsr L_JSR_8F40_8985_OK
	ldy $15 
	lda ($0B),Y 
	cmp #$01
	bne L_BRS_8992_898E_OK
	lda #$00
//------------------------------
L_BRS_8992_898E_OK:
//------------------------------
	sta ($09),Y 
	inc $16 
	ldy $16 
	lda $A1B0,Y 
	sta $09 
	lda $A1C0,Y 
	sta $0A 
	ldy $15 
	lda ($09),Y 
	cmp #$09
	bne L_BRS_89AD_89A8_OK
	lsr $1314 
//------------------------------
L_BRS_89AD_89A8_OK:
//------------------------------
	lda #$08
	sta ($09),Y 
	lda #$00
	sta $1B 
	jmp L_JMP_8927_89B5_OK
//------------------------------
L_BRS_89B8_8983_OK:
//------------------------------
	jmp L_JMP_8924_89B8_OK
	ldy $16 
	lda $A1B0,Y 
	sta $09 
	sta $0B 
	lda $A1C0,Y 
	sta $0A 
	lda $A1D0,Y 
	sta $0C 
	ldx $1A 
	cpx #$03
	bcs L_BRS_89F0_89D2_OK
	ldy $15 
	beq L_BRS_89ED_89D6_OK
	dey 
	lda ($09),Y 
	cmp #$08
	beq L_BRS_89ED_89DD_OK
	cmp #$02
	beq L_BRS_89ED_89E1_OK
	cmp #$01
	beq L_BRS_89ED_89E5_OK
	lda ($0B),Y 
	cmp #$05
	bne L_BRS_89F0_89EB_OK
//------------------------------
L_BRS_89ED_89D6_OK:
L_BRS_89ED_89DD_OK:
L_BRS_89ED_89E1_OK:
L_BRS_89ED_89E5_OK:
//------------------------------
	jmp L_JMP_8FAA_89ED_OK
//------------------------------
L_BRS_89F0_89D2_OK:
L_BRS_89F0_89EB_OK:
//------------------------------
	jsr L_JSR_8EE0_89F0_OK
	jsr L_JSR_9A43_89F3_OK
	jsr L_JSR_8F97_89F6_OK
	lda #$FF
	sta $18 
	dec $1A 
	bpl L_BRS_8A26_89FF_OK
	jsr L_JSR_8F40_8A01_OK
	ldy $15 
	lda ($0B),Y 
	cmp #$01
	bne L_BRS_8A0E_8A0A_OK
	lda #$00
//------------------------------
L_BRS_8A0E_8A0A_OK:
//------------------------------
	sta ($09),Y 
	dec $15 
	dey 
	lda ($09),Y 
	cmp #$09
	bne L_BRS_8A1C_8A17_OK
	lsr $1314 
//------------------------------
L_BRS_8A1C_8A17_OK:
//------------------------------
	lda #$08
	sta ($09),Y 
	lda #$04
	sta $1A 
	bne L_BRS_8A29_8A24_OK
//------------------------------
L_BRS_8A26_89FF_OK:
//------------------------------
	jsr L_JSR_8EF8_8A26_OK
//------------------------------
L_BRS_8A29_8A24_OK:
//------------------------------
	ldy $15 
	lda ($0B),Y 
	cmp #$04
	beq L_BRS_8A37_8A2F_OK
	lda #$00
	ldx #$02
	bne L_BRS_8A3B_8A35_OK
//------------------------------
L_BRS_8A37_8A2F_OK:
//------------------------------
	lda #$03
	ldx #$05
//------------------------------
L_BRS_8A3B_8A35_OK:
//------------------------------
	jsr L_JSR_8F76_8A3B_OK
	jsr L_JSR_8EE0_8A3E_OK
	jsr L_JSR_9A7E_8A41_OK
	jmp L_JMP_8FAA_8A44_OK
	ldy $16 
	lda $A1B0,Y 
	sta $09 
	sta $0B 
	lda $A1C0,Y 
	sta $0A 
	lda $A1D0,Y 
	sta $0C 
	ldx $1A 
	cpx #$02
	bcc L_BRS_8A7E_8A5E_OK
	ldy $15 
	cpy #$1B
	beq L_BRS_8A7B_8A64_OK
	iny 
	lda ($09),Y 
	cmp #$08
	beq L_BRS_8A7B_8A6B_OK
	cmp #$02
	beq L_BRS_8A7B_8A6F_OK
	cmp #$01
	beq L_BRS_8A7B_8A73_OK
	lda ($0B),Y 
	cmp #$05
	bne L_BRS_8A7E_8A79_OK
//------------------------------
L_BRS_8A7B_8A64_OK:
L_BRS_8A7B_8A6B_OK:
L_BRS_8A7B_8A6F_OK:
L_BRS_8A7B_8A73_OK:
//------------------------------
	jmp L_JMP_8FAA_8A7B_OK
//------------------------------
L_BRS_8A7E_8A5E_OK:
L_BRS_8A7E_8A79_OK:
//------------------------------
	jsr L_JSR_8EE0_8A7E_OK
	jsr L_JSR_9A43_8A81_OK
	jsr L_JSR_8F97_8A84_OK
	lda #$01
	sta $18 
	inc $1A 
	lda $1A 
	cmp #$05
	bcc L_BRS_8AB8_8A91_OK
	jsr L_JSR_8F40_8A93_OK
	ldy $15 
	lda ($0B),Y 
	cmp #$01
	bne L_BRS_8AA0_8A9C_OK
	lda #$00
//------------------------------
L_BRS_8AA0_8A9C_OK:
//------------------------------
	sta ($09),Y 
	inc $15 
	iny 
	lda ($09),Y 
	cmp #$09
	bne L_BRS_8AAE_8AA9_OK
	lsr $1314 
//------------------------------
L_BRS_8AAE_8AA9_OK:
//------------------------------
	lda #$08
	sta ($09),Y 
	lda #$00
	sta $1A 
	beq L_BRS_8ABB_8AB6_OK
//------------------------------
L_BRS_8AB8_8A91_OK:
//------------------------------
	jsr L_JSR_8EF8_8AB8_OK
//------------------------------
L_BRS_8ABB_8AB6_OK:
//------------------------------
	ldy $15 
	lda ($0B),Y 
	cmp #$04
	beq L_BRS_8AC9_8AC1_OK
	lda #$07
	ldx #$09
	bne L_BRS_8ACD_8AC7_OK
//------------------------------
L_BRS_8AC9_8AC1_OK:
//------------------------------
	lda #$0A
	ldx #$0C
//------------------------------
L_BRS_8ACD_8AC7_OK:
//------------------------------
	jsr L_JSR_8F76_8ACD_OK
	jsr L_JSR_8EE0_8AD0_OK
	jsr L_JSR_9A7E_8AD3_OK
	jmp L_JMP_8FAA_8AD6_OK
	stx $28 
	sty $29 
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $28 
	lda ($0B),Y 
	cmp #$01
	bne L_BRS_8AF8_8AED_OK
	lda $19 
	beq L_BRS_8AF8_8AF1_OK
	bmi L_BRS_8AF8_8AF3_OK
	lda #$03
	rts 
//------------------------------
L_BRS_8AF8_8AED_OK:
L_BRS_8AF8_8AF1_OK:
L_BRS_8AF8_8AF3_OK:
//------------------------------
	ldy $29 
	cpy $04 
	beq L_BRS_8B01_8AFC_OK
	jmp L_JMP_8B87_8AFE_OK
//------------------------------
L_BRS_8B01_8AFC_OK:
//------------------------------
	ldy $28 
	sty $2A 
	cpy $03 
	bcs L_BRS_8B48_8B07_OK
//------------------------------
L_BRS_8B09_8B43_OK:
//------------------------------
	inc $2A 
	ldy $29 
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $2A 
	lda ($0B),Y 
	cmp #$03
	beq L_BRS_8B3F_8B1D_OK
	cmp #$04
	beq L_BRS_8B3F_8B21_OK
	ldy $29 
	cpy #$0F
	beq L_BRS_8B3F_8B27_OK
	lda $A1B1,Y 
	sta $0B 
	lda $A1D1,Y 
	sta $0C 
	ldy $2A 
	lda ($0B),Y 
	cmp #$00
	beq L_BRS_8B87_8B39_OK
	cmp #$05
	beq L_BRS_8B87_8B3D_OK
//------------------------------
L_BRS_8B3F_8B1D_OK:
L_BRS_8B3F_8B21_OK:
L_BRS_8B3F_8B27_OK:
//------------------------------
	ldy $2A 
	cpy $03 
	bne L_BRS_8B09_8B43_OK
	lda #$02
	rts 
//------------------------------
L_BRS_8B48_8B07_OK:
L_BRS_8B48_8B82_OK:
//------------------------------
	dec $2A 
	ldy $29 
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $2A 
	lda ($0B),Y 
	cmp #$03
	beq L_BRS_8B7E_8B5C_OK
	cmp #$04
	beq L_BRS_8B7E_8B60_OK
	ldy $29 
	cpy #$0F
	beq L_BRS_8B7E_8B66_OK
	lda $A1B1,Y 
	sta $0B 
	lda $A1D1,Y 
	sta $0C 
	ldy $2A 
	lda ($0B),Y 
	cmp #$00
	beq L_BRS_8B87_8B78_OK
	cmp #$05
	beq L_BRS_8B87_8B7C_OK
//------------------------------
L_BRS_8B7E_8B5C_OK:
L_BRS_8B7E_8B60_OK:
L_BRS_8B7E_8B66_OK:
//------------------------------
	ldy $2A 
	cpy $03 
	bne L_BRS_8B48_8B82_OK
	lda #$01
	rts 
//------------------------------
L_JMP_8B87_8AFE_OK:
L_BRS_8B87_8B39_OK:
L_BRS_8B87_8B3D_OK:
L_BRS_8B87_8B78_OK:
L_BRS_8B87_8B7C_OK:
//------------------------------
	lda #$00
	sta $2B 
	lda #$FF
	sta $2C 
	ldx $28 
	ldy $29 
	jsr L_JSR_8E3F_8B93_OK
	jsr L_JSR_8C76_8B96_OK
	jsr L_JSR_8BA2_8B99_OK
	jsr L_JSR_8C0C_8B9C_OK
	lda $2B 
	rts 
//------------------------------
L_JSR_8BA2_8B99_OK:
L_JMP_8BA2_8C08_OK:
//------------------------------
	ldy $2D 
	cpy $28 
	beq L_BRS_8C0B_8BA6_OK
	ldy $29 
	cpy #$0F
	beq L_BRS_8BDA_8BAC_OK
	lda $A1B1,Y 
	sta $0B 
	lda $A1D1,Y 
	sta $0C 
	ldy $2D 
	lda ($0B),Y 
	cmp #$01
	beq L_BRS_8BDA_8BBE_OK
	cmp #$02
	beq L_BRS_8BDA_8BC2_OK
	ldx $2D 
	ldy $29 
	jsr L_JSR_8D9E_8BC8_OK
	ldx $2D 
	jsr L_JSR_8CD5_8BCD_OK
	cmp $2C 
	bcs L_BRS_8BDA_8BD2_OK
	sta $2C 
	lda #$01
	sta $2B 
//------------------------------
L_BRS_8BDA_8BAC_OK:
L_BRS_8BDA_8BBE_OK:
L_BRS_8BDA_8BC2_OK:
L_BRS_8BDA_8BD2_OK:
//------------------------------
	ldy $29 
	beq L_BRS_8C06_8BDC_OK
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $2D 
	lda ($0B),Y 
	cmp #$03
	bne L_BRS_8C06_8BEE_OK
	ldy $29 
	ldx $2D 
	jsr L_JSR_8D01_8BF4_OK
	ldx $2D 
	jsr L_JSR_8CD5_8BF9_OK
	cmp $2C 
	bcs L_BRS_8C06_8BFE_OK
	sta $2C 
	lda #$01
	sta $2B 
//------------------------------
L_BRS_8C06_8BDC_OK:
L_BRS_8C06_8BEE_OK:
L_BRS_8C06_8BFE_OK:
//------------------------------
	inc $2D 
	jmp L_JMP_8BA2_8C08_OK
//------------------------------
L_BRS_8C0B_8BA6_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_8C0C_8B9C_OK:
L_JMP_8C0C_8C72_OK:
//------------------------------
	ldy $2E 
	cpy $28 
	beq L_BRS_8C75_8C10_OK
	ldy $29 
	cpy #$0F
	beq L_BRS_8C44_8C16_OK
	lda $A1B1,Y 
	sta $0B 
	lda $A1D1,Y 
	sta $0C 
	ldy $2E 
	lda ($0B),Y 
	cmp #$01
	beq L_BRS_8C44_8C28_OK
	cmp #$02
	beq L_BRS_8C44_8C2C_OK
	ldx $2E 
	ldy $29 
	jsr L_JSR_8D9E_8C32_OK
	ldx $2E 
	jsr L_JSR_8CD5_8C37_OK
	cmp $2C 
	bcs L_BRS_8C44_8C3C_OK
	sta $2C 
	lda #$02
	sta $2B 
//------------------------------
L_BRS_8C44_8C16_OK:
L_BRS_8C44_8C28_OK:
L_BRS_8C44_8C2C_OK:
L_BRS_8C44_8C3C_OK:
//------------------------------
	ldy $29 
	beq L_BRS_8C70_8C46_OK
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $2E 
	lda ($0B),Y 
	cmp #$03
	bne L_BRS_8C70_8C58_OK
	ldy $29 
	ldx $2E 
	jsr L_JSR_8D01_8C5E_OK
	ldx $2E 
	jsr L_JSR_8CD5_8C63_OK
	cmp $2C 
	bcs L_BRS_8C70_8C68_OK
	sta $2C 
	lda #$02
	sta $2B 
//------------------------------
L_BRS_8C70_8C46_OK:
L_BRS_8C70_8C58_OK:
L_BRS_8C70_8C68_OK:
//------------------------------
	dec $2E 
	jmp L_JMP_8C0C_8C72_OK
//------------------------------
L_BRS_8C75_8C10_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_8C76_8B96_OK:
//------------------------------
	ldy $29 
	cpy #$0F
	beq L_BRS_8CA8_8C7A_OK
	lda $A1B1,Y 
	sta $0B 
	lda $A1D1,Y 
	sta $0C 
	ldy $28 
	lda ($0B),Y 
	cmp #$01
	beq L_BRS_8CA8_8C8C_OK
	cmp #$02
	beq L_BRS_8CA8_8C90_OK
	ldx $28 
	ldy $29 
	jsr L_JSR_8D9E_8C96_OK
	ldx $28 
	jsr L_JSR_8CD5_8C9B_OK
	cmp $2C 
	bcs L_BRS_8CA8_8CA0_OK
	sta $2C 
	lda #$04
	sta $2B 
//------------------------------
L_BRS_8CA8_8C7A_OK:
L_BRS_8CA8_8C8C_OK:
L_BRS_8CA8_8C90_OK:
L_BRS_8CA8_8CA0_OK:
//------------------------------
	ldy $29 
	beq L_BRS_8CD4_8CAA_OK
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $28 
	lda ($0B),Y 
	cmp #$03
	bne L_BRS_8CD4_8CBC_OK
	ldx $28 
	ldy $29 
	jsr L_JSR_8D01_8CC2_OK
	ldx $28 
	jsr L_JSR_8CD5_8CC7_OK
	cmp $2C 
	bcs L_BRS_8CD4_8CCC_OK
	sta $2C 
	lda #$03
	sta $2B 
//------------------------------
L_BRS_8CD4_8CAA_OK:
L_BRS_8CD4_8CBC_OK:
L_BRS_8CD4_8CCC_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_8CD5_8BCD_OK:
L_JSR_8CD5_8BF9_OK:
L_JSR_8CD5_8C37_OK:
L_JSR_8CD5_8C63_OK:
L_JSR_8CD5_8C9B_OK:
L_JSR_8CD5_8CC7_OK:
//------------------------------
	sta $1E 
	cmp $04 
	bne L_BRS_8CEC_8CD9_OK
	cpx $15 
	bcc L_BRS_8CE4_8CDD_OK
	txa 
	sec 
	sbc $15 
	rts 
//------------------------------
L_BRS_8CE4_8CDD_OK:
//------------------------------
	stx $1E 
	lda $15 
	sec 
	sbc $1E 
	rts 
//------------------------------
L_BRS_8CEC_8CD9_OK:
//------------------------------
	bcc L_BRS_8CF5_8CEC_OK
	sec 
	sbc $04 
	clc 
	adc #$C8
	rts 
//------------------------------
L_BRS_8CF5_8CEC_OK:
//------------------------------
	lda $04 
	sec 
	sbc $1E 
	clc 
	adc #$64
	rts 
//------------------------------
L_BRS_8CFE_8D15_OK:
//------------------------------
	lda $31 
	rts 
//------------------------------
L_JSR_8D01_8BF4_OK:
L_JSR_8D01_8C5E_OK:
L_JSR_8D01_8CC2_OK:
//------------------------------
	sty $31 
	stx $30 
//------------------------------
L_JMP_8D05_8D93_OK:
//------------------------------
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $30 
	lda ($0B),Y 
	cmp #$03
	bne L_BRS_8CFE_8D15_OK
	dec $31 
	ldy $30 
	beq L_BRS_8D4B_8D1B_OK
	dey 
	lda ($0B),Y 
	cmp #$01
	beq L_BRS_8D41_8D22_OK
	cmp #$02
	beq L_BRS_8D41_8D26_OK
	cmp #$03
	beq L_BRS_8D41_8D2A_OK
	ldy $31 
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $30 
	dey 
	lda ($0B),Y 
	cmp #$04
	bne L_BRS_8D4B_8D3F_OK
//------------------------------
L_BRS_8D41_8D22_OK:
L_BRS_8D41_8D26_OK:
L_BRS_8D41_8D2A_OK:
//------------------------------
	ldy $31 
	sty $2F 
	cpy $04 
	bcc L_BRS_8D98_8D47_OK
	beq L_BRS_8D98_8D49_OK
//------------------------------
L_BRS_8D4B_8D1B_OK:
L_BRS_8D4B_8D3F_OK:
//------------------------------
	ldy $30 
	cpy #$1B
	beq L_BRS_8D8D_8D4F_OK
	ldy $31 
	lda $A1B1,Y 
	sta $0B 
	lda $A1D1,Y 
	sta $0C 
	ldy $30 
	iny 
	lda ($0B),Y 
	cmp #$01
	beq L_BRS_8D83_8D64_OK
	cmp #$02
	beq L_BRS_8D83_8D68_OK
	cmp #$03
	beq L_BRS_8D83_8D6C_OK
	ldy $31 
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $30 
	iny 
	lda ($0B),Y 
	cmp #$04
	bne L_BRS_8D8D_8D81_OK
//------------------------------
L_BRS_8D83_8D64_OK:
L_BRS_8D83_8D68_OK:
L_BRS_8D83_8D6C_OK:
//------------------------------
	ldy $31 
	sty $2F 
	cpy $04 
	bcc L_BRS_8D98_8D89_OK
	beq L_BRS_8D98_8D8B_OK
//------------------------------
L_BRS_8D8D_8D4F_OK:
L_BRS_8D8D_8D81_OK:
//------------------------------
	ldy $31 
	cpy #$01
	bcc L_BRS_8D96_8D91_OK
	jmp L_JMP_8D05_8D93_OK
//------------------------------
L_BRS_8D96_8D91_OK:
//------------------------------
	tya 
	rts 
//------------------------------
L_BRS_8D98_8D47_OK:
L_BRS_8D98_8D49_OK:
L_BRS_8D98_8D89_OK:
L_BRS_8D98_8D8B_OK:
//------------------------------
	lda $2F 
	rts 
//------------------------------
L_BRS_8D9B_8DB2_OK:
L_BRS_8D9B_8DB6_OK:
//------------------------------
	lda $31 
	rts 
//------------------------------
L_JSR_8D9E_8BC8_OK:
L_JSR_8D9E_8C32_OK:
L_JSR_8D9E_8C96_OK:
//------------------------------
	sty $31 
	stx $30 
//------------------------------
L_JMP_8DA2_8E36_OK:
//------------------------------
	lda $A1B1,Y 
	sta $0B 
	lda $A1D1,Y 
	sta $0C 
	ldy $30 
	lda ($0B),Y 
	cmp #$01
	beq L_BRS_8D9B_8DB2_OK
	cmp #$02
	beq L_BRS_8D9B_8DB6_OK
	ldy $31 
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $30 
	lda ($0B),Y 
	cmp #$00
	beq L_BRS_8E2E_8DCA_OK
	cpy #$00
	beq L_BRS_8DFC_8DCE_OK
	dey 
	lda ($0B),Y 
	cmp #$04
	beq L_BRS_8DF4_8DD5_OK
	ldy $31 
	lda $A1B1,Y 
	sta $0B 
	lda $A1D1,Y 
	sta $0C 
	ldy $30 
	dey 
	lda ($0B),Y 
	cmp #$01
	beq L_BRS_8DF4_8DEA_OK
	cmp #$02
	beq L_BRS_8DF4_8DEE_OK
	cmp #$03
	bne L_BRS_8DFC_8DF2_OK
//------------------------------
L_BRS_8DF4_8DD5_OK:
L_BRS_8DF4_8DEA_OK:
L_BRS_8DF4_8DEE_OK:
//------------------------------
	ldy $31 
	sty $2F 
	cpy $04 
	bcs L_BRS_8E3C_8DFA_OK
//------------------------------
L_BRS_8DFC_8DCE_OK:
L_BRS_8DFC_8DF2_OK:
//------------------------------
	ldy $30 
	cpy #$1B
	bcs L_BRS_8E2E_8E00_OK
	iny 
	lda ($0B),Y 
	cmp #$04
	beq L_BRS_8E26_8E07_OK
	ldy $31 
	lda $A1B1,Y 
	sta $0B 
	lda $A1D1,Y 
	sta $0C 
	ldy $30 
	iny 
	lda ($0B),Y 
	cmp #$01
	beq L_BRS_8E26_8E1C_OK
	cmp #$03
	beq L_BRS_8E26_8E20_OK
	cmp #$02
	bne L_BRS_8E2E_8E24_OK
//------------------------------
L_BRS_8E26_8E07_OK:
L_BRS_8E26_8E1C_OK:
L_BRS_8E26_8E20_OK:
//------------------------------
	ldy $31 
	sty $2F 
	cpy $04 
	bcs L_BRS_8E3C_8E2C_OK
//------------------------------
L_BRS_8E2E_8DCA_OK:
L_BRS_8E2E_8E00_OK:
L_BRS_8E2E_8E24_OK:
//------------------------------
	inc $31 
	ldy $31 
	cpy #$10
	bcs L_BRS_8E39_8E34_OK
	jmp L_JMP_8DA2_8E36_OK
//------------------------------
L_BRS_8E39_8E34_OK:
//------------------------------
	lda #$0F
	rts 
//------------------------------
L_BRS_8E3C_8DFA_OK:
L_BRS_8E3C_8E2C_OK:
//------------------------------
	lda $2F 
	rts 
//------------------------------
L_JSR_8E3F_8B93_OK:
//------------------------------
	stx $2D 
	stx $2E 
	sty $20 
//------------------------------
L_BRS_8E45_8E8D_OK:
//------------------------------
	lda $2D 
	beq L_BRS_8E91_8E47_OK
	ldy $20 
	lda $A1B0,Y 
	sta $09 
	lda $A1C0,Y 
	sta $0A 
	ldy $2D 
	dey 
	lda ($09),Y 
	cmp #$01
	beq L_BRS_8E91_8E5C_OK
	cmp #$02
	beq L_BRS_8E91_8E60_OK
	cmp #$03
	beq L_BRS_8E8B_8E64_OK
	cmp #$04
	beq L_BRS_8E8B_8E68_OK
	ldy $20 
	cpy #$0F
	beq L_BRS_8E8B_8E6E_OK
	lda $A1B1,Y 
	sta $0B 
	lda $A1D1,Y 
	sta $0C 
	ldy $2D 
	dey 
	lda ($0B),Y 
	cmp #$01
	beq L_BRS_8E8B_8E81_OK
	cmp #$02
	beq L_BRS_8E8B_8E85_OK
	cmp #$03
	bne L_BRS_8E8F_8E89_OK
//------------------------------
L_BRS_8E8B_8E64_OK:
L_BRS_8E8B_8E68_OK:
L_BRS_8E8B_8E6E_OK:
L_BRS_8E8B_8E81_OK:
L_BRS_8E8B_8E85_OK:
//------------------------------
	dec $2D 
	bpl L_BRS_8E45_8E8D_OK
//------------------------------
L_BRS_8E8F_8E89_OK:
//------------------------------
	dec $2D 
//------------------------------
L_BRS_8E91_8E47_OK:
L_BRS_8E91_8E5C_OK:
L_BRS_8E91_8E60_OK:
L_BRS_8E91_8EDB_OK:
//------------------------------
	lda $2E 
	cmp #$1B
	beq L_BRS_8EDF_8E95_OK
	ldy $20 
	lda $A1B0,Y 
	sta $09 
	lda $A1C0,Y 
	sta $0A 
	ldy $2E 
	iny 
	lda ($09),Y 
	cmp #$01
	beq L_BRS_8EDF_8EAA_OK
	cmp #$02
	beq L_BRS_8EDF_8EAE_OK
	cmp #$03
	beq L_BRS_8ED9_8EB2_OK
	cmp #$04
	beq L_BRS_8ED9_8EB6_OK
	ldy $20 
	cpy #$0F
	beq L_BRS_8ED9_8EBC_OK
	lda $A1B1,Y 
	sta $0B 
	lda $A1D1,Y 
	sta $0C 
	ldy $2E 
	iny 
	lda ($0B),Y 
	cmp #$01
	beq L_BRS_8ED9_8ECF_OK
	cmp #$02
	beq L_BRS_8ED9_8ED3_OK
	cmp #$03
	bne L_BRS_8EDD_8ED7_OK
//------------------------------
L_BRS_8ED9_8EB2_OK:
L_BRS_8ED9_8EB6_OK:
L_BRS_8ED9_8EBC_OK:
L_BRS_8ED9_8ECF_OK:
L_BRS_8ED9_8ED3_OK:
//------------------------------
	inc $2E 
	bpl L_BRS_8E91_8EDB_OK
//------------------------------
L_BRS_8EDD_8ED7_OK:
//------------------------------
	inc $2E 
//------------------------------
L_BRS_8EDF_8E95_OK:
L_BRS_8EDF_8EAA_OK:
L_BRS_8EDF_8EAE_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_8EE0_8767_OK:
L_JSR_8EE0_87B2_OK:
L_JSR_8EE0_8859_OK:
L_JSR_8EE0_8866_OK:
L_JSR_8EE0_8873_OK:
L_JSR_8EE0_88D2_OK:
L_JSR_8EE0_892E_OK:
L_JSR_8EE0_8961_OK:
L_JSR_8EE0_89F0_OK:
L_JSR_8EE0_8A3E_OK:
L_JSR_8EE0_8A7E_OK:
L_JSR_8EE0_8AD0_OK:
L_JSR_8EE0_90B3_OK:
L_JSR_8EE0_9164_OK:
//------------------------------
	ldx $15 
	ldy $1A 
	jsr L_JSR_9B96_8EE4_OK
	stx $23 
	ldy $16 
	ldx $1B 
	jsr L_JSR_9BA4_8EED_OK
	ldx $17 
	lda $86C9,X 
	ldx $23 
	rts 
//------------------------------
L_JSR_8EF8_8788_OK:
L_JSR_8EF8_8924_OK:
L_JSR_8EF8_8A26_OK:
L_JSR_8EF8_8AB8_OK:
L_JMP_8EF8_8F8E_OK:
L_JMP_8EF8_8F93_OK:
L_JMP_8EF8_8FA1_OK:
L_JMP_8EF8_8FA6_OK:
//------------------------------
	lda $1A 
	cmp #$02
	bne L_BRS_8F3F_8EFC_OK
	lda $1B 
	cmp #$02
	bne L_BRS_8F3F_8F02_OK
	ldy $16 
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $15 
	lda ($0B),Y 
	cmp #$07
	bne L_BRS_8F3F_8F16_OK
	lda $19 
	bmi L_BRS_8F3F_8F1A_OK
	lda #$FF
	sec 
	sbc $131E 
	sta $19 
	lda #$00
	sta ($0B),Y 
	ldy $16 
	sty $50 
	ldy $15 
	sty $4F 
	jsr L_JSR_99F6_8F30_OK
	ldy $50 
	ldx $4F 
	jsr L_JSR_9B8B_8F37_OK
	lda #$07
	jmp L_JMP_9A43_8F3C_OK
//------------------------------
L_BRS_8F3F_8EFC_OK:
L_BRS_8F3F_8F02_OK:
L_BRS_8F3F_8F16_OK:
L_BRS_8F3F_8F1A_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_8F40_88F2_OK:
L_JSR_8F40_8985_OK:
L_JSR_8F40_8A01_OK:
L_JSR_8F40_8A93_OK:
//------------------------------
	lda $19 
	bpl L_BRS_8F75_8F42_OK
	inc $19 
	bne L_BRS_8F75_8F46_OK
	ldy $16 
	sty $50 
	lda $A1B0,Y 
	sta $0B 
	lda $A1D0,Y 
	sta $0C 
	ldy $15 
	sty $4F 
	lda ($0B),Y 
	cmp #$00
	bne L_BRS_8F73_8F5E_OK
	lda #$07
	sta ($0B),Y 
	jsr L_JSR_99F6_8F64_OK
	ldy $50 
	ldx $4F 
	jsr L_JSR_9B8B_8F6B_OK
	lda #$07
	jmp L_JMP_9A7E_8F70_OK
//------------------------------
L_BRS_8F73_8F5E_OK:
//------------------------------
	dec $19 
//------------------------------
L_BRS_8F75_8F42_OK:
L_BRS_8F75_8F46_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_8F76_892B_OK:
L_JSR_8F76_8A3B_OK:
L_JSR_8F76_8ACD_OK:
//------------------------------
	inc $17 
	cmp $17 
	bcc L_BRS_8F7F_8F7A_OK
//------------------------------
L_BRS_8F7C_8F81_OK:
//------------------------------
	sta $17 
	rts 
//------------------------------
L_BRS_8F7F_8F7A_OK:
//------------------------------
	cpx $17 
	bcc L_BRS_8F7C_8F81_OK
	rts 
//------------------------------
L_JSR_8F84_876D_OK:
L_JSR_8F84_88D8_OK:
L_JSR_8F84_8967_OK:
//------------------------------
	lda $1A 
	cmp #$02
	bcc L_BRS_8F91_8F88_OK
	beq L_BRS_8F96_8F8A_OK
	dec $1A 
	jmp L_JMP_8EF8_8F8E_OK
//------------------------------
L_BRS_8F91_8F88_OK:
//------------------------------
	inc $1A 
	jmp L_JMP_8EF8_8F93_OK
//------------------------------
L_BRS_8F96_8F8A_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_8F97_89F6_OK:
L_JSR_8F97_8A84_OK:
//------------------------------
	lda $1B 
	cmp #$02
	bcc L_BRS_8FA4_8F9B_OK
	beq L_BRS_8FA9_8F9D_OK
	dec $1B 
	jmp L_JMP_8EF8_8FA1_OK
//------------------------------
L_BRS_8FA4_8F9B_OK:
//------------------------------
	inc $1B 
	jmp L_JMP_8EF8_8FA6_OK
//------------------------------
L_BRS_8FA9_8F9D_OK:
//------------------------------
	rts 
//------------------------------
L_JMP_8FAA_8705_OK:
L_JMP_8FAA_87B8_OK:
L_JMP_8FAA_885F_OK:
L_JMP_8FAA_8879_OK:
L_JMP_8FAA_88A6_OK:
L_JMP_8FAA_8934_OK:
L_JMP_8FAA_895E_OK:
L_JMP_8FAA_89ED_OK:
L_JMP_8FAA_8A44_OK:
L_JMP_8FAA_8A7B_OK:
L_JMP_8FAA_8AD6_OK:
//------------------------------
	ldx $131F 
	lda $15 
	sta $1260,X 
	lda $16 
	sta $1268,X 
	lda $1A 
	sta $1278,X 
	lda $1B 
	sta $1280,X 
	lda $19 
	sta $1270,X 
	lda $18 
	sta $1290,X 
	lda $17 
	sta $1288,X 
	rts 
//------------------------------
L_JSR_8FD1_86E9_OK:
L_JSR_8FD1_90B0_OK:
L_JSR_8FD1_9138_OK:
//------------------------------
	ldx $131F 
	lda $1260,X 
	sta $15 
	lda $1268,X 
	sta $16 
	lda $1278,X 
	sta $1A 
	lda $1280,X 
	sta $1B 
	lda $1288,X 
	sta $17 
	lda $1290,X 
	sta $18 
	lda $1270,X 
	sta $19 
	rts 
//------------------------------
L_JSR_8FF8_618E_OK:
//------------------------------
	jsr L_JSR_9127_8FF8_OK
	inc $131E 
	lda $131E 
	cmp #$1C
	bcc L_BRS_900A_9003_OK
	lda #$00
	sta $131E 
//------------------------------
L_BRS_900A_9003_OK:
//------------------------------
	ldx #$1E
//------------------------------
L_JMP_900C_9123_OK:
//------------------------------
	lda $12E0,X 
	stx $52 
	bne L_BRS_9016_9011_OK
	jmp L_JMP_911E_9013_OK
//------------------------------
L_BRS_9016_9011_OK:
//------------------------------
	dec $12E0,X 
	beq L_BRS_9048_9019_OK
	lda $12A0,X 
	sta $4F 
	lda $12C0,X 
	sta $50 
	lda $12E0,X 
	cmp #$14
	bne L_BRS_9040_902A_OK
	lda #$38
//------------------------------
L_BRS_902E_9046_OK:
//------------------------------
	jsr L_JSR_99F6_902E_OK
	ldx $4F 
	ldy $50 
	jsr L_JSR_9B8B_9035_OK
	lda #$00
	jsr L_JSR_9A43_903A_OK
//------------------------------
L_BRS_903D_9042_OK:
//------------------------------
	jmp L_JMP_911E_903D_OK
//------------------------------
L_BRS_9040_902A_OK:
//------------------------------
	cmp #$0A
	bne L_BRS_903D_9042_OK
	lda #$39
	bne L_BRS_902E_9046_OK
//------------------------------
L_BRS_9048_9019_OK:
//------------------------------
	ldx $52 
	ldy $12C0,X 
	sty $50 
	jsr L_JSR_9BC7_904F_OK
	ldy $12A0,X 
	sty $4F 
	lda ($09),Y 
	cmp #$00
	bne L_BRS_9060_905B_OK
	jmp L_JMP_9112_905D_OK
//------------------------------
L_BRS_9060_905B_OK:
//------------------------------
	cmp #$09
	bne L_BRS_9067_9062_OK
	lsr $1314 
//------------------------------
L_BRS_9067_9062_OK:
//------------------------------
	cmp #$08
	beq L_BRS_9075_9069_OK
	cmp #$07
	bne L_BRS_9072_906D_OK
	dec $130E 
//------------------------------
L_BRS_9072_906D_OK:
//------------------------------
	jmp L_JMP_9112_9072_OK
//------------------------------
L_BRS_9075_9069_OK:
//------------------------------
	lda #$01
	sta ($09),Y 
	sta ($0B),Y 
	jsr L_JSR_99F0_907B_OK
	lda #$01
	jsr L_JSR_99F6_9080_OK
	ldx $131C 
//------------------------------
L_JMP_9086_910F_OK:
//------------------------------
	lda $1260,X 
	cmp $4F 
	beq L_BRS_9090_908B_OK
	jmp L_JMP_910C_908D_OK
//------------------------------
L_BRS_9090_908B_OK:
//------------------------------
	lda $1268,X 
	cmp $50 
	bne L_BRS_910C_9095_OK
	lda $A0C6,X 
	and $D015 
	sta $D015 
	lda $1270,X 
	bpl L_BRS_90A8_90A3_OK
	dec $130E 
//------------------------------
L_BRS_90A8_90A3_OK:
//------------------------------
	lda #$7F
	sta $1270,X 
	stx $131F 
	jsr L_JSR_8FD1_90B0_OK
	jsr L_JSR_8EE0_90B3_OK
	jsr L_JSR_9A43_90B6_OK
	ldx $131F 
	ldy #$01
	sty $50 
//------------------------------
L_BRS_90C0_90E5_OK:
//------------------------------
	ldy $50 
	jsr L_JSR_9BC7_90C2_OK
	ldy $131E 
//------------------------------
L_BRS_90C8_90DC_OK:
//------------------------------
	lda ($0B),Y 
	cmp #$00
	bne L_BRS_90D4_90CC_OK
	lda ($09),Y 
	cmp #$00
	beq L_BRS_90E7_90D2_OK
//------------------------------
L_BRS_90D4_90CC_OK:
//------------------------------
	inc $131E 
	ldy $131E 
	cpy #$1C
	bcc L_BRS_90C8_90DC_OK
	inc $50 
	lda #$00
	sta $131E 
	beq L_BRS_90C0_90E5_OK
//------------------------------
L_BRS_90E7_90D2_OK:
//------------------------------
	tya 
	sta $1260,X 
	lda $50 
	sta $1268,X 
	lda #$14
	sta $1298,X 
	lda #$02
	sta $1280,X 
	sta $1278,X 
	lda #$00
	sta $1288,X 
	lda #$15
	ldy #$00
	jsr L_JSR_9833_9106_OK
	jmp L_JMP_911E_9109_OK
//------------------------------
L_JMP_910C_908D_OK:
L_BRS_910C_9095_OK:
//------------------------------
	dex 
	beq L_BRS_9112_910D_OK
	jmp L_JMP_9086_910F_OK
//------------------------------
L_JMP_9112_905D_OK:
L_JMP_9112_9072_OK:
L_BRS_9112_910D_OK:
//------------------------------
	lda #$01
	sta ($09),Y 
	jsr L_JSR_99F0_9116_OK
	lda #$01
	jsr L_JSR_99F6_911B_OK
//------------------------------
L_JMP_911E_9013_OK:
L_JMP_911E_903D_OK:
L_JMP_911E_9109_OK:
//------------------------------
	ldx $52 
	dex 
	bmi L_BRS_9126_9121_OK
	jmp L_JMP_900C_9123_OK
//------------------------------
L_BRS_9126_9121_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_9127_8FF8_OK:
//------------------------------
	ldx $131C 
	beq L_BRS_9175_912A_OK
	lda $131F 
	pha 
//------------------------------
L_BRS_9130_916F_OK:
//------------------------------
	lda $1298,X 
	beq L_BRS_916E_9133_OK
	stx $131F 
	jsr L_JSR_8FD1_9138_OK
	lda #$7F
	sta $1270,X 
	lda $1260,X 
	sta $4F 
	lda $1268,X 
	sta $50 
	lda $1298,X 
	cmp #$14
	bcc L_BRS_9154_914F_OK
	jsr L_JSR_969B_9151_OK
//------------------------------
L_BRS_9154_914F_OK:
//------------------------------
	dec $1298,X 
	beq L_BRS_9176_9157_OK
	lda $1298,X 
	tax 
	lda $A0A6,X 
	pha 
	jsr L_JSR_99F6_9161_OK
	jsr L_JSR_8EE0_9164_OK
	pla 
	jsr L_JSR_9A7E_9168_OK
	ldx $131F 
//------------------------------
L_BRS_916E_9133_OK:
L_JMP_916E_91B8_OK:
//------------------------------
	dex 
	bne L_BRS_9130_916F_OK
	pla 
	sta $131F 
//------------------------------
L_BRS_9175_912A_OK:
//------------------------------
	rts 
//------------------------------
L_BRS_9176_9157_OK:
//------------------------------
	ldy $50 
	jsr L_JSR_9BC7_9178_OK
	ldy $4F 
	lda #$08
	sta ($09),Y 
	lda ($0B),Y 
	beq L_BRS_9192_9183_OK
	lda #$03
	jsr L_JSR_99F6_9187_OK
	lda #$03
	jsr L_JSR_99F0_918C_OK
	jmp L_JMP_919C_918F_OK
//------------------------------
L_BRS_9192_9183_OK:
//------------------------------
	lda #$00
	jsr L_JSR_99F6_9194_OK
	lda #$00
	jsr L_JSR_99F0_9199_OK
//------------------------------
L_JMP_919C_918F_OK:
//------------------------------
	lda #$08
	jsr L_JSR_99F0_919E_OK
	lda #$00
	ldx $131F 
	sta $1270,X 
	sta $1298,X 
	ldx $131F 
	lda $A0C0,X 
	ora $D015
	sta $D015 
	jmp L_JMP_916E_91B8_OK
//------------------------------
L_JSR_91BB_834A_OK:
L_JSR_91BB_8368_OK:
//------------------------------
	pha 
	lda #$20
	sta $51 
	lda $1310 
	sta $1351 
	lda #$98
	sta $1310 
	lda #$C4
	sta $7A2C 
	sta $7A46 
	lda #$01
	jsr L_JSR_7896_91D5_OK
	pla 
	cmp #$AA
	bne L_BRS_91F1_91DB_OK
	jmp L_JMP_93F1_91DD_OK
//------------------------------
L_JMP_91E0_93EE_OK:
L_JMP_91E0_94F8_OK:
//------------------------------
	lda #$10
	sta $7A2C 
	sta $7A46 
	jsr L_JSR_9C31_91E8_OK
	jsr L_JSR_69AA_91EB_OK
	jmp L_JMP_6A07_91EE_OK
//------------------------------
L_BRS_91F1_91DB_OK:
L_JMP_91F1_92F4_OK:
//------------------------------
	jsr L_JSR_94FB_91F1_OK
//------------------------------
L_JMP_91F4_9271_OK:
L_JMP_91F4_92EC_OK:
L_JMP_91F4_9372_OK:
//------------------------------
	jsr L_JSR_71F7_91F4_OK
	jsr L_JSR_9951_91F7_OK
	ldy #$D3
	ldy #$D7
	.byte $D2
	cmp #$D4
	cmp $D3 
	ldy #$A0
	cmp ($A0,X) 
	.byte $C7
	cmp ($CD,X) 
	cmp $A0 
	cmp #$CE
	.byte $D4,$CF
	ldy #$CC
	cmp #$D3
	.byte $D4
	sta $C4A0 
	ldy #$C4
	cmp $CC 
	cmp $D4 
	cmp $D3 
	ldy #$C1
	ldy #$C7
	cmp ($CD,X) 
	cmp $A0 
	dec $D2 
	.byte $CF
	cmp $CCA0 
	cmp #$D3
	.byte $D4
	sta $A0A0 
	ldy $AFD2,X 
	.byte $D3
	ldx $C3A0,Y 
	.byte $CF
	dec $C9D4 
	dec $C5D5 
	.byte $D3
	ldy #$D4
	iny 
	cmp $A0 
	.byte $C7
	cmp ($CD,X) 
	cmp $00 
	lda #$00
	sta $1328 
//------------------------------
L_BRS_9252_9255_OK:
//------------------------------
	jsr L_JSR_99CD_9252_OK
	bcc L_BRS_9252_9255_OK
	ldx #$00
	stx $1328 
	cmp #$0D
	bne L_BRS_9263_925E_OK
	jmp L_JMP_92F7_9260_OK
//------------------------------
L_BRS_9263_925E_OK:
//------------------------------
	cmp #$12
	beq L_BRS_9274_9265_OK
	cmp #$3F
	bne L_BRS_926E_9269_OK
	jmp L_JMP_93E8_926B_OK
//------------------------------
L_BRS_926E_9269_OK:
//------------------------------
	jsr L_JSR_9971_926E_OK
	jmp L_JMP_91F4_9271_OK
//------------------------------
L_BRS_9274_9265_OK:
//------------------------------
	jsr L_JSR_71F7_9274_OK
	jsr L_JSR_9951_9277_OK
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$C4
	cmp $CC 
	cmp $D4 
	cmp $A0 
	cmp ($CE,X) 
	ldy #$C5
	dec $D2D4 
	cmp $A0A0,Y 
	ldy #$A0
	ldy #$A0
	sta $A0A0 
	ldy #$A0
	ldy #$A0
	ldy #$CE
	cmp ($CD,X) 
	cmp $A0 
	ldx $A0A0,Y 
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy $A0A0,X 
	ldy #$A0
	ldy #$A0
	sta $A0A0 
	ldy #$A0
	ldy #$A0
	ldy #$BC
	.byte $D2,$AF,$D3
	ldx $A0A0,Y 
	.byte $D4,$CF
	ldy #$C1
	.byte $C2,$CF,$D2,$D4
	ldy #$A0
	ldy #$A0
	ldy #$A0
	.byte $00
	lda #$0D
	sta $4F 
	dec $50 
	sec 
	ldy #$08
	jsr L_JSR_76D2_92DA_OK
	bcs L_BRS_92EC_92DD_OK
	beq L_BRS_92EC_92DF_OK
	jsr L_JSR_9616_92E1_OK
	bcs L_BRS_92EF_92E4_OK
	jsr L_JSR_9971_92E6_OK
	jsr L_JSR_9971_92E9_OK
//------------------------------
L_BRS_92EC_92DD_OK:
L_BRS_92EC_92DF_OK:
//------------------------------
	jmp L_JMP_91F4_92EC_OK
//------------------------------
L_BRS_92EF_92E4_OK:
//------------------------------
	lda #$02
	jsr L_JSR_7896_92F1_OK
	jmp L_JMP_91F1_92F4_OK
//------------------------------
L_JMP_92F7_9260_OK:
//------------------------------
	jsr L_JSR_71F7_92F7_OK
	jsr L_JSR_9951_92FA_OK
	ldy #$A0
	ldy #$D3
	cmp ($D6,X) 
	cmp $A0 
	.byte $C7
	cmp ($CD,X) 
	cmp $A0 
	cmp #$CE
	ldy #$D0
	.byte $D2,$CF,$C7,$D2
	cmp $D3 
	.byte $D3
	ldy #$A0
	ldy #$A0
	sta $A0A0 
	ldy #$A0
	ldy #$CE
	cmp ($CD,X) 
	cmp $A0 
	ldx $A0A0,Y 
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy $A0A0,X 
	ldy #$A0
	ldy #$A0
	ldy #$A0
	sta $A0A0 
	ldy #$A0
	ldy #$A0
	ldy $AFD2,X 
	.byte $D3
	ldx $D4A0,Y 
	.byte $CF
	ldy #$C1
	.byte $C2,$CF,$D2,$D4
	ldy #$A0
	ldy #$A0
	ldy #$A0
	.byte $00
	lda #$0B
	sta $4F 
	dec $50 
	sec 
	ldy #$08
	jsr L_JSR_76D2_935B_OK
	bcs L_BRS_9372_935E_OK
	beq L_BRS_9372_9360_OK
	jsr L_JSR_9629_9362_OK
	bcs L_BRS_9375_9365_OK
	jsr L_JSR_964D_9367_OK
	bcs L_BRS_9375_936A_OK
	jsr L_JSR_9971_936C_OK
	jsr L_JSR_9971_936F_OK
//------------------------------
L_BRS_9372_935E_OK:
L_BRS_9372_9360_OK:
//------------------------------
	jmp L_JMP_91F4_9372_OK
//------------------------------
L_BRS_9375_9365_OK:
L_BRS_9375_936A_OK:
//------------------------------
	tay 
	ldx #$00
//------------------------------
L_BRS_9378_9382_OK:
//------------------------------
	lda $133D,X 
	sta $C400,Y 
	iny 
	inx 
	cpx #$08
	bcc L_BRS_9378_9382_OK
	lda $135F 
	bpl L_BRS_938F_9387_OK
	lda $135E 
	jmp L_JMP_9392_938C_OK
//------------------------------
L_BRS_938F_9387_OK:
//------------------------------
	lda $1305 
//------------------------------
L_JMP_9392_938C_OK:
//------------------------------
	sta $C400,Y 
	iny 
	lda $1351 
	sta $C400,Y 
	iny 
	lda $1312 
	sta $C400,Y 
	iny 
	lda $130D 
	sta $C400,Y 
	iny 
	lda $130C 
	sta $C400,Y 
	iny 
	lda $130B 
	sta $C400,Y 
	iny 
	lda $130A 
	sta $C400,Y 
	iny 
	lda $135F 
	sta $C400,Y 
	lda #$02
	jsr L_JSR_7896_93C8_OK
	inc $1310 
	lda #$C5
	sta $7A46 
//------------------------------
L_BRS_93D4_9406_BAD:
//------------------------------
	lda #$02
	jsr L_JSR_7896_93D5_OK
	dec $1310 
	lda #$C4
	sta $7A46 
	jsr L_JSR_94FB_93E0_OK
	lda #$01
	jsr L_JSR_630E_93E5_OK
//------------------------------
L_JMP_93E8_926B_OK:
//------------------------------
	lda $1351 
	sta $1310 
	jmp L_JMP_91E0_93EE_OK
//------------------------------
L_JMP_93F1_91DD_OK:
//------------------------------
	jsr L_JSR_94FB_93F1_OK
//------------------------------
L_BRS_93F4_944C_OK:
L_JMP_93F4_9459_OK:
//------------------------------
	jsr L_JSR_71F7_93F4_OK
	jsr L_JSR_9951_93F7_OK
	ldy #$A0
	ldy #$CC
	.byte $CF
	cmp ($C4,X) 
	ldy #$C1
	dec $A0C4 
	bne L_BRS_93D4_9406_BAD
	cmp ($D9,X) 
	ldy #$C1
	ldy #$C7
	cmp ($CD,X) 
	cmp $8D 
	ldy #$A0
	ldy #$A0
	dec $CDC1 
	cmp $A0 
	ldy #$A0
	ldx $A0A0,Y 
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy $A08D,X 
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy $AFD2,X 
	.byte $D3
	ldx $D4A0,Y 
	.byte $CF
	ldy #$C1
	.byte $C2,$CF,$D2,$D4,$00
	dec $50 
	lda #$0C
	sta $4F 
	sec 
	ldy #$08
	jsr L_JSR_76D2_9447_OK
	bcs L_BRS_945C_944A_OK
	beq L_BRS_93F4_944C_OK
	jsr L_JSR_9629_944E_OK
	bcs L_BRS_9465_9451_OK
	jsr L_JSR_9971_9453_OK
	jsr L_JSR_9971_9456_OK
	jmp L_JMP_93F4_9459_OK
//------------------------------
L_BRS_945C_944A_OK:
//------------------------------
	lda $1351 
	sta $1310 
	jmp L_JMP_94F8_9462_OK
//------------------------------
L_BRS_9465_9451_OK:
//------------------------------
	clc 
	adc #$08
	tay 
	lda $C400,Y 
	sta $1305 
	sta $135E 
	lda $C401,Y 
	pha 
	lda $C402,Y 
	sta $1312 
	sec 
	sbc #$01
	sta $C402,Y 
	lda $C403,Y 
	sta $130D 
	lda $C404,Y 
	sta $130C 
	lda $C405,Y 
	sta $130B 
	lda $C406,Y 
	sta $130A 
	lda $C407,Y 
	sta $135F 
	lda $1312 
	cmp #$01
	bne L_BRS_94AA_94A5_OK
	jsr L_JSR_9616_94A7_OK
//------------------------------
L_BRS_94AA_94A5_OK:
//------------------------------
	lda #$02
	jsr L_JSR_7896_94AC_OK
	inc $1310 
	lda #$C5
	sta $7A2C 
	lda #$01
	jsr L_JSR_7896_94B9_OK
	dec $1310 
	lda #$C4
	sta $7A2C 
	jsr L_JSR_9C31_94C4_OK
	jsr L_JSR_9C1A_94C7_OK
	pla 
	sta $1310 
	tay 
	lda $135F 
	cmp #$FF
	bne L_BRS_94DA_94D4_OK
	iny 
	sty $1305 
//------------------------------
L_BRS_94DA_94D4_OK:
//------------------------------
	ldy #$FF
	sty $133B 
	iny 
	sty $1311 
	sty $131E 
	tya 
	jsr L_JSR_9833_94E7_OK
	jsr L_JSR_980D_94EA_OK
	jsr L_JSR_9821_94ED_OK
	jsr L_JSR_6797_94F0_OK
	lda #$01
	sta $1318 
//------------------------------
L_JMP_94F8_9462_OK:
//------------------------------
	jmp L_JMP_91E0_94F8_OK
//------------------------------
L_JSR_94FB_91F1_OK:
L_JSR_94FB_93E0_OK:
L_JSR_94FB_93F1_OK:
//------------------------------
	lda #$20
	sta $51 
	jsr L_JSR_95E1_94FF_OK
	jsr L_JSR_9C31_9502_OK
	lda #$73
	tax 
	ldy #$01
	jsr L_JSR_6998_950A_OK
	lda #$00
	sta $4F 
	lda #$04
	sta $50 
	jsr L_JSR_9951_9515_OK
	ldy #$A0
	dec $CDC1 
	cmp $A0 
	ldy #$A0
	ldy #$CC
	cmp $D6 
	cmp $CC 
	ldy #$CD
	cmp $CE 
	ldy #$A0
	.byte $D3,$C3,$CF,$D2
	cmp $D3 
	sta $ADAD 
	lda $ADAD 
	lda $ADAD 
	ldy #$A0
	lda $ADAD 
	lda $A0AD 
	lda $ADAD 
	ldy #$AD
	lda $ADAD 
	lda $ADAD 
	lda $008D 
	ldy #$00
	sty $1C 
//------------------------------
L_JMP_9556_95DD_OK:
//------------------------------
	lda #$08
	sta $1D 
//------------------------------
L_BRS_955A_9566_OK:
//------------------------------
	ldy $1C 
	lda $C400,Y 
	jsr L_JSR_76B9_955F_OK
	inc $1C 
	dec $1D 
	bne L_BRS_955A_9566_OK
	inc $4F 
	inc $4F 
	inc $4F 
	ldy $1C 
	inc $1C 
	inc $1C 
	lda $C400,Y 
	cmp #$A0
	bne L_BRS_957E_9579_OK
	jmp L_JMP_95D0_957B_OK
//------------------------------
L_BRS_957E_9579_OK:
//------------------------------
	jsr L_JSR_9674_957E_OK
	inc $4F 
	inc $4F 
	ldy $1C 
	inc $1C 
	lda $C400,Y 
	jsr L_JSR_9674_958C_OK
	inc $4F 
	ldy $1C 
	inc $1C 
	lda $C400,Y 
	jsr L_JSR_966E_9598_OK
	ldy $1C 
	inc $1C 
	lda $C400,Y 
	jsr L_JSR_966E_95A2_OK
	ldy $1C 
	inc $1C 
	lda $C400,Y 
	jsr L_JSR_966E_95AC_OK
	ldy $1C 
	inc $1C 
	lda $C400,Y 
	jsr L_JSR_966E_95B6_OK
	ldy $1C 
	lda $C400,Y 
	cmp #$FF
	bne L_BRS_95CB_95C0_OK
	lda #$0A
	sta $4F 
	lda #$BE
	jsr L_JSR_76B9_95C8_OK
//------------------------------
L_BRS_95CB_95C0_OK:
//------------------------------
	lda #$8D
	jsr L_JSR_76B9_95CD_OK
//------------------------------
L_JMP_95D0_957B_OK:
//------------------------------
	lda $1C 
	and #$F0
	clc 
	adc #$10
	sta $1C 
	cmp #$A0
	beq L_BRS_95E0_95DB_OK
	jmp L_JMP_9556_95DD_OK
//------------------------------
L_BRS_95E0_95DB_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_95E1_94FF_OK:
//------------------------------
	lda $C4F0 
	cmp #$C8
	bne L_BRS_95F7_95E6_OK
	lda $C4F1 
	cmp #$C2
	bne L_BRS_95F7_95ED_OK
	lda $C4F2 
	cmp #$D5
	bne L_BRS_95F7_95F4_OK
	rts 
//------------------------------
L_BRS_95F7_95E6_OK:
L_BRS_95F7_95ED_OK:
L_BRS_95F7_95F4_OK:
//------------------------------
	ldx #$00
	lda #$A0
//------------------------------
L_BRS_95FB_95FF_OK:
//------------------------------
	sta $C400,X 
	inx 
	bne L_BRS_95FB_95FF_OK
	lda #$C8
	sta $C4F0 
	lda #$C2
	sta $C4F1 
	lda #$D5
	sta $C4F2 
	lda #$02
	jsr L_JSR_7896_9612_OK
	rts 
//------------------------------
L_JSR_9616_92E1_OK:
L_JSR_9616_94A7_OK:
//------------------------------
	jsr L_JSR_9629_9616_OK
	bcc L_BRS_9628_9619_OK
	tay 
//------------------------------
L_BRS_961C_9625_OK:
//------------------------------
	lda $C410,Y 
	sta $C400,Y 
	iny 
	cpy #$A0
	bcc L_BRS_961C_9625_OK
	sec 
//------------------------------
L_BRS_9628_9619_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_9629_9362_OK:
L_JSR_9629_944E_OK:
L_JSR_9629_9616_OK:
//------------------------------
	ldy #$00
//------------------------------
L_BRS_962B_9649_OK:
//------------------------------
	ldx #$00
//------------------------------
L_BRS_962D_9639_OK:
//------------------------------
	lda $C400,Y 
	cmp $133D,X 
	bne L_BRS_9640_9633_OK
	iny 
	inx 
	cpx #$08
	bne L_BRS_962D_9639_OK
	tya 
	and #$F0
	sec 
	rts 
//------------------------------
L_BRS_9640_9633_OK:
//------------------------------
	tya 
	and #$F0
	clc 
	adc #$10
	tay 
	cmp #$A0
	bne L_BRS_962B_9649_OK
	clc 
	rts 
//------------------------------
L_JSR_964D_9367_OK:
//------------------------------
	ldy #$00
//------------------------------
L_BRS_964F_966A_OK:
//------------------------------
	ldx #$08
	lda #$A0
//------------------------------
L_BRS_9653_965A_OK:
//------------------------------
	cmp $C400,Y 
	bne L_BRS_9661_9656_OK
	iny 
	dex 
	bne L_BRS_9653_965A_OK
	tya 
	and #$F0
	sec 
	rts 
//------------------------------
L_BRS_9661_9656_OK:
//------------------------------
	tya 
	and #$F0
	clc 
	adc #$10
	tay 
	cmp #$A0
	bne L_BRS_964F_966A_OK
	clc 
	rts 
//------------------------------
L_JSR_966E_73F9_OK:
L_JSR_966E_73FF_OK:
L_JSR_966E_7405_OK:
L_JSR_966E_740B_OK:
L_JSR_966E_7673_OK:
L_JSR_966E_767B_OK:
L_JSR_966E_7683_OK:
L_JSR_966E_768B_OK:
L_JSR_966E_9598_OK:
L_JSR_966E_95A2_OK:
L_JSR_966E_95AC_OK:
L_JSR_966E_95B6_OK:
L_JSR_966E_9870_OK:
L_JSR_966E_9876_OK:
L_JMP_966E_987C_OK:
//------------------------------
	jsr L_JSR_987F_966E_OK
	jmp L_JMP_967D_9671_OK
//------------------------------
L_JSR_9674_7666_OK:
L_JSR_9674_7698_OK:
L_JSR_9674_957E_OK:
L_JSR_9674_958C_OK:
L_JMP_9674_981E_OK:
//------------------------------
	jsr L_JSR_9892_9674_OK
	lda $1307 
	jsr L_JSR_993C_967A_OK
//------------------------------
L_JMP_967D_9671_OK:
//------------------------------
	lda $1308 
	jsr L_JSR_993C_9680_OK
	lda $1309 
	jmp L_JMP_993C_9686_OK
	lda #$02
	sta $1306 
	lda #$01
	jsr L_JSR_78D2_9690_OK
	cmp #$00
	bne L_BRS_9699_9695_OK
	sec 
	rts 
//------------------------------
L_BRS_9699_9695_OK:
//------------------------------
	clc 
	rts 
//------------------------------
L_JSR_969B_9151_OK:
//------------------------------
	txa 
	pha 
	ldy $50 
	lda $A0EC,Y 
	sta $46 
	lda $A0FC,Y 
	sta $1304 
	tay 
//------------------------------
L_BRS_96AB_96ED_OK:
//------------------------------
	lda $A128,Y 
	sta $42 
	lda $A13E,Y 
	sta $43 
	ldy $4F 
	lda $A10C,Y 
	clc 
	adc $42 
	sta $42 
	bcc L_BRS_96C3_96BF_OK
	inc $43 
//------------------------------
L_BRS_96C3_96BF_OK:
//------------------------------
	ldy #$01
//------------------------------
L_BRS_96C5_96E3_OK:
//------------------------------
	lda ($42),Y 
	and #$0F
	sta ($42),Y 
	lda $131F 
	tax 
	lda $9F17,X 
	clc 
	adc $1303 
	tax 
	lda $9F65,X 
	asl A 
	asl A 
	asl A 
	asl A 
	ora ($42),Y
	sta ($42),Y 
	dey 
	bpl L_BRS_96C5_96E3_OK
	dec $1304 
	ldy $1304 
	dec $46 
	bpl L_BRS_96AB_96ED_OK
	pla 
	tax 
	rts 
//------------------------------
L_JSR_96F2_60CB_OK:
L_JSR_96F2_6246_OK:
//------------------------------
	jsr L_JSR_69AA_96F2_OK
	jsr L_JSR_6A07_96F5_OK
//------------------------------
L_JSR_96F8_6E40_OK:
L_JSR_96F8_6E47_OK:
L_JSR_96F8_70DD_OK:
L_JSR_96F8_7C52_OK:
//------------------------------
	ldx #$22
	lda $51 
	cmp #$40
	beq L_BRS_9743_96FE_OK
	lda #$0A
	sta $3B90 
	sta $3B91 
	sta $3B92 
	sta $3B93 
	lda #$A0
	sta $3CA8 
	sta $3CA9 
	sta $3CAA 
	sta $3CAB 
//------------------------------
L_BRS_971C_9735_OK:
//------------------------------
	ldy #$03
	lda #$AA
//------------------------------
L_BRS_9720_9724_OK:
//------------------------------
	sta $3B98,Y 
	dey 
	bpl L_BRS_9720_9724_OK
	lda $9721 
	clc 
	adc #$08
	sta $9721 
	bcc L_BRS_9734_972F_OK
	inc $9722 
//------------------------------
L_BRS_9734_972F_OK:
//------------------------------
	dex 
	bne L_BRS_971C_9735_OK
	lda #$3B
	sta $9722 
	lda #$98
	sta $9721 
	bne L_BRS_9784_9741_OK
//------------------------------
L_BRS_9743_96FE_OK:
//------------------------------
	lda #$0A
	sta $5B90 
	sta $5B91 
	sta $5B92 
	sta $5B93 
	lda #$A0
	sta $5CA8 
	sta $5CA9 
	sta $5CAA 
	sta $5CAB 
//------------------------------
L_BRS_975F_9778_OK:
//------------------------------
	ldy #$03
	lda #$AA
//------------------------------
L_BRS_9763_9767_OK:
//------------------------------
	sta $5B98,Y 
	dey 
	bpl L_BRS_9763_9767_OK
	lda $9764 
	clc 
	adc #$08
	sta $9764 
	bcc L_BRS_9777_9772_OK
	inc $9765 
//------------------------------
L_BRS_9777_9772_OK:
//------------------------------
	dex 
	bne L_BRS_975F_9778_OK
	lda #$5B
	sta $9765 
	lda #$98
	sta $9764 
//------------------------------
L_BRS_9784_9741_OK:
//------------------------------
	jsr L_JSR_7223_9784_OK
	lda $136A 
	bmi L_BRS_9793_978A_OK
	lda $1306 
	cmp #$05
	bne L_BRS_97BB_9791_OK
//------------------------------
L_BRS_9793_978A_OK:
//------------------------------
	jsr L_JSR_9951_9793_OK
	cpy $D6C5 
	cmp $CC 
	ldy #$A0
	ldy #$A0
	cmp $C7D3 
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$A0
	.byte $00
	lda $1305 
	ldx #$05
	jmp L_JMP_9818_97B8_OK
//------------------------------
L_BRS_97BB_9791_OK:
//------------------------------
	jsr L_JSR_9951_97BB_OK
	.byte $D3,$C3,$CF,$D2
	cmp $A0 
	ldy #$A0
	ldy #$A0
	ldy #$A0
	ldy #$00
//------------------------------
L_JMP_97CC_980A_OK:
//------------------------------
	jsr L_JSR_9951_97CC_OK
	cmp $CEC5 
	ldy #$A0
	ldy #$A0
	cpy $D6C5 
	cmp $CC 
	ldy #$A0
	ldy #$A0
	.byte $00
	lda #$00
	cmp $07AA 
	bne L_BRS_97EA_97E5_OK
	jsr L_JSR_6A17_97E7_OK
//------------------------------
L_BRS_97EA_97E5_OK:
//------------------------------
	jsr L_JSR_980D_97EA_OK
	jsr L_JSR_9821_97ED_OK
	lda #$00
	tay 
	jmp L_JMP_9833_97F3_OK
//------------------------------
L_JSR_97F6_6279_OK:
L_JSR_97F6_82F9_OK:
//------------------------------
	lda $07A9 
	cmp $07AA 
	bne L_BRS_9801_97FC_OK
	jmp L_JMP_980D_97FE_OK
//------------------------------
L_BRS_9801_97FC_OK:
//------------------------------
	sta $6A1A 
	jsr L_JSR_6A22_9804_OK
	jsr L_JSR_721A_9807_OK
	jmp L_JMP_97CC_980A_OK
//------------------------------
L_JSR_980D_8365_OK:
L_JSR_980D_94EA_OK:
L_JSR_980D_97EA_OK:
L_JMP_980D_97FE_OK:
//------------------------------
	ldx $136A 
	bpl L_BRS_9813_9810_OK
	rts 
//------------------------------
L_BRS_9813_9810_OK:
//------------------------------
	lda $1312 
	ldx #$10
//------------------------------
L_JMP_9818_97B8_OK:
L_BRS_9818_9831_OK:
//------------------------------
	stx $4F 
	ldx #$10
	stx $50 
	jmp L_JMP_9674_981E_OK
//------------------------------
L_JSR_9821_94ED_OK:
L_JSR_9821_97ED_OK:
//------------------------------
	lda $135F 
	bpl L_BRS_982C_9824_OK
	lda $135E 
	jmp L_JMP_982F_9829_OK
//------------------------------
L_BRS_982C_9824_OK:
//------------------------------
	lda $1305 
//------------------------------
L_JMP_982F_9829_OK:
//------------------------------
	ldx #$19
	bne L_BRS_9818_9831_OK
//------------------------------
L_JSR_9833_6221_OK:
L_JSR_9833_6257_OK:
L_JSR_9833_629C_OK:
L_JSR_9833_85CE_OK:
L_JSR_9833_87AF_OK:
L_JSR_9833_9106_OK:
L_JSR_9833_94E7_OK:
L_JMP_9833_97F3_OK:
//------------------------------
	ldx $136A 
	bpl L_BRS_9839_9836_OK
	rts 
//------------------------------
L_BRS_9839_9836_OK:
//------------------------------
	clc 
	.byte $F8
	adc $130A 
	sta $130A 
	tya 
	adc $130B 
	sta $130B 
	lda #$00
	adc $130C 
	sta $130C 
	lda #$00
	adc $130D 
	sta $130D 
	cld 
	lda #$05
	sta $4F 
	lda #$10
	sta $50 
	lda $130D 
	jsr L_JSR_987F_9864_OK
	lda $1309 
	jsr L_JSR_993C_986A_OK
	lda $130C 
	jsr L_JSR_966E_9870_OK
	lda $130B 
	jsr L_JSR_966E_9876_OK
	lda $130A 
	jmp L_JMP_966E_987C_OK
//------------------------------
L_JSR_987F_6378_OK:
L_JSR_987F_6387_OK:
L_JSR_987F_639F_OK:
L_JSR_987F_63B7_OK:
L_JSR_987F_6548_OK:
L_JSR_987F_6557_OK:
L_JSR_987F_656F_OK:
L_JSR_987F_6587_OK:
L_JSR_987F_966E_OK:
L_JSR_987F_9864_OK:
//------------------------------
	sta $1308 
	and #$0F
	sta $1309 
	lda $1308 
	lsr 
	lsr 
	lsr 
	lsr 
	sta $1308 
	rts 
//------------------------------
L_JSR_9892_659F_OK:
L_JSR_9892_7150_OK:
L_JSR_9892_795A_OK:
L_JSR_9892_9674_OK:
//------------------------------
	ldx #$00
	stx $1308 
	stx $1307 
//------------------------------
L_BRS_989A_98A3_OK:
//------------------------------
	cmp #$64
	bcc L_BRS_98A5_989C_OK
	inc $1307 
	sbc #$64
	bne L_BRS_989A_98A3_OK
//------------------------------
L_BRS_98A5_989C_OK:
L_BRS_98A5_98AE_OK:
//------------------------------
	cmp #$0A
	bcc L_BRS_98B0_98A7_OK
	inc $1308 
	sbc #$0A
	bne L_BRS_98A5_98AE_OK
//------------------------------
L_BRS_98B0_98A7_OK:
//------------------------------
	sta $1309 
	rts 
//------------------------------
L_JSR_98B4_71E7_OK:
//------------------------------
	lda #$00
	ldx $1307 
	beq L_BRS_98C3_98B9_OK
	clc 
//------------------------------
L_BRS_98BC_98C1_OK:
//------------------------------
	adc #$64
	bcs L_BRS_98D4_98BE_OK
	dex 
	bne L_BRS_98BC_98C1_OK
//------------------------------
L_BRS_98C3_98B9_OK:
//------------------------------
	ldx $1308 
	beq L_BRS_98D0_98C6_OK
	clc 
//------------------------------
L_BRS_98C9_98CE_OK:
//------------------------------
	adc #$0A
	bcs L_BRS_98D4_98CB_OK
	dex 
	bne L_BRS_98C9_98CE_OK
//------------------------------
L_BRS_98D0_98C6_OK:
//------------------------------
	clc 
	adc $1309 
//------------------------------
L_BRS_98D4_98BE_OK:
L_BRS_98D4_98CB_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_98D5_7029_OK:
L_JSR_98D5_76F7_OK:
L_JSR_98D5_9927_OK:
//------------------------------
	cmp #$C1
	bcc L_BRS_98DD_98D7_OK
	cmp #$DB
	bcc L_BRS_9918_98DB_OK
//------------------------------
L_BRS_98DD_98D7_OK:
//------------------------------
	ldx #$7B
	cmp #$A0
	beq L_BRS_9917_98E1_OK
	ldx #$DB
	cmp #$BE
	beq L_BRS_9917_98E7_OK
	inx 
	cmp #$AE
	beq L_BRS_9917_98EC_OK
	inx 
	cmp #$A8
	beq L_BRS_9917_98F1_OK
	inx 
	cmp #$A9
	beq L_BRS_9917_98F6_OK
	inx 
	cmp #$AF
	beq L_BRS_9917_98FB_OK
	inx 
	cmp #$AD
	beq L_BRS_9917_9900_OK
	inx 
	cmp #$BC
	beq L_BRS_9917_9905_OK
	inx 
	cmp #$BA
	beq L_BRS_9917_990A_OK
	cmp #$68
	bcc L_BRS_9914_990E_OK
	cmp #$72
	bcc L_BRS_991B_9912_OK
//------------------------------
L_BRS_9914_990E_OK:
//------------------------------
	lda #$10
	rts 
//------------------------------
L_BRS_9917_98E1_OK:
L_BRS_9917_98E7_OK:
L_BRS_9917_98EC_OK:
L_BRS_9917_98F1_OK:
L_BRS_9917_98F6_OK:
L_BRS_9917_98FB_OK:
L_BRS_9917_9900_OK:
L_BRS_9917_9905_OK:
L_BRS_9917_990A_OK:
//------------------------------
	txa 
//------------------------------
L_BRS_9918_98DB_OK:
//------------------------------
	sec 
	sbc #$7B
//------------------------------
L_BRS_991B_9912_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_991C_73E3_OK:
L_JSR_991C_7600_OK:
L_JMP_991C_76C9_OK:
L_JSR_991C_7755_OK:
//------------------------------
	cmp #$8D
	bne L_BRS_9927_991E_OK
	inc $50 
	lda #$00
	sta $4F 
	rts 
//------------------------------
L_BRS_9927_991E_OK:
//------------------------------
	jsr L_JSR_98D5_9927_OK
	ldx $51 
	cpx #$40
	beq L_BRS_9936_992E_OK
	jsr L_JSR_99F0_9930_OK
	inc $4F 
	rts 
//------------------------------
L_BRS_9936_992E_OK:
//------------------------------
	jsr L_JSR_99F6_9936_OK
	inc $4F 
	rts 
//------------------------------
L_JSR_993C_7160_OK:
L_JSR_993C_71C4_OK:
L_JSR_993C_75F3_OK:
L_JSR_993C_75F8_OK:
L_JSR_993C_7605_OK:
L_JMP_993C_76CC_OK:
L_JSR_993C_967A_OK:
L_JSR_993C_9680_OK:
L_JMP_993C_9686_OK:
L_JSR_993C_986A_OK:
//------------------------------
	clc 
	adc #$3C
//------------------------------
L_JMP_993F_76CF_OK:
L_JSR_993F_7764_OK:
//------------------------------
	ldx $51 
	cpx #$40
	beq L_BRS_994B_9943_OK
	jsr L_JSR_99F0_9945_OK
	inc $4F 
	rts 
//------------------------------
L_BRS_994B_9943_OK:
//------------------------------
	jsr L_JSR_99F6_994B_OK
	inc $4F 
	rts 
//------------------------------
L_JSR_9951_6427_OK:
L_JSR_9951_6467_OK:
L_JSR_9951_65C0_OK:
L_JSR_9951_6A9C_OK:
L_JSR_9951_6AFA_OK:
L_JSR_9951_6B29_OK:
L_JSR_9951_6B42_OK:
L_JSR_9951_6BB3_OK:
L_JSR_9951_6BD9_OK:
L_JSR_9951_6C11_OK:
L_JSR_9951_6C3F_OK:
L_JSR_9951_6C5B_OK:
L_JSR_9951_6C74_OK:
L_JSR_9951_6C89_OK:
L_JSR_9951_6CB0_OK:
L_JSR_9951_6CE2_OK:
L_JSR_9951_6D92_OK:
L_JSR_9951_7007_OK:
L_JSR_9951_707D_OK:
L_JSR_9951_70B0_OK:
L_JSR_9951_7102_OK:
L_JSR_9951_7270_OK:
L_JSR_9951_7323_OK:
L_JSR_9951_758C_OK:
L_JSR_9951_7608_OK:
L_JSR_9951_765C_OK:
L_JSR_9951_7669_OK:
L_JSR_9951_768E_OK:
L_JSR_9951_7982_OK:
L_JSR_9951_91F7_OK:
L_JSR_9951_9277_OK:
L_JSR_9951_92FA_OK:
L_JSR_9951_93F7_OK:
L_JSR_9951_9515_OK:
L_JSR_9951_9793_OK:
L_JSR_9951_97BB_OK:
L_JSR_9951_97CC_OK:
//------------------------------
	pla 
	sta $13 
	pla 
	sta $14 
	bne L_BRS_9962_9957_OK
//------------------------------
L_BRS_9959_9964_OK:
L_BRS_9959_9968_OK:
//------------------------------
	ldy #$00
	lda ($13),Y 
	beq L_BRS_996A_995D_OK
	jsr L_JSR_76B9_995F_OK
//------------------------------
L_BRS_9962_9957_OK:
//------------------------------
	inc $13 
	bne L_BRS_9959_9964_OK
	inc $14 
	bne L_BRS_9959_9968_OK
//------------------------------
L_BRS_996A_995D_OK:
//------------------------------
	lda $14 
	pha 
	lda $13 
	pha 
	rts 
//------------------------------
L_JSR_9971_6B17_OK:
L_JSR_9971_6EB6_OK:
L_JSR_9971_7024_OK:
L_JSR_9971_70CC_OK:
L_JSR_9971_71D9_OK:
L_JSR_9971_777C_OK:
L_JSR_9971_794C_OK:
L_JSR_9971_794F_OK:
L_JSR_9971_8321_OK:
L_JSR_9971_926E_OK:
L_JSR_9971_92E6_OK:
L_JSR_9971_92E9_OK:
L_JSR_9971_936C_OK:
L_JSR_9971_936F_OK:
L_JSR_9971_9453_OK:
L_JSR_9971_9456_OK:
//------------------------------
	jsr L_JSR_66D8_9971_OK
	.byte $03
	bit $00 
	.byte $00,$00
	rts 
//------------------------------
L_JSR_997A_6E5D_OK:
L_JSR_997A_702C_OK:
L_JSR_997A_70D1_OK:
L_JSR_997A_717E_OK:
L_JSR_997A_722E_OK:
L_JSR_997A_76FA_OK:
//------------------------------
	sta $1324 
//------------------------------
L_JMP_997D_99C1_OK:
//------------------------------
	lda #$00
	sta $1322 
	lda #$0A
	sta $1323 
	lda #$00
	ldx $1324 
	bne L_BRS_9990_998C_OK
	lda #$0A
//------------------------------
L_BRS_9990_998C_OK:
//------------------------------
	jsr L_JSR_99F0_9990_OK
//------------------------------
L_BRS_9993_999B_OK:
L_BRS_9993_99A0_OK:
//------------------------------
	jsr L_JSR_99CD_9993_OK
	bcs L_BRS_99C4_9996_OK
	dec $1322 
	bne L_BRS_9993_999B_OK
	dec $1323 
	bne L_BRS_9993_99A0_OK
	lda $1324 
	jsr L_JSR_99F0_99A5_OK
	lda #$00
	sta $1322 
	lda #$0A
	sta $1323 
//------------------------------
L_BRS_99B2_99BA_OK:
L_BRS_99B2_99BF_OK:
//------------------------------
	jsr L_JSR_99CD_99B2_OK
	bcs L_BRS_99C4_99B5_OK
	dec $1322 
	bne L_BRS_99B2_99BA_OK
	dec $1323 
	bne L_BRS_99B2_99BF_OK
	jmp L_JMP_997D_99C1_OK
//------------------------------
L_BRS_99C4_9996_OK:
L_BRS_99C4_99B5_OK:
//------------------------------
	pha 
	lda $1324 
	jsr L_JSR_99F0_99C8_OK
	pla 
	rts 
//------------------------------
L_JSR_99CD_6117_OK:
L_JSR_99CD_6BD1_OK:
L_JSR_99CD_9252_OK:
L_JSR_99CD_9993_OK:
L_JSR_99CD_99B2_OK:
//------------------------------
	lda #$00
	sta $1370 
	lda $1328 
	bne L_BRS_99EE_99D5_OK
	lda $DC00 
	and #$0F
	eor #$0F
	bne L_BRS_99EB_99DE_OK
	lda $DC00 
	and #$10
	eor #$10
	bne L_BRS_99EB_99E7_OK
	clc 
	rts 
//------------------------------
L_BRS_99EB_99DE_OK:
L_BRS_99EB_99E7_OK:
//------------------------------
	dec $1370 
//------------------------------
L_BRS_99EE_99D5_OK:
//------------------------------
	sec 
	rts 
//------------------------------
L_JSR_99F0_6E81_OK:
L_JSR_99F0_802E_OK:
L_JSR_99F0_8041_OK:
L_JSR_99F0_80EF_OK:
L_JSR_99F0_8102_OK:
L_JSR_99F0_8635_OK:
L_JSR_99F0_8641_OK:
L_JSR_99F0_907B_OK:
L_JSR_99F0_9116_OK:
L_JSR_99F0_918C_OK:
L_JSR_99F0_9199_OK:
L_JSR_99F0_919E_OK:
L_JSR_99F0_9930_OK:
L_JSR_99F0_9945_OK:
L_JSR_99F0_9990_OK:
L_JSR_99F0_99A5_OK:
L_JSR_99F0_99C8_OK:
//------------------------------
	sta $23 
	lda #$20
	bne L_BRS_99FA_99F4_OK
//------------------------------
L_JSR_99F6_7BC3_OK:
L_JSR_99F6_7BEA_OK:
L_JSR_99F6_7BF7_OK:
L_JSR_99F6_7C7A_OK:
L_JSR_99F6_85BB_OK:
L_JSR_99F6_863A_OK:
L_JSR_99F6_8834_OK:
L_JSR_99F6_8F30_OK:
L_JSR_99F6_8F64_OK:
L_JSR_99F6_902E_OK:
L_JSR_99F6_9080_OK:
L_JSR_99F6_911B_OK:
L_JSR_99F6_9161_OK:
L_JSR_99F6_9187_OK:
L_JSR_99F6_9194_OK:
L_JSR_99F6_9936_OK:
L_JSR_99F6_994B_OK:
L_JSR_99F6_9C79_OK:
//------------------------------
	sta $23 
	lda #$40
//------------------------------
L_BRS_99FA_99F4_OK:
//------------------------------
	sta $24 
	ldy $50 
	ldx $4F 
	jsr L_JSR_9B8B_9A00_OK
	sty $20 
	jsr L_JSR_9B0E_9A05_OK
	jsr L_JSR_9BB2_9A08_OK
	stx $41 
	lda $A154,X 
	sta $25 
	lda $A158,X 
	sta $26 
	jsr L_JSR_9AB6_9A17_OK
	lda #$0B
	sta $22 
	ldx #$00
//------------------------------
L_BRS_9A20_9A40_OK:
//------------------------------
	ldy $20 
	jsr L_JSR_9BE1_9A22_OK
	ldy #$00
	lda ($0F),Y 
	and $25
	ora $5B,X
	sta ($0F),Y 
	inx 
	ldy #$08
	lda ($0F),Y 
	and $26
	ora $5B,X
	sta ($0F),Y 
	inx 
	inx 
	inc $20 
	dec $22 
	bne L_BRS_9A20_9A40_OK
	rts 
//------------------------------
L_JSR_9A43_7D00_OK:
L_JSR_9A43_7DD2_OK:
L_JSR_9A43_7E46_OK:
L_JSR_9A43_7EE3_OK:
L_JSR_9A43_7F5C_OK:
L_JSR_9A43_7FDF_OK:
L_JSR_9A43_800E_OK:
L_JSR_9A43_8056_OK:
L_JSR_9A43_80A0_OK:
L_JSR_9A43_80CF_OK:
L_JSR_9A43_8119_OK:
L_JSR_9A43_85C7_OK:
L_JSR_9A43_876A_OK:
L_JSR_9A43_8869_OK:
L_JSR_9A43_88D5_OK:
L_JSR_9A43_8964_OK:
L_JSR_9A43_89F3_OK:
L_JSR_9A43_8A81_OK:
L_JMP_9A43_8F3C_OK:
L_JSR_9A43_903A_OK:
L_JSR_9A43_90B6_OK:
//------------------------------
	sty $20 
	sta $23 
	jsr L_JSR_9BB2_9A47_OK
	sta $21 
	stx $41 
	jsr L_JSR_9AB6_9A4E_OK
	ldx #$0B
	stx $22 
	ldx #$00
//------------------------------
L_BRS_9A57_9A7B_OK:
//------------------------------
	ldy $20 
	jsr L_JSR_9BF5_9A59_OK
	ldy #$00
	lda $5B,X 
	eor #$FF
	and ($0F),Y 
	ora ($11),Y
	sta ($0F),Y 
	inx 
	ldy #$08
	lda $5B,X 
	eor #$FF
	and ($0F),Y 
	ora ($11),Y
	sta ($0F),Y 
	inx 
	inx 
	inc $20 
	dec $22 
	bne L_BRS_9A57_9A7B_OK
	rts 
//------------------------------
L_JSR_9A7E_8024_OK:
L_JSR_9A7E_80E5_OK:
L_JSR_9A7E_85E3_OK:
L_JSR_9A7E_87B5_OK:
L_JSR_9A7E_8840_OK:
L_JSR_9A7E_885C_OK:
L_JSR_9A7E_8876_OK:
L_JSR_9A7E_8931_OK:
L_JSR_9A7E_8A41_OK:
L_JSR_9A7E_8AD3_OK:
L_JMP_9A7E_8F70_OK:
L_JSR_9A7E_9168_OK:
L_JSR_9A7E_9C85_OK:
//------------------------------
	sty $20 
	sta $23 
	jsr L_JSR_9B0E_9A82_OK
	jsr L_JSR_9BB2_9A85_OK
	sta $21 
	stx $41 
	jsr L_JSR_9AB6_9A8C_OK
	lda #$0B
	sta $22 
	ldx #$00
	stx $27 
//------------------------------
L_BRS_9A97_9AB3_OK:
//------------------------------
	ldy $20 
	jsr L_JSR_9BF5_9A99_OK
	ldy #$00
	lda $5B,X 
	ora ($0F),Y
	sta ($0F),Y 
	inx 
	ldy #$08
	lda $5B,X 
	ora ($0F),Y
	sta ($0F),Y 
	inx 
	inx 
	inc $20 
	dec $22 
	bne L_BRS_9A97_9AB3_OK
	rts 
//------------------------------
L_JSR_9AB6_9A17_OK:
L_JSR_9AB6_9A4E_OK:
L_JSR_9AB6_9A8C_OK:
L_JSR_9AB6_9B62_OK:
//------------------------------
	stx $1371 
	ldx $23 
	lda $C900,X 
	sta $0D 
	lda $CA00,X 
	sta $0E 
	ldy #$20
//------------------------------
L_BRS_9AC7_9B0B_OK:
//------------------------------
	lda ($0D),Y 
	sta $005B,Y 
	dey 
	lda ($0D),Y 
	sta $005B,Y 
	dey 
	lda ($0D),Y 
	sta $005B,Y 
	tya 
	tax 
	lda $1371 
	beq L_BRS_9B0A_9ADD_OK
	cmp #$01
	beq L_BRS_9AFF_9AE1_OK
	cmp #$02
	beq L_BRS_9AF3_9AE5_OK
	lsr $5B,X 
	inx 
	ror $5B,X 
	dex 
	lsr $5B,X 
	inx 
	ror $5B,X 
	dex 
//------------------------------
L_BRS_9AF3_9AE5_OK:
//------------------------------
	lsr $5B,X 
	inx 
	ror $5B,X 
	dex 
	lsr $5B,X 
	inx 
	ror $5B,X 
	dex 
//------------------------------
L_BRS_9AFF_9AE1_OK:
//------------------------------
	lsr $5B,X 
	inx 
	ror $5B,X 
	dex 
	lsr $5B,X 
	inx 
	ror $5B,X 
//------------------------------
L_BRS_9B0A_9ADD_OK:
//------------------------------
	dey 
	bpl L_BRS_9AC7_9B0B_OK
	rts 
//------------------------------
L_JSR_9B0E_9A05_OK:
L_JSR_9B0E_9A82_OK:
//------------------------------
	lda $132C 
	bne L_BRS_9B5B_9B11_OK
	lda $23 
	cmp #$3A
	bcs L_BRS_9B5B_9B17_OK
	tay 
	lda $9EC1,Y 
	bmi L_BRS_9B5B_9B1D_OK
	beq L_BRS_9B23_9B1F_OK
	sta $23 
//------------------------------
L_BRS_9B23_9B1F_OK:
//------------------------------
	stx $21 
	jsr L_JSR_9B5C_9B25_OK
	lda $21 
	clc 
	adc #$0C
	asl A 
	and #$F8
	sta $D000,X 
	bcc L_BRS_9B41_9B33_OK
	lda $9EFB,X 
	ora $D010
	sta $D010 
	jmp L_JMP_9B4A_9B3E_OK
//------------------------------
L_BRS_9B41_9B33_OK:
//------------------------------
	lda $9EFC,X 
	and $D010 
	sta $D010 
//------------------------------
L_JMP_9B4A_9B3E_OK:
//------------------------------
	lda $20 
	clc 
	adc #$32
	sta $D001,X 
	lda $D01E 
	and #$01
	sta $27 
	pla 
	pla 
//------------------------------
L_BRS_9B5B_9B11_OK:
L_BRS_9B5B_9B17_OK:
L_BRS_9B5B_9B1D_OK:
//------------------------------
	rts 
//------------------------------
L_JSR_9B5C_9B25_OK:
//------------------------------
	pha 
	lda $21 
	and #$03
	tax 
	jsr L_JSR_9AB6_9B62_OK
	pla 
	beq L_BRS_9B6B_9B66_OK
	lda $131F 
//------------------------------
L_BRS_9B6B_9B66_OK:
//------------------------------
	tax 
	lda $9F0B,X 
	sta $9B82 
	lda $9F11,X 
	sta $9B83 
	lda $9F17,X 
	tax 
	ldy #$20
//------------------------------
L_BRS_9B7E_9B85_OK:
//------------------------------
	lda $005B,Y 
	sta $9B81,Y 
	dey 
	bpl L_BRS_9B7E_9B85_OK
	txa 
	asl A 
	tax 
	rts 
//------------------------------
L_JSR_9B8B_800A_OK:
L_JSR_9B8B_8020_OK:
L_JSR_9B8B_8052_OK:
L_JSR_9B8B_80CB_OK:
L_JSR_9B8B_80E1_OK:
L_JSR_9B8B_8115_OK:
L_JSR_9B8B_85C2_OK:
L_JSR_9B8B_883B_OK:
L_JSR_9B8B_8F37_OK:
L_JSR_9B8B_8F6B_OK:
L_JSR_9B8B_9035_OK:
L_JSR_9B8B_9A00_OK:
L_JSR_9B8B_9B98_OK:
L_JSR_9B8B_9BA6_OK:
L_JSR_9B8B_9C80_OK:
//------------------------------
	lda $9F2E,Y 
	pha 
	lda $9F3F,X 
	tax 
	pla 
	tay 
	rts 
//------------------------------
L_JSR_9B96_853D_OK:
L_JSR_9B96_8EE4_OK:
//------------------------------
	tya 
	pha 
	jsr L_JSR_9B8B_9B98_OK
	pla 
	tay 
	txa 
	clc 
	adc $9F5B,Y 
	tax 
	rts 
//------------------------------
L_JSR_9BA4_8546_OK:
L_JSR_9BA4_8EED_OK:
//------------------------------
	txa 
	pha 
	jsr L_JSR_9B8B_9BA6_OK
	pla 
	tax 
	tya 
	clc 
	adc $9F60,X 
	tay 
	rts 
//------------------------------
L_JSR_9BB2_9A08_OK:
L_JSR_9BB2_9A47_OK:
L_JSR_9BB2_9A85_OK:
//------------------------------
	lda #$00
	sta $1326 
	txa 
	pha 
	and #$03
	tax 
	pla 
	asl A 
	rol $1326 
	and #$F8
	sta $1325 
	rts 
//------------------------------
L_JSR_9BC7_7FC0_OK:
L_JSR_9BC7_7FD0_OK:
L_JSR_9BC7_807F_OK:
L_JSR_9BC7_8091_OK:
L_JSR_9BC7_904F_OK:
L_JSR_9BC7_90C2_OK:
L_JSR_9BC7_9178_OK:
L_JSR_9BC7_9C6A_OK:
//------------------------------
	lda $A1B0,Y 
	sta $09 
	sta $0B 
	lda $A1C0,Y 
	sta $0A 
	lda $A1D0,Y 
	sta $0C 
	rts 
//------------------------------
L_JSR_9BD9_9DC3_OK:
//------------------------------
	lda #$00
	sta $1325 
	sta $1326 
//------------------------------
L_JSR_9BE1_9A22_OK:
//------------------------------
	lda $0E00,Y 
	clc 
	adc $1325 
	sta $0F 
	lda $0F00,Y 
	adc $1326 
	ora $24
	sta $10 
	rts 
//------------------------------
L_JSR_9BF5_9A59_OK:
L_JSR_9BF5_9A99_OK:
//------------------------------
	lda $0E00,Y 
	clc 
	adc $1325 
	sta $0F 
	sta $11 
	lda $0F00,Y 
	adc $1326 
	ora #$20
	sta $10 
	eor #$60
	sta $12 
	rts 
//------------------------------
L_JSR_9C0F_60C5_OK:
L_JSR_9C0F_6243_OK:
L_JSR_9C0F_6350_OK:
L_JSR_9C0F_647D_OK:
L_JSR_9C0F_6946_OK:
L_JSR_9C0F_6A7C_OK:
L_JSR_9C0F_6A85_OK:
L_JSR_9C0F_6E2A_OK:
L_JSR_9C0F_7067_OK:
L_JSR_9C0F_70EC_OK:
L_JSR_9C0F_725E_OK:
L_JSR_9C0F_7579_OK:
//------------------------------
	lda #$20
	ldx #$00
	stx $D015 
	ldx #$40
	bne L_BRS_9C1E_9C18_OK
//------------------------------
L_JSR_9C1A_60C8_OK:
L_JSR_9C1A_6A7F_OK:
L_JSR_9C1A_94C7_OK:
//------------------------------
	lda #$40
	ldx #$60
//------------------------------
L_BRS_9C1E_9C18_OK:
//------------------------------
	sta $10 
	ldy #$00
	sty $0F 
	tya 
//------------------------------
L_BRS_9C25_9C28_OK:
L_BRS_9C25_9C2E_OK:
//------------------------------
	sta ($0F),Y 
	iny 
	bne L_BRS_9C25_9C28_OK
	inc $10 
	cpx $10 
	bne L_BRS_9C25_9C2E_OK
	rts 
//------------------------------
L_JSR_9C31_91E8_OK:
L_JSR_9C31_94C4_OK:
L_JSR_9C31_9502_OK:
//------------------------------
	lda #$20
	ldx #$00
	stx $D015 
	ldx #$3B
	bne L_BRS_9C40_9C3A_OK
	lda #$40
	ldx #$5B
//------------------------------
L_BRS_9C40_9C3A_OK:
//------------------------------
	sta $10 
	ldy #$00
	sty $0F 
	tya 
//------------------------------
L_BRS_9C47_9C4A_OK:
L_BRS_9C47_9C50_OK:
//------------------------------
	sta ($0F),Y 
	iny 
	bne L_BRS_9C47_9C4A_OK
	inc $10 
	cpx $10 
	bne L_BRS_9C47_9C50_OK
	ldy #$80
//------------------------------
L_BRS_9C54_9C57_OK:
//------------------------------
	sta ($0F),Y 
	dey 
	bpl L_BRS_9C54_9C57_OK
	rts 
//------------------------------
L_JSR_9C5A_617A_OK:
//------------------------------
	ldx $1301 
	bne L_BRS_9C64_9C5D_OK
	beq L_BRS_9C8D_9C5F_OK
//------------------------------
L_BRS_9C61_9C8B_OK:
//------------------------------
	ldx $1301 
//------------------------------
L_BRS_9C64_9C5D_OK:
//------------------------------
	lda $C67F,X 
	sta $50 
	tay 
	jsr L_JSR_9BC7_9C6A_OK
	lda $C600,X 
	sta $4F 
	tay 
	lda #$03
	sta ($0B),Y 
	sta ($09),Y 
	jsr L_JSR_99F6_9C79_OK
	ldx $4F 
	ldy $50 
	jsr L_JSR_9B8B_9C80_OK
	lda #$03
	jsr L_JSR_9A7E_9C85_OK
	dec $1301 
	bne L_BRS_9C61_9C8B_OK
//------------------------------
L_BRS_9C8D_9C5F_OK:
//------------------------------
	dec $130E 
	rts 
//------------------------------
L_JSR_9C91_8307_OK:
L_BRS_9C91_9C94_OK:
//------------------------------
	lda $1328 
	beq L_BRS_9C91_9C94_OK
	ldx #$00
	stx $1328 
	rts 
//------------------------------
L_JSR_9C9C_62B5_OK:
//------------------------------
	lda #$01
	sta $132B 
	lda #$20
	sta $24 
//------------------------------
L_BRS_9CA5_9CE6_OK:
//------------------------------
	jsr L_JSR_9D51_9CA5_OK
	jsr L_JSR_9D40_9CA8_OK
	jsr L_JSR_9D2F_9CAB_OK
	jsr L_JSR_9D1E_9CAE_OK
	jsr L_JSR_9D0D_9CB1_OK
	jsr L_JSR_9CFC_9CB4_OK
	jsr L_JSR_9D0D_9CB7_OK
	jsr L_JSR_9D1E_9CBA_OK
	jsr L_JSR_9D2F_9CBD_OK
	jsr L_JSR_9D40_9CC0_OK
	jsr L_JSR_9D51_9CC3_OK
	jsr L_JSR_9DA6_9CC6_OK
	jsr L_JSR_9D95_9CC9_OK
	jsr L_JSR_9D84_9CCC_OK
	jsr L_JSR_9D73_9CCF_OK
	jsr L_JSR_9D62_9CD2_OK
	jsr L_JSR_9D73_9CD5_OK
	jsr L_JSR_9D84_9CD8_OK
	jsr L_JSR_9D95_9CDB_OK
	jsr L_JSR_9DA6_9CDE_OK
	lda $132B 
	cmp #$32
	bcc L_BRS_9CA5_9CE6_OK
	jsr L_JSR_9D51_9CE8_OK
	jsr L_JSR_9D40_9CEB_OK
	jsr L_JSR_9D2F_9CEE_OK
	jsr L_JSR_9D1E_9CF1_OK
	jsr L_JSR_9D0D_9CF4_OK
	jsr L_JSR_9CFC_9CF7_OK
	clc 
	rts 
//------------------------------
L_JSR_9CFC_9CB4_OK:
L_JSR_9CFC_9CF7_OK:
//------------------------------
	jsr L_JSR_9DB7_9CFC_OK
	.byte $00
	ora ($02,X)
	.byte $03,$04
	ora $06
	.byte $07
	php 
	ora #$0A
	.byte $02
	ora ($00,X)
//------------------------------
L_JSR_9D0D_9CB1_OK:
L_JSR_9D0D_9CB7_OK:
L_JSR_9D0D_9CF4_OK:
//------------------------------
	jsr L_JSR_9DB7_9D0D_OK
	.byte $00,$00
	ora ($02,X)
	.byte $03,$04
	ora $07
	ora #$0A
	.byte $02
	ora ($00,X)
	.byte $00
//------------------------------
L_JSR_9D1E_9CAE_OK:
L_JSR_9D1E_9CBA_OK:
L_JSR_9D1E_9CF1_OK:
//------------------------------
	jsr L_JSR_9DB7_9D1E_OK
	.byte $00,$00,$00
	ora ($02,X)
	.byte $03,$04
	ora #$0A
	.byte $02
	ora ($00,X)
	.byte $00,$00
//------------------------------
L_JSR_9D2F_9CAB_OK:
L_JSR_9D2F_9CBD_OK:
L_JSR_9D2F_9CEE_OK:
//------------------------------
	jsr L_JSR_9DB7_9D2F_OK
	.byte $00,$00,$00,$00
	ora ($02,X)
	.byte $03
	asl A 
	.byte $02
	ora ($00,X)
	.byte $00,$00,$00
//------------------------------
L_JSR_9D40_9CA8_OK:
L_JSR_9D40_9CC0_OK:
L_JSR_9D40_9CEB_OK:
//------------------------------
	jsr L_JSR_9DB7_9D40_OK
	.byte $00,$00,$00,$00,$00
	ora ($03,X)
	asl A 
	ora ($00,X)
	.byte $00,$00,$00,$00
//------------------------------
L_JSR_9D51_9CA5_OK:
L_JSR_9D51_9CC3_OK:
L_JSR_9D51_9CE8_OK:
//------------------------------
	jsr L_JSR_9DB7_9D51_OK
	.byte $00,$00,$00,$00,$00,$00
	ora ($01,X)
	.byte $00,$00,$00,$00,$00,$00
//------------------------------
L_JSR_9D62_9CD2_OK:
//------------------------------
	jsr L_JSR_9DB7_9D62_OK
	.byte $00
	ora ($02,X)
	asl A 
	ora #$08
	.byte $07
	asl $05 
	.byte $04,$03,$02
	ora ($00,X)
//------------------------------
L_JSR_9D73_9CCF_OK:
L_JSR_9D73_9CD5_OK:
//------------------------------
	jsr L_JSR_9DB7_9D73_OK
	.byte $00,$00
	ora ($02,X)
	asl A 
	ora #$07
	ora $04
	.byte $03,$02
	ora ($00,X)
	.byte $00
//------------------------------
L_JSR_9D84_9CCC_OK:
L_JSR_9D84_9CD8_OK:
//------------------------------
	jsr L_JSR_9DB7_9D84_OK
	.byte $00,$00,$00
	ora ($02,X)
	asl A 
	ora #$04
	.byte $03,$02
	ora ($00,X)
	.byte $00,$00
//------------------------------
L_JSR_9D95_9CC9_OK:
L_JSR_9D95_9CDB_OK:
//------------------------------
	jsr L_JSR_9DB7_9D95_OK
	.byte $00,$00,$00,$00
	ora ($02,X)
	asl A 
	.byte $03,$02
	ora ($00,X)
	.byte $00,$00,$00
//------------------------------
L_JSR_9DA6_9CC6_OK:
L_JSR_9DA6_9CDE_OK:
//------------------------------
	jsr L_JSR_9DB7_9DA6_OK
	.byte $00,$00,$00,$00,$00
	ora ($0A,X)
	.byte $03
	ora ($00,X)
	.byte $00,$00,$00,$00
//------------------------------
L_JSR_9DB7_9CFC_OK:
L_JSR_9DB7_9D0D_OK:
L_JSR_9DB7_9D1E_OK:
L_JSR_9DB7_9D2F_OK:
L_JSR_9DB7_9D40_OK:
L_JSR_9DB7_9D51_OK:
L_JSR_9DB7_9D62_OK:
L_JSR_9DB7_9D73_OK:
L_JSR_9DB7_9D84_OK:
L_JSR_9DB7_9D95_OK:
L_JSR_9DB7_9DA6_OK:
//------------------------------
	pla 
	sta $0D 
	pla 
	sta $0E 
	ldy #$50
	sty $50 
	bne L_BRS_9DF8_9DC1_OK
//------------------------------
L_BRS_9DC3_9E01_OK:
//------------------------------
	jsr L_JSR_9BD9_9DC3_OK
	ldy #$00
	lda ($0D),Y 
	asl
	tax 
	lda $A264,X 
	sta $9DE5 
	lda $A265,X 
	sta $9DE6 
	ldy #$70
//------------------------------
L_BRS_9DDB_9E58_BAD:
//------------------------------
	sty $20 
	ldy #$0E
	sty $1E 
//------------------------------
L_BRS_9DE0_9DF6_OK:
//------------------------------
	ldy $1E 
	inc $1E 
	lda $9DE4,Y 
	lsr 
	ldy $20 
	sta ($0F),Y 
	tya 
	clc 
	adc #$08
	sta $20 
	ldy $1E 
	cpy #$1A
	bcc L_BRS_9DE0_9DF6_OK
//------------------------------
L_BRS_9DF8_9DC1_OK:
//------------------------------
	jsr L_JSR_9E22_9DF8_OK
	inc $50 
	ldy $50 
	cpy #$5F
	bcc L_BRS_9DC3_9E01_OK
	ldx $132B 
	ldy #$FF
//------------------------------
L_BRS_9E08_9E09_OK:
L_BRS_9E08_9E0C_OK:
//------------------------------
	dey 
	bne L_BRS_9E08_9E09_OK
	dex 
	bne L_BRS_9E08_9E0C_OK
	inc $132B 
	lda $DC00 
	and #$10
	beq L_BRS_9E1E_9E16_OK
	lda $1328 
	bne L_BRS_9E1E_9E1B_OK
	rts 
//------------------------------
L_BRS_9E1E_9E16_OK:
L_BRS_9E1E_9E1B_OK:
//------------------------------
	pla 
	pla 
	sec 
	rts 
//------------------------------
L_JSR_9E22_9DF8_OK:
//------------------------------
	inc $0D 
	bne L_BRS_9E28_9E24_OK
	inc $0E 
//------------------------------
L_BRS_9E28_9E24_OK:
//------------------------------
	rts 
//------------------------------
TabInGameCmdChr:
.byte $9e // U                  - Try Next Level
.byte $a9 // P                  - Try Previous Level
.byte $be // Q - Quit               - Quit level test and retu
.byte $95 // F                  - Inc Number of Lives
.byte $3f // <run/stop>             - Pause game
.byte $91 // R                  - Resign
.byte $8a // A                  - Restart Level
.byte $a2 // J                  - Set Joystick Control
.byte $a5 // K                  - Set Keyboard Control
.byte $a4 // M                  - Load Level Mirrored
.byte $aa // L                  - Load Game
.byte $8d // S                  - Save Game
.byte $97 // X                  - Transmit level to a slot of 
.byte $9a // G                  - Set all Gold collected in ex
.byte $8c // Z                  - Random (Zufall) level mode
.byte $92 // D                  - Toggle Shoot Mode
.byte $28 // +                  - Inc Game Speed
.byte $a8 // + plus <commodore>         - Inc Game Speed + <co
.byte $2b // -                  - Dec Game Speed
.byte $ab // - plus <commodore>         - Dec Game Speed + <co
.byte $00 // <end_of_tab>

TabLevelEdCmdChr:

.byte $58, $82, $86, $82,$82, $B4, $82, $82, 
.byte $DB, $82, $06, $83,$83, $2A, $83, $35
.byte $83, $83, $39, $83, $75, 
	cli 
	.byte $82
	stx $82 
	ldy $82,X 
	.byte $DB,$82
	asl $83 
	rol A 
	.byte $83
	and $83,X 
	and
     $7583,Y 
	.byte $83,$6F,$83
	eor ($83,X) 
	eor ($83),Y 
	asl $82 
	beq L_BRS_9DDB_9E58_BAD
	.byte $22,$82
	lda $9583 
	.byte $83
	sta $83,X 
	adc $7D83,X 
	.byte $83
	and #$14
	asl $1724 
	and ($0D,X) 
	sta $D800 
	.byte $6B
	bpl L_BRS_9EDF_9E71_JAM
	rol $5A6C,X 
	jmp 6B28_
	sbc ($6C,X) 
	.byte $AF,$6B
	sta ($6D),Y 
	and ($24,X) 
	.byte $22
	and $87
	.byte $07,$82,$02
	sta $8A96 
	sta $9E,X 
	.byte $9C
	lda #$97
	ldy $16 
	ldx $0600,Y 
	.byte $6F,$3C,$6F
	clc 
	.byte $6F
	rol A 
	.byte $6F
	asl $6F 
	.byte $3C,$6F
	clc 
	.byte $6F
	rol A 
	.byte $6F
	adc $C76F,X 
	ror $6F86 
	.byte $8F,$6F,$8F,$6F
	tya 
	.byte $6F
	tya 
	.byte $6F
	lda ($6F,X) 
	.byte $00,$6F
	cpy #$6F
	.byte $B2,$6F
	ora ($0F,X)
	.byte $0C,$0B,$00,$0B,$0C,$0F,$FF,$FF
	.byte $FF,$FF,$FF,$FF,$FF,$FF,$0B,$00
	.byte $FF,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
//------------------------------
L_BRS_9EDF_9E71_JAM:
//------------------------------
	.byte $00,$00,$FF,$FF,$FF,$FF,$FF,$FF
	.byte $FF,$FF,$FF,$FF,$00,$FF,$FF
	bpl L_BRS_9EFD_9EEA_JAM
	.byte $12,$0C
	ora $1716
	clc 
//------------------------------
L_BRS_9EF4_9F03_BAD:
//------------------------------
	ora $1B1A,Y
	asl $1513 
	.byte $14,$FF,$FF
	ora ($FE,X)
//------------------------------
L_BRS_9EFD_9EEA_JAM:
//------------------------------
	.byte $02
	sbc $FB04,X 
	php 
	.byte $F7
	bpl L_BRS_9EF4_9F03_BAD
	jsr 40DF
	.byte $BF,$80,$7F,$00
	rti 
//------------------------------
	.byte $80
	cpy #$00
	rti 
//------------------------------
	.byte $0C,$0C,$0C,$0C
	ora $000D
	.byte $02,$03,$04
	asl $07 
	.byte $00
	asl A 
	ora $20,X
	.byte $2B
	and $41,X 
	eor $675C 
	.byte $72
	sta ($8C,X) 
	.byte $97
	ldx $B1 
	ldy $0B00,X 
	asl $21,X 
	bit $4237 
	eor $6358 
	ror $8479 
	.byte $8F
	txs 
	lda $B5 
	asl A 
	.byte $0F,$14
	ora $231E,Y
	plp 
	and $3732 
	.byte $3C
	eor ($46,X) 
	.byte $4B
	bvc L_BRS_9FA4_9F4D_JAM
	.byte $5A,$5F,$64
	adc #$6E
	.byte $73
	sei 
	adc $8782,X 
	sty $FE91 
	.byte $FF,$00
	ora ($02,X)
	.byte $FB
	sbc $0200,X 
	.byte $04
	ora ($00,X)
	.byte $03,$03,$03,$00,$03,$03
	ora ($00,X)
	.byte $07
	ora $000A
	.byte $0F,$03
	ora ($00,X)
	asl A 
	asl $0004 
	.byte $07,$0F
	ora ($00,X)
	ora $070A
	.byte $00,$03,$0F
	ora ($00,X)
	.byte $07,$04
	asl $0D00 
	.byte $0F
	ora ($00,X)
	asl A 
	asl $0004 
	.byte $0F,$03
	ora ($00,X)
	asl $0D07 
	.byte $00,$03,$0F
	ora ($00,X)
	.byte $07
	asl A 
	asl $0400 
//------------------------------
L_BRS_9FA4_9F4D_JAM:
//------------------------------
	.byte $0F
	ora ($00,X)
	.byte $03,$07
	ora $0A00
	asl $0001 
	asl $0704 
	.byte $00,$03
	asl A 
	ora ($00,X)
	.byte $07
	ora $000A
	.byte $0F,$03
	ora ($00,X)
	ora $0E03
	.byte $00,$04,$07
	ora ($00,X)
	.byte $07,$04
	asl A 
	.byte $00,$0F,$03
	ora ($00,X)
	.byte $0F
	asl $0003 
	.byte $07
	ora $0001
	.byte $04
	asl A 
	asl $0300 
	.byte $0F
	ora ($00,X)
	ora $030A
	.byte $00,$07,$0F
	ora ($00,X)
	.byte $07
	ora $000A
	asl $3204 
	.byte $34
	and $3836,X 
	.byte $37,$3A
	and $34,X 
	and $3836,X 
	rol $353A,X 
	.byte $34,$1F,$32
	rol $343A,X 
	.byte $3A,$3D,$34,$38,$3E,$3A,$34,$3A
	.byte $3D,$34,$37,$3E,$CB,$77,$AA,$EE
	.byte $DD,$77,$AA,$DD,$AA,$77,$EE,$DD
	.byte $EE,$AA,$77,$EE,$DD,$11,$33,$33
	.byte $33,$33,$11,$11,$11,$77,$DD,$DD
	.byte $AA,$4E,$4E,$4E,$4E,$4E,$CF,$CF
	.byte $CF,$CF,$CF,$BB,$BB,$33,$00,$00
	.byte $08,$10,$18,$20,$28,$30,$38,$40
	.byte $48,$23,$38,$3B,$08,$0B,$10,$13
	.byte $18,$1B,$20,$00,$0D,$15,$FF,$FF
	.byte $FF,$FF,$08,$33,$57,$41,$34,$5A
	.byte $53,$45,$FF,$35,$52,$44,$36,$43
	.byte $46,$54,$58,$37,$59,$47,$38,$42
	.byte $48,$55,$56,$39,$49,$4A,$30,$4D
	.byte $4B,$4F,$4E,$2B,$50,$4C,$2D,$2E
	.byte $3A,$FF,$2C,$5C,$2A,$3B,$FF,$FF
	.byte $3D,$FF,$2F,$31,$FF,$FF,$32,$20
	.byte $FF,$51,$FF,$C4,$C1,$CE,$C5,$A0
	.byte $C2,$C9,$C7,$C8,$C1,$CD,$00,$00
	.byte $00,$CC,$CF,$C4,$C5,$A0,$D2,$D5
	.byte $CE,$CE,$C5,$52,$00,$84,$83,$82
	.byte $81,$80,$7F,$7E,$7D,$7C,$7B,$7A
	.byte $79,$78,$77,$76,$75,$74,$73,$72
	.byte $01,$05,$0D,$1D,$5D,$DD,$00,$04
	.byte $08,$10,$40,$80,$00,$FB,$F7,$EF
	.byte $BF,$7F,$00,$03,$06,$09,$0C,$0F
	.byte $12,$15,$18,$1B,$1E,$26,$26,$2E
	.byte $44,$47,$49,$4A,$4B,$4C,$4D,$4E
	.byte $4F,$50,$51,$52,$53,$54,$55,$56
	.byte $57,$58,$02,$02,$03,$02,$02,$03
	.byte $02,$02,$03,$02,$03,$02,$02,$03
	.byte $02,$02,$01,$02,$04,$05,$06,$08
	.byte $09,$0A,$0C,$0D,$0F,$10,$11,$13
	.byte $14,$15,$02,$03,$05,$06,$07,$08
	.byte $0A,$0B,$0C,$0D,$0F,$10,$11,$12
	.byte $14,$15,$16,$17,$19,$1A,$1B,$1C
	.byte $1E,$1F,$20,$21,$23,$24,$00,$28
	.byte $50,$78,$A0,$C8,$F0,$18,$40,$68
	.byte $90,$B8,$E0,$08,$30,$58,$80,$A8
	.byte $D0,$F8,$20,$48,$04,$04,$04,$04
	.byte $04,$04,$04,$05,$05,$05,$05,$05
	.byte $05,$06,$06,$06,$06,$06,$06,$06
	.byte $07,$07,$00,$C0,$F0,$FC,$3F,$0F
	.byte $03,$00,$23,$55,$2B,$0D,$00,$55
	.byte $31,$3A,$30,$32,$20,$30,$20,$30
	.byte $33,$20,$30,$30,$0D,$00,$30,$30
	.byte $30,$30,$30,$30,$30,$31,$31,$31
	.byte $31,$31,$31,$31,$31,$31,$33,$34
	.byte $35,$36,$37,$38,$39,$30,$31,$32
	.byte $33,$34,$35,$36,$37,$39,$30,$30
	.byte $30,$30,$30,$30,$30,$30,$30,$30
	.byte $31,$31,$31,$31,$31,$31,$30,$31
	.byte $32,$33,$34,$35,$36,$37,$38,$39
	.byte $30,$31,$32,$33,$34,$35,$00,$1C
	.byte $38,$54,$70,$8C,$A8,$C4,$E0,$00
	.byte $1C,$38,$54,$70,$8C,$A8,$08,$08
	.byte $08,$08,$08,$08,$08,$08,$08,$09
	.byte $09,$09,$09,$09,$09,$09,$0A,$0A
	.byte $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0B
	.byte $0B,$0B,$0B,$0B,$0B,$0B,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$0A,$AA,$AA,$AA,$AA,$AA
	.byte $AA,$AA,$AA,$AA,$AA,$80,$20,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$20,$22,$A8,$A8,$AA,$8A,$A0
	.byte $2A,$8A,$22,$A8,$AA,$20,$22,$08
	.byte $88,$A8,$8A,$00,$22,$8A,$22,$A8
	.byte $82,$20,$22,$00,$88,$88,$8A,$00
	.byte $22,$8A,$22,$80,$82,$20,$22,$00
	.byte $88,$88,$8A,$A0,$22,$8A,$22,$A0
	.byte $AA,$20,$22,$28,$A8,$88,$8A,$A0
	.byte $20,$8A,$22,$00,$A8,$20,$22,$08
	.byte $88,$88,$88,$00,$20,$8A,$A2,$00
	.byte $A8,$20,$22,$08,$88,$88,$88,$00
	.byte $20,$82,$82,$00,$A2,$20,$22,$A8
	.byte $88,$88,$8A,$A0,$2A,$82,$02,$A8
	.byte $A2,$20,$D2,$A1,$DE,$A1,$EA,$A1
	.byte $F6,$A1,$02,$A2,$0E,$A2,$1A,$A2
	.byte $26,$A2,$32,$A2,$3E,$A2,$4A,$A2
	.byte $09,$02,$0C,$0B,$A5,$32,$A6,$6F
	.byte $A3,$9E,$A4,$9C,$A5,$16,$A3,$AC
	.byte $A3,$E1,$A5,$E9,$A3,$E5,$A2,$B7
	.byte $A6,$B7,$A6,$B7,$A6,$B7,$A6,$B7
	.byte $A6,$00,$E1,$68,$F7,$8F,$30,$DA
	.byte $8F,$4E,$18,$EF,$D2,$C3,$C3,$D1
	.byte $EF,$1F,$60,$B5,$1E,$9C,$31,$DF
	.byte $A5,$87,$86,$A2,$DF,$3E,$C1,$6B
	.byte $3C,$39,$63,$BE,$4B,$0F,$00,$08
	.byte $09,$09,$0A,$0B,$0B,$0C,$0D,$0E
	.byte $0E,$0F,$10,$11,$12,$13,$15,$16
	.byte $17,$19,$1A,$1C,$1D,$1F,$21,$23
	.byte $25,$27,$2A,$2C,$2F,$32,$35,$38
	.byte $3B,$3F,$43,$04,$00,$00,$00,$08
	.byte $07,$FF,$A0,$08,$0C,$FF,$A0,$08
	.byte $10,$FF,$A0,$04,$13,$FF,$D0,$0C
	.byte $00,$00,$00,$08,$10,$FF,$A0,$06
	.byte $13,$FF,$D0,$06,$13,$FF,$A0,$06
	.byte $13,$FF,$70,$10,$13,$FF,$40,$10
	.byte $00,$00,$00,$00,$04,$00,$00,$00
	.byte $04,$13,$FF,$C0,$04,$12,$FF,$A0
	.byte $04,$11,$FF,$A0,$04,$10,$FF,$A0
	.byte $04,$0F,$FF,$A0,$04,$14,$FF,$A0
	.byte $04,$13,$FF,$A0,$04,$12,$FF,$A0
	.byte $04,$13,$FF,$D0,$04,$12,$FF,$A0
	.byte $04,$11,$FF,$A0,$04,$10,$FF,$A0
	.byte $04,$0F,$FF,$A0,$04,$10,$FF,$A0
	.byte $04,$11,$FF,$A0,$04,$12,$FF,$A0
	.byte $03,$13,$FF,$D0,$03,$13,$FF,$A0
	.byte $03,$13,$FF,$70,$04,$13,$FF,$40
	.byte $10,$00,$00,$00,$00,$04,$00,$00
	.byte $00,$05,$02,$1C,$A0,$05,$04,$17
	.byte $A0,$05,$05,$15,$A0,$05,$07,$13
	.byte $A0,$05,$09,$11,$A0,$05,$0B,$10
	.byte $A0,$05,$0C,$0C,$A0,$05,$10,$0B
	.byte $A0,$05,$11,$09,$A0,$05,$13,$07
	.byte $A0,$05,$15,$05,$A0,$05,$17,$04
	.byte $A0,$05,$1C,$02,$A0,$10,$00,$00
	.byte $00,$00,$04,$00,$00,$00,$04,$0C
	.byte $FF,$C0,$08,$00,$00,$00,$04,$07
	.byte $FF,$A0,$04,$06,$FF,$A0,$04,$07
	.byte $FF,$A0,$04,$08,$FF,$A0,$08,$00
	.byte $00,$00,$04,$07,$FF,$A0,$08,$00
	.byte $00,$00,$0C,$00,$00,$00,$04,$17
	.byte $11,$A0,$08,$00,$00,$00,$04,$18
	.byte $10,$A0,$10,$00,$00,$00,$00,$04
	.byte $00,$00,$00,$03,$07,$FF,$A0,$01
	.byte $00,$00,$00,$03,$07,$FF,$A0,$01
	.byte $00,$00,$00,$03,$07,$FF,$A0,$05
	.byte $00,$00,$00,$03,$07,$FF,$A0,$01
	.byte $00,$00,$00,$03,$07,$FF,$A0,$01
	.byte $00,$00,$00,$03,$07,$FF,$A0,$05
	.byte $00,$00,$00,$03,$07,$FF,$A0,$01
	.byte $00,$00,$00,$03,$07,$FF,$A0,$01
	.byte $00,$00,$00,$03,$0C,$FF,$B0,$05
	.byte $00,$00,$00,$03,$0E,$FF,$B0,$05
	.byte $00,$00,$00,$03,$10,$FF,$B0,$05
	.byte $00,$00,$00,$03,$07,$FF,$A0,$01
	.byte $00,$00,$00,$03,$07,$FF,$A0,$01
	.byte $00,$00,$00,$03,$07,$FF,$A0,$05
	.byte $00,$00,$A0,$03,$07,$FF,$A0,$01
	.byte $00,$00,$00,$03,$07,$FF,$A0,$01
	.byte $00,$00,$00,$03,$07,$FF,$A0,$05
	.byte $00,$00,$00,$03,$0C,$FF,$A0,$01
	.byte $00,$00,$00,$03,$10,$FF,$A0,$01
	.byte $00,$00,$00,$03,$0E,$FF,$B0,$05
	.byte $00,$00,$00,$03,$0B,$FF,$B0,$05
	.byte $00,$00,$00,$03,$07,$FF,$B0,$10
	.byte $00,$00,$00,$00,$04,$00,$00,$00
	.byte $04,$07,$FF,$A0,$04,$0C,$FF,$A0
	.byte $04,$10,$FF,$A0,$04,$13,$FF,$D0
	.byte $08,$00,$00,$00,$02,$13,$FF,$A0
	.byte $02,$00,$00,$00,$04,$13,$FF,$A0
	.byte $04,$00,$00,$00,$04,$10,$FF,$D0
	.byte $08,$00,$00,$00,$02,$10,$FF,$A0
	.byte $02,$00,$00,$00,$04,$10,$FF,$A0
	.byte $04,$00,$00,$00,$04,$0C,$FF,$A0
	.byte $04,$00,$00,$00,$04,$10,$FF,$A0
	.byte $04,$00,$00,$00,$04,$0C,$FF,$A0
	.byte $04,$00,$00,$00,$06,$07,$FF,$D0
	.byte $06,$07,$FF,$A0,$06,$07,$FF,$70
	.byte $06,$07,$FF,$50,$10,$00,$00,$00
	.byte $00,$04,$00,$00,$00,$02,$13,$10
	.byte $D0,$06,$13,$10,$A0,$08,$11,$0E
	.byte $A0,$06,$10,$0C,$A0,$02,$10,$0C
	.byte $40,$08,$10,$0C,$A0,$08,$11,$0E
	.byte $A0,$06,$10,$0C,$A0,$02,$10,$0C
	.byte $40,$08,$0E,$07,$A0,$08,$10,$0C
	.byte $A0,$06,$0E,$07,$A0,$02,$0E,$07
	.byte $40,$04,$0E,$07,$D0,$04,$0E,$07
	.byte $B0,$04,$0E,$07,$A0,$04,$0E,$07
	.byte $90,$04,$0E,$07,$80,$04,$0E,$07
	.byte $70,$08,$0E,$07,$A0,$08,$10,$0C
	.byte $A0,$06,$0E,$07,$A0,$02,$0E,$07
	.byte $40,$04,$0E,$07,$D0,$04,$0E,$07
	.byte $B0,$04,$0E,$07,$A0,$04,$0E,$07
	.byte $90,$04,$0E,$07,$80,$04,$0E,$07
	.byte $70,$04,$0E,$07,$60,$04,$0E,$07
	.byte $50,$04,$0E,$07,$40,$04,$0E,$07
	.byte $30,$08,$0E,$07,$20,$10,$00,$00
	.byte $00,$00,$04,$00,$00,$00,$04,$10
	.byte $FF,$A0,$04,$13,$FF,$A0,$04,$18
	.byte $FF,$A0,$04,$15,$FF,$A0,$04,$11
	.byte $FF,$A0,$04,$0E,$FF,$A0,$04,$13
	.byte $FF,$A0,$04,$11,$FF,$A0,$04,$0E
	.byte $FF,$A0,$04,$0C,$FF,$A0,$0C,$00
	.byte $00,$00,$02,$18,$FF,$A0,$02,$13
	.byte $FF,$A0,$02,$10,$FF,$A0,$04,$0C
	.byte $FF,$A0,$10,$00,$00,$00,$00,$04
	.byte $00,$00,$00,$04,$18,$FF,$A0,$04
	.byte $17,$FF,$A0,$04,$16,$FF,$A0,$04
	.byte $15,$FF,$A0,$04,$14,$FF,$A0,$04
	.byte $13,$FF,$A0,$04,$12,$FF,$A0,$04
	.byte $11,$FF,$A0,$04,$10,$FF,$A0,$04
	.byte $0F,$FF,$A0,$04,$0E,$FF,$A0,$04
	.byte $0D,$FF,$A0,$04,$0C,$FF,$A0,$0C
	.byte $00,$00,$00,$02,$0C,$FF,$A0,$02
	.byte $10,$FF,$A0,$02,$13,$FF,$A0,$04
	.byte $18,$FF,$A0,$10,$00,$00,$00,$00
	.byte $04,$00,$00,$00,$04,$10,$FF,$A0
	.byte $04,$13,$FF,$A0,$04,$18,$FF,$A0
	.byte $04,$13,$FF,$A0,$04,$10,$FF,$A0
	.byte $04,$13,$FF,$A0,$04,$18,$FF,$A0
	.byte $04,$13,$FF,$A0,$04,$15,$FF,$D0
	.byte $04,$00,$00,$00,$02,$11,$FF,$A0
	.byte $02,$11,$FF,$80,$04,$00,$00,$00
	.byte $02,$11,$FF,$A0,$02,$11,$FF,$80
	.byte $0C,$00,$00,$00,$04,$12,$FF,$A0
	.byte $04,$15,$FF,$A0,$04,$1F,$0F,$A0
	.byte $04,$15,$FF,$A0,$04,$12,$FF,$A0
	.byte $04,$15,$FF,$A0,$04,$1F,$0F,$A0
	.byte $04,$15,$FF,$A0,$04,$17,$FF,$D0
	.byte $04,$00,$00,$00,$02,$13,$FF,$A0
	.byte $02,$13,$FF,$80,$04,$00,$00,$00
	.byte $02,$13,$FF,$A0,$02,$13,$FF,$80
	.byte $10,$00,$00,$00,$00,$00,$21,$22
	.byte $25,$2A,$26,$1E,$00,$36,$A9,$36
	.byte $AA,$36,$AB,$36,$A9,$CF,$A6,$9F
	.byte $A7,$93,$A8,$1F,$A9,$16,$4C,$66
	.byte $02,$55,$01,$66,$02,$36,$18,$55
	.byte $01,$44,$01,$66,$14,$36,$0D,$30
	.byte $17,$60,$08,$66,$03,$16,$16,$66
	.byte $04,$36,$23,$32,$01,$62,$01,$55
	.byte $01,$66,$20,$16,$07,$66,$02,$36
	.byte $25,$30,$14,$60,$0E,$10,$11,$16
	.byte $25,$10,$08,$16,$23,$10,$06,$60
	.byte $02,$30,$0F,$36,$17,$66,$02,$16
	.byte $07,$55,$01,$66,$1E,$16,$38,$44
	.byte $01,$16,$05,$44,$01,$16,$07,$44
	.byte $01,$36,$07,$55,$01,$36,$04,$55
	.byte $01,$16,$03,$55,$01,$16,$03,$36
	.byte $0B,$55,$01,$16,$03,$36,$0E,$44
	.byte $01,$66,$01,$60,$0C,$30,$29,$60
	.byte $02,$44,$01,$16,$2B,$10,$04,$60
	.byte $05,$30,$01,$36,$67,$32,$01,$44
	.byte $01,$66,$2B,$36,$0C,$30,$15,$36
	.byte $12,$55,$01,$16,$03,$55,$01,$36
	.byte $05,$55,$01,$16,$03,$36,$08,$66
	.byte $02,$16,$4A,$10,$04,$60,$07,$30
	.byte $09,$36,$15,$66,$0A,$16,$0D,$44
	.byte $01,$66,$02,$16,$04,$44,$01,$16
	.byte $02,$44,$06,$16,$04,$44,$01,$16
	.byte $02,$62,$15,$36,$31,$66,$01,$62
	.byte $04,$12,$06,$44,$01,$66,$37,$36
	.byte $01,$30,$1D,$60,$33,$36,$32,$66
	.byte $03,$16,$01,$10,$1B,$60,$05,$36
	.byte $28,$44,$01,$66,$1F,$36,$14,$44
	.byte $01,$55,$01,$66,$2D,$36,$01,$30
	.byte $12,$60,$25,$66,$01,$55,$01,$16
	.byte $0D,$66,$02,$36,$09,$30,$0A,$36
	.byte $04,$44,$01,$36,$03,$44,$01,$36
	.byte $03,$16,$22,$44,$01,$16,$07,$44
	.byte $04,$16,$03,$44,$01,$16,$27,$12
	.byte $0E,$16,$1E,$55,$01,$66,$19,$36
	.byte $01,$30,$03,$60,$07,$10,$1F,$60
	.byte $07,$30,$09,$36,$33,$66,$04,$10
	.byte $09,$16,$08,$12,$01,$62,$0C,$32
	.byte $01,$36,$32,$44,$01,$16,$0B,$44
	.byte $01,$16,$09,$44,$01,$10,$2C,$60
	.byte $04,$30,$03,$36,$0A,$44,$01,$16
	.byte $05,$44,$01,$36,$03,$44,$01,$36
	.byte $03,$44,$01,$66,$03,$36,$03,$55
	.byte $01,$36,$08,$55,$01,$66,$4C,$16
	.byte $09,$10,$15,$44,$01,$10,$2F,$16
	.byte $09,$12,$03,$16,$12,$66,$02,$36
	.byte $06,$66,$2D,$55,$01,$16,$03,$10
	.byte $1C,$55,$01,$16,$03,$44,$01,$36
	.byte $03,$32,$15,$36,$0B,$30,$0B,$60
	.byte $0C,$44,$01,$62,$0D,$12,$02,$16
	.byte $0D,$44,$01,$66,$20,$36,$04,$30
	.byte $17,$36,$1E,$44,$01,$36,$2F,$30
	.byte $08,$60,$03,$10,$22,$16,$1B,$66
	.byte $26,$55,$07,$16,$03,$55,$01,$66
	.byte $1D,$16,$02,$10,$85,$60,$02,$30
	.byte $03,$36,$03,$32,$0F,$36,$03,$30
	.byte $0C,$36,$20,$66,$01,$16,$0A,$60
	.byte $06,$66,$02,$36,$08,$30,$05,$60
	.byte $02,$66,$02,$16,$08,$10,$01,$60
	.byte $06,$66,$01,$36,$08,$30,$04,$60
	.byte $03,$66,$01,$16,$08,$10,$02,$60
	.byte $03,$30,$01,$36,$08,$30,$03,$60
	.byte $03,$16,$09,$10,$02,$60,$03,$30
	.byte $03,$36,$07,$30,$03,$60,$02,$10
	.byte $02,$16,$08,$10,$01,$60,$02,$30
	.byte $02,$36,$0A,$30,$02,$60,$02,$10
	.byte $03,$16,$04,$10,$03,$60,$05,$30
	.byte $02,$36,$07,$66,$16,$36,$02,$66
	.byte $33,$55,$01,$36,$05,$55,$01,$36
	.byte $04,$55,$01,$36,$03,$55,$01,$36
	.byte $03,$55,$01,$66,$A9,$62,$0C,$66
	.byte $38,$10,$10,$55,$01,$36,$04,$55
	.byte $01,$66,$48,$16,$26,$66,$30,$16
	.byte $15,$44,$01,$60,$0A,$16,$32,$36
	.byte $30,$55,$01,$44,$01,$66,$33,$36
	.byte $0F,$66,$08,$16,$01,$66,$05,$55
	.byte $01,$66,$7F,$00,$06,$00,$00,$07
	.byte $00,$00,$07,$00,$00,$06,$00,$00
	.byte $03,$06,$13,$11,$11,$11,$11,$11
	.byte $11,$11,$11,$03,$00,$00,$03,$06
	.byte $03,$00,$00,$00,$00,$00,$00,$07
	.byte $00,$43,$44,$44,$03,$76,$11,$11
	.byte $11,$11,$31,$11,$11,$11,$11,$01
	.byte $00,$00,$13,$11,$11,$11,$11,$11
	.byte $33,$00,$00,$00,$00,$00,$00,$00
	.byte $03,$00,$11,$11,$11,$31,$43,$44
	.byte $44,$44,$03,$00,$00,$00,$03,$00
	.byte $71,$70,$11,$33,$00,$00,$00,$08
	.byte $03,$70,$00,$08,$03,$70,$11,$11
	.byte $31,$03,$00,$00,$13,$11,$21,$22
	.byte $11,$11,$13,$11,$00,$00,$30,$00
	.byte $00,$00,$03,$00,$00,$00,$00,$00
	.byte $03,$00,$00,$00,$30,$00,$00,$00
	.byte $03,$00,$00,$00,$00,$00,$03,$00
	.byte $00,$00,$38,$00,$70,$00,$43,$44
	.byte $44,$44,$44,$44,$03,$70,$13,$11
	.byte $11,$11,$11,$11,$03,$70,$00,$00
	.byte $70,$00,$13,$11,$03,$00,$00,$00
	.byte $00,$00,$03,$11,$11,$11,$11,$01
	.byte $03,$00,$03,$00,$00,$00,$00,$00
	.byte $03,$00,$00,$00,$00,$00,$03,$00
	.byte $03,$00,$00,$70,$00,$00,$03,$00
	.byte $90,$70,$00,$00,$03,$00,$11,$11
	.byte $11,$11,$11,$11,$11,$11,$11,$11
	.byte $11,$11,$11,$11,$00,$00,$C1,$A0
	.byte $C7,$CF,$CF,$C4,$A0,$CF,$CC,$C4
	.byte $A0,$CC,$C1,$C4,$D9,$00,$00,$00
	.byte $CC,$CF,$C4,$C5,$A0,$D2,$D5,$CE
	.byte $CE,$C5,$52,$00,$11,$11,$61,$11
	.byte $11,$11,$11,$11,$11,$11,$11,$01
	.byte $11,$11,$06,$00,$61,$01,$44,$44
	.byte $44,$04,$00,$00,$00,$00,$00,$10
	.byte $16,$61,$60,$01,$71,$00,$10,$13
	.byte $00,$00,$00,$00,$80,$10,$06,$11
	.byte $11,$01,$11,$11,$11,$13,$11,$11
	.byte $07,$31,$11,$11,$61,$00,$00,$47
	.byte $44,$11,$11,$13,$11,$11,$11,$31
	.byte $01,$11,$11,$11,$11,$01,$00,$01
	.byte $10,$13,$11,$10,$11,$31,$01,$11
	.byte $00,$00,$00,$80,$00,$00,$10,$13
	.byte $11,$10,$01,$31,$71,$10,$13,$11
	.byte $11,$11,$13,$73,$10,$13,$11,$10
	.byte $01,$31,$11,$11,$03,$00,$00,$00
	.byte $13,$11,$11,$13,$11,$07,$01,$31
	.byte $11,$10,$03,$00,$00,$00,$00,$11
	.byte $11,$13,$11,$11,$01,$31,$11,$17
	.byte $03,$00,$00,$00,$01,$00,$00,$03
	.byte $00,$00,$00,$30,$00,$10,$13,$11
	.byte $13,$11,$31,$21,$21,$21,$21,$21
	.byte $21,$31,$21,$21,$13,$11,$13,$11
	.byte $31,$11,$11,$11,$00,$11,$11,$31
	.byte $21,$21,$03,$00,$03,$00,$30,$11
	.byte $11,$11,$01,$10,$11,$31,$00,$00
	.byte $13,$11,$11,$11,$31,$11,$11,$11
	.byte $11,$07,$11,$11,$11,$31,$93,$00
	.byte $00,$00,$30,$70,$10,$11,$11,$01
	.byte $80,$00,$00,$30,$00,$00,$C2,$C5
	.byte $C1,$D5,$D4,$C9,$C6,$C9,$C5,$C4
	.byte $A0,$D7,$C9,$D4,$C8,$00,$00,$00
	.byte $CC,$CF,$C4,$C5,$A0,$D2,$D5,$CE
	.byte $CE,$C5,$52,$00,$00,$00,$00,$30
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$80,$07,$00,$30,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$70,$08
	.byte $13,$81,$07,$30,$00,$00,$00,$00
	.byte $00,$00,$00,$70,$18,$31,$03,$10
	.byte $01,$30,$11,$11,$36,$11,$11,$31
	.byte $00,$10,$01,$30,$03,$00,$00,$00
	.byte $00,$00,$33,$07,$00,$30,$00,$00
	.byte $00,$30,$03,$00,$00,$00,$00,$00
	.byte $37,$03,$00,$30,$00,$00,$00,$30
	.byte $03,$00,$00,$00,$00,$00,$33,$07
	.byte $00,$00,$00,$00,$00,$30,$03,$00
	.byte $00,$00,$00,$00,$37,$03,$00,$00
	.byte $00,$00,$00,$30,$03,$00,$00,$00
	.byte $00,$00,$33,$07,$00,$00,$00,$00
	.byte $00,$30,$03,$00,$00,$00,$00,$00
	.byte $37,$03,$00,$00,$00,$00,$00,$30
	.byte $03,$00,$00,$00,$00,$00,$33,$07
	.byte $00,$00,$00,$00,$00,$30,$03,$00
	.byte $00,$00,$00,$00,$37,$03,$00,$00
	.byte $00,$00,$00,$30,$03,$00,$00,$00
	.byte $00,$00,$33,$07,$00,$00,$00,$00
	.byte $00,$30,$03,$00,$00,$00,$00,$00
	.byte $37,$03,$00,$00,$00,$00,$00,$30
	.byte $03,$00,$00,$00,$09,$00,$33,$07
	.byte $00,$00,$00,$00,$00,$30,$03,$00
	.byte $30,$11,$11,$11,$11,$11,$11,$11
	.byte $11,$03,$00,$30,$00,$00,$C1,$A0
	.byte $C6,$C5,$D7,$A0,$CE,$C5,$D7,$A0
	.byte $C9,$C4,$C5,$C1,$D3,$00,$00,$00
	.byte $CC,$CF,$C4,$C5,$A0,$D2,$D5,$CE
	.byte $CE,$C5,$52,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$A8,$80,$00
	.byte $A8,$80,$00,$A8,$80,$00,$A8,$80
	.byte $00,$00,$00,$00,$8A,$80,$00,$8A
	.byte $80,$00,$8A,$80,$00,$8A,$80,$00
	.byte $8A,$80,$00,$00,$00,$00,$AA,$80
	.byte $00,$AA,$80,$00,$AA,$80,$00,$AA
	.byte $80,$00,$AA,$80,$00,$AA,$80,$00
	.byte $AA,$80,$00,$AA,$80,$00,$AA,$80
	.byte $00,$AA,$80,$00,$00,$00,$00,$C3
	.byte $00,$00,$C3,$00,$00,$FF,$00,$00
	.byte $C3,$00,$00,$C3,$00,$00,$C3,$00
	.byte $00,$C3,$00,$00,$FF,$00,$00,$C3
	.byte $00,$00,$C3,$00,$00,$C3,$00,$00
	.byte $00,$00,$00,$FF,$C0,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$AA,$80,$00,$AA,$80,$00,$00
	.byte $00,$00,$3F,$00,$00,$0C,$00,$00
	.byte $0C,$00,$00,$0C,$00,$00,$0C,$00
	.byte $00,$AA,$80,$00,$AA,$80,$00,$00
	.byte $00,$00,$C0,$00,$00,$C0,$00,$00
	.byte $FF,$00,$00,$C3,$00,$00,$03,$00
	.byte $00,$03,$00,$00,$03,$00,$00,$C3
	.byte $00,$00,$FF,$00,$00,$C0,$00,$00
	.byte $C0,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$FF,$00,$00,$EB,$00,$00
	.byte $EB,$00,$00,$EB,$00,$00,$FF,$00
	.byte $00,$00,$00,$00,$04,$00,$00,$14
	.byte $00,$00,$14,$00,$00,$04,$00,$00
	.byte $15,$00,$00,$44,$40,$00,$04,$00
	.byte $00,$15,$00,$00,$15,$40,$00,$10
	.byte $00,$00,$10,$00,$00,$0C,$00,$00
	.byte $0F,$00,$00,$0F,$00,$00,$0C,$00
	.byte $00,$3F,$00,$00,$CC,$C0,$00,$0C
	.byte $00,$00,$3F,$00,$00,$FF,$00,$00
	.byte $03,$00,$00,$03,$00,$00,$FF,$C0
	.byte $00,$FF,$C0,$00,$FF,$C0,$00,$FF
	.byte $C0,$00,$FF,$C0,$00,$FF,$C0,$00
	.byte $FF,$C0,$00,$FF,$C0,$00,$FF,$C0
	.byte $00,$FF,$C0,$00,$FF,$C0,$00,$10
	.byte $00,$00,$38,$00,$00,$38,$00,$00
	.byte $1C,$00,$00,$3B,$00,$00,$CD,$80
	.byte $00,$0C,$00,$00,$1C,$00,$00,$37
	.byte $80,$00,$30,$00,$00,$30,$00,$00
	.byte $10,$00,$00,$38,$00,$00,$38,$00
	.byte $00,$18,$00,$00,$1C,$00,$00,$3E
	.byte $00,$00,$DE,$00,$00,$38,$00,$00
	.byte $3C,$00,$00,$0E,$00,$00,$0C,$00
	.byte $00,$10,$00,$00,$38,$00,$00,$38
	.byte $00,$00,$18,$00,$00,$5E,$00,$00
	.byte $7B,$00,$00,$18,$00,$00,$3C,$00
	.byte $00,$66,$00,$00,$63,$00,$00,$03
	.byte $00,$00,$0C,$00,$00,$0C,$40,$00
	.byte $0F,$C0,$00,$4E,$00,$00,$7E,$00
	.byte $00,$0E,$00,$00,$0E,$00,$00,$1B
	.byte $00,$00,$1B,$80,$00,$18,$00,$00
	.byte $38,$00,$00,$02,$00,$00,$07,$00
	.byte $00,$07,$00,$00,$03,$00,$00,$0F
	.byte $C0,$00,$5B,$40,$00,$43,$00,$00
	.byte $07,$00,$00,$0D,$80,$00,$0D,$80
	.byte $00,$0D,$80,$00,$02,$00,$00,$07
	.byte $00,$00,$07,$00,$00,$0E,$00,$00
	.byte $37,$00,$00,$6C,$C0,$00,$0C,$00
	.byte $00,$0E,$00,$00,$7B,$00,$00,$03
	.byte $00,$00,$03,$00,$00,$02,$00,$00
	.byte $07,$00,$00,$07,$00,$00,$06,$00
	.byte $00,$0E,$00,$00,$1F,$00,$00,$1E
	.byte $C0,$00,$07,$00,$00,$0F,$00,$00
	.byte $1C,$00,$00,$0C,$00,$00,$02,$00
	.byte $00,$07,$00,$00,$07,$00,$00,$06
	.byte $00,$00,$1E,$80,$00,$37,$80,$00
	.byte $06,$00,$00,$0F,$00,$00,$19,$80
	.byte $00,$31,$80,$00,$30,$00,$00,$0C
	.byte $00,$00,$8C,$00,$00,$FC,$00,$00
	.byte $1C,$80,$00,$1F,$80,$00,$1C,$00
	.byte $00,$1C,$00,$00,$36,$00,$00,$76
	.byte $00,$00,$06,$00,$00,$07,$00,$00
	.byte $64,$C0,$00,$6E,$C0,$00,$6E,$C0
	.byte $00,$3F,$80,$00,$06,$00,$00,$06
	.byte $00,$00,$1E,$00,$00,$36,$00,$00
	.byte $36,$00,$00,$36,$00,$00,$06,$00
	.byte $00,$C9,$80,$00,$DD,$80,$00,$DD
	.byte $80,$00,$7F,$00,$00,$18,$00,$00
	.byte $18,$00,$00,$1E,$00,$00,$1B,$00
	.byte $00,$1B,$00,$00,$1B,$00,$00,$18
	.byte $00,$00,$61,$80,$00,$61,$80,$00
	.byte $6D,$80,$00,$6F,$00,$00,$3C,$00
	.byte $00,$18,$00,$00,$18,$00,$00,$78
	.byte $00,$00,$D8,$00,$00,$D8,$00,$00
	.byte $B0,$00,$00,$06,$00,$00,$06,$00
	.byte $00,$1E,$00,$00,$1C,$00,$00,$78
	.byte $00,$00,$D8,$00,$00,$18,$00,$00
	.byte $38,$00,$00,$6C,$00,$00,$6C,$00
	.byte $00,$6C,$00,$00,$18,$00,$00,$18
	.byte $00,$00,$1E,$00,$00,$0E,$C0,$00
	.byte $07,$80,$00,$06,$00,$00,$06,$00
	.byte $00,$0E,$00,$00,$1B,$00,$00,$1B
	.byte $00,$00,$1B,$00,$00,$61,$80,$00
	.byte $61,$80,$00,$6D,$80,$00,$3D,$80
	.byte $00,$0F,$00,$00,$06,$00,$00,$06
	.byte $00,$00,$07,$80,$00,$06,$C0,$00
	.byte $06,$C0,$00,$03,$40,$00,$18,$00
	.byte $00,$18,$00,$00,$1E,$00,$00,$0E
	.byte $00,$00,$07,$80,$00,$06,$C0,$00
	.byte $06,$00,$00,$07,$00,$00,$0D,$80
	.byte $00,$0D,$80,$00,$0D,$80,$00,$06
	.byte $00,$00,$06,$00,$00,$1E,$00,$00
	.byte $DC,$00,$00,$78,$00,$00,$18,$00
	.byte $00,$18,$00,$00,$1C,$00,$00,$36
	.byte $00,$00,$36,$00,$00,$36,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$08,$00,$00,$02,$40,$00
	.byte $20,$40,$00,$09,$00,$00,$01,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$08,$00,$00,$00,$00,$00
	.byte $00,$80,$00,$80,$00,$00,$20,$00
	.byte $00,$0A,$40,$00,$21,$40,$00,$09
	.byte $00,$00,$08,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$88,$00,$00,$00
	.byte $80,$00,$80,$00,$00,$20,$00,$00
	.byte $02,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$08,$00,$00,$00
	.byte $00,$00,$80,$00,$00,$00,$00,$00
	.byte $00,$80,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$A4,$80,$00,$A8
	.byte $80,$00,$A8,$80,$00,$A8,$80,$00
	.byte $00,$00,$00,$8A,$80,$00,$8A,$80
	.byte $00,$8A,$80,$00,$8A,$80,$00,$8A
	.byte $80,$00,$00,$00,$00,$04,$00,$00
	.byte $14,$00,$00,$80,$80,$00,$A8,$80
	.byte $00,$00,$00,$00,$8A,$80,$00,$8A
	.byte $80,$00,$8A,$80,$00,$8A,$80,$00
	.byte $8A,$80,$00,$00,$00,$00,$00,$00
	.byte $00,$04,$00,$00,$14,$00,$00,$94
	.byte $80,$00,$00,$00,$00,$8A,$80,$00
	.byte $8A,$80,$00,$8A,$80,$00,$8A,$80
	.byte $00,$8A,$80,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $04,$00,$00,$14,$00,$00,$15,$00
	.byte $00,$00,$00,$00,$8A,$80,$00,$8A
	.byte $80,$00,$8A,$80,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$04
	.byte $00,$00,$05,$00,$00,$95,$00,$00
	.byte $80,$00,$00,$8A,$80,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$04,$00
	.byte $00,$14,$00,$00,$15,$00,$00,$00
	.byte $00,$00,$08,$00,$00,$1C,$00,$00
	.byte $1C,$00,$00,$18,$00,$00,$7E,$00
	.byte $00,$5B,$40,$00,$18,$40,$00,$1C
	.byte $00,$00,$36,$00,$00,$36,$00,$00
	.byte $36,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$08,$00,$00
	.byte $22,$00,$00,$48,$00,$00,$50,$80
	.byte $00,$10,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$08,$00,$00
	.byte $00,$00,$00,$00,$80,$00,$A0,$00
	.byte $00,$40,$00,$00,$4A,$00,$00,$11
	.byte $00,$00,$11,$00,$00,$02,$00,$00
	.byte $05,$00,$00,$05,$00,$00,$04,$00
	.byte $00,$15,$00,$00,$44,$40,$00,$0C
	.byte $00,$00,$0E,$00,$00,$7B,$00,$00
	.byte $03,$00,$00,$03,$00,$00,$02,$00
	.byte $00,$05,$00,$00,$05,$00,$00,$04
	.byte $00,$00,$14,$00,$00,$15,$00,$00
	.byte $06,$40,$00,$07,$00,$00,$0F,$00
	.byte $00,$1C,$00,$00,$0C,$00,$00,$02
	.byte $00,$00,$05,$00,$00,$05,$00,$00
	.byte $04,$00,$00,$15,$00,$00,$45,$00
	.byte $00,$06,$00,$00,$0F,$00,$00,$19
	.byte $80,$00,$31,$80,$00,$30,$00,$00
	.byte $08,$00,$00,$14,$00,$00,$14,$00
	.byte $00,$04,$00,$00,$05,$00,$00,$15
	.byte $00,$00,$4C,$00,$00,$1C,$00,$00
	.byte $1E,$00,$00,$07,$00,$00,$06,$00
	.byte $00,$08,$00,$00,$14,$00,$00,$14
	.byte $00,$00,$04,$00,$00,$15,$00,$00
	.byte $14,$40,$00,$0C,$00,$00,$1E,$00
	.byte $00,$33,$00,$00,$31,$80,$00,$01
	.byte $80,$00,$41,$00,$00,$41,$00,$00
	.byte $45,$00,$00,$45,$00,$00,$14,$00
	.byte $00,$18,$00,$00,$10,$00,$00,$78
	.byte $00,$00,$D8,$00,$00,$D8,$00,$00
	.byte $B0,$00,$00,$04,$00,$00,$04,$00
	.byte $00,$14,$00,$00,$14,$00,$00,$50
	.byte $00,$00,$50,$00,$00,$10,$00,$00
	.byte $38,$00,$00,$6C,$00,$00,$6C,$00
	.byte $00,$6C,$00,$00,$10,$00,$00,$10
	.byte $00,$00,$14,$00,$00,$04,$40,$00
	.byte $05,$00,$00,$04,$00,$00,$04,$00
	.byte $00,$0E,$00,$00,$1B,$00,$00,$1B
	.byte $00,$00,$1B,$00,$00,$41,$00,$00
	.byte $41,$00,$00,$51,$00,$00,$51,$00
	.byte $00,$14,$00,$00,$04,$00,$00,$04
	.byte $00,$00,$0F,$00,$00,$0D,$80,$00
	.byte $0D,$80,$00,$06,$80,$00,$10,$00
	.byte $00,$10,$00,$00,$14,$00,$00,$14
	.byte $00,$00,$05,$00,$00,$05,$00,$00
	.byte $04,$00,$00,$07,$00,$00,$0D,$80
	.byte $00,$0D,$80,$00,$0D,$80,$00,$04
	.byte $00,$00,$04,$00,$00,$14,$00,$00
	.byte $10,$00,$00,$50,$00,$00,$10,$00
	.byte $00,$10,$00,$00,$1C,$00,$00,$36
	.byte $00,$00,$36,$00,$00,$36,$00,$00
	.byte $04,$00,$00,$04,$40,$00,$05,$40
	.byte $00,$44,$00,$00,$54,$00,$00,$04
	.byte $00,$00,$0E,$00,$00,$1B,$00,$00
	.byte $1B,$80,$00,$18,$00,$00,$38,$00
	.byte $00,$04,$00,$00,$84,$00,$00,$D4
	.byte $00,$00,$14,$80,$00,$15,$80,$00
	.byte $14,$00,$00,$1C,$00,$00,$36,$00
	.byte $00,$76,$00,$00,$06,$00,$00,$07
	.byte $00,$00,$44,$40,$00,$44,$40,$00
	.byte $44,$40,$00,$15,$00,$00,$04,$00
	.byte $00,$04,$00,$00,$0F,$00,$00,$0D
	.byte $80,$00,$0D,$80,$00,$0D,$80,$00
	.byte $0C,$00,$00,$44,$80,$00,$44,$80
	.byte $00,$44,$80,$00,$15,$00,$00,$04
	.byte $00,$00,$04,$00,$00,$1E,$00,$00
	.byte $36,$00,$00,$36,$00,$00,$36,$00
	.byte $00,$06,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$80,$80,$00,$80
	.byte $80,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$80
	.byte $80,$00,$80,$80,$00,$80,$80,$00
	.byte $80,$80,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$14,$00
	.byte $00,$55,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$14,$00,$00,$55
	.byte $00,$00,$55,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$55,$00,$00,$41,$00,$00,$41
	.byte $00,$00,$41,$00,$00,$45,$00,$00
	.byte $45,$00,$00,$45,$00,$00,$55,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$14,$00,$00,$14,$00,$00
	.byte $04,$00,$00,$04,$00,$00,$04,$00
	.byte $00,$04,$00,$00,$15,$00,$00,$15
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$55,$00,$00,$41,$00
	.byte $00,$01,$00,$00,$55,$00,$00,$40
	.byte $00,$00,$40,$00,$00,$45,$00,$00
	.byte $55,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$55,$00,$00,$41
	.byte $00,$00,$01,$00,$00,$15,$00,$00
	.byte $01,$00,$00,$01,$00,$00,$41,$00
	.byte $00,$55,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$51,$00,$00
	.byte $51,$00,$00,$51,$00,$00,$55,$00
	.byte $00,$01,$00,$00,$01,$00,$00,$01
	.byte $00,$00,$01,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$55,$00
	.byte $00,$40,$00,$00,$40,$00,$00,$55
	.byte $00,$00,$05,$00,$00,$05,$00,$00
	.byte $05,$00,$00,$55,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$55
	.byte $00,$00,$41,$00,$00,$40,$00,$00
	.byte $40,$00,$00,$55,$00,$00,$45,$00
	.byte $00,$45,$00,$00,$55,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $55,$00,$00,$05,$00,$00,$05,$00
	.byte $00,$05,$00,$00,$14,$00,$00,$10
	.byte $00,$00,$10,$00,$00,$10,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$15,$00,$00,$11,$00,$00,$11
	.byte $00,$00,$55,$00,$00,$41,$00,$00
	.byte $41,$00,$00,$41,$00,$00,$55,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$55,$00,$00,$41,$00,$00
	.byte $41,$00,$00,$55,$00,$00,$05,$00
	.byte $00,$05,$00,$00,$05,$00,$00,$05
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$2A,$00,$00,$22,$00
	.byte $00,$22,$00,$00,$AA,$00,$00,$82
	.byte $00,$00,$82,$00,$00,$8A,$00,$00
	.byte $8A,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$A8,$00,$00,$88
	.byte $00,$00,$88,$00,$00,$AA,$00,$00
	.byte $82,$00,$00,$82,$00,$00,$82,$00
	.byte $00,$AA,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$AA,$00,$00
	.byte $82,$00,$00,$80,$00,$00,$80,$00
	.byte $00,$A0,$00,$00,$A0,$00,$00,$A2
	.byte $00,$00,$AA,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$A8,$00
	.byte $00,$82,$00,$00,$82,$00,$00,$82
	.byte $00,$00,$A2,$00,$00,$A2,$00,$00
	.byte $A2,$00,$00,$A8,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$AA
	.byte $00,$00,$A0,$00,$00,$A0,$00,$00
	.byte $A8,$00,$00,$80,$00,$00,$80,$00
	.byte $00,$80,$00,$00,$AA,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $AA,$00,$00,$A0,$00,$00,$A0,$00
	.byte $00,$A8,$00,$00,$80,$00,$00,$80
	.byte $00,$00,$80,$00,$00,$80,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$AA,$00,$00,$82,$00,$00,$80
	.byte $00,$00,$80,$00,$00,$8A,$00,$00
	.byte $8A,$00,$00,$82,$00,$00,$AA,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$82,$00,$00,$82,$00,$00
	.byte $82,$00,$00,$AA,$00,$00,$A2,$00
	.byte $00,$A2,$00,$00,$A2,$00,$00,$A2
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$20,$00,$00,$20,$00
	.byte $00,$20,$00,$00,$28,$00,$00,$28
	.byte $00,$00,$28,$00,$00,$28,$00,$00
	.byte $28,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$08,$00,$00,$08
	.byte $00,$00,$08,$00,$00,$0A,$00,$00
	.byte $0A,$00,$00,$0A,$00,$00,$8A,$00
	.byte $00,$AA,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$82,$00,$00
	.byte $8A,$00,$00,$88,$00,$00,$A8,$00
	.byte $00,$AA,$00,$00,$A2,$00,$00,$A2
	.byte $00,$00,$A2,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$80,$00
	.byte $00,$80,$00,$00,$80,$00,$00,$80
	.byte $00,$00,$A0,$00,$00,$A0,$00,$00
	.byte $A0,$00,$00,$AA,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$82
	.byte $00,$00,$A2,$00,$00,$AA,$00,$00
	.byte $AA,$00,$00,$82,$00,$00,$82,$00
	.byte $00,$82,$00,$00,$82,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $82,$00,$00,$82,$00,$00,$A2,$00
	.byte $00,$AA,$00,$00,$AA,$00,$00,$8A
	.byte $00,$00,$82,$00,$00,$82,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$AA,$00,$00,$8A,$00,$00,$8A
	.byte $00,$00,$82,$00,$00,$82,$00,$00
	.byte $82,$00,$00,$82,$00,$00,$AA,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$AA,$00,$00,$82,$00,$00
	.byte $82,$00,$00,$AA,$00,$00,$A0,$00
	.byte $00,$A0,$00,$00,$A0,$00,$00,$A0
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$AA,$00,$00,$8A,$00
	.byte $00,$8A,$00,$00,$82,$00,$00,$82
	.byte $00,$00,$82,$00,$00,$88,$00,$00
	.byte $A2,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$AA,$00,$00,$82
	.byte $00,$00,$82,$00,$00,$AA,$00,$00
	.byte $A8,$00,$00,$A8,$00,$00,$A2,$00
	.byte $00,$A2,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$AA,$00,$00
	.byte $82,$00,$00,$80,$00,$00,$AA,$00
	.byte $00,$0A,$00,$00,$0A,$00,$00,$8A
	.byte $00,$00,$AA,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$AA,$00
	.byte $00,$20,$00,$00,$20,$00,$00,$20
	.byte $00,$00,$28,$00,$00,$28,$00,$00
	.byte $28,$00,$00,$28,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$82
	.byte $00,$00,$82,$00,$00,$82,$00,$00
	.byte $82,$00,$00,$A2,$00,$00,$A2,$00
	.byte $00,$A2,$00,$00,$AA,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $A2,$00,$00,$A2,$00,$00,$A2,$00
	.byte $00,$A2,$00,$00,$A2,$00,$00,$AA
	.byte $00,$00,$28,$00,$00,$20,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$82,$00,$00,$82,$00,$00,$82
	.byte $00,$00,$82,$00,$00,$AA,$00,$00
	.byte $AA,$00,$00,$A2,$00,$00,$82,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$82,$00,$00,$82,$00,$00
	.byte $82,$00,$00,$28,$00,$00,$28,$00
	.byte $00,$82,$00,$00,$82,$00,$00,$82
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$8A,$00,$00,$8A,$00
	.byte $00,$8A,$00,$00,$AA,$00,$00,$28
	.byte $00,$00,$28,$00,$00,$28,$00,$00
	.byte $28,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$AA,$00,$00,$82
	.byte $00,$00,$82,$00,$00,$08,$00,$00
	.byte $28,$00,$00,$80,$00,$00,$8A,$00
	.byte $00,$AA,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$80,$00,$00
	.byte $A0,$00,$00,$28,$00,$00,$0A,$00
	.byte $00,$0A,$00,$00,$28,$00,$00,$A0
	.byte $00,$00,$80,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$28,$00,$00
	.byte $28,$00,$00,$28,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$28
	.byte $00,$00,$28,$00,$00,$A0,$00,$00
	.byte $A0,$00,$00,$A0,$00,$00,$A0,$00
	.byte $00,$28,$00,$00,$28,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $28,$00,$00,$28,$00,$00,$0A,$00
	.byte $00,$0A,$00,$00,$0A,$00,$00,$0A
	.byte $00,$00,$28,$00,$00,$28,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$02,$00,$00,$02,$00,$00,$08
	.byte $00,$00,$08,$00,$00,$20,$00,$00
	.byte $20,$00,$00,$80,$00,$00,$80,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $AA,$80,$00,$AA,$80,$00,$AA,$80
	.byte $00,$AA,$80,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$02,$00,$00,$0A,$00
	.byte $00,$28,$00,$00,$A0,$00,$00,$A0
	.byte $00,$00,$28,$00,$00,$0A,$00,$00
	.byte $02,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$28,$00,$00,$28
	.byte $00,$00,$28,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$28,$00,$00,$28,$00
	.byte $00,$28,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$AA,$00,$00
	.byte $82,$00,$00,$82,$00,$00,$82,$00
	.byte $00,$8A,$00,$00,$8A,$00,$00,$8A
	.byte $00,$00,$AA,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$28,$00
	.byte $00,$28,$00,$00,$08,$00,$00,$08
	.byte $00,$00,$08,$00,$00,$08,$00,$00
	.byte $2A,$00,$00,$2A,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$AA
	.byte $00,$00,$82,$00,$00,$02,$00,$00
	.byte $AA,$00,$00,$80,$00,$00,$80,$00
	.byte $00,$8A,$00,$00,$AA,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $AA,$00,$00,$82,$00,$00,$02,$00
	.byte $00,$2A,$00,$00,$02,$00,$00,$02
	.byte $00,$00,$82,$00,$00,$AA,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$A2,$00,$00,$A2,$00,$00,$A2
	.byte $00,$00,$AA,$00,$00,$02,$00,$00
	.byte $02,$00,$00,$02,$00,$00,$02,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$AA,$00,$00,$80,$00,$00
	.byte $80,$00,$00,$AA,$00,$00,$0A,$00
	.byte $00,$0A,$00,$00,$0A,$00,$00,$AA
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$AA,$00,$00,$82,$00
	.byte $00,$80,$00,$00,$80,$00,$00,$AA
	.byte $00,$00,$8A,$00,$00,$8A,$00,$00
	.byte $AA,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$AA,$00,$00,$0A
	.byte $00,$00,$0A,$00,$00,$0A,$00,$00
	.byte $28,$00,$00,$20,$00,$00,$20,$00
	.byte $00,$20,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$2A,$00,$00
	.byte $22,$00,$00,$22,$00,$00,$AA,$00
	.byte $00,$82,$00,$00,$82,$00,$00,$82
	.byte $00,$00,$AA,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$AA,$00
	.byte $00,$82,$00,$00,$82,$00,$00,$AA
	.byte $00,$00,$0A,$00,$00,$0A,$00,$00
	.byte $0A,$00,$00,$0A,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$10,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$10,$00,$00,$10,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $10,$00,$00,$10,$00,$00,$10,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$14,$00,$00,$10,$00,$00,$10
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$15,$00,$00,$10,$00,$00
	.byte $10,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$15,$40,$00,$10,$00
	.byte $00,$10,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$01,$00,$00,$15,$40,$00,$10
	.byte $00,$00,$10,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$05,$00,$00,$15,$40,$00
	.byte $10,$00,$00,$10,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$15,$00,$00,$15,$40
	.byte $00,$10,$00,$00,$10,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$04,$00,$00,$15,$00,$00,$15
	.byte $40,$00,$10,$00,$00,$10,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$04
	.byte $00,$00,$04,$00,$00,$15,$00,$00
	.byte $15,$40,$00,$10,$00,$00,$10,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$15,$00,$00
	.byte $04,$00,$00,$04,$00,$00,$15,$00
	.byte $00,$15,$40,$00,$10,$00,$00,$10
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$04,$00,$00,$15,$00
	.byte $00,$04,$40,$00,$04,$00,$00,$15
	.byte $00,$00,$15,$40,$00,$10,$00,$00
	.byte $10,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$15
	.byte $00,$00,$44,$40,$00,$04,$00,$00
	.byte $15,$00,$00,$15,$40,$00,$10,$00
	.byte $00,$10,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$04,$00,$00
	.byte $15,$00,$00,$44,$40,$00,$04,$00
	.byte $00,$15,$00,$00,$15,$40,$00,$10
	.byte $00,$00,$10,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$04,$00,$00,$04,$00
	.byte $00,$15,$00,$00,$44,$40,$00,$04
	.byte $00,$00,$15,$00,$00,$15,$40,$00
	.byte $10,$00,$00,$10,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$14,$00,$00,$04
	.byte $00,$00,$15,$00,$00,$44,$40,$00
	.byte $04,$00,$00,$15,$00,$00,$15,$40
	.byte $00,$10,$00,$00,$10,$00,$00,$00
	.byte $00,$00,$14,$00,$00,$14,$00,$00
	.byte $04,$00,$00,$15,$00,$00,$44,$40
	.byte $00,$04,$00,$00,$15,$00,$00,$15
	.byte $40,$00,$10,$00,$00,$10,$00,$00
	.byte $04,$00,$00,$14,$00,$00,$14,$00
	.byte $00,$04,$00,$00,$15,$00,$00,$44
	.byte $40,$00,$04,$00,$00,$15,$00,$00
	.byte $15,$40,$00,$10,$00,$00,$10,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00  
