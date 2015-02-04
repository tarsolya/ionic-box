#!/usr/bin/env bash

# SETUP START
ANDROID_SDK_FILENAME=android-sdk_r24-linux.tgz
ANDROID_SDK=http://dl.google.com/android/$ANDROID_SDK_FILENAME
APT_PACKAGES="nodejs nodejs-legacy npm git openjdk-7-jdk ant expect"
NPM_PACKAGES="cordova ionic bower grunt phonegap"
# SETUP END

# PROVISIONING
function apt_install {
  echo "Installing APT package: $1"
  apt-get -y install "$1" >/dev/null 2>&1
}

function npm_install {
  echo "Installing global NPM package: $1"
  npm install -g "$1" >/dev/null 2>&1
}

echo "Updating APT sources ..."
export DEBIAN_FRONTEND=noninteractive
apt-get update > /dev/null 2>&1

echo "Installing required APT packages ..."
for package in $APT_PACKAGES; do
  apt_install $package
done

echo "Downloading Android SDK ($ANDROID_SDK) ..."
curl -s -O $ANDROID_SDK > /opt/$ANDROID_SDK_FILENAME

echo "Extracting Android SDK ..."
tar -xzf $ANDROID_SDK_FILENAME -C /opt

echo "Setting up permissions ..."
sudo chown -R vagrant /opt/android-sdk-linux >/dev/null 2>&1

echo "export ANDROID_HOME=/opt/android-sdk-linux" >> /home/vagrant/.bashrc
echo "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-i386" >> /home/vagrant/.bashrc
echo "export PATH=\$PATH:/opt/android-sdk-linux/tools:/opt/android-sdk-linux/platform-tools" >> /home/vagrant/.bashrc

# Install required global NPM packages
echo "Installing NPM packages ..."
for package in $NPM_PACKAGES; do
  npm_install $package
done

echo "Installing Android SDK packages and licenses ..."
expect -c '
set timeout -1   ;
spawn /opt/android-sdk-linux/tools/android update sdk -u --all --filter platform-tool,android-19,build-tools-19.1.0
expect {
  "Do you accept the license" { exp_send "y\r" ; exp_continue }
  eof
}
' >/dev/null 2>&1

echo "Installing SASS ..."
sudo gem install sass > /dev/null 2>&1

echo "Regenerating locales ..."
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 >/dev/null 2>&1

echo "Done. Use 'vagrant ssh' to login into your brand new Snapp / Ionic dev box! :)"

