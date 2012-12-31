default :
	tool\make.exe -r img
	
ipl.bin : src\ipl.nas Makefile
	tool\nask.exe src\ipl.nas out\ipl.bin out\ipl.lst
	
taoos.img : ipl.bin Makefile
	tool\edimg.exe imgin:tool\fdimg0at.tek \
		wbinimg src:out\ipl.bin len:512 from:0 to:0  imgout:bin\taoos.img
		

asm :
	tool\make.exe -r ipl.bin

img : 
	tool\make.exe -r taoos.img
	
run :
	tool\make.exe img
	copy bin\taoos.img tool\qemu\fdimage0.bin
	tool\make.exe -C tool\qemu
	
install :
	tool\make.exe img
	tool\imgtol.com w a: bin\taoos.img
	
clean :
	-del out\*
	-del bin\*