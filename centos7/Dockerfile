FROM centos:7

#RUN echo "proxy=http://172.17.42.1:3142" >> /etc/yum.conf

RUN yum install -y epel-release

RUN yum update -y \
    && yum makecache \
    && yum groupinstall -y 'Development Tools' \
    && yum install -y rpm-build yum-utils sudo tar ccache \
    && yum clean packages #20150828

RUN adduser -u 1000 build && ( \
  echo "build ALL = (root) NOPASSWD: /usr/bin/yum-builddep"; \
  echo "build ALL = (root) NOPASSWD: /usr/bin/yum"; \
  )> /etc/sudoers.d/build && chmod 440 /etc/sudoers.d/build

RUN sed -i s/enabled=1/enabled=0/ /etc/yum/pluginconf.d/fastestmirror.conf
