FROM codetroopers/jenkins-slave-jdk8-android:23-23.0.2

USER root
RUN apt-get update
RUN apt-get -y install qemu-kvm curl

USER jenkins
WORKDIR /home/jenkins

RUN echo 'PATH=/opt/tools:/opt/android-sdk-linux/tools:/opt/android-sdk-linux/platform-tools:$PATH' >> .profile
RUN wget http://ci.cgeo.org/jnlpJars/slave.jar
RUN mkdir slave
RUN ["android-accept-licenses.sh", "android update sdk --all --no-ui --filter android-19,android-22,addon-google_apis-google-22,addon-google_apis-google-23,sys-img-x86_64-addon-google_apis-google-23,extra-android-support,extra-android-m2repository"]
RUN android create avd -n emulator -t "Google Inc.:Google APIs:23" -c 50M -d "Nexus 4" -g google_apis -b x86_64
ADD start.sh /home/jenkins/
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
