# Base Loadbalancer
exec { 'apt-update':
    command => '/usr/bin/apt-get update',
}

# install proxy
class {'nginx':
    webnode_ips => "${::webnode_ips}",
    require => Exec['apt-update'],
}

package { 'curl': 
    ensure => installed,
    require => Class['nginx']
}
