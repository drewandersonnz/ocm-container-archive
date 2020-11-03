# ocm-container

A quick environment for accessing OpenShift v4 clusters. Nothing fancy, gets the job done.

Related tools added to image:
* `ocm`
* `oc`
* `aws`
* `osdctl`

## Features:
* Does not mount any host filesystem objects as read/write, only uses read-only mounts.
* Uses ephemeral containers per cluster login, keeping seperate `.kube` configuration and credentials.
* Credentials are destroyed on container exit (container has `--rm` flag set)
* Displays current cluster-name, and OpenShift project (`oc project`) in bash PS1
* Ability to login to private clusters without using a browser

## Getting Started:

### Config:

* clone this repo
* `./init.sh`
* edit the file `$HOME/.config/ocm-container/env.source`
  * set your requested OCM_USER (for `ocm -u OCM_USER`)
  * set your OFFLINE_ACCESS_TOKEN (from [cloud.redhat.com](https://cloud.redhat.com/))
* optional: configure alias in `~/.bashrc`
  * alias ocm-container-stg="OCM_URL=staging ocm-container"
  * set your kerberos username if it's different than your OCM_USER

### Build:

```
./build.sh
```

### Use it:
```
ocm-container
```
With launch options:
```
OCM_CONTAINER_LAUNCH_OPTS="-v ~/work/myproject:/root/myproject" ocm-container
```

Launch options provide you a way to add other volumes, add environment variables, or anything else you would need to do to run ocm-container the way you want to.

## Example:

### Public Clusters

```
$ ocm-container
[production] # ./login.sh
[production] # ocm cluster login test-cluster
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
[production] (test-cluster) #
```

### Private clusters
This tool also can tunnel into private clusters.

```
$ ocm-container-stg
[staging] # ./login.sh
[staging] # ocm tunnel --cluster test-cluster -- --dns &
Will create tunnel to cluster:
 Name: test-cluster
 ID: 01234567890123456789012345678901

# /usr/bin/sshuttle --remote sre-user@ssh-url.test-cluster.mycluster.com 10.0.0.0/16 172.31.0.0/16 --dns
client: Connected.
[staging] # cluster-login -c 01234567890123456789012345678901
Login successful.

You have access to 67 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "default".
Welcome! See 'oc help' to get started.
[staging] (test-cluster) #
```

Tunneling to private clusters requires you to run the kinit program to generate a kerberos ticket. (I'm not sure if it needs the -f flag set for forwardability, but I've been setting it).  I use the following command (outside the container):

```
kinit -f -c $KRB5CCFILE
```

where $KRB5CCFILE is exported to `/tmp/krb5cc` in my .bashrc.

You can also set defaults on forwardability or cache file location, however that's outside the scope of `ocm-container`.

On a Mac, it seems that it doesn't follow the default kinit functionality where /tmp/krb5cc_$UID is the default cache file location, so you have to explicitly set it with an env var.  If you're troubleshooting this, it might help to run `kdestroy -A` to remove all previous cache files, and run `kinit` with the `-V` to display where it's outputting the cache file.  On my machine, it was originally attempting to put this into an API location that's supposed to be windows specific.
