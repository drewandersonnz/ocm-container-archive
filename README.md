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

```bash
./build.sh # build the empty container image
cp env.source.sample env.source;
vim env.source; # add your offline access token to env.source
```

For offline token see [Offline Access Token](https://cloud.redhat.com/openshift/token)

You are now ready..

```bash
$ ./ocm-container.sh # note no params -- will list clusters
$ ./ocm-container.sh osd-v4stg-aws # note $1 == clusterid
Will login to cluster:
 Name: osd-v4stg-aws
 ID: 15uq.....
Authentication required for https://api.osd-v4stg-aws.....com:6443 (openshift)
Username: <kerberos>
Password:
Login successful.

You have access to 54 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "default".
Welcome! See 'oc help' to get started.
[root@9173034342c0 /] (osd-v4stg-aws)#
```

Note the bash PS1 also shows which cluster you are in, helpful to determine when you have multiple sessions open.