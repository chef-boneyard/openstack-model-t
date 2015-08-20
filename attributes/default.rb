

# The release you want to build your OpenStack cloud
default[:openstack_model_t][:release] = 'kilo'

# How you want to get your code. Options: source or packages
default[:openstack_model_t][:code] = 'packages'

# Default to turning off Ubuntu thememing for the dashboard
default[:openstack_model_t][:ubuntu_themeing] = false

# ServerName for the controller
default[:openstack_model_t][:controller_servername] = 'controller'

# Want hardware acceleration? change from qemu to kvm
default[:openstack_model_t][:hardware_acceleration] = 'qemu'

# Installation path
default[:openstack_model_t][:default_install_location] = '/opt/model-t'

# Lets pull trunk because #YOLO
tag = 'master'

# Git repositories
default[:openstack_model_t][:git_keystone] = 'https://git.openstack.org/openstack/keystone.git'
default[:openstack_model_t][:git_keystone_tag] = tag

# You'll want to set up a location for lvm
# You should probably read:
# http://docs.openstack.org/kilo/install-guide/install/apt/content/cinder-install-storage-node.html
default[:openstack_model_t][:lvm_device] = 'sdb'
default[:openstack_model_t][:lvm_physical_volume] = '/dev/sdb1'

# You should look at:
# http://docs.openstack.org/kilo/install-guide/install/apt/content/figures/1/a/common/figures/installguidearch-neutron-networks.png

# An IP on the management network, the RED boxes.
default[:openstack_model_t][:controller_ip] = '127.0.0.1'

# OVS needs a tunnel interface to talk to the other guys, the BROWN boxes.
default[:openstack_model_t][:instance_tunnel_ip] = '127.0.0.1'

# OVS needs an external nic that doesn't have an IP, the TEAL box.
default[:openstack_model_t][:network_node_external_bridge] = 'eth2'

# OVS compute nodes have: INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS, which is the BROWN box on Compute Node(s)
default[:openstack_model_t][:INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS] = 'eth1'

# Neutron external network options
default[:openstack_model_t][:EXTERNAL_SUBNET] = '10.0.1.0/24'
default[:openstack_model_t][:EXTERNAL_STARTING_IP] = '10.0.1.200'
default[:openstack_model_t][:EXTERNAL_ENDING_IP] = '10.0.1.250'
default[:openstack_model_t][:EXTERNAL_GATEWAY_IP] = '10.0.1.1'

# Neutron demo network options
default[:openstack_model_t][:DEMO_EXTERNAL_SUBNET] = '192.168.1.0/24'
default[:openstack_model_t][:DEMO_GATEWAY_IP] = '192.168.1.1'


# A generic password for everything
imlazy = 'mypass'

# Main OpenStack Passwords

# Password of user admin
default[:openstack_model_t][:ADMIN_PASS] = imlazy
# Database password for the Telemetry service
default[:openstack_model_t][:CEILOMETER_DBPASS] = imlazy
# Password of Telemetry service user ceilometer
default[:openstack_model_t][:CEILOMETER_PASS] = imlazy
# Database password for the Block Storage service
default[:openstack_model_t][:CINDER_DBPASS] = imlazy
# Password of Block Storage service user cinder
default[:openstack_model_t][:CINDER_PASS] = imlazy
# Database password for the dashboard
default[:openstack_model_t][:DASH_DBPASS] = imlazy
# Password of user demo
default[:openstack_model_t][:DEMO_PASS] = imlazy
# Database password for Image service
default[:openstack_model_t][:GLANCE_DBPASS] = imlazy
# Password of Image service user glance
default[:openstack_model_t][:GLANCE_PASS] = imlazy
# Database password for the Orchestration service
default[:openstack_model_t][:HEAT_DBPASS] = imlazy
# Password of Orchestration domain
default[:openstack_model_t][:HEAT_DOMAIN_PASS] = imlazy
# Password of Orchestration service user heat
default[:openstack_model_t][:HEAT_PASS] = imlazy
# Database password of Identity service
default[:openstack_model_t][:KEYSTONE_DBPASS] = imlazy
# Database password for the Networking service
default[:openstack_model_t][:NEUTRON_DBPASS] = imlazy
# Password of Networking service user neutron
default[:openstack_model_t][:NEUTRON_PASS] = imlazy
# Database password for Compute service
default[:openstack_model_t][:NOVA_DBPASS] = imlazy
# Password of Compute service user nova
default[:openstack_model_t][:NOVA_PASS] = imlazy
# Password of user guest of RabbitMQ
default[:openstack_model_t][:RABBIT_PASS] = imlazy
# Database password of Data processing service
default[:openstack_model_t][:SAHARA_DBPASS] = imlazy
# Password of Object Storage service user swift
default[:openstack_model_t][:SWIFT_PASS] = imlazy
# Database password of Database service
default[:openstack_model_t][:TROVE_DBPASS] = imlazy
# Password of Database service user trove
default[:openstack_model_t][:TROVE_PASS] = imlazy

# Other passwords

# Password for MariaDB
default[:openstack_model_t][:mariadb_pass] = imlazy

# Admin token for keystone this is insecure, you probably should remove this after deployment
# For security reasons, disable the temporary authentication token mechanism:
# Edit the /etc/keystone/keystone-paste.ini file and remove admin_token_auth from the [pipeline:public_api], [pipeline:admin_api], and [pipeline:api_v3] sections.
# Unset the temporary OS_TOKEN and OS_URL environment variables:
default[:openstack_model_t][:admin_token] = 'b14feea8128a0a1bbd60'

# Replace METADATA_SECRET with a suitable secret for the metadata proxy.
default[:openstack_model_t][:METADATA_SECRET] = '7874fa60615f3f86ac1a'
