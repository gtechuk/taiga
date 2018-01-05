FROM ubuntu:xenial

RUN apt-get update && apt-get install -y nginx git


# TAIGA FRONT
RUN git clone -b stable https://github.com/taigaio/taiga-front-dist.git

# 
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]

ADD nginx.conf /etc/nginx/nginx.conf

WORKDIR taiga-front-dist
RUN mkdir logs

EXPOSE 80

STOPSIGNAL SIGTERM