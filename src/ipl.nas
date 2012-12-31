;TAOOS-IPL
;TAB=4
	 ORG		0x7c00		;指明程序的装载地址

; 以下的记述用于标准的FAT12格式软盘
	JMP		entry
	DB		0x90
	DB		"TaoOSIPL"		; 启动区名字可以是任意的字符串(8字节)
	DW		512				; 每个扇区(sector)
	DB		1				; 簇(cluster)的大小(必须为1个扇区)
	DW		1				; FAT的起始位置(一般从第一个扇区开始)
	DB		2				; FAT的个数(必须为2)
	DW		224				; 根目录的大小(一般设置成224)
	DW		2880			; 该磁盘的大小(必须是2880扇区)
	DB		0xf0			; 磁盘的种类(必须是0xf0)
	DW		9				; FAT的长度(必须是9扇区)
	DW		18				; 1个磁道(track)有几个扇区(必须是18)
	DW		2				; 磁头数(必须是2)
	DD		0				; 不使用分区，必须是0
	DD		2880			; 重写一次磁盘大小
	DB		0, 0, 0x29		; 意义不明,固定
	DD      0xffffffff      ; (可能是)卷标号码
    DB		"DISK-TAOOS "	; 磁盘名称(11字节)
	DB      "FAT12   "      ; 磁盘格式名称(8字节)
    RESB    18              ; 先空出18字节
    

; 程序主体
entry:
	MOV		AX,0			;初始化寄存器
	MOV		SS,AX
	MOV		SP,0x7c00
	MOV		DS,AX
	MOV		ES,AX
	
	MOV		SI,msg

putloop:
	MOV		AL,[SI]			; INT10时，将会显示AL中的数据
	ADD		SI,1			; 
	CMP		AL,0			; if(AL == 0)
	JE		fin				; then goto fin
	MOV		AH,0x0e			; 显示一个文字
	MOV		BX,15			; 指定字符颜色
	INT		0x10			; 调用显卡BIOS
	JMP		putloop
	
fin:
	HLT		
	JMP		fin
	
msg:
	DB		0x0a,0x0a
	DB		"hello Taoos"
	DB		0x0a
	DB		0
	
	RESB	0x7dfe-$		;

	DB		0x55, 0xaa
