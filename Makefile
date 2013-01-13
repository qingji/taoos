TOOL_PATH = tool/
SRC_PATH = src/
OUT_PATH = out/
BIN_PATH = bin/

MAKE 	 = $(TOOL_PATH)make.exe -r
NASK     = $(TOOL_PATH)nask.exe
EDIMG    = $(TOOL_PATH)edimg.exe
IMGTOL   = $(TOOL_PATH)imgtol.com
COPY     = copy
DEL      = del

default :
	$(MAKE) -r img
	
ipl.bin : src\ipl.nas Makefile clean
	$(NASK) src\ipl.nas out\ipl.bin out\ipl.lst

taoos.sys : src\taoos.nas Makefile
	$(NASK) src\taoos.nas out\taoos.sys  out\taoos.lst
	
taoos.img : ipl.bin taoos.sys Makefile
	$(EDIMG) imgin:$(TOOL_PATH)fdimg0at.tek \
		wbinimg src:$(OUT_PATH)ipl.bin len:512 from:0 to:0  \
		copy from:out/taoos.sys to:@: \
		imgout:$(BIN_PATH)taoos.img

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
	-$(DEL) out\ipl.bin
	-$(DEL) out\ipl.lst
	
	-$(DEL) bin\taoos.img