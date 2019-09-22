# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::puppetmaster
class profile::puppetmaster (
  Boolean $manage_puppetdb = pick($facts['manage_puppetdb'], false),
) {
  class { 'puppetserver::repository': }
    -> class { 'puppetserver': }

  class { 'hiera':
    hiera_version   =>  '5',
    eyaml           => true,
    eyaml_extension => '.yaml',
    provider        => 'puppetserver_gem',
    manage_package  => true,
    hiera5_defaults =>  {'datadir' => 'code/data', 'data_hash' => 'yaml_data'},
    hierarchy       =>  [
                          {'name' =>  'Nodes yaml', 'paths' =>  ['nodes/%{::trusted.certname}.yaml', 'role/%{::facts.role}.yaml']},
                          {'name' =>  'Default yaml file', 'path' =>  'common.yaml'},
                        ],
  }

  if $manage_puppetdb {
    # Configure puppetdb and its underlying database
    class { 'puppetdb': }
    # Configure the Puppet master to use puppetdb
    class { 'puppetdb::master::config': }
  }

  file { '/etc/puppetlabs/facter/facts.d/puppetdb.yaml': 
    ensure => file,
    content => 'manage_puppetdb: true',
  }

}
