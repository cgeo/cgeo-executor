#!/bin/bash

echo avdmanager --verbose create avd -f -c 50M -k $ANDROID_IMAGE -n android-${ANDROID_API_VERSION} -g google_apis -b $ANDROID_ARCH -d "Nexus 4"
sudo -u jenkins /opt/android-sdk-linux/tools/bin/avdmanager --verbose create avd -f -c 50M -k $ANDROID_IMAGE -n android-${ANDROID_API_VERSION} -g google_apis -b $ANDROID_ARCH -d "Nexus 4"

/opt/android-sdk-linux/platform-tools/adb start-server

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
