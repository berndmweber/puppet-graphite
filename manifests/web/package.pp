# == Class: graphite::web::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'graphite::web::package': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class graphite::web::package {

  #### Package management

  # set params: in operation
  if $graphite::ensure == 'present' {

    # Check if we want to install a specific version or not
    if $graphite::version == false {

      $package_ensure = $graphite::autoupgrade ? {
        true  => 'latest',
        false => 'present',
      }

    } else {

      # install specific version
      $package_ensure = $graphite::version

    }

  # set params: removal
  } else {
    $package_ensure = 'purged'
  }

  # action
  package { $graphite::params::package_web:
    ensure   => $package_ensure,
    provider => $graphite::params::pkg_provider,
  }

  if $graphite::params::pkg_provider == 'pip' {
    file { '/usr/lib/python2.7/dist-packages/graphite_web-0.9.10-py2.7.egg-info' :
      ensure => link,
      target => '/opt/graphite/webapp/graphite_web-0.9.10-py2.7.egg-info',
      require => Package [ $graphite::params::package_web ],
    }
  }
}
