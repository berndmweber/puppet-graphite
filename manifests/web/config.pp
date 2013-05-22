# == Class: graphite::web::config
#
# This class exists to coordinate all configuration related actions,
# functionality and logical units in a central place.
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
#   class { 'graphite::carbon::config': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class graphite::web::config {

  #### Configuration

  file { '/etc/graphite-web':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644'
  }

  file { '/etc/graphite-web/local_settings.py':
    ensure  => present,
    source  => $graphite::web::local_settings_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/carbon']
  }
  file { '/opt/graphite/webapp/graphite/local_settings.py' :
    ensure => link,
    target => '/etc/graphite-web/local_settings.py',
    require => File [ '/etc/graphite-web/local_settings.py' ],
  }

  file { '/etc/graphite-web/dashboard.conf':
    ensure  => present,
    source  => $graphite::web::dashboard_config_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/carbon']
  }
  file { '/etc/apache2/sites-available/graphite.conf' :
    ensure => file,
    source => 'puppet:///modules/graphite/etc/apache2/sites-available/graphite.conf',
  }
  file { '/etc/apache2/sites-enabled/graphite.conf' :
    ensure  => link,
    target  => '/etc/apache2/sites-available/graphite.conf',
    require => File [ '/etc/apache2/sites-available/graphite.conf' ],
  }
  file { '/opt/graphite/conf/graphite.wsgi' :
    ensure => file,
    source => '/opt/graphite/conf/graphite.wsgi.example',
  }
  file { '/opt/graphite/storage/whisper/stats' :
    ensure  => directory,
    owner   => 'carbon',
    group   => 'www-data',
    require => Class [ 'graphite::web::package' ]
  }
}
