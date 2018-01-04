#!/bin/bash
set -e

[ -z "$TAIGA_BACK_HOST" ] && (echo "TAIGA_BACK_HOST environment variable not set, set to the host name of the server" && exit)
[ -z "$TAIGA_EVENTS_HOST" ] && (echo "TAIGA_EVENTS_HOST environment variable not set, set to the host name of the server" && exit)

echo "{" > ~/taiga-front-dist/dist/conf.json
echo "	\"api\": \"http://$TAIGA_BACK_HOST/api/v1/\"," >> ~/taiga-front-dist/dist/conf.json
echo "	\"eventsUrl\": \"ws://$TAIGA_EVENTS_HOST/events\"," >> ~/taiga-front-dist/dist/conf.json
echo "	\"debug\": \"true\"," >> ~/taiga-front-dist/dist/conf.json
echo "	\"publicRegisterEnabled\": true," >> ~/taiga-front-dist/dist/conf.json
echo "	\"feedbackEnabled\": true," >> ~/taiga-front-dist/dist/conf.json
echo "	\"privacyPolicyUrl\": null," >> ~/taiga-front-dist/dist/conf.json
echo "	\"termsOfServiceUrl\": null," >> ~/taiga-front-dist/dist/conf.json
echo "	\"maxUploadFileSize\": null," >> ~/taiga-front-dist/dist/conf.json
echo "	\"contribPlugins\": []" >> ~/taiga-front-dist/dist/conf.json
echo "}" >> ~/taiga-front-dist/dist/conf.json

# Now just fire of the command
exec "$@"