FROM easypi/shadowsocks-libev

EXPOSE 1920 1921

RUN set -ex && \
    apk --update add --no-cache curl privoxy && \
    echo 'forward-socks5  /       127.0.0.1:1920  .' >> /etc/privoxy/config && \
    sed -i'' 's/127\.0\.0\.1:8118/0\.0\.0\.0:1921/' /etc/privoxy/config && \
    mkdir -p /etc/shadowsocks-libev

HEALTHCHECK --interval=10s --timeout=5s --retries=10 CMD curl -x http://127.0.0.1:1921 https://www.google.com/ncr || exit 1

CMD privoxy /etc/privoxy/config && ss-local -b 0.0.0.0 -u -c /etc/shadowsocks-libev/config.json

