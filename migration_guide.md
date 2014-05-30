# Migration Guide

Two of the tarsnap cookbooks have been merged in this release, so please read over the information carefully before upgrading. Both original versions will
stay around for the time being, so if this seems like to much work please lock your cookbook versions in production.

## From [@andreacampi's tarsnap cookbook](https://github.com/andreacampi/tarsnap-cookbook)

If you are coming from [@andreacampi's tarsnap cookbook](https://github.com/andreacampi/tarsnap-cookbook) there should be little changes.

* You can now opt to use the tarsnapper LWRP described in the read me.
* The old `['tarsnapper']['jobs']` attribute method still works, but is now blank by default.

Keys are now handled differently. You will need to create a `tarsnap_keys` encrypted databag. After that you will need to import each of your keys into a
data bag entry named after node['fqdn']. The [knife-tarsnap](https://github.com/jssjr/chef-tarsnap/#configuring-the-tarsnap-knife-plugin) gem can
help you with this task.

If you prefer to stay with the last stable release please lock your cookbook to the old version. If you are using Berkshelf it might look like this.

`cookbook 'tarsnap', '~> 0.1.2'`

## From [@jssr's tarsnap cookbook](https://github.com/jssjr/chef-tarsnap/)

If you are coming from [@jssr's tarsnap cookbook](https://github.com/jssjr/chef-tarsnap/) feather was replaced with tarsnapper.

Unfortunately migration isn't so simple here, but I believe switching to [tarsnapper](https://github.com/miracle2k/tarsnapper) provided us with a more
robust backup wrapper. Please see the updated [tarsnap_backup](https://github.com/jssjr/chef-tarsnap/#backing-up-node-data) documentation before getting
started. Using the alias option may be of use to some of you. Expiration most like we need to be done manually because date formats will not be the same.

If you prefer to stay with the last stable release for now please lock your cookbook to the old version. If you are using Berkshelf it might look like
this.

`cookbook 'tarsnap', git: 'git@github.com:jssjr/chef-tarsnap.git', tag: 'v0.1.7'`
