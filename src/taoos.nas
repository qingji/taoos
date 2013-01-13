; taoos
; tab=4

;有关BIOS_INFO
CYLS	EQU		0x00f0		; 设定启动区
LEDS	EQU		0x00f1
VMODE	EQU		0x00f2		; 关于颜色数目的信息,颜色的位数
SCRANX	EQU		0x00f4		; 分辨率的X(screen x)
SCRANY	EQU		0x00f6		; 分辨率的Y(screen y)
VRAM	EQU		0x00f8		; 图像缓冲区的开始地址


		ORG		0xc200		; 
		
		MOV		AL,0x13		; VGA显卡, 320*200*8位彩色模式
		MOV		AH,0x00		; 
		INT		0x10		; 调用显卡BIOS
		
		MOV		BYTE [VMODE],8 ; 记录画面模式
		MOV		WORD [SCRANX],320
		MOV		WORD [SCRANY],200
		MOV		DWORD [VRAM],0x000a0000
		
; 用BIOS取得键盘上各种LED指示灯的状态
		MOV		AH,0x02
		INT		0x16		;keyboard BIOS
		MOV		[LEDS],AL


fin:
	HLT
	JMP fin