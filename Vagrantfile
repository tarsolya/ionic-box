# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

$init = <<SCRIPT
sudo /home/vagrant/android-sdk-linux/platform-tools/adb kill-server
sudo /home/vagrant/android-sdk-linux/platform-tools/adb start-server
sudo /home/vagrant/android-sdk-linux/platform-tools/adb devices
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty32"
  config.vm.hostname = "snapp-ionic-android"
  config.ssh.insert_key = true

  config.vm.provision :shell, path: "bootstrap.sh", keep_color: true
  config.vm.provision :shell, run: "always", inline: $init

  config.vm.network "forwarded_port", guest: 8100, host: 8100
  config.vm.network "forwarded_port", guest: 35729, host: 35729

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--usb", "on"]
    vb.customize ["usbfilter", "add", "0", "--target", :id, "--name", "android", "--vendorid", "0x18d1"]
  end
end
