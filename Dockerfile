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

RUN sed -i 's/http:\/\/rabbit.dereferenced.org\/~nenolod\/distfiles\//https:\/\/releases.pagure.org\/pkgconf\/pkgconf\//g' buildroot/package/pkgconf/pkgconf.mk 
RUN cd ~/buildroot && make at91sam9260dfc_defconfig 
RUN cd ~/buildroot && make
# # Create rootfs overlay.
# RUN mkdir -vpm775 buildroot/rootfs_overlay/srv

# # Install toolchain.
# RUN	wget -nv --no-check-certificate \
# 	https://github.com/Docker-nano/crosstool-NG/releases/download/1.0.1/x86_64-nano-linux-uclibc.tar.xz &&\
# 	tar xf *.tar* &&\
# 	ln -s "$(tar tf *.tar* | head -1)" toolchain &&\
# 	rm *.tar*

# COPY	in/buildroot		/usr/local/bin/
# COPY	in/buildroot-configure	/usr/local/bin/
# COPY	in/buildroot.conf	/root/buildroot/.config
# COPY	in/post_build.sh	/root/buildroot/
