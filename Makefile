OBJ = progress
CFLAGS ?= -g
override CFLAGS += -Wall -D_FILE_OFFSET_BITS=64
override LDFLAGS += -lm
ARCH := $(shell uname -m)
PKG_CONFIG ?= pkg-config

ifeq ($(ARCH),armv5tel)
	PREFIX := /ffp
	override LDFLAGS += $(shell $(PKG_CONFIG) ncursesw --libs)
	override CFLAGS += $(shell $(PKG_CONFIG) ncurses --cflags)
else ifeq ($(ARCH),aarch64)
	PREFIX := /data/data/com.termux/files/usr
	override LDFLAGS += $(shell $(PKG_CONFIG) ncursesw --libs)
	override CFLAGS += $(shell $(PKG_CONFIG) ncurses --cflags)
endif

BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1
BASHDIR = $(PREFIX)/etc/bash_completion.d

$(OBJ) : progress.o sizes.o hlist.o
	$(CC) -Wall $^ -o $@ $(LDFLAGS) -lc
%.o : %.c
	$(CC) $(CFLAGS) -lc -c $^
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
	@echo "Installing bash completion to $(DESTDIR)$(BASHDIR) ..."
	@mkdir -p $(DESTDIR)$(BASHDIR)
	@install -Dpm0644 $(OBJ).bash -t $(DESTDIR)$(BASHDIR)/ || \
	echo "Failed. Try "make PREFIX=~ install" ?"
uninstall :
	@rm -f $(DESTDIR)$(BINDIR)/$(OBJ)
	@rm -f $(DESTDIR)$(MANDIR)/$(OBJ).1.gz
	@rm -f $(DESTDIR)$(BASHDIR)/$(OBJ).bash
