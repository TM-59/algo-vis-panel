# gtk_window.c を再現可能にビルドするための環境。
# 手元の環境に GTK / PLplot を入れなくても、この 1 枚で同じ結果が出る:
#   docker build -t algo-vis-panel . && docker run --rm algo-vis-panel
# ベースイメージとビルド依存の更新は Dependabot(docker)が拾う。
FROM debian:13-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential=12.12 pkg-config=1.8.1-4 libgtk-3-dev=3.24.49-3 \
        libplplot-dev=5.15.0+dfsg2-15+b1 plplot-driver-cairo=5.15.0+dfsg2-15+b1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .
RUN make

CMD ["./gtk_window"]
