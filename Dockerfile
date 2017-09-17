FROM codetroopers/jenkins-slave-jdk8-android:23-23.0.2

USER root
RUN apt-get update \
    && apt-get -y install \
        qemu-kvm curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER jenkins
WORKDIR /home/jenkins

RUN echo 'PATH=/opt/tools:/opt/android-sdk-linux/tools:/opt/android-sdk-linux/platform-tools:$PATH' >> .profile
RUN wget http://ci.cgeo.org/jnlpJars/slave.jar
RUN mkdir slave
RUN ["android-accept-licenses.sh", "android update sdk --all --no-ui --filter android-19,android-22,android-23,addon-google_apis-google-22,addon-google_apis-google-23,sys-img-x86_64-google_apis-23,extra-android-support,extra-android-m2repository,extra-google-m2repository,build-tools-25.0.2,tools"]
RUN android create avd -n emulator -t "android-23" -c 50M -d "Nexus 4" -g google_apis -b google_apis/x86_64
ADD start.sh /home/jenkins/
ADD restart-emulator.sh /home/jenkins/
COPY adb+ /usr/local/bin/
RUN mv /opt/android-sdk-linux/platform-tools/adb /opt/android-sdk-linux/platform-tools/adb.orig \
  && ln -s /usr/local/bin/adb+ /opt/android-sdk-linux/platform-tools/adb
ENTRYPOINT /home/jenkins/start.sh

# Launch with:
#  docker run -d --privileged --name cgeo-executor -v PATH-TO-YOUR-SRV:/srv cgeo-executor
#
# The local srv directory must contain:
#  - slave: the name of the Jenkins slave
#  - secret: the secret of the Jenkins slave
#  - private.properties
#  - cgeo.geocaching_preferences.xml
#
# Your user must have access to /dev/kvm
