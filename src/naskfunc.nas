; naskfunc
; TAB=4

[FORMAT "WCOFF"]		;制作目标文件的模式
[BITS 32]				;制作32位模式用的机器语言
[INSTRSET "i486p"]  	; 指定CPU模式为486

;制作目标文件的信息
[FILE "naskfunc.nas"]

		GLOBAL _io_hlt,_write_mem8
		
;以下是实际的函数
[SECTION .text]		;目标文件中写了这些之后再写程序

_io_hlt:		;void io_hlt(void);
		HLT
		RET
		
_write_mem8:	;void write_mem8(int addr, int data);
		MOV		ECX,[ESP+4]		;[ESP+4]中存放的是地址, 将其读入ECX
		MOV		AL,[ESP+8]		;[ESP+8]中存放的是数据, 将其读入AL
		MOV		[ECX],AL
		RET
