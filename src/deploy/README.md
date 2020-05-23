1. set up build environment
   1. install debian testing, udpate to latest packages
   1. add user account
   1. install openssh client and server
   1. create SSH key, copy to authorized keys, turn off host key checking
1. save build image
1. enlarge build image disk
1. set up client image from build
   1. mount /opt RO and /data RW
   1. copy ssh public key to /data/etc/clients/`hostname`
1. set up server image from build
   1. install NFS server
   1. create /opt and /data NFS exports
   1. install hwloc
   1. install openmpi
   1. install gmp
   1. install cado-nfs
   1. instal supporting packages
1. start M clients
   1. client waits for SSH connection, otherwise idle
1. start 1 server
   1. log into server, run cado-nfs.py \
      slaves.hostnames=$(cd /data/etc/clients; ls -1) \
      tasks.linalg.run=false \
      3777...7771


base:
	apt update
	apt install -y --no-install-recommends ssh-client ssh-server

	add cado user
	add build user

	as cado:
		ssh-keygen -N "" -f ${HOME}/.ssh/id_rsa -q
		cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys


cado-server:
	mount /export
	mkdir /export/pkg /export/data
	nfs-export /export/pkg
	nfs-export /export/data

	install build tools

	as build, prefix=/pkg:
		install hwloc
		install openmpi
		install gmp
		install cado-nfs


cado-client:
	mount cado-server:/pkg /pkg
	mount cado-server:/data /data
