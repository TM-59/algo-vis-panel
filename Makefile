# gtk_window.c のビルド。pkg-config で GTK と PLplot の在り処を引く。
CC      ?= cc
CFLAGS  ?= -O2 -Wall -Wextra
PKGS    := gtk+-3.0 plplot
CFLAGS  += $(shell pkg-config --cflags $(PKGS))
LDLIBS  += $(shell pkg-config --libs $(PKGS)) -lm

.PHONY: all clean check fmt lint typecheck check-style check-tool-versions
all: gtk_window

gtk_window: gtk_window.c
	$(CC) $(CFLAGS) -o $@ $< $(LDLIBS)

# 画面を開かずに通せる検査(CI は置かない方針なので手元で使う)
check:
	$(CC) $(CFLAGS) -fsyntax-only gtk_window.c

clean:
	rm -f gtk_window

CLANG_FORMAT ?= clang-format
CLANG_TIDY ?= clang-tidy
STYLE_CC ?= clang
DOCKERFMT ?= dockerfmt
HADOLINT ?= hadolint
STYLE_FLAGS ?=
PRETTIER := ./node_modules/.bin/prettier
SOURCES := $(shell git ls-files '*.c')
DOCS := $(shell git ls-files '*.md' '*.json' '*.yaml' '*.yml')

check-tool-versions:
	$(CLANG_FORMAT) --version | grep -Eq '(^| )23\.1\.5($$| )'
	$(CLANG_TIDY) --version | grep -Eq '(^| )23\.1\.5($$| )'
	$(STYLE_CC) --version | grep -Eq '(^| )23\.1\.5($$| )'
	$(DOCKERFMT) version | grep -Eq '(^| )v?1\.0\.0($$| )'
	$(HADOLINT) --version | grep -Eq '(^| )2\.15\.1($$| )'
	test "$$($(PRETTIER) --version)" = 3.10.1

fmt: check-tool-versions
	$(CLANG_FORMAT) -i $(SOURCES)
	$(DOCKERFMT) --write Dockerfile
	$(PRETTIER) --write $(DOCS) package.json

lint: check-tool-versions
	$(CLANG_FORMAT) --dry-run --Werror $(SOURCES)
	$(DOCKERFMT) --check Dockerfile
	$(HADOLINT) --failure-threshold warning Dockerfile
	$(PRETTIER) --check $(DOCS) package.json
	$(CLANG_TIDY) gtk_window.c --warnings-as-errors='*' -- -std=c17 -Wall -Wextra -Werror $(STYLE_FLAGS) $(shell pkg-config --cflags $(PKGS))
	$(CLANG_TIDY) panel.c sample.c --warnings-as-errors='*' -- -std=c17 -Wall -Wextra -Werror $(STYLE_FLAGS)

typecheck: check-tool-versions
	$(STYLE_CC) -std=c17 -Wall -Wextra -Werror $(STYLE_FLAGS) -fsyntax-only gtk_window.c $(shell pkg-config --cflags $(PKGS))
	$(STYLE_CC) -std=c17 -Wall -Wextra -Werror $(STYLE_FLAGS) -fsyntax-only panel.c sample.c

check-style: lint typecheck
