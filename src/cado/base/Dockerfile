# Take an image that has cado-nfs installed in /pkg and configure it to remove
# unncessary packages, install supporting software not necessarily needed to
# build, and set up a cado user account to run the client and server.
FROM cado-build

ENV RUNDEPS ' \
	bc \
	curl \
	iputils-ping \
	less \
	libdata-dumper-concise-perl \
	libgomp1 \
	openssl \
	python \
	python3 \
	vim-common \
	vim-tiny \
	'

# This list could be built with the aid of 
# dpkg-query -Wf '${Package;-40}${Priority}\n' | grep -v essential
ENV CRUFT ' \
	acpi \
	acpid \
	aptitude \
	aspell \
	aspell-en \
	autoconf \
	automake \
	avahi-daemon \
	base-config \
	bash-completion \
	bin86 \
	bind9-host \
	bison \
	clang \
	cmake \
	console-common \
	console-data \
	console-tools \
	cupsys-bsd \
	cupsys-client \
	cupsys-driver-gutenprint \
	cupsys-pdf \
	debian-faq \
	debian-faq-de \
	debian-faq-fr \
	debian-faq-it \
	debian-faq-zh-cn \
	dhcp \
	dhcp3-client \
	dhcp3-common \
	dictionaries \
	dnsutils \
	doc-debian \
	doc-linux-text \
	dpkg-dev \
	eject \
	fdutils \
	file \
	finger \
	foomatic-filters \
	gcc-3.3 \
	gettext-base \
	gnu-efi \
	groff \
	grub \
	hplip \
	iamerican \
	ibritish \
	info \
	ispell \
	laptop-detect \
	libavahi-compat-libdnssd1 \
	libc6-amd64 \
	libc6-i686 \
	libgpmg1 \
	make \
	manpages \
	mercurial \
	mtools \
	mtr-tiny \
	mutt \
	nano \
	ncurses-term \
	net-tools \
	netcat \
	openssh-client \
	openssh-server \
	pidentd \
	ppp \
	pppconfig \
	pppoe \
	pppoeconf \
	read-edid \
	reportbug \
	smclient \
	ssh \
	subversion \
	tasksel \
	tcsh \
	texinfo \
	traceroute \
	usbutils \
	w3m \
	wamerican \
	whois \
	zeroinstall-injector \
	'

RUN apt-get update && \
	apt-get install -y \
		$RUNDEPS && \
	dpkg --purge \
		$CRUFT && \
	apt-get autoremove -y && \
	apt-get clean -y && \
	useradd \
		--create-home \
		--home /home/cado \
		--password yyN7aDl7nlnvQ \
		--shell /bin/bash \
		--user-group \
		cado
