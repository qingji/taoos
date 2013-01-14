void io_hlt(void);
void write_mem8(int addr, int data);

void HariMain(void)
{

	int i;
	
	for(i = 0x000a0000; i <= 0x000affff; i++)
	{
		//ŽÊ“ü“žVRAM
		write_mem8(i, i & 0x0f); 
	}
	
	for(;;)
	{
		io_hlt();
	}
}
