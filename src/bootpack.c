void io_hlt(void);
void io_cli(void);
void io_out8(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);

void HariMain(void)
{

	int i;
	char *p;
	
	init_palette();
	
	p = (char *) 0xa0000;
	for(i = 0; i <= 0x000affff; i++)
	{
		//ŽÊ“ü“žVRAM
		p[i] = i & 0x0f;
	}
	
	for(;;)
	{
		io_hlt();
	}
}

void init_palette(void)
{
	static unsigned char table_rgb[16 * 3] = {
		0x00, 0x00, 0x00,	/*  0:üK */
		0xff, 0x00, 0x00,	/*  1:—º? */
		0x00, 0xff, 0x00,	/*  2:—º? */
		0xff, 0xff, 0x00,	/*  3:—º‰© */
		0x00, 0x00, 0xff,	/*  4:—º? */
		0xff, 0x00, 0xff,	/*  5:—ºŽ‡ */
		0x00, 0xff, 0xff,	/*  6:ó—ºF */
		0xff, 0xff, 0xff,	/*  7:”’ */
		0xc6, 0xc6, 0xc6,	/*  8:—ºŠD */
		0x84, 0x00, 0x00,	/*  9:ˆÃ? */
		0x00, 0x84, 0x00,	/* 10:ˆÃ? */
		0x84, 0x84, 0x00,	/* 11:ˆÃ‰© */
		0x00, 0x00, 0x84,	/* 12:ˆÃÂ */
		0x84, 0x00, 0x84,	/* 13:ˆÃŽ‡ */
		0x00, 0x84, 0x84,	/* 14:óˆÃ? */
		0x84, 0x84, 0x84	/* 15:ˆÃŠD */
	};
	
	set_palette(0, 15, table_rgb);
	return;
}


void set_palette(int start, int end, unsigned char *rgb)
{
	int i, eflags;
	eflags = io_load_eflags(); // ?? ’†’f?‰Â?Žu “I?
	io_cli(); // «IF(’†’f?Žu)?’u?0, ‹ÖŽ~’†’f.
	io_out8(0x03c8, start);
	for(i = start; i <= end; i++)
	{
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);
		rgb += 3; //‘O?3˜¢ˆÊ’u
	}
	io_store_eflags(eflags); //‰ø? ’†’f?‰Â?Žu
	return;
}

