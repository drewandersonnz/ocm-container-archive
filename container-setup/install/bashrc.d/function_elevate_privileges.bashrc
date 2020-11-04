function elevate() {
  oc adm groups add-users osd-sre-cluster-admins $(oc whoami)
}
