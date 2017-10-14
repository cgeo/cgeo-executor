#! /bin/bash
#

if [ "x$1" = "x--stop" ]; then
  adb kill-server
else
  adb kill-server
  adb start-server
fi

