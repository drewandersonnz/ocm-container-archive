# this is used for faster building (the layers exist already)
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


ADD ./container-setup/install /container-setup/install
WORKDIR /

ARG awsclient=awscli-exe-linux-x86_64.zip
ARG osdctlversion=v0.2.0
ARG osv4client=openshift-client-linux-4.3.12.tar.gz
ARG rosaversion=v0.0.16
ARG veleroversion=v1.5.1

RUN ./container-setup/install/install-aws.sh
RUN ./container-setup/install/install-kube_ps1.sh
RUN ./container-setup/install/install-oc.sh
RUN ./container-setup/install/install-ocm.sh
RUN ./container-setup/install/install-osdctl.sh
RUN ./container-setup/install/install-rosa.sh
RUN ./container-setup/install/install-velero.sh

RUN ./container-setup/install/install-utils.sh

RUN rm -rf /container-setup

WORKDIR /root

ADD ./container-setup/utils/ .
ADD ./container-setup/assets/.bashrc_supplement.sh .
RUN echo 'source ~/.bashrc_supplement.sh' >> ~/.bashrc
