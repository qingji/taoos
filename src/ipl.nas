;TAOOS-IPL
;TAB=4
	 ORG		0x7c00		;ָ�������װ�ص�ַ

; ���µļ������ڱ�׼��FAT12��ʽ����
	JMP		entry
	DB		0x90
	DB		"TaoOSIPL"		; ���������ֿ�����������ַ���(8�ֽ�)
	DW		512				; ÿ������(sector)
	DB		1				; ��(cluster)�Ĵ�С(����Ϊ1������)
	DW		1				; FAT����ʼλ��(һ��ӵ�һ��������ʼ)
	DB		2				; FAT�ĸ���(����Ϊ2)
	DW		224				; ��Ŀ¼�Ĵ�С(һ�����ó�224)
	DW		2880			; �ô��̵Ĵ�С(������2880����)
	DB		0xf0			; ���̵�����(������0xf0)
	DW		9				; FAT�ĳ���(������9����)
	DW		18				; 1���ŵ�(track)�м�������(������18)
	DW		2				; ��ͷ��(������2)
	DD		0				; ��ʹ�÷�����������0
	DD		2880			; ��дһ�δ��̴�С
	DB		0, 0, 0x29		; ���岻��,�̶�
	DD      0xffffffff      ; (������)������
    DB		"DISK-TAOOS "	; ��������(11�ֽ�)
	DB      "FAT12   "      ; ���̸�ʽ����(8�ֽ�)
    RESB    18              ; �ȿճ�18�ֽ�
    

; ��������
entry:
	MOV		AX,0			;��ʼ���Ĵ���
	MOV		SS,AX
	MOV		SP,0x7c00
	MOV		DS,AX
	MOV		ES,AX
	
	MOV		SI,msg

putloop:
	MOV		AL,[SI]			; INT10ʱ��������ʾAL�е�����
	ADD		SI,1			; 
	CMP		AL,0			; if(AL == 0)
	JE		fin				; then goto fin
	MOV		AH,0x0e			; ��ʾһ������
	MOV		BX,15			; ָ���ַ���ɫ
	INT		0x10			; �����Կ�BIOS
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
