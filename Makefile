# gtk_window.c のビルド。pkg-config で GTK と PLplot の在り処を引く。
CC      ?= cc
CFLAGS  ?= -O2 -Wall -Wextra
PKGS    := gtk+-3.0 plplot
CFLAGS  += $(shell pkg-config --cflags $(PKGS))
LDLIBS  += $(shell pkg-config --libs $(PKGS)) -lm

.PHONY: all clean check
all: gtk_window

gtk_window: gtk_window.c
	$(CC) $(CFLAGS) -o $@ $< $(LDLIBS)

# 画面を開かずに通せる検査(CI は置かない方針なので手元で使う)
check:
	$(CC) $(CFLAGS) -fsyntax-only gtk_window.c

clean:
	rm -f gtk_window
