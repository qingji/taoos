OBJS_BOOTPACK = bootpack.obj naskfunc.obj hankaku.obj graphic.obj dsctbl.obj
OUT_OBJS_BOOTPACK = out\bootpack.obj out\naskfunc.obj out\hankaku.obj out\graphic.obj out\dsctbl.obj

TOOL_PATH = tool/
SRC_PATH = src/
OUT_PATH = out/
BIN_PATH = bin/
INCPATH = res/

MAKE 	 = $(TOOL_PATH)make.exe -r
NASK     = $(TOOL_PATH)nask.exe
CC1      = $(TOOLPATH)cc1.exe -I$(INCPATH) -Os -Wall -quiet
GAS2NASK = $(TOOLPATH)gas2nask.exe -a
OBJ2BIM  = $(TOOLPATH)obj2bim.exe
MAKEFONT = $(TOOLPATH)makefont.exe
BIN2OBJ  = $(TOOLPATH)bin2obj.exe
BIM2HRB  = $(TOOLPATH)bim2hrb.exe
RULEFILE = res/taoos.rul
EDIMG    = $(TOOL_PATH)edimg.exe
IMGTOL   = $(TOOL_PATH)imgtol.com
COPY     = copy
DEL      = del


#====================================
#默认操作
#====================================
default :
	$(MAKE) -r img

#====================================
#编译生成
#====================================
ipl10.bin : src\ipl10.nas Makefile
	$(NASK) src\ipl10.nas out\ipl10.bin out\ipl10.lst

asmhead.bin : src\asmhead.nas Makefile
	$(NASK) src\asmhead.nas out\asmhead.bin out\asmhead.lst	
	
hankaku.bin : res\hankaku.txt Makefile
	$(MAKEFONT) res\hankaku.txt out\hankaku.bin
	
hankaku.obj : hankaku.bin Makefile
	$(BIN2OBJ) out\hankaku.bin out\hankaku.obj _hankaku

naskfunc.obj : src\naskfunc.nas Makefile
	$(NASK) src\naskfunc.nas out\naskfunc.obj out\naskfunc.lst
	
bootpack.bim : $(OBJS_BOOTPACK) Makefile
	$(OBJ2BIM) @$(RULEFILE) out:out\bootpack.bim stack:3136k map:out\bootpack.map \
		$(OUT_OBJS_BOOTPACK)
# 3MB+64K=3136KB		

bootpack.hrb : bootpack.bim Makefile
	$(BIM2HRB) out\bootpack.bim out\bootpack.hrb 0


taoos.sys : asmhead.bin bootpack.hrb Makefile
	copy /B out\asmhead.bin+out\bootpack.hrb out\taoos.sys
	
taoos.img : ipl10.bin taoos.sys Makefile
	$(EDIMG) imgin:$(TOOL_PATH)fdimg0at.tek \
		wbinimg src:$(OUT_PATH)ipl10.bin len:512 from:0 to:0  \
		copy from:out/taoos.sys to:@: \
		imgout:$(BIN_PATH)taoos.img

#====================================
# 规则
#====================================
%.gas : src\%.c Makefile
	$(CC1) -o out\$*.gas src\$*.c	

%.nas : %.gas Makefile
	$(GAS2NASK) out\$*.gas out\$*.nas

%.obj : %.nas Makefile
	$(NASK) out\$*.nas out\$*.obj out\$*.lst		
		
		
#====================================
#命令
#====================================		
img : 
	$(MAKE) taoos.img
	
run : taoos.img 
	$(MAKE) img
	$(COPY) bin\taoos.img tool\qemu\fdimage0.bin
	$(MAKE) -C $(TOOL_PATH)qemu
	
install :
	$(MAKE) img
	$(IMGTOL) w a: $(BIN_PATH)taoos.img
	
clean :
	-$(DEL) out\*.bin
	
	-$(DEL) out\*.lst
	-$(DEL) out\*.gas
	-$(DEL) out\*.obj
	-$(DEL) out\*.nas
	-$(DEL) out\bootpack.map
	-$(DEL) out\bootpack.bim
	-$(DEL) out\bootpack.hrb
	-$(DEL) out\taoos.sys	
	
	-$(DEL) bin\taoos.img