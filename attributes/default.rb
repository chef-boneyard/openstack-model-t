

# The release you want to build your OpenStack cloud
default[:openstack_model_t][:release] = 'kilo'

# ServerName for the controller
default[:openstack_model_t][:controller_servername] = 'controller'

# Want hardware acceleration? change from qemu to kvm
default[:openstack_model_t][:hardware_acceleration] = 'qemu'

# You should look at:
# http://docs.openstack.org/kilo/install-guide/install/apt/content/figures/1/a/common/figures/installguidearch-neutron-networks.png

# An IP on the management network, the RED boxes.
default[:openstack_model_t][:management_network_ip] = '127.0.0.1'

# OVS needs a tunnel interface to talk to the other guys, the YELLOW?/BROWN? boxes.
default[:openstack_model_t][:instance_tunnel_ip] = '127.0.0.1'

# OVS needs an external nic that doesn't have an IP, the TEAL box.
default[:openstack_model_t][:network_node_external_bridge] = 'eth2'

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
