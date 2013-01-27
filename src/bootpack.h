
/* 
 *==================================================================
 * asmhead.nas
 *==================================================================
 */
struct BOOTINFO { /* 0x0ff0 ~ 0x0fff*/
	char cyls; /// 启动区度硬盘读到何处为止
	char leds; /// 启动时键盘LED的状态
	char vmode; /// 显卡模式为多少位色彩
	char reserve; ///
	short scrnx, scrny; /// 画面分辨率
	char *vram; ///
};
#define ADR_BOOTINFO	0x00000ff0 //BOOTINFO起始位置

/* 
 *==================================================================
 * naskfunc.nas
 *==================================================================
 */
 
/**
 * 
 */
void io_hlt(void);

/**
 * 
 */
void io_cli(void);

/**
 * 
 */
void io_out8(int port, int data);

/**
 * 
 */
int io_load_eflags(void);

/**
 * 
 */
void io_store_eflags(int eflags);

/* 
 *==================================================================
 * graphic.c 
 *==================================================================
 */
/**
 * 初始化调色板
 */
void init_palette(void);

/**
 * 设置调色板
 * 
 * @start - 
 * @end - 
 * @unsigned - 
 * @rgb - 
 */
void set_palette(int start, int end, unsigned char *rgb);

/**
 *
 *
 *
 * @vram - 
 * @xsize - 
 * @c - 
 * @x0 - 
 * @y0 - 
 * @x1 - 
 * @y1 - 
 */
void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1);

/**
 *
 * 
 * @vram - 
 * @x - 
 * @y - 
 */
void init_screen8(char *vram, int x, int y);

/**
 *
 *
 * @varm - 
 * @xsize - 
 * @x - 
 * @y - 
 * @c - 
 * @font - 
 */
void putfont8(char *vram, int xsize, int x, int y, char c, char *font);

/**
 *
 *
 * @vram
 * @xsize
 * @x
 * @y
 * @c
 * @s
 */
void putfonts8_asc(char *vram, int xsize, int x, int y, char c, unsigned char *s);

/**
 *
 *
 * @mouse
 * @bc
 */
void init_mouse_cursor8(char *mouse, char bc);

/**
 *
 *
 * @vram
 * @vxsize
 * @pxsize
 * @pysize
 * @px0
 * @buf
 * @bxsize
 */
void putblock8_8(char *vram, int vxsize, int pxsize,
	int pysize, int px0, int py0, char *buf, int bxsize);

/* 调色板*/	
#define COL8_000000		0	///黑 		0x00, 0x00, 0x00, 
#define COL8_FF0000		1	///亮红 	0xff, 0x00, 0x00,	  
#define COL8_00FF00		2	///亮绿		0x00, 0xff, 0x00,	  
#define COL8_FFFF00		3	///亮黄		0xff, 0xff, 0x00,	
#define COL8_0000FF		4	///亮蓝		0x00, 0x00, 0xff,	 
#define COL8_FF00FF		5	///亮紫		0xff, 0x00, 0xff,	  
#define COL8_00FFFF		6	///浅亮色	0x00, 0xff, 0xff,	  
#define COL8_FFFFFF		7	///白		0xff, 0xff, 0xff,	  
#define COL8_C6C6C6		8	///亮灰		0xc6, 0xc6, 0xc6,	  
#define COL8_840000		9	///暗红		0x84, 0x00, 0x00,	  
#define COL8_008400		10	///暗绿		0x00, 0x84, 0x00,	 
#define COL8_848400		11	///暗黄		0x84, 0x84, 0x00,	 
#define COL8_000084		12	///暗青		0x00, 0x00, 0x84,	 
#define COL8_840084		13	///暗紫		0x84, 0x00, 0x84,	 
#define COL8_008484		14	///浅暗蓝	0x00, 0x84, 0x84,	 
#define COL8_848484		15	///暗灰		0x84, 0x84, 0x84	 


/* 
 *==================================================================
 * dsctbl.c 
 *==================================================================
 */
struct SEGMENT_DESCRIPTOR {
	short limit_low; ///
	short base_low;
	char base_mid;
	char access_right;
	char limit_high;
	char base_high;
};

struct GATE_DESCRIPTOR {
	short offset_low; 
	short selector;
	char dw_count;
	char access_right;
	short offset_high;
};

/**
 * 初始化GDT,IDT
 */
void init_gdtidt(void);

/**
 * 设置GDT
 *
 * params:
 * @sd - gdt地址指针
 * @limit - GDT管理的内存上限.
 * @base - GDT的初始位置
 * @ar - 段属性
 */
void set_segmdesc(struct SEGMENT_DESCRIPTOR *sd, unsigned int limit, int base, int ar);

/**
 * 设置LDT
 *
 * params:
 * @gd - gdt地址指针
 * @offset - GDT管理的内存上限.
 * @selector - GDT的初始位置
 * @ar - 段属性
 */
void set_gatedesc(struct GATE_DESCRIPTOR *gd, int offset, int selector, int ar);

#define ADR_IDT			0x0026f800  /// IDT起始位置
#define LIMIT_IDT		0x000007ff  /// IDT的大小
#define ADR_GDT			0x00270000  /// GDT的起始位置, 使用0x00270000没有特殊意义, 仅仅是这块内存没人使用.
#define LIMIT_GDT		0x0000ffff  /// GDT的大小
#define ADR_BOTPAK		0x00280000  /// BOOTPARK的起始位置
#define LIMIT_BOTPAK	0x0007ffff	/// BOOTPARK的大小
#define AR_DATA32_RW	0x4092		/// 
#define AR_CODE32_ER	0x409a		/// 
