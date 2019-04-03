#!/bin/bash

if [ -c /dev/kvm ]; then
  echo "Device KVM exists. Setting rights...."
  chown 1000:1000 /dev/kvm
else
  echo "/dev/kvm does not exist"
  exit 1
fi

echo avdmanager --verbose create avd -f -c 50M -k $ANDROID_IMAGE -n android-${ANDROID_API_VERSION} -g google_apis -b $ANDROID_ARCH -d "Nexus 4"
sudo -u jenkins /opt/android-sdk-linux/tools/bin/avdmanager --verbose create avd -f -c 50M -k $ANDROID_IMAGE -n android-${ANDROID_API_VERSION} -g google_apis -b $ANDROID_ARCH -d "Nexus 4"

/opt/android-sdk-linux/platform-tools/adb start-server

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
