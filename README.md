# Overview

Have you ever wanted to use multiple V4 cluster login sessions simultaneously?

https://github.com/drewandersonnz/ocm-container

This builds the ocm and oc tools into a base Fedora container image and allows you to start one container per execution.

As the kube token is stored locally inside the container, and the container is destroyed upon exit, there is no permanent storage of cluster tokens, and no conflicts when using multiple logins simultaneously.

# Security

* Uses raw Fedora image and installs tools from our services.
* No personal tokens or URLs are stored in the container image (personal tokens passed in via ENV at runtime).
* Container image is only stored locally, not pushed to any registry.
* Running container does not mount any local volumes.
* Uses the same base ocm login script as per the V4 ocm SOP (minor modifications).

# Instructions

## Build

```bash
make build # build the empty container image
```

## Configure

```bash
cp templates/ocm-stage.source.template ~/.ocm-stage.source
cp templates/ocm-prod.source.template ~/.ocm-prod.source
vim -p ~/.ocm-*.source; # add your offline access token to env.source
```

For offline token see [Offline Access Token](https://cloud.redhat.com/openshift/token)


## Use

You are now ready..

```bash
$ ./ocm-container.sh stage # note no cluster params -- will list clusters
$ ./ocm-container.sh stage mytestcluster # note $2 == clusterid or clustername
Will login to cluster:
 Name: mytestcluster
 ID: 15uq.....
Authentication required for https://api.mytestcluster.....com:6443 (openshift)
Username: <kerberos>
Password:
Login successful.

You have access to 54 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "default".
Welcome! See 'oc help' to get started.
[root@9173034342c0 /] (myuser@mytestcluster)#
```

Note the bash PS1 also shows which cluster you are in, helpful to determine when you have multiple sessions open.

TIP: use an alias so this can be run from anywhere at any time
```bash
echo 'alias ocmc="~/source/ocm-container/ocm-container.sh"' >> ~/.bashrc
. .bashrc
ocmc stage
```

# Configuration

There are several environment variables setup in each config file (i.e. ocm-{stage,prod}.source):

* `OCM_URL` - the URL for the OCM API
* `CLUSTER_USERNAME` - the user you use to login to the OCP cluster, defaults to `$USER`
* `CONTAINER_PS1` - a colorized PS1 for use within the container
* `OFFLINE_ACCESS_TOKEN` - your offline access token

You must set `OFFLINE_ACCESS_TOKEN`.  If your local username isn't the same username you login to clusters with you'll have to update that as well.  The others can be left at the default.