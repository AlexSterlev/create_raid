# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :'otus-task-2' => {
        :box_name => "centos/7",
        :ip_addr => '192.168.11.101',
	:disks => {
		:sata1 => {
			:dfile => './sata1.vdi',
			:size => 100,
			:port => 1
		},
		:sata2 => {
                        :dfile => './sata2.vdi',
                        :size => 100, # Megabytes
			:port => 2
		},
                :sata3 => {
                        :dfile => './sata3.vdi',
                        :size => 100,
                        :port => 3
                },
                :sata4 => {
                        :dfile => './sata4.vdi',
                        :size => 100, # Megabytes
                        :port => 4
                
                }

	}

		
  },
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

      config.vm.define boxname do |box|

          box.vm.box = boxconfig[:box_name]
          box.vm.host_name = boxname.to_s

          #box.vm.network "forwarded_port", guest: 3260, host: 3260+offset

          box.vm.network "private_network", ip: boxconfig[:ip_addr]

          box.vm.provider :virtualbox do |vb|
            	  vb.customize ["modifyvm", :id, "--memory", "1024"]
                  needsController = false
		  boxconfig[:disks].each do |dname, dconf|
			  unless File.exist?(dconf[:dfile])
				vb.customize ['createhd', '--filename', dconf[:dfile], '--variant', 'Fixed', '--size', dconf[:size]]
                                needsController =  true
                          end

		  end
                  if needsController == true
                     vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]
                     boxconfig[:disks].each do |dname, dconf|
                         vb.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]
                     end
                  end
          end
 	  box.vm.provision "shell", inline: <<-SHELL
	      mkdir -p ~root/.ssh
              cp ~vagrant/.ssh/auth* ~root/.ssh
	      yum install -y mdadm smartmontools hdparm gdisk
              mdadm --create --verbose /dev/md0 -l 10 -n 4 /dev/sd[b-e]
              mkdir /etc/mdadm
              echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
              mdadm --detail --scan --verbose | awk '/ARRAY/{print}' >> /etc/mdadm/mdadm.conf 
              parted --script /dev/md0 mklabel gpt\  mkpart primary 2048s 25%\  mkpart primary 25% 50%\ mkpart primary ext4 50% 75%\ mkpart primary ext4 75% 100%
              for i in $(seq 1 4); do sudo mkfs.ext4 /dev/md0p$i; done
              mkdir -p /raid/part{1,2,3,4}
              for i in $(seq 1 4); do mount /dev/md0p$i /megaraid/part$i; done
              for i in $(seq 1 4); do echo /dev/md0p$i /megaraid/part$i ext4 defaults 0 0 >> /etc/fstab; done
  	  SHELL

      end
  end
end