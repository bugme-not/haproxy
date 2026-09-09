FROM haproxy:alpine
USER root

RUN apk add --no-cache ca-certificates wget unzip tzdata

RUN wget -O /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip /tmp/xray.zip xray -d /usr/local/bin/ && chmod +x /usr/local/bin/xray && rm -rf /tmp/xray.zip

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY config.json /etc/xray.json
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY index.html /var/www/index.html

EXPOSE 8080

CMD sh -c "xray run -c /etc/xray.json & haproxy -f /usr/local/etc/haproxy/haproxy.cfg"
