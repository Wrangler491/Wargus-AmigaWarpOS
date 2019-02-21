
CC = gcc

CROSSDIR = /usr/local/cross
STRATAGUSPATH = ../stratagus/

CFLAGS = -specs=warpup -O2 -mcpu=750 -mmultiple -I/gg/os-include
LDFLAGS = -specs=warpup -O2 -mcpu=750 -mmultiple -lz -lpng12 -lm -static -L/gg/ppc-amigaos/newlib/lib

all: cleanobj wartool$(EXE)

wartool$(EXE): wartool.o
	$(CC) -o $@ $^ $(LDFLAGS)

wartool.o:
	$(CC) -c wartool.c -o $@ $(CFLAGS)

win32:
	export PATH=$(CROSSDIR)/bin:$(CROSSDIR)/i386-mingw32msvc/bin:$$PATH; \
	export EXE=.exe; \
	$(MAKE) $(WIN32)

cleanobj:
	rm -f wartool.o

clean:
	rm -rf wartool wartool.exe wartool.o data.wc2 wargus-* wargus

strip:
	strip wartool
#	strip wartool.exe

date = $(shell date +%y%m%d)
ver = 2.1pre2

release: release-src release-linux

release-src: clean cleanobj
	echo `find Makefile build.* contrib campaigns wartool.c wartool.ds* scripts maps | grep -v 'CVS' | grep -v '/\.'` > .list
	mkdir wargus-$(ver); \
	for i in `cat .list`; do echo $$i; done | cpio -pdml --quiet wargus-$(ver);\
	rm -rf `find wargus-$(ver) | grep -i cvs`; \
	tar -zcf wargus-$(ver)-src.tar.gz wargus-$(ver); \
	zip -qr wargus-$(ver)-src.zip wargus-$(ver); \
	rm -rf wargus-$(ver) .list;

release-linux: clean wartool strip cleanobj
	pwd
	echo `find Makefile build.sh contrib campaigns wartool scripts maps stratagus | grep -v 'CVS' | grep -v '/\.'` > .list
	mkdir wargus-$(ver); \
	for i in `cat .list`; do echo $$i; done | cpio -pdml --quiet wargus-$(ver);\
	rm -rf `find wargus-$(ver) | grep -i cvs`; \
	tar -zcf wargus-$(ver)-linux.tar.gz wargus-$(ver); \
	rm -rf wargus-$(ver) .list stratagus;
