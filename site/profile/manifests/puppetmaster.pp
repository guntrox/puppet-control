# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::puppetmaster
class profile::puppetmaster {
  class { 'puppetserver::repository': }
    -> class { 'puppetserver': }
}
