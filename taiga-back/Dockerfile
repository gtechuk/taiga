FROM python:3.5

RUN apt-get update && apt-get install -y \
    build-essential binutils-doc autoconf flex bison libjpeg-dev \
    libfreetype6-dev zlib1g-dev libzmq3-dev libgdbm-dev libncurses5-dev \
    automake libtool libffi-dev curl git tmux gettext \
    nginx \
    rabbitmq-server redis-server \
    postgresql


WORKDIR /root
#RUN adduser taiga
#RUN adduser taiga sudo
#
#USER taiga
RUN mkdir -p ~/logs


# TAIGA BACK
RUN git clone -b stable https://github.com/taigaio/taiga-back.git
#RUN bash -c "source /usr/bin/virtualenvwrapper.sh && mkvirtualenv -p /usr/bin/python2.5 taiga"

RUN echo "LANG=en_US.UTF-8" > /etc/default/locale
RUN echo "LC_TYPE=en_US.UTF-8" > /etc/default/locale
RUN echo "LC_MESSAGES=POSIX" >> /etc/default/locale
RUN echo "LANGUAGE=en" >> /etc/default/locale

ENV LANG en_US.UTF-8
ENV LC_TYPE en_US.UTF-8


 
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR /root/taiga-back

ADD checkdb.py /checkdb.py

RUN python manage.py collectstatic --noinput
