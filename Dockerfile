#FROM ocm-container
FROM fedora:latest

RUN yum -y install \
    bash-completion \
    findutils \
    git \
    jq \
    wget \
    vim-enhanced \
    golang && \
    yum update -y && \
    yum clean all 

RUN go get -u github.com/openshift-online/ocm-cli/cmd/ocm;
RUN ln -s /root/go/bin/ocm /usr/local/bin/ocm;

# https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/
RUN wget -q https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux-4.1.18.tar.gz && \
    tar xzvf openshift-client-linux-4.1.18.tar.gz && \
    rm -f openshift-client-linux-4.1.18.tar.gz && \
    mv oc /usr/local/bin/oc

ADD ./container-setup /container-setup
