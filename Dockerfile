FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" TZ="Europe/Ljubljana" apt-get -y install \
        openjdk-11-jdk-headless \
        wget \
        curl \
        unzip \
        lib32stdc++6 \
        libqt5widgets5 \
        lib32z1 \
        tzdata \
        git \
        vim \
        less \
        bind9-host \
        iputils-ping \
        supervisor \
        qemu-kvm \
        x11vnc \
        openbox \
        feh \
        sudo \
        libqt5webkit5 \
        libgconf-2-4 \
        xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV ANDROID_SDK_VERSION=7583922
ENV ANDROID_HOME=/opt/android-sdk-linux/
ENV PATH=$PATH:/opt/android-sdk-linux/tools/:/opt/android-sdk-linux/cmdline-tools/latest/bin:/opt/android-sdk-linux/cmdline-tools/tools/bin:/opt/android-sdk-linux/platform-tools:/opt/android-sdk-linux/emulator
ENV QEMU_AUDIO_DRV=none

COPY android-packages /tmp/

RUN wget -O /tmp/sdk-tools-linux.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip \
    && mkdir /opt/android-sdk-linux/ \
    && unzip /tmp/sdk-tools-linux.zip -d /opt/android-sdk-linux/cmdline-tools \
    && mv /opt/android-sdk-linux/cmdline-tools/cmdline-tools/ /opt/android-sdk-linux/cmdline-tools/latest/ \
    && mkdir -p /var/log/supervisor \
    && yes | sdkmanager --licenses \
    && while read p; do echo "y" | sdkmanager "${p}"; done </tmp/android-packages \
    && yes | sdkmanager --update \
    && yes | sdkmanager --licenses \
    && useradd -m jenkins \
    && chown -R jenkins. /opt/android-sdk-linux/ \
    && cd /opt/android-sdk-linux/platform-tools/ \
    && mv adb adb.orig \
    && ln -s /usr/local/bin/adb+ adb \
    && chown jenkins. /var/log/supervisor

COPY scripts/* /usr/local/bin/
# To be compatible with old Jenkins scripts
COPY scripts/restart-emulator.sh /home/jenkins/restart-emulator.sh

ENV DISPLAY=:0 \
    SCREEN=0 \
    SCREEN_WIDTH=1600 \
    SCREEN_HEIGHT=900 \
    SCREEN_DEPTH=24+32 \
    LOG_PATH=/var/log/supervisor \
    ANDROID_API_VERSION=30 \
    ANDROID_IMAGE=system-images;android-30;google_apis;x86_64 \
    ANDROID_ARCH=x86_64

COPY supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 5900

WORKDIR /home/jenkins

HEALTHCHECK --interval=2s --timeout=40s --retries=1 \
    CMD timeout 40 adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done'

CMD ["/usr/local/bin/start.sh"]

# Launch with:
#  docker run -d --device /dev/kvm --memory=8g --memory-reservation=4g --name cgeo-executor -v PATH-TO-YOUR-SRV:/srv cgeo-executor
#
# The local srv directory must contain:
#  - slave: the name of the Jenkins slave
#  - secret: the secret of the Jenkins slave
#  - private.properties
#  - cgeo.geocaching_preferences.xml
#
# Your user must have access to /dev/kvm
