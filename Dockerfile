FROM debian/eol:squeeze


WORKDIR	/root

# Install dependencies.
RUN	apt-get update && DEBIAN_FRONTEND=noninteractive\
	apt-get install -y build-essential libncurses5-dev rsync cpio python unzip bc wget lib32z1

# Install Buildroot.
RUN	wget -nv http://buildroot.uclibc.org/downloads/buildroot-2014.02.tar.bz2 &&\
	tar xf buildroot-*.tar* &&\
	rm buildroot-*.tar* &&\
	ln -s buildroot-* buildroot &&\
	mkdir -v buildroot/patches


RUN mkdir /tmp/ssl && cd /tmp/ssl && wget http://ftp.oregonstate.edu/.1/blfs/conglomeration/openssl/openssl-1.0.1.tar.gz && tar xfz openssl-1.0.1.tar.gz 
RUN cd /tmp/ssl/openssl-* && ./config --prefix=/usr --openssldir=/etc/ssl shared && make
RUN apt-get -y remove openssl
RUN cd /tmp/ssl/openssl-* && make install 


RUN sed -i 's/http:\/\/rabbit.dereferenced.org\/~nenolod\/distfiles\//https:\/\/releases.pagure.org\/pkgconf\/pkgconf\//g' buildroot/package/pkgconf/pkgconf.mk 
#BR2_KERNEL_MIRROR="https://mirrors.edge.kernel.org/pub"
#BR2_KERNEL_MIRROR="http://ftp.iij.ad.jp/pub/linux/kernel"


#RUN cd ~/buildroot && make at91sam9260dfc_defconfig 
#RUN cd ~/buildroot && make
# manual installation of openssl is needed for tls 1.2

#make qemu_arm_versatile_defconfig
#make linux-menuconfig
#make uclibc-menuconfig

# docker cp 33a01f7bd8b4:/root/buildroot/output/build/uclibc-0.9.33.2/.config uclibc-0.9.33.2_menuconfig
# docker cp 33a01f7bd8b4:/root/buildroot/output/build/linux-3.10.32/.config linux-3.10.32_menuconfig
