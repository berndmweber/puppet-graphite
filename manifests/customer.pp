class graphite::customer {
  mysqld::db::create { 'graphite' :
    user     => 'graphite',
    password => 'abcdefghijklmn1234567',
  }
  class { 'graphite' :
    #carbon_cache_enable => true,
    require => Mysqld::Db::Create [ 'graphite' ],
  }
}
