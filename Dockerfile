FROM centos:8
LABEL maintainer="David Alger"

RUN yum -y install sudo openssh-clients python3-pip \
    && yum clean all \
    && rm -rf /var/cache/yum

ARG ANSIBLE_VERSION
RUN set -eux \
    && if [[ ${ANSIBLE_VERSION} =~ ^[0-9]+\.[0-9]+$ ]]; \
        then ANSIBLE_PKG="ansible==${ANSIBLE_VERSION}.*"; \
        else ANSIBLE_PKG="ansible==${ANSIBLE_VERSION}"; \
    fi \
    && pip3 install ${ANSIBLE_PKG} jmespath

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers
