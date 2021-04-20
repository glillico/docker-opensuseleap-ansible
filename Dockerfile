FROM opensuse/leap:latest
LABEL maintainer="Graham Lillico"

ENV container docker

# Update packages to the latest version
RUN zypper update -y \
&& zypper clean --all

# Install required packages.
# Remove packages that are nolonger requried.
# Clean the dnf cache.
RUN zypper install -y \
python3 \
python3-pip \
sudo \
systemd \
&& zypper clean --all \
&& rm -rf /var/cache/zypp/*

# Configure systemd.
RUN (cd /usr/lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /usr/lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /usr/lib/systemd/system/local-fs.target.wants/*; \
rm -f /usr/lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /usr/lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /usr/lib/systemd/system/basic.target.wants/*;

# Install ansible.
RUN pip3 install ansible 'cryptography==3.3.2'

# Create ansible directory and copy ansible inventory file.
RUN mkdir /etc/ansible
COPY hosts /etc/ansible/hosts

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/lib/systemd/systemd"]
