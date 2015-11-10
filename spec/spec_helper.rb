require 'chefspec'
require 'chefspec/berkshelf'
require 'fauxhai'

LOG_LEVEL = :fatal

UBUNTU_OPTS = {
  :platform => 'ubuntu',
  :version => '14.04',
  :log_level => LOG_LEVEL,
  :file_cache_path => '/tmp'
}

at_exit { ChefSpec::Coverage.report! }
