/* GDT和IDT相关 */

#include "bootpack.h"
 
/*
 *  
 */ 
void init_gdtidt(void)
{
	struct SEGMENT_DESCRIPTOR *gdt = (struct SEGMENT_DESCRIPTOR *) ADR_GDT;
	struct GATE_DESCRIPTOR *idt = (struct GATE_DESCRIPTOR *)ADR_IDT;
	int i;
	//init GDT
	for(i = 0; i < 8192; i++) {
		set_segmdesc(gdt + i, 0, 0, 0);
	}
	set_segmdesc(gdt + 1, 0xffffffff, 0x00000000, AR_DATA32_RW);//上限为4GB (0xffffffff)
	set_segmdesc(gdt + 1, LIMIT_BOTPAK, ADR_BOTPAK, AR_CODE32_ER);//BOOTPACK的上限为512KB 
	load_gdtr(LIMIT_GDT, ADR_GDT); //调用汇编函数, 给GDT赋值
	
	//init IDT
	for(i = 0; i < 256; i++){
		set_gatedesc(idt + i, 0, 0, 0);
	}
	load_gdtr(LIMIT_IDT, ADR_IDT);//调用汇编函数, 给LDT赋值
	
	return;
}


void set_segmdesc(struct SEGMENT_DESCRIPTOR *sd, unsigned int limit, int base, int ar)
{
	if(limit > 0xfffff){
		ar |= 0x8000;//G_bit = 1
		limit /= 0x1000;
	}
	sd->limit_low = limit & 0xffff;
	sd->base_low =  base & 0xffff;
	sd->base_mid = (base >> 16) & 0xff;
	sd->access_right = ar &0xff;
	sd->limit_high = ((limit >> 16)& 0x0f) |((ar >> 8) &0xf0);
	sd->base_high = (base >> 24) & 0xff;
	return;
	
}

void set_gatedesc(struct GATE_DESCRIPTOR *gd, int offset, int selector, int ar)
{
	gd->offset_low = offset & 0xffff;
	gd->selector = selector;
	gd->dw_count = (ar >> 8) & 0xff;
	gd->access_right = ar & 0xff;
	gd->offset_high = (offset >> 16) & 0xffff;
	return;
}
