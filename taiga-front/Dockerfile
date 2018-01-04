FROM ubuntu:xenial

RUN apt-get update && apt-get install -y nginx git

WORKDIR /root

# TAIGA FRONT
RUN git clone -b stable https://github.com/taigaio/taiga-front-dist.git

# 
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

ADD nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
