; naskfunc
; TAB=4

[FORMAT "WCOFF"]		;制作目标文件的模式
[BITS 32]				;制作32位模式用的机器语言


;制作目标文件的信息
[FILE "naskfunc.nas"]

		GLOBAL _io_hlt
		
;以下是实际的函数
[SECTION .text]		;目标文件中写了这些之后再写程序

_io_hlt:		;void io_hlt(void);
		HLT
		RET
		