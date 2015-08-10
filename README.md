# openstack-model-t

# PLEASE DON'T USE THIS TILL THE 1.0.0 Release, it's WIP till then!

> "The Customer Can Have Any Color He Wants So Long As It's Black".
**Henry Ford**

![model-t-car](https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/1919_Ford_Model_T_Highboy_Coupe.jpg/280px-1919_Ford_Model_T_Highboy_Coupe.jpg)

## General Info

This is a build of OpenStack that is taken directly from the [install-guide](http://docs.openstack.org/kilo/install-guide/install/apt/content/ch_preface.html) and is *opinionated*. This will only every be a [Ubuntu](https://wiki.ubuntu.com/ServerTeam/CloudArchive) build, and at the time of this release [Ubuntu 14.04 LTS](http://releases.ubuntu.com/14.04/). The goal of this build is to show you what you can do with [chef](http://chef.io) and [openstack](http://openstack.org).

This build is also [test-kitchened](http://kitchen.ci) with a good coverage of [serverspec](http://serverspec.org/) tests. I strongly suggest you get the latest [chef-dk](https://downloads.chef.io/chef-dk/) and leverage it as your build platform.

## Attributes to change/override.

WARNING:

Admin token for keystone this is insecure, you probably should remove this after deployment for security reasons, disable the temporary authentication token mechanism: edit the `/etc/keystone/keystone-paste.ini` file and remove admin_token_auth from the `[pipeline:public_api]`, `[pipeline:admin_api]`, and `[pipeline:api_v3]` sections. Unset the temporary `OS_TOKEN` and `OS_URL` environment variables:

`default[:openstack_model_t][:admin_token] = 'b14feea8128a0a1bbd60'`

### Networking stuff

![minimal-arch-example](http://docs.openstack.org/kilo/install-guide/install/apt/content/figures/1/a/common/figures/installguidearch-neutron-networks.png)

An IP on the management network, the RED boxes.

`default[:openstack_model_t][:management_network_ip] = '127.0.0.1'`

OVS needs a tunnel interface to talk to the other guys, the YELLOW?/BROWN? boxes.

`default[:openstack_model_t][:instance_tunnel_ip] = '127.0.0.1'`

OVS needs an external nic that doesn't have an IP, the TEAL box.
`default[:openstack_model_t][:network_node_external_bridge] = 'eth2'`

Replace METADATA_SECRET with a suitable secret for the metadata proxy.

`default[:openstack_model_t][:METADATA_SECRET] = '7874fa60615f3f86ac1a'`

### Hardware acceleration?

Test via:

`egrep -c '(vmx|svm)' /proc/cpuinfo`

If it comes back anything other than zero, you should override this attribute to `kvm`.

`default[:openstack_model_t][:hardware_acceleration] = 'qemu'`


## TODO
- Write a cleanup recipe
- Write up the ability to split out the db machine to another host "mysql -h blahblah"



Keystone instance:
default,mysql,keystone

Glance instance:
default,mysql,glance

Nova-controller:
default,mysql,nova-controller-node

Nova-compute:
default,mysql,nova-compute-node
