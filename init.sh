#!/bin/sh

# Launch the setup according to the detected OS type
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	echo "os with type $OSTYPE found - setup for debian..."
	sh setup/setup_system_debian.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "os with type $OSTYPE found - setup for macos..."
  	sh setup/setup_system_darwin.sh
else
	echo "os with type $OSTYPE does not have setup config!"
	exit 1
fi
