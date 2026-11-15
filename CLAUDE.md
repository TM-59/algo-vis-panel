`npm ci`、LLVM 23.1.5、dockerfmt 1.0.0、hadolint 2.15.1、GTK 3・PLplot・ncurses の開発用パッケージが必要。
`make fmt` で整形し、`make check-style` と `make check` で検査する。

追跡済み生成物 `gtk_window`: `make` で再生成。
追跡済み生成物 `panel`: `cc panel.c -o panel -lncurses -lpanel` で再生成。
追跡済み生成物 `sample`: `cc sample.c -o sample` で再生成。
