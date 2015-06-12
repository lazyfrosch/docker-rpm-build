FROM centos:6

RUN echo "proxy=http://172.17.42.1:3142" >> /etc/yum.conf

RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm \
  && sed -i 's#https://#http://#' /etc/yum.repos.d/epel.repo

RUN yum update -y \
    && yum makecache \
    && yum install -y rpm-build yum-utils sudo tar \
    && yum clean packages #201506-1

RUN adduser -u 1000 build && ( \
  echo "build ALL = (root) NOPASSWD: /usr/bin/yum-builddep"; \
  echo "build ALL = (root) NOPASSWD: /usr/bin/yum"; \
  )> /etc/sudoers.d/build && chmod 440 /etc/sudoers.d/build
