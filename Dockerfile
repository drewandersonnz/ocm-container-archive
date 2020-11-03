#FROM ocm-container
FROM fedora:latest

ENV I_AM_IN_CONTAINER="I-am-in-container"

RUN yum -y install \
    bash-completion \
    findutils \
    fzf \
    git \
    golang \
    jq \
    make \
    procps-ng \
    rsync \
    sshuttle \
    vim-enhanced \
    wget \
    && yum clean all;

ADD ./container-setup/utils/ /container-setup/utils

WORKDIR /container-setup/install

ARG osv4client=openshift-client-linux-4.3.12.tar.gz
ARG rosaversion=v0.0.16
ARG awsclient=awscli-exe-linux-x86_64.zip
ARG osdctlversion=v0.2.0
ARG veleroversion=v1.5.1

ADD ./container-setup/install/helpers.sh helpers.sh

ADD ./container-setup/install/install-rosa.sh .
RUN ./install-rosa.sh
ADD ./container-setup/install/install-ocm.sh .
RUN ./install-ocm.sh
ADD ./container-setup/install/install-oc.sh .
RUN ./install-oc.sh
ADD ./container-setup/install/install-aws.sh .
RUN ./install-aws.sh
ADD ./container-setup/install/install-kube_ps1.sh .
RUN ./install-kube_ps1.sh
ADD ./container-setup/install/install-osdctl.sh .
RUN ./install-osdctl.sh
ADD ./container-setup/install/install-velero.sh .
RUN ./install-velero.sh
ADD ./container-setup/install/install-utils.sh .
RUN ./install-utils.sh

RUN rm -rf /container-setup

WORKDIR /root

ADD container-setup/install/bashrc_supplement.sh .bashrc_supplement.sh
RUN echo 'source ~/.bashrc_supplement.sh' >> ~/.bashrc
