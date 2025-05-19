Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.provider "virtualbox"
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt update
    sudo apt install -y build-essential linux-headers-$(uname -r) python3
  SHELL
end
