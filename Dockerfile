# gtk_window.c を再現可能にビルドするための環境。
# 手元の環境に GTK / PLplot を入れなくても、この 1 枚で同じ結果が出る:
#   docker build -t algo-vis-panel . && docker run --rm algo-vis-panel
# ベースイメージとビルド依存の更新は Dependabot(docker)が拾う。
FROM debian:13-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential pkg-config libgtk-3-dev libplplot-dev plplot-driver-cairo \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .
RUN make

CMD ["./gtk_window"]
