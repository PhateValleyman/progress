OBJ = progress
CFLAGS ?= -g
override CFLAGS += -Wall -D_FILE_OFFSET_BITS=64
override LDFLAGS += -lm
ARCH := $(shell uname -m)
UNAME := $(shell uname)
PKG_CONFIG ?= pkg-config

BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1
ZSHDIR = $(PREFIX)/share/zsh/site-functions

ifeq ($(ARCH),armv5tel)
    PREFIX := /ffp
    override LDFLAGS += $(shell $(PKG_CONFIG) ncursesw --libs)
    override CFLAGS += $(shell $(PKG_CONFIG) ncurses --cflags)
else ifeq ($(ARCH),aarch64)
    PREFIX := /data/data/com.termux/files/usr
    override LDFLAGS += $(shell $(PKG_CONFIG) ncursesw --libs)
    override CFLAGS += $(shell $(PKG_CONFIG) ncurses --cflags)
endif

$(OBJ) : progress.o sizes.o hlist.o
	$(CC) -Wall $^ -o $@ $(LDFLAGS)

%.o : %.c
	$(CC) $(CFLAGS) -c $^

clean :
	rm -f *.o $(OBJ)

install : $(OBJ)
	@echo "Installing program to $(DESTDIR)$(BINDIR) ..."
	@mkdir -p $(DESTDIR)$(BINDIR)
	@install -pm0755 $(OBJ) $(DESTDIR)$(BINDIR)/$(TARGET) || \
	echo "Failed. Try "make PREFIX=~ install" ?"
	@echo "Installing manpage to $(DESTDIR)$(MANDIR) ..."
	@mkdir -p $(DESTDIR)$(MANDIR)
	@install -pm0644 $(OBJ).1.gz $(DESTDIR)$(MANDIR)/ || \
	echo "Failed. Try "make PREFIX=~ install" ?"
	@echo "Installing zsh completion to $(DESTDIR)$(ZSHDIR) ..."
	@install -Dpm0644 _$(OBJ) -t $(DESTDIR)$(ZSHDIR)/ || \
	echo "Failed. Try "make PREFIX=~ install" ?"

uninstall :
	@rm -f $(DESTDIR)$(BINDIR)/$(OBJ)
	@rm -f $(DESTDIR)$(MANDIR)/$(OBJ).1.gz
	@rm -f $(DESTDIR)$(ZSHDIR)/_$(OBJ)
