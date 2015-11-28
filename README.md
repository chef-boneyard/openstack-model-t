# openstack-model-t

> "The Customer Can Have Any Color He Wants So Long As It's Black".
**Henry Ford**

![model-t-car](https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/1919_Ford_Model_T_Highboy_Coupe.jpg/280px-1919_Ford_Model_T_Highboy_Coupe.jpg)

## General Info

This is a build of OpenStack that is taken directly from the [install-guide](http://docs.openstack.org/kilo/install-guide/install/apt/content/ch_preface.html)
and is *opinionated*. This will only every be a [Ubuntu](https://wiki.ubuntu.com/ServerTeam/CloudArchive)
build, and at the time of this release [Ubuntu 14.04 LTS](http://releases.ubuntu.com/14.04/).
The goal of this build is to show you what you can do with [chef](http://chef.io)
and [openstack](http://openstack.org).

This build is also [test-kitchened](http://kitchen.ci) with a good coverage of [serverspec](http://serverspec.org/)
tests. I strongly suggest you get the latest [chef-dk](https://downloads.chef.io/chef-dk/)
and leverage it as your build platform.

If you would like to build it out via test-kitchen, you can run the following:

```bash
git clone https://github.com/chef-partners/openstack-model-t.git
cd openstack-model-t
chef exec kitchen verify
```

After the build is completed, and the serverspec is ran, you should do the following:

```bash
chef exec kitchen login
sudo su -
bash build_neutron_networks.sh
```

The `build_neutron_networks.sh` script builds out an external network and internal
tenant network for a user account of `demo`. You can override the options via override
attributes if you would like to do this on real hardware.

After the `build_neutron_networks.sh` is built out, you can go to https://127.0.0.1:8443/horizon
and log in as `demo`/`mypass` and you should be able to spin up a CirrOS image.

**NOTE**: The networking can be funky virtual space, it's a hit and miss for pinging
out. You will be able to spin up the CirrOS image, console in via horizon, but
actually sshing out may fail. If you like what you see I strongly suggest building
this on physical hardware per the reference architecture below.

## Attributes

### Moving to hardware and want acceleration?

Test via:

`egrep -c '(vmx|svm)' /proc/cpuinfo`

If it comes back anything other than zero, you should override this attribute to `kvm`.

`default[:openstack_model_t][:hardware_acceleration] = 'qemu'`

**WARNING**:

Admin token for keystone this is insecure, you probably should remove this after deployment for security reasons, disable the temporary authentication token mechanism: edit the `/etc/keystone/keystone-paste.ini` file and remove admin_token_auth from the `[pipeline:public_api]`, `[pipeline:admin_api]`, and `[pipeline:api_v3]` sections. Unset the temporary `OS_TOKEN` and `OS_URL` environment variables: `default[:openstack_model_t][:admin_token] = 'b14feea8128a0a1bbd60'`

### Networking

![minimal-arch-example](http://docs.openstack.org/kilo/install-guide/install/apt/content/figures/1/a/common/figures/installguidearch-neutron-networks.png)

An IP on the management network, the RED boxes.

`default[:openstack_model_t][:controller_ip] = '127.0.0.1'`

OVS needs a tunnel interface to talk to the other guys, the YELLOW?/BROWN? boxes.

`default[:openstack_model_t][:instance_tunnel_ip] = '127.0.0.1'`

OVS needs an external nic that doesn't have an IP, the TEAL box.

`default[:openstack_model_t][:network_node_external_bridge] = 'eth2'`

Replace METADATA_SECRET with a suitable secret for the metadata proxy.

`default[:openstack_model_t][:METADATA_SECRET] = '7874fa60615f3f86ac1a'`

OVS compute nodes have: INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS, which is the BROWN box on Compute Node(s)

`default[:openstack_model_t][:INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS] = 'eth2'`

## Recipes

`default` : all in one recipe. Has the complete stack for a compute OpenStack cloud.

`compute_node` : only installs the required portions for creating a compute node to extend out an all in one build.
