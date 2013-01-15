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
		//�ʓ���VRAM
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
		0x00, 0x00, 0x00,	/*  0:�K */
		0xff, 0x00, 0x00,	/*  1:��? */
		0x00, 0xff, 0x00,	/*  2:��? */
		0xff, 0xff, 0x00,	/*  3:���� */
		0x00, 0x00, 0xff,	/*  4:��? */
		0xff, 0x00, 0xff,	/*  5:���� */
		0x00, 0xff, 0xff,	/*  6:�󗺐F */
		0xff, 0xff, 0xff,	/*  7:�� */
		0xc6, 0xc6, 0xc6,	/*  8:���D */
		0x84, 0x00, 0x00,	/*  9:��? */
		0x00, 0x84, 0x00,	/* 10:��? */
		0x84, 0x84, 0x00,	/* 11:�É� */
		0x00, 0x00, 0x84,	/* 12:�Ð� */
		0x84, 0x00, 0x84,	/* 13:�Î� */
		0x00, 0x84, 0x84,	/* 14:���? */
		0x84, 0x84, 0x84	/* 15:�ÊD */
	};
	
	set_palette(0, 15, table_rgb);
	return;
}


void set_palette(int start, int end, unsigned char *rgb)
{
	int i, eflags;
	eflags = io_load_eflags(); // ?? ���f?��?�u �I?
	io_cli(); // ��IF(���f?�u)?�u?0, �֎~���f.
	io_out8(0x03c8, start);
	for(i = start; i <= end; i++)
	{
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);
		rgb += 3; //�O?3���ʒu
	}
	io_store_eflags(eflags); //��? ���f?��?�u
	return;
}

