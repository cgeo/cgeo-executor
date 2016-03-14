#! /bin/bash
#

export SHELL=/bin/bash
export PATH=/opt/tools:/opt/android-sdk-linux/tools:/opt/android-sdk-linux/platform-tools:$PATH
export TERM=dumb

cd "$HOME"

PIDFILE=emulator.pid

if [ -f $PIDFILE ]; then
  OLDPID=$(cat $PIDFILE)
  if [ -d /proc/$OLDPID ]; then
    kill $OLDPID
    count=0
    while ((count < 10 )); do
      if [ -d /proc/$OLDPID ]; then
        ((count++))
        sleep 1
      else
        count=10
      fi
    done
    kill -9 $OLDPID 2> /dev/null
  fi
fi

if [ "x$1" = "x--stop" ]; then
  rm -f $PIDFILE
else
  emulator -avd emulator -no-window -no-boot-anim -no-audio -memory 2048 -qemu -enable-kvm &
  echo $! > $PIDFILE
fi
