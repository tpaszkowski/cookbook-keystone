# Set to some text value if you want templated config files
# to contain a custom banner at the top of the written file
default["keystone"]["custom_template_banner"] = "
# This file autogenerated by Chef
# Do not edit, changes will be overwritten
"

# Adding these as blank
# this needs to be here for the initial deep-merge to work
default["credentials"]["EC2"]["admin"]["access"] = ""
default["credentials"]["EC2"]["admin"]["secret"] = ""

default["keystone"]["db"]["username"] = "keystone"

default["keystone"]["verbose"] = "False"
default["keystone"]["debug"] = "False"

default["keystone"]["service_port"] = "5000"
default["keystone"]["admin_port"] = "35357"
default["keystone"]["region"] = "RegionOne"
default["keystone"]["public_endpoint"] = "http://127.0.0.1:$public_port/"
default["keystone"]["admin_endpoint"] = "http://127.0.0.1:$admin_port/"

default["keystone"]["bind_interface"] = "lo"

# Logging stuff
default["keystone"]["syslog"]["use"] = false
default["keystone"]["syslog"]["facility"] = "LOG_LOCAL2"
default["keystone"]["syslog"]["config_facility"] = "local2"

# default["keystone"]["roles"] = [ "admin", "Member", "KeystoneAdmin", "KeystoneServiceAdmin", "sysadmin", "netadmin" ]
default["keystone"]["roles"] = [ "admin", "Member", "KeystoneAdmin", "KeystoneServiceAdmin" ]

#TODO(shep): this should probably be derived from keystone.users hash keys
default["keystone"]["tenants"] = [ "admin", "service"]

default["keystone"]["admin_user"] = "admin"
default["keystone"]["admin_tenant_name"] = "admin"

default["keystone"]["users"] = {
    default["keystone"]["admin_user"]  => {
        "default_tenant" => default["keystone"]["admin_tenant_name"],
        "roles" => {
            "admin" => [ "admin" ],
            "KeystoneAdmin" => [ "admin" ],
            "KeystoneServiceAdmin" => [ "admin" ]
        }
    },
    "monitoring" => {
        "password" => "",
        "default_tenant" => "service",
        "roles" => {
            "Member" => [ "admin" ]
        }
    }
}

# PKI signing. Corresponds to the [signing] section of keystone.conf
# Note this section is only written if node["openstack"]["auth"]["straegy"] == "pki"
default["keystone"]["signing"]["basedir"] = "/etc/keystone/ssl"
default["keystone"]["signing"]["certfile"] = "/etc/keystone/ssl/certs/signing_cert.pem"
default["keystone"]["signing"]["keyfile"] = "/etc/keystone/ssl/private/signing_key.pem"
default["keystone"]["signing"]["ca_certs"] = "/etc/keystone/ssl/certs/ca.pem"
default["keystone"]["signing"]["key_size"] = "1024"
default["keystone"]["signing"]["valid_days"] = "3650"
default["keystone"]["signing"]["ca_password"] = nil

# platform defaults
case platform
when "fedora", "redhat", "centos" # :pragma-foodcritic: ~FC024 - won't fix this
  default['keystone']['user'] = "keystone"
  default['keystone']['group'] = "keystone"
  default["keystone"]["platform"] = {
    "mysql_python_packages" => [ "MySQL-python" ],
    "keystone_packages" => [ "openstack-keystone" ],
    "keystone_service" => "openstack-keystone",
    "keystone_process_name" => "keystone-all",
    "package_options" => ""
  }
when "suse"
  default['keystone']['user'] = "openstack-keystone"
  default['keystone']['group'] = "openstack-keystone"
  default["keystone"]["platform"] = {
    "mysql_python_packages" => [ "python-mysql" ],
    "keystone_packages" => [ "openstack-keystone" ],
    "keystone_service" => "openstack-keystone",
    "keystone_process_name" => "keystone-all",
    "package_options" => ""
  }
when "ubuntu"
  default['keystone']['user'] = "keystone"
  default['keystone']['group'] = "keystone"
  default["keystone"]["platform"] = {
    "mysql_python_packages" => [ "python-mysqldb" ],
    "keystone_packages" => [ "keystone" ],
    "keystone_service" => "keystone",
    "keystone_process_name" => "keystone-all",
    "package_options" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'"
  }
end
