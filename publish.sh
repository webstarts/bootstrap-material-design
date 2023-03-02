#!/bin/bash

./node_modules/grunt-cli/bin/grunt dist --force && cp dist/css/*.min.css ../webstarts/library/ && rsync -Pav -e "ssh -i $HOME/keys/Webstarts_ec2_webserver.pem" dist/css/*.min.css ubuntu@18.223.45.107:/home/kashif/webstarts/library/
