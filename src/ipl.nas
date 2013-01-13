;TAOOS-IPL
;TAB=4
CYLS	EQU	10 ;10个柱面

	ORG		0x7c00		;指明程序的装载地址

; 以下的记述用于标准的FAT12格式软盘

	JMP		entry
	DB		0x90
	DB		"TaoOSIPL"	; 启动区名字可以是任意的字符串(8字节)
	DW		512	; 每个扇区(sector)
	DB		1	; 簇(cluster)的大小(必须为1个扇区)
	DW		1	; FAT的起始位置(一般从第一个扇区开始)
	DB		2	; FAT的个数(必须为2)
	DW		224	; 根目录的大小(一般设置成224)
	DW		2880	; 该磁盘的大小(必须是2880扇区)
	DB		0xf0	; 磁盘的种类(必须是0xf0)
	DW		9	; FAT的长度(必须是9扇区)
	DW		18	; 1个磁道(track)有几个扇区(必须是18)
	DW		2	; 磁头数(必须是2)
	DD		0	; 不使用分区，必须是0
	DD		2880	; 重写一次磁盘大小
	DB		0, 0, 0x29	; 意义不明,固定
	DD      0xffffffff	; (可能是)卷标号码
    DB		"DISK-TAOOS "	; 磁盘名称(11字节)
	DB      "FAT12   "	; 磁盘格式名称(8字节)
    RESB    18	; 先空出18字节
    


	
; 程序主体
entry:
	MOV		AX,0			;初始化寄存器
	MOV		SS,AX
	MOV		SP,0x7c00
	MOV		DS,AX			;DS是默认的段寄存器, 在使用时,需指定值. 

;读盘．具体请参考API--INT 0x13 :磁盘BIOS
	; 将操作系统加载到0x0820处, 
	MOV		AX,0x0820 ;为什么是0x0820? 没有为什么, 仅仅是这块地方没有被利用.
	MOV		ES,AX	; EX *16 + BX
	
	; 设定待读取的数据在磁盘的位置
	MOV		DH,0	; 磁头0
	MOV		CH,0	; 柱面0
	MOV		CL,2	; 扇区2

read_loop:
	MOV		SI,0	; 初始化, 用于记录失败次数
	
retry
	MOV		BX,0	; 缓冲区地址
	MOV		DL,0x00	; 驱动器号
	; 设定操作方式
	MOV		AL,1	; 只能连续处理1个扇区
	MOV		AH,0x02	; 设定为读盘
	INT		0x13	; 调用磁盘BIOS
	; 检验是否读盘成功, 是就进入 fin
	JNC		read_next	; jump if not carry (if FLAGS.CF==0 就跳转), 反之有JC
	
	ADD		SI, 1
	CMP		SI, 5
	JAE		disk_read_error ; if(FLAGS.CF>=5) goto disk_read_error. (JAE: jump if above or equal, 大于或等于时跳转)
	;继续尝试
	MOV		AH, 0x00 ; 重置
	MOV		DL, 0x00 ; 指定驱动器为A
	INT		0x13 ;重置驱动器
	JMP		retry

read_next:
	;把内存地址往后移0x200
	MOV		AX,ES			
	ADD		AX,0x0020
	MOV		ES,AX			;ES 不能直接ADD, 所以用AX来做
	ADD		CL,1			;往后推一个扇区.
	CMP		CL,18			;是否到18扇区?
	JBE		read_loop		; if CL<= 18 跳转至readloop. (JBE: jump if below or equal, 小于等于就跳转)
	; 如果扇区大于18,就继续读下一个柱面
	MOV		CL,1
	ADD		DH,1	;切换到反面磁头
	CMP		DH,2
	JB		read_loop ;		
	MOV		DH,0	;切换到正面磁头
	ADD		CH,1	;切换到下一个扇区
	CMP		CH,CYLS	;是否到CYLS扇区?
	JB		read_loop		;CH < CYLS
	
fin:
	HLT		
	JMP		fin

disk_read_error:
	MOV		SI,error_msg	
	
putloop:
	MOV		AL,[SI]			; INT10时，将会显示AL中的数据
	ADD		SI,1			; 
	CMP		AL,0			; if(AL == 0)
	JE		fin				; then goto fin
	MOV		AH,0x0e			; 显示一个文字
	MOV		BX,15			; 指定字符颜色
	INT		0x10			; 调用显卡BIOS
	JMP		putloop



	
error_msg:
	DB		0x0a,0x0a
	DB		"load error"
	DB		0x0a
	DB		0
	
	RESB	0x7dfe-$		;

	DB		0x55, 0xaa
