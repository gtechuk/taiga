#!/bin/bash
set -e
set -x
 
[ -z "$VHOST" ] && (echo "VHOST environment variable not set, set to the host name of the server" && exit)


echo "from .common import *" > ~/taiga-back/settings/local.py
echo "MEDIA_URL = \"http://$VHOST/media/\"" >> ~/taiga-back/settings/local.py
echo "STATIC_URL = \"http://$VHOST/static/\"" >> ~/taiga-back/settings/local.py
echo 'SITES["front"]["scheme"] = "http"' >> ~/taiga-back/settings/local.py
echo "SITES[\"front\"][\"domain\"] = \"$VHOST\"" >> ~/taiga-back/settings/local.py
echo "DEBUG = False" >> ~/taiga-back/settings/local.py
echo "PUBLIC_REGISTER_ENABLED = True" >> ~/taiga-back/settings/local.py
echo "no-reply@$VHOST" >> ~/taiga-back/settings/local.py
echo "SERVER_EMAIL = DEFAULT_FROM_EMAIL" >> ~/taiga-back/settings/local.py



PGPASSWORD=$TAIGA_DB_PASSWORD  psql -h $TAIGA_DB_HOST -w $TAIGA_DB_NAME $TAIGA_DB_USER -c "select * from information_schema.tables where table_name='django_migrations'"
DB_CHECK_STATUS=$?
echo "DB Status $DB_CHECK_STATUS"

if [ $DB_CHECK_STATUS -eq 1 ]; then
  echo "Failed to connect to database server or database does not exist."
  exit 1
elif [ $DB_CHECK_STATUS -eq 2 ]; then
  echo "Configuring initial database"
  python2 manage.py migrate --noinput
  python2 manage.py loaddata initial_user
  python2 manage.py loaddata initial_project_templates
  python2 manage.py loaddata initial_role
  python2 manage.py compilemessages
fi

# Now just fire of the command
python2 /root/taiga-back/manage.py runserver 0.0.0.0:8001