#!/bin/bash
set -e

[ -z "$VHOST" ] && (echo "VHOST environment variable not set, set to the host name of the server" && exit)
[ -z "$TAIGA_BACK_HOST" ] && (echo "TAIGA_BACK_HOST environment variable not set, set to the host name of the server" && exit)
[ -z "$TAIGA_BACK_PORT" ] && (echo "TAIGA_BACK_PORT environment variable not set, set to the host name of the server" && exit)

echo "{" > dist/conf.json
echo "	\"api\": \"http://$VHOST/api/v1/\"," >> dist/conf.json
#echo "	\"eventsUrl\": \"ws://$VHOST/events\"," >> dist/conf.json
echo "	\"debug\": \"true\"," >> dist/conf.json
echo "	\"publicRegisterEnabled\": true," >> dist/conf.json
echo "	\"feedbackEnabled\": true," >> dist/conf.json
echo "	\"privacyPolicyUrl\": null," >> dist/conf.json
echo "	\"termsOfServiceUrl\": null," >> dist/conf.json
echo "	\"maxUploadFileSize\": null," >> dist/conf.json
echo "	\"contribPlugins\": []" >> dist/conf.json
echo "}" >> dist/conf.json

 
sed -i "s/BACKENDHOST/$TAIGA_BACK_HOST/g" /etc/nginx/nginx.conf
sed -i "s/BACKENDPORT/$TAIGA_BACK_PORT/g" /etc/nginx/nginx.conf
#cat /etc/nginx/nginx.conf

n=0
until [ $n -ge 5 ]
do
    nginx -g "daemon off;" && break || true

    n=$[$n+1]
    sleep 5
done

