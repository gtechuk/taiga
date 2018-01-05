#!/bin/bash
set -e
#set -x
#set -v

function testVar(){
   [ -z "$1" ] && (print $2 && exit)
}
[ -z "$VHOST" ] && (print "VHOST environment variable not set" && exit)

[ -z "$TAIGA_DB_PASSWORD" ] && (print "TAIGA_DB_PASSWORD environment variable not set" && exit)
[ -z "$TAIGA_DB_HOST" ] && (print "TAIGA_DB_HOST environment variable not set" && exit)
[ -z "$TAIGA_DB_NAME" ] && (print "TAIGA_DB_NAME environment variable not set" && exit)
[ -z "$TAIGA_DB_USER" ] && (print "TAIGA_DB_USER environment variable not set" && exit)
[ -z "$TAIGA_SECRET_KEY" ] && (print "TAIGA_SECRET_KEY environment variable not set" && exit)

echo "from .common import *" > settings/local.py
echo "MEDIA_URL = \"http://$VHOST/media/\"" >> settings/local.py
echo "STATIC_URL = \"http://$VHOST/static/\"" >> settings/local.py
echo 'SITES["front"]["scheme"] = "http"' >> settings/local.py
echo "SITES[\"front\"][\"domain\"] = \"$VHOST\"" >> settings/local.py
echo "SECRET_KEY = \"$TAIGA_SECRET_KEY\"" >> settings/local.py
echo "DEBUG = False" >> settings/local.py
echo "PUBLIC_REGISTER_ENABLED = False" >> settings/local.py
echo "DEFAULT_FROM_EMAIL = \"no-reply@$VHOST\"" >> settings/local.py
echo "SERVER_EMAIL = DEFAULT_FROM_EMAIL" >> settings/local.py

echo "DATABASES = {" >> settings/local.py
echo "    'default': {" >> settings/local.py
echo "        'ENGINE': 'django.db.backends.postgresql_psycopg2'," >> settings/local.py
echo "        'NAME': '$TAIGA_DB_NAME'," >> settings/local.py
echo "        'USER': '$TAIGA_DB_USER'," >> settings/local.py
echo "        'PASSWORD': '$TAIGA_DB_PASSWORD'," >> settings/local.py
echo "        'HOST': '$TAIGA_DB_HOST'," >> settings/local.py
#echo "        'PORT': 'YYY'," >> settings/local.py
echo "    }" >> settings/local.py
echo "}" >> settings/local.py


n=0
until [ $n -ge 10 ]
do
    STATUS=$((PGPASSWORD=$TAIGA_DB_PASSWORD psql -h $TAIGA_DB_HOST -w $TAIGA_DB_NAME $TAIGA_DB_USER -c "select 1" > /dev/null 2>&1 && echo "CONNECTED") || echo "NOT REACHABLE") 
    
    echo "DB Status $STATUS"

    if [ "$STATUS" == 'CONNECTED' ] ; then
        break;
    fi

    n=$[$n+1]
    sleep 1
done



RESULTSET=$(PGPASSWORD=$TAIGA_DB_PASSWORD psql -h $TAIGA_DB_HOST -w $TAIGA_DB_NAME $TAIGA_DB_USER -c "select COUNT(*) from information_schema.tables where table_name='django_migrations' " | sed -n '3 p') 

echo "DB Result $RESULTSET"

if [ "$RESULTSET" == '     0' ] ; then
    echo "Configuring initial database"
    python manage.py migrate --noinput
    python manage.py loaddata initial_user
    python manage.py loaddata initial_project_templates
    python manage.py compilemessages
    python manage.py collectstatic --noinput
fi



echo "Starting server on 0.0.0.0:8000 for virtual host $VHOST"
# Now just fire of the command
python manage.py runserver 0.0.0.0:8000
