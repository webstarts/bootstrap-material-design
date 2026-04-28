#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="/Users/kashifnaseem/projects/webstarts/webstarts/library"
REMOTE_DEPLOY="${REMOTE_DEPLOY:-1}"
SSH_KEY_PATH="${SSH_KEY_PATH:-$HOME/projects/key_files/Webstarts_ec2_webserver.pem}"
REMOTE_DEST="${REMOTE_DEST:-ubuntu@18.223.45.107:/home/kashif/webstarts/library/}"

cd "$ROOT_DIR"

# Build CSS artifacts. --force keeps legacy lint warnings from aborting the build.
./node_modules/grunt-cli/bin/grunt dist-less --force

# Publish exact mappings requested by WebStarts.
cp "$ROOT_DIR/dist/css/bootstrap-material-design.css" "$TARGET_DIR/bootstrap-material-design-designer.min.css"
cp "$ROOT_DIR/dist/css/bootstrap-material-design.min.css" "$TARGET_DIR/bootstrap-material-design.min.css"

echo "Published CSS files:"
echo "- $TARGET_DIR/bootstrap-material-design-designer.min.css"
echo "- $TARGET_DIR/bootstrap-material-design.min.css"

if [[ "$REMOTE_DEPLOY" == "1" ]]; then
	rsync -Pav -e "ssh -i $SSH_KEY_PATH" dist/css/*.min.css "$REMOTE_DEST"
	echo "Remote sync complete: $REMOTE_DEST"
else
	echo "Remote sync skipped (set REMOTE_DEPLOY=1 to enable)."
fi