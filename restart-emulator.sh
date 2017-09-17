#! /bin/bash
#

export SHELL=/bin/bash
export PATH=/opt/tools:/opt/android-sdk-linux/tools:/opt/android-sdk-linux/platform-tools:$PATH
export TERM=dumb

if [ "x$1" = "x--stop" ]; then
  # Poweroff screen
  adb  shell input keyevent 26

  adb kill-server
else
  adb kill-server
  adb wait-for-device
  adb root
  adb remount

  # Wakeup screen
  adb  shell input keyevent 26
fi
exit 0
