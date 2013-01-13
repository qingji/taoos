; taoos
; tab=4

		ORG		0xc200		; 
		
		MOV		AL,0x13		; VGA显卡, 320*200*8位彩色模式
		MOV		AH,0x00		; 
		INT		0x10		; 调用显卡BIOS


fin:
	HLT
	JMP fin