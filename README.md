# ocm-container

A quick environment for accessing OpenShift v4 clusters. Nothing fancy, gets the job done.

Related tools added to image:
* `ocm`
* `oc`
* `aws`

Features:
* Does not mount any host filesystem objects as read/write, only uses read-only mounts.
* Uses ephemeral containers per cluster login, keeping seperate `.kube` configuration and credentials.
* Credentials are destroyed on container exit (container has `--rm` flag set)
* Displays current cluster-name, and OpenShift project (`oc project`) in bash PS1

## Usage:

Config:

* cp env.source.sample env.source
* vim env.source
  * set your requested OCM_USER (for `ocm -u OCM_USER`)
  * set your OFFLINE_ACCESS_TOKEN (from [cloud.redhat.com](https://cloud.redhat.com/))
* optional: configure alias in `~/.bashrc`
  * alias ocm-container="/path/to/ocm-container/ocm-container.sh"
  * alias ocm-container-stg="OCM_URL=staging /path/to/ocm-container/ocm-container.sh"
  * FOR mac users you might need to prepend the `SSH_AUTH_ENABLE=ssh-agent`
    * alias ocm-container="SSH_AUTH_ENABLE=ssh-agent /path/to/ocm-container/ocm-container.sh"
    * alias ocm-container-stg="SSH_AUTH_ENABLE=ssh-agent OCM_URL=staging /path/to/ocm-container/ocm-container.sh"

Build:

```
./build.sh
```

* Check current `oc` version from here, can use force version by specifyng filename in environment variable `osv4client`:
[mirror.openshift.com](https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/)

Usage:

```
# Bootstrap ocm-container environment
./ocm-container.sh


## In-container

# Get a list of clusters.
./login.sh

# Login to cluster
./login.sh <cluster_name>

# Multiple logins to multiple clusters
# Just open multiple containers, one container per login
```

Example:

```
./ocm-container.sh
./login.sh test-cluster
Will login to cluster:
 Name: test-cluster
 ID: 01234567890123456789012345678901
Authentication required for https://api.test-cluster.shard.hive.example.com:6443 (openshift)
Username: my_user
Password:
Login successful.

You have access to 67 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "default".
Welcome! See 'oc help' to get started.
[root@999999999999 /] (test-cluster)#
```

Bash Alias:

Enables access from anywhere on the filesystem.

```
vim ~/.bashrc
alias ocm-container='/path/to/ocm-container/ocm-container.sh'
alias ocm-container-stg='OCM_URL=staging /path/to/ocm-container/ocm-container.sh'
```

# Private clusters
the tool makes it easier to login to the private clusters, when you use the container-setup/login.sh command
with the clusterID, you only need to:
- copy the `shuttle` command to another terminal
- grab the token
- run the login.sh command again and use it to log in

# FAQ
## I get a 'Failed to create  OCM connection' while the contianer is running
if you get the error:

```
Error: Failed to create OCM connection: Tokens have expired, run the 'login' command
```

you can re-login quickly with

```
ocm-login.sh
```
