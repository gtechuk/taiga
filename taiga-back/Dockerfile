FROM python:3.5

RUN apt-get update && apt-get install -y \
    build-essential binutils-doc autoconf flex bison libjpeg-dev \
    libfreetype6-dev zlib1g-dev libzmq3-dev libgdbm-dev libncurses5-dev \
    automake libtool libffi-dev curl git tmux gettext \
    postgresql

RUN mkdir -p /root/logs

# TAIGA BACK
RUN git clone -b stable https://github.com/taigaio/taiga-back.git

WORKDIR /taiga-back
RUN pip install -r requirements.txt

RUN python manage.py collectstatic --noinput

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8000
