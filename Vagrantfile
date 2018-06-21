Vagrant.configure("2") do |config|
  config.vm.define "centos7" do |machine|
    machine.vm.box = "centos/7"
    machine.vm.provision "shell", inline: "sudo yum install -y gcc zlib zlib zlib-devel"
    machine.vm.provision "shell", inline: "sudo yum install -y readline readline-devel libxml2 libxml2-devel"
    machine.vm.provider :virtualbox do |v|
    end
  end

  config.vm.define "ubuntu" do |machine|
    machine.vm.box = "ubuntu/trusty64"
    machine.vm.provider :virtualbox do |v|
    end
  end
end
