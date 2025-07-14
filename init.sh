#!/bin/sh

# Launch the setup according to the detected OS type
# Only available for macOS at the moment
if [[ "$OSTYPE" == "darwin"* ]]; then
	echo "os with type $OSTYPE found - setup for macos..."
  	cd setup && chmod +x setup_system_darwin.sh && ./setup_system_darwin.sh
else
	echo "os with type $OSTYPE does not have setup config!"
	exit 1
fi
