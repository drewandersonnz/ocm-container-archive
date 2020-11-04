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

ADD ./container-setup /container-setup

WORKDIR /container-setup

ARG osv4client=openshift-client-linux-4.3.12.tar.gz
ARG rosaversion=v0.0.16
ARG awsclient=awscli-exe-linux-x86_64.zip
ARG osdctlversion=v0.2.0
ARG veleroversion=v1.5.1

RUN ./install/install-rosa.sh
RUN ./install/install-ocm.sh
RUN ./install/install-oc.sh
RUN ./install/install-aws.sh
RUN ./install/install-kube_ps1.sh
RUN ./install/install-osdctl.sh
RUN ./install/install-velero.sh
RUN ./install/install-utils.sh

RUN mv /container-setup/install/bashrc.d/ /root/bashrc.d/
RUN cat /container-setup/install/bashrc_supplement.sh >> ~/.bashrc

RUN rm -rf /container-setup

WORKDIR /root
