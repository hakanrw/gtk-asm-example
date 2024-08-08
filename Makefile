S_x86_64  ?= /mingw64/bin/
S_i686    ?= /mingw32/bin/
S_aarch64 ?= 

CC_x86_64  ?= $(S_x86_64)gcc "-Wl,--image-base=0x10000000"
CC_i686    ?= $(S_i686)gcc -m32 -no-pie
CC_aarch64 ?= $(S_aarch64)gcc

AS_x86_64  ?= $(S_x86_64)as
AS_i686    ?= $(S_i386)as --32
AS_aarch64 ?= $(S_aarch64)as

.PRECIOUS: obj/hello.%.o bin/libshowmessage.%.dll

default: bin/hello.x86_64.exe bin/hello.i686.exe

bin/hello.%.exe: obj/hello.%.o bin/libshowmessage.%.dll
	@mkdir -p bin
	$(eval CC = $$(CC_$*))
	$(eval S = $$(S_$*))
	export PATH=$(S); $(CC) $< -o $@ -lshowmessage.$* -Lbin -Wl,-rpath=.

obj/hello.%.o: hello.%.s
	@mkdir -p obj
	$(eval AS = $$(AS_$*))
	$(AS) $< -o $@

bin/libshowmessage.%.dll: show_message.c
	@mkdir -p bin
	$(eval CC = $$(CC_$*))
	$(eval S = $$(S_$*))
	export PATH=$(S); $(CC) -shared -o bin/libshowmessage.$*.dll -fPIC show_message.c `pkg-config --cflags --libs gtk+-3.0`

.PHONY: clean
clean:
	rm -rf bin obj
