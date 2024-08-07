S_x86_64  ?= 
S_i686    ?= 
S_aarch64 ?= aarch64-none-linux-gnu-
S_riscv64 ?= riscv64-none-linux-gnu-

CC_x86_64  ?= $(S_x86_64)gcc
CC_i686    ?= $(S_i386)gcc -m32
CC_aarch64 ?= $(S_aarch64)gcc
CC_riscv64 ?= $(S_riscv64)gcc

AS_x86_64  ?= $(S_x86_64)as
AS_i686    ?= $(S_i386)as --32
AS_aarch64 ?= $(S_aarch64)as
AS_riscv64 ?= $(S_riscv64)as

.PRECIOUS: obj/hello.%.o bin/libshowmessage.%.so

default: bin/hello.x86_64 bin/hello.i686 bin/hello.aarch64 bin/hello.riscv64

bin/hello.%: obj/hello.%.o bin/libshowmessage.%.so
	@mkdir -p bin
	$(eval CC = $$(CC_$*))
	$(CC) $< -o $@ -lc -lshowmessage.$* -Lbin -Wl,-rpath=.

obj/hello.%.o: hello.%.s
	@mkdir -p obj
	$(eval AS = $$(AS_$*))
	$(AS) $< -o $@

bin/libshowmessage.%.so: show_message.c
	@mkdir -p bin
	$(eval CC = $$(CC_$*))
	$(CC) -shared -o bin/libshowmessage.$*.so -fPIC show_message.c `pkg-config --cflags --libs gtk+-3.0`

.PHONY: clean
clean:
	rm -rf bin obj
