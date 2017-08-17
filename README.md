# Project status

[![imagelayers](https://imagelayers.io/badge/cgeo/cgeo-executor:latest.svg)](https://imagelayers.io/?images=cgeo/cgeo-executor:latest)<br>

# Using cgeo-executor

You can launch a `cgeo-executor-1` from the `cgeo-executor` image using `docker`:

    docker run -d --device /dev/kvm --cpuset-cpus=12-15 \
      --memory=8g --memory-reservation=4g \
      --name cgeo-executor-1 -v PATH-TO-YOUR-SRV:/srv cgeo/cgeo-executor

Here, the executor  has access to `/dev/kvm`, is restricted to 4 CPUs (12 to 15),
and can use at most 8GB of RAM (4GB preferred).

Also, a directory is bound to `/srv` in the container. This directory must contain
at least those files:

- slave: the name of the Jenkins slave
- secret: the secret of the Jenkins slave
- private.properties
- cgeo.geocaching_preferences.xml

The user running docker must have access to `/dev/kvm`.
